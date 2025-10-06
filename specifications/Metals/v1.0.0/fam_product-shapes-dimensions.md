# Product Shapes and Dimensions

## Aspect Overview

### Aspect Name

**Name**: Product Shapes and Dimensions

### Aspect Category

- [x] Physical Properties
- [ ] Chemical Properties
- [ ] Delivery Conditions
- [ ] Processing Information
- [ ] Quality Attributes
- [ ] Compliance Data
- [ ] Sustainability Metrics
- [ ] Other: \***\*\_\_\_\*\***

### Priority

- [x] Core (Required)
- [ ] Standard (Recommended)
- [ ] Extended (Optional)

## Data Structure

### Primary Data Elements

List the main data fields for this aspect:

| Field Name          | Data Type | Required | Description                                    | Example                                 |
| ------------------- | --------- | -------- | ---------------------------------------------- | --------------------------------------- |
| ProductForm         | string    | Yes      | Primary product form classification            | "Long Product", "Flat Product"          |
| ShapeCategory       | string    | Yes      | General shape category                         | "Bar", "Tube", "Sheet", "Profile"       |
| ShapeType           | string    | Yes      | Specific shape designation                     | "Round Bar", "Square Tube", "C-Channel" |
| PrimaryDimensions   | object    | Yes      | Main dimensional measurements                  | See sub-aspects                         |
| SecondaryDimensions | object    | No       | Additional shape-specific dimensions           | See sub-aspects                         |
| DimensionalStandard | string    | Yes      | Applicable dimensional standard                | "EN 10058", "ASTM A6"                   |
| ToleranceClass      | string    | No       | Tolerance classification                       | "Standard", "Special", "Precision"      |
| SurfaceArea         | number    | No       | Total surface area per unit length             | 125.6 cm²/m                             |
| CrossSectionalArea  | number    | No       | Cross-sectional area                           | 15.7 cm²                                |
| MomentOfInertia     | object    | No       | Section properties for structural calculations | See sub-aspects                         |
| Weight              | object    | Yes      | Weight specifications                          | See sub-aspects                         |

### Sub-aspects

Break down into specific components:

#### Sub-aspect 1: Primary Dimensions

- **Description**: Essential dimensional measurements that define the product shape
- **Data Elements by Shape Type**:

**For Bars (Round, Square, Hex, Flat):**

- Diameter: Number with unit (for round bars)
- Width: Number with unit (for square/flat bars)
- Height/Thickness: Number with unit (for flat bars)
- AcrossFlats: Number with unit (for hex bars)
- Length: Number with unit

**For Tubes/Pipes:**

- OuterDiameter: Number with unit
- WallThickness: Number with unit
- InnerDiameter: Number with unit (calculated or specified)
- Length: Number with unit

**For Sheets/Plates:**

- Thickness: Number with unit
- Width: Number with unit
- Length: Number with unit

**For Structural Shapes (Angles, Channels, I-Beams):**

- Height: Number with unit
- Width: Number with unit
- WebThickness: Number with unit
- FlangeThickness: Number with unit
- LegLength1: Number with unit (for angles)
- LegLength2: Number with unit (for angles)

#### Sub-aspect 2: Secondary Dimensions

- **Description**: Additional measurements specific to certain shape types
- **Data Elements**:
- CornerRadius: Number with unit (for structural shapes)
- RootRadius: Number with unit (for channels, I-beams)
- Slope: Number (percentage for tapered flanges)
- Ovality: Number (percentage for tubes)
- Straightness: Number with unit (deviation per length)
- Flatness: Number with unit (for sheets/plates)
- Camber: Number with unit (lateral deviation)
- Twist: Number (degrees per length)

#### Sub-aspect 3: Dimensional Tolerances

- **Description**: Allowable variations from nominal dimensions
- **Data Elements**:
- DimensionName: String (e.g., "Diameter", "Thickness")
- NominalValue: Number with unit
- PlusTolerance: Number with unit
- MinusTolerance: Number with unit
- ToleranceType: String ("Bilateral", "Unilateral", "Limit")
- ToleranceStandard: String (reference to applicable standard)

#### Sub-aspect 4: Section Properties

- **Description**: Calculated properties for structural analysis
- **Data Elements**:
- MomentOfInertiaX: Number with unit (Ix)
- MomentOfInertiaY: Number with unit (Iy)
- SectionModulusX: Number with unit (Sx)
- SectionModulusY: Number with unit (Sy)
- RadiusOfGyrationX: Number with unit (rx)
- RadiusOfGyrationY: Number with unit (ry)
- TorsionalConstant: Number with unit (J)
- WarpingConstant: Number with unit (Cw)
- CentroidLocation: Object {x: Number, y: Number}
- ShearCenter: Object {x: Number, y: Number}

#### Sub-aspect 5: Weight Specifications

- **Description**: Weight-related measurements
- **Data Elements**:
- LinearWeight: Number with unit (kg/m, lb/ft)
- AreaWeight: Number with unit (kg/m², lb/ft²)
- PieceWeight: Number with unit (for cut lengths)
- TheoreticalWeight: Boolean (calculated vs actual)
- Density: Number with unit (if non-standard)

## Validation Rules

### Required Validations

- ProductForm must align with ShapeCategory
- ShapeType must be valid for the selected ShapeCategory
- All required dimensions must be present for the specified ShapeType
- Dimensional values must be positive numbers
- Units must be specified for all dimensional values
- Inner diameter must be less than outer diameter for tubes
- Wall thickness must be less than radius for tubes

### Format Validations

- Dimensions must follow metric (mm, cm, m) or imperial (in, ft) units consistently
- Tolerance values must use same units as nominal dimensions
- Weight units must be appropriate (kg/m, lb/ft for linear; kg/m², lb/ft² for area)
- Angular measurements in degrees
- Percentage values between 0-100

### Business Rules

- Standard mill lengths typically: 6m, 12m (metric) or 20ft, 40ft (imperial)
- Minimum wall thickness ratios for tubes based on diameter
- Maximum width-to-thickness ratios for flat products
- Standard tolerance classes per dimensional standards
- Section property calculations must follow recognized methods

## Use Cases

### Primary Use Cases

1. **Material Procurement**: Accurate ordering based on dimensional requirements
2. **Structural Design**: Using section properties for engineering calculations
3. **Inventory Management**: Calculating storage space and handling requirements
4. **Cost Estimation**: Weight-based pricing calculations
5. **Fabrication Planning**: Determining cutting patterns and material utilization
6. **Quality Control**: Verifying received materials meet specifications
7. **Logistics Planning**: Calculating shipping weights and volumes

### Integration Points

Where does this aspect connect with other parts of the format?

- **Material Classification**: Shape availability depends on material type
- **Manufacturing Process**: Shapes limited by production method
- **Surface Treatment**: Surface area calculations for coating requirements
- **Mechanical Properties**: Section properties affect load-bearing capacity
- **Tolerances**: Links to quality specifications
- **Packaging**: Dimensions determine bundling and shipping methods

## Implementation Considerations

### Technical Requirements

- Support for multiple unit systems (metric/imperial)
- Automatic unit conversion capabilities
- Calculation engines for derived properties
- Validation against standard shape catalogs
- Support for custom/non-standard shapes

### Standards Compliance

- EN 10058: Hot rolled flat steel bars - Tolerances on dimensions and shape
- EN 10059: Hot rolled square steel bars - Tolerances
- EN 10060: Hot rolled round steel bars - Tolerances
- EN 10061: Hot rolled hexagon steel bars - Tolerances
- EN 10279: Hot rolled steel channels - Tolerances
- EN 10056: Structural steel equal and unequal leg angles
- ASTM A6/A6M: General requirements for rolled structural steel
- ASTM A484/A484M: General requirements for stainless steel
- ASTM B221: Aluminum and aluminum-alloy extruded bars, rods, wire, profiles, and tubes
- ISO 657: Hot rolled steel sections

### Industry Practices

- Steel industry uses different standards for hot-rolled vs cold-formed shapes
- Aerospace requires tighter tolerances and additional inspections
- Construction industry follows regional building codes for structural shapes
- Tube/pipe industry distinguishes between seamless and welded products
- Custom profiles require detailed drawings beyond standard dimensions

## JSON Schema Example

```json
{
  "type": "object",
  "properties": {
    "ProductShapesAndDimensions": {
      "type": "object",
      "properties": {
        "ProductForm": {
          "type": "string",
          "enum": [
            "Long Product",
            "Flat Product",
            "Tube Product",
            "Special Profile"
          ]
        },
        "ShapeCategory": {
          "type": "string",
          "enum": [
            "Bar",
            "Tube",
            "Pipe",
            "Sheet",
            "Plate",
            "Structural Shape",
            "Profile"
          ]
        },
        "ShapeType": {
          "type": "string",
          "examples": [
            "Round Bar",
            "Square Bar",
            "Flat Bar",
            "Hexagon Bar",
            "Round Tube",
            "Square Tube",
            "Rectangular Tube",
            "Seamless Pipe",
            "Welded Pipe",
            "Sheet",
            "Plate",
            "Coil",
            "Equal Angle",
            "Unequal Angle",
            "C-Channel",
            "I-Beam",
            "H-Beam",
            "T-Section"
          ]
        },
        "PrimaryDimensions": {
          "type": "object",
          "additionalProperties": false,
          "properties": {
            "Diameter": {
              "$ref": "#/$defs/DimensionWithUnit"
            },
            "Width": {
              "$ref": "#/$defs/DimensionWithUnit"
            },
            "Height": {
              "$ref": "#/$defs/DimensionWithUnit"
            },
            "Thickness": {
              "$ref": "#/$defs/DimensionWithUnit"
            },
            "OuterDiameter": {
              "$ref": "#/$defs/DimensionWithUnit"
            },
            "WallThickness": {
              "$ref": "#/$defs/DimensionWithUnit"
            },
            "InnerDiameter": {
              "$ref": "#/$defs/DimensionWithUnit"
            },
            "WebThickness": {
              "$ref": "#/$defs/DimensionWithUnit"
            },
            "FlangeThickness": {
              "$ref": "#/$defs/DimensionWithUnit"
            },
            "LegLength1": {
              "$ref": "#/$defs/DimensionWithUnit"
            },
            "LegLength2": {
              "$ref": "#/$defs/DimensionWithUnit"
            },
            "AcrossFlats": {
              "$ref": "#/$defs/DimensionWithUnit"
            },
            "Length": {
              "$ref": "#/$defs/DimensionWithUnit"
            }
          }
        },
        "SecondaryDimensions": {
          "type": "object",
          "properties": {
            "CornerRadius": {
              "$ref": "#/$defs/DimensionWithUnit"
            },
            "RootRadius": {
              "$ref": "#/$defs/DimensionWithUnit"
            },
            "Slope": {
              "type": "number",
              "description": "Flange slope in percentage"
            },
            "Ovality": {
              "type": "number",
              "description": "Maximum ovality in percentage"
            },
            "Straightness": {
              "$ref": "#/$defs/DimensionWithUnit",
              "description": "Maximum deviation per unit length"
            },
            "Flatness": {
              "$ref": "#/$defs/DimensionWithUnit"
            },
            "Camber": {
              "$ref": "#/$defs/DimensionWithUnit"
            },
            "Twist": {
              "type": "number",
              "description": "Maximum twist in degrees per meter"
            }
          }
        },
        "DimensionalStandard": {
          "type": "string",
          "examples": [
            "EN 10058",
            "EN 10279",
            "ASTM A6",
            "ASTM A484",
            "DIN 1026",
            "JIS G3192"
          ]
        },
        "ToleranceClass": {
          "type": "string",
          "enum": ["Standard", "Special", "Precision", "Wide", "Commercial"]
        },
        "Tolerances": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "DimensionName": {
                "type": "string"
              },
              "NominalValue": {
                "$ref": "#/$defs/DimensionWithUnit"
              },
              "PlusTolerance": {
                "$ref": "#/$defs/DimensionWithUnit"
              },
              "MinusTolerance": {
                "$ref": "#/$defs/DimensionWithUnit"
              },
              "ToleranceType": {
                "type": "string",
                "enum": ["Bilateral", "Unilateral", "Limit"]
              },
              "ToleranceStandard": {
                "type": "string"
              }
            },
            "required": ["DimensionName", "NominalValue"]
          }
        },
        "SurfaceArea": {
          "type": "object",
          "properties": {
            "Value": {
              "type": "number"
            },
            "Unit": {
              "type": "string",
              "examples": ["cm²/m", "in²/ft", "m²/m"]
            }
          }
        },
        "CrossSectionalArea": {
          "$ref": "#/$defs/DimensionWithUnit"
        },
        "SectionProperties": {
          "type": "object",
          "properties": {
            "MomentOfInertiaX": {
              "$ref": "#/$defs/DimensionWithUnit"
            },
            "MomentOfInertiaY": {
              "$ref": "#/$defs/DimensionWithUnit"
            },
            "SectionModulusX": {
              "$ref": "#/$defs/DimensionWithUnit"
            },
            "SectionModulusY": {
              "$ref": "#/$defs/DimensionWithUnit"
            },
            "RadiusOfGyrationX": {
              "$ref": "#/$defs/DimensionWithUnit"
            },
            "RadiusOfGyrationY": {
              "$ref": "#/$defs/DimensionWithUnit"
            },
            "TorsionalConstant": {
              "$ref": "#/$defs/DimensionWithUnit"
            },
            "WarpingConstant": {
              "$ref": "#/$defs/DimensionWithUnit"
            },
            "CentroidLocation": {
              "type": "object",
              "properties": {
                "X": {
                  "$ref": "#/$defs/DimensionWithUnit"
                },
                "Y": {
                  "$ref": "#/$defs/DimensionWithUnit"
                }
              }
            },
            "ShearCenter": {
              "type": "object",
              "properties": {
                "X": {
                  "$ref": "#/$defs/DimensionWithUnit"
                },
                "Y": {
                  "$ref": "#/$defs/DimensionWithUnit"
                }
              }
            }
          }
        },
        "Weight": {
          "type": "object",
          "properties": {
            "LinearWeight": {
              "type": "object",
              "properties": {
                "Value": {
                  "type": "number"
                },
                "Unit": {
                  "type": "string",
                  "examples": ["kg/m", "lb/ft"]
                }
              }
            },
            "AreaWeight": {
              "type": "object",
              "properties": {
                "Value": {
                  "type": "number"
                },
                "Unit": {
                  "type": "string",
                  "examples": ["kg/m²", "lb/ft²"]
                }
              }
            },
            "PieceWeight": {
              "$ref": "#/$defs/DimensionWithUnit"
            },
            "TheoreticalWeight": {
              "type": "boolean",
              "description": "True if calculated, false if actual"
            },
            "Density": {
              "$ref": "#/$defs/DimensionWithUnit",
              "description": "Only if non-standard density"
            }
          }
        }
      },
      "required": [
        "ProductForm",
        "ShapeCategory",
        "ShapeType",
        "PrimaryDimensions",
        "DimensionalStandard",
        "Weight"
      ]
    }
  },
  "$defs": {
    "DimensionWithUnit": {
      "type": "object",
      "properties": {
        "Value": {
          "type": "number"
        },
        "Unit": {
          "type": "string",
          "examples": ["mm", "cm", "m", "in", "ft", "kg", "lb", "cm⁴", "in⁴"]
        }
      },
      "required": ["Value", "Unit"]
    }
  }
}
```

## Sample Data

### Example 1: Hot Rolled Steel Equal Angle

```json
{
  "ProductShapesAndDimensions": {
    "ProductForm": "Long Product",
    "ShapeCategory": "Structural Shape",
    "ShapeType": "Equal Angle",
    "PrimaryDimensions": {
      "LegLength1": {
        "Value": 100,
        "Unit": "mm"
      },
      "LegLength2": {
        "Value": 100,
        "Unit": "mm"
      },
      "Thickness": {
        "Value": 10,
        "Unit": "mm"
      },
      "Length": {
        "Value": 12,
        "Unit": "m"
      }
    },
    "SecondaryDimensions": {
      "CornerRadius": {
        "Value": 12,
        "Unit": "mm"
      },
      "RootRadius": {
        "Value": 6,
        "Unit": "mm"
      },
      "Straightness": {
        "Value": 3,
        "Unit": "mm/m"
      }
    },
    "DimensionalStandard": "EN 10056-1",
    "ToleranceClass": "Standard",
    "Tolerances": [
      {
        "DimensionName": "LegLength",
        "NominalValue": {
          "Value": 100,
          "Unit": "mm"
        },
        "PlusTolerance": {
          "Value": 2,
          "Unit": "mm"
        },
        "MinusTolerance": {
          "Value": 2,
          "Unit": "mm"
        },
        "ToleranceType": "Bilateral",
        "ToleranceStandard": "EN 10056-1"
      },
      {
        "DimensionName": "Thickness",
        "NominalValue": {
          "Value": 10,
          "Unit": "mm"
        },
        "PlusTolerance": {
          "Value": 0.5,
          "Unit": "mm"
        },
        "MinusTolerance": {
          "Value": 0.5,
          "Unit": "mm"
        },
        "ToleranceType": "Bilateral",
        "ToleranceStandard": "EN 10056-1"
      }
    ],
    "SurfaceArea": {
      "Value": 78.5,
      "Unit": "cm²/m"
    },
    "CrossSectionalArea": {
      "Value": 19.2,
      "Unit": "cm²"
    },
    "SectionProperties": {
      "MomentOfInertiaX": {
        "Value": 176.6,
        "Unit": "cm⁴"
      },
      "MomentOfInertiaY": {
        "Value": 176.6,
        "Unit": "cm⁴"
      },
      "RadiusOfGyrationX": {
        "Value": 3.03,
        "Unit": "cm"
      },
      "RadiusOfGyrationY": {
        "Value": 3.03,
        "Unit": "cm"
      },
      "CentroidLocation": {
        "X": {
          "Value": 2.82,
          "Unit": "cm"
        },
        "Y": {
          "Value": 2.82,
          "Unit": "cm"
        }
      }
    },
    "Weight": {
      "LinearWeight": {
        "Value": 15.1,
        "Unit": "kg/m"
      },
      "PieceWeight": {
        "Value": 181.2,
        "Unit": "kg"
      },
      "TheoreticalWeight": true
    }
  }
}
```

### Example 2: Seamless Steel Tube

```json
{
  "ProductShapesAndDimensions": {
    "ProductForm": "Tube Product",
    "ShapeCategory": "Tube",
    "ShapeType": "Round Tube",
    "PrimaryDimensions": {
      "OuterDiameter": {
        "Value": 114.3,
        "Unit": "mm"
      },
      "WallThickness": {
        "Value": 6.3,
        "Unit": "mm"
      },
      "InnerDiameter": {
        "Value": 101.7,
        "Unit": "mm"
      },
      "Length": {
        "Value": 6,
        "Unit": "m"
      }
    },
    "SecondaryDimensions": {
      "Ovality": {
        "Value": 1.0,
        "Unit": "%"
      },
      "Straightness": {
        "Value": 2,
        "Unit": "mm/m"
      }
    },
    "DimensionalStandard": "EN 10216-1",
    "ToleranceClass": "Standard",
    "Tolerances": [
      {
        "DimensionName": "OuterDiameter",
        "NominalValue": {
          "Value": 114.3,
          "Unit": "mm"
        },
        "PlusTolerance": {
          "Value": 1.0,
          "Unit": "%"
        },
        "MinusTolerance": {
          "Value": 1.0,
          "Unit": "%"
        },
        "ToleranceType": "Bilateral",
        "ToleranceStandard": "EN 10216-1"
      },
      {
        "DimensionName": "WallThickness",
        "NominalValue": {
          "Value": 6.3,
          "Unit": "mm"
        },
        "PlusTolerance": {
          "Value": 12.5,
          "Unit": "%"
        },
        "MinusTolerance": {
          "Value": 10.0,
          "Unit": "%"
        },
        "ToleranceType": "Bilateral",
        "ToleranceStandard": "EN 10216-1"
      }
    ],
    "SurfaceArea": {
      "Value": 359.2,
      "Unit": "cm²/m"
    },
    "CrossSectionalArea": {
      "Value": 21.5,
      "Unit": "cm²"
    },
    "SectionProperties": {
      "MomentOfInertiaX": {
        "Value": 490.9,
        "Unit": "cm⁴"
      },
      "SectionModulusX": {
        "Value": 85.9,
        "Unit": "cm³"
      },
      "RadiusOfGyrationX": {
        "Value": 3.88,
        "Unit": "cm"
      }
    },
    "Weight": {
      "LinearWeight": {
        "Value": 16.9,
        "Unit": "kg/m"
      },
      "PieceWeight": {
        "Value": 101.4,
        "Unit": "kg"
      },
      "TheoreticalWeight": true,
      "Density": {
        "Value": 7850,
        "Unit": "kg/m³"
      }
    }
  }
}
```

### Example 3: Aluminum Sheet

```json
{
  "ProductShapesAndDimensions": {
    "ProductForm": "Flat Product",
    "ShapeCategory": "Sheet",
    "ShapeType": "Sheet",
    "PrimaryDimensions": {
      "Thickness": {
        "Value": 3.0,
        "Unit": "mm"
      },
      "Width": {
        "Value": 1500,
        "Unit": "mm"
      },
      "Length": {
        "Value": 3000,
        "Unit": "mm"
      }
    },
    "SecondaryDimensions": {
      "Flatness": {
        "Value": 4,
        "Unit": "mm"
      },
      "Camber": {
        "Value": 2,
        "Unit": "mm/m"
      }
    },
    "DimensionalStandard": "EN 485-4",
    "ToleranceClass": "Special",
    "Tolerances": [
      {
        "DimensionName": "Thickness",
        "NominalValue": {
          "Value": 3.0,
          "Unit": "mm"
        },
        "PlusTolerance": {
          "Value": 0.15,
          "Unit": "mm"
        },
        "MinusTolerance": {
          "Value": 0.15,
          "Unit": "mm"
        },
        "ToleranceType": "Bilateral",
        "ToleranceStandard": "EN 485-4"
      },
      {
        "DimensionName": "Width",
        "NominalValue": {
          "Value": 1500,
          "Unit": "mm"
        },
        "PlusTolerance": {
          "Value": 5,
          "Unit": "mm"
        },
        "MinusTolerance": {
          "Value": 0,
          "Unit": "mm"
        },
        "ToleranceType": "Unilateral",
        "ToleranceStandard": "EN 485-4"
      }
    ],
    "CrossSectionalArea": {
      "Value": 45.0,
      "Unit": "cm²"
    },
    "Weight": {
      "AreaWeight": {
        "Value": 8.1,
        "Unit": "kg/m²"
      },
      "PieceWeight": {
        "Value": 36.45,
        "Unit": "kg"
      },
      "TheoreticalWeight": true,
      "Density": {
        "Value": 2700,
        "Unit": "kg/m³"
      }
    }
  }
}
```

## Notes

### Implementation Notes

- Consider integration with CAD systems for shape visualization
- Implement automatic calculation of derived properties
- Support for both metric and imperial unit systems
- Validation against standard shape catalogs (EN, ASTM, DIN)
- Consider shape-specific validation rules
- Support for custom or proprietary profiles

### Shape-Specific Considerations

1. **Bars**: Simple shapes but various cross-sections (round, square, hex, flat)
2. **Tubes/Pipes**: Distinguish between structural tubes and pressure pipes
3. **Sheets/Plates**: Thickness determines classification (typically <6mm = sheet)
4. **Structural Shapes**: Complex profiles requiring multiple dimensions
5. **Custom Profiles**: May require drawing references or coordinate lists

### Related Aspects

- Material Classification (affects available shapes)
- Manufacturing Process (determines shape capabilities)
- Surface Treatment (uses surface area calculations)
- Mechanical Properties (combined with section properties)
- Quality Specifications (dimensional tolerances)
- Logistics (dimensions for transport planning)

### References

- EN 10079: Definition of steel products
- ISO 6929: Steel products - Vocabulary
- ASTM A941: Terminology relating to steel
- EN 10365: Hot rolled steel channels, I and H sections
- ASTM A500: Cold-formed welded structural tubing
- EN 10219: Cold formed welded structural hollow sections
- Industry shape catalogs and handbooks
