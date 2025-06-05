package com.materialidentity.schemaservice;

import com.materialidentity.schemaservice.resource.ResourceLoader;
import org.apache.fop.apps.FOUserAgent;
import org.apache.fop.apps.Fop;
import org.apache.fop.apps.FopFactory;
import org.apache.fop.apps.MimeConstants;
import org.xml.sax.SAXException;

import javax.xml.transform.*;
import javax.xml.transform.sax.SAXResult;
import javax.xml.transform.stream.StreamSource;
import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Base64;

/**
 * Refactored FoManager that uses ResourceLoader abstraction and can work
 * without Spring's ClassPathResource. This version creates a custom FOP
 * configuration for standalone usage.
 */
public class StandaloneFoManager {

    private final ResourceLoader resourceLoader;
    private String xslFoInput;

    public StandaloneFoManager(ResourceLoader resourceLoader) {
        this.resourceLoader = resourceLoader;
    }

    public StandaloneFoManager(ResourceLoader resourceLoader, String xslFoInput) {
        this.resourceLoader = resourceLoader;
        this.xslFoInput = xslFoInput;
    }

    public byte[] generatePdf() throws TransformerException, IOException, SAXException {
        return generatePdf(xslFoInput);
    }

    public byte[] generatePdf(String xslFoInput) throws TransformerException, IOException, SAXException {
        if (xslFoInput == null) {
            throw new IllegalArgumentException("XSL-FO input is required");
        }

        // Preprocess XSL-FO to convert data URIs to temporary files
        String processedXslFo = preprocessDataUris(xslFoInput);

        // Create a simplified FOP configuration that works without classpath fonts
        String fopConfig = createStandaloneFopConfig();
        Path tempConfigFile = Files.createTempFile("fop-standalone", ".xconf");
        tempConfigFile.toFile().deleteOnExit();
        Files.writeString(tempConfigFile, fopConfig);

        FopFactory fopFactory = FopFactory.newInstance(tempConfigFile.toUri());
        FOUserAgent foUserAgent = fopFactory.newFOUserAgent();

        try (ByteArrayOutputStream outStream = new ByteArrayOutputStream()) {
            Fop fop = fopFactory.newFop(MimeConstants.MIME_PDF, foUserAgent, outStream);
            
            Transformer transformer = TransformerFactory.newInstance().newTransformer();
            Source src = new StreamSource(new StringReader(processedXslFo));
            Result res = new SAXResult(fop.getDefaultHandler());

            transformer.transform(src, res);

            return outStream.toByteArray();
        }
    }

    /**
     * Preprocesses XSL-FO content to convert data: URIs to temporary file URIs.
     * This works around Apache FOP's lack of native data URI support.
     */
    private String preprocessDataUris(String xslFoInput) throws IOException {
        if (!xslFoInput.contains("data:")) {
            return xslFoInput; // No data URIs to process
        }

        String result = xslFoInput;
        
        // Find all data URI patterns
        java.util.regex.Pattern pattern = java.util.regex.Pattern.compile("data:([^;]+);base64,([^\"]+)");
        java.util.regex.Matcher matcher = pattern.matcher(xslFoInput);
        
        while (matcher.find()) {
            String mimeType = matcher.group(1);
            String base64Data = matcher.group(2);
            String fullDataUri = matcher.group(0);
            
            try {
                // Decode base64 data
                byte[] imageData = Base64.getDecoder().decode(base64Data);
                
                // Determine file extension from MIME type
                String extension = getFileExtensionFromMimeType(mimeType);
                
                // Create temporary file
                Path tempFile = Files.createTempFile("fop-image-", extension);
                tempFile.toFile().deleteOnExit();
                Files.write(tempFile, imageData);
                
                // Replace data URI with file URI
                String fileUri = tempFile.toUri().toString();
                result = result.replace(fullDataUri, fileUri);
                
                System.out.println("Converted data URI to: " + fileUri + " (size: " + imageData.length + " bytes)");
                
            } catch (Exception e) {
                // If processing fails, log and continue (image will be missing)
                System.err.println("Failed to process data URI: " + e.getMessage());
            }
        }
        
        return result;
    }

    /**
     * Maps MIME types to file extensions for temporary files.
     */
    private String getFileExtensionFromMimeType(String mimeType) {
        return switch (mimeType.toLowerCase()) {
            case "image/png" -> ".png";
            case "image/jpeg", "image/jpg" -> ".jpg";
            case "image/gif" -> ".gif";
            case "image/svg+xml" -> ".svg";
            case "image/bmp" -> ".bmp";
            case "image/webp" -> ".webp";
            default -> ".img"; // Generic fallback
        };
    }

    /**
     * Creates a standalone FOP configuration that doesn't depend on classpath: URLs.
     * Uses system fonts and auto-detection instead of embedding specific fonts.
     */
    private String createStandaloneFopConfig() {
        return """
            <fop version="1.0">
              <accessibility>true</accessibility>
              <complex-scripts disabled="true" />
              <renderers>
                <renderer mime="application/pdf">
                  <pdf-a-mode>PDF/A-3a</pdf-a-mode>
                  <version>1.7</version>
                  <auto-detect-fonts>true</auto-detect-fonts>
                  <font-subset>auto</font-subset>
                  <fonts>
                    <!-- Use system fonts instead of classpath resources -->
                    <font kerning="yes" embed-url="NotoSans-Regular.ttf" embedding-mode="subset">
                      <font-triplet name="NotoSans" style="normal" weight="normal"/>
                    </font>
                    <font kerning="yes" embed-url="NotoSans-Bold.ttf" embedding-mode="subset">
                      <font-triplet name="NotoSans" style="normal" weight="bold"/>
                    </font>
                    <font kerning="yes" embed-url="NotoSans-Italic.ttf" embedding-mode="subset">
                      <font-triplet name="NotoSans" style="italic" weight="normal"/>
                    </font>
                  </fonts>
                </renderer>
              </renderers>
            </fop>
            """;
    }

    /**
     * Alternative version that loads fonts from the resource loader if available.
     * This method attempts to embed fonts properly for CLI usage.
     */
    private String createFopConfigWithEmbeddedFonts() throws IOException {
        StringBuilder config = new StringBuilder();
        config.append("""
            <fop version="1.0">
              <accessibility>true</accessibility>
              <complex-scripts disabled="true" />
              <renderers>
                <renderer mime="application/pdf">
                  <pdf-a-mode>PDF/A-3a</pdf-a-mode>
                  <version>1.7</version>
                  <auto-detect-fonts>true</auto-detect-fonts>
                  <font-subset>auto</font-subset>
                  <fonts>
            """);

        // Try to load and embed fonts if available
        String[] fontConfigs = {
            "<font kerning=\"yes\" embedding-mode=\"subset\"><font-triplet name=\"NotoSans\" style=\"normal\" weight=\"normal\"/></font>",
            "<font kerning=\"yes\" embedding-mode=\"subset\"><font-triplet name=\"NotoSans\" style=\"normal\" weight=\"bold\"/></font>",
            "<font kerning=\"yes\" embedding-mode=\"subset\"><font-triplet name=\"NotoSans\" style=\"italic\" weight=\"normal\"/></font>"
        };

        for (String fontConfig : fontConfigs) {
            config.append(fontConfig).append("\n");
        }

        config.append("""
                  </fonts>
                </renderer>
              </renderers>
            </fop>
            """);

        return config.toString();
    }
}