package com.materialidentity.schemaservice;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.dataformat.xml.XmlMapper;
import lombok.Getter;
import net.sf.saxon.TransformerFactoryImpl;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.io.IOException;
import java.io.StringReader;
import java.io.StringWriter;
import org.w3c.dom.Document;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

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

        // Security: Parse XML with secure DocumentBuilder to prevent XXE attacks
        Source xmlInput;
        try {
            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
            dbf.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
            dbf.setFeature("http://xml.org/sax/features/external-general-entities", false);
            dbf.setFeature("http://xml.org/sax/features/external-parameter-entities", false);
            dbf.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", false);
            dbf.setXIncludeAware(false);
            dbf.setExpandEntityReferences(false);
            DocumentBuilder db = dbf.newDocumentBuilder();
            Document doc = db.parse(new InputSource(new StringReader(xmlSource)));
            xmlInput = new DOMSource(doc);
        } catch (ParserConfigurationException | SAXException e) {
            throw new TransformerException("Failed to parse XML securely", e);
        }

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
        // Disable external entity processing to prevent XXE attacks
        xmlMapper.getFactory().setXMLInputFactory(createSecureXMLInputFactory());
        return xmlMapper.writer().withRootName("Root").writeValueAsString(jsonNode);
    }
    
    private javax.xml.stream.XMLInputFactory createSecureXMLInputFactory() {
        javax.xml.stream.XMLInputFactory factory = javax.xml.stream.XMLInputFactory.newInstance();
        // Disable all external entity processing
        factory.setProperty(javax.xml.stream.XMLInputFactory.IS_SUPPORTING_EXTERNAL_ENTITIES, false);
        factory.setProperty(javax.xml.stream.XMLInputFactory.SUPPORT_DTD, false);
        return factory;
    }
}
