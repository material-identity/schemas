package com.materialidentity.schemaservice;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

import org.apache.pdfbox.Loader;
import org.apache.pdfbox.cos.COSArray;
import org.apache.pdfbox.cos.COSDictionary;
import org.apache.pdfbox.cos.COSName;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDDocumentCatalog;
import org.apache.pdfbox.pdmodel.PDDocumentNameDictionary;
import org.apache.pdfbox.pdmodel.PDEmbeddedFilesNameTreeNode;
import org.apache.pdfbox.pdmodel.common.filespecification.PDComplexFileSpecification;
import org.apache.pdfbox.pdmodel.common.filespecification.PDEmbeddedFile;

public class AttachmentManager {

  private final String contentString;
  private final String fileName;
  private final Boolean attachJson;

  public AttachmentManager(String contentString, String fileName, Boolean attachJson) {
    this.contentString = contentString;
    this.fileName = fileName;
    this.attachJson = attachJson;
  }

  public byte[] attach(byte[] pdfData) throws IOException {
    if (!attachJson) {
      return pdfData;
    }
    PDDocument document = Loader.loadPDF(pdfData);
    PDComplexFileSpecification fs = new PDComplexFileSpecification();
    fs.setFile(fileName);
    fs.setFileUnicode(fileName);

    byte[] contentBytes = contentString.getBytes(StandardCharsets.UTF_8);

    InputStream is = new ByteArrayInputStream(contentBytes);
    PDEmbeddedFile embeddedFile = new PDEmbeddedFile(document, is);
    embeddedFile.setSubtype("application/json");
    fs.setEmbeddedFile(embeddedFile);

    COSDictionary dict = fs.getCOSObject();
    dict.setName("AFRelationship", "Alternative");

    PDDocumentCatalog catalog = document.getDocumentCatalog();
    COSArray cosArray = new COSArray();
    cosArray.add(fs.getCOSObject());
    catalog.getCOSObject().setItem(COSName.AF, cosArray);

    PDEmbeddedFilesNameTreeNode efTree = new PDEmbeddedFilesNameTreeNode();
    Map<String, PDComplexFileSpecification> efMap = new HashMap<>();
    efMap.put(fileName, fs);
    efTree.setNames(efMap);

    PDDocumentNameDictionary names = new PDDocumentNameDictionary(
        document.getDocumentCatalog());
    names.setEmbeddedFiles(efTree);
    document.getDocumentCatalog().setNames(names);

    ByteArrayOutputStream output = new ByteArrayOutputStream();
    document.save(output);
    return output.toByteArray();
  }
}
