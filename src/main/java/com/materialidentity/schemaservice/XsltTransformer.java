package com.materialidentity.schemaservice;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.dataformat.xml.XmlMapper;
import lombok.Getter;
import net.sf.saxon.TransformerFactoryImpl;

import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.io.IOException;
import java.io.StringReader;
import java.io.StringWriter;

public class XsltTransformer {

    private final String xsltSource;
    @Getter
    private final JsonNode source;

    public XsltTransformer(String xsltSource, JsonNode source) {
        this.xsltSource = xsltSource;
        this.source = source;
    }

    public String transform() throws TransformerException, IOException {
        String xmlSource = jsonNodeToXml(source);

        Source xmlInput = new StreamSource(new StringReader(xmlSource));
        Source xsltInput = new StreamSource(new StringReader(xsltSource));
        StringWriter outputWriter = new StringWriter();

        TransformerFactory factory = new TransformerFactoryImpl();
        
        // Security: Disable external entity access to prevent XXE attacks
        // but allow file access for legitimate translation files
        factory.setAttribute("http://javax.xml.XMLConstants/property/accessExternalDTD", "");
        factory.setAttribute("http://javax.xml.XMLConstants/property/accessExternalStylesheet", "file");
        
        // Allow file access for json-doc() function to load translation files
        factory.setFeature("http://saxon.sf.net/feature/allow-external-functions", true);
        
        Transformer transformer = factory.newTransformer(xsltInput);
        transformer.transform(xmlInput, new StreamResult(outputWriter));

        String result = outputWriter.toString();
        
        return result;
    }

    private String jsonNodeToXml(JsonNode jsonNode) throws IOException {
        XmlMapper xmlMapper = new XmlMapper();
        return xmlMapper.writer().withRootName("Root").writeValueAsString(jsonNode);
    }
}
