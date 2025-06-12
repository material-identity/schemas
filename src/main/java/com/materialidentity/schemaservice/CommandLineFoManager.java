package com.materialidentity.schemaservice;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.apache.fop.apps.FOUserAgent;
import org.apache.fop.apps.Fop;
import org.apache.fop.apps.FopFactory;
import org.apache.fop.apps.MimeConstants;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.xml.sax.SAXException;

import javax.xml.transform.*;
import javax.xml.transform.sax.SAXResult;
import javax.xml.transform.stream.StreamSource;
import java.io.*;

/**
 * Command-line specific FO Manager that handles font loading for standalone usage.
 * This class uses the same FOP configuration approach as the main service
 * to ensure consistent font embedding and PDF generation.
 */
public class CommandLineFoManager {
    private static final Logger logger = LoggerFactory.getLogger(CommandLineFoManager.class);
    private String xslFoInput;

    public CommandLineFoManager() {
    }

    public CommandLineFoManager(String xslFoInput) {
        this.xslFoInput = xslFoInput;
    }


    private String replaceClasspathUrls(String xconfContent) {
        // Replace classpath: URLs with file: URLs pointing to the actual classpath resources
        String result = xconfContent;
        
        String[] fontFiles = {
            "NotoSans-Regular.ttf", "NotoSans-Bold.ttf", "NotoSans-Italic.ttf", "NotoSans-Light.ttf",
            "NotoSansSC-Regular.ttf", "NotoSansSC-Bold.ttf", "NotoSansSC-Light.ttf", 
            "TKTypeRegular.ttf", "TKTypeBold.ttf", "TKTypeMedium.ttf"
        };
        
        for (String fontFile : fontFiles) {
            try {
                java.net.URL fontUrl = getClass().getClassLoader().getResource("fonts/" + fontFile);
                if (fontUrl != null) {
                    String fontPath = fontUrl.toString();
                    String classpathUrl = "classpath:fonts/" + fontFile;
                    result = result.replace(classpathUrl, fontPath);
                }
            } catch (Exception e) {
                logger.error("Error processing font " + fontFile + ": " + e.getMessage());
            }
        }
        
        return result;
    }

    public byte[] generatePdf() throws TransformerException, IOException, SAXException {
        return generatePdf(xslFoInput);
    }

    public byte[] generatePdf(String xslFoInput) throws TransformerException, IOException, SAXException {
        if (xslFoInput == null) {
            throw new IllegalArgumentException("XSL-FO input is required");
        }

        Resource xconfResource = new ClassPathResource("fop.xconf");
        FopFactory fopFactory;

        try (InputStream is = xconfResource.getInputStream()) {
            // Read the original config and replace classpath: URLs with actual file paths
            String xconfContent = new String(is.readAllBytes(), java.nio.charset.StandardCharsets.UTF_8);
            
            // Replace classpath: URLs with file: URLs pointing to the actual font files
            String processedConfig = replaceClasspathUrls(xconfContent);
            
            File tempFile = File.createTempFile("fop", ".xconf");
            tempFile.deleteOnExit();
            
            try (FileOutputStream fos = new FileOutputStream(tempFile)) {
                fos.write(processedConfig.getBytes(java.nio.charset.StandardCharsets.UTF_8));
            }
            
            // Use the same FopFactory approach as the service, but with processed config
            fopFactory = FopFactory.newInstance(tempFile);
        }

        FOUserAgent foUserAgent = fopFactory.newFOUserAgent();

        try (ByteArrayOutputStream outStream = new ByteArrayOutputStream()) {
            Fop fop = fopFactory.newFop(MimeConstants.MIME_PDF, foUserAgent, outStream);
            Transformer transformer = TransformerFactory.newInstance().newTransformer();
            Source src = new StreamSource(new StringReader(xslFoInput));
            Result res = new SAXResult(fop.getDefaultHandler());

            transformer.transform(src, res);

            return outStream.toByteArray();
        }
    }
}