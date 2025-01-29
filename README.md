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

## Run with node script

```shell
node scripts/render-demo.js --certificatePath path_to_certificate --schemaType type --schemaVersion version
```

**Example:**

```shell
node scripts/render-demo.js --certificatePath ../test/fixtures/EN10168/v0.4.1/valid_certificate_2.json --schemaType EN10168 --schemaVersion v4.0.1
```

## OpenAPI / Swagger

http://localhost:8081/api-docs
http://localhost:8081/swagger-ui/index.html

## Working with Schemas

All schemas, certificates, stylesheets and fixtures can be found in the `./schemas` folder.
The filepath convention is as follows: `./schemas/<schema-type>/<version>/`.

To add a new version, create a new folder with the version as the name. When the schemas-service app is built,
the script `copy-resources.sh` will be run automatically and will copy across the needed `stylesheet.xsl` and `translations.json` files.

The file `schema.json` is obligatory, and for PDF validation valid `stylesheet.xsl` and `translations.json` files.

Rendering text fixtures should be added using the same file structure in the `fixtures` folder. Any `valid_certificate_*.json` files will be rendered and the result checked against the corresponding `valid_certificate_*.pdf` file.

## Converting Schemas from .JSON to .XML

To generate the XML schema from a JSON schema, run the following command from the root directory:

```shell
npm run json2xml <relative filepath to schema>
```

**Example:**

```shell
npm run json2xml test/fixtures/CoA/v1.1.0/valid_certificate_1.xml
```

It will save the resulting file to the same directory as the original .json file.
