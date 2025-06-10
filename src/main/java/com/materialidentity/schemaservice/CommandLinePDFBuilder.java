package com.materialidentity.schemaservice;

import java.io.IOException;
import java.net.URISyntaxException;

import javax.xml.transform.TransformerException;

import org.xml.sax.SAXException;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.node.ObjectNode;

/**
 * Command-line specific PDF Builder that uses CommandLineFoManager
 * to handle font loading for standalone usage.
 */
public class CommandLinePDFBuilder {

    private final CommandLineFoManager foManager;
    private TranslationLoader translationLoader;
    private AttachmentManager attachmentManager;
    private XsltTransformer xsltTransformer;
    private EmbedManager embedManager;

    public CommandLinePDFBuilder(CommandLineFoManager foManager) {
        this.foManager = foManager;
    }

    public CommandLinePDFBuilder() {
        this.foManager = new CommandLineFoManager();
    }

    public CommandLinePDFBuilder withTranslations(TranslationLoader translationLoader) {
        this.translationLoader = translationLoader;
        return this;
    }

    public CommandLinePDFBuilder withXsltTransformer(XsltTransformer xsltTransformer) {
        this.xsltTransformer = xsltTransformer;
        return this;
    }

    public CommandLinePDFBuilder withAttachment(AttachmentManager attachmentManager) {
        this.attachmentManager = attachmentManager;
        return this;
    }

    public CommandLinePDFBuilder withEmbeddedPdf(EmbedManager embedManager) {
        this.embedManager = embedManager;
        return this;
    }

    public byte[] build() throws TransformerException, IOException, SAXException, URISyntaxException {
        byte[] pdf = generatePdf();
        return pdf;
    }

    private byte[] generatePdf() throws TransformerException, IOException, SAXException, URISyntaxException {
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