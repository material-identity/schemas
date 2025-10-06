# Supplementary Tests

## Aspect Overview

### Aspect Name

**Name**: Supplementary Tests

### Aspect Category

- [ ] Physical Properties
- [ ] Chemical Properties
- [ ] Delivery Conditions
- [x] Processing Information
- [x] Quality Attributes
- [ ] Compliance Data
- [ ] Sustainability Metrics
- [ ] Other: ****\_\_\_****

### Priority

- [ ] Core (Required)
- [x] Standard (Recommended)
- [ ] Extended (Optional)

## Data Structure

### Primary Data Elements

This aspect uses the universal Measurement structure defined in the Measurements FAM. Supplementary tests encompass any additional testing beyond standard mechanical, physical, and chemical properties:

| Test Category | Common Tests | Result Types | Purpose |
|---------------|--------------|--------------|---------|
| Non-Destructive | Ultrasonic, Radiographic, Magnetic Particle | Boolean/String | Defect detection |
| Metallographic | Microstructure, Inclusion Rating | String/Numeric | Quality assessment |
| Corrosion | Salt Spray, Pitting, Intergranular | Numeric/String | Durability |
| Surface | Coating thickness, Adhesion | Numeric/Boolean | Coating quality |
| Dimensional | Straightness, Flatness, Profile | Numeric | Geometric conformance |
| Special | Customer-specific, Prototype tests | Various | Specific requirements |

### Sub-aspects

Break down into specific components:

#### Sub-aspect 1: Non-Destructive Testing (NDT)

- **Description**: Tests that don't damage the material
- **Common Tests**:
  - Ultrasonic Testing (UT): Internal defect detection
  - Radiographic Testing (RT): X-ray or gamma ray inspection
  - Magnetic Particle Testing (MT): Surface crack detection
  - Dye Penetrant Testing (PT): Surface defect detection
  - Eddy Current Testing (ET): Conductivity and defects
  - Visual Testing (VT): Surface inspection
- **Typical Results**: Pass/Fail, defect size/location, acceptance class

#### Sub-aspect 2: Metallographic Examination

- **Description**: Microscopic structure analysis
- **Common Tests**:
  - Microstructure Analysis: Phase identification, grain structure
  - Inclusion Rating: Non-metallic inclusion assessment
  - Decarburization Depth: Surface carbon loss
  - Case Depth: Hardened layer thickness
  - Coating Structure: Layer analysis
  - Weld Examination: HAZ and weld quality
- **Typical Results**: Descriptive, ratings, measurements

#### Sub-aspect 3: Corrosion Testing

- **Description**: Resistance to environmental degradation
- **Common Tests**:
  - Salt Spray Test: Hours to failure/corrosion
  - Intergranular Corrosion: Susceptibility testing
  - Pitting Resistance: Critical pitting temperature
  - Stress Corrosion Cracking: Time to failure
  - Galvanic Corrosion: Compatibility testing
  - Atmospheric Exposure: Field testing
- **Typical Results**: Time to failure, corrosion rate, pass/fail

#### Sub-aspect 4: Surface and Coating Tests

- **Description**: Surface treatment quality and performance
- **Common Tests**:
  - Coating Thickness: Multiple methods (magnetic, eddy current)
  - Adhesion Testing: Pull-off, tape test, bend test
  - Porosity Testing: Ferroxyl test, electrochemical
  - Hardness Profile: Through-thickness hardness
  - Surface Contamination: Cleanliness testing
  - Paint/Plating Quality: Various specific tests
- **Typical Results**: Thickness values, adhesion strength, ratings

#### Sub-aspect 5: Dimensional and Geometric Tests

- **Description**: Shape and dimensional conformance beyond basic measurements
- **Common Tests**:
  - Straightness/Flatness: Deviation measurements
  - Profile Tolerance: Shape conformance
  - Roundness/Ovality: Circular geometry
  - Parallelism/Perpendicularity: Angular relationships
  - Thread Inspection: Thread geometry and quality
  - Weld Dimensions: Weld size and profile
- **Typical Results**: Deviation values, conformance statements

#### Sub-aspect 6: Special Customer Tests

- **Description**: Non-standard or customer-specific requirements
- **Common Tests**:
  - Prototype Testing: New product validation
  - Simulated Service: Application-specific tests
  - Fatigue Testing: Cyclic loading
  - Creep Testing: Long-term deformation
  - Environmental Testing: Combined stresses
  - Functional Testing: Performance validation
- **Typical Results**: Various formats based on test type

## Validation Rules

### Required Validations

- All tests must follow universal Measurement schema
- Test method or procedure must be specified
- Pass/fail criteria should be clear
- For qualitative results, grading scales must be defined
- Inspector qualifications may be required for certain tests

### Format Validations

- NDT results often use specific classification systems
- Inclusion ratings follow standard charts (e.g., ASTM E45)
- Corrosion test duration must include units
- Coating thickness typically in micrometers or mils
- Geometric tolerances follow GD&T standards

### Business Rules

- NDT often requires certified operators
- Acceptance criteria vary by application
- Some tests are informational only
- Customer approval may override standard criteria
- Witness testing may be required
- Frequency of testing varies by criticality

## Use Cases

### Primary Use Cases

1. **Quality Assurance**: Verify product meets all requirements
2. **Customer Satisfaction**: Meet specific customer needs
3. **Defect Detection**: Find internal/surface defects
4. **Process Validation**: Confirm manufacturing quality
5. **Failure Prevention**: Identify potential problems
6. **Regulatory Compliance**: Meet industry-specific requirements
7. **Continuous Improvement**: Monitor process capability

### Integration Points

Where does this aspect connect with other parts of the format?

- **Product Specification**: Defines required tests
- **Standards Compliance**: Test methods and acceptance
- **Customer Requirements**: Special test needs
- **Quality System**: Test planning and execution
- **Certification**: Test results support certificates
- **Traceability**: Link tests to products/batches

## Implementation Considerations

### Technical Requirements

- Support diverse result types (numeric, boolean, string, images)
- Handle both quantitative and qualitative results
- Enable test-specific data fields
- Support multiple acceptance criteria
- Allow for conditional testing
- Enable rich descriptions and comments

### Standards Compliance

- ASTM E45: Determining Inclusion Content
- ASTM E112: Determining Average Grain Size
- ASTM B117: Salt Spray Testing
- ISO 9227: Corrosion tests in artificial atmospheres
- ASTM E165: Liquid Penetrant Testing
- ASTM E709: Magnetic Particle Testing
- ISO 17636: Non-destructive testing of welds

### Industry Practices

- NDT levels (I, II, III) for operator certification
- Standard defect classification systems
- Industry-specific test requirements
- Witness points for critical tests
- Photographic documentation common
- Statistical sampling for large batches

## JSON Schema Example

```json
{
  "type": "object",
  "properties": {
    "SupplementaryTests": {
      "type": "array",
      "items": {
        "$ref": "#/$defs
/Measurement"
      },
      "examples": [
        {
          "PropertySymbol": "UT",
          "PropertyName": "Ultrasonic Testing",
          "Method": "ASTM A388",
          "TestConditions": "2.25 MHz, 0.75\" dia. transducer",
          "ResultType": "boolean",
          "Result": {
            "Value": true,
            "PassCriteria": "No recordable indications found",
            "Interpretation": "In Specification"
          },
          "Grade": "Class A"
        },
        {
          "PropertySymbol": "SST",
          "PropertyName": "Salt Spray Test",
          "Unit": "hours",
          "Method": "ASTM B117",
          "TestConditions": "5% NaCl, 35°C",
          "ResultType": "numeric",
          "Result": {
            "Value": 720,
            "Operator": ">",
            "Minimum": 500,
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
  "SupplementaryTests": [
    {
      "PropertySymbol": "UT",
      "PropertyName": "Ultrasonic Testing",
      "Method": "EN 10160:1999",
      "TestConditions": "4 MHz normal beam probe",
      "SampleIdentifier": "Full plate",
      "ResultType": "string",
      "Result": {
        "Value": "S1/E1",
        "Interpretation": "In Specification"
      }
    },
    {
      "PropertySymbol": "Inclusion",
      "PropertyName": "Non-Metallic Inclusion Rating",
      "Method": "ASTM E45 Method A",
      "TestConditions": "100X magnification",
      "ResultType": "array",
      "Result": {
        "ParameterName": "Inclusion Type",
        "ParameterUnit": "Type",
        "ValueName": "Rating",
        "ValueUnit": "Scale",
        "DecimalPlaces": 1,
        "Data": [
          {
            "Parameter": "A (Sulfide) - Thin",
            "Value": 1.0
          },
          {
            "Parameter": "A (Sulfide) - Thick",
            "Value": 0.5
          },
          {
            "Parameter": "B (Alumina) - Thin",
            "Value": 1.5
          },
          {
            "Parameter": "B (Alumina) - Thick",
            "Value": 1.0
          },
          {
            "Parameter": "C (Silicate) - Thin",
            "Value": 0.5
          },
          {
            "Parameter": "C (Silicate) - Thick",
            "Value": 0.5
          },
          {
            "Parameter": "D (Globular) - Thin",
            "Value": 1.0
          },
          {
            "Parameter": "D (Globular) - Thick",
            "Value": 0.5
          }
        ],
        "Interpretation": "In Specification"
      },
      "Grade": "Fine"
    },
    {
      "PropertySymbol": "IGC",
      "PropertyName": "Intergranular Corrosion Test",
      "Method": "ASTM A262 Practice E",
      "TestConditions": "Copper sulfate - 16% sulfuric acid, 24 hours",
      "ResultType": "boolean",
      "Result": {
        "Value": true,
        "PassCriteria": "No intergranular attack observed after bending",
        "Interpretation": "In Specification"
      }
    },
    {
      "PropertySymbol": "CoatThk",
      "PropertyName": "Galvanizing Thickness",
      "Unit": "µm",
      "Method": "ISO 1461",
      "TestConditions": "Magnetic thickness gauge",
      "ResultType": "numeric",
      "Result": {
        "Value": 125,
        "DecimalPlaces": 0,
        "Minimum": 85,
        "IndividualValues": [118, 125, 132, 128, 122],
        "Statistics": {
          "Average": 125,
          "StandardDeviation": 5.7,
          "Count": 5
        },
        "Interpretation": "In Specification"
      }
    },
    {
      "PropertySymbol": "Flatness",
      "PropertyName": "Flatness Tolerance",
      "Unit": "mm/m",
      "Method": "EN 10029",
      "TestConditions": "Class N",
      "ResultType": "numeric",
      "Result": {
        "Value": 3,
        "DecimalPlaces": 0,
        "Maximum": 4,
        "Interpretation": "In Specification"
      }
    },
    {
      "PropertySymbol": "MacroEtch",
      "PropertyName": "Macrostructure Examination",
      "Method": "ASTM E381",
      "TestConditions": "Hot nitric acid etch",
      "SampleLocation": "Transverse section",
      "ResultType": "string",
      "Result": {
        "Value": "Sound structure, no segregation or porosity observed",
        "Interpretation": "In Specification"
      }
    },
    {
      "PropertySymbol": "CustomerX",
      "PropertyName": "Special Magnetic Permeability Test",
      "Unit": "H/m",
      "Method": "Customer Specification XYZ-123",
      "TestConditions": "As per customer procedure at 1000 Hz",
      "ResultType": "numeric",
      "Result": {
        "Value": 1.003,
        "DecimalPlaces": 3,
        "Maximum": 1.005,
        "Interpretation": "In Specification"
      }
    }
  ]
}
```

## Notes

### Implementation Notes

- Result types vary widely - flexibility is key
- Some tests produce images or charts (store as attachments)
- Qualitative results need clear grading criteria
- Customer tests may have unique requirements
- Statistical sampling plans often apply
- Test frequency varies by product and customer

### Extensibility

This FAM provides a framework for recording any supplementary test using the universal Measurement structure. New test types can be added by specifying:
- Appropriate property identification
- Result type that fits the test output
- Test method and conditions
- Acceptance criteria
- Interpretation guidelines

The flexible structure accommodates:
- Standard industry tests
- Customer-specific requirements
- New test methods as they develop
- Various result formats

### Related Aspects

- Measurements (base structure for all tests)
- Product Specification (defines required tests)
- Standards Compliance (test methods)
- Customer Requirements (special tests)
- Quality Plans (test frequency)
- Defect Management (for failed tests)

### References

- ASTM E45: Standard Test Methods for Determining Inclusion Content
- ASTM B117: Standard Practice for Operating Salt Spray
- ISO 9227: Corrosion tests in artificial atmospheres
- ASTM E709: Standard Guide for Magnetic Particle Testing
- EN 10160: Ultrasonic testing of steel flat products
- ISO 1461: Hot dip galvanized coatings on fabricated articles
- ASTM E381: Standard Method of Macroetch Testing