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

## Endpoints
- `curl localhost:8080/hello`
- `curl localhost:8080/render`

```
curl -X POST 'http://localhost:8080/render?schemaType=CoA&schemaVersion=1.0' \
     -H 'Content-Type: application/json' \
     -d '{"key":"value", "anotherKey": {"nestedKey":"nestedValue"}}'
```




source env/bin/activate
