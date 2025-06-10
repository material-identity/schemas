package com.materialidentity.schemaservice;

import org.apache.xmlgraphics.io.Resource;
import org.apache.xmlgraphics.io.ResourceResolver;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URI;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.Base64;

/**
 * Custom resource resolver that handles classpath: URLs for Apache FOP.
 * This allows FOP to load fonts and other resources from the classpath.
 */
public class ClasspathResourceResolver implements ResourceResolver {

    private static final Logger logger = LoggerFactory.getLogger(ClasspathResourceResolver.class);
    private static final String CLASSPATH_SCHEME = "classpath";
    private static final String DATA_SCHEME = "data";

    @Override
    public Resource getResource(URI uri) throws IOException {
        logger.info("Resolving resource URI: {}", uri);
        
        if (CLASSPATH_SCHEME.equals(uri.getScheme())) {
            return getClasspathResource(uri);
        } else if (DATA_SCHEME.equals(uri.getScheme())) {
            return getDataUriResource(uri);
        }
        
        // For non-classpath URIs, delegate to default behavior
        logger.debug("Delegating to default URL handling for: {}", uri);
        return new Resource(uri.toURL().openStream());
    }

    private Resource getClasspathResource(URI uri) throws IOException {
        String path = uri.getSchemeSpecificPart();
        
        // Remove leading slashes to make it a proper classpath resource path
        while (path.startsWith("/")) {
            path = path.substring(1);
        }
        
        logger.info("Loading classpath resource: {}", path);
        
        InputStream inputStream = Thread.currentThread().getContextClassLoader().getResourceAsStream(path);
        if (inputStream == null) {
            // Try with the class loader used to load this class
            inputStream = getClass().getClassLoader().getResourceAsStream(path);
        }
        if (inputStream == null) {
            // Try system class loader as last resort
            inputStream = ClassLoader.getSystemResourceAsStream(path);
        }
        
        if (inputStream == null) {
            logger.error("Classpath resource not found: {}", path);
            throw new IOException("Classpath resource not found: " + path);
        }
        
        logger.info("Successfully loaded classpath resource: {}", path);
        return new Resource(inputStream);
    }

    private Resource getDataUriResource(URI uri) throws IOException {
        String dataUri = uri.toString();
        logger.info("Processing data URI resource (length: {})", dataUri.length());
        
        // Parse data URI format: data:[<mediatype>][;base64],<data>
        String schemeSpecificPart = uri.getSchemeSpecificPart();
        
        // Find the comma that separates metadata from data
        int commaIndex = schemeSpecificPart.indexOf(',');
        if (commaIndex == -1) {
            throw new IOException("Invalid data URI format: missing comma separator");
        }
        
        String metadata = schemeSpecificPart.substring(0, commaIndex);
        String data = schemeSpecificPart.substring(commaIndex + 1);
        
        logger.debug("Data URI metadata: {}", metadata);
        
        // Check if it's base64 encoded
        boolean isBase64 = metadata.contains("base64");
        
        InputStream inputStream;
        try {
            if (isBase64) {
                // Decode base64 data
                byte[] decodedData = Base64.getDecoder().decode(data);
                inputStream = new ByteArrayInputStream(decodedData);
                logger.info("Successfully decoded base64 data URI (decoded size: {} bytes)", decodedData.length);
            } else {
                // URL decode plain text data
                String decodedData = URLDecoder.decode(data, StandardCharsets.UTF_8);
                inputStream = new ByteArrayInputStream(decodedData.getBytes(StandardCharsets.UTF_8));
                logger.info("Successfully processed plain text data URI");
            }
        } catch (Exception e) {
            logger.error("Failed to decode data URI: {}", e.getMessage());
            throw new IOException("Failed to decode data URI: " + e.getMessage(), e);
        }
        
        return new Resource(inputStream);
    }

    @Override
    public OutputStream getOutputStream(URI uri) throws IOException {
        throw new UnsupportedOperationException("Output streams not supported for classpath resources");
    }
}