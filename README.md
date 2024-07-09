# Schem Service

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

```
curl -X POST 'http://localhost:8081/render?schemaType=CoA&schemaVersion=1.0' \
     -H 'Content-Type: application/json' \
     -d '{"key":"value", "anotherKey": {"nestedKey":"nestedValue"}}'
```

source env/bin/activate

## OpenAPI / Swagger

http://localhost:8081/api-docs
http://localhost:8081/swagger-ui/index.html