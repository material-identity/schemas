package com.materialidentity.schemaservice;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.networknt.schema.InputFormat;
import com.networknt.schema.JsonSchema;
import com.networknt.schema.JsonSchemaFactory;
import com.networknt.schema.SpecVersion;
import com.networknt.schema.ValidationMessage;

import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class SchemaController {

  // @GetMapping("/")
  // public String index() {
  // return "Schemas Service";
  // }

  @PostMapping("/render")
  public ResponseEntity<byte[]> render(
      @RequestParam("schemaType") String schemaType,
      @RequestParam("schemaVersion") String schemaVersion,
      @RequestParam("languages") String[] languages,
      @RequestBody JsonNode certificate) throws Exception {
    String translationsPattern = Paths
        .get("schemas", schemaType, schemaVersion, "translations*.json")
        .toString();

    String certificateJson = jsonToString(certificate);

    String xsltPath = Paths
        .get("schemas", schemaType, schemaVersion, "stylesheet.xsl")
        .toString();

    Resource xsltResource = new ClassPathResource(xsltPath);
    String xsltSource = new String(
        Files.readAllBytes(Paths.get(xsltResource.getURI())));

    byte[] pdfBytes = new PDFBuilder()
        .withXsltTransformer(new XsltTransformer(xsltSource, certificate))
        .withTranslations(new TranslationLoader(translationsPattern, languages))
        .withAttachment(
            new AttachmentManager(certificateJson, "certificate.json"))
        .build();

    HttpHeaders headers = new HttpHeaders();
    headers.setContentType(MediaType.APPLICATION_PDF);
    headers.setContentDispositionFormData("filename", "output.pdf");

    return new ResponseEntity<>(pdfBytes, headers, HttpStatus.OK);
  }

  @PostMapping("/validate")
  public ResponseEntity<Boolean> validate(
      @RequestParam("schemaType") String schemaType,
      @RequestParam("schemaVersion") String schemaVersion,
      @RequestBody JsonNode requestBody) {
    try {
      ObjectMapper objectMapper = new ObjectMapper();
      String jsonCertificateString = objectMapper.writeValueAsString(requestBody.get("jsonData"));
      String jsonSchemaString = objectMapper.writeValueAsString(requestBody.get("jsonSchema"));

      // build schema validator with schema definition
      JsonSchemaFactory schemaFactory = JsonSchemaFactory.getInstance(SpecVersion.VersionFlag.V202012);
      JsonSchema schema = schemaFactory.getSchema(jsonSchemaString);

      Set<ValidationMessage> validationResult = schema.validate(jsonCertificateString, InputFormat.JSON,
          executionContext -> {
            executionContext.getExecutionConfig().setFormatAssertionsEnabled(true);
          });

      Boolean isValid = validationResult.isEmpty();

      if (!isValid)
        for (ValidationMessage result : validationResult) {
          System.out.println(result.getMessage());
        }

      HttpHeaders headers = new HttpHeaders();
      headers.setContentType(MediaType.APPLICATION_JSON);

      Map<String, Object> response = new HashMap<>();
      response.put("success", isValid);

      return new ResponseEntity<>(validationResult.isEmpty(), HttpStatus.OK);

    } catch (Exception e) {
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
