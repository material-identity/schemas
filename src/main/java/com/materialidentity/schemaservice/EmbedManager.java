package com.materialidentity.schemaservice;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.Base64;

import org.apache.pdfbox.Loader;
import org.apache.pdfbox.multipdf.PDFMergerUtility;
import org.apache.pdfbox.pdmodel.PDDocument;

public class EmbedManager {

  private final String[] base64Data;

  public EmbedManager(String[] base64Data) {
    this.base64Data = base64Data;
  }

  public byte[] embed(byte[] data) throws IOException {
    PDDocument originalDocument = Loader.loadPDF(data);
    try {
      PDFMergerUtility merger = new PDFMergerUtility();

      for (String base64String : this.base64Data) {
        String[] parts = base64String.split(",");
        String base64Part;
        if (parts.length > 1) {
          base64Part = parts[1].trim();
        } else {
          base64Part = parts[0].trim();
        }

        byte[] decodedData = Base64.getDecoder().decode(base64Part);
        PDDocument embedDocument = Loader.loadPDF(decodedData);
        try {
          merger.appendDocument(originalDocument, embedDocument);
        } finally {
          embedDocument.close();
        }
      }

      ByteArrayOutputStream output = new ByteArrayOutputStream();
      originalDocument.save(output);
      return output.toByteArray();
    } finally {
      if (originalDocument != null) {
        originalDocument.close();
      }
    }
  }
}
