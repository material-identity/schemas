# Customs and Trade Compliance

## Aspect Overview

### Aspect Name

**Name**: Customs and Trade Compliance

### Aspect Category

- [ ] Physical Properties
- [ ] Chemical Properties
- [ ] Delivery Conditions
- [ ] Processing Information
- [ ] Quality Attributes
- [x] Compliance Data
- [ ] Sustainability Metrics
- [x] Other: **International Trade Data**

### Priority

- [ ] Core (Required)
- [x] Standard (Recommended)
- [ ] Extended (Optional)

## Data Structure

### Primary Data Elements

List the main data fields for this aspect:

| Field Name | Data Type | Required | Description | Example |
|------------|-----------|----------|-------------|---------|
| HSCode | string | Yes | Harmonized System code (6-digit minimum) | "7208.51" |
| CNCode | string | Yes* | Combined Nomenclature code (EU 8-digit) | "7208.51.20" |
| TARICCode | string | No | EU TARIC code (10-digit) | "7208512011" |
| HSTariffNumber | string | Yes* | Full tariff classification | "7208.51.20.00" |
| CountryOfOrigin | string | Yes | ISO country code of manufacture | "GB" |
| PreferentialOrigin | object | No | Preferential origin details | See sub-aspect |
| ExportControl | object | No | Export control classifications | See sub-aspect |
| PortOfLoading | object | No | Port where goods were loaded | See sub-aspect |
| PortOfDischarge | object | No | Port where goods will be discharged | See sub-aspect |
| CustomsValue | object | No | Value declaration for customs | See sub-aspect |
| CertificatesRequired | array | No | Required customs certificates | See sub-aspect |
| DutyStatus | object | No | Duty and tax information | See sub-aspect |

### Sub-aspects

Break down into specific components:

#### Sub-aspect 1: Classification Codes

- **Description**: Various customs classification systems
- **Data Elements**:
  - HSCode: 6-digit Harmonized System
  - CNCode: 8-digit Combined Nomenclature (EU)
  - TARICCode: 10-digit integrated tariff (EU)
  - USHTSCode: US Harmonized Tariff Schedule
  - NationalCode: Country-specific additions
  - StatisticalSuffix: Statistical reporting digits
  - ClassificationDate: Date of classification
  - ClassificationAuthority: Who determined the code

#### Sub-aspect 2: Preferential Origin

- **Description**: Information for preferential duty treatment
- **Data Elements**:
  - PreferentialScheme: String (GSP, FTA name, etc.)
  - OriginCriterion: String (WO, PE, PSR code)
  - CumulationType: String (bilateral, diagonal, full)
  - CertificateType: String (EUR.1, Form A, COO)
  - CertificateNumber: String
  - IssuingAuthority: String
  - ValidFrom: Date
  - ValidTo: Date
  - ProofOfOrigin: String (invoice declaration, etc.)

#### Sub-aspect 3: Export Control

- **Description**: Export licensing and control data
- **Data Elements**:
  - ECCNCode: Export Control Classification Number (US)
  - EUDualUseCode: EU dual-use code
  - WassenaarCode: Wassenaar Arrangement code
  - MunitionsList: Military/munitions list category
  - LicenseRequired: Boolean
  - LicenseType: String (individual, global, general)
  - LicenseNumber: String
  - LicenseExpiryDate: Date
  - EndUseStatement: String

#### Sub-aspect 4: Port Information

- **Description**: Loading and discharge port details
- **Data Elements**:
  - PortCode: String (UN/LOCODE)
  - PortName: String
  - CountryCode: String (ISO 3166-1)
  - PortType: String (sea, air, road, rail, inland)
  - TerminalCode: String
  - TerminalName: String
  - CustomsOfficeCode: String
  - ETD: DateTime (Estimated Time of Departure)
  - ETA: DateTime (Estimated Time of Arrival)

#### Sub-aspect 5: Customs Value

- **Description**: Valuation for customs purposes
- **Data Elements**:
  - InvoiceValue: Number
  - Currency: String (ISO 4217)
  - ValuationMethod: String (transaction, computed, etc.)
  - IncotermsCode: String
  - IncotermsPlace: String
  - FreightCost: Number
  - InsuranceCost: Number
  - OtherCosts: Array of cost items
  - CustomsValue: Number (calculated total)

## Validation Rules

### Required Validations

- HSCode must be at least 6 digits
- CNCode required for EU trade (8 digits)
- Country codes must be ISO 3166-1 alpha-2
- Port codes should follow UN/LOCODE format
- Currency codes must be ISO 4217
- Classification codes must be valid per customs tariff

### Format Validations

- HSCode: `^\d{4}\.\d{2}(\.\d{2})?$`
- CNCode: `^\d{8}$`
- TARICCode: `^\d{10}$`
- UN/LOCODE: `^[A-Z]{2}\s?[A-Z]{3}$`
- ECCN: `^\d[A-Z]\d{3}(\.[a-z])?$`

### Business Rules

- Origin country must match manufacturing location
- Preferential origin requires supporting documents
- Export control may restrict destinations
- Customs value includes freight for CIF terms
- Classification determines duty rates
- Dual-use items require special handling

## Use Cases

### Primary Use Cases

1. **Import Clearance**: Provide classification for customs entry
2. **Export Documentation**: Generate export declarations
3. **Duty Calculation**: Determine applicable tariff rates
4. **Origin Verification**: Prove origin for preferences
5. **Trade Compliance**: Screen for export controls
6. **Supply Chain Security**: Track port-to-port movement
7. **Free Trade Agreements**: Qualify for reduced duties
8. **Statistical Reporting**: Intrastat/Extrastat reporting

### Integration Points

Where does this aspect connect with other parts of the format?

- **Product**: Links classification to specific products
- **Parties**: Importer/exporter of record
- **Transaction Data**: Commercial invoice values
- **Certificates**: Origin certificates, EUR.1, etc.
- **Delivery**: Shipping routes and logistics
- **Compliance**: Regulatory requirements

## Implementation Considerations

### Technical Requirements

- Support multiple classification systems
- Handle classification changes over time
- Link to customs tariff databases
- Support electronic customs filing
- Multi-country code mapping
- Certificate generation capability
- Integration with trade systems

### Standards Compliance

- WCO HS Convention: Harmonized System
- EU Combined Nomenclature
- UN/LOCODE: Location codes
- ISO 3166: Country codes
- ISO 4217: Currency codes
- WCO SAFE Framework
- International Trade Data System (ITDS)

### Industry Practices

- Annual HS code updates
- Binding Tariff Information (BTI) rulings
- Origin accumulation rules
- Duty suspension procedures
- Customs warehousing
- Inward/outward processing
- AEO/C-TPAT trusted trader programs

## JSON Schema Example

```json
{
  "type": "object",
  "properties": {
    "CustomsCompliance": {
      "type": "object",
      "properties": {
        "HSCode": {
          "type": "string",
          "pattern": "^\\d{4}\\.\\d{2}(\\.\\d{2})?$",
          "description": "6-digit Harmonized System code"
        },
        "CNCode": {
          "type": "string",
          "pattern": "^\\d{8}$",
          "description": "8-digit Combined Nomenclature code (EU)"
        },
        "TARICCode": {
          "type": "string",
          "pattern": "^\\d{10}$",
          "description": "10-digit TARIC code (EU)"
        },
        "HSTariffNumber": {
          "type": "string",
          "description": "Full tariff classification number"
        },
        "CountryOfOrigin": {
          "type": "string",
          "pattern": "^[A-Z]{2}$",
          "description": "ISO 3166-1 alpha-2 country code"
        },
        "PreferentialOrigin": {
          "type": "object",
          "properties": {
            "PreferentialScheme": {
              "type": "string",
              "examples": ["EU-UK TCA", "GSP", "EU-Korea FTA", "CPTPP"]
            },
            "OriginCriterion": {
              "type": "string",
              "examples": ["WO", "PE", "PSR", "CTH", "RVC40"]
            },
            "CertificateType": {
              "type": "string",
              "enum": ["EUR.1", "EUR-MED", "Form A", "Origin Declaration", "Certificate of Origin"]
            },
            "CertificateNumber": { "type": "string" },
            "IssuingAuthority": { "type": "string" },
            "ValidFrom": { "type": "string", "format": "date" },
            "ValidTo": { "type": "string", "format": "date" }
          }
        },
        "ExportControl": {
          "type": "object",
          "properties": {
            "ECCNCode": {
              "type": "string",
              "pattern": "^\\d[A-Z]\\d{3}(\\.[a-z])?$",
              "examples": ["2B350", "5A002.a.1"]
            },
            "EUDualUseCode": {
              "type": "string",
              "examples": ["2B350", "5A002a1"]
            },
            "LicenseRequired": { "type": "boolean" },
            "LicenseType": {
              "type": "string",
              "enum": ["None", "NLR", "Individual", "Global", "General", "OGEL", "OIEL"]
            },
            "LicenseNumber": { "type": "string" },
            "EndUseStatement": { "type": "string" }
          }
        },
        "PortOfLoading": {
          "type": "object",
          "properties": {
            "PortCode": {
              "type": "string",
              "pattern": "^[A-Z]{2}\\s?[A-Z]{3}$",
              "examples": ["GBSHE", "DEHAM", "NLRTM"]
            },
            "PortName": { "type": "string" },
            "CountryCode": { "type": "string", "pattern": "^[A-Z]{2}$" },
            "PortType": {
              "type": "string",
              "enum": ["Sea", "Air", "Road", "Rail", "Inland", "Postal"]
            },
            "CustomsOfficeCode": { "type": "string" },
            "ETD": { "type": "string", "format": "date-time" }
          }
        },
        "PortOfDischarge": {
          "type": "object",
          "properties": {
            "PortCode": { "type": "string", "pattern": "^[A-Z]{2}\\s?[A-Z]{3}$" },
            "PortName": { "type": "string" },
            "CountryCode": { "type": "string", "pattern": "^[A-Z]{2}$" },
            "PortType": { "type": "string" },
            "CustomsOfficeCode": { "type": "string" },
            "ETA": { "type": "string", "format": "date-time" }
          }
        },
        "CustomsValue": {
          "type": "object",
          "properties": {
            "InvoiceValue": { "type": "number", "minimum": 0 },
            "Currency": { "type": "string", "pattern": "^[A-Z]{3}$" },
            "ValuationMethod": {
              "type": "string",
              "enum": ["Transaction", "Computed", "Deductive", "Fallback"]
            },
            "IncotermsCode": { "type": "string" },
            "IncotermsPlace": { "type": "string" },
            "FreightCost": { "type": "number", "minimum": 0 },
            "InsuranceCost": { "type": "number", "minimum": 0 },
            "CustomsValue": { "type": "number", "minimum": 0 }
          }
        },
        "CertificatesRequired": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "CertificateType": { "type": "string" },
              "Required": { "type": "boolean" },
              "Provided": { "type": "boolean" },
              "ReferenceNumber": { "type": "string" }
            }
          }
        },
        "DutyStatus": {
          "type": "object",
          "properties": {
            "DutyRate": { "type": "number" },
            "DutyType": {
              "type": "string",
              "enum": ["Ad Valorem", "Specific", "Compound", "Technical"]
            },
            "PreferentialRate": { "type": "number" },
            "AntiDumpingDuty": { "type": "boolean" },
            "CountervailingDuty": { "type": "boolean" },
            "Quotas": { "type": "string" }
          }
        }
      },
      "required": ["HSCode", "CountryOfOrigin"]
    }
  }
}
```

## Sample Data

```json
{
  "CustomsCompliance": {
    "HSCode": "7208.51",
    "CNCode": "72085120",
    "TARICCode": "7208512011",
    "HSTariffNumber": "7208.51.20.00",
    "CountryOfOrigin": "GB",
    "PreferentialOrigin": {
      "PreferentialScheme": "EU-UK Trade and Cooperation Agreement",
      "OriginCriterion": "PSR",
      "CertificateType": "Origin Declaration",
      "CertificateNumber": "GB/20240915/LSS/001",
      "IssuingAuthority": "Self-Certification",
      "ValidFrom": "2024-01-01",
      "ValidTo": "2024-12-31"
    },
    "ExportControl": {
      "ECCNCode": "1C116",
      "EUDualUseCode": "1C116",
      "LicenseRequired": false,
      "LicenseType": "NLR",
      "EndUseStatement": "Civil aerospace application only"
    },
    "PortOfLoading": {
      "PortCode": "GBSHE",
      "PortName": "Sheffield",
      "CountryCode": "GB",
      "PortType": "Road",
      "CustomsOfficeCode": "GB000060",
      "ETD": "2024-09-24T14:00:00Z"
    },
    "PortOfDischarge": {
      "PortCode": "USDET",
      "PortName": "Detroit",
      "CountryCode": "US",
      "PortType": "Road",
      "CustomsOfficeCode": "3801",
      "ETA": "2024-10-05T10:00:00Z"
    },
    "CustomsValue": {
      "InvoiceValue": 5610.00,
      "Currency": "GBP",
      "ValuationMethod": "Transaction",
      "IncotermsCode": "DAP",
      "IncotermsPlace": "Detroit, MI, USA",
      "FreightCost": 450.00,
      "InsuranceCost": 56.10,
      "CustomsValue": 6116.10
    },
    "CertificatesRequired": [
      {
        "CertificateType": "Mill Test Certificate EN 10204 3.1",
        "Required": true,
        "Provided": true,
        "ReferenceNumber": "00740730/1"
      },
      {
        "CertificateType": "Certificate of Origin",
        "Required": true,
        "Provided": true,
        "ReferenceNumber": "COO-2024-09-001"
      },
      {
        "CertificateType": "REACH Compliance Statement",
        "Required": true,
        "Provided": true,
        "ReferenceNumber": "REACH-2024-001"
      }
    ],
    "DutyStatus": {
      "DutyRate": 0.0,
      "DutyType": "Ad Valorem",
      "PreferentialRate": 0.0,
      "AntiDumpingDuty": false,
      "CountervailingDuty": false,
      "Quotas": "None applicable"
    }
  }
}
```

## Notes

### Implementation Notes

- HS codes updated annually (January 1)
- Support historical code lookups
- Integration with customs systems critical
- Consider blockchain for origin verification
- Support multiple trade agreements
- Handle retroactive origin claims
- Track cumulation between countries

### Related Aspects

- Product (what is being classified)
- Parties (importer, exporter, brokers)
- Transaction Data (commercial values)
- Certificates (origin, conformity)
- Transportation (routing and logistics)
- Compliance (sanctions screening)

### References

- WCO Harmonized System Convention
- EU Combined Nomenclature
- EU TARIC Database
- US Harmonized Tariff Schedule
- UN/LOCODE: Code for Trade and Transport Locations
- WCO SAFE Framework of Standards
- Rules of Origin (various FTAs)
- Wassenaar Arrangement
- EU Dual-Use Regulation