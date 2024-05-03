package com.materialidentity.schemaservice;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringReader;
import java.io.StringWriter;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;
import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.sax.SAXResult;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import net.sf.saxon.TransformerFactoryImpl;
import org.apache.fop.apps.FOPException;
import org.apache.fop.apps.FOUserAgent;
import org.apache.fop.apps.Fop;
import org.apache.fop.apps.FopFactory;
import org.apache.fop.apps.MimeConstants;
import org.apache.pdfbox.Loader;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDDocumentNameDictionary;
import org.apache.pdfbox.pdmodel.PDEmbeddedFilesNameTreeNode;
import org.apache.pdfbox.pdmodel.common.filespecification.PDComplexFileSpecification;
import org.apache.pdfbox.pdmodel.common.filespecification.PDEmbeddedFile;
import org.json.JSONObject;
import org.json.XML;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.xml.sax.SAXException;

@RestController
public class SchemaController {

  @PostMapping("/")
  public String index() {
    return "Schemas Service";
  }

  @PostMapping("/render")
  public ResponseEntity<byte[]> render(
    @RequestParam("schemaType") String schemaType,
    @RequestParam("schemaVersion") String schemaVersion,
    @RequestBody Map<String, Object> jsonMap
  ) {
    try {
      String certificateXml = jsonToXml(jsonMap);

      String xsltPath = Paths
        .get("schemas", schemaType, schemaVersion, "stylesheet.xsl")
        .toString();

      Resource xsltResource = new ClassPathResource(xsltPath);
      String xsltSource = new String(
        Files.readAllBytes(Paths.get(xsltResource.getURI()))
      );

      String transformedXml = xsltTransform(certificateXml, xsltSource);
      var pdfBytes = generatePdfFromXslFo(transformedXml);

      String certificateString = jsonToString(jsonMap);

      var pdfBytesWithAttachment = attachFileToPdf(
        pdfBytes,
        certificateString,
        "certificate.json"
      );

      HttpHeaders headers = new HttpHeaders();
      headers.setContentType(MediaType.APPLICATION_PDF);
      headers.setContentDispositionFormData("filename", "output.pdf");

      return new ResponseEntity<>(
        pdfBytesWithAttachment,
        headers,
        HttpStatus.OK
      );
    } catch (Exception e) {
      e.printStackTrace();
      return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }
  }

  public static String jsonToString(Map<String, Object> jsonMap)
    throws JsonProcessingException {
    ObjectMapper objectMapper = new ObjectMapper();
    return objectMapper.writeValueAsString(jsonMap);
  }

  public static String jsonToXml(Map<String, Object> jsonMap) {
    JSONObject json = new JSONObject(jsonMap);
    return "<root>" + XML.toString(json) + "</root>";
  }

  public String xsltTransform(String xmlSource, String xsltSource) {
    try {
      Source xmlInput = new StreamSource(new StringReader(xmlSource));
      Source xsltInput = new StreamSource(new StringReader(xsltSource));
      StringWriter outputWriter = new StringWriter();

      TransformerFactory factory = new TransformerFactoryImpl();
      Transformer transformer = factory.newTransformer(xsltInput);
      transformer.transform(xmlInput, new StreamResult(outputWriter));

      return outputWriter.toString();
    } catch (Exception e) {
      e.printStackTrace();
      return null;
    }
  }

  public static byte[] attachFileToPdf(
    byte[] pdfData,
    String contentString,
    String fileName
  ) {
    try (PDDocument document = Loader.loadPDF(pdfData)) {
      PDComplexFileSpecification fs = new PDComplexFileSpecification();
      fs.setFile(fileName);

      byte[] contentBytes = contentString.getBytes(StandardCharsets.UTF_8);

      try (InputStream is = new ByteArrayInputStream(contentBytes)) {
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
    } catch (Exception e) {
      e.printStackTrace();
    }
    return null;
  }

  public static byte[] generatePdfFromXslFo(String xslFoInput) {
    ByteArrayOutputStream outStream = new ByteArrayOutputStream();
    Resource xconfResource = new ClassPathResource("fop.xconf");

    FopFactory fopFactory;
    try {
      File xconf = xconfResource.getFile();
      fopFactory = FopFactory.newInstance(xconf);
    } catch (SAXException | IOException e) {
      e.printStackTrace();
      return null;
    }

    FOUserAgent foUserAgent = fopFactory.newFOUserAgent();
    try {
      Fop fop = fopFactory.newFop(
        MimeConstants.MIME_PDF,
        foUserAgent,
        outStream
      );
      Transformer transformer = TransformerFactory
        .newInstance()
        .newTransformer();
      Source src = new StreamSource(new StringReader(xslFoInput));
      Result res = new SAXResult(fop.getDefaultHandler());

      transformer.transform(src, res);

      return outStream.toByteArray();
    } catch (FOPException | TransformerException e) {
      e.printStackTrace();
      return null;
    } finally {
      try {
        outStream.close();
      } catch (IOException e) {
        e.printStackTrace();
      }
    }
  }
}
