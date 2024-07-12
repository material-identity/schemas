package com.materialidentity.schemaservice.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.materialidentity.schemaservice.AttachmentManager;
import com.materialidentity.schemaservice.PDFBuilder;
import com.materialidentity.schemaservice.TranslationLoader;
import com.materialidentity.schemaservice.XsltTransformer;
import com.materialidentity.schemaservice.config.SchemaControllerConstants;
import com.materialidentity.schemaservice.config.SchemasAndVersions;
import com.networknt.schema.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.xml.sax.SAXException;

import javax.xml.transform.TransformerException;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Service
public class SchemasServiceImpl implements SchemasService {

    private static final Logger logger = LoggerFactory.getLogger(SchemasServiceImpl.class);
    private static final Pattern schemaPattern = Pattern.compile(".*/([^/]+)/v[\\d.]+/schema\\.json$");
    private static final Pattern versionPattern = Pattern.compile("(v\\d+\\.\\d+\\.\\d+)");
    private static final Map<String, String> certificateTypeMap = new HashMap<>();

    static {
        certificateTypeMap.put("coa", "CoA");
        certificateTypeMap.put("en10168", "EN10168");
        certificateTypeMap.put("tkr", "TKR");
    }

    public static String[] extractLanguages(JsonNode jsonContent) {
        return Optional.ofNullable(jsonContent.path("Certificate").path("CertificateLanguages"))
                .filter(JsonNode::isArray)
                .map(languagesNode -> {
                    List<String> languages = new ArrayList<>();
                    languagesNode.forEach(node -> languages.add(node.asText()));
                    return languages.toArray(new String[0]);
                })
                .orElseThrow(() -> new IllegalArgumentException(
                        "No languages found in the certificate"));
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

        byte[] pdfBytes = new PDFBuilder()
                .withXsltTransformer(new XsltTransformer(xsltSource, certificate))
                .withTranslations(new TranslationLoader(translationsPattern, languages))
                .withAttachment(
                        new AttachmentManager(certificateJson,
                                SchemaControllerConstants.PDF_ATTACHMENT_CERT_FILE_NAME,
                                attachJson))
                .build();

        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION,
                        String.format("filename=\"%s\"",
                                SchemaControllerConstants.PDF_RENDERED_OUTPUT_FILE_NAME))
                .contentType(MediaType.APPLICATION_PDF)
                .body(pdfBytes);
    }

    @Override
    public ResponseEntity<Map<String, Object>> validate(String schemaType, String schemaVersion,
                                                        JsonNode jsonCertificate) throws IOException {
        logger.info("Validating certificate type: {}, version: {}", schemaType, schemaVersion);
        String certificateString = jsonToString(jsonCertificate);

        // build schema validator with schema definition
        JsonSchemaFactory schemaFactory = JsonSchemaFactory.getInstance(SpecVersion.VersionFlag.V202012);

        String schemaDefinitionPath = Paths
                .get(SchemaControllerConstants.SCHEMAS_FOLDER_NAME, schemaType, schemaVersion,
                        SchemaControllerConstants.SCHEMA_DEFINITION_FILE_NAME)
                .toString();

        String schemaDefinition = readResourceAsString(schemaDefinitionPath);

        JsonSchema schema = schemaFactory.getSchema(schemaDefinition);

        Set<ValidationMessage> validationResult = schema.validate(certificateString, InputFormat.JSON,
                executionContext -> executionContext.getExecutionConfig()
                        .setFormatAssertionsEnabled(true));

        Boolean isValid = validationResult.isEmpty();

        if (!isValid)
            for (ValidationMessage result : validationResult) {
                System.out.println(result.getMessage());
            }

        Map<String, Object> response = new HashMap<>();
        response.put("success", isValid);

        return ResponseEntity.ok()
                .contentType(MediaType.APPLICATION_JSON)
                .body(response);
    }

    @Override
    public ResponseEntity<Map<String, Object>> getSchemas() throws IOException {
        logger.info("Getting schemas");

        Map<String, Object> response = new HashMap<>();
        PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();

        // get 1st level resource tree from directory storing schema types
        Resource[] resources = resolver
                .getResources(
                        String.format("classpath:%s",
                                SchemaControllerConstants.SCHEMA_TYPES_FOLDER_NAME_PATTERN));

        for (Resource resource : resources) {
            if (resource.getFile().isDirectory()) {
                String schemaName = resource.getFilename();
                List<String> versions = getVersionsForResource(resolver, schemaName);
                response.put(schemaName, Collections.singletonMap("versions: ", versions));
            }
        }
        // for (Resource resource : resources) {
        // if (resource.isReadable()) { // Check if the resource is readable
        // String schemaName = resource.getFilename();
        // List<String> versions = getVersionsForResource(resolver, schemaName);
        // response.put(schemaName, Collections.singletonMap("versions: ", versions));
        // }
        // }

        // HttpHeaders headers = new HttpHeaders();
        // headers.setContentType(MediaType.APPLICATION_JSON);

        return ResponseEntity.ok()
                .contentType(MediaType.APPLICATION_JSON)
                .body(response);
    }

    /**
     * Retrieves a list of version directories for a given schema name from the
     * classpath.
     * This method searches within the 'schemas' directory, specifically in the
     * subdirectory
     * corresponding to the provided schema name, to find all subdirectories which
     * represent
     * different versions of the schema.
     *
     * @param resolver   The {@link PathMatchingResourcePatternResolver} used to
     *                   find resources
     *                   on the classpath.
     * @param schemaName The name of the schema for which versions are to be
     *                   retrieved. This
     *                   should correspond to a subdirectory under the 'schemas'
     *                   directory.
     * @return A list of strings, where each string is the name of a subdirectory
     * that represents
     * a version of the schema. The list will be empty if no versions are
     * found or if the
     * specified schemaName does not exist.
     * @throws IOException If an I/O error occurs when accessing the file system.
     */
    private List<String> getVersionsForResource(PathMatchingResourcePatternResolver resolver, String schemaName)
            throws IOException {
        List<String> versions = new ArrayList<>();
        Resource[] versionResources = resolver.getResources("classpath:schemas/" + schemaName + "/*");

        for (Resource versionResource : versionResources) {
            if (versionResource.getFile().isDirectory()) {
                versions.add(versionResource.getFilename());
            }
        }

        return versions;
    }

    /**
     * Reads the contents of a resource located at the specified path in the
     * classpath and returns it as a String.
     * This method assumes that the resource content is encoded using UTF-8.
     *
     * @param resourcePath The path to the resource within the classpath. The path
     *                     should not start with a slash (/),
     *                     as "classpath:" is already prefixed when resolving the
     *                     resource.
     * @return A string containing the contents of the resource, decoded using UTF-8
     * encoding.
     * @throws IOException If an error occurs during I/O operations, such as if the
     *                     resource does not exist
     *                     or an error occurs while reading the resource.
     */
    private String readResourceAsString(String resourcePath) throws IOException {
        PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
        Resource resource = resolver.getResource("classpath:" + resourcePath);
        try (InputStream inputStream = resource.getInputStream()) {
            byte[] bytes = inputStream.readAllBytes();
            return new String(bytes, StandardCharsets.UTF_8);
        }
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
