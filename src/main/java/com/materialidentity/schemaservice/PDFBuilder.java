package com.materialidentity.schemaservice;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.node.ObjectNode;

public class PDFBuilder {

  private TranslationLoader translationLoader;
  private AttachmentManager attachmentManager;
  private FoManager foManager;
  private XsltTransformer xsltTransformer;

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

  public byte[] build() throws Exception {
    byte[] pdf = generatePdf();
    return attachmentManager == null ? pdf : attachmentManager.attach(pdf);
  }

  private byte[] generatePdf()
    throws Exception {
    if (xsltTransformer != null) {
      // Attach translations to the certificate
      if (translationLoader != null) {
        JsonNode translations = translationLoader.load();
        ((ObjectNode) xsltTransformer.getSource()).set(
            "Translations",
            translations
          );
      }

      // Process the xslt input
      String xslFoInput = xsltTransformer.transform();
      return foManager.generatePdf(xslFoInput);
    }

    return foManager.generatePdf();
  }
}
