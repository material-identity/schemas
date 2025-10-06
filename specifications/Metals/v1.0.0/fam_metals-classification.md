# Metals Classification

## Aspect Overview

### Aspect Name

**Name**: Metals Classification

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

| Field Name | Data Type | Required | Description | Example |
|------------|-----------|----------|-------------|---------|
| MetalFamily | string | Yes | Primary metallurgical classification | "Ferrous", "Non-Ferrous" |
| MetalType | string | Yes | Specific metal or alloy type | "Stainless Steel", "Aluminum Alloy" |
| MetalSubType | string | Conditional | Detailed subcategory | "Austenitic Stainless", "7xxx Series" |
| StandardClassifications | array | Yes | Classifications according to international/regional standards | See sub-aspects |
| OEMClassifications | array | No | Classifications according to OEM specifications | See sub-aspects |
| CrossReferences | array | No | Equivalent grades across different standards | See sub-aspects |
| MagneticProperties | string | No | Magnetic behavior of the material | "Magnetic", "Non-Magnetic" |
| CorrosionResistance | string | No | General corrosion resistance classification | "Excellent", "Good", "Fair", "Poor" |
| PrimaryAlloyingElements | array | No | Main alloying elements affecting properties | ["Chromium", "Nickel"] |

### Sub-aspects

Break down into specific components:

#### Sub-aspect 1: Standard Classifications

- **Description**: Material classifications according to recognized standards bodies
- **Data Elements**:
  - Standard: String - Standard organization/body
  - StandardNumber: String - Standard document number
  - Grade: String - Material grade/designation
  - Classification: String - Full classification code
  - Description: String - Grade description
  - Year: Integer - Standard version year
  - Status: String - Standard status (active, superseded, withdrawn)

#### Sub-aspect 2: OEM Classifications

- **Description**: Material classifications according to Original Equipment Manufacturer specifications
- **Data Elements**:
  - OEM: String - OEM name/identifier
  - Specification: String - OEM specification number
  - Grade: String - OEM material designation
  - Revision: String - Specification revision
  - ApprovalDate: String - Date of approval
  - ApprovalNumber: String - Approval reference number
  - ApplicationArea: String - Intended application area
  - SpecialRequirements: Array - Additional OEM requirements

#### Sub-aspect 3: Cross References

- **Description**: Equivalent material grades across different classification systems
- **Data Elements**:
  - ReferenceStandard: String - Reference standard
  - ReferenceGrade: String - Reference grade
  - EquivalentStandard: String - Equivalent standard
  - EquivalentGrade: String - Equivalent grade
  - EquivalenceType: String - Type of equivalence (exact, similar, comparable)
  - Notes: String - Additional notes on equivalence

## Validation Rules

### Required Validations

- MetalFamily must be either "Ferrous" or "Non-Ferrous"
- MetalType must align with MetalFamily (e.g., Steel types only for Ferrous)
- At least one StandardClassification must be present
- Standard must be from recognized list (ISO, EN, ASTM, DIN, JIS, GB, AMS, etc.)
- Grade must follow standard-specific format rules
- Year must be valid (1900-current year)
- MetalSubType is required for certain MetalTypes (see conditional rules)

### Conditional Validations

- If MetalType is "Stainless Steel", "Carbon Steel", "Alloy Steel", "Tool Steel", or "Cast Iron", then MetalSubType is required
- If MetalType is "Aluminum Alloy", then MetalSubType must be from aluminum series
- If MetalType is "Copper Alloy", then MetalSubType must be from copper alloy families
- If MetalFamily is "Ferrous", then MagneticProperties should typically be "Magnetic" or "Weakly Magnetic"
- If MetalFamily is "Non-Ferrous", then MagneticProperties should typically be "Non-Magnetic"

### Format Validations

- ISO grades must follow ISO naming conventions
- EN grades must follow EN 10027 systematic designation rules
- ASTM grades must follow ASTM alphanumeric patterns
- AMS specifications must follow AMS-XXXX format
- AIMS specifications must follow AIMS XX-XX-XXX format
- OEM specifications must include revision identifier
- Cross-reference equivalence type must be from allowed values

### Business Rules

- Active standards take precedence over superseded ones
- OEM classifications must reference base standard classification
- Cross references must be reciprocal where applicable
- Multiple classifications allowed for same material
- Version control for standard updates
- Aerospace OEM specifications (Boeing, Airbus) require corresponding AMS or industry standard

## Use Cases

### Primary Use Cases

1. **Material Selection**: Engineers selecting materials based on standards
2. **Procurement**: Purchasing departments ordering correct grades
3. **Quality Control**: Verifying received materials match specifications
4. **Regulatory Compliance**: Ensuring materials meet regional requirements
5. **Global Trade**: Converting between regional standard designations
6. **OEM Approval**: Validating materials meet customer specifications
7. **Aerospace Certification**: Meeting stringent aerospace material requirements

### Integration Points

Where does this aspect connect with other parts of the format?

- **Chemical Composition**: Classifications define composition ranges
- **Mechanical Properties**: Classifications specify property requirements
- **Heat Treatment**: Classifications may specify treatment conditions
- **Certification**: Links to test certificates and standards compliance
- **Traceability**: Connects material batches to specifications
- **Processing**: Links to manufacturing and treatment requirements

## Implementation Considerations

### Technical Requirements

- Support for multiple classification systems simultaneously
- Version control for standard updates
- Validation against standard-specific rules
- Cross-reference lookup capabilities
- Support for custom/proprietary classifications
- Ferrous/non-ferrous categorization logic
- Conditional field requirements based on metal type

### Standards Compliance

- ISO 15510: Stainless steels - Chemical composition
- EN 10027: Designation systems for steels
- ASTM E527: Standard Practice for Numbering Metals and Alloys
- DIN EN 10088: Stainless steels classification
- AMS specifications: Aerospace Material Specifications
- AIMS specifications: Airbus Industry Material Specifications
- Industry-specific standards (aerospace, automotive, etc.)

### Industry Practices

- Steel industry uses multiple parallel classification systems
- Aerospace requires specific OEM approvals (Boeing BMS, Airbus AIMS/IPS)
- Automotive has manufacturer-specific standards
- Construction follows regional building codes
- Global trade requires cross-reference capabilities
- Explicit ferrous/non-ferrous distinction critical for recycling

## JSON Schema Example

```json
{
  "type": "object",
  "properties": {
    "MetalsClassification": {
      "type": "object",
      "properties": {
        "MetalFamily": {
          "type": "string",
          "enum": ["Ferrous", "Non-Ferrous"],
          "description": "Primary metallurgical classification"
        },
        "MetalType": {
          "type": "string",
          "enum": [
            "Carbon Steel",
            "Alloy Steel",
            "Stainless Steel",
            "Tool Steel",
            "Cast Iron",
            "Wrought Iron",
            "Aluminum",
            "Aluminum Alloy",
            "Copper",
            "Copper Alloy",
            "Titanium",
            "Titanium Alloy",
            "Nickel",
            "Nickel Alloy",
            "Magnesium",
            "Magnesium Alloy",
            "Zinc",
            "Zinc Alloy",
            "Lead",
            "Tin",
            "Other"
          ]
        },
        "MetalSubType": {
          "type": "string",
          "examples": [
            "Austenitic Stainless Steel",
            "Ferritic Stainless Steel",
            "Duplex Stainless Steel",
            "Martensitic Stainless Steel",
            "Low Carbon Steel",
            "Medium Carbon Steel",
            "High Carbon Steel",
            "1xxx - Pure Aluminum",
            "2xxx - Aluminum-Copper",
            "3xxx - Aluminum-Manganese",
            "4xxx - Aluminum-Silicon",
            "5xxx - Aluminum-Magnesium",
            "6xxx - Aluminum-Magnesium-Silicon",
            "7xxx - Aluminum-Zinc",
            "8xxx - Aluminum-Other Elements",
            "Brass - Copper-Zinc",
            "Bronze - Copper-Tin",
            "Copper-Nickel"
          ]
        },
        "MagneticProperties": {
          "type": "string",
          "enum": ["Magnetic", "Non-Magnetic", "Weakly Magnetic"]
        },
        "CorrosionResistance": {
          "type": "string",
          "enum": ["Excellent", "Good", "Fair", "Poor"]
        },
        "PrimaryAlloyingElements": {
          "type": "array",
          "items": {
            "type": "string"
          },
          "examples": [["Chromium", "Nickel"], ["Copper", "Manganese"], ["Zinc", "Magnesium"]]
        },
        "StandardClassifications": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "Standard": {
                "type": "string",
                "enum": ["ISO", "EN", "ASTM", "DIN", "JIS", "GB", "GOST", "BS", "AFNOR", "UNI", "AMS", "SAE", "UNS", "Werkstoffnummer", "AA"]
              },
              "StandardNumber": {
                "type": "string",
                "examples": ["EN 10088-2", "ASTM A240", "ISO 15510", "AMS 4911", "AMS 5604"]
              },
              "Grade": {
                "type": "string",
                "examples": ["1.4301", "304", "X5CrNi18-10", "Ti-6Al-4V", "2024-T351", "7075-T6"]
              },
              "Classification": {
                "type": "string",
                "description": "Full classification code"
              },
              "Description": {
                "type": "string"
              },
              "Year": {
                "type": "integer",
                "minimum": 1900,
                "maximum": 2100
              },
              "Status": {
                "type": "string",
                "enum": ["active", "superseded", "withdrawn"]
              }
            },
            "required": ["Standard", "Grade"]
          },
          "minItems": 1
        },
        "OEMClassifications": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "OEM": {
                "type": "string",
                "examples": ["Boeing", "Airbus", "Rolls-Royce", "GE Aviation", "Pratt & Whitney", "Safran", "VW", "BMW", "Mercedes-Benz"]
              },
              "Specification": {
                "type": "string",
                "examples": ["BMS 7-323", "AIMS 03-18-020", "IPS 03-18-020-01", "RRP 58000", "PWA 1202", "VW 50065"]
              },
              "Grade": {
                "type": "string"
              },
              "Revision": {
                "type": "string",
                "examples": ["Rev. A", "Version 3.1", "2024-01", "Issue 5"]
              },
              "ApprovalDate": {
                "type": "string",
                "format": "date"
              },
              "ApprovalNumber": {
                "type": "string"
              },
              "ApplicationArea": {
                "type": "string",
                "examples": ["aerospace structures", "engine components", "body panels", "landing gear", "fasteners"]
              },
              "SpecialRequirements": {
                "type": "array",
                "items": {
                  "type": "string"
                }
              }
            },
            "required": ["OEM", "Specification", "Grade"]
          }
        },
        "CrossReferences": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "ReferenceStandard": {
                "type": "string"
              },
              "ReferenceGrade": {
                "type": "string"
              },
              "EquivalentStandard": {
                "type": "string"
              },
              "EquivalentGrade": {
                "type": "string"
              },
              "EquivalenceType": {
                "type": "string",
                "enum": ["exact", "similar", "comparable", "nearest"]
              },
              "Notes": {
                "type": "string"
              }
            },
            "required": ["ReferenceStandard", "ReferenceGrade", "EquivalentStandard", "EquivalentGrade", "EquivalenceType"]
          }
        }
      },
      "required": ["MetalFamily", "MetalType", "StandardClassifications"],
      "allOf": [
        {
          "if": {
            "properties": {
              "MetalFamily": { "const": "Ferrous" }
            }
          },
          "then": {
            "properties": {
              "MetalType": {
                "enum": ["Carbon Steel", "Alloy Steel", "Stainless Steel", "Tool Steel", "Cast Iron", "Wrought Iron"]
              }
            }
          }
        },
        {
          "if": {
            "properties": {
              "MetalFamily": { "const": "Non-Ferrous" }
            }
          },
          "then": {
            "properties": {
              "MetalType": {
                "enum": ["Aluminum", "Aluminum Alloy", "Copper", "Copper Alloy", "Titanium", "Titanium Alloy", "Nickel", "Nickel Alloy", "Magnesium", "Magnesium Alloy", "Zinc", "Zinc Alloy", "Lead", "Tin", "Other"]
              }
            }
          }
        },
        {
          "if": {
            "properties": {
              "MetalType": {
                "enum": ["Carbon Steel", "Alloy Steel", "Stainless Steel", "Tool Steel", "Cast Iron"]
              }
            }
          },
          "then": {
            "required": ["MetalSubType"]
          }
        },
        {
          "if": {
            "properties": {
              "MetalType": { "const": "Aluminum Alloy" }
            }
          },
          "then": {
            "required": ["MetalSubType"],
            "properties": {
              "MetalSubType": {
                "enum": [
                  "1xxx - Pure Aluminum",
                  "2xxx - Aluminum-Copper",
                  "3xxx - Aluminum-Manganese",
                  "4xxx - Aluminum-Silicon",
                  "5xxx - Aluminum-Magnesium",
                  "6xxx - Aluminum-Magnesium-Silicon",
                  "7xxx - Aluminum-Zinc",
                  "8xxx - Aluminum-Other Elements"
                ]
              }
            }
          }
        },
        {
          "if": {
            "properties": {
              "MetalType": { "const": "Copper Alloy" }
            }
          },
          "then": {
            "required": ["MetalSubType"],
            "properties": {
              "MetalSubType": {
                "enum": [
                  "Brass - Copper-Zinc",
                  "Bronze - Copper-Tin",
                  "Copper-Nickel",
                  "Copper-Beryllium",
                  "Copper-Aluminum",
                  "Nickel Silver"
                ]
              }
            }
          }
        }
      ]
    }
  }
}
```

## Sample Data

### Example 1: Aerospace Aluminum Alloy

```json
{
  "MetalsClassification": {
    "MetalFamily": "Non-Ferrous",
    "MetalType": "Aluminum Alloy",
    "MetalSubType": "7xxx - Aluminum-Zinc",
    "MagneticProperties": "Non-Magnetic",
    "CorrosionResistance": "Good",
    "PrimaryAlloyingElements": ["Zinc", "Magnesium", "Copper"],
    "StandardClassifications": [
      {
        "Standard": "AA",
        "StandardNumber": "AA-01",
        "Grade": "7075",
        "Classification": "7075-T6",
        "Description": "High strength aluminum alloy, precipitation hardened",
        "Year": 2023,
        "Status": "active"
      },
      {
        "Standard": "AMS",
        "StandardNumber": "AMS 4045",
        "Grade": "7075-T6",
        "Classification": "7075-T6 Sheet",
        "Description": "Aluminum Alloy, Sheet 5.6Zn - 2.5Mg - 1.6Cu - 0.23Cr",
        "Year": 2022,
        "Status": "active"
      },
      {
        "Standard": "EN",
        "StandardNumber": "EN 573-3",
        "Grade": "EN AW-7075",
        "Classification": "AlZn5.5MgCu",
        "Description": "Aluminum and aluminum alloys - Chemical composition",
        "Year": 2019,
        "Status": "active"
      }
    ],
    "OEMClassifications": [
      {
        "OEM": "Airbus",
        "Specification": "AIMS 03-02-002",
        "Grade": "7075-T6",
        "Revision": "Issue 4",
        "ApprovalDate": "2023-03-15",
        "ApprovalNumber": "AIMS-2023-0892",
        "ApplicationArea": "wing structures and fuselage frames",
        "SpecialRequirements": [
          "Ultrasonic testing to AIMS 01-06-013",
          "Grain structure per AIMS 03-95-001",
          "Stress corrosion testing required"
        ]
      },
      {
        "OEM": "Boeing",
        "Specification": "BMS 7-121",
        "Grade": "7075-T6",
        "Revision": "Rev. T",
        "ApprovalDate": "2023-01-20",
        "ApprovalNumber": "BA-2023-0145",
        "ApplicationArea": "primary aircraft structures",
        "SpecialRequirements": [
          "Fracture toughness testing required",
          "Exfoliation corrosion resistance per ASTM G34"
        ]
      }
    ],
    "CrossReferences": [
      {
        "ReferenceStandard": "AA",
        "ReferenceGrade": "7075",
        "EquivalentStandard": "EN",
        "EquivalentGrade": "EN AW-7075",
        "EquivalenceType": "exact",
        "Notes": "Direct equivalent, same composition"
      },
      {
        "ReferenceStandard": "AA",
        "ReferenceGrade": "7075",
        "EquivalentStandard": "ISO",
        "EquivalentGrade": "AlZn5.5MgCu",
        "EquivalenceType": "exact",
        "Notes": "ISO designation for same alloy"
      }
    ]
  }
}
```

### Example 2: Stainless Steel with Airbus Approval

```json
{
  "MetalsClassification": {
    "MetalFamily": "Ferrous",
    "MetalType": "Stainless Steel",
    "MetalSubType": "Austenitic Stainless Steel",
    "MagneticProperties": "Non-Magnetic",
    "CorrosionResistance": "Excellent",
    "PrimaryAlloyingElements": ["Chromium", "Nickel"],
    "StandardClassifications": [
      {
        "Standard": "EN",
        "StandardNumber": "EN 10088-2",
        "Grade": "1.4301",
        "Classification": "X5CrNi18-10",
        "Description": "Austenitic stainless steel, standard grade",
        "Year": 2014,
        "Status": "active"
      },
      {
        "Standard": "ASTM",
        "StandardNumber": "ASTM A240",
        "Grade": "304",
        "Classification": "UNS S30400",
        "Description": "Chromium-Nickel Austenitic Stainless Steel",
        "Year": 2023,
        "Status": "active"
      },
      {
        "Standard": "AMS",
        "StandardNumber": "AMS 5513",
        "Grade": "304",
        "Classification": "304 Sheet",
        "Description": "Steel, Corrosion Resistant, Sheet and Strip",
        "Year": 2021,
        "Status": "active"
      }
    ],
    "OEMClassifications": [
      {
        "OEM": "Airbus",
        "Specification": "AIMS 03-18-020",
        "Grade": "1.4301",
        "Revision": "Issue 3",
        "ApprovalDate": "2023-06-15",
        "ApprovalNumber": "AIMS-2023-1847",
        "ApplicationArea": "galley and lavatory components",
        "SpecialRequirements": [
          "Surface finish Ra < 0.8 μm",
          "Intergranular corrosion test per ASTM A262",
          "Passivation per AIMS 03-06-002"
        ]
      }
    ],
    "CrossReferences": [
      {
        "ReferenceStandard": "EN",
        "ReferenceGrade": "1.4301",
        "EquivalentStandard": "ASTM",
        "EquivalentGrade": "304",
        "EquivalenceType": "exact",
        "Notes": "Direct equivalent, same chemical composition"
      },
      {
        "ReferenceStandard": "EN",
        "ReferenceGrade": "1.4301",
        "EquivalentStandard": "JIS",
        "EquivalentGrade": "SUS304",
        "EquivalenceType": "exact",
        "Notes": "Japanese equivalent"
      }
    ]
  }
}
```

### Example 3: Titanium Alloy for Aerospace

```json
{
  "MetalsClassification": {
    "MetalFamily": "Non-Ferrous",
    "MetalType": "Titanium Alloy",
    "MetalSubType": "Alpha-Beta Titanium Alloy",
    "MagneticProperties": "Non-Magnetic",
    "CorrosionResistance": "Excellent",
    "PrimaryAlloyingElements": ["Aluminum", "Vanadium"],
    "StandardClassifications": [
      {
        "Standard": "AMS",
        "StandardNumber": "AMS 4911",
        "Grade": "Ti-6Al-4V",
        "Classification": "Ti-6Al-4V Sheet",
        "Description": "Titanium Alloy, Sheet, Strip, and Plate, 6Al - 4V, Annealed",
        "Year": 2023,
        "Status": "active"
      },
      {
        "Standard": "ASTM",
        "StandardNumber": "ASTM B265",
        "Grade": "Grade 5",
        "Classification": "UNS R56400",
        "Description": "Titanium and Titanium Alloy Strip, Sheet, and Plate",
        "Year": 2022,
        "Status": "active"
      }
    ],
    "OEMClassifications": [
      {
        "OEM": "Airbus",
        "Specification": "AIMS 03-14-010",
        "Grade": "Ti-6Al-4V",
        "Revision": "Issue 2",
        "ApprovalDate": "2023-04-10",
        "ApprovalNumber": "AIMS-2023-0623",
        "ApplicationArea": "engine mounts and landing gear components",
        "SpecialRequirements": [
          "Beta transus temperature verification",
          "Microstructure per AIMS 03-95-014",
          "Hydrogen content < 125 ppm"
        ]
      }
    ],
    "CrossReferences": [
      {
        "ReferenceStandard": "AMS",
        "ReferenceGrade": "Ti-6Al-4V",
        "EquivalentStandard": "ASTM",
        "EquivalentGrade": "Grade 5",
        "EquivalenceType": "exact",
        "Notes": "Same alloy, different designation system"
      },
      {
        "ReferenceStandard": "AMS",
        "ReferenceGrade": "Ti-6Al-4V",
        "EquivalentStandard": "DIN",
        "EquivalentGrade": "3.7165",
        "EquivalenceType": "exact",
        "Notes": "German equivalent designation"
      }
    ]
  }
}
```

## Notes

### Implementation Notes

- Consider API integration with standards databases
- Implement version tracking for standard updates
- Support for proprietary/confidential OEM specifications
- Validation rules specific to each standard system
- Consider machine-readable format for cross-references
- Implement conditional validation based on MetalFamily and MetalType
- Support for Airbus AIMS/IPS specification format (AIMS XX-XX-XXX)

### Key Improvements from FEP Integration

1. **Explicit Ferrous/Non-Ferrous Classification**: Added required MetalFamily field
2. **Technical Properties**: Added MagneticProperties and CorrosionResistance
3. **Alloying Elements**: Added PrimaryAlloyingElements array
4. **Conditional Validation**: Implemented metal type-specific requirements
5. **Hierarchical Structure**: Clear Family → Type → SubType hierarchy
6. **Aerospace Focus**: Enhanced support for AMS and Airbus AIMS specifications

### Related Aspects

- Chemical Composition (defines actual vs. specified composition)
- Mechanical Properties (linked to grade requirements)
- Heat Treatment (grade-specific requirements)
- Certification (standards compliance documentation)
- Supply Chain (material sourcing and alternatives)
- Processing Requirements (manufacturing constraints by material)

### References

- ISO 15510: Stainless steels - Chemical composition
- EN 10027-1: Designation systems for steels - Part 1: Steel names
- EN 10027-2: Designation systems for steels - Part 2: Numerical system
- ASTM E527: Standard Practice for Numbering Metals and Alloys (UNS)
- SAE AMS Index: Aerospace Material Specifications
- Airbus AIMS: Airbus Industry Material Specifications
- Boeing BMS: Boeing Material Specifications
- AA Registration: Aluminum Association alloy designations