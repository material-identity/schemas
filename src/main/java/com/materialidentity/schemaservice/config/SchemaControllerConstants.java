package com.materialidentity.schemaservice.config;

public final class SchemaControllerConstants {
    // render endpoint constants
    public static final String SCHEMAS_FOLDER_NAME = "schemas";
    public static final String JSON_TRANSLATIONS_FILE_NAME_PATTERN = "translations*.json";
    public static final String XSLT_FILE_NAME = "stylesheet.xsl";
    public static final String DEFAULT_PDF_ATTACHMENT_CERT_FILE_NAME = "dmp.json";
    public static final String DEFAULT_PDF_ATTACHMENT_CERT_FILE_EXTENSION = ".json";
    public static final String PDF_RENDERED_OUTPUT_FILE_NAME = "output.pdf";

    // validate endpoint constants
    public static final String SCHEMA_DEFINITION_FILE_NAME = "schema.json";

    // schemas endpoint constants
    public static final String SCHEMA_TYPES_FOLDER_NAME_PATTERN = "schemas/*";
    public static final String SCHEMA_VERSIONS_FOLDER_NAME_PATTERN = "versions/*";

    private SchemaControllerConstants() {
    }
}
