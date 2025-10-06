# Mechanical Properties

## Aspect Overview

### Aspect Name

**Name**: Mechanical Properties

### Aspect Category

- [x] Physical Properties
- [ ] Chemical Properties
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

| Field Name | Data Type | Required | Description | Example |
|------------|-----------|----------|-------------|---------|
| TestGroupId | string | Yes | Unique identifier for the test group | "MECH-001" |
| TestGroupName | string | No | Descriptive name for the test group | "Tensile Properties" |
| TestStandard | string | Yes | Primary test standard | "ASTM E8-16a" |
| SampleHeatTreatment | object | No | Heat treatment applied to test samples | See sub-aspect |
| TestTemperature | number | No | Temperature at which tests were performed | 23 |
| TestTemperatureUnit | string | No | Unit for test temperature | "°C" |
| TestEnvironment | string | No | Environment conditions | "Air", "Vacuum" |
| Properties | array[Measurement] | Yes | Individual mechanical property measurements | See Measurements FAM |

### Sub-aspects

Break down into specific components:

#### Sub-aspect 1: Tensile Properties

- **Description**: Properties derived from tensile testing
- **Common Properties**:
  - UTS/Rm: Ultimate Tensile Strength
  - YS/Re/Rp0.2: Yield Strength (0.2% offset)
  - Elongation/A: Percentage elongation
  - R of A/Z: Reduction of area
  - E: Modulus of elasticity
  - n: Strain hardening exponent
  - Proportional Limit
  - Fracture Position (when applicable)

#### Sub-aspect 2: Impact Properties

- **Description**: Properties from impact testing (Charpy, Izod)
- **Common Properties**:
  - KV/CVN: Charpy V-notch impact energy
  - KU: Charpy U-notch impact energy
  - Lateral Expansion
  - Shear Fracture Percentage
  - DBTT: Ductile-Brittle Transition Temperature
  - Test Geometry (specimen dimensions)

#### Sub-aspect 3: Hardness Properties

- **Description**: Various hardness measurements
- **Common Types**:
  - HB/HBW: Brinell hardness
  - HV: Vickers hardness (HV1, HV10, HV30)
  - HRC/HRB/HRA: Rockwell hardness scales
  - HK: Knoop hardness
  - Shore hardness
  - Conversion between scales

#### Sub-aspect 4: Sample Heat Treatment

- **Description**: Heat treatment applied to test specimens
- **Data Elements**:
  - Process: String - Treatment process name
  - Temperature: Number - Process temperature
  - TemperatureUnit: String - Temperature unit
  - Duration: String - Time duration
  - CoolingMethod: String - Cooling method
  - Sequence: Array - Multiple step processes

#### Sub-aspect 5: Fracture Mechanics

- **Description**: Fracture toughness and related properties
- **Common Properties**:
  - KIC: Plane strain fracture toughness
  - JIC: J-integral at crack initiation
  - CTOD: Crack tip opening displacement
  - Fatigue crack growth rate (da/dN)
  - Threshold stress intensity (ΔKth)

## Validation Rules

### Required Validations

- TestGroupId must be unique within the document
- TestStandard must be a recognized standard
- All Properties must follow Measurement schema
- Temperature values must be reasonable for material type
- Linked measurements should have same TestGroupId

### Format Validations

- TestStandard format: organization + number + year (e.g., "ASTM E8-16a")
- Temperature units must be °C, °F, or K
- Duration format should be clear (e.g., "01:00hr", "60min", "3600s")
- Property symbols must match standard notation

### Business Rules

- Tensile properties typically reported together
- Impact tests usually at specific temperatures
- Hardness conversions only valid within ranges
- Heat treatment affects all mechanical properties
- Multiple specimens typical for statistical validity
- Fracture position relevant for acceptance criteria

## Use Cases

### Primary Use Cases

1. **Material Certification**: Verify mechanical properties meet specifications
2. **Design Data**: Provide engineering design allowables
3. **Quality Control**: Batch release testing
4. **Failure Analysis**: Compare properties to requirements
5. **Material Selection**: Choose materials based on properties
6. **Heat Treatment Validation**: Verify treatment effectiveness
7. **Statistical Analysis**: Process capability studies

### Integration Points

Where does this aspect connect with other parts of the format?

- **Chemical Analysis**: Composition affects mechanical properties
- **Product**: Links to specific product forms and sizes
- **Heat Treatment**: Processing history affects properties
- **Standards Compliance**: Properties must meet specifications
- **Measurements**: Uses measurement schema for values
- **Sample Management**: Specimen preparation and identification

## Implementation Considerations

### Technical Requirements

- Group related properties under common test conditions
- Support for multiple test temperatures
- Handle both individual and average values
- Support various specimen geometries
- Enable statistical analysis of results
- Track heat treatment of samples

### Standards Compliance

- ASTM E8/E8M: Tension Testing of Metallic Materials
- ISO 6892: Metallic materials - Tensile testing
- ASTM E23: Notched Bar Impact Testing
- ISO 148: Metallic materials - Charpy impact test
- ASTM E18: Rockwell Hardness
- ISO 6506: Brinell hardness
- ASTM E399: Fracture Toughness Testing

### Industry Practices

- Report average and individual values
- Specify test temperature for impact tests
- Include sample heat treatment
- Report fracture location for tensile tests
- Multiple hardness scales common
- Room temperature assumed if not specified
- Specimen orientation affects properties

## JSON Schema Example

```json
{
  "type": "object",
  "properties": {
    "MechanicalProperties": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "TestGroupId": {
            "type": "string",
            "description": "Unique identifier for this test group"
          },
          "TestGroupName": {
            "type": "string",
            "enum": [
              "Tensile Properties",
              "Impact Properties",
              "Hardness Testing",
              "Fracture Toughness",
              "Fatigue Properties"
            ]
          },
          "TestStandard": {
            "type": "string"
          },
          "SampleHeatTreatment": {
            "type": "object",
            "properties": {
              "Description": { "type": "string" },
              "Steps": {
                "type": "array",
                "items": {
                  "type": "object",
                  "properties": {
                    "Process": {
                      "type": "string",
                      "enum": ["Normalise", "Harden", "Temper", "Anneal", "Quench", "Age"]
                    },
                    "Temperature": { "type": "number" },
                    "TemperatureUnit": { "type": "string", "enum": ["°C", "°F", "K"] },
                    "Duration": { "type": "string" },
                    "CoolingMethod": {
                      "type": "string",
                      "enum": ["Air Cool", "Oil Quench", "Water Quench", "Furnace Cool"]
                    }
                  }
                }
              }
            }
          },
          "TestTemperature": { "type": "number" },
          "TestTemperatureUnit": { 
            "type": "string", 
            "enum": ["°C", "°F", "K"],
            "default": "°C"
          },
          "TestEnvironment": {
            "type": "string",
            "enum": ["Air", "Vacuum", "Inert Gas", "Corrosive"]
          },
          "Properties": {
            "type": "array",
            "items": { "$ref": "#/$defs/Measurement" }
          }
        },
        "required": ["TestGroupId", "TestStandard", "Properties"]
      }
    }
  }
}
```

## Sample Data

```json
{
  "MechanicalProperties": [
    {
      "TestGroupId": "MECH-001",
      "TestGroupName": "Tensile Properties",
      "TestStandard": "ASTM E8-16a",
      "SampleHeatTreatment": {
        "Description": "Standard heat treatment per specification",
        "Steps": [
          {
            "Process": "Normalise",
            "Temperature": 927,
            "TemperatureUnit": "°C",
            "Duration": "01:00hr",
            "CoolingMethod": "Air Cool"
          },
          {
            "Process": "Harden",
            "Temperature": 871,
            "TemperatureUnit": "°C",
            "Duration": "01:00hr",
            "CoolingMethod": "Oil Quench"
          },
          {
            "Process": "Temper",
            "Temperature": 302,
            "TemperatureUnit": "°C",
            "Duration": "02:00hr",
            "CoolingMethod": "Air Cool"
          }
        ]
      },
      "TestTemperature": 23,
      "TestTemperatureUnit": "°C",
      "Properties": [
        {
          "PropertySymbol": "Rm",
          "PropertyName": "Ultimate Tensile Strength",
          "Unit": "MPa",
          "Method": "ASTM E8-16a",
          "SampleLocation": "Centre",
          "SampleIdentifier": "3758176",
          "ResultType": "numeric",
          "Result": {
            "Value": 245.0,
            "DecimalPlaces": 1,
            "Minimum": 235,
            "IndividualValues": [243.0, 244.0, 248.0],
            "IndividualIdentifiers": ["3758180", "3758181", "3758182"],
            "Interpretation": "In Specification"
          },
          "Grade": "B"
        },
        {
          "PropertySymbol": "Rp0.2",
          "PropertyName": "0.2% Yield Strength",
          "Unit": "MPa",
          "ResultType": "numeric",
          "Result": {
            "Value": 290.0,
            "DecimalPlaces": 1,
            "Minimum": 280,
            "Interpretation": "In Specification"
          }
        },
        {
          "PropertySymbol": "A",
          "PropertyName": "Elongation",
          "Unit": "%",
          "ResultType": "numeric",
          "Result": {
            "Value": 42.0,
            "DecimalPlaces": 1,
            "Minimum": 38.0,
            "Interpretation": "In Specification"
          }
        },
        {
          "PropertySymbol": "Z",
          "PropertyName": "Reduction of Area",
          "Unit": "%",
          "ResultType": "numeric",
          "Result": {
            "Value": 11.0,
            "DecimalPlaces": 1,
            "Minimum": 10.5,
            "Interpretation": "In Specification"
          }
        }
      ]
    },
    {
      "TestGroupId": "MECH-002",
      "TestGroupName": "Impact Properties",
      "TestStandard": "BS EN ISO 148-1:2016 Ed 3",
      "TestTemperature": -40,
      "TestTemperatureUnit": "°C",
      "Properties": [
        {
          "PropertySymbol": "KV",
          "PropertyName": "Charpy V-Notch Impact Energy",
          "Unit": "J",
          "TestConditions": "Striker Radius: 8mm",
          "ResultType": "numeric",
          "Result": {
            "Value": 29,
            "DecimalPlaces": 0,
            "Minimum": 27,
            "IndividualValues": [29, 28, 30],
            "IndividualIdentifiers": ["3749140", "3777126", null],
            "Interpretation": "In Specification"
          }
        }
      ]
    },
    {
      "TestGroupId": "MECH-003",
      "TestGroupName": "Hardness Testing",
      "TestStandard": "ASTM E10-18",
      "Properties": [
        {
          "PropertySymbol": "HBW10/3000",
          "PropertyName": "Brinell Hardness",
          "Unit": "HBW",
          "SampleLocation": "Surface",
          "SampleIdentifier": "3749176",
          "ResultType": "numeric",
          "Result": {
            "Value": 293,
            "DecimalPlaces": 0,
            "Minimum": 280,
            "Maximum": 320,
            "Interpretation": "In Specification"
          }
        }
      ]
    }
  ]
}
```

## Notes

### Implementation Notes

- Group all properties tested under same conditions
- Heat treatment critical for mechanical properties
- Support multiple test temperatures (especially impact)
- Individual specimen tracking important
- Fracture position may determine acceptance
- Consider specimen orientation effects
- Statistical analysis often required

### Related Aspects

- Chemical Analysis (composition affects properties)
- Heat Treatment (processing determines properties)
- Product Form (size effects on properties)
- Standards Compliance (property requirements)
- Sampling (specimen location matters)
- Test Equipment (calibration critical)

### References

- ASTM E8/E8M: Standard Test Methods for Tension Testing
- ISO 6892-1: Metallic materials - Tensile testing at room temperature
- ASTM E23: Standard Test Methods for Notched Bar Impact Testing
- ISO 148-1: Metallic materials - Charpy pendulum impact test
- ASTM E18: Standard Test Methods for Rockwell Hardness
- ASTM E10: Standard Test Method for Brinell Hardness
- ASTM E399: Standard Test Method for Linear-Elastic Fracture Toughness