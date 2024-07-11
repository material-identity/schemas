package com.materialidentity.schemaservice.controller;

import com.fasterxml.jackson.databind.JsonNode;
import com.materialidentity.schemaservice.config.EndpointParamConstants;
import com.materialidentity.schemaservice.config.SchemasAndVersions;
import com.materialidentity.schemaservice.service.SchemasService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.xml.sax.SAXException;

import javax.xml.transform.TransformerException;
import java.io.IOException;
import java.util.Map;

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
            @RequestParam(EndpointParamConstants.SCHEMA_TYPE_PARAM) SchemasAndVersions.SchemaTypes schemaType,
            @RequestParam(EndpointParamConstants.SCHEMA_VERSION_PARAM) String schemaVersion,
            @RequestParam(EndpointParamConstants.LANGUAGES_PARAM) String[] languages,
            @RequestParam(value = EndpointParamConstants.ATTACH_JSON, defaultValue = "true") Boolean attachJson,
            @RequestBody JsonNode certificate) throws TransformerException, IOException, SAXException {
        return schemasService.renderPdf(schemaType, schemaVersion, languages, attachJson, certificate);
    }

    @PostMapping("/render-certificate")
    @ResponseStatus(code = HttpStatus.OK)
    @Operation(summary = "Render a JSON certificate as a PDF")
    public ResponseEntity<byte[]> render(
            @RequestParam(value = EndpointParamConstants.ATTACH_JSON, defaultValue = "true") Boolean attachJson,
            @RequestBody JsonNode certificate) throws TransformerException, IOException, SAXException {
        return schemasService.renderCertificateAsPdf(attachJson, certificate);
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
    private ResponseEntity<Map<String, Object>> getSchemas() throws IOException {
        return schemasService.getSchemas();
    }

}
