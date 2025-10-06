# Chemical Analysis

## Aspect Overview

### Aspect Name

**Name**: Chemical Analysis

### Aspect Category

- [ ] Physical Properties
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

| Field Name | Data Type | Required | Description | Example |
|------------|-----------|----------|-------------|---------|
| AnalysisType | string | Yes | Type of analysis performed | "Cast", "Check", "Product" |
| MeltingProcess | string | No | The metallurgical process used for melting and refining | "EAF+LF+VD" |
| HeatNumber | string | Yes | The heat or melt number defining the chemical properties | "8R518V" |
| CastingDate | date | No | The date when the heat was cast | "2024-03-15" |
| SampleLocation | string | No | Location where the chemical analysis sample was taken | "Ladle" |
| SampleType | string | No | The type of sample used for chemical analysis | "Liquid" |
| SampleMethod | string | No | Method of obtaining the sample | "Drilling", "Milling" |
| Elements | array[Measurement] | Yes | List of elements and their measured values | See sub-aspects |
| AnalysisStandard | string | No | Standard according to which analysis was performed | "ISO 10474" |
| TestSpecimenId | string | No | Identifier linking to test specimens | "8R518V" |

### Sub-aspects

Break down into specific components:

#### Sub-aspect 1: Analysis Types

- **Description**: Different types of chemical analyses performed
- **Common Types**:
  - Cast Analysis: Analysis at time of casting (ladle analysis)
  - Check Analysis: Verification analysis on product
  - Product Analysis: Final product chemistry
  - Retest Analysis: Additional verification
  - Heat Analysis: Combined/average analysis

#### Sub-aspect 2: Elements Classification

- **Description**: Grouping of chemical elements by type and significance
- **Categories**:
  - Major Elements: C, Si, Mn, P, S (typically in %)
  - Alloying Elements: Cr, Ni, Mo, Cu, Al, V, Ti, Nb (in %)
  - Trace Elements: H, N, O, B, Pb, As, Sn (in ppm or %)
  - Residual Elements: Elements not intentionally added
  - Calculated Values: CEV, Pcm, CET (carbon equivalents)

#### Sub-aspect 3: Sample Methods

- **Description**: Methods for obtaining chemical analysis samples
- **Common Methods**:
  - Liquid: From molten metal
  - Solid: From solidified product
  - Drilling: Drill chips from product
  - Milling: Milled chips from product
  - Chips: Pre-made chips
  - Spectro Disc: Prepared disc for spectrometry
  - Pin Sample: Pin extracted during casting

#### Sub-aspect 4: Multiple Analyses

- **Description**: Handling multiple analyses for same heat
- **Data Elements**:
  - Sequence: Order of analyses (Cast → Check)
  - Purpose: Reason for analysis
  - Variance: Acceptable differences between analyses
  - Certification: Which analysis is certified

## Validation Rules

### Required Validations

- HeatNumber is always required
- At least one Element must be present in Elements array
- Each Element must have PropertySymbol, Unit, and Actual
- Sum of all elements should be reasonable (typically ≤ 100% for full analysis)
- Major elements (Fe, C, etc.) should be present for ferrous materials
- AnalysisType must be specified when multiple analyses exist

### Format Validations

- HeatNumber must match mill's format (alphanumeric)
- CastingDate must be valid date format
- Element symbols must be valid chemical symbols
- Unit should typically be "%" or "ppm"
- Operator field in NumericResult critical for trace elements
- Cast Analysis should precede Check Analysis chronologically

### Business Rules

- Carbon (C) typically required for all steels
- Trace elements often reported with "<" operator
- Calculated values (e.g., CEV) must include Formula
- Maximum values more common than Minimum for impurities
- Analysis standard should match regional requirements
- Sample location affects acceptance criteria
- Check Analysis values may differ slightly from Cast Analysis
- Product Analysis takes precedence for certification

## Use Cases

### Primary Use Cases

1. **Material Verification**: Confirm material meets specification
2. **Quality Control**: Verify heat chemistry meets standards
3. **Traceability**: Link products to specific heats/melts
4. **Regulatory Compliance**: Meet industry standards (RoHS, REACH)
5. **Material Selection**: Choose materials based on composition
6. **Welding Procedures**: Calculate carbon equivalent for weldability
7. **Failure Analysis**: Investigate material-related failures
8. **Multi-Stage Verification**: Cast vs Product analysis comparison

### Integration Points

Where does this aspect connect with other parts of the format?

- **Product**: Links to material designations and standards
- **Mechanical Properties**: Chemistry affects mechanical behavior
- **Heat Treatment**: Chemistry determines heat treatment response
- **Measurements**: Elements are specialized measurements
- **Standards Compliance**: Chemistry must meet norm requirements
- **Traceability**: Heat number critical for tracking
- **Test Specimens**: Links analyses to physical samples

## Implementation Considerations

### Technical Requirements

- Support for multiple analyses per heat
- Support for "<" operator for trace elements
- Decimal places preservation for accurate reporting
- Formula parser for calculated values (CEV, Pcm)
- Support for both % and ppm units
- Validation against material standard requirements
- Sum validation for complete analyses
- Linking mechanism between analyses

### Standards Compliance

- ISO 10474: Steel and steel products - Inspection documents
- ASTM E415: Standard Test Method for Analysis of Carbon and Low-Alloy Steel
- ASTM E1019: Test Methods for Carbon, Sulfur, Nitrogen, and Oxygen
- EN 10204: Metallic products - Types of inspection documents
- ISO 14284: Steel and iron - Sampling and preparation of samples
- Industry-specific standards (API, ASME, aerospace)

### Industry Practices

- Major elements listed first (C, Si, Mn, P, S)
- Trace elements use "<" for below detection limit
- Residual elements grouped separately
- Carbon equivalent calculations standard for structural steel
- Nitrogen control critical for certain grades
- Multiple analyses common for critical applications
- Cast and Check analyses may show minor variations

## JSON Schema Example

```json
{
  "type": "object",
  "properties": {
    "ChemicalAnalyses": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "AnalysisType": {
            "type": "string",
            "enum": ["Cast", "Check", "Product", "Retest", "Heat"]
          },
          "MeltingProcess": {
            "type": "string",
            "examples": [
              "BOF", "EAF", "VIM", "VAR", "ESR",
              "BOF+LF", "EAF+LF", "EAF+LF+VD", "EAF+AOD+LF"
            ]
          },
          "HeatNumber": {
            "type": "string"
          },
          "TestSpecimenId": {
            "type": "string",
            "description": "Links to test specimen identification"
          },
          "CastingDate": {
            "type": "string",
            "format": "date"
          },
          "SampleLocation": {
            "type": "string",
            "enum": [
              "Ladle", "Product", "Test Piece",
              "1/4 thickness", "1/2 radius", "Surface", "Core"
            ]
          },
          "SampleType": {
            "type": "string",
            "enum": ["Solid", "Liquid", "Drilling", "Milling", "Chips", "Spectro Disc", "Pin Sample"]
          },
          "SampleMethod": {
            "type": "string",
            "enum": ["Drilling", "Milling", "Turning", "Punching", "Cutting"]
          },
          "Elements": {
            "type": "array",
            "items": { "$ref": "#/$defs
/ChemicalElement" },
            "minItems": 1
          },
          "AnalysisStandard": {
            "type": "string",
            "examples": ["ASTM E415", "ISO 10474", "EN 10204", "ASTM E1019"]
          }
        },
        "required": ["AnalysisType", "HeatNumber", "Elements"]
      }
    }
  }
}
```

## Sample Data

```json
{
  "ChemicalAnalyses": [
    {
      "AnalysisType": "Cast",
      "MeltingProcess": "EAF+LF+VD",
      "HeatNumber": "8R518V",
      "TestSpecimenId": "8R518V",
      "CastingDate": "2019-08-15",
      "SampleLocation": "Ladle",
      "SampleType": "Liquid",
      "AnalysisStandard": "ASTM E415",
      "Elements": [
        {
          "PropertySymbol": "C",
          "PropertyName": "Carbon",
          "Unit": "%",
          "Actual": {
            "ResultType": "numeric",
            "Value": 0.405,
            "Operator": "=",
            "DecimalPlaces": 3,
            "Minimum": 0.38
          }
        },
        {
          "PropertySymbol": "H2",
          "PropertyName": "Hydrogen",
          "Unit": "ppm",
          "Method": "ASTM E1019",
          "Actual": {
            "ResultType": "numeric",
            "Value": 1.5,
            "Operator": "=",
            "DecimalPlaces": 1,
            "Maximum": 2.0
          }
        },
        {
          "PropertySymbol": "Si",
          "PropertyName": "Silicon",
          "Unit": "%",
          "Actual": {
            "ResultType": "numeric",
            "Value": 1.65,
            "Operator": "=",
            "DecimalPlaces": 2,
            "ExclusiveMinimum": 1.0,
            "ExclusiveMaximum": 2.0
          }
        }
      ]
    },
    {
      "AnalysisType": "Check",
      "HeatNumber": "8R518V",
      "TestSpecimenId": "3749168",
      "SampleLocation": "Product",
      "SampleType": "Solid",
      "SampleMethod": "Drilling",
      "Elements": [
        {
          "PropertySymbol": "C",
          "PropertyName": "Carbon",
          "Unit": "%",
          "SampleIdentifier": "3749168",
          "Actual": {
            "ResultType": "numeric",
            "Value": 0.41,
            "Operator": "=",
            "DecimalPlaces": 2,
            "Minimum": 0.38
          }
        },
        {
          "PropertySymbol": "H2",
          "PropertyName": "Hydrogen",
          "Unit": "ppm",
          "SampleIdentifier": "3749168",
          "Method": "ASTM E1019",
          "Actual": {
            "ResultType": "numeric",
            "Value": 1.2,
            "Operator": "=",
            "DecimalPlaces": 1,
            "Maximum": 2.0
          }
        },
        {
          "PropertySymbol": "Si",
          "PropertyName": "Silicon",
          "Unit": "%",
          "SampleIdentifier": "3749168",
          "Actual": {
            "ResultType": "numeric",
            "Value": 1.67,
            "Operator": "=",
            "DecimalPlaces": 2,
            "ExclusiveMinimum": 1.0,
            "ExclusiveMaximum": 2.0
          }
        }
      ]
    }
  ]
}
```

## Notes

### Implementation Notes

- Support for multiple analyses (Cast, Check) for same heat
- Cast Analysis typically from ladle, Check from product
- Minor variations between Cast and Check are normal
- Operator field critical for trace elements ("<" values)
- Consider separate display for major/minor/trace elements
- DecimalPlaces varies by element (C: 2-3, P/S: 3-4, trace: 4)
- Support both % and ppm units with conversion
- Heat number format varies by mill - allow flexible format
- TestSpecimenId links to mechanical test specimens

### Related Aspects

- Product (material grade determines chemistry requirements)
- Mechanical Properties (chemistry influences properties)
- Heat Treatment (chemistry determines parameters)
- Standards Compliance (chemistry must meet specifications)
- Traceability (heat number links all products)
- Environmental Compliance (RoHS, REACH requirements)
- Test Specimens (links chemistry to physical samples)

### References

- ISO 10474: Steel and steel products - Inspection documents
- ASTM E415: Analysis of Carbon and Low-Alloy Steel by Spark AES
- ASTM E1019: Determination of Carbon, Sulfur, Nitrogen, and Oxygen
- EN 10204: Metallic products - Types of inspection documents
- ISO 14284: Steel and iron - Sampling and preparation
- ASTM E350: Standard Test Methods for Chemical Analysis of Carbon Steel
- ASTM E1251: Standard Test Method for Analysis of Aluminum and Aluminum Alloys