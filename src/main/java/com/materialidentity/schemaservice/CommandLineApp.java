package com.materialidentity.schemaservice;

import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URISyntaxException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.xml.transform.TransformerException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.xml.sax.SAXException;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.materialidentity.schemaservice.config.SchemaControllerConstants;

/**
 * Standalone command-line application for converting JSON certificates to PDF
 * without requiring a running web service.
 */
public class CommandLineApp {

    private static final Logger logger = LoggerFactory.getLogger(CommandLineApp.class);
    private static final Pattern schemaPattern = Pattern.compile(".*/([^/]+)/v[\\d.]+/schema\\.json$");
    private static final Pattern versionPattern = Pattern.compile("(v\\d+\\.\\d+\\.\\d+)");
    private static final Map<String, String> certificateTypeMap = new HashMap<>();

    static {
        certificateTypeMap.put("coa", "CoA");
        certificateTypeMap.put("en10168", "EN10168");
        certificateTypeMap.put("metals", "Metals");
        certificateTypeMap.put("forestry", "Forestry");
        certificateTypeMap.put("forestry-source", "ForestrySource");
        certificateTypeMap.put("e-coc", "E-CoC");
    }

    public static void main(String[] args) {
        if (args.length < 1) {
            showUsage();
            System.exit(1);
        }

        String inputFile = null;
        String outputFile = null;
        String xsltPath = null;

        // Parse command line arguments
        for (int i = 0; i < args.length; i++) {
            String arg = args[i];
            switch (arg) {
                case "--input":
                case "-i":
                    if (i + 1 < args.length) {
                        inputFile = args[++i];
                    }
                    break;
                case "--output":
                case "-o":
                    if (i + 1 < args.length) {
                        outputFile = args[++i];
                    }
                    break;
                case "--xsltPath":
                    if (i + 1 < args.length) {
                        xsltPath = args[++i];
                    }
                    break;
                case "--help":
                case "-h":
                    showUsage();
                    System.exit(0);
                    break;
                default:
                    if (!arg.startsWith("-") && inputFile == null) {
                        inputFile = arg;
                    } else if (!arg.startsWith("-") && outputFile == null) {
                        outputFile = arg;
                    }
            }
        }

        if (inputFile == null) {
            System.err.println("Error: Input file is required");
            showUsage();
            System.exit(1);
        }

        // Set default output file if not provided
        if (outputFile == null) {
            Path inputPath = Paths.get(inputFile);
            String nameWithoutExt = inputPath.getFileName().toString().replaceFirst("\\.[^.]+$", "");
            outputFile = inputPath.getParent().resolve(nameWithoutExt + ".pdf").toString();
        }

        try {
            convertJsonToPdf(inputFile, outputFile, xsltPath);
            System.out.println("✓ PDF successfully created: " + outputFile);
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
            logger.error("Conversion failed", e);
            System.exit(1);
        }
    }

    private static void showUsage() {
        System.out.println("JSON to PDF Converter (Standalone)");
        System.out.println();
        System.out.println("Usage: java -cp <classpath> com.materialidentity.schemaservice.CommandLineApp [options] <input-file> [output-file]");
        System.out.println();
        System.out.println("Options:");
        System.out.println("  -i, --input <file>      Input JSON file path");
        System.out.println("  -o, --output <file>     Output PDF file path");
        System.out.println("  --xsltPath <file>       Custom XSLT file path (overrides default)");
        System.out.println("  -h, --help              Show this help message");
        System.out.println();
        System.out.println("Examples:");
        System.out.println("  java -cp target/classes:target/lib/* com.materialidentity.schemaservice.CommandLineApp certificate.json");
        System.out.println("  java -cp target/classes:target/lib/* com.materialidentity.schemaservice.CommandLineApp --input cert.json --output result.pdf");
        System.out.println("  java -cp target/classes:target/lib/* com.materialidentity.schemaservice.CommandLineApp cert.json --xsltPath custom.xsl");
    }

    private static void convertJsonToPdf(String inputFile, String outputFile, String xsltPath) 
            throws IOException, TransformerException, SAXException, URISyntaxException {
        
        // Read JSON file
        Path inputPath = Paths.get(inputFile);
        if (!Files.exists(inputPath)) {
            throw new IOException("Input file not found: " + inputFile);
        }

        String jsonContent = Files.readString(inputPath);
        ObjectMapper objectMapper = new ObjectMapper();
        JsonNode certificate = objectMapper.readTree(jsonContent);

        // Extract certificate information
        String[] languages = extractLanguages(certificate);
        String schemaType = extractCertificateType(certificate);
        String schemaVersion = extractCertificateVersion(certificate);

        logger.info("Processing certificate type: {}, version: {}, languages: {}", 
                   schemaType, schemaVersion, String.join(",", languages));

        // Validate schema type and version
        validateSchemaTypeAndVersion(schemaType, schemaVersion);

        // Set up paths
        String translationsPattern = Paths
                .get("schemas", schemaType, schemaVersion, SchemaControllerConstants.JSON_TRANSLATIONS_FILE_NAME_PATTERN)
                .toString();

        String xsltSource;
        
        if (xsltPath != null && !xsltPath.isEmpty()) {
            // Load XSLT from provided file path
            Path customXsltPath = Paths.get(xsltPath);
            if (!Files.exists(customXsltPath)) {
                throw new IOException("XSLT file not found: " + xsltPath);
            }
            logger.info("Loading custom XSLT from: {}", xsltPath);
            xsltSource = Files.readString(customXsltPath);
        } else {
            // Load default XSLT from classpath
            String defaultXsltPath = Paths
                    .get("schemas", schemaType, schemaVersion, SchemaControllerConstants.XSLT_FILE_NAME)
                    .toString();
            org.springframework.core.io.Resource xsltResource = new org.springframework.core.io.ClassPathResource(defaultXsltPath);
            xsltSource = new String(Files.readAllBytes(Paths.get(xsltResource.getURI())));
        }

        // Build PDF using the command-line builder pattern (with font loading fixes)
        CommandLinePDFBuilder pdfBuilder = new CommandLinePDFBuilder()
                .withXsltTransformer(new XsltTransformer(xsltSource, certificate))
                .withTranslations(new TranslationLoader(translationsPattern, languages))
                .withAttachment(new AttachmentManager(jsonContent, 
                                                     Paths.get(outputFile).getFileName().toString().replace(".pdf", ""), 
                                                     false));

        byte[] pdfBytes = pdfBuilder.build();

        // Write PDF to output file
        Path outputPath = Paths.get(outputFile);
        Files.createDirectories(outputPath.getParent());
        
        try (FileOutputStream fos = new FileOutputStream(outputFile)) {
            fos.write(pdfBytes);
        }
    }

    private static String[] extractLanguages(JsonNode certificate) {
        // Try Metals/Forestry format first: DigitalMaterialPassport.Languages
        JsonNode languagesNode = certificate.at("/DigitalMaterialPassport/Languages");
        
        // Try EN10168 format: Certificate.CertificateLanguages
        if (languagesNode.isMissingNode()) {
            languagesNode = certificate.at("/Certificate/CertificateLanguages");
        }
        
        // Try CoA format: Languages
        if (languagesNode.isMissingNode()) {
            languagesNode = certificate.get("Languages");
        }
        
        if (languagesNode.isMissingNode() || !languagesNode.isArray()) {
            throw new IllegalArgumentException("Languages array not found in certificate. Tried: /DigitalMaterialPassport/Languages, /Certificate/CertificateLanguages, /Languages");
        }

        String[] languages = new String[languagesNode.size()];
        for (int i = 0; i < languagesNode.size(); i++) {
            languages[i] = languagesNode.get(i).asText();
        }
        return languages;
    }

    private static String extractCertificateType(JsonNode certificate) {
        JsonNode refSchemaUrlNode = certificate.get("RefSchemaUrl");
        if (refSchemaUrlNode == null || refSchemaUrlNode.asText().isEmpty()) {
            throw new IllegalArgumentException("RefSchemaUrl not found in certificate");
        }

        String refSchemaUrl = refSchemaUrlNode.asText();
        Matcher matcher = schemaPattern.matcher(refSchemaUrl);
        if (matcher.find()) {
            String schemaType = matcher.group(1).toLowerCase();
            // Handle schema names that end with '-schemas'
            if (schemaType.endsWith("-schemas")) {
                schemaType = schemaType.substring(0, schemaType.length() - "-schemas".length());
            }
            return certificateTypeMap.getOrDefault(schemaType, capitalizeFirstLetter(schemaType));
        }

        throw new IllegalArgumentException("Could not extract certificate type from RefSchemaUrl: " + refSchemaUrl);
    }

    private static String extractCertificateVersion(JsonNode certificate) {
        JsonNode refSchemaUrlNode = certificate.get("RefSchemaUrl");
        if (refSchemaUrlNode == null || refSchemaUrlNode.asText().isEmpty()) {
            throw new IllegalArgumentException("RefSchemaUrl not found in certificate");
        }

        String refSchemaUrl = refSchemaUrlNode.asText();
        Matcher matcher = versionPattern.matcher(refSchemaUrl);
        if (matcher.find()) {
            return matcher.group(1);
        }

        throw new IllegalArgumentException("Could not extract version from RefSchemaUrl: " + refSchemaUrl);
    }

    private static void validateSchemaTypeAndVersion(String schemaType, String schemaVersion) {
        Path schemaPath = Paths.get("schemas", schemaType, schemaVersion, "schema.json");
        if (!Files.exists(schemaPath)) {
            throw new IllegalArgumentException("Schema not found: " + schemaPath);
        }
    }

    private static String capitalizeFirstLetter(String input) {
        if (input == null || input.isEmpty()) {
            return input;
        }
        return input.substring(0, 1).toUpperCase() + input.substring(1);
    }
}