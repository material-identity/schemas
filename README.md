# Schemas Service

## System Requirements
- Java version: 21

## Install packages

From root directory, run:

```shell
chmod +x copy-resources.sh && \
mvn clean install
```

## Compile

`mvn compile`

```
curl -X POST 'http://localhost:8081/render?schemaType=CoA&schemaVersion=1.0' \
     -H 'Content-Type: application/json' \
     -d '{"key":"value", "anotherKey": {"nestedKey":"nestedValue"}}'
```

## Start the service

`mvn exec:java -Dexec.mainClass="com.materialidentity.schemaservice.App"`

## Run the jar

`java -jar target/schema-service-1.0-SNAPSHOT.jar`

## Watch

`mvn spring-boot:run`

## Run tests

```shell
mvn test
```

## UI

To use the UI to interact with the service, run command:

```shell
cd ui && npm install
npm start
```

## Render PDF with node script

```shell
node scripts/render-pdf.js --certificatePath path_to_certificate [--output output_directory]
```

The script automatically detects the schema type and version from the certificate. By default, it saves the PDF in the same directory as the input JSON file with the same name but .pdf extension.

**Examples:**

```shell
# Render to same directory as input
node scripts/render-pdf.js --certificatePath test/fixtures/EN10168/v0.4.1/valid_certificate_2.json
# Output: test/fixtures/EN10168/v0.4.1/valid_certificate_2.pdf

# Render to specific output directory
node scripts/render-pdf.js --certificatePath test/fixtures/EN10168/v0.4.1/valid_certificate_2.json --output output/pdfs
# Output: output/pdfs/valid_certificate_2.pdf
```

## OpenAPI / Swagger

http://localhost:8081/api-docs
http://localhost:8081/swagger-ui/index.html

## Working with Schemas

All schemas, certificates, stylesheets and fixtures can be found in the `./schemas` folder.
The filepath convention is as follows: `./schemas/<schema-type>/<version>/`.

If you are a part of S1EVEN team and would like to test the app with private schemas, log in to dotenv using `npx dotenv-vault login` and pull using `npx dotenv-vault@latest pull` to get environment variables for running the script.
This will run the copy-from-s3bucket script which will pull all private schemas and fixtures.
To add a new version, create a new folder with the version as the name. When the schemas-service app is built,
the script `copy-resources.sh` will be run automatically and will copy across the needed `stylesheet.xsl` and `translations.json` files.

The file `schema.json` is obligatory, and for PDF validation valid `stylesheet.xsl` and `translations.json` files.

Rendering text fixtures should be added using the same file structure in the `fixtures` folder. Any `valid_certificate_*.json` files will be rendered and the result checked against the corresponding `valid_certificate_*.pdf` file.

## Converting JSON to .XML

### Purpose

The creation of a PDF from JSON is based on [Apache FOP](https://projects.apache.org/project.html?xmlgraphics-fop). The steps are:

1. JSON to XML Transformation

     The JSON is transformed to XML

2. XML + XSLT to FO Transformation

     The XSLT found next to the corresponding `schema.json` is applied to the XML from step 1. The output is a XSL-FO document.

3. FO to PDF Transformation

     An Apache FOP processes the XSL-FO to create the PDF.

The script generates the XML output of step 1.

### Usage

```shell
npm run json2xml <relative filepath to schema>
```

**Example:**

```shell
npm run json2xml test/fixtures/CoA/v1.1.0/valid_certificate_1.json
```

It will save the resulting file to the same directory as the original .json file.
