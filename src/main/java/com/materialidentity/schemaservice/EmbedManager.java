package com.materialidentity.schemaservice;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.Base64;

import org.apache.pdfbox.Loader;
import org.apache.pdfbox.multipdf.PDFMergerUtility;
import org.apache.pdfbox.pdmodel.PDDocument;

public class EmbedManager {

  private final String base64Data;

  public EmbedManager(String base64Data) {
    this.base64Data = base64Data;
  }

  public byte[] embed(byte[] data) throws IOException {
    PDDocument document1 = Loader.loadPDF(data);
    PDDocument document2 = null;
    try {
      byte[] decodedData = Base64.getDecoder().decode((this.base64Data.split(",")[1]).trim());
      document2 = Loader.loadPDF(decodedData);
      PDFMergerUtility merger = new PDFMergerUtility();
      merger.appendDocument(document1, document2);
      ByteArrayOutputStream output = new ByteArrayOutputStream();
      document1.save(output);
      return output.toByteArray();
    } finally {
      if (document1 != null) {
        document1.close();
      }
      if (document2 != null) {
        document2.close();
      }
    }
  }

}
