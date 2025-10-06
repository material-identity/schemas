# Regulatory Markings and Certifications

## Aspect Overview

### Aspect Name

**Name**: Regulatory Markings and Certifications

### Aspect Category

- [ ] Physical Properties
- [ ] Chemical Properties
- [ ] Delivery Conditions
- [ ] Processing Information
- [ ] Quality Attributes
- [x] Compliance Data
- [ ] Sustainability Metrics
- [ ] Other: ****\_\_\_****

### Scope Clarification

This aspect focuses on the **technical and regulatory details of markings** applied to products. It does NOT include:
- Validation statements or declarations (see "Validation and Declaration of Conformance")
- Who approved/signed the certificate (see "Validation and Declaration of Conformance")
- Certificate types like EN 10204 3.1/3.2 (see "Validation and Declaration of Conformance")

This aspect DOES include:
- The markings themselves (CE, ASME, JIS, etc.)
- Technical details of certifications
- Validity and expiry information
- Verification of marking authenticity

### Priority

- [x] Core (Required)
- [ ] Standard (Recommended)
- [ ] Extended (Optional)

## Data Structure

### Primary Data Elements

List the main data fields for this aspect:

| Field Name | Data Type | Required | Description | Example |
|------------|-----------|----------|-------------|---------|
| RegulatoryMarkings | array | Yes | Array of all regulatory and certification markings | See sub-aspects |
| ComplianceLevel | string | No | Overall compliance classification | "Full Compliance", "Conditional" |
| VerificationStatus | string | No | Status of marking verification | "Verified", "Pending", "Not Verified" |
| LastAuditDate | string | No | Date of last compliance audit | "2024-03-15" |
| NextAuditDate | string | No | Scheduled next audit date | "2025-03-15" |

### Sub-aspects

Break down into specific components:

#### Sub-aspect 1: Regulatory Marking

- **Description**: Individual regulatory, certification, or compliance marking
- **Data Elements**:
  - MarkingType: String - Type of regulatory marking
  - MarkingSubType: String - Specific variant or category
  - MarkingImage: String - Base64 encoded image of the marking
  - CertificateNumber: String - Certificate or approval number
  - IssuingBody: String - Certifying authority or organization
  - NotifiedBodyNumber: String - Notified body identifier (where applicable)
  - IssueDate: String - Date of certification issue
  - ExpiryDate: String - Expiration date of certification
  - ValidityStatus: String - Current validity status
  - Scope: String - Scope of certification
  - ApplicableDirectives: Array - Relevant directives or regulations
  - HarmonizedStandards: Array - Technical standards applied
  - ProductCategories: Array - Certified product categories
  - Restrictions: Array - Any limitations or restrictions
  - AdditionalData: Object - Marking-specific additional fields

#### Sub-aspect 2: Regional Markings

Different regions have specific marking requirements:

**European Union (CE, UKCA)**
- NotifiedBodyNumber: 4-digit identifier
- DoCYear: Year of Declaration of Conformity
- EssentialRequirements: List of met requirements
- ModuleUsed: Conformity assessment module (A-H)

**United States (ASME, API, ASTM)**
- StampType: Type of ASME stamp (U, U2, S, etc.)
- CodeSection: Applicable code section
- NationalBoardNumber: Registration number
- Jurisdiction: State or province approval
- SpecificationGrade: Specific material grade certified

**Asia-Pacific (JIS, KS, CCC, BIS)**
- LicenseNumber: Manufacturing license number
- FactoryCode: Factory identification code
- ProductionBatch: Batch certification scope
- TestingLaboratory: Accredited lab reference

**Classification Societies (DNV, ABS, LR, BV)**
- ClassNotation: Specific class notation
- SurveyType: Type of survey conducted
- SurveyorID: Surveyor identification
- RuleEdition: Classification rules edition
- MaterialCategory: Classification material category

#### Sub-aspect 3: Marking Verification

- **Description**: Verification and validation information
- **Data Elements**:
  - VerificationMethod: String - How marking was verified
  - VerificationDate: String - When verified
  - VerifiedBy: String - Person/system that verified
  - VerificationDocuments: Array - Supporting documents
  - DigitalSignature: String - Digital verification signature
  - BlockchainReference: String - Blockchain verification reference



## Validation Rules

### Required Validations

- At least one RegulatoryMarking must be present if product requires certification
- MarkingType must be from the approved enumeration list
- ExpiryDate must be after IssueDate when both are provided
- NotifiedBodyNumber format must match regional requirements (e.g., 4 digits for CE)
- CertificateNumber must follow marking-specific format rules

### Format Validations

- Date fields must be in ISO 8601 format (YYYY-MM-DD)
- MarkingImage must be valid base64 encoded image (PNG, JPG, PDF)
- Certificate numbers must match expected patterns for marking type
- Notified body numbers must be valid registered numbers
- Standard references must follow proper notation (e.g., EN 10204:2004)

### Business Rules

- CE markings require NotifiedBodyNumber for certain product categories
- ASME stamps require valid National Board registration
- Multiple markings of same type allowed (e.g., multiple CE markings for different directives)
- Expired certifications should be marked with appropriate ValidityStatus
- Certain marking combinations may be mutually exclusive

## Use Cases

### Primary Use Cases

1. **Regulatory Compliance**: Demonstrating product meets required standards
2. **Market Access**: Proving eligibility for specific geographic markets
3. **Technical Verification**: Confirming marking details and validity
4. **Supply Chain**: Validation of markings throughout distribution
5. **Customs Clearance**: Documentation for international trade
6. **Customer Requirements**: Meeting specific marking requirements
7. **Marking Authenticity**: Verifying markings are genuine and valid

Note: For validation of who approved these markings and formal declarations, see "Validation and Declaration of Conformance" aspect.

### Integration Points

Where does this aspect connect with other parts of the format?

- **Validation and Declaration**: The formal approval of these markings
- **Product Identification**: Links markings to specific products/batches
- **Test Certificates**: Supporting documentation for markings
- **Manufacturing Process**: Process certifications and approvals
- **Material Classification**: Material-specific certifications
- **Traceability**: Chain of custody for certified materials

## Implementation Considerations

### Technical Requirements

- Support for multiple image formats and sizes
- Validation against official marking registries (where available)
- Support for QR codes and digital markings
- Integration with blockchain verification systems
- API connections to certification body databases

### Standards Compliance

**Global Standards:**
- ISO/IEC 17065: Conformity assessment bodies
- ISO/IEC 17025: Testing and calibration laboratories
- ISO/IEC 17021: Management systems certification

**Regional Regulations:**
- EU: Regulation (EC) No 765/2008 (Accreditation and market surveillance)
- EU: Various product directives (PED, CPR, Machinery, etc.)
- US: ASME Boiler and Pressure Vessel Code
- US: API Specifications and Standards
- China: GB Standards and CCC Requirements
- India: BIS Standards and ISI Mark requirements
- Japan: JIS Standards and JET certification

### Industry Practices

- Metal industry often requires multiple certifications per product
- Pressure equipment requires specific marking combinations
- Structural steel needs both material and fabrication certifications
- Aerospace materials require extensive certification tracking
- Nuclear applications have unique marking requirements
- Marine applications require classification society approvals

## JSON Schema Example

```json
{
  "type": "object",
  "properties": {
    "RegulatoryMarkingsAndCertifications": {
      "type": "object",
      "properties": {
        "RegulatoryMarkings": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "MarkingType": {
                "type": "string",
                "enum": [
                  "CE", "UKCA", "EAC", "CCC", "BIS", "KC", "JET", "RCM",
                  "ASME", "ASTM", "API", "UL", "FM", "TUV", "JIS", "KS", 
                  "GOST", "PED", "CPR", "ATEX", "ISO", "DNV", "DNV_GL", 
                  "ABS", "LR", "BV", "ClassNK", "RINA", "RMRS", "CCS",
                  "GS", "cUL", "CSA", "SGS", "EN", "DIN", "BS", "NF",
                  "GB", "IS", "AS", "SANS", "SII", "PSB", "SIRIM", "Other"
                ]
              },
              "MarkingSubType": {
                "type": "string",
                "description": "Specific variant (e.g., CE-PED, CE-CPR, ASME-U, API-5L)"
              },
              "MarkingImage": {
                "type": "string",
                "contentEncoding": "base64",
                "contentMediaType": "image/png",
                "description": "Base64 encoded image of the marking/stamp"
              },
              "CertificateNumber": {
                "type": "string",
                "description": "Certificate, approval, or declaration number"
              },
              "IssuingBody": {
                "type": "string",
                "description": "Authority or organization that issued the certification"
              },
              "NotifiedBodyNumber": {
                "type": "string",
                "pattern": "^[0-9]{4}$",
                "description": "4-digit notified body number (for CE, UKCA)"
              },
              "IssueDate": {
                "type": "string",
                "format": "date"
              },
              "ExpiryDate": {
                "type": "string",
                "format": "date"
              },
              "ValidityStatus": {
                "type": "string",
                "enum": ["Valid", "Expired", "Suspended", "Withdrawn", "Pending"]
              },
              "Scope": {
                "type": "string",
                "description": "Scope or limitations of the certification"
              },
              "ApplicableDirectives": {
                "type": "array",
                "items": {
                  "type": "string"
                },
                "examples": [["2014/68/EU", "2014/29/EU"], ["97/23/EC"]]
              },
              "HarmonizedStandards": {
                "type": "array",
                "items": {
                  "type": "string"
                },
                "examples": [["EN 10204:2004", "EN 10168:2004"], ["ASTM A36/A36M-19"]]
              },
              "ProductCategories": {
                "type": "array",
                "items": {
                  "type": "string"
                },
                "description": "Certified product categories or groups"
              },
              "Restrictions": {
                "type": "array",
                "items": {
                  "type": "string"
                },
                "description": "Any limitations or restrictions on use"
              },
              "AdditionalData": {
                "type": "object",
                "additionalProperties": true,
                "properties": {
                  "StampType": {
                    "type": "string",
                    "description": "ASME stamp type (U, U2, S, etc.)"
                  },
                  "CodeSection": {
                    "type": "string",
                    "description": "Applicable code section (e.g., VIII Div 1)"
                  },
                  "NationalBoardNumber": {
                    "type": "string",
                    "description": "National Board registration number"
                  },
                  "DoCYear": {
                    "type": "string",
                    "pattern": "^[0-9]{2}$",
                    "description": "Year of Declaration of Conformity (2 digits)"
                  },
                  "ModuleUsed": {
                    "type": "string",
                    "enum": ["A", "A1", "A2", "B", "C", "C1", "C2", "D", "D1", "E", "E1", "F", "G", "H", "H1"],
                    "description": "EU conformity assessment module"
                  },
                  "EssentialRequirements": {
                    "type": "array",
                    "items": {
                      "type": "string"
                    }
                  },
                  "ClassNotation": {
                    "type": "string",
                    "description": "Classification society notation"
                  },
                  "SurveyType": {
                    "type": "string",
                    "description": "Type of classification survey"
                  },
                  "SpecificationGrade": {
                    "type": "string",
                    "description": "Specific material grade certified (e.g., A36, Grade B)"
                  },
                  "TestingLaboratory": {
                    "type": "string",
                    "description": "Accredited laboratory reference"
                  },
                  "FactoryCode": {
                    "type": "string",
                    "description": "Manufacturing facility code"
                  }
                }
              }
            },
            "required": ["MarkingType"],
            "allOf": [
              {
                "if": {
                  "properties": {
                    "MarkingType": { "enum": ["CE", "UKCA"] }
                  }
                },
                "then": {
                  "required": ["NotifiedBodyNumber", "ApplicableDirectives"]
                }
              },
              {
                "if": {
                  "properties": {
                    "MarkingType": { "const": "ASME" }
                  }
                },
                "then": {
                  "properties": {
                    "AdditionalData": {
                      "required": ["StampType", "NationalBoardNumber"]
                    }
                  }
                }
              }
            ]
          },
          "minItems": 1
        },
        "ComplianceLevel": {
          "type": "string",
          "enum": ["Full Compliance", "Conditional", "Partial", "Under Review"]
        },
        "VerificationStatus": {
          "type": "string",
          "enum": ["Verified", "Pending", "Not Verified", "Disputed"]
        },
        "LastAuditDate": {
          "type": "string",
          "format": "date"
        },
        "NextAuditDate": {
          "type": "string",
          "format": "date"
        },
        "MarkingVerification": {
          "type": "object",
          "properties": {
            "VerificationMethod": {
              "type": "string",
              "enum": ["Visual", "Digital", "Database", "Blockchain", "Third-Party"]
            },
            "VerificationDate": {
              "type": "string",
              "format": "date-time"
            },
            "VerifiedBy": {
              "type": "string"
            },
            "VerificationDocuments": {
              "type": "array",
              "items": {
                "type": "object",
                "properties": {
                  "DocumentType": {
                    "type": "string"
                  },
                  "DocumentReference": {
                    "type": "string"
                  },
                  "DocumentHash": {
                    "type": "string",
                    "description": "SHA-256 hash of document"
                  }
                }
              }
            },

          }
            "ComplianceTracking": {
              "type": "object",
              "properties": {
                "ComplianceHistory": {
                  "type": "array",
                  "items": {
                    "type": "object",
                    "properties": {
                      "Date": {
                        "type": "string",
                        "format": "date"
                      },
                      "Event": {
                        "type": "string"
                      },
                      "Status": {
                        "type": "string"
                      },
                      "Notes": {
                        "type": "string"
                      }
                    }
                  }
                },
                "NonConformities": {
                  "type": "array",
                  "items": {
                    "type": "object",
                    "properties": {
                      "IdentifiedDate": {
                        "type": "string",
                        "format": "date"
                      },
                      "Description": {
                        "type": "string"
                      },
                      "Severity": {
                        "type": "string",
                        "enum": ["Critical", "Major", "Minor"]
                      },
                      "Status": {
                        "type": "string",
                        "enum": ["Open", "In Progress", "Closed"]
                      }
                    }
                  }
                },
                "CorrectiveActions": {
                  "type": "array",
                  "items": {
                    "type": "object",
                    "properties": {
                      "ActionID": {
                        "type": "string"
                      },
                      "Description": {
                        "type": "string"
                      },
                      "DueDate": {
                        "type": "string",
                        "format": "date"
                      },
                      "CompletionDate": {
                        "type": "string",
                        "format": "date"
                      }
                    }
                  }
                }
              }
            }
      },
      "required": ["RegulatoryMarkings"]
    }
  }
}
```

## Sample Data

### Example 1: Pressure Vessel Steel Plate with Multiple Markings

```json
{
  "RegulatoryMarkingsAndCertifications": {
    "RegulatoryMarkings": [
      {
        "MarkingType": "CE",
        "MarkingSubType": "CE-PED",
        "MarkingImage": "iVBORw0KGgoAAAANSUhEUgAAAAUA...",
        "CertificateNumber": "PED-2024-00123",
        "IssuingBody": "TÜV SÜD",
        "NotifiedBodyNumber": "0036",
        "IssueDate": "2024-01-15",
        "ExpiryDate": "2029-01-15",
        "ValidityStatus": "Valid",
        "Scope": "Pressure vessels Category II, Module D1",
        "ApplicableDirectives": ["2014/68/EU"],
        "HarmonizedStandards": ["EN 10028-2:2017", "EN 10204:2004"],
        "ProductCategories": ["Pressure Vessel Plates"],
        "AdditionalData": {
          "DoCYear": "24",
          "ModuleUsed": "D1",
          "EssentialRequirements": ["Annex I, Section 4.1", "Annex I, Section 4.2"]
        }
      },
      {
        "MarkingType": "ASME",
        "MarkingSubType": "ASME-SA516",
        "CertificateNumber": "MTR-2024-45678",
        "IssuingBody": "National Board",
        "IssueDate": "2024-01-10",
        "ValidityStatus": "Valid",
        "Scope": "SA-516 Grade 70 Pressure Vessel Plates",
        "HarmonizedStandards": ["ASME SA-516/SA-516M", "ASME Section II Part A"],
        "AdditionalData": {
          "StampType": "Material",
          "NationalBoardNumber": "NB-1234",
          "CodeSection": "Section II",
          "SpecificationGrade": "Grade 70"
        }
      },
      {
        "MarkingType": "EN",
        "MarkingSubType": "EN-10028",
        "CertificateNumber": "EN-CERT-2024-9876",
        "IssuingBody": "European Committee for Standardization",
        "IssueDate": "2024-01-05",
        "ValidityStatus": "Valid",
        "HarmonizedStandards": ["EN 10028-2:2017"],
        "ProductCategories": ["P355GH Pressure Vessel Steel"]
      }
    ],
    "ComplianceLevel": "Full Compliance",
    "VerificationStatus": "Verified",
    "LastAuditDate": "2023-12-15",
    "NextAuditDate": "2024-12-15",
    "MarkingVerification": {
      "VerificationMethod": "Database",
      "VerificationDate": "2024-01-20T10:30:00Z",
      "VerifiedBy": "QA-Inspector-001",
      "VerificationDocuments": [
        {
          "DocumentType": "PED Certificate",
          "DocumentReference": "TUV-PED-CERT-2024-00123",
          "DocumentHash": "a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3"
        }
      ]
    }
  }
}
```

### Example 2: Structural Steel with Regional Certifications

```json
{
  "RegulatoryMarkingsAndCertifications": {
    "RegulatoryMarkings": [
      {
        "MarkingType": "ASTM",
        "MarkingSubType": "ASTM-A36",
        "CertificateNumber": "ASTM-A36-2024-1234",
        "IssuingBody": "ASTM International",
        "IssueDate": "2024-02-01",
        "ValidityStatus": "Valid",
        "Scope": "Structural Steel Shapes and Plates",
        "HarmonizedStandards": ["ASTM A36/A36M-19"],
        "AdditionalData": {
          "SpecificationGrade": "A36",
          "TestingLaboratory": "Certified Testing Lab #CTL-123"
        }
      },
      {
        "MarkingType": "JIS",
        "MarkingSubType": "JIS-SS400",
        "MarkingImage": "iVBORw0KGgoAAAANSUhEUgAAAAUA...",
        "CertificateNumber": "JIS-G3101-2024-5678",
        "IssuingBody": "Japanese Industrial Standards Committee",
        "IssueDate": "2024-01-25",
        "ValidityStatus": "Valid",
        "HarmonizedStandards": ["JIS G 3101:2020"],
        "AdditionalData": {
          "FactoryCode": "JP-FAC-789",
          "SpecificationGrade": "SS400"
        }
      },
      {
        "MarkingType": "GB",
        "CertificateNumber": "GB/T700-2024-9012",
        "IssuingBody": "Standardization Administration of China",
        "IssueDate": "2024-01-30",
        "ValidityStatus": "Valid",
        "HarmonizedStandards": ["GB/T 700-2006"],
        "ProductCategories": ["Q235B Carbon Structural Steel"],
        "AdditionalData": {
          "SpecificationGrade": "Q235B",
          "LicenseNumber": "SAC-LIC-456789"
        }
      }
    ],
    "ComplianceLevel": "Full Compliance",
    "VerificationStatus": "Verified"
  }
}
```

### Example 3: Marine Grade Steel with Classification Society Approvals

```json
{
  "RegulatoryMarkingsAndCertifications": {
    "RegulatoryMarkings": [
      {
        "MarkingType": "DNV_GL",
        "MarkingSubType": "DNV-GL-VL-A36",
        "MarkingImage": "iVBORw0KGgoAAAANSUhEUgAAAAUA...",
        "CertificateNumber": "DNV-GL-MAT-2024-3456",
        "IssuingBody": "DNV GL",
        "IssueDate": "2024-02-10",
        "ExpiryDate": "2027-02-10",
        "ValidityStatus": "Valid",
        "Scope": "Hull structural steel Grade A36",
        "HarmonizedStandards": ["DNV-GL-RU-SHIP-Pt.2-Ch.2"],
        "ProductCategories": ["Marine Grade Steel Plates"],
        "AdditionalData": {
          "ClassNotation": "VL-A36",
          "SurveyType": "Initial Approval",
          "SurveyorID": "DNV-SURV-123",
          "RuleEdition": "2024 January",
          "MaterialCategory": "Hull Structural Steel"
        }
      },
      {
        "MarkingType": "ABS",
        "CertificateNumber": "ABS-2024-7890",
        "IssuingBody": "American Bureau of Shipping",
        "IssueDate": "2024-02-12",
        "ExpiryDate": "2027-02-12",
        "ValidityStatus": "Valid",
        "Scope": "Grade A Hull Steel",
        "HarmonizedStandards": ["ABS Rules Part 2 Chapter 3"],
        "AdditionalData": {
          "ClassNotation": "Grade A",
          "SurveyType": "Material Approval"
        }
      },
      {
        "MarkingType": "LR",
        "CertificateNumber": "LR-MAT-2024-4567",
        "IssuingBody": "Lloyd's Register",
        "IssueDate": "2024-02-08",
        "ValidityStatus": "Valid",
        "Scope": "Normal strength hull structural steel",
        "AdditionalData": {
          "ClassNotation": "Grade A",
          "MaterialCategory": "Hull Steel"
        }
      }
    ],
    "ComplianceLevel": "Full Compliance",
    "VerificationStatus": "Verified",
    "LastAuditDate": "2024-01-15",
    "NextAuditDate": "2025-01-15",
    "ComplianceTracking": {
      "ComplianceHistory": [
        {
          "Date": "2024-01-15",
          "Event": "Annual Classification Survey",
          "Status": "Passed",
          "Notes": "All markings verified, certificates renewed"
        }
      ]
    }
  }
}
```

## Notes

### Implementation Notes

- Consider API integration with certification body databases
- Implement QR code generation for digital markings
- Support for blockchain verification systems
- Automated expiry date monitoring and alerts
- Integration with document management systems
- Support for multi-language certificate information

### Regional Considerations

1. **European Union**: CE marking mandatory for many products
2. **United Kingdom**: UKCA replacing CE post-Brexit
3. **United States**: Various markings (ASME, API, ASTM) by application
4. **China**: CCC mandatory for many products
5. **India**: BIS/ISI marking requirements
6. **Marine**: Classification society approvals required globally

### Future Enhancements

- Digital product passports integration
- Automated compliance checking against regulations
- AI-powered marking verification
- Integration with customs systems
- Real-time validity checking
- Predictive compliance management

### Related Aspects

- Test Certificates (supporting documentation)
- Manufacturing Process (process certifications)
- Quality Management (ISO certifications)
- Traceability (maintaining certification chain)
- Product Identification (linking markings to products)
- Packaging (marking visibility requirements)

### References

- EU Regulation 765/2008: Accreditation and market surveillance
- EU Directive 2014/68/EU: Pressure Equipment Directive
- ASME Boiler and Pressure Vessel Code
- API Specification Q1: Quality Management System
- ISO/IEC 17065: Conformity assessment requirements
- Various national and regional marking requirements