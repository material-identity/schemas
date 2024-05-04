package com.materialidentity.schemaservice;

import com.fasterxml.jackson.databind.ObjectMapper;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.LinkedHashMap;
import java.util.Map;
import javax.xml.transform.TransformerException;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.xml.sax.SAXException;

@ControllerAdvice
public class GlobalExceptionHandler {

  @ExceptionHandler(
    { TransformerException.class, IOException.class, SAXException.class }
  )
  public ResponseEntity<byte[]> handleServerExceptions(Exception ex) {
    // Log the exception
    System.out.println(ex); // Use a proper logger in production environments

    // Create error details map
    Map<String, Object> errorDetails = new LinkedHashMap<>();
    errorDetails.put("timestamp", System.currentTimeMillis());
    errorDetails.put("status", HttpStatus.INTERNAL_SERVER_ERROR.value());
    errorDetails.put("error", "Internal Server Error");
    errorDetails.put("message", ex.getMessage());
    errorDetails.put("type", ex.getClass().getSimpleName());

    // Convert map to JSON then to byte array
    byte[] responseBytes = convertMapToJsonBytes(errorDetails);

    // Creating HttpHeaders
    HttpHeaders headers = new HttpHeaders();
    headers.add(HttpHeaders.CONTENT_TYPE, "application/json");

    return ResponseEntity
      .status(HttpStatus.INTERNAL_SERVER_ERROR)
      .headers(headers)
      .body(responseBytes);
  }

  private byte[] convertMapToJsonBytes(Map<String, Object> map) {
    ObjectMapper mapper = new ObjectMapper();
    try {
      String json = mapper.writeValueAsString(map);
      return json.getBytes(StandardCharsets.UTF_8);
    } catch (IOException e) {
      // In case of failure in converting to JSON
      return new byte[0];
    }
  }
}
