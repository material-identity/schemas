# Format Extension

## Aspect Overview

### Aspect Name
**Name**: Format Extension (General Concept)

### Aspect Category
- [ ] Physical Properties
- [ ] Chemical Properties
- [ ] Delivery Conditions
- [ ] Processing Information
- [ ] Quality Attributes
- [ ] Compliance Data
- [ ] Sustainability Metrics
- [x] Other: **Schema Management & Extensibility**

### Priority
- [x] Core (Required)
- [ ] Standard (Recommended)
- [ ] Extended (Optional)

## Purpose

The extension mechanism allows the Digital Material Passport (DMP) to remain stable while enabling industry-specific schemas to replace or enhance generic sections. This ensures the DMP schema never needs modification when new industry standards emerge.

## Data Structure

### Primary Data Elements
List the main data fields for this aspect:

| Field Name | Data Type | Required | Description | Example |
|------------|-----------|----------|-------------|---------|
| ExtensionId | string | Yes | Unique identifier for the extension | "pcf-catena-x-v7" |
| ExtensionName | string | Yes | Human-readable name of the extension | "Product Carbon Footprint (Catena-X)" |
| Version | string | Yes | Version of the extension schema | "7.0.0" |
| ExtensionType | string | Yes | Type of extension application | "replacement" |
| TargetPath | string | Yes | JSON path in DMP being extended | "Sustainability.CarbonFootprint" |
| Namespace | string | Yes | Namespace URI for the extension | "urn:io.catenax.pcf:datamodel" |
| SchemaUrl | string | Yes | URL to the JSON schema definition | "https://github.com/eclipse-tractusx/.../Pcf-schema.json" |
| Description | string | No | Description of the extension purpose | "Replaces generic carbon footprint with Catena-X PCF" |
| Provider | string | Yes | Organization providing the extension | "Catena-X Automotive Network" |
| Compatibility | array | Yes | Compatible base format versions | ["v1.0", "v1.1"] |
| ValidationMode | string | Yes | How to validate the extended section | "exclusive" |
| MigrationPath | object | No | Mapping from base schema to extension | {"TotalCO2Equivalent": "pcf.pcfExcludingBiogenic"} |

### Sub-aspects

#### Sub-aspect 1: Extension Identity
- **Description**: Core identification and metadata for the extension
- **Data Elements**:
  - ExtensionId (unique identifier)
  - ExtensionName (display name)
  - Version (extension schema version)
  - Provider (maintaining organization)
  - Description (purpose and scope)

#### Sub-aspect 2: Extension Application
- **Description**: How the extension modifies the base schema
- **Data Elements**:
  - ExtensionType (replacement, supplement, transform)
  - TargetPath (JSON path being extended)
  - ValidationMode (exclusive, merged, override)
  - SchemaUrl (replacement/supplemental schema)

#### Sub-aspect 3: Compatibility & Migration
- **Description**: Version compatibility and data migration support
- **Data Elements**:
  - Compatibility (supported DMP versions)
  - MigrationPath (field mappings)
  - Dependencies (required extensions)
  - ConflictResolution (handling overlaps)

## Validation Rules

### Required Validations
- `ExtensionId` must be unique across all registered extensions
- `TargetPath` must be a valid JSON path in the base DMP schema
- `SchemaUrl` must be accessible and return valid JSON schema
- `Version` must follow semantic versioning (SemVer)
- `ExtensionType` must be a valid type

### Format Validations
- `ExtensionId` must follow naming convention (lowercase, hyphens, no spaces)
- `TargetPath` uses dot notation (e.g., "Sustainability.CarbonFootprint")
- `Version` must match pattern: `^\d+\.\d+\.\d+(-[a-zA-Z0-9-]+)?$`
- `ValidationMode` must be one of: exclusive, merged, override

### Business Rules
- Replacement extensions completely override the target section
- Only one extension can target the same path in replacement mode
- Extensions must maintain backward compatibility within major versions
- Migration paths should cover all required fields

## Extension Types

### Replacement
- **Purpose**: Complete replacement of a DMP section with industry-specific schema
- **Example**: Catena-X PCF replaces generic CarbonFootprint
- **Validation**: Only the extension schema is used

### Supplement
- **Purpose**: Add additional fields to existing structure
- **Example**: Adding industry-specific fields alongside base fields
- **Validation**: Both base and extension schemas apply

### Transform
- **Purpose**: Modify validation rules or constraints
- **Example**: Stricter tolerances for aerospace applications
- **Validation**: Modified rules replace base rules

## Use Cases

### Primary Use Cases
1. **Industry Standards Integration**: Catena-X for automotive, RMI for steel, etc.
2. **Regional Compliance**: Country-specific regulatory requirements
3. **Sector Requirements**: Industry-specific data models
4. **Future Standards**: New standards without DMP modification

### Integration Points
Where does this aspect connect with other parts of the format?
- **All DMP Sections**: Any section can be extended
- **Validation Engine**: Routes validation to appropriate schemas
- **Schema Registry**: Central management of extensions
- **Data Exchange**: Industry-specific data formats

## Implementation Considerations

### Technical Requirements
- JSON Schema validation with dynamic schema loading
- Path-based section replacement mechanism
- Extension registry for discovery
- Schema version management
- Validation routing based on active extensions

### Standards Compliance
- JSON Schema Draft 2020-12 or compatible
- Semantic versioning for extensions
- Industry-standard naming conventions
- Standard JSON Path notation

### Industry Practices
- Extensions published by industry consortiums
- Open source schema repositories
- Version alignment with industry standards
- Clear documentation and examples

## JSON Schema Example

```json
{
  "type": "object",
  "properties": {
    "ExtensionMetadata": {
      "type": "object",
      "properties": {
        "ExtensionId": {
          "type": "string",
          "pattern": "^[a-z0-9]+(-[a-z0-9]+)*$",
          "description": "Unique identifier for the extension"
        },
        "ExtensionName": {
          "type": "string",
          "minLength": 1,
          "maxLength": 100
        },
        "Version": {
          "type": "string",
          "pattern": "^\\d+\\.\\d+\\.\\d+(-[a-zA-Z0-9-]+)?$"
        },
        "ExtensionType": {
          "type": "string",
          "enum": ["replacement", "supplement", "transform"],
          "description": "How the extension modifies the base schema"
        },
        "TargetPath": {
          "type": "string",
          "pattern": "^[A-Za-z][A-Za-z0-9]*(\\.[A-Za-z][A-Za-z0-9]*)*$",
          "description": "JSON path to the section being extended"
        },
        "Namespace": {
          "type": "string",
          "format": "uri"
        },
        "SchemaUrl": {
          "type": "string",
          "format": "uri",
          "description": "URL to the extension schema"
        },
        "Provider": {
          "type": "string",
          "minLength": 1
        },
        "Compatibility": {
          "type": "array",
          "items": {
            "type": "string",
            "pattern": "^v\\d+\\.\\d+$"
          },
          "minItems": 1
        },
        "ValidationMode": {
          "type": "string",
          "enum": ["exclusive", "merged", "override"],
          "description": "How validation is performed"
        },
        "MigrationPath": {
          "type": "object",
          "additionalProperties": {
            "type": "string"
          },
          "description": "Field mappings from base to extension"
        },
        "ConflictResolution": {
          "type": "string",
          "enum": ["error", "extension-wins", "base-wins"],
          "default": "error"
        }
      },
      "required": [
        "ExtensionId", 
        "ExtensionName", 
        "Version", 
        "ExtensionType",
        "TargetPath",
        "SchemaUrl", 
        "Provider", 
        "Compatibility",
        "ValidationMode"
      ]
    }
  }
}
```

## Sample Data

### Example 1: Catena-X PCF Extension (Replacement)
```json
{
  "ExtensionMetadata": {
    "ExtensionId": "pcf-catena-x-v7",
    "ExtensionName": "Product Carbon Footprint (Catena-X)",
    "Version": "7.0.0",
    "ExtensionType": "replacement",
    "TargetPath": "Sustainability.CarbonFootprint",
    "Namespace": "urn:io.catenax.pcf:datamodel",
    "SchemaUrl": "https://github.com/eclipse-tractusx/sldt-semantic-models/blob/main/io.catenax.pcf/7.0.0/gen/Pcf-schema.json",
    "Description": "Replaces generic carbon footprint structure with Catena-X PCF data model for automotive supply chain",
    "Provider": "Catena-X Automotive Network",
    "Compatibility": ["v1.0", "v1.1"],
    "ValidationMode": "exclusive",
    "MigrationPath": {
      "TotalCO2Equivalent": "pcf.pcfExcludingBiogenic",
      "Unit": "pcf.declaredUnit"
    },
    "ConflictResolution": "error"
  }
}
```

### Example 2: RMI Steel Guidance Extension (Replacement)
```json
{
  "ExtensionMetadata": {
    "ExtensionId": "pcf-rmi-steel-v1",
    "ExtensionName": "Steel Industry PCF (RMI)",
    "Version": "1.0.0",
    "ExtensionType": "replacement",
    "TargetPath": "Sustainability.CarbonFootprint",
    "Namespace": "https://rmi.org/steel-guidance/pcf",
    "SchemaUrl": "https://rmi.org/schemas/steel-pcf/v1.0/schema.json",
    "Description": "Steel industry-specific carbon footprint based on RMI Steel Guidance",
    "Provider": "Rocky Mountain Institute",
    "Compatibility": ["v1.0", "v1.1"],
    "ValidationMode": "exclusive",
    "MigrationPath": {
      "TotalCO2Equivalent": "emissions.total",
      "Scope1Emissions": "emissions.scope1"
    }
  }
}
```

### Example 3: China RoHS Extension (Supplement)
```json
{
  "ExtensionMetadata": {
    "ExtensionId": "rohs-china-gb-v2",
    "ExtensionName": "China RoHS (GB/T 26572)",
    "Version": "2.0.0",
    "ExtensionType": "supplement",
    "TargetPath": "RohsReachCompliance.RohsCompliance",
    "Namespace": "https://gb-standards.cn/rohs",
    "SchemaUrl": "https://standards.cn/schemas/gb-rohs/v2.0/schema.json",
    "Description": "Adds China-specific RoHS requirements alongside EU RoHS",
    "Provider": "SAC (Standardization Administration of China)",
    "Compatibility": ["v1.0", "v1.1"],
    "ValidationMode": "merged",
    "ConflictResolution": "extension-wins"
  }
}
```

## Implementation Pattern

```python
# Pseudo-code for extension processing
def process_dmp_with_extensions(dmp_data, active_extensions):
    # 1. Validate base DMP structure
    validate_against_schema(dmp_data, base_dmp_schema)
    
    # 2. Apply extensions
    for extension in active_extensions:
        if extension.type == "replacement":
            # Replace target section with extension data
            target_section = get_path(dmp_data, extension.target_path)
            validate_against_schema(target_section, extension.schema_url)
            
        elif extension.type == "supplement":
            # Merge extension fields with base
            merge_schemas(base_schema, extension.schema)
            validate_merged(target_section)
            
        elif extension.type == "transform":
            # Apply modified validation rules
            apply_transforms(extension.rules)
    
    return processed_dmp
```

## Notes

### Key Principles
- **DMP schema stability**: Base schema never changes
- **Industry ownership**: Industries maintain their extensions
- **Clean separation**: Extensions are self-contained
- **Market-driven**: Adoption based on industry needs
- **Future-proof**: New standards add extensions, not schema changes

### Implementation Notes
- Extensions discovered at document processing time
- Validation dynamically routed based on active extensions
- Migration paths enable data transformation
- Clear precedence rules for conflicts
- Extension registry enables discovery

### Benefits
1. **Zero DMP changes**: Core schema remains stable
2. **Industry flexibility**: Each sector uses appropriate standards
3. **Clean validation**: Each section validates against its schema
4. **Easy adoption**: Industries can start using immediately
5. **Future standards**: Supported without coordination

### Related Aspects
- **All DMP Aspects**: Any section can be extended
- **Validation Framework**: Routes to appropriate schemas
- **Schema Registry**: Manages available extensions
- **Industry Standards**: Source of extension schemas

### References
- JSON Schema Specification (Draft 2020-12)
- Semantic Versioning 2.0.0
- JSON Path Specification
- Industry-specific standards (Catena-X, RMI, etc.)