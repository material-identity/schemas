package com.materialidentity.schemaservice;

public final class Constants {
    // render endpoint constants
    protected static final String SCHEMAS_FOLDER_NAME = "schemas";
    protected static final String JSON_TRANSLATIONS_FILE_NAME_PATTERN = "translations*.json";
    protected static final String XSLT_FILE_NAME = "stylesheet.xsl";
    protected static final String PDF_ATTACHMENT_CERT_FILE_NAME = "certificate.json";
    protected static final String PDF_RENDERED_OUTPUT_FILE_NAME = "output.pdf";

    // validate endpoint constants
    protected static final String SCHEMA_DEFINITION_FILE_NAME = "schema.json";

    // schemas endpoint constants
    protected static final String SCHEMA_TYPES_FOLDER_NAME_PATTERN = "schemas/*";
    protected static final String SCHEMA_VERSIONS_FOLDER_NAME_PATTERN = "versions/*";

    private Constants() {
    }

}
