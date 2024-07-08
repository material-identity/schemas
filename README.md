# Schemas Service

## Start the service

`mvn exec:java -Dexec.mainClass="com.materialidentity.schemaservice.App"`

## Run the jar

`java -jar target/schema-service-1.0-SNAPSHOT.jar`

## Watch

`mvn spring-boot:run`

## Install packages

`mvn install`

## Compile

`mvn compile`

## Endpoints

- `curl localhost:8080/hello`
- `curl localhost:8080/render`

```
curl -X POST 'http://localhost:8080/render?schemaType=CoA&schemaVersion=1.0' \
     -H 'Content-Type: application/json' \
     -d '{"key":"value", "anotherKey": {"nestedKey":"nestedValue"}}'
```

## OpenAPI / Swagger

http://localhost:8081/api-docs
http://localhost:8081/swagger-ui/index.html

## Working with Schemas

All schemas, certificates, stylesheets and fixtures can be found in the `./schemas` folder.
The filepath convention is as follows: `./schemas/<schema-type>/<version>/`.

To add a new version, create a new folder with the version as the name. When the schemas-service app is built,
the script `copy-resources.sh` will be run automatically and will copy across the needed `stylesheet.xsl` and `translations.json` files.
