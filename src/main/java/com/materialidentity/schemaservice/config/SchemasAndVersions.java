package com.materialidentity.schemaservice.config;

import java.util.List;
import java.util.Map;

public class SchemasAndVersions {
  public enum SchemaTypes {
    EN10168, CoA, TKR, Forestry, ForestrySource, Bluemint
  }

  public static final Map<SchemaTypes, List<String>> supportedSchemas = Map.of(
      SchemaTypes.CoA, List.of("v1.1.0"),
      SchemaTypes.TKR, List.of("v0.0.4"),
      SchemaTypes.EN10168, List.of("v0.4.1", "v0.5.0"),
      SchemaTypes.Forestry, List.of("v0.0.1"),
      SchemaTypes.ForestrySource, List.of("v0.0.1"),
      SchemaTypes.Bluemint, List.of("v1.0.0"));
}
