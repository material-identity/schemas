package com.materialidentity.schemaservice;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.networknt.schema.InputFormat;
import com.networknt.schema.JsonSchema;
import com.networknt.schema.JsonSchemaFactory;
import com.networknt.schema.SpecVersion;
import com.networknt.schema.ValidationMessage;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
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
  public ResponseEntity<Map<String, Object>> validate(
      @RequestParam("schemaType") String schemaType,
      @RequestParam("schemaVersion") String schemaVersion,
      @RequestBody JsonNode jsonCertificate) {
    try {

      String certificateString = jsonToString(jsonCertificate);

      // build schema validator with schema definition
      JsonSchemaFactory schemaFactory = JsonSchemaFactory.getInstance(SpecVersion.VersionFlag.V202012);

      String schemaDefinitionPath = Paths
          .get("schemas", schemaType, schemaVersion, "schema.json")
          .toString();

      String schemaDefinition = readResourceAsString(schemaDefinitionPath);

      JsonSchema schema = schemaFactory.getSchema(schemaDefinition);

      Set<ValidationMessage> validationResult = schema.validate(certificateString, InputFormat.JSON,
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

      return new ResponseEntity<>(response, headers, HttpStatus.OK);

    } catch (Exception e) {
      e.printStackTrace();
      return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }
  }

  @GetMapping("/schemas")
  public ResponseEntity<Map<String, Object>> getSchemas() {
    Map<String, Object> response = new HashMap<>();
    PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();

    try {
      Resource[] resources = resolver.getResources("classpath:schemas/*");

      for (Resource resource : resources) {
        if (resource.getFile().isDirectory()) {
          String schemaName = resource.getFilename();
          List<String> versions = getVersionsForResource(resolver, schemaName);
          response.put(schemaName, Collections.singletonMap("versions", versions));
        }
      }

      HttpHeaders headers = new HttpHeaders();
      headers.setContentType(MediaType.APPLICATION_JSON);

      return new ResponseEntity<>(response, headers, HttpStatus.OK);
    } catch (IOException e) {
      e.printStackTrace();
      return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }
  }

  private List<String> getVersionsForResource(PathMatchingResourcePatternResolver resolver, String schemaName)
      throws IOException {
    List<String> versions = new ArrayList<>();
    Resource[] versionResources = resolver.getResources("classpath:schemas/" + schemaName + "/*");

    for (Resource versionResource : versionResources) {
      if (versionResource.getFile().isDirectory()) {
        versions.add(versionResource.getFilename());
      }
    }

    return versions;
  }

  public static String jsonToString(JsonNode jsonMap)
      throws JsonProcessingException {
    ObjectMapper objectMapper = new ObjectMapper();
    return objectMapper.writeValueAsString(jsonMap);
  }

  private String readResourceAsString(String resourcePath) throws IOException {
    PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
    Resource resource = resolver.getResource("classpath:" + resourcePath);
    try (InputStream inputStream = resource.getInputStream()) {
      byte[] bytes = inputStream.readAllBytes();
      return new String(bytes, StandardCharsets.UTF_8);
    }
  }
}
