package com.materialidentity.schemaservice;

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

public class FoManager {

    private String xslFoInput;

    public FoManager() {
    }

    public FoManager(String xslFoInput) {
        this.xslFoInput = xslFoInput;
    }

    private static void copyInputStreamToFile(InputStream inputStream, File file) throws IOException {
        try (FileOutputStream outputStream = new FileOutputStream(file)) {
            int read;
            byte[] bytes = new byte[1024];
            while ((read = inputStream.read(bytes)) != -1) {
                outputStream.write(bytes, 0, read);
            }
        }
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
            File tempFile = File.createTempFile("fop", ".xconf");
            tempFile.deleteOnExit();
            copyInputStreamToFile(is, tempFile);
            fopFactory = FopFactory.newInstance(tempFile);
        }

        FOUserAgent foUserAgent = fopFactory.newFOUserAgent();

        try (ByteArrayOutputStream outStream = new ByteArrayOutputStream()) {
            Fop fop = fopFactory.newFop(MimeConstants.MIME_PDF, foUserAgent, outStream);
            Transformer transformer = TransformerFactory.newInstance().newTransformer();
            Source src = new StreamSource(new StringReader(xslFoInput));
            Result res = new SAXResult(fop.getDefaultHandler());

            try {
                transformer.transform(src, res);
            } catch (RuntimeException e) {
                throw new IOException(getPdfGenerationErrorMessage(e), e);
            }

            return outStream.toByteArray();
        }
    }

    static String getPdfGenerationErrorMessage(RuntimeException e) {
        for (Throwable t = e; t != null; t = t.getCause()) {
            if (t.getStackTrace().length > 0) {
                String className = t.getStackTrace()[0].getClassName();
                if (className.contains("PNGImage") || className.contains("PNGImageDecoder")) {
                    return "An embedded image contains a malformed or truncated PNG. "
                            + "Please check that all base64-encoded images in the certificate are valid PNG files.";
                }
            }
        }
        return "PDF generation failed due to invalid certificate data. "
                + "Please verify all embedded resources are valid.";
    }
}
