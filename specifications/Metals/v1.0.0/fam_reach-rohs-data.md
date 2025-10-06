# RoHS/REACH Compliance

## Aspect Overview

### Aspect Name
**Name**: RoHS/REACH Compliance

### Aspect Category
- [ ] Physical Properties
- [ ] Chemical Properties
- [ ] Delivery Conditions
- [ ] Processing Information
- [ ] Quality Attributes
- [x] Compliance Data
- [ ] Sustainability Metrics
- [ ] Other: ___________

### Priority
- [x] Core (Required)
- [ ] Standard (Recommended)
- [ ] Extended (Optional)

## Data Structure

### Primary Data Elements
List the main data fields for this aspect:

| Field Name | Data Type | Required | Description | Example |
|------------|-----------|----------|-------------|---------|
| RohsCompliance | object | Yes | RoHS compliance information | {...} |
| ReachCompliance | object | Yes | REACH compliance information | {...} |
| Substances | array | Yes | List of substances and their concentrations | [...] |
| Exemptions | array | No | Applicable exemptions | [...] |
| Certificates | array | No | Compliance certificates | [...] |
| TestReports | array | No | Test reports and analysis | [...] |
| SupplierDeclarations | array | No | Supplier compliance declarations | [...] |
| LastUpdated | string | Yes | Last update timestamp | "2025-01-15T10:30:00Z" |
| ComplianceStatus | string | Yes | Overall compliance status | "compliant" |
| RegulatoryRegion | array | Yes | Applicable regulatory regions | ["EU", "US", "China"] |

### Sub-aspects

#### Sub-aspect 1: RoHS Compliance
- **Description**: Restriction of Hazardous Substances compliance per EU Directive 2011/65/EU
- **Data Elements**:
  - RohsCategory (product category under RoHS)
  - RestrictedSubstances (RoHS restricted substances list)
  - ConcentrationLimits (maximum allowed concentrations)
  - Exemptions (applicable exemptions with expiry dates)
  - TestResults (analytical test results)
  - ComplianceDate (date of compliance assessment)
  - DeclarationOfCompliance (formal compliance declaration)
  - RohsVersion (version of RoHS directive applied)

#### Sub-aspect 2: REACH Compliance
- **Description**: Registration, Evaluation, Authorisation and Restriction of Chemicals compliance per EU Regulation 1907/2006
- **Data Elements**:
  - CandidateList (SVHC candidate list substances)
  - SvhcListReference (version and date of SVHC list used)
  - AuthorizedSubstances (substances requiring authorization)
  - RestrictedSubstances (substances under restriction)
  - RegistrationNumbers (REACH registration numbers)
  - SdsReferences (Safety Data Sheet references)
  - NotificationThreshold (0.1% threshold notifications)
  - SupplierCommunication (communication in supply chain)

#### Sub-aspect 3: Substance Information
- **Description**: Detailed information about chemical substances present
- **Data Elements**:
  - SubstanceName (chemical name and identifiers)
  - CasNumber (Chemical Abstracts Service number)
  - EcNumber (European Commission number)
  - Concentration (concentration or concentration range)
  - Location (where in product substance is located)
  - Function (purpose/function of substance)
  - Alternatives (alternative substances information)

## Validation Rules

### Required Validations
- RoHS category must be from defined list (1-11)
- Substance concentrations must be within valid ranges (0-100%)
- CAS numbers must follow valid format (XXXXX-XX-X)
- ComplianceStatus must be from enumerated values
- TestReports must reference valid testing standards

### Format Validations
- CAS numbers must match regex pattern: `^\d{2,7}-\d{2}-\d$`
- EC numbers must match format: `2XX-XXX-X` or `3XX-XXX-X`
- Concentration values must be numeric with appropriate units
- Date fields must be valid ISO 8601 timestamps
- Certificate numbers are free-form strings (no specific format validation due to varying issuer formats)

### Business Rules
- RoHS RestrictedSubstances must not exceed maximum concentration limits
- REACH SVHC substances >0.1% must be communicated to recipients
- Exemptions should include validity period
- TestReports should be from accredited laboratories when available
- SupplierDeclarations must be signed and dated
- Compliance assessments should be updated when regulations change
- SVHC list version should be tracked for compliance assessment

## Use Cases

### Primary Use Cases
1. **EU Market Access**: Ensuring products meet RoHS/REACH requirements for EU sales
2. **Supply Chain Communication**: Providing substance information to downstream users
3. **Regulatory Reporting**: Supporting regulatory submissions and notifications
4. **Customer Requirements**: Meeting customer-specific substance restrictions
5. **Risk Management**: Identifying and managing hazardous substances
6. **Audit Support**: Providing evidence of compliance for audits

### Integration Points
Where does this aspect connect with other parts of the format?
- **Chemical Properties**: Detailed chemical composition data
- **Quality Attributes**: Material safety and performance characteristics
- **General Attachment Information**: Test reports, certificates, and safety data sheets
- **Compliance Data**: Other regulatory compliance requirements
- **Supplier Information**: Links to supplier declarations and certifications

## Implementation Considerations

### Technical Requirements
- Integration with substance databases (ECHA, CHEMADVISOR, etc.)
- Automated compliance checking against current regulations
- Multi-language support for regulatory regions
- Version control for regulation updates
- Secure handling of proprietary substance information
- Regular updates for SVHC list changes (typically bi-annual)

### Standards Compliance
- EU RoHS Directive 2011/65/EU (and amendments)
- EU REACH Regulation 1907/2006 (and updates)
- IEC 62474 (Material Declaration for Products)
- ECHA Candidate List updates
- China RoHS (GB/T 26572)
- US TSCA requirements

### Industry Practices
- Regular monitoring of regulatory updates (ECHA publishes SVHC updates twice yearly)
- Proactive substance screening and assessment
- Supplier engagement and declaration management
- Third-party testing for high-risk substances
- Documentation retention (typically 10 years)
- Use of industry databases for substance tracking

## JSON Schema Example

```json
{
  "type": "object",
  "properties": {
    "RohsCompliance": {
      "type": "object",
      "properties": {
        "RohsCategory": {
          "type": "integer",
          "minimum": 1,
          "maximum": 11,
          "description": "RoHS product category (1-11)"
        },
        "RohsVersion": {
          "type": "string",
          "enum": ["RoHS2", "RoHS3"],
          "default": "RoHS3",
          "description": "Version of RoHS directive"
        },
        "ComplianceStatus": {
          "type": "string",
          "enum": ["compliant", "non-compliant", "pending", "exempt"],
          "description": "RoHS compliance status"
        },
        "RestrictedSubstances": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "Substance": {
                "type": "string",
                "enum": ["lead", "mercury", "cadmium", "hexavalent_chromium", "pbb", "pbde", "dehp", "bbp", "dbp", "dibp"],
                "description": "RoHS restricted substance"
              },
              "ConcentrationLimit": {
                "type": "number",
                "description": "Maximum allowed concentration"
              },
              "ActualConcentration": {
                "type": "number",
                "description": "Actual measured concentration"
              },
              "Unit": {
                "type": "string",
                "enum": ["ppm", "percent", "mg/kg"],
                "default": "ppm",
                "description": "Concentration unit"
              },
              "DetectionLimit": {
                "type": "number",
                "description": "Laboratory detection limit"
              }
            },
            "required": ["Substance", "ConcentrationLimit", "ActualConcentration", "Unit"]
          }
        },
        "Exemptions": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "ExemptionNumber": {
                "type": "string",
                "description": "RoHS exemption number (e.g., 6(a), 7(c)-I)"
              },
              "Description": {
                "type": "string",
                "description": "Exemption description"
              },
              "ExpiryDate": {
                "type": "string",
                "format": "date",
                "description": "Exemption expiry date"
              },
              "ApplicableSubstances": {
                "type": "array",
                "items": {
                  "type": "string"
                },
                "description": "Substances covered by exemption"
              },
              "ProductCategories": {
                "type": "array",
                "items": {
                  "type": "integer"
                },
                "description": "RoHS categories where exemption applies"
              }
            },
            "required": ["ExemptionNumber", "Description"]
          }
        },
        "TestReports": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "ReportNumber": {
                "type": "string",
                "description": "Test report number"
              },
              "TestingLaboratory": {
                "type": "string",
                "description": "Name of testing laboratory"
              },
              "AccreditationNumber": {
                "type": "string",
                "description": "Lab accreditation number (e.g., ISO 17025)"
              },
              "TestStandard": {
                "type": "string",
                "enum": ["IEC 62321", "EN 62321", "EPA 3052", "EPA 6010", "Other"],
                "description": "Testing standard used"
              },
              "TestDate": {
                "type": "string",
                "format": "date",
                "description": "Date of testing"
              },
              "ReportUrl": {
                "type": "string",
                "format": "uri",
                "description": "URL to test report"
              }
            },
            "required": ["ReportNumber", "TestingLaboratory", "TestStandard", "TestDate"]
          }
        },
        "ComplianceDate": {
          "type": "string",
          "format": "date-time",
          "description": "Date of compliance assessment"
        }
      },
      "required": ["RohsCategory", "ComplianceStatus", "RestrictedSubstances", "ComplianceDate"]
    },
    "ReachCompliance": {
      "type": "object",
      "properties": {
        "ComplianceStatus": {
          "type": "string",
          "enum": ["compliant", "non-compliant", "pending", "not-applicable"],
          "description": "REACH compliance status"
        },
        "SvhcListReference": {
          "type": "object",
          "properties": {
            "Version": {
              "type": "string",
              "description": "SVHC list version (e.g., 'January 2024 (30th update)')"
            },
            "EffectiveDate": {
              "type": "string",
              "format": "date",
              "description": "Date list became effective"
            },
            "TotalSubstances": {
              "type": "integer",
              "description": "Number of substances on this version of the list"
            },
            "UpdateNumber": {
              "type": "integer",
              "description": "Sequential update number"
            }
          },
          "required": ["Version", "EffectiveDate"],
          "description": "Reference to SVHC list version used for assessment"
        },
        "SvhcSubstances": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "SubstanceName": {
                "type": "string",
                "description": "SVHC substance name"
              },
              "CasNumber": {
                "type": "string",
                "pattern": "^\\d{2,7}-\\d{2}-\\d$",
                "description": "CAS registry number"
              },
              "EcNumber": {
                "type": "string",
                "pattern": "^[23]\\d{2}-\\d{3}-\\d$",
                "description": "EC number"
              },
              "Concentration": {
                "type": "number",
                "minimum": 0,
                "maximum": 100,
                "description": "Concentration in article (%)"
              },
              "ConcentrationRange": {
                "type": "string",
                "enum": ["<0.1%", "0.1-1%", "1-10%", "10-25%", ">25%"],
                "description": "Concentration range if exact value unknown"
              },
              "CandidateListDate": {
                "type": "string",
                "format": "date",
                "description": "Date substance was added to candidate list"
              },
              "ReasonForInclusion": {
                "type": "array",
                "items": {
                  "type": "string",
                  "enum": ["CMR", "PBT", "vPvB", "Endocrine disruptor", "Equivalent concern"]
                },
                "description": "Reasons for SVHC listing"
              },
              "UseCategory": {
                "type": "string",
                "description": "Use category in the article"
              },
              "SafeUseInstructions": {
                "type": "string",
                "description": "Instructions for safe use if applicable"
              }
            },
            "required": ["SubstanceName", "CasNumber", "Concentration", "CandidateListDate"]
          }
        },
        "AuthorizedSubstances": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "SubstanceName": {
                "type": "string",
                "description": "Authorized substance name"
              },
              "AuthorizationNumber": {
                "type": "string",
                "pattern": "^REACH/\\d{2}/\\d{1,2}/\\d{1,4}$",
                "description": "REACH authorization number"
              },
              "AuthorizationHolder": {
                "type": "string",
                "description": "Authorization holder"
              },
              "ExpiryDate": {
                "type": "string",
                "format": "date",
                "description": "Authorization expiry date"
              },
              "ReviewPeriod": {
                "type": "string",
                "format": "date",
                "description": "Review period end date"
              },
              "UseConditions": {
                "type": "string",
                "description": "Conditions of use"
              }
            },
            "required": ["SubstanceName", "AuthorizationNumber", "AuthorizationHolder"]
          }
        },
        "RestrictedSubstances": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "SubstanceName": {
                "type": "string",
                "description": "Restricted substance name"
              },
              "RestrictionEntry": {
                "type": "string",
                "description": "REACH Annex XVII entry number"
              },
              "RestrictionConditions": {
                "type": "string",
                "description": "Restriction conditions"
              },
              "Exemptions": {
                "type": "array",
                "items": {
                  "type": "string"
                },
                "description": "Applicable exemptions"
              }
            },
            "required": ["SubstanceName", "RestrictionEntry", "RestrictionConditions"]
          }
        },
        "RegistrationNumbers": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "SubstanceName": {
                "type": "string",
                "description": "Registered substance name"
              },
              "RegistrationNumber": {
                "type": "string",
                "pattern": "^\\d{2}-\\d{10}-\\d{2}-\\d{4}$",
                "description": "REACH registration number"
              },
              "RegistrationStatus": {
                "type": "string",
                "enum": ["Full", "Intermediate", "PPORD"],
                "description": "Type of registration"
              }
            },
            "required": ["SubstanceName", "RegistrationNumber"]
          }
        },
        "ComplianceDate": {
          "type": "string",
          "format": "date-time",
          "description": "Date of REACH compliance assessment"
        }
      },
      "required": ["ComplianceStatus", "SvhcListReference", "SvhcSubstances", "ComplianceDate"]
    },
    "Substances": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "SubstanceName": {
            "type": "string",
            "description": "Chemical substance name"
          },
          "CasNumber": {
            "type": "string",
            "pattern": "^\\d{2,7}-\\d{2}-\\d$",
            "description": "CAS registry number"
          },
          "EcNumber": {
            "type": "string",
            "pattern": "^[23]\\d{2}-\\d{3}-\\d$",
            "description": "EC number"
          },
          "Concentration": {
            "type": "number",
            "minimum": 0,
            "maximum": 100,
            "description": "Concentration in product (%)"
          },
          "Unit": {
            "type": "string",
            "enum": ["ppm", "percent", "mg/kg", "w/w", "w/v"],
            "default": "percent",
            "description": "Concentration unit"
          },
          "Location": {
            "type": "string",
            "description": "Location/component where substance is present"
          },
          "Function": {
            "type": "string",
            "description": "Function/purpose of the substance"
          },
          "RohsRestricted": {
            "type": "boolean",
            "description": "Whether substance is RoHS restricted"
          },
          "ReachSvhc": {
            "type": "boolean",
            "description": "Whether substance is REACH SVHC"
          },
          "AlternativeAssessed": {
            "type": "boolean",
            "description": "Whether alternatives have been assessed"
          },
          "SafetyDataSheet": {
            "type": "string",
            "format": "uri",
            "description": "URL to safety data sheet"
          }
        },
        "required": ["SubstanceName", "Concentration", "Unit", "Location"]
      }
    },
    "Certificates": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "CertificateType": {
            "type": "string",
            "enum": ["rohs", "reach", "combined", "iec62474", "other"],
            "description": "Type of certificate"
          },
          "CertificateNumber": {
            "type": "string",
            "minLength": 1,
            "maxLength": 100,
            "description": "Certificate number as issued by certification body"
          },
          "IssuingAuthority": {
            "type": "string",
            "description": "Issuing certification body"
          },
          "IssueDate": {
            "type": "string",
            "format": "date",
            "description": "Certificate issue date"
          },
          "ExpiryDate": {
            "type": "string",
            "format": "date",
            "description": "Certificate expiry date"
          },
          "CertificateUrl": {
            "type": "string",
            "format": "uri",
            "description": "URL to certificate"
          },
          "VerificationUrl": {
            "type": "string",
            "format": "uri",
            "description": "URL to verify certificate validity"
          },
          "Scope": {
            "type": "string",
            "description": "Scope of certification"
          }
        },
        "required": ["CertificateType", "CertificateNumber", "IssuingAuthority", "IssueDate"]
      }
    },
    "SupplierDeclarations": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "SupplierName": {
            "type": "string",
            "description": "Name of supplier"
          },
          "SupplierIdentifier": {
            "type": "string",
            "description": "Supplier identifier (DUNS, VAT, etc.)"
          },
          "DeclarationType": {
            "type": "string",
            "enum": ["rohs", "reach", "combined", "material", "full-disclosure"],
            "description": "Type of declaration"
          },
          "DeclarationDate": {
            "type": "string",
            "format": "date",
            "description": "Date of declaration"
          },
          "ValidityPeriod": {
            "type": "object",
            "properties": {
              "From": {
                "type": "string",
                "format": "date"
              },
              "To": {
                "type": "string",
                "format": "date"
              }
            },
            "description": "Validity period of declaration"
          },
          "DeclarationUrl": {
            "type": "string",
            "format": "uri",
            "description": "URL to declaration document"
          },
          "ContactPerson": {
            "type": "string",
            "description": "Supplier contact person"
          },
          "ContactEmail": {
            "type": "string",
            "format": "email",
            "description": "Supplier contact email"
          },
          "DeclarationFormat": {
            "type": "string",
            "enum": ["IPC-1752", "IEC-62474", "IMDS", "Proprietary", "Other"],
            "description": "Format of the declaration"
          }
        },
        "required": ["SupplierName", "DeclarationType", "DeclarationDate"]
      }
    },
    "LastUpdated": {
      "type": "string",
      "format": "date-time",
      "description": "Last update timestamp"
    },
    "ComplianceStatus": {
      "type": "string",
      "enum": ["compliant", "non-compliant", "pending", "partial", "conditional"],
      "description": "Overall compliance status"
    },
    "RegulatoryRegion": {
      "type": "array",
      "items": {
        "type": "string",
        "enum": ["EU", "US", "China", "Japan", "Korea", "India", "Turkey", "UK", "Taiwan", "Global"]
      },
      "minItems": 1,
      "description": "Applicable regulatory regions"
    },
    "NextReviewDate": {
      "type": "string",
      "format": "date",
      "description": "Date when compliance should be reviewed (e.g., for SVHC list updates)"
    }
  },
  "required": ["RohsCompliance", "ReachCompliance", "Substances", "LastUpdated", "ComplianceStatus", "RegulatoryRegion"]
}
```

## Sample Data

```json
{
  "RohsCompliance": {
    "RohsCategory": 3,
    "RohsVersion": "RoHS3",
    "ComplianceStatus": "compliant",
    "RestrictedSubstances": [
      {
        "Substance": "lead",
        "ConcentrationLimit": 1000,
        "ActualConcentration": 850,
        "Unit": "ppm",
        "DetectionLimit": 50
      },
      {
        "Substance": "mercury",
        "ConcentrationLimit": 1000,
        "ActualConcentration": 5,
        "Unit": "ppm",
        "DetectionLimit": 2
      },
      {
        "Substance": "cadmium",
        "ConcentrationLimit": 100,
        "ActualConcentration": 50,
        "Unit": "ppm",
        "DetectionLimit": 5
      },
      {
        "Substance": "hexavalent_chromium",
        "ConcentrationLimit": 1000,
        "ActualConcentration": 200,
        "Unit": "ppm",
        "DetectionLimit": 10
      },
      {
        "Substance": "pbb",
        "ConcentrationLimit": 1000,
        "ActualConcentration": 10,
        "Unit": "ppm",
        "DetectionLimit": 5
      },
      {
        "Substance": "pbde",
        "ConcentrationLimit": 1000,
        "ActualConcentration": 15,
        "Unit": "ppm",
        "DetectionLimit": 5
      },
      {
        "Substance": "dehp",
        "ConcentrationLimit": 1000,
        "ActualConcentration": 0,
        "Unit": "ppm",
        "DetectionLimit": 50
      },
      {
        "Substance": "bbp",
        "ConcentrationLimit": 1000,
        "ActualConcentration": 0,
        "Unit": "ppm",
        "DetectionLimit": 50
      },
      {
        "Substance": "dbp",
        "ConcentrationLimit": 1000,
        "ActualConcentration": 0,
        "Unit": "ppm",
        "DetectionLimit": 50
      },
      {
        "Substance": "dibp",
        "ConcentrationLimit": 1000,
        "ActualConcentration": 0,
        "Unit": "ppm",
        "DetectionLimit": 50
      }
    ],
    "Exemptions": [
      {
        "ExemptionNumber": "6(a)-I",
        "Description": "Lead as an alloying element in steel for machining purposes containing up to 0.35% lead by weight",
        "ExpiryDate": "2026-07-21",
        "ApplicableSubstances": ["lead"],
        "ProductCategories": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
      }
    ],
    "TestReports": [
      {
        "ReportNumber": "RoHS-2024-001234",
        "TestingLaboratory": "TÜV SÜD Product Service",
        "AccreditationNumber": "DAkkS D-PL-14489-01-00",
        "TestStandard": "IEC 62321",
        "TestDate": "2024-11-15",
        "ReportUrl": "https://reports.example.com/rohs-2024-001234.pdf"
      }
    ],
    "ComplianceDate": "2024-12-01T10:30:00Z"
  },
  "ReachCompliance": {
    "ComplianceStatus": "compliant",
    "SvhcListReference": {
      "Version": "January 2024 (30th update)",
      "EffectiveDate": "2024-01-23",
      "TotalSubstances": 240,
      "UpdateNumber": 30
    },
    "SvhcSubstances": [
      {
        "SubstanceName": "Bis(2-ethylhexyl) phthalate (DEHP)",
        "CasNumber": "117-81-7",
        "EcNumber": "204-211-0",
        "Concentration": 0.05,
        "ConcentrationRange": "<0.1%",
        "CandidateListDate": "2008-10-28",
        "ReasonForInclusion": ["CMR"],
        "UseCategory": "Plasticizer in cable insulation",
        "SafeUseInstructions": "No special precautions required at this concentration"
      }
    ],
    "AuthorizedSubstances": [],
    "RestrictedSubstances": [
      {
        "SubstanceName": "Lead and its compounds",
        "RestrictionEntry": "63",
        "RestrictionConditions": "Shall not be placed on the market or used in articles supplied to the general public if concentration of lead (expressed as metal) is equal to or greater than 0.05% by weight",
        "Exemptions": ["Articles covered by RoHS Directive"]
      }
    ],
    "RegistrationNumbers": [
      {
        "SubstanceName": "Iron",
        "RegistrationNumber": "01-2119457014-47-0001",
        "RegistrationStatus": "Full"
      }
    ],
    "ComplianceDate": "2024-12-01T10:30:00Z"
  },
  "Substances": [
    {
      "SubstanceName": "Lead",
      "CasNumber": "7439-92-1",
      "EcNumber": "231-100-4",
      "Concentration": 0.085,
      "Unit": "percent",
      "Location": "Solder joints",
      "Function": "Electrical connection",
      "RohsRestricted": true,
      "ReachSvhc": false,
      "AlternativeAssessed": true,
      "SafetyDataSheet": "https://sds.example.com/lead-7439-92-1.pdf"
    },
    {
      "SubstanceName": "Copper",
      "CasNumber": "7440-50-8",
      "EcNumber": "231-159-6",
      "Concentration": 65.2,
      "Unit": "percent",
      "Location": "Conductive traces",
      "Function": "Electrical conductor",
      "RohsRestricted": false,
      "ReachSvhc": false,
      "AlternativeAssessed": false,
      "SafetyDataSheet": "https://sds.example.com/copper-7440-50-8.pdf"
    },
    {
      "SubstanceName": "Tin",
      "CasNumber": "7440-31-5",
      "EcNumber": "231-141-8",
      "Concentration": 15.8,
      "Unit": "percent",
      "Location": "Surface finish",
      "Function": "Corrosion protection",
      "RohsRestricted": false,
      "ReachSvhc": false,
      "AlternativeAssessed": false,
      "SafetyDataSheet": "https://sds.example.com/tin-7440-31-5.pdf"
    }
  ],
  "Certificates": [
    {
      "CertificateType": "combined",
      "CertificateNumber": "TUV-ROHS-REACH-2024-5678",
      "IssuingAuthority": "TÜV Rheinland",
      "IssueDate": "2024-12-01",
      "ExpiryDate": "2026-12-01",
      "CertificateUrl": "https://certs.example.com/rohs-reach-2024-5678.pdf",
      "VerificationUrl": "https://database.tuv.com/verify/5678",
      "Scope": "Electronic assembly model XYZ-123"
    }
  ],
  "SupplierDeclarations": [
    {
      "SupplierName": "Advanced Components Ltd",
      "SupplierIdentifier": "GB123456789",
      "DeclarationType": "combined",
      "DeclarationDate": "2024-11-20",
      "ValidityPeriod": {
        "From": "2024-11-20",
        "To": "2025-11-20"
      },
      "DeclarationUrl": "https://suppliers.example.com/declarations/acl-2024-1120.pdf",
      "ContactPerson": "John Smith",
      "ContactEmail": "compliance@advancedcomponents.com",
      "DeclarationFormat": "IPC-1752"
    }
  ],
  "LastUpdated": "2024-12-15T14:22:00Z",
  "ComplianceStatus": "compliant",
  "RegulatoryRegion": ["EU", "UK", "US"],
  "NextReviewDate": "2025-06-30"
}
```

## Notes

### Implementation Notes
- ECHA publishes SVHC list updates twice yearly (typically January and June)
- Automated monitoring of regulatory updates recommended
- Certificate numbers are free-form strings to accommodate various issuer formats
- Integration with supplier management systems for declaration tracking
- Version control essential for tracking which regulations were applied
- Multi-language support needed for international compliance reporting
- Consider implementing alerts for upcoming exemption expiries

### Real-World Considerations
- Certificate formats vary widely between certification bodies
- SVHC list grows over time - always reference the version used
- RoHS exemptions have expiry dates that vary by product category
- REACH registration numbers follow a specific format but may have variations
- Supplier declarations come in many formats (IPC-1752, IEC-62474, proprietary)

### Related Aspects
- **Chemical Properties**: Detailed substance composition and properties
- **Quality Attributes**: Material safety and performance characteristics
- **General Attachment Information**: Test reports, certificates, and safety data sheets
- **Compliance Data**: Integration with other regulatory requirements
- **Supply Chain**: Links to supplier data and declarations

### References
- EU RoHS Directive 2011/65/EU (Restriction of Hazardous Substances)
- EU REACH Regulation 1907/2006 (Registration, Evaluation, Authorisation and Restriction of Chemicals)
- IEC 62474 (Material Declaration for Products of and for the Electrotechnical Industry)
- ECHA Candidate List of Substances of Very High Concern
- IEC 62321 series (Determination of certain substances in electrotechnical products)
- IPC-1752A (Materials Declaration Management Standard)
- China RoHS (GB/T 26572)
- ECHA Guidance on substances in articles