package com.materialidentity.schemaservice.service;

import com.fasterxml.jackson.databind.JsonNode;
import org.springframework.http.ResponseEntity;
import org.xml.sax.SAXException;

import javax.xml.transform.TransformerException;
import java.io.IOException;
import java.util.List;
import java.util.Map;

public interface SchemasService {
        ResponseEntity<byte[]> renderPdf(Boolean attachJson, JsonNode certificate)
                        throws IOException, TransformerException, SAXException;

        ResponseEntity<Map<String, Object>> validate(String schemaType, String schemaVersion, JsonNode jsonCertificate)
                        throws IOException;

        ResponseEntity<Map<String, List<String>>> getSchemas() throws IOException;
}
