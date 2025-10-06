# Physical Properties

## Aspect Overview

### Aspect Name

**Name**: Physical Properties

### Aspect Category

- [x] Physical Properties
- [ ] Chemical Properties
- [ ] Delivery Conditions
- [ ] Processing Information
- [ ] Quality Attributes
- [ ] Compliance Data
- [ ] Sustainability Metrics
- [ ] Other: ****\_\_\_****

### Priority

- [ ] Core (Required)
- [x] Standard (Recommended)
- [ ] Extended (Optional)

## Data Structure

### Primary Data Elements

This aspect uses the universal Measurement structure defined in the Measurements FAM. The following table shows common physical properties:

| Property Category | Common Properties | Typical Units | Example Standards |
|-------------------|-------------------|---------------|-------------------|
| Density | Density, Specific Gravity | g/cm³, kg/m³ | ASTM B311, ISO 3369 |
| Thermal | Thermal Conductivity, Expansion Coefficient, Specific Heat | W/m·K, µm/m·K, J/kg·K | ASTM E1461, ASTM E831 |
| Electrical | Electrical Resistivity, Conductivity | µΩ·cm, %IACS | ASTM B193, IEC 60468 |
| Magnetic | Permeability, Coercivity, Saturation | H/m, A/m, T | ASTM A773, IEC 60404 |
| Optical | Reflectance, Emissivity | %, - | ASTM E1933 |
| Dimensional | Grain Size, Surface Roughness | ASTM #, µm | ASTM E112, ISO 4287 |

### Sub-aspects

Break down into specific components:

#### Sub-aspect 1: Thermal Properties

- **Description**: Properties related to heat transfer and thermal behavior
- **Common Measurements**:
  - Thermal Conductivity (k): Heat transfer capability
  - Coefficient of Thermal Expansion (CTE): Dimensional change with temperature
  - Specific Heat Capacity (Cp): Heat storage capability
  - Thermal Diffusivity: Heat propagation rate
  - Melting Point/Range: Phase transition temperature
  - Glass Transition Temperature (Tg): For applicable materials

#### Sub-aspect 2: Electrical Properties

- **Description**: Properties related to electrical conduction and resistance
- **Common Measurements**:
  - Electrical Resistivity (ρ): Material's opposition to current flow
  - Electrical Conductivity (σ): Ability to conduct current
  - IACS Conductivity: Percentage of International Annealed Copper Standard
  - Dielectric Strength: For insulating materials
  - Temperature Coefficient of Resistance (TCR)

#### Sub-aspect 3: Magnetic Properties

- **Description**: Response to magnetic fields
- **Common Measurements**:
  - Magnetic Permeability (µ): Ability to support magnetic field
  - Coercivity (Hc): Resistance to demagnetization
  - Saturation Magnetization (Ms): Maximum magnetic moment
  - Remanence (Br): Residual magnetization
  - Curie Temperature: Magnetic transition temperature

#### Sub-aspect 4: Density and Porosity

- **Description**: Mass per unit volume and void content
- **Common Measurements**:
  - Density: Mass per unit volume
  - Apparent Density: Including closed porosity
  - Bulk Density: Including all voids
  - Porosity: Volume fraction of voids
  - Specific Gravity: Relative to water

#### Sub-aspect 5: Surface and Microstructural Properties

- **Description**: Surface characteristics and internal structure
- **Common Measurements**:
  - Surface Roughness (Ra, Rz): Surface texture parameters
  - Grain Size: Average grain diameter or ASTM number
  - Phase Content: Volume fraction of phases
  - Texture/Orientation: Crystallographic preferred orientation
  - Coating Thickness: For coated products

## Validation Rules

### Required Validations

- All measurements must follow the universal Measurement schema
- Temperature-dependent properties must specify test temperature
- Direction-dependent properties must specify orientation
- Statistical properties should include number of measurements

### Format Validations

- Units must be appropriate for the property type
- Method must reference recognized test standards
- Temperature conditions critical for thermal/electrical properties
- Sample preparation method may affect results

### Business Rules

- Density typically reported at room temperature unless specified
- Electrical conductivity often reported as %IACS for conductors
- Thermal expansion usually given as average over temperature range
- Magnetic properties may require specific field conditions
- Surface roughness parameters must specify measurement standard

## Use Cases

### Primary Use Cases

1. **Design Engineering**: Select materials based on physical properties
2. **Quality Control**: Verify material meets physical property specs
3. **Thermal Management**: Design heat sinks, insulation systems
4. **Electrical Systems**: Select conductors and insulators
5. **Magnetic Applications**: Design motors, transformers, shields
6. **Process Control**: Monitor property variations
7. **Failure Analysis**: Compare properties to specifications

### Integration Points

Where does this aspect connect with other parts of the format?

- **Chemical Analysis**: Composition affects physical properties
- **Processing History**: Heat treatment affects properties
- **Microstructure**: Grain size, phase content
- **Product Form**: Size and shape effects
- **Temperature Conditions**: Many properties temperature-dependent
- **Measurement Conditions**: Environmental effects

## Implementation Considerations

### Technical Requirements

- Support for temperature-dependent properties
- Handle directional properties (anisotropy)
- Enable property curves (e.g., CTE vs temperature)
- Support various measurement conditions
- Allow for derived properties (e.g., thermal diffusivity)

### Standards Compliance

- ASTM E1461: Thermal Diffusivity by Flash Method
- ASTM E831: Linear Thermal Expansion
- ASTM B193: Resistivity of Electrical Conductor Materials
- ASTM A773: DC Magnetic Properties
- ASTM E112: Determining Average Grain Size
- ISO 4287: Surface Texture Parameters
- IEC 60404: Magnetic Materials Standards

### Industry Practices

- Report test temperature for temperature-sensitive properties
- Specify measurement direction for anisotropic materials
- Include measurement uncertainty when critical
- Reference specific test methods
- Report environmental conditions (humidity, atmosphere)
- Multiple measurements for statistical confidence

## JSON Schema Example

```json
{
  "type": "object",
  "properties": {
    "PhysicalProperties": {
      "type": "array",
      "items": {
        "$ref": "#/$defs
/Measurement"
      },
      "examples": [
        {
          "PropertySymbol": "ρ",
          "PropertyName": "Density",
          "Unit": "g/cm³",
          "Method": "ASTM B311",
          "TestConditions": "20°C",
          "ResultType": "numeric",
          "Result": {
            "Value": 7.85,
            "DecimalPlaces": 2,
            "Interpretation": "In Specification"
          }
        },
        {
          "PropertySymbol": "k",
          "PropertyName": "Thermal Conductivity",
          "Unit": "W/m·K",
          "Method": "ASTM E1461",
          "TestConditions": "25°C",
          "ResultType": "numeric",
          "Result": {
            "Value": 50.2,
            "DecimalPlaces": 1,
            "Minimum": 45.0,
            "Interpretation": "In Specification"
          }
        },
        {
          "PropertySymbol": "CTE",
          "PropertyName": "Coefficient of Thermal Expansion",
          "Unit": "µm/m·K",
          "Method": "ASTM E831",
          "TestConditions": "20-100°C",
          "ResultType": "numeric",
          "Result": {
            "Value": 11.8,
            "DecimalPlaces": 1,
            "Interpretation": "In Specification"
          }
        }
      ]
    }
  }
}
```

## Sample Data

```json
{
  "PhysicalProperties": [
    {
      "PropertySymbol": "ρ",
      "PropertyName": "Density",
      "Unit": "g/cm³",
      "Method": "ASTM B311",
      "TestConditions": "20°C",
      "SampleLocation": "Centre",
      "ResultType": "numeric",
      "Result": {
        "Value": 7.85,
        "DecimalPlaces": 2,
        "Target": 7.85,
        "Interpretation": "In Specification"
      }
    },
    {
      "PropertySymbol": "σ",
      "PropertyName": "Electrical Conductivity",
      "Unit": "%IACS",
      "Method": "ASTM B193",
      "TestConditions": "20°C",
      "ResultType": "numeric",
      "Result": {
        "Value": 2.9,
        "DecimalPlaces": 1,
        "Minimum": 2.5,
        "Interpretation": "In Specification"
      }
    },
    {
      "PropertySymbol": "CTE",
      "PropertyName": "Mean Coefficient of Thermal Expansion",
      "Unit": "µm/m·K",
      "Method": "ASTM E831",
      "TestConditions": "20-300°C",
      "ResultType": "array",
      "Result": {
        "ParameterName": "Temperature Range",
        "ParameterUnit": "°C",
        "ValueName": "Thermal Expansion",
        "ValueUnit": "µm/m·K",
        "DecimalPlaces": 1,
        "Data": [
          {
            "Parameter": "20-100",
            "Value": 11.8
          },
          {
            "Parameter": "20-200",
            "Value": 12.3
          },
          {
            "Parameter": "20-300",
            "Value": 12.9
          }
        ],
        "Interpretation": "In Specification"
      }
    },
    {
      "PropertySymbol": "µr",
      "PropertyName": "Relative Magnetic Permeability",
      "Unit": "-",
      "Method": "ASTM A773",
      "TestConditions": "H=800 A/m",
      "ResultType": "numeric",
      "Result": {
        "Value": 1.02,
        "DecimalPlaces": 2,
        "Maximum": 1.05,
        "Interpretation": "In Specification"
      }
    },
    {
      "PropertySymbol": "GS",
      "PropertyName": "Average Grain Size",
      "Unit": "ASTM",
      "Method": "ASTM E112",
      "TestConditions": "Longitudinal section",
      "ResultType": "numeric",
      "Result": {
        "Value": 7,
        "DecimalPlaces": 0,
        "Minimum": 5,
        "Interpretation": "In Specification"
      }
    },
    {
      "PropertySymbol": "Ra",
      "PropertyName": "Surface Roughness",
      "Unit": "µm",
      "Method": "ISO 4287",
      "TestConditions": "Cutoff 0.8mm",
      "SampleLocation": "Top surface",
      "ResultType": "numeric",
      "Result": {
        "Value": 1.2,
        "DecimalPlaces": 1,
        "Maximum": 3.2,
        "Interpretation": "In Specification"
      }
    }
  ]
}
```

## Notes

### Implementation Notes

- Many physical properties are temperature-dependent
- Some properties are directional (anisotropic)
- Measurement conditions must be clearly specified
- Units vary widely - careful validation needed
- Some properties derived from multiple measurements
- Environmental conditions may be critical

### Extensibility

This FAM provides examples of common physical properties but is not exhaustive. The universal Measurement structure allows for any physical property to be recorded with appropriate:
- Property identification (symbol, name, ID)
- Value and constraints
- Test method and conditions
- Units and interpretation

### Related Aspects

- Measurements (base structure for all properties)
- Chemical Analysis (composition affects properties)
- Processing/Heat Treatment (affects microstructure)
- Product Form (geometry affects some measurements)
- Test Conditions (temperature, environment)
- Sampling (location and orientation matter)

### References

- ASTM E1269: Specific Heat Capacity by DSC
- ASTM D792: Density and Specific Gravity
- ASTM E1530: Thermal Conductivity
- IEC 60404-4: Methods of measurement of d.c. magnetic properties
- ISO 6892-1: Metallic materials - Tensile testing
- ASTM A255: Determining Hardenability of Steel