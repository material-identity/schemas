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
    PDDocument originalDocument = Loader.loadPDF(data);
    PDDocument embedDocument = null;
    try {
      byte[] decodedData = Base64.getDecoder().decode((this.base64Data.split(",")[1]).trim());
      embedDocument = Loader.loadPDF(decodedData);
      PDFMergerUtility merger = new PDFMergerUtility();
      merger.appendDocument(originalDocument, embedDocument);
      ByteArrayOutputStream output = new ByteArrayOutputStream();
      originalDocument.save(output);
      return output.toByteArray();
    } finally {
      if (originalDocument != null) {
        originalDocument.close();
      }
      if (embedDocument != null) {
        embedDocument.close();
      }
    }
  }

}
