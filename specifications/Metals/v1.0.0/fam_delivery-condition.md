# Metals Delivery Condition

## Aspect Overview

### Aspect Name

**Name**: Delivery Condition

- [ ] Physical Properties
- [ ] Chemical Properties
- [x] Delivery Conditions
- [ ] Processing Information
- [ ] Quality Attributes
- [ ] Compliance Data
- [ ] Sustainability Metrics
- [ ] Other: ****\_\_\_****

### Priority

- [x] Core (Required)
- [ ] Standard (Recommended)
- [ ] Extended (Optional)

## Data Structure

### Primary Data Elements

List the main data fields for this aspect:

| Field Name | Data Type | Required | Description                     | Example                                                  |
| ---------- | --------- | -------- | ------------------------------- | -------------------------------------------------------- |
| Coloring   | object    | No       | Color marking information       | See Coloring sub-aspect |
| Marking    | object    | No       | Identification marking details  | See Marking sub-aspect |
| Bundles    | object    | No       | Bundle packaging information    | See Bundles sub-aspect |
| Stamping   | object    | No       | Stamping identification details | See Stamping sub-aspect |

### Sub-aspects

#### Sub-aspect 1: Coloring

- **Description**: Color coding applied to metals for identification, sorting, or safety purposes
- **Data Elements**:
  - Method: String - Application method (paint, powder_coating, anodizing, etc.)
  - Color: String - Color name or description
  - ColorCode: String - Standard color code (RAL, Pantone, etc.)
  - Coverage: String - Coverage area (full, partial, ends_only, etc.)
  - Purpose: String - Reason for coloring (identification, safety, aesthetics, etc.)

#### Sub-aspect 2: Marking

- **Description**: Identification marks applied to metals for traceability and identification
- **Data Elements**:
  - Type: String - Marking method (stamped, etched, laser, ink, etc.)
  - Content: String - Marking content/text
  - Location: String - Position of marking (end, side, surface, etc.)
  - Legibility: String - Readability assessment (clear, faded, illegible, etc.)
  - Standard: String - Marking standard reference (if applicable)

#### Sub-aspect 3: Bundles

- **Description**: Packaging and bundling information for grouped metal items
- **Data Elements**:
  - Type: String - Bundle method (wire_tied, banded, strapped, etc.)
  - Quantity: Number - Number of items in bundle
  - Weight: Number - Total bundle weight
  - WeightUnit: String - Weight unit (kg, lbs, etc.)
  - Dimensions: Object - Bundle dimensions
  - Material: String - Bundling material (steel_wire, plastic_strap, etc.)
  - Condition: String - Bundle condition (intact, damaged, loose, etc.)

#### Sub-aspect 4: Stamping

- **Description**: Permanent identification stamps applied to metals
- **Data Elements**:
  - Location: String - Stamp position (end, side, surface, etc.)
  - Content: String - Stamped information
  - Depth: Number - Stamp depth
  - DepthUnit: String - Depth unit (mm)
  - Legibility: String - Readability (clear, worn, deep, shallow, etc.)
  - Standard: String - Stamping standard (if applicable)
  - Equipment: String - Stamping equipment used

## Validation Rules

### Required Validations

- At least one sub-aspect must be present if DeliveryCondition is specified
- Color codes must follow recognized standards (RAL, Pantone, etc.) when specified
- Bundle quantities must be positive integers
- Weight values must be positive numbers

### Format Validations

- Color codes must match standard format patterns
- Marking content must be alphanumeric with allowed special characters
- Dimensions must include unit specifications
- Stamp depth must be within reasonable ranges (0.1-5.0mm)

### Business Rules

- Coloring method must be appropriate for metal type
- Marking location must be feasible for the metal form
- Bundle type must be suitable for metal dimensions
- Stamping depth must not compromise structural integrity

## Use Cases

### Primary Use Cases

1. **Quality Control Inspection**: Verify delivery condition matches specifications
2. **Inventory Management**: Identify and sort metals by delivery condition
3. **Traceability**: Track metals through supply chain using markings and stamps
4. **Receiving Inspection**: Validate delivery condition at goods receipt
5. **Safety Compliance**: Ensure proper safety markings and color coding

### Integration Points

Where does this aspect connect with other parts of the format?

- Links to material identification through marking/stamping content
- Connects to quality assessment through condition descriptions
- Relates to packaging information through bundle details
- Supports traceability through unique identifiers

## Implementation Considerations

### Technical Requirements

- Support for multiple color coding standards
- Flexible marking content validation
- Dimensional measurement units (metric/imperial)
- Image attachment support for visual verification
- Multiple instances of each sub-aspect (e.g., multiple markings)

### Standards Compliance

- ISO 12944 for protective paint systems
- ASTM A615 for marking requirements
- EN 10204 for material certificates
- Industry-specific marking standards
- Color standards (RAL, Pantone, NCS, BS)

### Industry Practices

- Common color coding systems in steel industry
- Standard marking positions for different metal forms
- Typical bundling methods for various metal products
- Stamping practices for traceability
- Regional variations in marking requirements

## JSON Schema Example

```json
{
  "type": "object",
  "properties": {
    "DeliveryCondition": {
      "type": "object",
      "properties": {
        "Coloring": {
          "type": "object",
          "properties": {
            "Method": {
              "type": "string",
              "enum": ["paint", "powder_coating", "anodizing", "galvanizing", "other"]
            },
            "Color": {
              "type": "string"
            },
            "ColorCode": {
              "type": "string",
              "pattern": "^(RAL|PANTONE|NCS|BS)\\s*\\S+$"
            },
            "Coverage": {
              "type": "string",
              "enum": ["full", "partial", "ends_only", "marking_only"]
            },
            "Purpose": {
              "type": "string",
              "enum": ["identification", "safety", "aesthetics", "protection", "sorting"]
            }
          }
        },
        "Marking": {
          "type": "object",
          "properties": {
            "Type": {
              "type": "string",
              "enum": ["stamped", "etched", "laser", "ink", "embossed", "other"]
            },
            "Content": {
              "type": "string",
              "maxLength": 100
            },
            "Location": {
              "type": "string",
              "enum": ["end", "side", "surface", "multiple", "other"]
            },
            "Legibility": {
              "type": "string",
              "enum": ["clear", "faded", "partial", "illegible"]
            },
            "Standard": {
              "type": "string"
            }
          }
        },
        "Bundles": {
          "type": "object",
          "properties": {
            "Type": {
              "type": "string",
              "enum": ["wire_tied", "banded", "strapped", "boxed", "loose", "other"]
            },
            "Quantity": {
              "type": "integer",
              "minimum": 1
            },
            "Weight": {
              "type": "number",
              "minimum": 0
            },
            "WeightUnit": {
              "type": "string",
              "enum": ["kg", "lbs", "t", "MT"]
            },
            "Dimensions": {
              "type": "object",
              "properties": {
                "Length": { "type": "number", "minimum": 0 },
                "Width": { "type": "number", "minimum": 0 },
                "Height": { "type": "number", "minimum": 0 },
                "Unit": {
                  "type": "string",
                  "enum": ["mm", "cm", "m", "in", "ft"]
                }
              }
            },
            "Material": {
              "type": "string",
              "enum": ["steel_wire", "plastic_strap", "metal_band", "rope", "other"]
            },
            "Condition": {
              "type": "string",
              "enum": ["intact", "damaged", "loose", "partial", "missing"]
            }
          }
        },
        "Stamping": {
          "type": "object",
          "properties": {
            "Location": {
              "type": "string",
              "enum": ["end", "side", "surface", "multiple", "other"]
            },
            "Content": {
              "type": "string",
              "maxLength": 50
            },
            "Depth": {
              "type": "number",
              "minimum": 0.1,
              "maximum": 5.0
            },
            "DepthUnit": {
              "type": "string",
              "const": "mm"
            },
            "Legibility": {
              "type": "string",
              "enum": ["clear", "worn", "deep", "shallow", "illegible"]
            },
            "Standard": {
              "type": "string"
            },
            "Equipment": {
              "type": "string"
            }
          }
        }
      },
      "additionalProperties": false
    }
  }
}
```

## Sample Data

```json
{
  "DeliveryCondition": {
    "Coloring": {
      "Method": "paint",
      "Color": "Traffic Red",
      "ColorCode": "RAL 3020",
      "Coverage": "ends_only",
      "Purpose": "identification"
    },
    "Marking": {
      "Type": "stamped",
      "Content": "BATCH-2024-001-XYZ",
      "Location": "end",
      "Legibility": "clear",
      "Standard": "ASTM A615"
    },
    "Bundles": {
      "Type": "wire_tied",
      "Quantity": 50,
      "Weight": 125.5,
      "WeightUnit": "kg",
      "Dimensions": {
        "Length": 6000,
        "Width": 200,
        "Height": 150,
        "Unit": "mm"
      },
      "Material": "steel_wire",
      "Condition": "intact"
    },
    "Stamping": {
      "Location": "end",
      "Content": "MILL-CERT-789-2024",
      "Depth": 0.5,
      "DepthUnit": "mm",
      "Legibility": "clear",
      "Standard": "EN 10204",
      "Equipment": "hydraulic_press"
    }
  }
}
```

## Notes

### Implementation Notes

- Consider visual documentation through photos for verification
- Allow for multiple markings/stamps on single item (array support)
- Support both metric and imperial units with conversion
- Validate color codes against standard databases
- Consider QR code or barcode marking options

### Related Aspects

- Material Identification (linked through marking content)
- Quality Assessment (condition descriptions)
- Packaging Information (bundle details)
- Traceability (stamping and marking content)
- Visual Documentation (photos of actual condition)

### References

- ISO 12944: Paints and varnishes - Corrosion protection of steel structures
- ASTM A615: Standard Specification for Deformed and Plain Carbon-Steel Bars
- EN 10204: Metallic products - Types of inspection documents
- RAL Color Standards
- Industry best practices for metal identification and marking