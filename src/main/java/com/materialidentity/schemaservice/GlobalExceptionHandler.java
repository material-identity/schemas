package com.materialidentity.schemaservice;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.materialidentity.schemaservice.apiexception.ApiError;
import io.sentry.Sentry;
import lombok.extern.slf4j.Slf4j;
import org.apache.fop.apps.FOPException;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler;
import org.xml.sax.SAXException;

import javax.xml.transform.TransformerException;
import java.io.IOException;

@Slf4j
@Order(Ordered.HIGHEST_PRECEDENCE)
@ControllerAdvice
public class GlobalExceptionHandler extends ResponseEntityExceptionHandler {

    @ExceptionHandler(JsonProcessingException.class)
    protected ResponseEntity<Object> handleJsonProcessingException(JsonProcessingException e) {
        Sentry.captureException(e);
        ApiError apiError = new ApiError(HttpStatus.BAD_REQUEST);
        log.error("Error processing json certificate", e);
        apiError.setMessage("\"There was a problem processing the uploaded JSON certificate. Please check the JSON structure and try again.\"");
        return new ResponseEntity<>(apiError, apiError.getStatus());
    }

    @ExceptionHandler(IOException.class)
    protected ResponseEntity<Object> handleIOException(IOException e) {
        Sentry.captureException(e);
        ApiError apiError = new ApiError(HttpStatus.BAD_REQUEST);
        log.error("I/O error occurred", e);
        apiError.setMessage("An I/O error occurred. Please try again.");
        return new ResponseEntity<>(apiError, apiError.getStatus());
    }

    @ExceptionHandler(FOPException.class)
    protected ResponseEntity<Object> handleFOPException(FOPException e) {
        Sentry.captureException(e);
        ApiError apiError = new ApiError(HttpStatus.INTERNAL_SERVER_ERROR);
        log.error("Error during PDF generation", e);
        apiError.setMessage("A PDF generation error occurred. Please try again.");
        return new ResponseEntity<>(apiError, apiError.getStatus());
    }

    @ExceptionHandler(TransformerException.class)
    protected ResponseEntity<Object> handleTransformerException(TransformerException e) {
        Sentry.captureException(e);
        ApiError apiError = new ApiError(HttpStatus.INTERNAL_SERVER_ERROR);
        log.error("Error transforming XML", e);
        apiError.setMessage("An error occurred while transforming XML. Please check the XML and try again.");
        return new ResponseEntity<>(apiError, apiError.getStatus());
    }

    @ExceptionHandler(SAXException.class)
    protected ResponseEntity<Object> handleSAXException(SAXException e) {
        Sentry.captureException(e);
        ApiError apiError = new ApiError(HttpStatus.BAD_REQUEST);
        log.error("SAX error occurred", e);
        apiError.setMessage("An error occurred while parsing XML. Please check the XML and try again.");
        return new ResponseEntity<>(apiError, apiError.getStatus());
    }
}
