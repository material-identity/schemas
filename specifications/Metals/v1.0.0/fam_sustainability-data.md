# Sustainability

## Aspect Overview

### Aspect Name
**Name**: Sustainability

### Aspect Category
- [ ] Physical Properties
- [ ] Chemical Properties
- [ ] Delivery Conditions
- [ ] Processing Information
- [ ] Quality Attributes
- [ ] Compliance Data
- [x] Sustainability Metrics
- [ ] Other: ___________

### Priority
- [ ] Core (Required)
- [x] Standard (Recommended)
- [ ] Extended (Optional)

## Data Structure

### Primary Data Elements
List the main data fields for this aspect:

| Field Name | Data Type | Required | Description | Example |
|------------|-----------|----------|-------------|---------|
| RecycledContent | object | No | Information about recycled material content | {...} |
| PrimaryMaterialContent | object | No | Primary material composition data | {...} |
| CarbonFootprint | object | No | Product carbon footprint information | {...} |
| WaterUsage | object | No | Water consumption and usage data | {...} |

### Sub-aspects

#### Sub-aspect 1: RecycledContent
- **Description**: Information about recycled and secondary material content
- **Data Elements**:
  - TotalRecycledPercentage (overall recycled content percentage)
  - PreConsumerRecycled (pre-consumer recycled content)
  - PostConsumerRecycled (post-consumer recycled content)
  - RecycledMaterials (breakdown by material type)
  - CertificationStandard (recycling certification)
  - VerificationMethod (how recycled content was verified)
  - TraceabilityChain (source traceability information)

#### Sub-aspect 2: PrimaryMaterialContent
- **Description**: Composition of primary (virgin) materials
- **Data Elements**:
  - MaterialComposition (breakdown by material type and percentage)
  - SourceOrigin (geographic origin of materials)
  - SustainabilityStandards (certification standards met)
  - SupplyChainTransparency (traceability information)
  - ConflictMinerals (conflict mineral compliance)
  - BioBased (bio-based material content)

#### Sub-aspect 3: CarbonFootprint
- **Description**: Greenhouse gas emissions and carbon impact data
- **Data Elements**:
  - TotalCO2Equivalent (total carbon footprint in kg CO2e)
  - Scope1Emissions (direct emissions)
  - Scope2Emissions (indirect energy emissions)
  - Scope3Emissions (other indirect emissions)
  - LifecycleStage (emissions by lifecycle stage)
  - CalculationMethod (methodology used)
  - CertificationStandard (carbon footprint standard)
  - OffsetPrograms (carbon offset information)

#### Sub-aspect 4: WaterUsage
- **Description**: Water consumption and impact throughout product lifecycle
- **Data Elements**:
  - TotalWaterConsumption (total water used in liters)
  - ProductionWaterUse (water used in production)
  - WaterStressIndex (water stress level of source regions)
  - WaterEfficiencyMeasures (efficiency initiatives)
  - WasteWaterTreatment (treatment and discharge information)
  - WaterRecycling (recycled water usage)
  - WaterQualityImpact (impact on water quality)

## Validation Rules

### Required Validations
- At least one sustainability metric should be provided
- Percentages must be between 0 and 100
- Carbon footprint values must be non-negative
- Water usage values must be non-negative
- Geographic regions must use ISO 3166 country codes

### Format Validations
- RecycledContent percentages must sum to ≤ 100%
- PrimaryMaterialContent percentages should sum to ≈ 100%
- Carbon footprint must include unit specification (kg CO2e, t CO2e)
- Water usage must include unit specification (liters, m³)
- Date fields must be valid ISO 8601 timestamps

### Business Rules
- PreConsumerRecycled + PostConsumerRecycled should equal TotalRecycledPercentage
- Scope1 + Scope2 + Scope3 emissions should equal TotalCO2Equivalent
- Material composition should account for all significant materials (>1%)
- Lifecycle stage emissions should be comprehensive
- Water stress regions should be identified using recognized indices

## Use Cases

### Primary Use Cases
1. **Circular Economy Compliance**: Report recycled content for circular economy regulations
2. **Carbon Reporting**: Provide carbon footprint data for climate disclosure requirements
3. **Supply Chain Transparency**: Track material origins and sustainability credentials
4. **Water Stewardship**: Monitor and report water usage for environmental compliance
5. **Green Procurement**: Support sustainable purchasing decisions
6. **Regulatory Compliance**: Meet sustainability disclosure requirements (EU Digital Product Passport, etc.)
7. **Sustainability Certification**: Support various environmental certification schemes

### Integration Points
Where does this aspect connect with other parts of the format?
- **Product Information**: Links material composition to sustainability data
- **Compliance Data**: Environmental compliance and certifications
- **Processing Information**: Production methods affecting sustainability metrics
- **Parties**: Certification bodies and testing laboratories for verification
- **General Attachments**: Supporting sustainability reports and certificates

## Implementation Considerations

### Technical Requirements
- Support for multiple measurement units and conversions
- Integration with lifecycle assessment (LCA) tools
- Real-time data collection from production systems
- Third-party verification system integration
- Carbon accounting software compatibility
- Water footprint calculation tools

### Standards Compliance
- ISO 14040/14044 (Life Cycle Assessment)
- ISO 14067 (Carbon Footprint of Products)
- ISO 14046 (Water Footprint)
- GHG Protocol Product Standard
- Cradle to Cradle Certified™
- EPEAT (Electronic Product Environmental Assessment Tool)
- EU Taxonomy for Sustainable Activities
- TCFD (Task Force on Climate-related Financial Disclosures)

### Industry Practices
- Use recognized calculation methodologies for carbon footprints
- Implement third-party verification for sustainability claims
- Follow supply chain transparency best practices
- Adopt water stewardship principles
- Align with circular economy frameworks
- Support multiple sustainability certification schemes

## JSON Schema Example

```json
{
  "type": "object",
  "properties": {
    "Sustainability": {
      "type": "object",
      "properties": {
        "RecycledContent": {
          "type": "object",
          "properties": {
            "TotalRecycledPercentage": {
              "type": "number",
              "minimum": 0,
              "maximum": 100,
              "description": "Total recycled content percentage"
            },
            "PreConsumerRecycled": {
              "type": "number",
              "minimum": 0,
              "maximum": 100,
              "description": "Pre-consumer recycled content percentage"
            },
            "PostConsumerRecycled": {
              "type": "number",
              "minimum": 0,
              "maximum": 100,
              "description": "Post-consumer recycled content percentage"
            },
            "RecycledMaterials": {
              "type": "array",
              "items": {
                "type": "object",
                "properties": {
                  "MaterialType": {
                    "type": "string",
                    "description": "Type of recycled material"
                  },
                  "Percentage": {
                    "type": "number",
                    "minimum": 0,
                    "maximum": 100
                  },
                  "Source": {
                    "type": "string",
                    "enum": ["PreConsumer", "PostConsumer", "Mixed"]
                  }
                },
                "required": ["MaterialType", "Percentage", "Source"]
              }
            },
            "CertificationStandard": {
              "type": "string",
              "enum": ["GRS", "RCS", "OEKO-TEX", "Cradle2Cradle", "Other"]
            },
            "VerificationMethod": {
              "type": "string",
              "description": "Method used to verify recycled content"
            },
            "TraceabilityChain": {
              "type": "array",
              "items": {
                "type": "object",
                "properties": {
                  "Stage": {
                    "type": "string"
                  },
                  "Organization": {
                    "type": "string"
                  },
                  "CertificationNumber": {
                    "type": "string"
                  }
                }
              }
            }
          }
        },
        "PrimaryMaterialContent": {
          "type": "object",
          "properties": {
            "MaterialComposition": {
              "type": "array",
              "items": {
                "type": "object",
                "properties": {
                  "MaterialType": {
                    "type": "string",
                    "description": "Type of primary material"
                  },
                  "Percentage": {
                    "type": "number",
                    "minimum": 0,
                    "maximum": 100
                  },
                  "Grade": {
                    "type": "string",
                    "description": "Material grade or specification"
                  }
                },
                "required": ["MaterialType", "Percentage"]
              }
            },
            "SourceOrigin": {
              "type": "array",
              "items": {
                "type": "object",
                "properties": {
                  "Country": {
                    "type": "string",
                    "pattern": "^[A-Z]{2}$",
                    "description": "ISO 3166-1 alpha-2 country code"
                  },
                  "Region": {
                    "type": "string",
                    "description": "Specific region or province"
                  },
                  "MaterialType": {
                    "type": "string"
                  },
                  "Percentage": {
                    "type": "number",
                    "minimum": 0,
                    "maximum": 100
                  }
                },
                "required": ["Country", "MaterialType", "Percentage"]
              }
            },
            "SustainabilityStandards": {
              "type": "array",
              "items": {
                "type": "string",
                "enum": ["FSC", "PEFC", "MSC", "ASC", "RTRS", "RSPO", "Other"]
              }
            },
            "ConflictMinerals": {
              "type": "object",
              "properties": {
                "Compliant": {
                  "type": "boolean",
                  "description": "Conflict minerals compliance status"
                },
                "StandardsFollowed": {
                  "type": "array",
                  "items": {
                    "type": "string",
                    "enum": ["OECD", "CFSI", "RMI", "Other"]
                  }
                },
                "AuditDate": {
                  "type": "string",
                  "format": "date-time"
                }
              }
            },
            "BioBased": {
              "type": "object",
              "properties": {
                "BioBasedPercentage": {
                  "type": "number",
                  "minimum": 0,
                  "maximum": 100
                },
                "CertificationStandard": {
                  "type": "string",
                  "enum": ["ASTM D6400", "EN 13432", "USDA BioPreferred", "Other"]
                }
              }
            }
          }
        },
        "CarbonFootprint": {
          "type": "object",
          "properties": {
            "TotalCO2Equivalent": {
              "type": "number",
              "minimum": 0,
              "description": "Total carbon footprint"
            },
            "Unit": {
              "type": "string",
              "enum": ["kg CO2e", "t CO2e", "g CO2e"],
              "default": "kg CO2e"
            },
            "Scope1Emissions": {
              "type": "number",
              "minimum": 0,
              "description": "Direct emissions"
            },
            "Scope2Emissions": {
              "type": "number",
              "minimum": 0,
              "description": "Indirect energy emissions"
            },
            "Scope3Emissions": {
              "type": "number",
              "minimum": 0,
              "description": "Other indirect emissions"
            },
            "LifecycleStage": {
              "type": "array",
              "items": {
                "type": "object",
                "properties": {
                  "Stage": {
                    "type": "string",
                    "enum": ["RawMaterial", "Production", "Distribution", "Use", "EndOfLife"]
                  },
                  "EmissionsCO2e": {
                    "type": "number",
                    "minimum": 0
                  },
                  "Percentage": {
                    "type": "number",
                    "minimum": 0,
                    "maximum": 100
                  }
                },
                "required": ["Stage", "EmissionsCO2e"]
              }
            },
            "CalculationMethod": {
              "type": "string",
              "enum": ["ISO 14067", "GHG Protocol", "PAS 2050", "Cradle2Cradle", "Other"]
            },
            "AssessmentDate": {
              "type": "string",
              "format": "date-time"
            },
            "ValidityPeriod": {
              "type": "object",
              "properties": {
                "From": {
                  "type": "string",
                  "format": "date-time"
                },
                "To": {
                  "type": "string",
                  "format": "date-time"
                }
              }
            },
            "CertificationStandard": {
              "type": "string",
              "enum": ["ISO 14067", "PAS 2060", "Carbon Trust", "Other"]
            },
            "OffsetPrograms": {
              "type": "array",
              "items": {
                "type": "object",
                "properties": {
                  "ProgramName": {
                    "type": "string"
                  },
                  "OffsetAmount": {
                    "type": "number",
                    "minimum": 0
                  },
                  "OffsetType": {
                    "type": "string",
                    "enum": ["Forestry", "Renewable Energy", "Methane Capture", "Direct Air Capture", "Other"]
                  },
                  "Standard": {
                    "type": "string",
                    "enum": ["VCS", "Gold Standard", "CAR", "CDM", "Other"]
                  }
                }
              }
            }
          },
          "required": ["TotalCO2Equivalent", "Unit"]
        },
        "WaterUsage": {
          "type": "object",
          "properties": {
            "TotalWaterConsumption": {
              "type": "number",
              "minimum": 0,
              "description": "Total water consumption"
            },
            "Unit": {
              "type": "string",
              "enum": ["liters", "m³", "gallons"],
              "default": "liters"
            },
            "ProductionWaterUse": {
              "type": "object",
              "properties": {
                "ProcessWater": {
                  "type": "number",
                  "minimum": 0
                },
                "CoolingWater": {
                  "type": "number",
                  "minimum": 0
                },
                "CleaningWater": {
                  "type": "number",
                  "minimum": 0
                }
              }
            },
            "WaterStressIndex": {
              "type": "object",
              "properties": {
                "OverallRisk": {
                  "type": "string",
                  "enum": ["Low", "Medium", "High", "Extremely High"]
                },
                "SourceRegions": {
                  "type": "array",
                  "items": {
                    "type": "object",
                    "properties": {
                      "Country": {
                        "type": "string",
                        "pattern": "^[A-Z]{2}$"
                      },
                      "Region": {
                        "type": "string"
                      },
                      "StressLevel": {
                        "type": "string",
                        "enum": ["Low", "Medium", "High", "Extremely High"]
                      },
                      "WaterSource": {
                        "type": "string",
                        "enum": ["Groundwater", "Surface Water", "Municipal", "Recycled", "Other"]
                      }
                    }
                  }
                }
              }
            },
            "WaterEfficiencyMeasures": {
              "type": "array",
              "items": {
                "type": "object",
                "properties": {
                  "Measure": {
                    "type": "string"
                  },
                  "WaterSaved": {
                    "type": "number",
                    "minimum": 0
                  },
                  "EfficiencyGain": {
                    "type": "number",
                    "minimum": 0,
                    "maximum": 100,
                    "description": "Percentage improvement"
                  }
                }
              }
            },
            "WaterRecycling": {
              "type": "object",
              "properties": {
                "RecycledWaterPercentage": {
                  "type": "number",
                  "minimum": 0,
                  "maximum": 100
                },
                "TreatmentMethods": {
                  "type": "array",
                  "items": {
                    "type": "string",
                    "enum": ["Primary", "Secondary", "Tertiary", "Advanced", "Membrane", "Other"]
                  }
                }
              }
            },
            "WasteWaterTreatment": {
              "type": "object",
              "properties": {
                "TreatmentLevel": {
                  "type": "string",
                  "enum": ["Primary", "Secondary", "Tertiary", "Advanced"]
                },
                "DischargeStandards": {
                  "type": "array",
                  "items": {
                    "type": "string"
                  }
                },
                "WaterQualityParameters": {
                  "type": "object",
                  "properties": {
                    "BOD": {
                      "type": "number",
                      "description": "Biochemical Oxygen Demand (mg/L)"
                    },
                    "COD": {
                      "type": "number",
                      "description": "Chemical Oxygen Demand (mg/L)"
                    },
                    "TSS": {
                      "type": "number",
                      "description": "Total Suspended Solids (mg/L)"
                    },
                    "pH": {
                      "type": "number",
                      "minimum": 0,
                      "maximum": 14
                    }
                  }
                }
              }
            },
            "AssessmentMethod": {
              "type": "string",
              "enum": ["ISO 14046", "Water Footprint Network", "WBCSD", "Other"]
            },
            "AssessmentDate": {
              "type": "string",
              "format": "date-time"
            }
          },
          "required": ["TotalWaterConsumption", "Unit"]
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
  "Sustainability": {
    "RecycledContent": {
      "TotalRecycledPercentage": 65.0,
      "PreConsumerRecycled": 25.0,
      "PostConsumerRecycled": 40.0,
      "RecycledMaterials": [
        {
          "MaterialType": "Steel",
          "Percentage": 45.0,
          "Source": "PostConsumer"
        },
        {
          "MaterialType": "Aluminum",
          "Percentage": 20.0,
          "Source": "Mixed"
        }
      ],
      "CertificationStandard": "GRS",
      "VerificationMethod": "Third-party audit and material flow tracking",
      "TraceabilityChain": [
        {
          "Stage": "Collection",
          "Organization": "Example Recycling Collective Ltd.",
          "CertificationNumber": "GRS-2025-001"
        },
        {
          "Stage": "Processing",
          "Organization": "Fictional Metal Recovery Inc.",
          "CertificationNumber": "GRS-2025-002"
        }
      ]
    },
    "PrimaryMaterialContent": {
      "MaterialComposition": [
        {
          "MaterialType": "Steel",
          "Percentage": 35.0,
          "Grade": "S355"
        },
        {
          "MaterialType": "Iron Ore",
          "Percentage": 55.0,
          "Grade": "Hematite"
        },
        {
          "MaterialType": "Carbon",
          "Percentage": 1.2,
          "Grade": "Metallurgical Coke"
        },
        {
          "MaterialType": "Limestone",
          "Percentage": 8.8,
          "Grade": "Flux Grade"
        }
      ],
      "SourceOrigin": [
        {
          "Country": "AU",
          "Region": "Western Australia",
          "MaterialType": "Iron Ore",
          "Percentage": 60.0
        },
        {
          "Country": "BR",
          "Region": "Minas Gerais",
          "MaterialType": "Iron Ore",
          "Percentage": 40.0
        }
      ],
      "SustainabilityStandards": ["RTRS"],
      "ConflictMinerals": {
        "Compliant": true,
        "StandardsFollowed": ["OECD", "RMI"],
        "AuditDate": "2025-06-15T00:00:00Z"
      },
      "BioBased": {
        "BioBasedPercentage": 0.0,
        "CertificationStandard": "Other"
      }
    },
    "CarbonFootprint": {
      "TotalCO2Equivalent": 2450.5,
      "Unit": "kg CO2e",
      "Scope1Emissions": 1850.2,
      "Scope2Emissions": 450.8,
      "Scope3Emissions": 149.5,
      "LifecycleStage": [
        {
          "Stage": "RawMaterial",
          "EmissionsCO2e": 1200.0,
          "Percentage": 49.0
        },
        {
          "Stage": "Production",
          "EmissionsCO2e": 980.3,
          "Percentage": 40.0
        },
        {
          "Stage": "Distribution",
          "EmissionsCO2e": 147.1,
          "Percentage": 6.0
        },
        {
          "Stage": "Use",
          "EmissionsCO2e": 73.6,
          "Percentage": 3.0
        },
        {
          "Stage": "EndOfLife",
          "EmissionsCO2e": 49.5,
          "Percentage": 2.0
        }
      ],
      "CalculationMethod": "ISO 14067",
      "AssessmentDate": "2025-05-20T00:00:00Z",
      "ValidityPeriod": {
        "From": "2025-01-01T00:00:00Z",
        "To": "2027-12-31T23:59:59Z"
      },
      "CertificationStandard": "ISO 14067",
      "OffsetPrograms": [
        {
          "ProgramName": "Example Forest Conservation Initiative",
          "OffsetAmount": 500.0,
          "OffsetType": "Forestry",
          "Standard": "VCS"
        }
      ]
    },
    "WaterUsage": {
      "TotalWaterConsumption": 15750.0,
      "Unit": "liters",
      "ProductionWaterUse": {
        "ProcessWater": 8500.0,
        "CoolingWater": 6250.0,
        "CleaningWater": 1000.0
      },
      "WaterStressIndex": {
        "OverallRisk": "Medium",
        "SourceRegions": [
          {
            "Country": "DE",
            "Region": "North Rhine-Westphalia",
            "StressLevel": "Medium",
            "WaterSource": "Surface Water"
          },
          {
            "Country": "AU",
            "Region": "Western Australia",
            "StressLevel": "High",
            "WaterSource": "Groundwater"
          }
        ]
      },
      "WaterEfficiencyMeasures": [
        {
          "Measure": "Closed-loop cooling system implementation",
          "WaterSaved": 3200.0,
          "EfficiencyGain": 25.0
        },
        {
          "Measure": "Rainwater harvesting system",
          "WaterSaved": 850.0,
          "EfficiencyGain": 8.0
        }
      ],
      "WaterRecycling": {
        "RecycledWaterPercentage": 35.0,
        "TreatmentMethods": ["Secondary", "Tertiary"]
      },
      "WasteWaterTreatment": {
        "TreatmentLevel": "Tertiary",
        "DischargeStandards": ["EU Urban Waste Water Directive", "Local Environmental Authority"],
        "WaterQualityParameters": {
          "BOD": 15.0,
          "COD": 35.0,
          "TSS": 10.0,
          "pH": 7.2
        }
      },
      "AssessmentMethod": "ISO 14046",
      "AssessmentDate": "2025-05-20T00:00:00Z"
    }
  }
}
```

## Notes

### Implementation Notes
- Sustainability data should be regularly updated to reflect current practices
- Third-party verification recommended for carbon footprint and recycled content claims
- Water stress assessments should use recognized global databases (e.g., WRI Aqueduct)
- Material composition data should align with product specifications
- Consider implementing automated data collection from production systems
- Support for multiple units and conversions essential for global use

### Related Aspects
- **Product Information**: Material composition and specifications
- **Compliance Data**: Environmental certifications and standards
- **Processing Information**: Production methods affecting sustainability
- **Parties**: Certification bodies and laboratories for verification
- **General Attachments**: LCA reports, certificates, and sustainability documents

### References
- ISO 14040:2006 - Environmental management — Life cycle assessment — Principles and framework
- ISO 14044:2006 - Environmental management — Life cycle assessment — Requirements and guidelines
- ISO 14067:2018 - Greenhouse gases — Carbon footprint of products
- ISO 14046:2014 - Environmental management — Water footprint
- GHG Protocol Product Life Cycle Accounting and Reporting Standard
- Ellen MacArthur Foundation - Circularity Indicators
- Water Footprint Network Assessment Manual
- EU Digital Product Passport Guidelines