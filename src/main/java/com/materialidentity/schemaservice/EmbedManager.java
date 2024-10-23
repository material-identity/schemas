package com.materialidentity.schemaservice;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URL;
import java.util.Base64;

import org.apache.pdfbox.Loader;
import org.apache.pdfbox.multipdf.PDFMergerUtility;
import org.apache.pdfbox.pdmodel.PDDocument;

public class EmbedManager {

  private final String[] base64Data;
  private final String[] s3Urls;

  public EmbedManager(String[] base64Data, String[] s3Urls) {
    this.base64Data = base64Data;
    this.s3Urls = s3Urls;
  }

  public byte[] embed(byte[] data) throws IOException {
    if (this.base64Data != null) {
      return embedBase64(data);
    }
    if (this.s3Urls != null) {
      return embedFromS3Url(data);
    }
    return data;
  }

  public byte[] embedBase64(byte[] data) throws IOException {
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
        try (PDDocument embedDocument = Loader.loadPDF(decodedData)) {
          merger.appendDocument(originalDocument, embedDocument);
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

  public byte[] embedFromS3Url(byte[] data) throws IOException {
    PDDocument originalDocument = Loader.loadPDF(data);

    try {
      PDFMergerUtility merger = new PDFMergerUtility();

      for (String s3Url : this.s3Urls) {
        byte[] s3Data = downloadFileFromUrl(s3Url);

        try (PDDocument embedDocument = Loader.loadPDF(s3Data)) {
          merger.appendDocument(originalDocument, embedDocument);
        }
      }

      ByteArrayOutputStream output = new ByteArrayOutputStream();
      originalDocument.save(output);

      return output.toByteArray();
    } finally {
      if (originalDocument != null) {
        try {
          originalDocument.close();
        } catch (IOException e) {
          System.err.println("Failed to close embedDocument: " + e.getMessage());
        }
      }
    }
  }
  
  private byte[] downloadFileFromUrl(String s3Url) throws IOException {
        URL url = URI.create(s3Url).toURL();
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        connection.setRequestMethod("GET");

        try (InputStream inputStream = connection.getInputStream();
             ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream()) {

            byte[] buffer = new byte[4096];
            int bytesRead;

            while ((bytesRead = inputStream.read(buffer)) != -1) {
                byteArrayOutputStream.write(buffer, 0, bytesRead);
            }

            return byteArrayOutputStream.toByteArray();
        }
    }
}
