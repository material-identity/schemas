package com.materialidentity.schemaservice;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringReader;
import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.sax.SAXResult;
import javax.xml.transform.stream.StreamSource;
import org.apache.fop.apps.FOPException;
import org.apache.fop.apps.FOUserAgent;
import org.apache.fop.apps.Fop;
import org.apache.fop.apps.FopFactory;
import org.apache.fop.apps.MimeConstants;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.xml.sax.SAXException;

public class FoManager {

  private String xslFoInput;

  public FoManager() {
  }

  public FoManager(String xslFoInput) {
    this.xslFoInput = xslFoInput;
  }

  public byte[] generatePdf() throws FOPException, TransformerException, IOException, SAXException {
    return generatePdf(xslFoInput);
  }

  public byte[] generatePdf(String xslFoInput)
      throws FOPException, TransformerException, IOException, SAXException {
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

    try (ByteArrayOutputStream outStream = new ByteArrayOutputStream();) {
      Fop fop = fopFactory.newFop(
          MimeConstants.MIME_PDF,
          foUserAgent,
          outStream);
      Transformer transformer = TransformerFactory
          .newInstance()
          .newTransformer();
      Source src = new StreamSource(new StringReader(xslFoInput));
      Result res = new SAXResult(fop.getDefaultHandler());

      transformer.transform(src, res);

      return outStream.toByteArray();
    }
  }

  private static void copyInputStreamToFile(InputStream inputStream, File file)
      throws IOException {
    try (FileOutputStream outputStream = new FileOutputStream(file)) {
      int read;
      byte[] bytes = new byte[1024];
      while ((read = inputStream.read(bytes)) != -1) {
        outputStream.write(bytes, 0, read);
      }
    }
  }
}
