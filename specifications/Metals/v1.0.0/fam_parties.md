# Parties

## Aspect Overview

### Aspect Name

**Name**: Parties

### Aspect Category

- [ ] Physical Properties
- [ ] Chemical Properties
- [ ] Delivery Conditions
- [ ] Processing Information
- [ ] Quality Attributes
- [x] Compliance Data
- [ ] Sustainability Metrics
- [x] Other: **Business Transaction Data**

### Priority

- [x] Core (Required)
- [ ] Standard (Recommended)
- [ ] Extended (Optional)

## Data Structure

### Primary Data Elements

List the main data fields for this aspect:

| Field Name          | Data Type    | Required | Description                                                                     | Example              |
| ------------------- | ------------ | -------- | ------------------------------------------------------------------------------- | -------------------- |
| Manufacturer        | Party        | Yes      | The party manufacturing the goods and issuing the certificate                   | See Party sub-aspect |
| Customer            | Party        | Yes      | The party purchasing the goods from the manufacturer                            | See Party sub-aspect |
| GoodsReceiver       | Party        | No       | The party receiving the physical goods (may differ from Customer)               | See Party sub-aspect |
| CertificateReceiver | Party        | No       | The party receiving the inspection certificate (may differ from Customer)       | See Party sub-aspect |
| Others              | array[Party] | No       | Other parties involved (e.g., inspection bodies, laboratories, notified bodies) | See Party sub-aspect |

### Sub-aspects

Break down into specific components:

#### Sub-aspect 1: Party

- **Description**: An organization or entity involved in the inspection certificate process
- **Data Elements**:
  - Name: String - The legal name of the organization
  - Street: Array[String] - The address (1-3 lines)
  - ZipCode: String - The postal or ZIP code
  - City: String - The city name
  - Country: String - Two-letter ISO country code (ISO 3166-1 alpha-2)
  - Emails: Array[String] - Email addresses for certificate communications
  - Logo: String - Base64-encoded PNG image of organization logo
  - Identifiers: CompanyIdentifiers - Unique identifiers for the organization
  - Contacts: Array[Person] - Contact persons associated with the organization
  - PartyRole: String - Role of this party (for Others array)

#### Sub-aspect 2: CompanyIdentifiers

- **Description**: Unique identifiers for the organization
- **Data Elements**:
  - CageCode: String - Commercial and Government Entity Code
  - VAT: String - Value Added Tax identification number (8-15 chars)
  - DUNS: String - Data Universal Numbering System identifier (9 chars)
  - EORI: String - Economic Operators Registration and Identification number
  - BPN: String - Business Partner Number (Catena-X)
  - GLN: String - Global Location Number (GS1)
  - LEI: String - Legal Entity Identifier (ISO 17442)
  - TaxId: String - National tax identification number

#### Sub-aspect 3: Person

- **Description**: Representation of an individual contact person
- **Data Elements**:
  - Name: String - The full name of the contact person
  - Role: String - The role in the business process
  - Department: String - The department association
  - Email: String - Email address of the contact
  - Phone: String - Phone number of the contact

## Validation Rules

### Required Validations

- Manufacturer and Customer are always required
- Each Party must have Name, Street, ZipCode, City, and Country
- Country must be exactly 2 uppercase letters (ISO 3166-1 alpha-2)
- At least one email address required per Party
- Email addresses must be valid format
- Others array parties must have PartyRole defined

### Format Validations

- Country code: `^[A-Z]{2}`
- Email: Valid email format per RFC 5322
- VAT: 8-15 characters
- DUNS: Exactly 9 characters
- EORI: Format varies by country (e.g., DE + 12 digits for Germany)
- BPN: BPNL + 10 alphanumeric (Catena-X format)
- GLN: 13 digits
- LEI: 20 alphanumeric characters
- Street: Array with 1-3 elements
- Logo: Base64-encoded PNG format

### Business Rules

- GoodsReceiver defaults to Customer if not specified
- CertificateReceiver defaults to Customer if not specified
- For 3.2 certificates, at least one "Others" party with inspection body role required
- PartyRole in Others must be from defined list
- Contact persons should reflect party's role
- At least one identifier recommended for traceability

## Use Cases

### Primary Use Cases

1. **Certificate Issuance**: Identify manufacturer issuing the certificate
2. **Order Fulfillment**: Link certificate to correct customer and order
3. **3.2 Certification**: Include third-party inspection bodies (TÜV, Lloyd's, etc.)
4. **Laboratory Testing**: Reference external testing laboratories
5. **Multi-channel Communication**: Support multiple email addresses
6. **Supply Chain Integration**: BPN for Catena-X, GLN for GS1 networks
7. **Customs Clearance**: EORI for import/export documentation

### Integration Points

Where does this aspect connect with other parts of the format?

- **Business Transaction**: Links to Order and Delivery information
- **Validation**: Validators from Manufacturer or inspection body (3.2)
- **Product**: Country of origin relates to Manufacturer location
- **Measurements**: Laboratory parties link to test results
- **Compliance**: Notified bodies for CE marking
- **Supply Chain Networks**: BPN for Catena-X integration

## Implementation Considerations

### Technical Requirements

- Support for multiple email addresses per organization
- Flexible identifier system for various standards
- Role-based validation for Others array
- Support for international addresses
- Base64 encoding/decoding for logos
- Validation of identifier formats

### Standards Compliance

- ISO 3166-1 alpha-2 for country codes
- RFC 5322 for email addresses
- ISO/IEC 15459: Unique identification
- ISO 17442: Legal Entity Identifier (LEI)
- GS1 General Specifications (GLN)
- Catena-X BPN specification
- EU EORI number format

### Industry Practices

- Multiple emails for different departments/functions
- Third-party involvement for 3.2 certificates mandatory
- Laboratories often independent from manufacturer
- EORI critical for cross-border trade
- BPN adoption growing in automotive sector
- Multiple identifiers common for large organizations

## JSON Schema Example

```json
{
  "type": "object",
  "properties": {
    "Parties": {
      "type": "object",
      "properties": {
        "Manufacturer": {
          "$ref": "#/$defs/Party"
        },
        "Customer": {
          "$ref": "#/$defs/Party"
        },
        "GoodsReceiver": {
          "$ref": "#/$defs/Party"
        },
        "CertificateReceiver": {
          "$ref": "#/$defs/Party"
        },
        "Others": {
          "type": "array",
          "items": {
            "allOf": [
              { "$ref": "#/$defs/Party" },
              {
                "properties": {
                  "PartyRole": {
                    "type": "string",
                    "enum": [
                      "InspectionBody",
                      "Laboratory",
                      "NotifiedBody",
                      "CertificationBody",
                      "WitnessingAuthority",
                      "Subcontractor",
                      "Distributor",
                      "Other"
                    ]
                  }
                },
                "required": ["PartyRole"]
              }
            ]
          }
        }
      },
      "required": ["Manufacturer", "Customer"],
      "additionalProperties": false
    }
  },
  "$defs": {
    "Party": {
      "type": "object",
      "properties": {
        "Name": {
          "type": "string"
        },
        "Street": {
          "type": "array",
          "items": { "type": "string" },
          "minItems": 1,
          "maxItems": 3
        },
        "ZipCode": {
          "type": "string"
        },
        "City": {
          "type": "string"
        },
        "Country": {
          "type": "string",
          "minLength": 2,
          "maxLength": 2,
          "pattern": "^[A-Z]{2}$"
        },
        "Emails": {
          "type": "array",
          "items": {
            "type": "string",
            "format": "email"
          },
          "minItems": 1,
          "uniqueItems": true
        },
        "Logo": {
          "type": "string",
          "contentEncoding": "base64",
          "contentMediaType": "image/png"
        },
        "Identifiers": {
          "$ref": "#/$defs/CompanyIdentifiers"
        },
        "Contacts": {
          "type": "array",
          "items": { "$ref": "#/$defs/Person" },
          "uniqueItems": true
        }
      },
      "required": ["Name", "Street", "ZipCode", "City", "Country", "Emails"],
      "additionalProperties": false
    },
    "CompanyIdentifiers": {
      "type": "object",
      "properties": {
        "CageCode": { "type": "string" },
        "VAT": {
          "type": "string",
          "minLength": 8,
          "maxLength": 15
        },
        "DUNS": {
          "type": "string",
          "minLength": 9,
          "maxLength": 9
        },
        "EORI": {
          "type": "string",
          "pattern": "^[A-Z]{2}[A-Z0-9]{1,15}$"
        },
        "BPN": {
          "type": "string",
          "pattern": "^BPNL[0-9A-Z]{10}$"
        },
        "GLN": {
          "type": "string",
          "pattern": "^[0-9]{13}$"
        },
        "LEI": {
          "type": "string",
          "pattern": "^[A-Z0-9]{20}$"
        },
        "TaxId": { "type": "string" }
      },
      "additionalProperties": false
    },
    "Person": {
      "type": "object",
      "properties": {
        "Name": {
          "type": "string"
        },
        "Role": {
          "type": "string"
        },
        "Department": {
          "type": "string"
        },
        "Email": {
          "type": "string",
          "format": "email"
        },
        "Phone": {
          "type": "string"
        }
      },
      "required": ["Name", "Role"],
      "additionalProperties": false
    }
  }
}
```

## Sample Data

```json
{
  "Parties": {
    "Manufacturer": {
      "Name": "Fictional Steel Works Corporation",
      "Street": ["123 Industrial Boulevard"],
      "ZipCode": "45001",
      "City": "Steeltown",
      "Country": "DE",
      "Emails": [
        "certificates@example-steel.test",
        "quality@example-steel.test",
        "export@example-steel.test"
      ],
      "Logo": "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==",
      "Identifiers": {
        "VAT": "DE999999999",
        "DUNS": "999999999",
        "CageCode": "F9999",
        "EORI": "DE999999999999",
        "BPN": "BPNL9999999999",
        "GLN": "9999999999999",
        "LEI": "999999999999999999XX"
      },
      "Contacts": [
        {
          "Name": "Alexandra Schmidt",
          "Role": "Quality Manager",
          "Department": "Factory Production Control",
          "Email": "a.schmidt@example-steel.test",
          "Phone": "+49 999 999-0000"
        }
      ]
    },
    "Customer": {
      "Name": "Example Automotive Components Ltd.",
      "Street": ["456 Manufacturing Street", "Industrial Park North"],
      "ZipCode": "12345",
      "City": "Autoville",
      "Country": "US",
      "Emails": ["procurement@example-auto.test", "receiving@example-auto.test"],
      "Identifiers": {
        "VAT": "US999999999",
        "DUNS": "888888888",
        "EORI": "US9999999999",
        "BPN": "BPNL8888888888"
      },
      "Contacts": [
        {
          "Name": "Robert Johnson",
          "Role": "Purchasing Manager",
          "Department": "Procurement",
          "Email": "r.johnson@example-auto.test",
          "Phone": "+1 999 555-0100"
        }
      ]
    },
    "GoodsReceiver": {
      "Name": "Sample Logistics Solutions Inc.",
      "Street": ["789 Distribution Center Drive"],
      "ZipCode": "54321",
      "City": "Warehouseville",
      "Country": "US",
      "Emails": ["receiving@example-logistics.test", "documents@example-logistics.test"],
      "Identifiers": {
        "GLN": "7777777777777"
      },
      "Contacts": [
        {
          "Name": "Jennifer Wilson",
          "Role": "Warehouse Manager",
          "Department": "Operations",
          "Email": "j.wilson@example-logistics.test",
          "Phone": "+1 999 555-0200"
        }
      ]
    },
    "Others": [
      {
        "PartyRole": "InspectionBody",
        "Name": "Fictional Testing Institute GmbH",
        "Street": ["101 Inspection Avenue"],
        "ZipCode": "80000",
        "City": "Teststadt",
        "Country": "DE",
        "Emails": ["certificates@example-testing.test"],
        "Identifiers": {
          "VAT": "DE888888888",
          "LEI": "888888888888888888XX"
        },
        "Contacts": [
          {
            "Name": "Dr. Michael Weber",
            "Role": "Lead Inspector",
            "Department": "Material Testing",
            "Email": "m.weber@example-testing.test",
            "Phone": "+49 888 888-0000"
          }
        ]
      },
      {
        "PartyRole": "Laboratory",
        "Name": "Sample Materials Laboratory Services",
        "Street": ["202 Research Park Circle"],
        "ZipCode": "67890",
        "City": "Labtown",
        "Country": "US",
        "Emails": ["reports@example-lab.test", "info@example-lab.test"],
        "Identifiers": {
          "DUNS": "777777777",
          "TaxId": "99-9999999"
        },
        "Contacts": [
          {
            "Name": "Dr. Emily Chen",
            "Role": "Laboratory Director",
            "Department": "Chemical Analysis",
            "Email": "e.chen@example-lab.test",
            "Phone": "+1 999 555-0300"
          }
        ]
      }
    ]
  }
}
```

## Notes

### Implementation Notes

- Email array allows department-specific addresses
- Others array supports unlimited third parties
- PartyRole enum should be extensible for new roles
- Consider validation services for EORI, BPN, LEI
- Logo size limits should be enforced (e.g., max 1MB)
- Support migration from single Email to Emails array
- **IMPORTANT**: All sample data uses fictional companies, persons, and test domains (.test) to prevent accidental use in production

### Related Aspects

- Business Transaction (links parties to orders/deliveries)
- Validation (3.2 requires inspection body validator)
- Measurements (laboratory parties link to test results)
- Compliance (notified bodies for CE marking)
- Supply Chain Integration (BPN for Catena-X)
- Customs Documentation (EORI for import/export)

### References

- ISO 3166-1: Country codes
- RFC 5322: Internet Message Format (Email)
- ISO 17442: Legal Entity Identifier (LEI)
- GS1 General Specifications (GLN)
- Catena-X Standards (BPN)
- EU EORI Guidelines
- EN 10204: Certificate types (3.1, 3.2)