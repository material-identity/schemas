package com.materialidentity.schemaservice.config;

import com.fasterxml.jackson.databind.node.JsonNodeFactory;
import org.springframework.boot.autoconfigure.jackson.Jackson2ObjectMapperBuilderCustomizer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * Preserves certificate numbers exactly as submitted through the app-wide Jackson
 * {@code ObjectMapper} bean (used to parse {@code @RequestBody JsonNode} in {@link
 * com.materialidentity.schemaservice.controller.SchemaController}).
 *
 * <p>{@code spring.jackson.deserialization.use-big-decimal-for-floats} (application.yml) alone is
 * not sufficient: it parses JSON floats as {@link java.math.BigDecimal} instead of {@code double},
 * but Jackson's tree-building deserializer still normalizes ("strips trailing zeros from") the
 * resulting BigDecimal by default — e.g. {@code 250.0} becomes scale -1 internally, which then
 * renders as {@code 2.5E+2} once serialized to XML for the legacy render pipeline. Configuring the
 * {@link JsonNodeFactory} to keep exact BigDecimals prevents that normalization, so a value is
 * preserved verbatim end to end.
 */
@Configuration
public class JacksonConfig {

  @Bean
  public Jackson2ObjectMapperBuilderCustomizer exactBigDecimalNodeFactoryCustomizer() {
    return builder -> builder.postConfigurer(
        mapper -> mapper.setNodeFactory(JsonNodeFactory.withExactBigDecimals(true)));
  }
}
