# Material Identity Schemas

[![License: Apache-2.0](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)
[![Latest release](https://img.shields.io/github/v/release/material-identity/schemas)](https://github.com/material-identity/schemas/releases/latest)
[![Security Vulnerability Scan](https://github.com/material-identity/schemas/actions/workflows/security-scan.yml/badge.svg)](https://github.com/material-identity/schemas/actions/workflows/security-scan.yml)

Open JSON schemas for digital material certificates, plus a service that
validates certificates against them and renders them as PDF.

Material certificates — mill test reports, certificates of analysis,
inspection documents — are still exchanged as PDFs that no system can read.
These schemas define the same content as structured, versioned JSON, so a
certificate can be validated, exchanged machine-to-machine, and still
rendered as a human-readable document when someone needs to look at it.

**What is here**

| Schema type | Describes | Current version | Canonical `$id` |
| --- | --- | --- | --- |
| EN10168 | Inspection documents for steel products per EN 10168 / EN 10204 | `v0.5.0` | `https://schemas.materialidentity.org/en10168-schemas/v0.5.0/schema.json` |
| CoA | Certificates of Analysis for plastics and other materials | `v1.1.0` | `https://schemas.s1seven.com/coa-schemas/v1.1.0/schema.json` |
| Metals | Digital Material Passport for metal products | `v0.1.1` | `https://schemas.materialidentity.org/metals-schemas/v0.1.1/schema.json` |
| ForestrySource | Digital Material Passport for forestry sources (harvest origin, EUDR due-diligence data) | `v1.1.0` | `https://schemas.materialidentity.org/forestry-source-schemas/v1.1.0/schema.json` |
| ForestryOutput | Digital Material Passport for forestry and wood products | `v1.0.0` | `https://schemas.materialidentity.org/forestry-output-schemas/v1.0.0/schema.json` |
| Forestry | Earlier combined forestry passport, predecessor of ForestrySource and ForestryOutput | `v0.0.1` | `https://schemas.s1seven.com/forestry-schemas/v0.0.1/schema.json` |
| E-CoC | Electronic Certificate of Conformity (schema only, no PDF rendering) | `v1.0.0` | `https://schemas.s1seven.com/e-coc-schemas/v1.0.0/schema.json` |

Newer versions publish their `$id` under `https://schemas.materialidentity.org/`;
older versions still declare `https://schemas.s1seven.com/`. Both hosts serve
the published schemas. Reference a schema by the `$id` declared in its
`schema.json`, not by a path into this repository.

Schema files live under `./schemas/<schema-type>/<version>/`. Each version
directory contains `schema.json`, plus `stylesheet.xsl` and
`translations.json` used for PDF rendering.

**The service** exposes a `POST /api/render` endpoint that turns a JSON
certificate into a PDF via XSLT and Apache FOP, with an OpenAPI/Swagger UI for
trying it out. See below to run it locally.

**Security and compliance.** Every pull request and push is scanned with
Grype and fails at medium severity or higher, and each release ships SPDX and
CycloneDX SBOMs, in line with the EU Cyber Resilience Act. Details in
[Security & Compliance](#security--compliance).

Licensed under [Apache-2.0](LICENSE). Contributions are welcome; see
[CONTRIBUTING.md](CONTRIBUTING.md).

> This repository previously lived as
> [CoA-schemas](https://github.com/material-identity/CoA-schemas),
> [EN10168-schemas](https://github.com/material-identity/EN10168-schemas) and
> [E-CoC-schemas](https://github.com/material-identity/E-CoC-schemas), with
> shared definitions in
> [schema-definitions](https://github.com/material-identity/schema-definitions).
> All four are now archived.

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

## Standalone PDF Generation

### Prerequisites

Before using the standalone PDF generation, you must build the project:

```shell
# Install dependencies and build the project
chmod +x copy-resources.sh && mvn clean install
```

This compiles the Java classes and copies all dependencies to the `target/` directory.

**Important**: If you get a `NoClassDefFoundError` or similar error, ensure dependencies are copied:
```shell
mvn dependency:copy-dependencies -DoutputDirectory=target/dependency
```

### Single Certificate Conversion

```shell
node scripts/json2pdf.js <input-file> [output-file]
```

The script automatically detects the schema type and version from the certificate. By default, it saves the PDF in the same directory as the input JSON file with the same name but .pdf extension.

**Examples:**

```shell
# Convert single certificate (output to same directory)
node scripts/json2pdf.js test/fixtures/EN10168/v0.4.1/valid_certificate_2.json
# Output: test/fixtures/EN10168/v0.4.1/valid_certificate_2.pdf

# Convert with custom output path
node scripts/json2pdf.js test/fixtures/EN10168/v0.4.1/valid_certificate_2.json output/custom.pdf

# Using npm script
npm run json2pdf -- certificate.json output.pdf
```

### Development Mode - Custom XSLT

For development and testing, you can provide a custom XSLT file path to override the default compiled XSLT:

```shell
# Use custom XSLT file for development
node scripts/json2pdf.js certificate.json --xsltPath ./schemas/EN10168/v0.5.0/stylesheet.xsl

# With input/output flags
node scripts/json2pdf.js --input cert.json --output result.pdf --xsltPath custom.xsl
```

This feature is particularly useful when developing or modifying XSLT stylesheets, as it allows you to test changes without rebuilding the entire project.

### Batch Processing

```shell
# Process all test fixtures
npm run render-all-pdf
```

This processes all JSON certificates in the `test/fixtures/` directory and outputs PDFs to the `tmp/` directory with comprehensive statistics.

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

### Public and private schemas

The schema types listed at the top of this README are public and versioned in
this repository. Some customer-specific schema types are not published here;
they are pulled from a private S3 bucket by the `copy-from-s3bucket` step,
which is only relevant to S1Seven team members with access to that bucket.
The service builds and runs with the public schemas alone. A few service tests
reference private fixtures and only pass with bucket access.

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

## Security & Compliance

### Vulnerability Scanning

This project uses [Grype](https://github.com/anchore/grype) for automated vulnerability scanning to ensure compliance with the EU Cyber Resilience Act (CRA). Vulnerability scans run automatically on:

- Every pull request
- Every push to `main`
- Weekly schedule (Mondays at 9 AM UTC)

**Severity Threshold**: Builds fail on **medium** severity or higher vulnerabilities.

**Viewing Results**:
- Navigate to the [Security tab](../../security) to view vulnerability reports
- Vulnerability reports are also available as workflow artifacts

**Configuration**: See [`.grype.yaml`](.grype.yaml) for scan configuration and ignore rules.

### Software Bill of Materials (SBOM)

In compliance with the EU Cyber Resilience Act, we automatically generate Software Bill of Materials (SBOM) for each release using [Syft](https://github.com/anchore/syft). SBOMs are available in both SPDX and CycloneDX formats as [release assets](../../releases).

**For detailed information**, see [README_SBOM.md](README_SBOM.md).

### Manual Security Operations

**Run vulnerability scan locally**:
```bash
# Install Grype
curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b /usr/local/bin

# Scan project
grype .
```

**Generate SBOM locally**:
```bash
# Install Syft
curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin

# Generate SPDX format
syft . -o spdx-json --file sbom-spdx.json

# Generate CycloneDX format
syft . -o cyclonedx-json --file sbom-cyclonedx.json
```

### Reporting Security Issues

Please report security vulnerabilities by opening a [security advisory](../../security/advisories/new) or contacting the security team directly.

## History

This repository consolidates the former
[CoA-schemas](https://github.com/material-identity/CoA-schemas),
[EN10168-schemas](https://github.com/material-identity/EN10168-schemas) and
[E-CoC-schemas](https://github.com/material-identity/E-CoC-schemas)
repositories and the shared definitions from
[schema-definitions](https://github.com/material-identity/schema-definitions).
All four are archived.
