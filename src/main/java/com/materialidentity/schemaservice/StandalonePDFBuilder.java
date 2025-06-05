package com.materialidentity.schemaservice;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import org.xml.sax.SAXException;

import javax.xml.transform.TransformerException;
import java.io.IOException;

/**
 * PDF Builder that works with the new standalone components.
 * This version uses the abstracted resource loading and FO management.
 */
public class StandalonePDFBuilder {

    private StandaloneFoManager foManager;
    private StandaloneTranslationLoader translationLoader;
    private AttachmentManager attachmentManager;
    private XsltTransformer xsltTransformer;
    private EmbedManager embedManager;

    public StandalonePDFBuilder(StandaloneFoManager foManager) {
        this.foManager = foManager;
    }

    public StandalonePDFBuilder() {
        // Default constructor - foManager will be set later
    }

    public StandalonePDFBuilder withTranslations(StandaloneTranslationLoader translationLoader) {
        this.translationLoader = translationLoader;
        return this;
    }

    public StandalonePDFBuilder withXsltTransformer(XsltTransformer xsltTransformer) {
        this.xsltTransformer = xsltTransformer;
        return this;
    }

    public StandalonePDFBuilder withAttachment(AttachmentManager attachmentManager) {
        this.attachmentManager = attachmentManager;
        return this;
    }

    public StandalonePDFBuilder withEmbeddedPdf(EmbedManager embedManager) {
        this.embedManager = embedManager;
        return this;
    }

    public StandalonePDFBuilder withFoManager(StandaloneFoManager foManager) {
        this.foManager = foManager;
        return this;
    }

    public byte[] build() throws TransformerException, IOException, SAXException {
        return generatePdf();
    }

    private byte[] generatePdf() throws TransformerException, IOException, SAXException {
        if (xsltTransformer != null) {
            // Attach translations to the certificate
            if (translationLoader != null) {
                JsonNode translations = translationLoader.load();
                ((ObjectNode) xsltTransformer.getSource()).set("Translations", translations);
            }

            // Transform JSON to XSL-FO
            String xslFo = xsltTransformer.transform();

            // Generate PDF from XSL-FO
            byte[] pdfData;
            if (foManager != null) {
                pdfData = foManager.generatePdf(xslFo);
            } else {
                throw new IllegalStateException("FoManager is required but not set");
            }

            // Attach the JSON if needed
            if (attachmentManager != null) {
                pdfData = attachmentManager.attach(pdfData);
            }

            // Embed external PDFs if present
            if (embedManager != null) {
                pdfData = embedManager.embed(pdfData);
            }

            return pdfData;
        }

        throw new IllegalStateException("XsltTransformer is required but not set");
    }
}