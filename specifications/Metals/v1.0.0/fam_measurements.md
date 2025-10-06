Here's the updated Measurements FAM based on the Liberty certificate insights:
# Measurements

## Aspect Overview

### Aspect Name

**Name**: Measurements

### Aspect Category

- [x] Physical Properties
- [x] Chemical Properties
- [ ] Delivery Conditions
- [ ] Processing Information
- [x] Quality Attributes
- [x] Compliance Data
- [ ] Sustainability Metrics
- [ ] Other: ****\_\_\_****

### Priority

- [x] Core (Required)
- [ ] Standard (Recommended)
- [ ] Extended (Optional)

## Data Structure

### Primary Data Elements

List the main data fields for this aspect:

| Field Name         | Data Type | Required | Description                                    | Example               |
| ------------------ | --------- | -------- | ---------------------------------------------- | --------------------- |
| PropertySymbol     | string    | Yes      | Standardized technical symbol for the property | "Rm", "HV", "C"       |
| PropertyName       | string    | No       | Human-readable name in specified language      | "Tensile Strength"    |
| PropertyId         | string    | No       | Identifier from standard catalog               | "1039"                |
| Unit               | string    | Yes      | Unit of measurement                            | "MPa", "%", "HV"      |
| Method             | string    | No       | Testing method or standard used                | "EN ISO 6892-1"       |
| TestConditions     | string    | No       | Conditions under which test was performed      | "23°C, 50% RH"        |
| PropertiesStandard | string    | No       | Reference to standard catalog                  | "CAMPUS", "ISO 80000" |
| Formula            | string    | No       | For calculated values                          | "C+Mn/6+(Cr+Mo+V)/5"  |
| ResultType         | enum      | Yes      | Type of result data structure                  | "numeric", "boolean"  |
| Result             | object    | Yes      | Measured result with constraints               | See Result types      |
| Grade              | string    | No       | Grade or class classification                  | "A", "B", "Pass"      |
| SampleLocation     | string    | No       | Location where sample was taken                | "Centre", "Mid-Radial"|
| SampleIdentifier   | string    | No       | Unique identifier for the test specimen        | "3749168"             |
| TestGroupId        | string    | No       | Identifier to group related measurements       | "MECH-001"            |

### Sub-aspects

Break down into specific components:

#### Sub-aspect 1: Result Types

- **Description**: Different types of measurement results with inline constraints
- **Data Elements**:
  - NumericResult (single values with operator, min/max/target)
  - BooleanResult (pass/fail with expected)
  - StringResult (text with allowed values)
  - RangeResult (min-max ranges)
  - ArrayResult (multiple values at parameters with operator support)

#### Sub-aspect 2: Numeric Precision and Operators

- **Description**: Handling significant figures, decimal places, and comparison operators
- **Data Elements**:
  - DecimalPlaces (integer)
  - Operator (enum: "=", "<", "≤", ">", "≥")
  - RoundingStandard (string)
  - RoundingContext (enum)

#### Sub-aspect 3: Statistical Data

- **Description**: Individual measurements and statistics
- **Data Elements**:
  - IndividualValues (array)
  - IndividualIdentifiers (array) - specimen IDs for each value
  - Statistics.Average (number)
  - Statistics.StandardDeviation (number)
  - Statistics.Range (number)
  - Statistics.Count (integer)

#### Sub-aspect 4: Test Groups

- **Description**: Grouping of related measurements under common test conditions
- **Data Elements**:
  - TestGroupId (string)
  - TestGroupName (string)
  - CommonTestConditions (string)
  - TestGroupStandard (string)

#### Sub-aspect 5: Sample Metadata

- **Description**: Enhanced sample location and identification
- **Data Elements**:
  - SampleLocation (string) - physical location
  - SampleIdentifier (string) - unique ID
  - SampleOrientation (string) - T/L/S, Top/Bottom
  - SampleDepth (number) - depth from surface

## Validation Rules

### Required Validations

- PropertySymbol and Unit are always required
- Actual must contain a valid Result object
- Result.Value must be present
- For arrays: Values.length must equal Parameters.length
- If Operator is present, validate accordingly (e.g., "<" means actual value is less than stated)
- If IndividualValues present, IndividualIdentifiers length must match

### Format Validations

- PropertySymbol must match standard notation (e.g., "Rm", "Re", "A")
- Unit must be valid SI or accepted industry unit
- Method should reference recognized standard
- Numeric values must respect DecimalPlaces when rendered
- Operator must be from allowed set: "=", "<", "≤", ">", "≥"
- Grade should follow standard classifications when applicable

### Business Rules

- If Minimum/Maximum present, validate Value against constraints
- For ExclusiveMinimum/Maximum, use exclusive comparison
- When Operator is "<", value represents upper detection/reporting limit
- BooleanResult comparison with Expected determines pass/fail
- StringResult must match AllowedValues if specified
- Interpretation should align with validation results
- TestGroupId should be consistent across related measurements

## Use Cases

### Primary Use Cases

1. **Material Testing**: Tensile tests, hardness tests, impact tests
2. **Chemical Analysis**: Composition percentages with max limits, trace elements with detection limits
3. **Quality Control**: Multi-point measurements (Jominy curves)
4. **Compliance Verification**: Pass/fail criteria for specifications
5. **Statistical Process Control**: Individual values with statistics
6. **Trace Analysis**: Values below detection limits (e.g., "<2 ppm")
7. **Test Grouping**: Related tests under common conditions
8. **Multi-Specimen Testing**: Track individual test specimens

### Integration Points

Where does this aspect connect with other parts of the format?

- **Product Identification**: Links measurements to specific batch/heat
- **Standards Compliance**: References testing standards and specifications
- **Certificates**: Core data for test certificates (CoA, 3.1, etc.)
- **Traceability**: Connects to test equipment and operators
- **Test Groups**: Links related measurements together
- **Sample Management**: Tracks specimen chain of custody

## Implementation Considerations

### Technical Requirements

- Support for multiple result types (numeric, boolean, string, range, array)
- Preservation of significant figures through DecimalPlaces
- Support for comparison operators ("<", "≤", etc.)
- Validation engine for min/max constraints
- Rendering logic for proper decimal display and operators
- Statistical calculations for grouped measurements
- Test grouping mechanism for related measurements
- Enhanced sample tracking capabilities

### Standards Compliance

- ASTM E29 for rounding practices
- ISO 80000 for quantities and units
- EN 10204 for certificate types
- Industry-specific testing standards (ASTM, ISO, EN, DIN)
- Laboratory reporting standards for detection limits
- ISO/IEC 17025 for testing competence

### Industry Practices

- Hardness tests report individual values plus average
- Chemical composition uses minimum and maximum limits
- Trace elements often reported as "less than" values
- Mechanical properties use minimum and maximum requirements
- Jominy tests use distance-based array data
- Different decimal places for different properties
- Test specimens tracked individually
- Related tests grouped under common conditions

## JSON Schema Example

```json
{
  "type": "object",
  "properties": {
    "Measurement": {
      "type": "object",
      "properties": {
        "PropertySymbol": {
          "type": "string",
          "pattern": "^[A-Za-z][A-Za-z0-9_-]*$"
        },
        "PropertyName": {
          "type": "string"
        },
        "PropertyId": {
          "type": "string"
        },
        "Unit": {
          "type": "string"
        },
        "Method": {
          "type": "string"
        },
        "TestConditions": {
          "type": "string"
        },
        "PropertiesStandard": {
          "type": "string"
        },
        "Formula": {
          "type": "string"
        },
        "Grade": {
          "type": "string",
          "examples": ["A", "B", "C", "Pass", "Fail", "Class 1", "Class 2"]
        },
        "SampleLocation": {
          "type": "string",
          "examples": ["Centre", "Mid-Radial", "Surface", "1/4 thickness"]
        },
        "SampleIdentifier": {
          "type": "string"
        },
        "TestGroupId": {
          "type": "string"
        },
        "ResultType": {
          "type": "string",
          "enum": ["numeric", "boolean", "string", "range", "array"]
        },
        "Result": {
          "oneOf": [
            { "$ref": "#/$defs/NumericResult" },
            { "$ref": "#/$defs/BooleanResult" },
            { "$ref": "#/$defs/StringResult" },
            { "$ref": "#/$defs/RangeResult" },
            { "$ref": "#/$defs/ArrayResult" }
          ]
        }
      },
      "required": ["PropertySymbol", "Unit", "ResultType", "Result"],
      "additionalProperties": false
    },
    "NumericResult": {
      "type": "object",
      "properties": {
        "Value": { "type": "number" },
        "Operator": {
          "type": "string",
          "enum": ["=", "<", "≤", ">", "≥"],
          "default": "=",
          "description": "Comparison operator for the value"
        },
        "DecimalPlaces": { "type": "integer", "minimum": 0 },
        "Minimum": { "type": "number" },
        "Maximum": { "type": "number" },
        "ExclusiveMinimum": { "type": "number" },
        "ExclusiveMaximum": { "type": "number" },
        "Target": { "type": "number" },
        "IndividualValues": {
          "type": "array",
          "items": { "type": "number" }
        },
        "IndividualIdentifiers": {
          "type": "array",
          "items": { "type": "string" },
          "description": "Specimen identifiers corresponding to IndividualValues"
        },
        "Statistics": {
          "type": "object",
          "properties": {
            "Average": { "type": "number" },
            "StandardDeviation": { "type": "number" },
            "Range": { "type": "number" },
            "Count": { "type": "integer" }
          }
        },
        "Interpretation": {
          "type": "string",
          "enum": [
            "In Specification",
            "Out of Specification",
            "Conditionally Acceptable",
            "Not Evaluated"
          ]
        }
      },
      "required": ["Value"]
    },
    "ArrayResult": {
      "type": "object",
      "properties": {
        "ParameterName": { "type": "string" },
        "ParameterUnit": { "type": "string" },
        "ValueName": { "type": "string" },
        "ValueUnit": { "type": "string" },
        "DecimalPlaces": { "type": "integer", "minimum": 0 },
        
        "Data": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "Parameter": { 
                "oneOf": [
                  { "type": "string" },
                  { "type": "number" }
                ]
              },
              "Value": { "type": "number" },
              "StringValue": { "type": "string" },
              "Operator": {
                "type": "string",
                "enum": ["=", "<", "≤", ">", "≥"],
                "default": "="
              },
              "Minimum": { "type": "number" },
              "Maximum": { "type": "number" },
              "Target": { "type": "number" },
              "Status": {
                "type": "string",
                "enum": ["Pass", "Fail", "Warning", "Info"]
              },
              "AdditionalValues": {
                "type": "object",
                "description": "For tests with multiple values per parameter"
              }
            },
            "required": ["Parameter"],
            "oneOf": [
              { "required": ["Value"] },
              { "required": ["StringValue"] }
            ]
          }
        },
        
        "Statistics": {
          "type": "object",
          "properties": {
            "Mean": { "type": "number" },
            "StandardDeviation": { "type": "number" },
            "Range": { "type": "number" },
            "Minimum": { "type": "number" },
            "Maximum": { "type": "number" },
            "Count": { "type": "integer" },
            "CoefficientOfVariation": { "type": "number" }
          }
        },
        
        "CurveFit": {
          "type": "object",
          "properties": {
            "Equation": { "type": "string" },
            "FitType": {
              "type": "string",
              "enum": ["Linear", "Polynomial", "Power", "Exponential", "Logarithmic", "Custom"]
            },
            "Coefficients": { "type": "object" },
            "R2": { "type": "number", "minimum": 0, "maximum": 1 },
            "RMSE": { "type": "number" }
          }
        },
        
        "SpecificationBand": {
          "type": "object",
          "properties": {
            "UpperCurve": {
              "type": "array",
              "items": {
                "type": "array",
                "items": { "type": "number" },
                "minItems": 2,
                "maxItems": 2
              }
            },
            "LowerCurve": {
              "type": "array",
              "items": {
                "type": "array",
                "items": { "type": "number" },
                "minItems": 2,
                "maxItems": 2
              }
            },
            "Standard": { "type": "string" },
            "Grade": { "type": "string" }
          }
        },
        
        "DerivedResults": {
          "type": "object",
          "description": "Test-specific calculated values",
          "additionalProperties": {
            "type": "object",
            "properties": {
              "Value": { 
                "oneOf": [
                  { "type": "number" },
                  { "type": "string" }
                ]
              },
              "Unit": { "type": "string" },
              "Description": { "type": "string" }
            }
          }
        },
        
        "TestConditions": {
          "type": "object",
          "description": "Test-specific parameters and conditions",
          "additionalProperties": true
        },
        
        "GraphConfiguration": {
          "type": "object",
          "properties": {
            "GraphType": {
              "type": "string",
              "enum": ["XY-Curve", "Bar", "Scatter", "HeatMap"]
            },
            "XAxisLabel": { "type": "string" },
            "YAxisLabel": { "type": "string" },
            "XAxisScale": {
              "type": "string",
              "enum": ["Linear", "Logarithmic"]
            },
            "YAxisScale": {
              "type": "string",
              "enum": ["Linear", "Logarithmic"]
            },
            "ShowSpecificationBand": { "type": "boolean" },
            "ShowCurveFit": { "type": "boolean" }
          }
        },
        
        "Interpretation": {
          "type": "string"
        },
        
        "OverallStatus": {
          "type": "string",
          "enum": [
            "In Specification",
            "Out of Specification",
            "Conditionally Acceptable",
            "Not Evaluated"
          ]
        }
      },
      
      "required": ["ParameterName", "Data"]
    },
    "BooleanResult": {
      "type": "object",
      "properties": {
        "Value": { "type": "boolean" },
        "Expected": { "type": "boolean" },
        "PassCriteria": {
          "type": "string",
          "description": "Description of what constitutes a pass"
        },
        "Interpretation": {
          "type": "string",
          "enum": [
            "In Specification",
            "Out of Specification",
            "Conditionally Acceptable",
            "Not Evaluated"
          ]
        }
      },
      "required": ["Value"]
    },
    "StringResult": {
      "type": "object",
      "properties": {
        "Value": { "type": "string" },
        "Interpretation": {
          "type": "string",
          "enum": [
            "In Specification",
            "Out of Specification",
            "Conditionally Acceptable",
            "Not Evaluated"
          ]
        }
      },
      "required": ["Value"]
    },
    "RangeResult": {
      "type": "object",
      "properties": {
        "MinValue": { "type": "number" },
        "MaxValue": { "type": "number" },
        "Unit": { "type": "string" },
        "DecimalPlaces": { "type": "integer", "minimum": 0 },
        "TargetMin": { "type": "number" },
        "TargetMax": { "type": "number" },
        "ToleranceMin": { "type": "number" },
        "ToleranceMax": { "type": "number" },
        "Interpretation": {
          "type": "string",
          "enum": [
            "In Specification",
            "Out of Specification",
            "Conditionally Acceptable",
            "Not Evaluated"
          ]
        }
      },
      "required": ["MinValue", "MaxValue"]
    }
  }
}
```

## Sample Data

```json
{
  "Measurements": [
    {
      "PropertySymbol": "Rm",
      "PropertyName": "Tensile Strength",
      "Unit": "MPa",
      "Method": "ASTM E8-16a",
      "TestGroupId": "MECH-001",
      "SampleLocation": "Centre",
      "SampleIdentifier": "3758176",
      "ResultType": "numeric",
      "Result": {
        "Value": 245.0,
        "Operator": "=",
        "DecimalPlaces": 1,
        "Minimum": 235,
        "IndividualValues": [243.0, 244.0, 248.0],
        "IndividualIdentifiers": ["3758180", "3758181", "3758182"],
        "Statistics": {
          "Average": 245.0,
          "Range": 5.0,
          "Count": 3
        },
        "Interpretation": "In Specification"
      },
      "Grade": "B"
    },
    {
      "PropertySymbol": "HRC-J",
      "PropertyName": "Jominy Hardenability",
      "Unit": "HRc",
      "Method": "ASTM A255-10",
      "TestConditions": "927C for 01:00hr Air Cool in 35mm Dia",
      "ResultType": "array",
      "Result": {
        "ParameterName": "Distance from quenched end",
        "ParameterUnit": "16ths inch",
        "ValueName": "Hardness",
        "ValueUnit": "HRc",
        "DecimalPlaces": 1,
        "Data": [
          {
            "Parameter": 0.5,
            "Value": 57.5,
            "Minimum": 55,
            "Maximum": 60,
            "Status": "Pass"
          },
          {
            "Parameter": 1.25,
            "Value": 57.0,
            "Minimum": 50,
            "Maximum": 58,
            "Status": "Pass"
          },
          {
            "Parameter": 2.0,
            "Value": 45.2,
            "Minimum": 40,
            "Maximum": 50,
            "Status": "Pass"
          }
        ],
        "Statistics": {
          "Mean": 53.2,
          "StandardDeviation": 6.8,
          "Range": 12.3,
          "Minimum": 45.2,
          "Maximum": 57.5,
          "Count": 3
        },
        "CurveFit": {
          "Equation": "y = 58.1 * exp(-0.32 * x)",
          "FitType": "Exponential",
          "Coefficients": {
            "a": 58.1,
            "b": -0.32
          },
          "R2": 0.97,
          "RMSE": 1.2
        },
        "GraphConfiguration": {
          "GraphType": "XY-Curve",
          "XAxisLabel": "Distance from quenched end (inches)",
          "YAxisLabel": "Hardness (HRc)",
          "XAxisScale": "Linear",
          "YAxisScale": "Linear",
          "ShowSpecificationBand": true,
          "ShowCurveFit": true
        },
        "Interpretation": "Hardenability curve follows expected exponential decay pattern",
        "OverallStatus": "In Specification"
      }
    },
    {
      "PropertySymbol": "MagTest",
      "PropertyName": "Magnetic Particle Test",
      "Unit": "Pass/Fail",
      "Method": "ASTM E709",
      "TestGroupId": "NDT-001",
      "ResultType": "boolean",
      "Result": {
        "Value": true,
        "Expected": true,
        "PassCriteria": "No linear indications greater than 1.6mm",
        "Interpretation": "In Specification"
      }
    },
    {
      "PropertySymbol": "HeatTreat",
      "PropertyName": "Heat Treatment Condition",
      "Unit": "Condition",
      "Method": "Company Standard",
      "TestGroupId": "PROC-001",
      "ResultType": "string",
      "Result": {
        "Value": "Normalized",
        "Interpretation": "In Specification"
      }
    },
    {
      "PropertySymbol": "Remarks",
      "PropertyName": "Inspection Remarks",
      "Unit": "Text",
      "Method": "Visual Inspection",
      "TestGroupId": "INSP-001",
      "ResultType": "string",
      "Result": {
        "Value": "Minor surface oxidation observed on edges, within acceptable limits",
        "Interpretation": "In Specification"
      }
    },
    {
      "PropertySymbol": "TempRange",
      "PropertyName": "Operating Temperature Range",
      "Unit": "°C",
      "Method": "Design Specification",
      "TestGroupId": "DESIGN-001",
      "ResultType": "range",
      "Result": {
        "MinValue": -40,
        "MaxValue": 200,
        "Unit": "°C",
        "DecimalPlaces": 0,
        "TargetMin": -20,
        "TargetMax": 150,
        "ToleranceMin": -45,
        "ToleranceMax": 220,
        "Interpretation": "In Specification"
      }
    }
  ]
}
```

## Notes

### Implementation Notes

- DecimalPlaces determines display format, not storage precision
- Validation occurs on numeric values, not string representations
- Support localization of decimal separators at rendering time
- Support for visualization of exclusiveMinimum and exclusiveMaximum
- Operator field enables proper rendering of "less than" values common in trace analysis
- When Operator is "<", the Value represents the detection or reporting limit
- TestGroupId enables linking related measurements
- IndividualIdentifiers track specific test specimens
- Grade field supports various classification systems

### Related Aspects

- Product Identification (links measurements to products)
- Equipment Calibration (measurement uncertainty)
- Personnel Qualification (who performed tests)
- Environmental Conditions (ambient test conditions)
- Laboratory Information (detection limits, methods)
- Test Groups (related measurements under common conditions)
- Sample Management (specimen tracking and chain of custody)

### References

- ASTM E29-22: Standard Practice for Using Significant Digits
- ISO/IEC 17025: Testing and Calibration Laboratories
- EN 10204: Types of Inspection Documents
- ISO 80000-1: Quantities and Units
- ASTM E1019: Standard Test Methods for Determination of Carbon, Sulfur, Nitrogen, and Oxygen in Steel
- ASTM E8: Standard Test Methods for Tension Testing of Metallic Materials
- ASTM A255: Standard Test Methods for Determining Hardenability of Steel