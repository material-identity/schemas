package com.materialidentity.schemaservice;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.materialidentity.schemaservice.config.SchemasAndVersions;
import com.materialidentity.schemaservice.resource.ResourceLoader;
import org.springframework.core.io.Resource;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Core PDF generation service extracted from SchemasServiceImpl.
 * This class contains the essential PDF rendering logic without Spring dependencies.
 */
public class CorePdfService {
    
    private static final ObjectMapper objectMapper = new ObjectMapper();
    private static final Pattern SCHEMA_TYPE_PATTERN = Pattern.compile(".*/([^/]+)/v[\\d.]+/schema\\.json$");
    private static final Pattern VERSION_PATTERN = Pattern.compile("(v\\d+\\.\\d+\\.\\d+)");
    
    private final ResourceLoader resourceLoader;
    
    public CorePdfService(ResourceLoader resourceLoader) {
        this.resourceLoader = resourceLoader;
    }
    
    /**
     * Render a certificate to PDF bytes
     * @param certificateJson JSON certificate content
     * @param attachJson whether to attach the JSON to the PDF
     * @param filename optional filename for the JSON attachment
     * @return PDF bytes
     */
    public byte[] renderCertificate(String certificateJson, boolean attachJson, String filename) 
            throws Exception {
        
        JsonNode certificate = objectMapper.readTree(certificateJson);
        
        // Extract metadata from certificate
        String[] languages = extractLanguages(certificate);
        String[] encodedData = extractPdfData(certificate);
        String[] dataFromS3 = extractPdfDataFromS3(certificate);
        String schemaType = extractCertificateType(certificate);
        String schemaVersion = extractCertificateVersion(certificate);
        
        // Validate schema type and version
        validateSchemaTypeAndVersion(schemaType, schemaVersion);
        
        // Build paths to resources
        String translationsPattern = Paths
                .get("schemas", schemaType, schemaVersion, "translations*.json")
                .toString();
        
        String xsltPath = Paths
                .get("schemas", schemaType, schemaVersion, "stylesheet.xsl")
                .toString();
        
        // Load XSLT stylesheet
        String xsltSource;
        try (var xsltStream = resourceLoader.getResource(xsltPath)) {
            xsltSource = new String(xsltStream.readAllBytes());
        }
        
        // Build PDF using the extracted components
        StandalonePDFBuilder pdfBuilder = new StandalonePDFBuilder()
                .withXsltTransformer(new XsltTransformer(xsltSource, certificate))
                .withTranslations(new StandaloneTranslationLoader(resourceLoader, translationsPattern, languages))
                .withAttachment(new AttachmentManager(certificateJson, filename != null ? filename : "certificate.json", attachJson))
                .withFoManager(new StandaloneFoManager(resourceLoader));
        
        // Add embedded PDFs if present
        if (encodedData != null || dataFromS3 != null) {
            pdfBuilder.withEmbeddedPdf(new EmbedManager(encodedData, dataFromS3));
        }
        
        return pdfBuilder.build();
    }
    
    private String[] extractLanguages(JsonNode certificate) {
        JsonNode languagesNode = certificate.path("Certificate").path("CertificateLanguages");
        if (languagesNode.isMissingNode()) {
            languagesNode = certificate.path("DigitalMaterialPassport").path("Languages");
        }
        
        if (languagesNode.isMissingNode() || !languagesNode.isArray()) {
            return new String[]{"EN"}; // Default language
        }
        
        String[] languages = new String[languagesNode.size()];
        for (int i = 0; i < languagesNode.size(); i++) {
            languages[i] = languagesNode.get(i).asText();
        }
        return languages;
    }
    
    private String[] extractPdfData(JsonNode certificate) {
        // Extract base64 PDF data from attachments
        JsonNode attachments = certificate.path("Certificate").path("Attachments");
        if (attachments.isMissingNode() || !attachments.isArray()) {
            return null;
        }
        
        return new String[0]; // Simplified for now
    }
    
    private String[] extractPdfDataFromS3(JsonNode certificate) {
        // Extract S3 URLs from documents
        JsonNode documents = certificate.path("DigitalMaterialPassport").path("Documents");
        if (documents.isMissingNode() || !documents.isArray()) {
            return null;
        }
        
        return new String[0]; // Simplified for now
    }
    
    private String extractCertificateType(JsonNode certificate) {
        JsonNode refSchemaUrl = certificate.path("RefSchemaUrl");
        if (refSchemaUrl.isMissingNode()) {
            throw new IllegalArgumentException("RefSchemaUrl not found in certificate");
        }
        
        String url = refSchemaUrl.asText();
        
        // Handle different URL patterns
        if (url.contains("en10168-schemas")) {
            return "EN10168";
        } else if (url.contains("coa-schemas")) {
            return "CoA";
        } else if (url.contains("forestry-schemas")) {
            return "Forestry";
        } else if (url.contains("forestrysource-schemas")) {
            return "ForestrySource";
        } else if (url.contains("metals-schemas")) {
            return "Metals";
        } else if (url.contains("tkr-schemas")) {
            return "TKR";
        } else if (url.contains("bluemint-schemas")) {
            return "Bluemint";
        } else {
            // Fallback to regex pattern
            Matcher matcher = SCHEMA_TYPE_PATTERN.matcher(url);
            if (!matcher.find()) {
                throw new IllegalArgumentException("Cannot extract schema type from RefSchemaUrl: " + url);
            }
            
            String schemaType = matcher.group(1);
            
            // Map schema names to internal format
            return switch (schemaType.toLowerCase()) {
                case "coa" -> "CoA";
                case "en10168" -> "EN10168";
                case "forestry" -> "Forestry";
                case "forestrysource" -> "ForestrySource";
                case "metals" -> "Metals";
                case "tkr" -> "TKR";
                case "bluemint" -> "Bluemint";
                default -> schemaType;
            };
        }
    }
    
    private String extractCertificateVersion(JsonNode certificate) {
        JsonNode refSchemaUrl = certificate.path("RefSchemaUrl");
        if (refSchemaUrl.isMissingNode()) {
            throw new IllegalArgumentException("RefSchemaUrl not found in certificate");
        }
        
        String url = refSchemaUrl.asText();
        Matcher matcher = VERSION_PATTERN.matcher(url);
        if (!matcher.find()) {
            throw new IllegalArgumentException("Cannot extract version from RefSchemaUrl: " + url);
        }
        
        return matcher.group(1);
    }
    
    private void validateSchemaTypeAndVersion(String schemaType, String schemaVersion) {
        // Simple validation - check if schema files exist
        String schemaPath = Paths.get("schemas", schemaType, schemaVersion, "schema.json").toString();
        if (!resourceLoader.exists(schemaPath)) {
            throw new IllegalArgumentException("Schema not found: " + schemaType + " " + schemaVersion);
        }
    }
}