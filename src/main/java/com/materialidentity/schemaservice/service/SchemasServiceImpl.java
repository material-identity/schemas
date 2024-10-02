package com.materialidentity.schemaservice.service;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.EnumSet;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.xml.transform.TransformerException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.xml.sax.SAXException;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.materialidentity.schemaservice.AttachmentManager;
import com.materialidentity.schemaservice.EmbedManager;
import com.materialidentity.schemaservice.PDFBuilder;
import com.materialidentity.schemaservice.TranslationLoader;
import com.materialidentity.schemaservice.XsltTransformer;
import com.materialidentity.schemaservice.config.SchemaControllerConstants;
import com.materialidentity.schemaservice.config.SchemasAndVersions;

@Service
public class SchemasServiceImpl implements SchemasService {

    private static final Logger logger = LoggerFactory.getLogger(SchemasServiceImpl.class.getName());
    private static final Pattern schemaPattern = Pattern.compile(".*/([^/]+)/v[\\d.]+/schema\\.json$");
    private static final Pattern versionPattern = Pattern.compile("(v\\d+\\.\\d+\\.\\d+)");
    private static final Map<String, String> certificateTypeMap = new HashMap<>();

    static {
        certificateTypeMap.put("coa", "CoA");
        certificateTypeMap.put("en10168", "EN10168");
        certificateTypeMap.put("tkr", "TKR");
    }

    public static String[] extractLanguages(JsonNode jsonContent) {
        String[] languages = Optional.ofNullable(jsonContent.path("Certificate").path("CertificateLanguages"))
                .filter(JsonNode::isArray)
                .map(languagesNode -> {
                    List<String> languageList = new ArrayList<>();
                    languagesNode.forEach(node -> languageList.add(node.asText()));
                    return languageList.toArray(new String[0]);
                })
                .orElseThrow(() -> new IllegalArgumentException("No languages property found in the certificate"));

        if (languages.length == 0) {
            throw new IllegalArgumentException("CertificateLanguages array is empty");
        }

        return languages;
    }

    public static String extractPdfData(JsonNode jsonContent) {
        JsonNode firstAttachment = jsonContent.path("Certificate").path("Attachments").get(0);
    
        String pdfData = firstAttachment != null ? firstAttachment.path("Data").asText(null) : null;
    
        if (pdfData != null && pdfData.startsWith("data:image/pdf;base64")) {
            return pdfData;
        }
    
        return null;
    }
    

    public static String extractCertificateType(JsonNode jsonContent) {
        String refSchemaUrl = jsonContent.path("RefSchemaUrl").asText();
        Matcher matcher = schemaPattern.matcher(refSchemaUrl);

        if (matcher.find()) {
            // Extract the certificate type and remove "-schemas" from the result
            String certificateType = matcher.group(1).replace("-schemas", "");
            if (!certificateTypeMap.containsKey(certificateType)) {
                throw new IllegalArgumentException(
                        "Certificate type '" + certificateType + "' is not supported.");
            }
            return certificateTypeMap.get(certificateType);
        }
        throw new IllegalArgumentException("Unsupported certificate type in RefSchemaUrl");
    }

    public static String extractCertificateVersion(JsonNode jsonContent) {
        String refSchemaUrl = jsonContent.path("RefSchemaUrl").asText();
        Matcher matcher = versionPattern.matcher(refSchemaUrl);

        if (matcher.find()) {
            // Return the version number
            return matcher.group(1);
        }
        throw new IllegalArgumentException("Unsupported certificate version in RefSchemaUrl");
    }

    public static String jsonToString(JsonNode jsonMap)
            throws JsonProcessingException {
        ObjectMapper objectMapper = new ObjectMapper();
        return objectMapper.writeValueAsString(jsonMap);
    }

    @Override
    public ResponseEntity<byte[]> renderPdf(Boolean attachJson, JsonNode certificate)
            throws IOException, TransformerException, SAXException {
        String[] languages = extractLanguages(certificate);
        String encodedData = extractPdfData(certificate);
        String schemaType = extractCertificateType(certificate);
        String schemaVersion = extractCertificateVersion(certificate);
        logger.info("Rendering certificate type: {}, version: {}, languages: {}, attachJson: {}", schemaType,
                schemaVersion, languages, attachJson);

        // TODO: throw error if language is not supported
        validateSchemaTypeAndVersion(schemaType, schemaVersion);

        String translationsPattern = Paths
                .get("schemas", schemaType, schemaVersion,
                        SchemaControllerConstants.JSON_TRANSLATIONS_FILE_NAME_PATTERN)
                .toString();

        String certificateJson = jsonToString(certificate);

        String xsltPath = Paths
                .get("schemas", schemaType, schemaVersion, SchemaControllerConstants.XSLT_FILE_NAME)
                .toString();

        Resource xsltResource = new ClassPathResource(xsltPath);
        String xsltSource = new String(
                Files.readAllBytes(Paths.get(xsltResource.getURI())));

        PDFBuilder pdfBuilder = new PDFBuilder()
                .withXsltTransformer(new XsltTransformer(xsltSource, certificate))
                .withTranslations(new TranslationLoader(translationsPattern, languages))
                .withAttachment(
                        new AttachmentManager(certificateJson,
                                SchemaControllerConstants.PDF_ATTACHMENT_CERT_FILE_NAME,
                                attachJson));

        if (encodedData != null) {
            pdfBuilder.withEmbeddedPdf(new EmbedManager(encodedData));
        }

        byte[] pdfBytes = pdfBuilder.build();

        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION,
                        String.format("filename=\"%s\"",
                                SchemaControllerConstants.PDF_RENDERED_OUTPUT_FILE_NAME))
                .contentType(MediaType.APPLICATION_PDF)
                .body(pdfBytes);
    }

    public void validateSchemaTypeAndVersion(String schemaType, String version) {
        // Check if schemaType is valid
        if (!EnumSet.allOf(SchemasAndVersions.SchemaTypes.class)
                .contains(SchemasAndVersions.SchemaTypes.valueOf(schemaType))) {
            throw new IllegalArgumentException("Invalid schemaType: " + schemaType);
        }

        // Retrieve the list of versions for the schemaType
        List<String> versions = SchemasAndVersions.supportedSchemas
                .get(SchemasAndVersions.SchemaTypes.valueOf(schemaType));
        // Check if the provided version is in the list for the schemaType
        if (!versions.contains(version)) {
            throw new IllegalArgumentException(
                    "Invalid version: " + version + " for schemaType: " + schemaType);
        }
    }
}
