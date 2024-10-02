package com.materialidentity.schemaservice.service;

import java.io.IOException;

import javax.xml.transform.TransformerException;

import org.springframework.http.ResponseEntity;
import org.xml.sax.SAXException;

import com.fasterxml.jackson.databind.JsonNode;

public interface SchemasService {
        ResponseEntity<byte[]> renderPdf(Boolean attachJson, JsonNode certificate)
                        throws IOException, TransformerException, SAXException;
}
