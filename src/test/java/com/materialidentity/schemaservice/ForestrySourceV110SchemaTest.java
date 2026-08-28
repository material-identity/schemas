package com.materialidentity.schemaservice;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Set;

import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.networknt.schema.JsonSchema;
import com.networknt.schema.JsonSchemaFactory;
import com.networknt.schema.SpecVersion;
import com.networknt.schema.ValidationMessage;

class ForestrySourceV110SchemaTest {

  private static final ObjectMapper OBJECT_MAPPER = new ObjectMapper();
  private static JsonSchema schema;
  private static JsonNode baseCertificate;

  @BeforeAll
  static void loadSchemaAndFixture() throws Exception {
    JsonNode schemaNode = OBJECT_MAPPER.readTree(
        Files.readString(Path.of("schemas", "ForestrySource", "v1.1.0", "schema.json")));
    schema = JsonSchemaFactory.getInstance(SpecVersion.VersionFlag.V201909).getSchema(schemaNode);
    baseCertificate = OBJECT_MAPPER.readTree(Files.readString(Path.of(
        "test", "fixtures", "ForestrySource", "v1.1.0", "valid_forestry_source_DMP_01.json")));
  }

  @Test
  void validatesPercentageBoundariesAndPrecision() throws Exception {
    assertValid(withMeasurements("{\"PercentageEstimationOrDeviation\":125.125}"));
    assertInvalid(withMeasurements("{\"PercentageEstimationOrDeviation\":0}"));
    assertInvalid(withMeasurements("{\"PercentageEstimationOrDeviation\":-1}"));
    assertInvalid(withMeasurements("{\"PercentageEstimationOrDeviation\":12.3456}"));
  }

  @Test
  void validatesSixDecimalQuantityBounds() throws Exception {
    assertValid(withMeasurements("{\"NetWeight\":{\"Value\":9999999999.999999,\"Unit\":\"kg\"}}"));
    assertInvalid(withMeasurements("{\"NetWeight\":{\"Value\":0,\"Unit\":\"kg\"}}"));
    assertInvalid(withMeasurements("{\"NetWeight\":{\"Value\":-1,\"Unit\":\"kg\"}}"));
    assertInvalid(withMeasurements("{\"NetWeight\":{\"Value\":10000000000,\"Unit\":\"kg\"}}"));
    assertInvalid(withMeasurements("{\"NetWeight\":{\"Value\":1.0000001,\"Unit\":\"kg\"}}"));

    assertValid(withMeasurements(
        "{\"SupplementaryUnit\":{\"Value\":9999999999.999999,\"Unit\":\"ton (short)\",\"Qualifier\":\"STN\",\"DisplayUnit\":\"US Short Tons\"}}"));
    assertInvalid(withMeasurements(
        "{\"SupplementaryUnit\":{\"Value\":0,\"Unit\":\"ton (short)\",\"Qualifier\":\"STN\",\"DisplayUnit\":\"US Short Tons\"}}"));
    assertInvalid(withMeasurements(
        "{\"SupplementaryUnit\":{\"Value\":-1,\"Unit\":\"ton (short)\",\"Qualifier\":\"STN\",\"DisplayUnit\":\"US Short Tons\"}}"));
    assertInvalid(withMeasurements(
        "{\"SupplementaryUnit\":{\"Value\":10000000000,\"Unit\":\"ton (short)\",\"Qualifier\":\"STN\",\"DisplayUnit\":\"US Short Tons\"}}"));
    assertInvalid(withMeasurements(
        "{\"SupplementaryUnit\":{\"Value\":1.0000001,\"Unit\":\"ton (short)\",\"Qualifier\":\"STN\",\"DisplayUnit\":\"US Short Tons\"}}"));
  }

  @Test
  void validatesSupplementaryQualifier() throws Exception {
    assertValid(withMeasurements(
        "{\"SupplementaryUnit\":{\"Value\":1.123456,\"Unit\":\"ton (short)\",\"Qualifier\":\"STN\",\"DisplayUnit\":\"US Short Tons\"}}"));
    assertInvalid(withMeasurements(
        "{\"SupplementaryUnit\":{\"Value\":1,\"Unit\":\"ton (short)\",\"DisplayUnit\":\"US Short Tons\"}}"));
    assertInvalid(withMeasurements(
        "{\"SupplementaryUnit\":{\"Value\":1,\"Unit\":\"ton (short)\",\"Qualifier\":\"TO\",\"DisplayUnit\":\"US Short Tons\"}}"));
    assertInvalid(withMeasurements(
        "{\"SupplementaryUnit\":{\"Value\":1,\"Unit\":\"ton (short)\",\"Qualifier\":\"TONNE\",\"DisplayUnit\":\"US Short Tons\"}}"));
  }

  @Test
  void requiresAtLeastOneMeasurement() throws Exception {
    assertInvalid(withMeasurements("{}"));
  }

  private static JsonNode withMeasurements(String measurementsJson) throws Exception {
    JsonNode certificate = baseCertificate.deepCopy();
    ObjectNode species = (ObjectNode) certificate.at("/DigitalMaterialPassport/Products/0/ListOfSpecies/0");
    species.set("Measurements", OBJECT_MAPPER.readTree(measurementsJson));
    return certificate;
  }

  private static void assertValid(JsonNode certificate) {
    Set<ValidationMessage> messages = schema.validate(certificate);
    assertTrue(messages.isEmpty(), () -> "Expected valid certificate, got: " + messages);
  }

  private static void assertInvalid(JsonNode certificate) {
    assertFalse(schema.validate(certificate).isEmpty(), "Expected certificate to be invalid");
  }
}
