package com.materialidentity.schemaservice.controller;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.xml.transform.TransformerException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import org.xml.sax.SAXException;

import com.fasterxml.jackson.databind.JsonNode;
import com.materialidentity.schemaservice.config.EndpointParamConstants;
import com.materialidentity.schemaservice.service.SchemasService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;

@RestController
@RequestMapping("/api")
@Tag(name = "Schemas Controller", description = "This REST controller provides endpoints to render and validate JSON certificates")
public class SchemaController {

    private final SchemasService schemasService;

    @Autowired
    public SchemaController(SchemasService schemasService) {
        this.schemasService = schemasService;
    }

    @PostMapping("/render")
    @ResponseStatus(code = HttpStatus.OK)
    @Operation(summary = "Render a JSON certificate as a PDF")
    public ResponseEntity<byte[]> render(
            @RequestParam(value = EndpointParamConstants.ATTACH_JSON, defaultValue = "true") Boolean attachJson,
            @RequestBody JsonNode certificate) throws TransformerException, IOException, SAXException {
        return schemasService.renderPdf(attachJson, certificate);
    }

    @PostMapping("/validate")
    @ResponseStatus(code = HttpStatus.OK)
    @Operation(summary = "Validate a JSON certificate against a schema")
    public ResponseEntity<Map<String, Object>> validate(@RequestParam("schemaType") String schemaType,
            @RequestParam("schemaVersion") String schemaVersion, @RequestBody JsonNode jsonCertificate)
            throws IOException {
        return schemasService.validate(schemaType, schemaVersion, jsonCertificate);
    }

    @GetMapping("/schemas")
    @ResponseStatus(code = HttpStatus.OK)
    @Operation(summary = "List the supported schemas and versions")
    private ResponseEntity<Map<String, List<String>>> getSchemas() throws IOException {
        return schemasService.getSchemas();
    }

    @GetMapping("/health")
    @ResponseStatus(HttpStatus.OK)
    public ResponseEntity<String> checkHealth() {
        return new ResponseEntity<>("API is running", HttpStatus.OK);
    }

}
