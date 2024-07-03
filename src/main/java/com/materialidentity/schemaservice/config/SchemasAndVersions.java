package com.materialidentity.schemaservice.config;

import java.util.List;
import java.util.Map;

public class SchemasAndVersions {
  public enum SchemaTypes {
    EN10168, CoA, TKR
  }

  public static final Map<SchemaTypes, List<String>> supportedSchemas = Map.of(
      SchemaTypes.CoA, List.of("v1.1.0"),
      SchemaTypes.TKR, List.of("v0.0.4"),
      SchemaTypes.EN10168, List.of("v0.4.1"));
}
