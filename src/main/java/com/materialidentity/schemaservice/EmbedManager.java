package com.materialidentity.schemaservice;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Base64;

import org.apache.pdfbox.Loader;
import org.apache.pdfbox.multipdf.PDFMergerUtility;
import org.apache.pdfbox.pdmodel.PDDocument;

import com.materialidentity.schemaservice.config.AwsConstants;

import software.amazon.awssdk.auth.credentials.AnonymousCredentialsProvider;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.GetObjectRequest;

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
    String bucketName = AwsConstants.DMP_PDF_BUCKET;
    String bucketRegion = AwsConstants.AWS_REGION;
    S3Client s3 = S3Client.builder()
        .credentialsProvider(AnonymousCredentialsProvider.create())
        .region(Region.of(bucketRegion))
        .build();

    try {
      PDFMergerUtility merger = new PDFMergerUtility();

      for (String s3Url : this.s3Urls) {
        String objectKey = s3Url;
        GetObjectRequest getObjectRequest = GetObjectRequest.builder()
            .bucket(bucketName)
            .key(objectKey)
            .build();
        InputStream s3InputStream = s3.getObject(getObjectRequest);
        byte[] s3Data = s3InputStream.readAllBytes();

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
}
