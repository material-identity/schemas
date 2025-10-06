# Validation and Declaration of Conformance

## Aspect Overview

### Aspect Name

**Name**: Validation and Declaration of Conformance

### Aspect Category

- [ ] Physical Properties
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
| ValidationStatement | object | Yes | Formal declaration of conformity | See sub-aspects |
| ValidationDate | string | Yes | Date of validation or approval | "2024-04-01" |
| ValidationPlace | string | No | Location where validation was performed | "Duisburg, Germany" |
| Validators | array | Yes | Persons who validated/approved | See sub-aspects |
| CertificateType | object | Yes | Type of certificate per standards | {Standard: "EN 10204", Type: "3.1"} |
| Disclaimer | string | No | Legal disclaimer text | "Subject to general conditions" |
| DigitalApproval | object | No | Digital approval information | See sub-aspects |

### Sub-aspects

Break down into specific components:

#### Sub-aspect 1: Validation Statement

- **Description**: The formal declaration of conformity or compliance
- **Data Elements**:
  - Statement: String - Full text of the declaration
  - Standards: Array - List of standards to which conformity is declared
  - ComplianceType: String - Type of compliance being declared
  - Language: String - Language of the statement (ISO 639-1 code)
  - ReferenceDocuments: Array - References to supporting documents

#### Sub-aspect 2: Validating Person

- **Description**: Person responsible for validation and approval
- **Data Elements**:
  - Name: String - Full name of the validator
  - Title: String - Job title or position
  - Department: String - Department or division
  - Signature: String - Base64 encoded signature image
  - SignatureDate: String - Date when signed (if different from ValidationDate)
  - Email: String - Contact email
  - Phone: String - Contact phone
  - CertificationNumber: String - Professional certification number (if applicable)
  - Authority: String - Legal authority to validate

#### Sub-aspect 3: Certificate Type

- **Description**: Classification of the certificate according to standards
- **Data Elements**:
  - Standard: String - The standard defining certificate types
  - Type: String - Specific type according to the standard
  - Description: String - Description of what this type represents
  - RequiredValidators: Number - Minimum validators required for this type
  - ThirdPartyRequired: Boolean - Whether third-party validation is required

#### Sub-aspect 4: Digital Approval

- **Description**: Information for digital/electronic approvals
- **Data Elements**:
  - ApprovalSystem: String - Name of digital approval system
  - ApprovalID: String - Unique identifier in the system
  - Timestamp: String - ISO 8601 timestamp
  - HashValue: String - Document hash for integrity
  - CertificateURL: String - URL to verify the certificate

## Validation Rules

### Required Validations

- At least one Validator must be provided with Name and Title
- ValidationStatement must include the Statement text
- ValidationDate must be a valid date
- CertificateType must reference a recognized standard
- For Type 3.2 certificates, at least two validators required (one third-party)
- Email format validation when provided
- Signature image must be valid base64 when provided

### Format Validations

- Date fields in ISO 8601 format (YYYY-MM-DD)
- Timestamps in ISO 8601 format with timezone
- Language codes per ISO 639-1 (e.g., "en", "de", "fr")
- Email addresses must follow RFC 5322
- Phone numbers should include country code

### Business Rules

- Certificate Type determines validation requirements:
  - Type 2.1: Declaration by manufacturer
  - Type 2.2: Declaration with non-specific inspection
  - Type 3.1: Declaration with specific inspection
  - Type 3.2: Third-party validation required
- Validator authority must match certificate type requirements
- Third-party validators must be from independent organizations
- Digital approvals require both system ID and timestamp

## Use Cases

### Primary Use Cases

1. **Legal Compliance**: Providing legally binding declarations of conformity
2. **Quality Assurance**: Documenting who approved product quality
3. **Traceability**: Identifying responsible parties for validation
4. **Audit Support**: Providing clear validation trails
5. **Customer Assurance**: Demonstrating proper approval processes
6. **Regulatory Requirements**: Meeting industry-specific validation needs
7. **Digital Transformation**: Supporting paperless validation processes

### Integration Points

Where does this aspect connect with other parts of the format?

- **Regulatory Markings**: Validates the markings are properly applied
- **Test Results**: Confirms test results meet requirements
- **Product Information**: Links validation to specific products/batches
- **Manufacturing Process**: Validates process compliance
- **Quality Management**: Part of QMS documentation
- **Customer Requirements**: Validates customer-specific needs are met

## Implementation Considerations

### Technical Requirements

- Support for multiple validators (especially for Type 3.2)
- Signature image handling and storage
- Multi-language support for statements
- Integration with digital approval systems
- Hash generation for document integrity
- Support for various certificate type standards

### Standards Compliance

- EN 10204: Metallic products - Types of inspection documents
- ISO 10474: Steel and steel products - Inspection documents
- EN 10168: Steel products - Inspection documents
- ISO/IEC 17050: Conformity assessment - Supplier's declaration
- Industry-specific validation requirements
- Regional regulatory requirements

### Industry Practices

- Metal industry typically uses EN 10204 certificate types
- Pressure equipment requires specific validation procedures
- Aerospace may require multiple approvers
- Nuclear industry has strict validation chains
- Different regions may require local language statements
- Digital signatures increasingly replacing physical signatures

## JSON Schema Example

```json
{
  "type": "object",
  "properties": {
    "ValidationAndDeclaration": {
      "type": "object",
      "properties": {
        "ValidationStatement": {
          "type": "object",
          "properties": {
            "Statement": {
              "type": "string",
              "description": "Full text of the declaration of conformity"
            },
            "Standards": {
              "type": "array",
              "items": {
                "type": "string"
              },
              "description": "Standards to which conformity is declared"
            },
            "ComplianceType": {
              "type": "string",
              "enum": [
                "Declaration of Conformity",
                "Certificate of Compliance",
                "Statement of Compliance",
                "Type Approval",
                "Factory Production Control",
                "Initial Type Testing"
              ]
            },
            "Language": {
              "type": "string",
              "pattern": "^[a-z]{2}$",
              "description": "ISO 639-1 language code"
            },
            "ReferenceDocuments": {
              "type": "array",
              "items": {
                "type": "object",
                "properties": {
                  "DocumentType": {
                    "type": "string"
                  },
                  "DocumentNumber": {
                    "type": "string"
                  },
                  "Description": {
                    "type": "string"
                  }
                }
              }
            }
          },
          "required": ["Statement"]
        },
        "ValidationDate": {
          "type": "string",
          "format": "date",
          "description": "Date of validation or approval"
        },
        "ValidationPlace": {
          "type": "string",
          "description": "Location where validation was performed"
        },
        "Validators": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "Name": {
                "type": "string",
                "description": "Full name of the validator"
              },
              "Title": {
                "type": "string",
                "description": "Job title or position",
                "examples": [
                  "Quality Inspector",
                  "Head of Quality Control",
                  "Authorized Inspector",
                  "Factory Production Control Manager",
                  "Third Party Inspector"
                ]
              },
              "Department": {
                "type": "string",
                "examples": [
                  "Quality Assurance",
                  "Factory Production Control",
                  "Technical Department",
                  "Third Party Inspection"
                ]
              },
              "Signature": {
                "type": "string",
                "contentEncoding": "base64",
                "contentMediaType": "image/png",
                "description": "Base64 encoded signature image"
              },
              "SignatureDate": {
                "type": "string",
                "format": "date",
                "description": "Date when signed if different from ValidationDate"
              },
              "Email": {
                "type": "string",
                "format": "email"
              },
              "Phone": {
                "type": "string",
                "pattern": "^\\+?[1-9]\\d{1,14}$",
                "description": "Phone number with country code"
              },
              "CertificationNumber": {
                "type": "string",
                "description": "Professional certification or license number"
              },
              "Authority": {
                "type": "string",
                "enum": [
                  "Manufacturer Representative",
                  "Quality Control",
                  "Third Party Inspector",
                  "Notified Body",
                  "Authorized Inspector",
                  "Certified Inspector"
                ]
              }
            },
            "required": ["Name", "Title"]
          },
          "minItems": 1
        },
        "CertificateType": {
          "type": "object",
          "properties": {
            "Standard": {
              "type": "string",
              "examples": ["EN 10204", "ISO 10474", "EN 10168"],
              "description": "Standard defining certificate types"
            },
            "Type": {
              "type": "string",
              "examples": ["2.1", "2.2", "3.1", "3.2"],
              "description": "Specific certificate type"
            },
            "Description": {
              "type": "string",
              "description": "Description of this certificate type"
            },
            "RequiredValidators": {
              "type": "integer",
              "minimum": 1,
              "description": "Minimum number of validators required"
            },
            "ThirdPartyRequired": {
              "type": "boolean",
              "description": "Whether third-party validation is required"
            }
          },
          "required": ["Standard", "Type"]
        },
        "Disclaimer": {
          "type": "string",
          "description": "Legal disclaimer text"
        },
        "DigitalApproval": {
          "type": "object",
          "properties": {
            "ApprovalSystem": {
              "type": "string",
              "description": "Name of digital approval system"
            },
            "ApprovalID": {
              "type": "string",
              "description": "Unique identifier in the approval system"
            },
            "Timestamp": {
              "type": "string",
              "format": "date-time",
              "description": "ISO 8601 timestamp with timezone"
            },
            "HashValue": {
              "type": "string",
              "description": "SHA-256 hash of the certificate"
            },
            "CertificateURL": {
              "type": "string",
              "format": "uri",
              "description": "URL to verify the certificate"
            }
          }
        }
      },
      "required": ["ValidationStatement", "ValidationDate", "Validators", "CertificateType"]
    }
  }
}
```

## Sample Data

### Example 1: Basic Type 3.1 Certificate

```json
{
  "ValidationAndDeclaration": {
    "ValidationStatement": {
      "Statement": "We hereby certify that the material supplied complies with the specification as stated in this certificate and has been manufactured in accordance with a quality system conforming to ISO 9001:2015.",
      "Standards": ["EN 10025-2:2019", "ISO 9001:2015"],
      "ComplianceType": "Certificate of Compliance",
      "Language": "en"
    },
    "ValidationDate": "2024-04-01",
    "ValidationPlace": "Duisburg, Germany",
    "Validators": [
      {
        "Name": "Thomas Schmidt",
        "Title": "Quality Inspector",
        "Department": "Factory Production Control",
        "Email": "t.schmidt@steelmill.de",
        "Authority": "Manufacturer Representative"
      }
    ],
    "CertificateType": {
      "Standard": "EN 10204",
      "Type": "3.1",
      "Description": "Inspection certificate issued by manufacturer"
    },
    "Disclaimer": "This certificate is issued subject to our general conditions of sale."
  }
}
```

### Example 2: Type 3.2 Certificate with Third Party

```json
{
  "ValidationAndDeclaration": {
    "ValidationStatement": {
      "Statement": "We certify that the products listed in this document have been manufactured, tested and inspected in accordance with the customer's purchase order requirements and applicable specifications. All tests have been witnessed and results verified by the independent third party inspector.",
      "Standards": ["EN 10088-2:2014", "NORSOK M-650"],
      "ComplianceType": "Certificate of Compliance",
      "Language": "en",
      "ReferenceDocuments": [
        {
          "DocumentType": "Purchase Order",
          "DocumentNumber": "PO-2024-12345",
          "Description": "Customer technical requirements"
        },
        {
          "DocumentType": "Inspection Plan",
          "DocumentNumber": "ITP-2024-001",
          "Description": "Agreed inspection and test plan"
        }
      ]
    },
    "ValidationDate": "2024-03-15",
    "ValidationPlace": "Sheffield, United Kingdom",
    "Validators": [
      {
        "Name": "Sarah Johnson",
        "Title": "Head of Quality Control",
        "Department": "Quality Assurance",
        "Signature": "iVBORw0KGgoAAAANSUhEUgAAAAUA...",
        "Email": "s.johnson@manufacturer.com",
        "Phone": "+44 114 123 4567",
        "Authority": "Manufacturer Representative"
      },
      {
        "Name": "Michael Brown",
        "Title": "Senior Inspector",
        "Department": "Third Party Inspection Services",
        "Signature": "iVBORw0KGgoAAAANSUhEUgAAAAUA...",
        "Email": "m.brown@inspection-agency.com",
        "CertificationNumber": "IEng-12345",
        "Authority": "Third Party Inspector"
      }
    ],
    "CertificateType": {
      "Standard": "EN 10204",
      "Type": "3.2",
      "Description": "Inspection certificate validated by authorized third party",
      "RequiredValidators": 2,
      "ThirdPartyRequired": true
    },
    "Disclaimer": "This certificate is valid only for the specific items listed herein."
  }
}
```

### Example 3: Digital Approval System

```json
{
  "ValidationAndDeclaration": {
    "ValidationStatement": {
      "Statement": "This digital certificate confirms that the delivered products meet all specified requirements and have been manufactured under our certified quality management system.",
      "Standards": ["EN 10025-2:2019", "EN 1090-2:2018"],
      "ComplianceType": "Declaration of Conformity",
      "Language": "en"
    },
    "ValidationDate": "2024-04-10",
    "ValidationPlace": "Hamburg, Germany",
    "Validators": [
      {
        "Name": "Anna Müller",
        "Title": "Quality Manager",
        "Department": "Quality Assurance",
        "Email": "a.mueller@steel-company.de",
        "Authority": "Quality Control"
      }
    ],
    "CertificateType": {
      "Standard": "EN 10204",
      "Type": "3.1"
    },
    "DigitalApproval": {
      "ApprovalSystem": "eQuality Certificate System",
      "ApprovalID": "EQC-2024-DE-45678",
      "Timestamp": "2024-04-10T14:30:00+02:00",
      "HashValue": "a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3",
      "CertificateURL": "https://certificates.steel-company.de/verify/EQC-2024-DE-45678"
    }
  }
}
```

## Notes

### Implementation Notes

- Support for multiple languages in validation statements
- Signature image optimization for file size
- Integration with existing QMS systems
- Support for both traditional and digital approval workflows
- Consider time zones for international operations
- Implement validator authentication for digital systems

### Certificate Type Guidelines

**EN 10204 Types:**
- **Type 2.1**: Declaration of compliance with order (no test results)
- **Type 2.2**: Test report (non-specific inspection)
- **Type 3.1**: Inspection certificate 3.1 (specific inspection by manufacturer)
- **Type 3.2**: Inspection certificate 3.2 (specific inspection with third party)

### Related Aspects

- Regulatory Markings (separate but complementary)
- Test Results (validated by this declaration)
- Product Identification (what is being validated)
- Manufacturing Process (process validation)
- Quality Management (QMS context)
- Customer Requirements (validation against specs)

### References

- EN 10204:2004 - Metallic products - Types of inspection documents
- ISO 10474:2013 - Steel and steel products - Inspection documents
- EN 10168:2004 - Steel products - Inspection documents
- ISO/IEC 17050 - Supplier's declaration of conformity
- Industry-specific validation standards