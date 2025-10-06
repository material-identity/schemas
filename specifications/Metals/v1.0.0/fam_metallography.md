# Metallography

## Aspect Overview

### Aspect Name

**Name**: Metallography

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

- [ ] Core (Required)
- [x] Standard (Recommended)
- [ ] Extended (Optional)

## Data Structure

### Primary Data Elements

List the main data fields for this aspect:

| Field Name | Data Type | Required | Description | Example |
|------------|-----------|----------|-------------|---------|
| ExaminationId | string | Yes | Unique identifier for the metallographic examination | "METALLO-001" |
| ExaminationName | string | No | Descriptive name for the examination | "Microstructure Analysis" |
| Standard | string | Yes | Primary examination standard | "ASTM E3-11" |
| SamplePreparation | object | No | Sample preparation details | See sub-aspect |
| EtchingDetails | object | No | Etching method and conditions | See sub-aspect |
| Magnifications | array[number] | No | Magnification levels used | [100, 500, 1000] |
| Examiner | string | No | Name/ID of examiner | "Dr. Smith" |
| ExaminationDate | date | No | Date of examination | "2024-03-15" |
| Measurements | array[Measurement] | Yes | Individual metallographic measurements | See Measurements FAM |

### Sub-aspects

Break down into specific components:

#### Sub-aspect 1: Microstructure Analysis

- **Description**: Identification and quantification of phases and constituents
- **Common Measurements**:
  - Phase Content: Volume fraction of phases (ferrite, pearlite, bainite, martensite)
  - Grain Size: ASTM grain size number or linear intercept
  - Grain Shape: Aspect ratio, elongation factor
  - Phase Distribution: Homogeneity, banding assessment
  - Matrix Structure: Primary phase characteristics
  - Second Phase Particles: Size, distribution, morphology

#### Sub-aspect 2: Quantitative Metallography

- **Description**: Statistical measurements using stereological principles
- **Common Measurements**:
  - Volume Fraction: Percentage of phases/constituents
  - Number Density: Particles per unit area
  - Mean Free Path: Average distance between particles
  - Spacing Measurements: Interparticle, interlamellar spacing
  - Size Distribution: Statistical grain/particle size data
  - Connectivity: Phase connectivity measurements

#### Sub-aspect 3: Crystallographic Analysis

- **Description**: Texture and orientation measurements
- **Common Measurements**:
  - Texture Coefficients: Crystallographic texture intensity
  - Orientation Distribution: Pole figures, ODF data
  - Preferred Orientation: Texture strength and components
  - Grain Boundary Character: Coincidence site lattice boundaries
  - Misorientation: Angular relationships between grains

#### Sub-aspect 4: Sample Preparation

- **Description**: Metallographic sample preparation details
- **Data Elements**:
  - SectionOrientation: String - Sample sectioning plane
  - MountingMethod: String - Mounting material and method
  - GrindingSequence: Array - Grit sequence used
  - PolishingSteps: Array - Polishing compounds and times
  - PreparationTime: String - Total preparation time
  - AutomatedPrep: Boolean - Whether automated preparation used

#### Sub-aspect 5: Etching Details

- **Description**: Chemical etching parameters
- **Data Elements**:
  - EtchantType: String - Chemical etchant composition
  - EtchingMethod: String - Immersion, swabbing, electrolytic
  - EtchingTime: String - Duration of etching
  - Temperature: Number - Etching temperature
  - Voltage: Number - For electrolytic etching
  - PostEtchTreatment: String - Cleaning or neutralization

#### Sub-aspect 6: Image Analysis

- **Description**: Digital image analysis parameters and results
- **Data Elements**:
  - ImageResolution: String - Pixel resolution
  - AnalysisSoftware: String - Software used for analysis
  - ThresholdingMethod: String - Segmentation approach
  - CalibrationStandard: String - Length calibration reference
  - StatisticalSampling: Object - Sampling strategy and field count
  - QualityMetrics: Object - Image quality assessments

## Validation Rules

### Required Validations

- ExaminationId is always required
- At least one Measurement must be present in Measurements array
- Standard must reference recognized metallographic standard
- Magnifications should be reasonable values (10x to 50000x)
- If etching is performed, EtchingDetails should be provided
- Volume fractions should sum to ≤ 100% when measuring phases

### Format Validations

- ExaminationId must be alphanumeric with allowed separators
- ExaminationDate must be valid date format
- Magnifications must be positive integers
- Temperature values must include units when specified
- EtchingTime must follow duration format (e.g., "30s", "2min")
- Phase symbols must use standard metallographic notation

### Business Rules

- Primary phases (ferrite, austenite, etc.) typically have higher volume fractions
- Grain size measurements should specify linear intercept or planimetric method
- Texture measurements require specific sample orientations
- Image analysis results should include statistical confidence measures
- Multiple fields should be examined for statistical validity
- Etching should be appropriate for the material system

## Use Cases

### Primary Use Cases

1. **Quality Control**: Verify microstructure meets specifications
2. **Failure Analysis**: Investigate microstructural causes of failure
3. **Process Development**: Optimize heat treatment and processing
4. **Material Characterization**: Document microstructural features
5. **Research & Development**: Study phase transformations and properties
6. **Compliance Verification**: Meet industry standards and specifications
7. **Comparative Analysis**: Compare microstructures across batches
8. **Texture Analysis**: Assess forming behavior and anisotropy

### Integration Points

Where does this aspect connect with other parts of the format?

- **Chemical Analysis**: Composition affects phase formation
- **Heat Treatment**: Processing determines microstructure
- **Mechanical Properties**: Microstructure controls properties
- **Physical Properties**: Structure affects physical behavior
- **Quality Attributes**: Microstructure indicates quality
- **Test Specimens**: Links to physical sample identification
- **Standards Compliance**: Meets metallographic requirements

## Implementation Considerations

### Technical Requirements

- Support for multiple measurement types (numeric, string, array)
- Image storage and reference capabilities
- Statistical data handling for quantitative measurements
- Multi-magnification examination support
- Phase identification and quantification
- Standardized metallographic terminology
- Integration with microscopy equipment data
- Support for automated image analysis results

### Standards Compliance

- ASTM E3: Standard Guide for Preparation of Metallographic Specimens
- ASTM E112: Standard Test Methods for Determining Average Grain Size
- ASTM E1382: Standard Test Methods for Determining Average Grain Size Using Semiautomatic and Automatic Image Analysis
- ASTM E562: Standard Test Method for Determining Volume Fraction by Systematic Manual Point Count
- ASTM E1181: Standard Test Methods for Characterizing Duplex Grain Sizes
- ISO 643: Steels - Micrographic determination of the apparent grain size
- ISO 4499: Hardmetals - Metallographic determination of microstructure

### Industry Practices

- Multiple fields examined for statistical validity (typically 5-10 fields)
- Standardized etching procedures for each material system
- Appropriate magnification selection based on microstructural features
- Documentation of sample orientation relative to working direction
- Statistical analysis of quantitative measurements
- Digital image archiving with metadata
- Calibrated measurement systems with traceability

## JSON Schema Example

```json
{
  "type": "object",
  "properties": {
    "MetallographicExamination": {
      "type": "object",
      "properties": {
        "ExaminationId": {
          "type": "string"
        },
        "ExaminationName": {
          "type": "string"
        },
        "Standard": {
          "type": "string",
          "examples": ["ASTM E3-11", "ISO 643", "ASTM E112"]
        },
        "SamplePreparation": {
          "type": "object",
          "properties": {
            "SectionOrientation": {
              "type": "string",
              "enum": ["Longitudinal", "Transverse", "Through-thickness", "45-degree"]
            },
            "MountingMethod": {
              "type": "string",
              "enum": ["Compression", "Castable", "Cold", "Clamping"]
            },
            "GrindingSequence": {
              "type": "array",
              "items": { "type": "string" },
              "examples": [["240", "400", "600", "800", "1200"]]
            },
            "PolishingSteps": {
              "type": "array",
              "items": {
                "type": "object",
                "properties": {
                  "Compound": { "type": "string" },
                  "Size": { "type": "string" },
                  "Time": { "type": "string" }
                }
              }
            },
            "AutomatedPrep": { "type": "boolean" }
          }
        },
        "EtchingDetails": {
          "type": "object",
          "properties": {
            "EtchantType": {
              "type": "string",
              "examples": ["Nital", "Picral", "Marble's", "Klemm's", "Beraha's"]
            },
            "EtchingMethod": {
              "type": "string",
              "enum": ["Immersion", "Swabbing", "Electrolytic", "Ion beam"]
            },
            "EtchingTime": { "type": "string" },
            "Temperature": { "type": "number" },
            "TemperatureUnit": { "type": "string" },
            "Voltage": { "type": "number" },
            "PostEtchTreatment": { "type": "string" }
          }
        },
        "Magnifications": {
          "type": "array",
          "items": { "type": "integer", "minimum": 10, "maximum": 50000 }
        },
        "Examiner": { "type": "string" },
        "ExaminationDate": { "type": "string", "format": "date" },
        "Measurements": {
          "type": "array",
          "items": { "$ref": "#/$defs/Measurement" },
          "minItems": 1
        }
      },
      "required": ["ExaminationId", "Standard", "Measurements"]
    }
  }
}
```

## Sample Data

```json
{
  "MetallographicExamination": {
    "ExaminationId": "METALLO-001",
    "ExaminationName": "Low Carbon Steel Microstructure Analysis",
    "Standard": "ASTM E3-11",
    "SamplePreparation": {
      "SectionOrientation": "Transverse",
      "MountingMethod": "Compression",
      "GrindingSequence": ["240", "400", "600", "800", "1200"],
      "PolishingSteps": [
        {
          "Compound": "Diamond suspension",
          "Size": "6 μm",
          "Time": "5 min"
        },
        {
          "Compound": "Diamond suspension", 
          "Size": "1 μm",
          "Time": "3 min"
        },
        {
          "Compound": "Colloidal silica",
          "Size": "0.05 μm", 
          "Time": "2 min"
        }
      ],
      "AutomatedPrep": true
    },
    "EtchingDetails": {
      "EtchantType": "2% Nital",
      "EtchingMethod": "Immersion",
      "EtchingTime": "15s",
      "Temperature": 23,
      "TemperatureUnit": "°C",
      "PostEtchTreatment": "Alcohol rinse and air dry"
    },
    "Magnifications": [100, 500, 1000],
    "Examiner": "Dr. A. Metallurgist",
    "ExaminationDate": "2024-03-15",
    "Measurements": [
      {
        "PropertySymbol": "αVf",
        "PropertyName": "Ferrite Volume Fraction",
        "Unit": "%",
        "Method": "ASTM E562",
        "TestConditions": "500X magnification, 10 fields",
        "ResultType": "numeric",
        "Result": {
          "Value": 75.2,
          "DecimalPlaces": 1,
          "Minimum": 70.0,
          "Maximum": 80.0,
          "Statistics": {
            "StandardDeviation": 2.1,
            "Count": 10,
            "Range": 6.5
          },
          "Interpretation": "In Specification"
        }
      },
      {
        "PropertySymbol": "PVf",
        "PropertyName": "Pearlite Volume Fraction", 
        "Unit": "%",
        "Method": "ASTM E562",
        "TestConditions": "500X magnification, 10 fields",
        "ResultType": "numeric",
        "Result": {
          "Value": 24.8,
          "DecimalPlaces": 1,
          "Minimum": 20.0,
          "Maximum": 30.0,
          "Statistics": {
            "StandardDeviation": 2.1,
            "Count": 10,
            "Range": 6.5
          },
          "Interpretation": "In Specification"
        }
      },
      {
        "PropertySymbol": "GS",
        "PropertyName": "Ferrite Grain Size",
        "Unit": "ASTM",
        "Method": "ASTM E112",
        "TestConditions": "100X magnification, linear intercept",
        "ResultType": "numeric",
        "Result": {
          "Value": 8.5,
          "DecimalPlaces": 1,
          "Minimum": 7.0,
          "Statistics": {
            "StandardDeviation": 0.3,
            "Count": 200,
            "Range": 1.2
          },
          "Interpretation": "In Specification"
        }
      },
      {
        "PropertySymbol": "Banding",
        "PropertyName": "Microstructural Banding",
        "Unit": "Rating",
        "Method": "ASTM A588",
        "TestConditions": "100X magnification, longitudinal section",
        "ResultType": "numeric",
        "Result": {
          "Value": 2,
          "DecimalPlaces": 0,
          "Maximum": 3,
          "Interpretation": "In Specification"
        }
      },
      {
        "PropertySymbol": "PearSpacing",
        "PropertyName": "Pearlite Interlamellar Spacing",
        "Unit": "nm",
        "Method": "Linear Intercept",
        "TestConditions": "1000X magnification, 50 measurements",
        "ResultType": "numeric",
        "Result": {
          "Value": 285,
          "DecimalPlaces": 0,
          "Statistics": {
            "StandardDeviation": 45,
            "Count": 50,
            "Range": 180
          },
          "Interpretation": "Typical for this composition"
        }
      },
      {
        "PropertySymbol": "Texture",
        "PropertyName": "Crystallographic Texture Analysis",
        "Unit": "Intensity",
        "Method": "EBSD",
        "TestConditions": "20kV, 70° tilt, 1μm step size",
        "ResultType": "array",
        "Result": {
          "ParameterName": "Texture Component",
          "ParameterUnit": "Miller Indices",
          "ValueName": "Intensity",
          "ValueUnit": "Multiples of Random",
          "DecimalPlaces": 2,
          "Data": [
            {
              "Parameter": "{100}<011>",
              "Value": 2.45,
              "Status": "Pass"
            },
            {
              "Parameter": "{110}<112>",
              "Value": 1.85,
              "Status": "Pass"
            },
            {
              "Parameter": "{111}<110>",
              "Value": 0.95,
              "Status": "Pass"
            }
          ],
          "Interpretation": "Weak rolling texture typical for low carbon steel"
        }
      },
      {
        "PropertySymbol": "Cleanliness",
        "PropertyName": "Steel Cleanliness Assessment",
        "Unit": "Classification",
        "Method": "ASTM E45 Method A",
        "TestConditions": "100X magnification, worst field",
        "ResultType": "string",
        "Result": {
          "Value": "A1.5 B1.0 C0.5 D1.0 - Fine",
          "Interpretation": "In Specification"
        }
      }
    ]
  }
}
```

## Notes

### Implementation Notes

- Multiple measurement types support different metallographic analyses
- Statistical sampling critical for quantitative measurements
- Image archiving and metadata management important for traceability
- Automated analysis integration reduces subjectivity and improves repeatability
- Sample preparation details affect measurement validity
- Multiple magnifications often required for complete characterization
- Etching parameters must be documented for reproducibility

### Related Aspects

- Chemical Analysis (composition affects microstructure)
- Mechanical Properties (structure-property relationships)
- Heat Treatment (processing-microstructure relationships)
- Physical Properties (microstructure affects properties)
- Quality Attributes (microstructural quality indicators)
- Test Specimens (sample identification and tracking)
- Standards Compliance (metallographic requirements)

### References

- ASTM E3: Standard Guide for Preparation of Metallographic Specimens
- ASTM E112: Standard Test Methods for Determining Average Grain Size
- ASTM E562: Standard Test Method for Determining Volume Fraction by Systematic Manual Point Count
- ASTM E1382: Standard Test Methods for Determining Average Grain Size Using Semiautomatic and Automatic Image Analysis
- ISO 643: Steels - Micrographic determination of the apparent grain size
- ASM Handbook Vol. 9: Metallography and Microstructures
- Vander Voort, G.F.: Metallography, Principles and Practice