package com.materialidentity.schemaservice.controller;

import com.fasterxml.jackson.databind.JsonNode;
import com.materialidentity.schemaservice.config.EndpointParamConstants;
import com.materialidentity.schemaservice.config.SchemasAndVersions;
import com.materialidentity.schemaservice.service.SchemasService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.xml.sax.SAXException;

import javax.xml.transform.TransformerException;
import java.io.IOException;
import java.util.Map;

@RestController
@RequestMapping("/api")
public class SchemaController {

    private final SchemasService schemasService;

    @Autowired
    public SchemaController(SchemasService schemasService) {
        this.schemasService = schemasService;
    }

    @PostMapping("/render")
    public ResponseEntity<byte[]> render(
            @RequestParam(EndpointParamConstants.SCHEMA_TYPE_PARAM) SchemasAndVersions.SchemaTypes schemaType,
            @RequestParam(EndpointParamConstants.SCHEMA_VERSION_PARAM) String schemaVersion,
            @RequestParam(EndpointParamConstants.LANGUAGES_PARAM) String[] languages,
            @RequestBody JsonNode certificate)
            throws TransformerException, IOException, SAXException {

        return schemasService.renderPdf(schemaType, schemaVersion, languages, certificate);
    }

    @PostMapping("/validate")
    public ResponseEntity<Map<String, Object>> validate(
            @RequestParam("schemaType") String schemaType,
            @RequestParam("schemaVersion") String schemaVersion,
            @RequestBody JsonNode jsonCertificate) throws IOException {

        return schemasService.validate(schemaType, schemaVersion, jsonCertificate);
    }

    @GetMapping("/schemas")
    private ResponseEntity<Map<String, Object>> getSchemas() throws IOException {
        return schemasService.getSchemas();
    }

}
