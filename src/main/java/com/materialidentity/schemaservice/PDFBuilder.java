package com.materialidentity.schemaservice;

import java.io.IOException;

import javax.xml.transform.TransformerException;

import org.xml.sax.SAXException;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.node.ObjectNode;

public class PDFBuilder {

    private final FoManager foManager;
    private TranslationLoader translationLoader;
    private AttachmentManager attachmentManager;
    private XsltTransformer xsltTransformer;
    private EmbedManager embedManager;

    public PDFBuilder(FoManager foManager) {
        this.foManager = foManager;
    }

    public PDFBuilder() {
        this.foManager = new FoManager();
    }

    public PDFBuilder withTranslations(TranslationLoader translationLoader) {
        this.translationLoader = translationLoader;
        return this;
    }

    public PDFBuilder withXsltTransformer(XsltTransformer xsltTransformer) {
        this.xsltTransformer = xsltTransformer;
        return this;
    }

    public PDFBuilder withAttachment(AttachmentManager attachmentManager) {
        this.attachmentManager = attachmentManager;
        return this;
    }

    public PDFBuilder withEmbeddedPdf(EmbedManager embedManager) {
        this.embedManager = embedManager;
        return this;
    }

    public byte[] build() throws TransformerException, IOException, SAXException {
        byte[] pdf = generatePdf();
        return pdf;
    }

    private byte[] generatePdf() throws TransformerException, IOException, SAXException {
        if (xsltTransformer != null) {
            // Attach translations to the dmp
            if (translationLoader != null) {
                JsonNode translations = translationLoader.load();
                ((ObjectNode) xsltTransformer.getSource()).set("Translations", translations);
            }

            // Process the xslt input
            String xslFoInput = xsltTransformer.transform();

            byte[] pdf = foManager.generatePdf(xslFoInput);

            if (embedManager != null) {
                pdf = embedManager.embed(pdf);
            }

            if (attachmentManager != null) {
                pdf = attachmentManager.attach(pdf);
            }
            return pdf;
        }

        return foManager.generatePdf();
    }
}
