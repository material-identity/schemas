package com.materialidentity.schemaservice;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import javax.xml.transform.TransformerException;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.xml.sax.SAXException;

@RestController
public class SchemaController {

  @GetMapping("/")
  public String index() {
    return "Schemas Service";
  }

  @PostMapping("/render")
  public ResponseEntity<byte[]> render(
    @RequestParam("schemaType") String schemaType,
    @RequestParam("schemaVersion") String schemaVersion,
    @RequestParam("languages") String[] languages,
    @RequestBody JsonNode certificate
  ) {
    try {
      String translationsPattern = Paths
        .get("schemas", schemaType, schemaVersion, "translations*.json")
        .toString();

      String certificateJson = jsonToString(certificate);

      String xsltPath = Paths
        .get("schemas", schemaType, schemaVersion, "stylesheet.xsl")
        .toString();

      Resource xsltResource = new ClassPathResource(xsltPath);
      String xsltSource = new String(
        Files.readAllBytes(Paths.get(xsltResource.getURI()))
      );

      byte[] pdfBytes = new PDFBuilder()
        .withXsltTransformer(new XsltTransformer(xsltSource, certificate))
        .withTranslations(new TranslationLoader(translationsPattern, languages))
        .withAttachment(
          new AttachmentManager(certificateJson, "certificate.json")
        )
        .build();

      HttpHeaders headers = new HttpHeaders();
      headers.setContentType(MediaType.APPLICATION_PDF);
      headers.setContentDispositionFormData("filename", "output.pdf");

      return new ResponseEntity<>(pdfBytes, headers, HttpStatus.OK);
    } catch (TransformerException | IOException | SAXException e) {
      e.printStackTrace();
      return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }
  }

  public static String jsonToString(JsonNode jsonMap)
    throws JsonProcessingException {
    ObjectMapper objectMapper = new ObjectMapper();
    return objectMapper.writeValueAsString(jsonMap);
  }
}
