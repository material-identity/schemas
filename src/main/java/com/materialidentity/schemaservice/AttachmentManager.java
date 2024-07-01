package com.materialidentity.schemaservice;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;
import org.apache.pdfbox.Loader;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDDocumentNameDictionary;
import org.apache.pdfbox.pdmodel.PDEmbeddedFilesNameTreeNode;
import org.apache.pdfbox.pdmodel.common.filespecification.PDComplexFileSpecification;
import org.apache.pdfbox.pdmodel.common.filespecification.PDEmbeddedFile;

public class AttachmentManager {

  private final String contentString;
  private final String fileName;

  public AttachmentManager(String contentString, String fileName) {
    this.contentString = contentString;
    this.fileName = fileName;
  }

  public byte[] attach(byte[] pdfData) throws IOException {
    PDDocument document = Loader.loadPDF(pdfData);
    PDComplexFileSpecification fs = new PDComplexFileSpecification();
    fs.setFile(fileName);

    byte[] contentBytes = contentString.getBytes(StandardCharsets.UTF_8);

    InputStream is = new ByteArrayInputStream(contentBytes);
    fs.setEmbeddedFile(new PDEmbeddedFile(document, is));

    PDEmbeddedFilesNameTreeNode efTree = new PDEmbeddedFilesNameTreeNode();
    Map<String, PDComplexFileSpecification> efMap = new HashMap<>();
    efMap.put(fileName, fs);
    efTree.setNames(efMap);

    PDDocumentNameDictionary names = new PDDocumentNameDictionary(
      document.getDocumentCatalog()
    );
    names.setEmbeddedFiles(efTree);
    document.getDocumentCatalog().setNames(names);

    // Save the document with the attachment to a new ByteArrayOutputStream
    ByteArrayOutputStream output = new ByteArrayOutputStream();
    document.save(output);
    return output.toByteArray();
  }
}
