# Summary of the Digital Material Passport (DMP) Specification

This document provides a high-level summary of the Digital Material Passport (DMP) specification for metals, as detailed in the various `fam_*.md` files.

## Core Principles

The DMP is built on the following core principles:

*   **Modularity**: The DMP is composed of independent "Aspects" (e.g., Chemical Analysis, Mechanical Properties) that can be combined as needed.
*   **Extensibility**: The format can be extended with new aspects or by replacing generic sections with industry-specific schemas without modifying the base schema.
*   **Machine-Readability**: All data is structured for automated processing, validation, and integration.
*   **Human-Readability**: The format is designed to be easily rendered into human-readable documents (e.g., PDF, HTML).
*   **Interoperability**: The DMP uses common standards (JSON Schema, ISO codes) to ensure broad compatibility.

## Structure

The DMP is a JSON object with a root element `DigitalMaterialPassport`. This root contains various aspects, each representing a specific category of information.

## Aspects

The DMP specification includes the following aspects:

*   **General Attributes**: Core identification and metadata for the DMP.
*   **Parties**: Information about the manufacturer, customer, and other involved parties.
*   **Transaction Data**: Purchase order, delivery note, and other transactional information.
*   **Metals Classification**: Classification of the metal according to various standards (EN, ASTM, etc.).
*   **Product Shapes and Dimensions**: Detailed dimensional information about the product's shape.
*   **Chemical Analysis**: Chemical composition of the material.
*   **Mechanical Properties**: Tensile, impact, hardness, and other mechanical properties.
*   **Physical Properties**: Density, thermal, electrical, and magnetic properties.
*   **Supplementary Tests**: Non-destructive testing, corrosion tests, and other supplementary examinations.
*   **Metallography**: Microstructural analysis, grain size, and phase content.
*   **Regulatory Markings & Certifications**: CE, UKCA, ASME, and other regulatory markings.
*   **RoHS/REACH Compliance**: Compliance with RoHS and REACH regulations.
*   **Sustainability**: Recycled content, carbon footprint, and other sustainability metrics.
*   **Validation and Declaration**: Formal declaration of conformity and validation by authorized personnel.
*   **General Attachment Information**: Information about attached documents (e.g., test reports, drawings).
*   **QR Code and Visual Rendering**: Specifications for generating QR codes and rendering the DMP into visual formats.
*   **Format Extension**: Defines the mechanism for extending the DMP with industry-specific schemas.
*   **PCF Extension (Catena-X)**: An example of a replacement extension for the carbon footprint, using the Catena-X PCF data model.
*   **LESS Label Extension**: An example of a supplemental extension for the LESS sustainability label.

## Universal Measurement Structure

Many aspects use a universal `Measurement` structure to record data, ensuring consistency and simplifying data processing.

## Extensibility

The `ExtensionMetadata` aspect allows for the inclusion of industry-specific schemas that can either **replace** or **supplement** existing sections of the DMP. This ensures that the core DMP schema remains stable while accommodating the evolving needs of different industries.
# General Attachment Information

## Aspect Overview

### Aspect Name

**Name**: General Attachment Information

### Aspect Category

- [ ] Physical Properties
- [ ] Chemical Properties
- [ ] Delivery Conditions
- [ ] Processing Information
- [ ] Quality Attributes
- [ ] Compliance Data
- [ ] Sustainability Metrics
- [x] Other: **Document Management & References**

### Priority

- [x] Core (Required)
- [ ] Standard (Recommended)
- [ ] Extended (Optional)

## Data Structure

### Primary Data Elements

List the main data fields for this aspect:

| Field Name    | Data Type | Required | Description                               | Example                        |
| ------------- | --------- | -------- | ----------------------------------------- | ------------------------------ |
| AttachmentId  | string    | Yes      | Unique identifier for the attachment      | "att_12345"                    |
| Filename      | string    | Yes      | Original filename of the attachment       | "safety_certificate.pdf"       |
| MimeType      | string    | Yes      | MIME type of the file                     | "application/pdf"              |
| Size          | integer   | Yes      | File size in bytes                        | 2048576                        |
| HashValue     | string    | Yes      | Cryptographic hash of the file content    | "sha256:a1b2c3d4..."           |
| HashAlgorithm | string    | Yes      | Algorithm used for hash calculation       | "SHA-256"                      |
| Url           | string    | No       | External URL if file is linked            | "https://example.com/file.pdf" |
| Base64Data    | string    | No       | Base64 encoded file content if embedded   | "iVBORw0KGgoAAAANSUhEUgAA..."  |
| CreatedAt     | string    | Yes      | ISO 8601 timestamp of attachment creation | "2025-07-10T10:30:00Z"         |
| LastModified  | string    | No       | ISO 8601 timestamp of last modification   | "2025-07-10T10:30:00Z"         |

### Sub-aspects

#### Sub-aspect 1: File Identity

- **Description**: Core identification information for the attached file
- **Data Elements**:
  - AttachmentId (unique identifier)
  - Filename (original name)
  - MimeType (content type)
  - Size (file size in bytes)

#### Sub-aspect 2: Content Integrity

- **Description**: Cryptographic verification of file content
- **Data Elements**:
  - HashValue (cryptographic hash)
  - HashAlgorithm (hash method used)
  - LastModified (modification timestamp)

#### Sub-aspect 3: Storage Method

- **Description**: How the file content is stored or referenced
- **Data Elements**:
  - Url (external reference)
  - Base64Data (embedded content)
  - CreatedAt (creation timestamp)

## Validation Rules

### Required Validations

- Either `Url` OR `Base64Data` must be provided (but not both)
- `AttachmentId` must be unique within the document
- `Filename` must not be empty
- `MimeType` must be a valid MIME type
- `Size` must be a positive integer

### Format Validations

- `MimeType` must follow RFC 6838 format (type/subtype)
- `Url` must be a valid URL if provided
- `Base64Data` must be valid base64 encoding if provided
- `HashValue` must match the expected format for the specified algorithm
- `CreatedAt` and `LastModified` must be valid ISO 8601 timestamps

### Business Rules

- File size should not exceed system-defined limits
- Hash value must match the actual file content
- Supported hash algorithms should be from approved cryptographic standards
- External URLs should be accessible and persistent

## Use Cases

### Primary Use Cases

1. **Document Attachment**: Attaching certificates, test reports, or compliance documents to material passports
2. **Image References**: Including product photos, diagrams, or visual inspection results
3. **Data Files**: Embedding or linking to structured data files (CSV, XML, JSON)

### Integration Points

Where does this aspect connect with other parts of the format?

- **Quality Attributes**: Test reports and certificates
- **Compliance Data**: Regulatory documents and certifications
- **Processing Information**: Process diagrams and specifications
- **Sustainability Metrics**: Environmental impact reports

## Implementation Considerations

### Technical Requirements

- Support for common MIME types (PDF, images, Office documents, etc.)
- Efficient handling of both embedded and linked content
- Robust hash verification mechanisms
- URL validation and accessibility checking

### Standards Compliance

- MIME types according to IANA registry
- Hash algorithms compliant with FIPS or equivalent standards
- URL format according to RFC 3986
- Base64 encoding according to RFC 4648

### Industry Practices

- Prefer SHA-256 or stronger hash algorithms
- Use external links for large files to reduce document size
- Implement proper access controls for linked resources
- Maintain audit trails for attachment modifications

## JSON Schema Example

```json
{
  "type": "object",
  "properties": {
    "AttachmentId": {
      "type": "string",
      "pattern": "^[a-zA-Z0-9_-]+$",
      "description": "Unique identifier for the attachment"
    },
    "Filename": {
      "type": "string",
      "minLength": 1,
      "maxLength": 255,
      "description": "Original filename of the attachment"
    },
    "MimeType": {
      "type": "string",
      "pattern": "^[a-zA-Z0-9][a-zA-Z0-9!#$&\\-\\^_]*\/[a-zA-Z0-9][a-zA-Z0-9!#$&\\-\\^_]*$",
      "description": "MIME type of the file"
    },
    "HashValue": {
      "type": "string",
      "description": "Cryptographic hash of the file content"
    },
    "HashAlgorithm": {
      "type": "string",
      "enum": ["SHA-256", "SHA-512", "SHA-3-256", "SHA-3-512"],
      "description": "Algorithm used for hash calculation"
    },
    "Url": {
      "type": "string",
      "format": "uri",
      "description": "External URL if file is linked"
    },
    "Base64Data": {
      "type": "string",
      "pattern": "^[A-Za-z0-9+/]*={0,2}$",
      "description": "Base64 encoded file content if embedded"
    },
    "CreatedAt": {
      "type": "string",
      "format": "date-time",
      "description": "ISO 8601 timestamp of attachment creation"
    },
    "LastModified": {
      "type": "string",
      "format": "date-time",
      "description": "ISO 8601 timestamp of last modification"
    }
  },
  "required": [
    "AttachmentId",
    "Filename",
    "MimeType",
    "HashValue",
    "HashAlgorithm",
    "CreatedAt"
  ],
  "oneOf": [{ "required": ["Url"] }, { "required": ["Base64Data"] }]
}
```

## Sample Data

```json
{
  "AttachmentId": "att_safety_cert_001",
  "Filename": "safety_certificate.pdf",
  "MimeType": "application/pdf",
  "HashValue": "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",
  "HashAlgorithm": "SHA-256",
  "Url": "https://documents.example.com/safety_cert_001.pdf",
  "CreatedAt": "2025-07-10T10:30:00Z",
  "LastModified": "2025-07-10T10:30:00Z"
}
```

Example with embedded content:

```json
{
  "AttachmentId": "att_product_image_001",
  "Filename": "product_photo.jpg",
  "MimeType": "image/jpeg",
  "HashValue": "f7bc83f430538424b13298e6aa6fb143ef4d59a14946175997479dbc2d1a3cd8",
  "HashAlgorithm": "SHA-256",
  "Base64Data": "/9j/4AAQSkZJRgABAQEAYABgAAD/2wBDAAEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQH/2wBDAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQH/wAARCAABAAEDASIAAhEBAxEB/8QAFQABAQAAAAAAAAAAAAAAAAAAAAv/xAAUEAEAAAAAAAAAAAAAAAAAAAAA/8QAFQEBAQAAAAAAAAAAAAAAAAAAAAX/xAAUEQEAAAAAAAAAAAAAAAAAAAAA/9oADAMBAAIRAxEAPwA/8H8A",
  "CreatedAt": "2025-07-10T10:30:00Z"
}
```

## Notes

### Implementation Notes

- When using external URLs, implement proper error handling for inaccessible resources
- Consider implementing attachment versioning for tracking changes
- Provide clear guidance on when to embed vs. link based on file size thresholds
- Implement proper security measures for file access and validation

### Related Aspects

- **Quality Attributes**: Test reports and inspection documents
- **Compliance Data**: Regulatory certificates and approvals
- **Processing Information**: Technical specifications and process documents
- **Sustainability Metrics**: Environmental impact assessments

### References

- RFC 6838: Media Type Specifications and Registration Procedures
- RFC 3986: Uniform Resource Identifier (URI): Generic Syntax
- RFC 4648: The Base16, Base32, and Base64 Data Encodings
- NIST FIPS 180-4: Secure Hash Standard (SHS)
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
- ASTM E1251: Standard Test Method for Analysis of Aluminum and Aluminum Alloys# Customs and Trade Compliance

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
- EU Dual-Use Regulation# Metals Delivery Condition

## Aspect Overview

### Aspect Name

**Name**: Delivery Condition

- [ ] Physical Properties
- [ ] Chemical Properties
- [x] Delivery Conditions
- [ ] Processing Information
- [ ] Quality Attributes
- [ ] Compliance Data
- [ ] Sustainability Metrics
- [ ] Other: ****\_\_\_****

### Priority

- [x] Core (Required)
- [ ] Standard (Recommended)
- [ ] Extended (Optional)

## Data Structure

### Primary Data Elements

List the main data fields for this aspect:

| Field Name | Data Type | Required | Description                     | Example                                                  |
| ---------- | --------- | -------- | ------------------------------- | -------------------------------------------------------- |
| Coloring   | object    | No       | Color marking information       | See Coloring sub-aspect |
| Marking    | object    | No       | Identification marking details  | See Marking sub-aspect |
| Bundles    | object    | No       | Bundle packaging information    | See Bundles sub-aspect |
| Stamping   | object    | No       | Stamping identification details | See Stamping sub-aspect |

### Sub-aspects

#### Sub-aspect 1: Coloring

- **Description**: Color coding applied to metals for identification, sorting, or safety purposes
- **Data Elements**:
  - Method: String - Application method (paint, powder_coating, anodizing, etc.)
  - Color: String - Color name or description
  - ColorCode: String - Standard color code (RAL, Pantone, etc.)
  - Coverage: String - Coverage area (full, partial, ends_only, etc.)
  - Purpose: String - Reason for coloring (identification, safety, aesthetics, etc.)

#### Sub-aspect 2: Marking

- **Description**: Identification marks applied to metals for traceability and identification
- **Data Elements**:
  - Type: String - Marking method (stamped, etched, laser, ink, etc.)
  - Content: String - Marking content/text
  - Location: String - Position of marking (end, side, surface, etc.)
  - Legibility: String - Readability assessment (clear, faded, illegible, etc.)
  - Standard: String - Marking standard reference (if applicable)

#### Sub-aspect 3: Bundles

- **Description**: Packaging and bundling information for grouped metal items
- **Data Elements**:
  - Type: String - Bundle method (wire_tied, banded, strapped, etc.)
  - Quantity: Number - Number of items in bundle
  - Weight: Number - Total bundle weight
  - WeightUnit: String - Weight unit (kg, lbs, etc.)
  - Dimensions: Object - Bundle dimensions
  - Material: String - Bundling material (steel_wire, plastic_strap, etc.)
  - Condition: String - Bundle condition (intact, damaged, loose, etc.)

#### Sub-aspect 4: Stamping

- **Description**: Permanent identification stamps applied to metals
- **Data Elements**:
  - Location: String - Stamp position (end, side, surface, etc.)
  - Content: String - Stamped information
  - Depth: Number - Stamp depth
  - DepthUnit: String - Depth unit (mm)
  - Legibility: String - Readability (clear, worn, deep, shallow, etc.)
  - Standard: String - Stamping standard (if applicable)
  - Equipment: String - Stamping equipment used

## Validation Rules

### Required Validations

- At least one sub-aspect must be present if DeliveryCondition is specified
- Color codes must follow recognized standards (RAL, Pantone, etc.) when specified
- Bundle quantities must be positive integers
- Weight values must be positive numbers

### Format Validations

- Color codes must match standard format patterns
- Marking content must be alphanumeric with allowed special characters
- Dimensions must include unit specifications
- Stamp depth must be within reasonable ranges (0.1-5.0mm)

### Business Rules

- Coloring method must be appropriate for metal type
- Marking location must be feasible for the metal form
- Bundle type must be suitable for metal dimensions
- Stamping depth must not compromise structural integrity

## Use Cases

### Primary Use Cases

1. **Quality Control Inspection**: Verify delivery condition matches specifications
2. **Inventory Management**: Identify and sort metals by delivery condition
3. **Traceability**: Track metals through supply chain using markings and stamps
4. **Receiving Inspection**: Validate delivery condition at goods receipt
5. **Safety Compliance**: Ensure proper safety markings and color coding

### Integration Points

Where does this aspect connect with other parts of the format?

- Links to material identification through marking/stamping content
- Connects to quality assessment through condition descriptions
- Relates to packaging information through bundle details
- Supports traceability through unique identifiers

## Implementation Considerations

### Technical Requirements

- Support for multiple color coding standards
- Flexible marking content validation
- Dimensional measurement units (metric/imperial)
- Image attachment support for visual verification
- Multiple instances of each sub-aspect (e.g., multiple markings)

### Standards Compliance

- ISO 12944 for protective paint systems
- ASTM A615 for marking requirements
- EN 10204 for material certificates
- Industry-specific marking standards
- Color standards (RAL, Pantone, NCS, BS)

### Industry Practices

- Common color coding systems in steel industry
- Standard marking positions for different metal forms
- Typical bundling methods for various metal products
- Stamping practices for traceability
- Regional variations in marking requirements

## JSON Schema Example

```json
{
  "type": "object",
  "properties": {
    "DeliveryCondition": {
      "type": "object",
      "properties": {
        "Coloring": {
          "type": "object",
          "properties": {
            "Method": {
              "type": "string",
              "enum": ["paint", "powder_coating", "anodizing", "galvanizing", "other"]
            },
            "Color": {
              "type": "string"
            },
            "ColorCode": {
              "type": "string",
              "pattern": "^(RAL|PANTONE|NCS|BS)\\s*\\S+$"
            },
            "Coverage": {
              "type": "string",
              "enum": ["full", "partial", "ends_only", "marking_only"]
            },
            "Purpose": {
              "type": "string",
              "enum": ["identification", "safety", "aesthetics", "protection", "sorting"]
            }
          }
        },
        "Marking": {
          "type": "object",
          "properties": {
            "Type": {
              "type": "string",
              "enum": ["stamped", "etched", "laser", "ink", "embossed", "other"]
            },
            "Content": {
              "type": "string",
              "maxLength": 100
            },
            "Location": {
              "type": "string",
              "enum": ["end", "side", "surface", "multiple", "other"]
            },
            "Legibility": {
              "type": "string",
              "enum": ["clear", "faded", "partial", "illegible"]
            },
            "Standard": {
              "type": "string"
            }
          }
        },
        "Bundles": {
          "type": "object",
          "properties": {
            "Type": {
              "type": "string",
              "enum": ["wire_tied", "banded", "strapped", "boxed", "loose", "other"]
            },
            "Quantity": {
              "type": "integer",
              "minimum": 1
            },
            "Weight": {
              "type": "number",
              "minimum": 0
            },
            "WeightUnit": {
              "type": "string",
              "enum": ["kg", "lbs", "t", "MT"]
            },
            "Dimensions": {
              "type": "object",
              "properties": {
                "Length": { "type": "number", "minimum": 0 },
                "Width": { "type": "number", "minimum": 0 },
                "Height": { "type": "number", "minimum": 0 },
                "Unit": {
                  "type": "string",
                  "enum": ["mm", "cm", "m", "in", "ft"]
                }
              }
            },
            "Material": {
              "type": "string",
              "enum": ["steel_wire", "plastic_strap", "metal_band", "rope", "other"]
            },
            "Condition": {
              "type": "string",
              "enum": ["intact", "damaged", "loose", "partial", "missing"]
            }
          }
        },
        "Stamping": {
          "type": "object",
          "properties": {
            "Location": {
              "type": "string",
              "enum": ["end", "side", "surface", "multiple", "other"]
            },
            "Content": {
              "type": "string",
              "maxLength": 50
            },
            "Depth": {
              "type": "number",
              "minimum": 0.1,
              "maximum": 5.0
            },
            "DepthUnit": {
              "type": "string",
              "const": "mm"
            },
            "Legibility": {
              "type": "string",
              "enum": ["clear", "worn", "deep", "shallow", "illegible"]
            },
            "Standard": {
              "type": "string"
            },
            "Equipment": {
              "type": "string"
            }
          }
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
  "DeliveryCondition": {
    "Coloring": {
      "Method": "paint",
      "Color": "Traffic Red",
      "ColorCode": "RAL 3020",
      "Coverage": "ends_only",
      "Purpose": "identification"
    },
    "Marking": {
      "Type": "stamped",
      "Content": "BATCH-2024-001-XYZ",
      "Location": "end",
      "Legibility": "clear",
      "Standard": "ASTM A615"
    },
    "Bundles": {
      "Type": "wire_tied",
      "Quantity": 50,
      "Weight": 125.5,
      "WeightUnit": "kg",
      "Dimensions": {
        "Length": 6000,
        "Width": 200,
        "Height": 150,
        "Unit": "mm"
      },
      "Material": "steel_wire",
      "Condition": "intact"
    },
    "Stamping": {
      "Location": "end",
      "Content": "MILL-CERT-789-2024",
      "Depth": 0.5,
      "DepthUnit": "mm",
      "Legibility": "clear",
      "Standard": "EN 10204",
      "Equipment": "hydraulic_press"
    }
  }
}
```

## Notes

### Implementation Notes

- Consider visual documentation through photos for verification
- Allow for multiple markings/stamps on single item (array support)
- Support both metric and imperial units with conversion
- Validate color codes against standard databases
- Consider QR code or barcode marking options

### Related Aspects

- Material Identification (linked through marking content)
- Quality Assessment (condition descriptions)
- Packaging Information (bundle details)
- Traceability (stamping and marking content)
- Visual Documentation (photos of actual condition)

### References

- ISO 12944: Paints and varnishes - Corrosion protection of steel structures
- ASTM A615: Standard Specification for Deformed and Plain Carbon-Steel Bars
- EN 10204: Metallic products - Types of inspection documents
- RAL Color Standards
- Industry best practices for metal identification and marking# PCF Extension (Catena-X) - Replacement Extension

## Aspect Overview

### Aspect Name
**Name**: PCF Extension (Catena-X) - Replacement Extension

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

## Extension Mechanism

This extension demonstrates how industry-specific schemas can **replace** generic DMP sections without modifying the base schema. The Catena-X PCF data model completely replaces the generic `Sustainability.CarbonFootprint` structure when activated.

### How It Works:
1. **Base DMP** has generic `Sustainability.CarbonFootprint` structure
2. **Extension activated** via extension metadata
3. **Catena-X schema replaces** the generic structure entirely
4. **Validation uses** only the Catena-X schema for that section

### Extension Registration:
```json
{
  "ExtensionId": "pcf-catena-x-v7",
  "ExtensionType": "replacement",
  "TargetPath": "Sustainability.CarbonFootprint",
  "ValidationMode": "exclusive"
}
```

## Data Structure

When this extension is active, the entire `Sustainability.CarbonFootprint` section follows the Catena-X PCF data model.

### Primary Data Elements

The Catena-X PCF structure that replaces the generic carbon footprint includes:

| Field Name | Data Type | Required | Description | Example |
|------------|-----------|----------|-------------|---------|
| id | string (UUID) | Yes | Product footprint identifier | "urn:uuid:550e8400-e29b-41d4-a716-446655440000" |
| specVersion | string | Yes | Version of PCF data specification | "2.0.0" |
| partialFullPcf | string | Yes | Indicator for partial or full PCF | "Cradle-to-gate" |
| version | number | Yes | Version of the product footprint | 0 |
| created | string | Yes | Timestamp of PCF creation | "2025-01-15T10:30:00Z" |
| companyName | string | Yes | PCF data owner company name | "Example Manufacturing" |
| companyIds | array | Yes | Company identifiers (must include BPNL) | ["urn:bpn:id:BPNL123456789012"] |
| productName | string | Yes | Trade name of product | "Steel Component A" |
| productIds | array | Yes | Product identifiers | ["urn:gtin:1234567890123"] |
| pcf | object | Yes | Carbon footprint calculation data | {...} |

### Sub-aspects

#### Sub-aspect 1: PCF Header Information
- **Description**: Core identification and metadata for the PCF according to Catena-X PCF Rulebook v3.0.0
- **Data Elements**:
  - id (UUID v4 product footprint identifier)
  - specVersion (PCF data specification version)
  - partialFullPcf (Cradle-to-gate or Cradle-to-grave)
  - version (product footprint version number)
  - created (timestamp of PCF creation)
  - companyName and companyIds (data owner identification)
  - productName and productIds (product identification)
  - validityPeriodStart/End (validity period of the PCF)
  - comment (additional explanatory information)
  - pcfLegalStatement (legal disclaimer)

#### Sub-aspect 2: Carbon Footprint Calculation Data (pcf object)
- **Description**: Detailed emissions calculations per Catena-X PCF Rulebook v3.0.0
- **Data Elements**:
  - **Core Emissions**:
    - pcfExcludingBiogenic (mandatory: CO2e emissions excluding biogenic)
    - pcfIncludingBiogenic (mandatory 2025: CO2e emissions including biogenic)
    - fossilGhgEmissions (mandatory 2025: fossil source emissions)
    - biogenicCarbonEmissionsOtherThanCO2 (mandatory 2025: biogenic non-CO2)
    - biogenicCarbonWithdrawal (mandatory 2025: biogenic carbon withdrawal)
    - dlucGhgEmissions (mandatory 2025: direct land use change emissions)
    - aircraftGhgEmissions (mandatory 2025: aircraft transport emissions)
  
  - **Distribution Stage Emissions** (optional):
    - distributionStagePcfExcludingBiogenic
    - distributionStagePcfIncludingBiogenic
    - distributionStageFossilGhgEmissions
    - distributionStageBiogenicCarbonEmissionsOtherThanCO2
    - distributionStageBiogenicCarbonWithdrawal
    - distributionStageAircraftGhgEmissions

#### Sub-aspect 3: Methodology & Data Quality
- **Description**: Calculation methods, standards, and data quality indicators
- **Data Elements**:
  - **Calculation Parameters**:
    - declaredUnit (unit of analysis: liter, kilogram, cubic meter, etc.)
    - unitaryProductAmount (amount of units in product)
    - productMassPerDeclaredUnit (mass per declared unit)
    - referencePeriodStart/End (time period of data)
  
  - **Standards & Methods**:
    - crossSectoralStandardsUsed (ISO 14067, GHG Protocol, etc.)
    - productOrSectorSpecificRules (PCR/PSR rules applied)
    - boundaryProcessesDescription (system boundaries)
    - exemptedEmissionsPercent (percentage of exempted emissions)
    - exemptedEmissionsDescription (description of exemptions)
  
  - **Data Quality**:
    - dataQualityRating (DQI with coverage, technological, temporal, geographical, reliability)
    - primaryDataShare (percentage of primary data used)
    - secondaryEmissionFactorSources (emission factor sources)

#### Sub-aspect 4: Geographic and Carbon Content
- **Description**: Geographic scope and carbon content information
- **Data Elements**:
  - geographyCountry (ISO country code)
  - geographyCountrySubdivision (e.g., US-NY)
  - geographyRegionOrSubregion (e.g., Africa, Europe)
  - carbonContentTotal (total carbon content)
  - carbonContentBiogenic (biogenic carbon content)
  - extWBCSD_fossilCarbonContent (fossil carbon content)

#### Sub-aspect 5: Extensions and Additional Fields
- **Description**: WBCSD and TFS extensions for additional sustainability metrics
- **Data Elements**:
  - extWBCSD_* fields (WBCSD Pathfinder extensions)
  - extTFS_* fields (Together for Sustainability extensions)
  - precedingPfIds (references to previous PCF versions)

## Validation Rules

### Required Validations
- UUID must be valid v4 format for `id` field
- `specVersion` must match supported Catena-X versions
- `companyIds` must contain at least one BPNL (Business Partner Number Legal)
- `created` timestamp must be valid ISO 8601 format
- `pcf` object must contain all mandatory fields
- `declaredUnit` must be from allowed enumeration
- Dates must be logically consistent (start before end)

### Format Validations
- BPNL format: "urn:bpn:id:BPNL" followed by 12 alphanumeric characters
- Product IDs should follow recognized formats (GTIN, CAS, etc.)
- Emission values must be non-negative numbers
- Percentages must be between 0 and 100
- DQR values must be between 1.0 and 5.0

### Business Rules
- `pcfIncludingBiogenic` should equal `pcfExcludingBiogenic` plus biogenic emissions
- `primaryDataShare` + secondary data share should equal 100%
- Distribution stage emissions are optional but if present must be complete
- Extensions (extWBCSD_*, extTFS_*) follow their respective standards
- Progressive mandatory fields (marked "mandatory 2025") become required

## Use Cases

### Primary Use Cases
1. **Automotive Supply Chain**: Standardized PCF exchange between OEMs and suppliers
2. **Regulatory Compliance**: Meeting EU Carbon Border Adjustment Mechanism (CBAM)
3. **Scope 3 Reporting**: Accurate upstream emissions data for corporate reporting
4. **Product Design**: Comparing carbon footprints of material options
5. **Procurement Decisions**: Carbon-based supplier selection
6. **Customer Transparency**: Providing verified product carbon data

### Integration Points
Where does this aspect connect with other parts of the format?
- **Sustainability (Base)**: Replaces generic CarbonFootprint structure
- **Product Information**: Links PCF to specific products
- **Business Transaction**: Associates PCF with specific deliveries
- **Chemical Analysis**: Material composition affects carbon calculations
- **Processing Information**: Manufacturing emissions data

## Implementation Considerations

### Technical Requirements
- UUID generation capability for unique identifiers
- BPNL validation against Catena-X registry
- Support for Catena-X data exchange protocols
- Handling of extension fields (extWBCSD_*, extTFS_*)
- Progressive field requirements (2025 mandatory fields)

### Standards Compliance
- ISO 14067:2018 (Carbon footprint of products)
- GHG Protocol Product Life Cycle Accounting Standard
- WBCSD Pathfinder Framework (Version 2.0+)
- **Catena-X PCF Rulebook Version 3.0.0** (primary specification)
- Catena-X PCF Data Model Version 7.0.0 (current schema)
- Technical Specifications for PCF Data Exchange (Version 2.0.0+)

### Industry Practices
- Follow Catena-X automotive industry-specific calculation methods
- Use Business Partner Number Legal Entity (BPNL) for company identification
- **Schema replacement approach**: This extension completely replaces generic carbon footprint data
- **No DMP schema changes required**: Extension mechanism handles the replacement
- **Market adoption**: Success depends on automotive industry uptake

## JSON Schema Location

The Catena-X PCF schema that replaces the generic carbon footprint structure is maintained by Eclipse Tractus-X:

**Schema URL**: https://github.com/eclipse-tractusx/sldt-semantic-models/blob/main/io.catenax.pcf/7.0.0/gen/Pcf-schema.json

**Important**: When this extension is active, the above schema completely defines the structure of `Sustainability.CarbonFootprint`.

## Sample Data

When this extension is active, the `Sustainability.CarbonFootprint` section contains Catena-X PCF data:

```json
{
  "DigitalMaterialPassport": {
    "Sustainability": {
      "CarbonFootprint": {
        // This entire section now follows Catena-X PCF schema
        "specVersion": "urn:io.catenax.pcf:datamodel:version:7.0.0",
        "id": "3893bb5d-da16-4dc1-9185-11d97476c254",
        "companyIds": ["urn:bpn:id:BPNL123456789012"],
        "created": "2022-05-22T21:47:32Z",
        "companyName": "My Corp",
        "version": 0,
        "productName": "My Product Name",
        "partialFullPcf": "Cradle-to-gate",
        "pcf": {
          "pcfExcludingBiogenic": 2.0,
          "pcfIncludingBiogenic": 1.0,
          "primaryDataShare": 56.12,
          // ... all other Catena-X specific fields
        }
        // ... rest of Catena-X structure
      }
    }
  }
}
```

### Complete Example from Catena-X:

```json
{
  "specVersion": "urn:io.catenax.pcf:datamodel:version:7.0.0",
  "companyIds": [
    "telnet://192.0.2.16:80/",
    "ftp://ftp.is.co.za/rfc/rfc1808.txt",
    "http://www.ietf.org/rfc/rfc2396.txt"
  ],
  "extWBCSD_productCodeCpc": "011-99000",
  "created": "2022-05-22T21:47:32Z",
  "companyName": "My Corp",
  "extWBCSD_pfStatus": "Active",
  "version": 0,
  "productName": "My Product Name",
  "pcf": {
    "biogenicCarbonEmissionsOtherThanCO2": 1.0,
    "distributionStagePcfExcludingBiogenic": 1.5,
    "biogenicCarbonWithdrawal": 0.0,
    "distributionStageBiogenicCarbonEmissionsOtherThanCO2": 1.0,
    "extWBCSD_allocationRulesDescription": "In accordance with Catena-X PCF Rulebook",
    "exemptedEmissionsDescription": "No exemption",
    "distributionStageFossilGhgEmissions": 0.5,
    "exemptedEmissionsPercent": 0.0,
    "geographyCountrySubdivision": "US-NY",
    "extTFS_luGhgEmissions": 0.3,
    "distributionStageBiogenicCarbonWithdrawal": 0.0,
    "pcfIncludingBiogenic": 1.0,
    "aircraftGhgEmissions": 0.0,
    "productMassPerDeclaredUnit": 0.456,
    "productOrSectorSpecificRules": [
      {
        "extWBCSD_operator": "PEF",
        "productOrSectorSpecificRules": [
          {
            "ruleName": "urn:tfs-initiative.com:PCR:The Product Carbon Footprint Guideline for the Chemical Industry:version:v2.0"
          }
        ],
        "extWBCSD_otherOperatorName": "NSF"
      }
    ],
    "extTFS_allocationWasteIncineration": "cut-off",
    "pcfExcludingBiogenic": 2.0,
    "referencePeriodEnd": "2022-12-31T23:59:59Z",
    "extWBCSD_characterizationFactors": "AR5",
    "secondaryEmissionFactorSources": [
      {
        "secondaryEmissionFactorSource": "ecoinvent 3.8"
      }
    ],
    "unitaryProductAmount": 1000.0,
    "declaredUnit": "liter",
    "referencePeriodStart": "2022-01-01T00:00:01Z",
    "geographyRegionOrSubregion": "Africa",
    "fossilGhgEmissions": 0.5,
    "distributionStageAircraftGhgEmissions": 0.0,
    "boundaryProcessesDescription": "Electricity consumption included as an input in the production phase",
    "geographyCountry": "DE",
    "extWBCSD_packagingGhgEmissions": 0,
    "dlucGhgEmissions": 0.4,
    "carbonContentTotal": 2.5,
    "extTFS_distributionStageLuGhgEmissions": 1.1,
    "primaryDataShare": 56.12,
    "dataQualityRating": {
      "completenessDQR": 2.0,
      "technologicalDQR": 2.0,
      "geographicalDQR": 2.0,
      "temporalDQR": 2.0,
      "reliabilityDQR": 2.0,
      "coveragePercent": 100
    },
    "extWBCSD_packagingEmissionsIncluded": true,
    "extWBCSD_fossilCarbonContent": 0.1,
    "crossSectoralStandardsUsed": [
      {
        "crossSectoralStandard": "ISO Standard 14067"
      }
    ],
    "extTFS_distributionStageDlucGhgEmissions": 1.0,
    "distributionStagePcfIncludingBiogenic": 0.0,
    "carbonContentBiogenic": 0.0
  },
  "partialFullPcf": "Cradle-to-gate",
  "productIds": [
    "http://www.wikipedia.org",
    "ftp://ftp.is.co.za/rfc/rfc1808.txt"
  ],
  "validityPeriodStart": "2022-01-01T00:00:01Z",
  "comment": "Additional explanatory information not reflected by other attributes",
  "id": "3893bb5d-da16-4dc1-9185-11d97476c254",
  "validityPeriodEnd": "2022-12-31T23:59:59Z",
  "pcfLegalStatement": "This PCF (Product Carbon Footprint) is for information purposes only. It is based upon the standards mentioned above.",
  "productDescription": "Ethanol, 95% solution",
  "precedingPfIds": [
    {
      "id": "3893bb5d-da16-4dc1-9185-11d97476c254"
    }
  ]
}
```

## Notes

### Implementation Notes
- **Extension Type**: This is a "replacement" extension
- **No DMP schema modification**: The base DMP schema remains unchanged
- **Complete replacement**: When active, Catena-X schema completely replaces generic carbon footprint
- **Validation**: Only Catena-X schema validates the CarbonFootprint section
- **Migration**: Use MigrationPath in extension metadata to map from generic to Catena-X fields
- **BPNL Requirement**: Company IDs must include Business Partner Number Legal Entity
- **Progressive Requirements**: Some fields become mandatory in 2025
- **Market-driven adoption**: Extension succeeds based on automotive industry adoption

### Extension Activation Example
```json
{
  "ExtensionMetadata": {
    "ExtensionId": "pcf-catena-x-v7",
    "ExtensionType": "replacement",
    "TargetPath": "Sustainability.CarbonFootprint",
    "SchemaUrl": "https://github.com/eclipse-tractusx/.../Pcf-schema.json",
    "ValidationMode": "exclusive",
    "MigrationPath": {
      "TotalCO2Equivalent": "pcf.pcfExcludingBiogenic",
      "Unit": "pcf.declaredUnit"
    }
  }
}
```

### Related Aspects
- **Sustainability (Base)**: Generic carbon footprint that gets replaced
- **Format Extension (General Concept)**: Defines how extensions work
- **Processing Information**: Manufacturing emissions may link here
- **Quality Attributes**: Environmental quality indicators
- **Compliance Data**: Regulatory reporting requirements

### References
- **Catena-X PCF Rulebook Version 3.0.0** (primary specification)
- **Catena-X PCF Data Model Version 7.0.0** (schema specification)
- **Eclipse Tractus-X Semantic Models Repository** (official schema source)
- WBCSD Technical Specifications for PCF Data Exchange (Version 2.0.0+)
- ISO 14067:2018 - Greenhouse gases — Carbon footprint of products
- GHG Protocol Product Life Cycle Accounting and Reporting Standard
- Catena-X Operating Model and Technical Standards

### Additional Resources
- Catena-X PCF Implementation Guide: https://catena-x.net/pcf-guide
- Eclipse Tractus-X GitHub: https://github.com/eclipse-tractusx
- WBCSD Pathfinder Framework: https://www.wbcsd.org/pathfinder

## Summary

The Catena-X PCF Extension demonstrates the power of the DMP extension mechanism:

1. **Complete Replacement**: The generic `Sustainability.CarbonFootprint` structure is entirely replaced by the Catena-X PCF data model when this extension is active.

2. **No Schema Changes**: The base DMP schema remains untouched - the extension mechanism handles the replacement dynamically.

3. **Industry Ownership**: Catena-X maintains and evolves their PCF schema independently, ensuring it meets automotive industry needs.

4. **Clean Validation**: When active, only the Catena-X schema validates the CarbonFootprint section, ensuring data quality and compliance.

5. **Market Adoption**: Success depends on automotive industry adoption, not on DMP schema committee decisions.

This approach allows the DMP to support multiple industry-specific carbon footprint formats (Catena-X for automotive, RMI for steel, etc.) without any modifications to the core schema, demonstrating true extensibility and future-proofing.# Format Extension

## Aspect Overview

### Aspect Name
**Name**: Format Extension (General Concept)

### Aspect Category
- [ ] Physical Properties
- [ ] Chemical Properties
- [ ] Delivery Conditions
- [ ] Processing Information
- [ ] Quality Attributes
- [ ] Compliance Data
- [ ] Sustainability Metrics
- [x] Other: **Schema Management & Extensibility**

### Priority
- [x] Core (Required)
- [ ] Standard (Recommended)
- [ ] Extended (Optional)

## Purpose

The extension mechanism allows the Digital Material Passport (DMP) to remain stable while enabling industry-specific schemas to replace or enhance generic sections. This ensures the DMP schema never needs modification when new industry standards emerge.

## Data Structure

### Primary Data Elements
List the main data fields for this aspect:

| Field Name | Data Type | Required | Description | Example |
|------------|-----------|----------|-------------|---------|
| ExtensionId | string | Yes | Unique identifier for the extension | "pcf-catena-x-v7" |
| ExtensionName | string | Yes | Human-readable name of the extension | "Product Carbon Footprint (Catena-X)" |
| Version | string | Yes | Version of the extension schema | "7.0.0" |
| ExtensionType | string | Yes | Type of extension application | "replacement" |
| TargetPath | string | Yes | JSON path in DMP being extended | "Sustainability.CarbonFootprint" |
| Namespace | string | Yes | Namespace URI for the extension | "urn:io.catenax.pcf:datamodel" |
| SchemaUrl | string | Yes | URL to the JSON schema definition | "https://github.com/eclipse-tractusx/.../Pcf-schema.json" |
| Description | string | No | Description of the extension purpose | "Replaces generic carbon footprint with Catena-X PCF" |
| Provider | string | Yes | Organization providing the extension | "Catena-X Automotive Network" |
| Compatibility | array | Yes | Compatible base format versions | ["v1.0", "v1.1"] |
| ValidationMode | string | Yes | How to validate the extended section | "exclusive" |
| MigrationPath | object | No | Mapping from base schema to extension | {"TotalCO2Equivalent": "pcf.pcfExcludingBiogenic"} |

### Sub-aspects

#### Sub-aspect 1: Extension Identity
- **Description**: Core identification and metadata for the extension
- **Data Elements**:
  - ExtensionId (unique identifier)
  - ExtensionName (display name)
  - Version (extension schema version)
  - Provider (maintaining organization)
  - Description (purpose and scope)

#### Sub-aspect 2: Extension Application
- **Description**: How the extension modifies the base schema
- **Data Elements**:
  - ExtensionType (replacement, supplement, transform)
  - TargetPath (JSON path being extended)
  - ValidationMode (exclusive, merged, override)
  - SchemaUrl (replacement/supplemental schema)

#### Sub-aspect 3: Compatibility & Migration
- **Description**: Version compatibility and data migration support
- **Data Elements**:
  - Compatibility (supported DMP versions)
  - MigrationPath (field mappings)
  - Dependencies (required extensions)
  - ConflictResolution (handling overlaps)

## Validation Rules

### Required Validations
- `ExtensionId` must be unique across all registered extensions
- `TargetPath` must be a valid JSON path in the base DMP schema
- `SchemaUrl` must be accessible and return valid JSON schema
- `Version` must follow semantic versioning (SemVer)
- `ExtensionType` must be a valid type

### Format Validations
- `ExtensionId` must follow naming convention (lowercase, hyphens, no spaces)
- `TargetPath` uses dot notation (e.g., "Sustainability.CarbonFootprint")
- `Version` must match pattern: `^\d+\.\d+\.\d+(-[a-zA-Z0-9-]+)?$`
- `ValidationMode` must be one of: exclusive, merged, override

### Business Rules
- Replacement extensions completely override the target section
- Only one extension can target the same path in replacement mode
- Extensions must maintain backward compatibility within major versions
- Migration paths should cover all required fields

## Extension Types

### Replacement
- **Purpose**: Complete replacement of a DMP section with industry-specific schema
- **Example**: Catena-X PCF replaces generic CarbonFootprint
- **Validation**: Only the extension schema is used

### Supplement
- **Purpose**: Add additional fields to existing structure
- **Example**: Adding industry-specific fields alongside base fields
- **Validation**: Both base and extension schemas apply

### Transform
- **Purpose**: Modify validation rules or constraints
- **Example**: Stricter tolerances for aerospace applications
- **Validation**: Modified rules replace base rules

## Use Cases

### Primary Use Cases
1. **Industry Standards Integration**: Catena-X for automotive, RMI for steel, etc.
2. **Regional Compliance**: Country-specific regulatory requirements
3. **Sector Requirements**: Industry-specific data models
4. **Future Standards**: New standards without DMP modification

### Integration Points
Where does this aspect connect with other parts of the format?
- **All DMP Sections**: Any section can be extended
- **Validation Engine**: Routes validation to appropriate schemas
- **Schema Registry**: Central management of extensions
- **Data Exchange**: Industry-specific data formats

## Implementation Considerations

### Technical Requirements
- JSON Schema validation with dynamic schema loading
- Path-based section replacement mechanism
- Extension registry for discovery
- Schema version management
- Validation routing based on active extensions

### Standards Compliance
- JSON Schema Draft 2020-12 or compatible
- Semantic versioning for extensions
- Industry-standard naming conventions
- Standard JSON Path notation

### Industry Practices
- Extensions published by industry consortiums
- Open source schema repositories
- Version alignment with industry standards
- Clear documentation and examples

## JSON Schema Example

```json
{
  "type": "object",
  "properties": {
    "ExtensionMetadata": {
      "type": "object",
      "properties": {
        "ExtensionId": {
          "type": "string",
          "pattern": "^[a-z0-9]+(-[a-z0-9]+)*$",
          "description": "Unique identifier for the extension"
        },
        "ExtensionName": {
          "type": "string",
          "minLength": 1,
          "maxLength": 100
        },
        "Version": {
          "type": "string",
          "pattern": "^\\d+\\.\\d+\\.\\d+(-[a-zA-Z0-9-]+)?$"
        },
        "ExtensionType": {
          "type": "string",
          "enum": ["replacement", "supplement", "transform"],
          "description": "How the extension modifies the base schema"
        },
        "TargetPath": {
          "type": "string",
          "pattern": "^[A-Za-z][A-Za-z0-9]*(\\.[A-Za-z][A-Za-z0-9]*)*$",
          "description": "JSON path to the section being extended"
        },
        "Namespace": {
          "type": "string",
          "format": "uri"
        },
        "SchemaUrl": {
          "type": "string",
          "format": "uri",
          "description": "URL to the extension schema"
        },
        "Provider": {
          "type": "string",
          "minLength": 1
        },
        "Compatibility": {
          "type": "array",
          "items": {
            "type": "string",
            "pattern": "^v\\d+\\.\\d+$"
          },
          "minItems": 1
        },
        "ValidationMode": {
          "type": "string",
          "enum": ["exclusive", "merged", "override"],
          "description": "How validation is performed"
        },
        "MigrationPath": {
          "type": "object",
          "additionalProperties": {
            "type": "string"
          },
          "description": "Field mappings from base to extension"
        },
        "ConflictResolution": {
          "type": "string",
          "enum": ["error", "extension-wins", "base-wins"],
          "default": "error"
        }
      },
      "required": [
        "ExtensionId", 
        "ExtensionName", 
        "Version", 
        "ExtensionType",
        "TargetPath",
        "SchemaUrl", 
        "Provider", 
        "Compatibility",
        "ValidationMode"
      ]
    }
  }
}
```

## Sample Data

### Example 1: Catena-X PCF Extension (Replacement)
```json
{
  "ExtensionMetadata": {
    "ExtensionId": "pcf-catena-x-v7",
    "ExtensionName": "Product Carbon Footprint (Catena-X)",
    "Version": "7.0.0",
    "ExtensionType": "replacement",
    "TargetPath": "Sustainability.CarbonFootprint",
    "Namespace": "urn:io.catenax.pcf:datamodel",
    "SchemaUrl": "https://github.com/eclipse-tractusx/sldt-semantic-models/blob/main/io.catenax.pcf/7.0.0/gen/Pcf-schema.json",
    "Description": "Replaces generic carbon footprint structure with Catena-X PCF data model for automotive supply chain",
    "Provider": "Catena-X Automotive Network",
    "Compatibility": ["v1.0", "v1.1"],
    "ValidationMode": "exclusive",
    "MigrationPath": {
      "TotalCO2Equivalent": "pcf.pcfExcludingBiogenic",
      "Unit": "pcf.declaredUnit"
    },
    "ConflictResolution": "error"
  }
}
```

### Example 2: RMI Steel Guidance Extension (Replacement)
```json
{
  "ExtensionMetadata": {
    "ExtensionId": "pcf-rmi-steel-v1",
    "ExtensionName": "Steel Industry PCF (RMI)",
    "Version": "1.0.0",
    "ExtensionType": "replacement",
    "TargetPath": "Sustainability.CarbonFootprint",
    "Namespace": "https://rmi.org/steel-guidance/pcf",
    "SchemaUrl": "https://rmi.org/schemas/steel-pcf/v1.0/schema.json",
    "Description": "Steel industry-specific carbon footprint based on RMI Steel Guidance",
    "Provider": "Rocky Mountain Institute",
    "Compatibility": ["v1.0", "v1.1"],
    "ValidationMode": "exclusive",
    "MigrationPath": {
      "TotalCO2Equivalent": "emissions.total",
      "Scope1Emissions": "emissions.scope1"
    }
  }
}
```

### Example 3: China RoHS Extension (Supplement)
```json
{
  "ExtensionMetadata": {
    "ExtensionId": "rohs-china-gb-v2",
    "ExtensionName": "China RoHS (GB/T 26572)",
    "Version": "2.0.0",
    "ExtensionType": "supplement",
    "TargetPath": "RohsReachCompliance.RohsCompliance",
    "Namespace": "https://gb-standards.cn/rohs",
    "SchemaUrl": "https://standards.cn/schemas/gb-rohs/v2.0/schema.json",
    "Description": "Adds China-specific RoHS requirements alongside EU RoHS",
    "Provider": "SAC (Standardization Administration of China)",
    "Compatibility": ["v1.0", "v1.1"],
    "ValidationMode": "merged",
    "ConflictResolution": "extension-wins"
  }
}
```

## Implementation Pattern

```python
# Pseudo-code for extension processing
def process_dmp_with_extensions(dmp_data, active_extensions):
    # 1. Validate base DMP structure
    validate_against_schema(dmp_data, base_dmp_schema)
    
    # 2. Apply extensions
    for extension in active_extensions:
        if extension.type == "replacement":
            # Replace target section with extension data
            target_section = get_path(dmp_data, extension.target_path)
            validate_against_schema(target_section, extension.schema_url)
            
        elif extension.type == "supplement":
            # Merge extension fields with base
            merge_schemas(base_schema, extension.schema)
            validate_merged(target_section)
            
        elif extension.type == "transform":
            # Apply modified validation rules
            apply_transforms(extension.rules)
    
    return processed_dmp
```

## Notes

### Key Principles
- **DMP schema stability**: Base schema never changes
- **Industry ownership**: Industries maintain their extensions
- **Clean separation**: Extensions are self-contained
- **Market-driven**: Adoption based on industry needs
- **Future-proof**: New standards add extensions, not schema changes

### Implementation Notes
- Extensions discovered at document processing time
- Validation dynamically routed based on active extensions
- Migration paths enable data transformation
- Clear precedence rules for conflicts
- Extension registry enables discovery

### Benefits
1. **Zero DMP changes**: Core schema remains stable
2. **Industry flexibility**: Each sector uses appropriate standards
3. **Clean validation**: Each section validates against its schema
4. **Easy adoption**: Industries can start using immediately
5. **Future standards**: Supported without coordination

### Related Aspects
- **All DMP Aspects**: Any section can be extended
- **Validation Framework**: Routes to appropriate schemas
- **Schema Registry**: Manages available extensions
- **Industry Standards**: Source of extension schemas

### References
- JSON Schema Specification (Draft 2020-12)
- Semantic Versioning 2.0.0
- JSON Path Specification
- Industry-specific standards (Catena-X, RMI, etc.)# LESS Label Extension

## Aspect Overview

### Aspect Name
**Name**: LESS Label Extension

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
| OverallScore | integer | Yes | Overall LESS score (0-100) | 78 |
| CertificationLevel | string | Yes | LESS certification level | "Gold" |
| AssessmentVersion | string | Yes | Version of LESS methodology used | "LESS-2024-v2.1" |
| VerificationBody | string | Yes | Organization that verified the assessment | "Green Building Council" |
| CertificateId | string | Yes | Unique certificate identifier | "LESS-CERT-2025-GBC-5678" |
| ValidityPeriod | object | Yes | Certificate validity period | {...} |
| CategoryScores | object | Yes | Individual category scores | {...} |
| AssessmentDate | string | Yes | Date of assessment completion | "2025-03-15T00:00:00Z" |
| ProductCategory | string | Yes | Category of assessed product | "Building Materials" |
| ImprovementPotential | number | No | Potential score improvement | 15 |

### Sub-aspects

#### Sub-aspect 1: LESS Scoring System
- **Description**: Core LESS scoring methodology and results
- **Data Elements**:
  - OverallScore (composite score 0-100)
  - CategoryScores (individual category performance)
  - CertificationLevel (Bronze, Silver, Gold, Platinum)
  - ScoringWeights (category importance weights)
  - BenchmarkComparison (industry benchmark position)

#### Sub-aspect 2: Assessment Methodology
- **Description**: Technical details of the LESS assessment process
- **Data Elements**:
  - AssessmentVersion (methodology version)
  - AssessmentScope (system boundaries)
  - DataQuality (input data quality assessment)
  - CalculationMethod (scoring algorithm)
  - AssumptionsLog (key assumptions made)

#### Sub-aspect 3: Certification & Verification
- **Description**: Third-party certification and verification details
- **Data Elements**:
  - VerificationBody (certifying organization)
  - CertificateId (unique certificate reference)
  - ValidityPeriod (certificate validity timeframe)
  - AuditTrail (verification process history)
  - RenewalRequirements (renewal criteria)

## Validation Rules

### Required Validations
- Overall score must be between 0 and 100
- Category scores must be between 0 and 100
- Certification level must match score thresholds
- Certificate validity period must be future-dated
- Verification body must be accredited

### Format Validations
- All scores must be integers
- Date fields must be valid ISO 8601 timestamps
- Certificate ID must follow standard format
- Assessment version must follow semantic versioning
- Product category must be from approved list

### Business Rules
- Gold/Platinum levels require third-party verification
- Certificate validity cannot exceed 3 years
- Score must be consistent with category breakdowns
- Improvement recommendations required for scores below 60
- Annual surveillance required for Platinum level

## Use Cases

### Primary Use Cases
1. **Sustainability Certification**: Providing standardized environmental performance labeling
2. **Procurement Decisions**: Supporting sustainable purchasing decisions
3. **Performance Benchmarking**: Comparing environmental performance across products

### Integration Points
Where does this aspect connect with other parts of the format?
- **Sustainability Metrics**: Base environmental performance data
- **Quality Attributes**: Environmental quality indicators
- **Compliance Data**: Sustainability compliance requirements
- **General Attachment Information**: Supporting assessment reports and certificates

## Implementation Considerations

### Technical Requirements
- Integration with LESS assessment tools and databases
- Support for multiple assessment methodology versions
- Real-time score calculation and validation
- Integration with certification body systems

### Standards Compliance
- LESS Methodology Framework
- ISO 14040/14044 (Life Cycle Assessment)
- EN 15804 (Environmental Product Declarations)
- Regional sustainability standards (EU Taxonomy, etc.)

### Industry Practices
- Follow sector-specific LESS guidelines
- Implement proper data governance for assessment data
- Ensure transparency in scoring methodology
- Support continuous improvement tracking

## JSON Schema Example

```json
{
  "type": "object",
  "properties": {
    "OverallScore": {
      "type": "integer",
      "minimum": 0,
      "maximum": 100,
      "description": "Overall LESS score (0-100)"
    },
    "CertificationLevel": {
      "type": "string",
      "enum": ["Bronze", "Silver", "Gold", "Platinum"],
      "description": "LESS certification level"
    },
    "AssessmentVersion": {
      "type": "string",
      "pattern": "^LESS-\\d{4}-v\\d+\\.\\d+$",
      "description": "Version of LESS methodology used"
    },
    "VerificationBody": {
      "type": "string",
      "minLength": 1,
      "description": "Organization that verified the assessment"
    },
    "CertificateId": {
      "type": "string",
      "pattern": "^LESS-CERT-\\d{4}-[A-Z]{2,5}-\\d+$",
      "description": "Unique certificate identifier"
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
      },
      "required": ["From", "To"]
    },
    "CategoryScores": {
      "type": "object",
      "properties": {
        "Materials": {
          "type": "integer",
          "minimum": 0,
          "maximum": 100,
          "description": "Materials sustainability score"
        },
        "Energy": {
          "type": "integer",
          "minimum": 0,
          "maximum": 100,
          "description": "Energy efficiency score"
        },
        "Water": {
          "type": "integer",
          "minimum": 0,
          "maximum": 100,
          "description": "Water usage efficiency score"
        },
        "Waste": {
          "type": "integer",
          "minimum": 0,
          "maximum": 100,
          "description": "Waste management score"
        },
        "Emissions": {
          "type": "integer",
          "minimum": 0,
          "maximum": 100,
          "description": "Emissions reduction score"
        },
        "Biodiversity": {
          "type": "integer",
          "minimum": 0,
          "maximum": 100,
          "description": "Biodiversity impact score"
        },
        "SocialImpact": {
          "type": "integer",
          "minimum": 0,
          "maximum": 100,
          "description": "Social sustainability score"
        }
      },
      "required": ["Materials", "Energy", "Water", "Waste", "Emissions"]
    },
    "AssessmentDate": {
      "type": "string",
      "format": "date-time",
      "description": "Date of assessment completion"
    },
    "ProductCategory": {
      "type": "string",
      "enum": [
        "Building Materials",
        "Textiles",
        "Electronics",
        "Automotive Components",
        "Packaging",
        "Furniture",
        "Other"
      ],
      "description": "Category of assessed product"
    },
    "ImprovementPotential": {
      "type": "number",
      "minimum": 0,
      "maximum": 100,
      "description": "Potential score improvement"
    },
    "ScoringWeights": {
      "type": "object",
      "properties": {
        "Materials": {"type": "number", "minimum": 0, "maximum": 1},
        "Energy": {"type": "number", "minimum": 0, "maximum": 1},
        "Water": {"type": "number", "minimum": 0, "maximum": 1},
        "Waste": {"type": "number", "minimum": 0, "maximum": 1},
        "Emissions": {"type": "number", "minimum": 0, "maximum": 1},
        "Biodiversity": {"type": "number", "minimum": 0, "maximum": 1},
        "SocialImpact": {"type": "number", "minimum": 0, "maximum": 1}
      }
    },
    "BenchmarkComparison": {
      "type": "object",
      "properties": {
        "IndustryAverage": {
          "type": "integer",
          "minimum": 0,
          "maximum": 100
        },
        "TopPerformer": {
          "type": "integer",
          "minimum": 0,
          "maximum": 100
        },
        "Percentile": {
          "type": "integer",
          "minimum": 0,
          "maximum": 100
        }
      }
    },
    "ImprovementRecommendations": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "Category": {
            "type": "string",
            "enum": ["Materials", "Energy", "Water", "Waste", "Emissions", "Biodiversity", "SocialImpact"]
          },
          "Recommendation": {
            "type": "string",
            "minLength": 1
          },
          "PotentialImpact": {
            "type": "integer",
            "minimum": 1,
            "maximum": 20,
            "description": "Potential score improvement points"
          },
          "ImplementationComplexity": {
            "type": "string",
            "enum": ["low", "medium", "high"]
          }
        },
        "required": ["Category", "Recommendation", "PotentialImpact"]
      }
    }
  },
  "required": [
    "OverallScore",
    "CertificationLevel",
    "AssessmentVersion",
    "VerificationBody",
    "CertificateId",
    "ValidityPeriod",
    "CategoryScores",
    "AssessmentDate",
    "ProductCategory"
  ]
}
```

## Sample Data

```json
{
  "OverallScore": 78,
  "CertificationLevel": "Gold",
  "AssessmentVersion": "LESS-2024-v2.1",
  "VerificationBody": "Green Building Council",
  "CertificateId": "LESS-CERT-2025-GBC-5678",
  "ValidityPeriod": {
    "From": "2025-03-15T00:00:00Z",
    "To": "2027-03-14T23:59:59Z"
  },
  "CategoryScores": {
    "Materials": 82,
    "Energy": 75,
    "Water": 88,
    "Waste": 65,
    "Emissions": 80,
    "Biodiversity": 72,
    "SocialImpact": 85
  },
  "AssessmentDate": "2025-03-15T00:00:00Z",
  "ProductCategory": "Building Materials",
  "ImprovementPotential": 15,
  "ScoringWeights": {
    "Materials": 0.20,
    "Energy": 0.18,
    "Water": 0.12,
    "Waste": 0.15,
    "Emissions": 0.20,
    "Biodiversity": 0.10,
    "SocialImpact": 0.05
  },
  "BenchmarkComparison": {
    "IndustryAverage": 62,
    "TopPerformer": 89,
    "Percentile": 85
  },
  "ImprovementRecommendations": [
    {
      "Category": "Waste",
      "Recommendation": "Implement circular economy principles to reduce waste generation by 25%",
      "PotentialImpact": 8,
      "ImplementationComplexity": "medium"
    },
    {
      "Category": "Energy",
      "Recommendation": "Transition to 100% renewable energy sources for manufacturing",
      "PotentialImpact": 12,
      "ImplementationComplexity": "high"
    },
    {
      "Category": "Biodiversity",
      "Recommendation": "Establish biodiversity offset programs for raw material sourcing",
      "PotentialImpact": 6,
      "ImplementationComplexity": "medium"
    }
  ],
  "AssessmentScope": "cradle-to-gate",
  "DataQuality": "high",
  "NextAssessmentDue": "2026-03-15T00:00:00Z",
  "SurveillanceSchedule": [
    {
      "Date": "2025-09-15T00:00:00Z",
      "Type": "desk-review"
    },
    {
      "Date": "2026-03-15T00:00:00Z",
      "Type": "full-assessment"
    }
  ]
}
```

## Notes

### Implementation Notes
- LESS Label assessments require specialized expertise and tools
- Integration with existing sustainability management systems recommended
- Consider implementing automated data collection from operational systems
- Ensure compliance with regional sustainability disclosure requirements

### Related Aspects
- **Sustainability Metrics**: Base environmental performance framework
- **Quality Attributes**: Environmental quality indicators
- **Compliance Data**: Sustainability compliance requirements
- **PCF Extension**: Carbon footprint component of LESS assessment

### References
- LESS (Lifecycle Environmental Sustainability Score) Methodology
- ISO 14040:2006 - Environmental management — Life cycle assessment
- ISO 14044:2006 - Environmental management — Life cycle assessment
- EN 15804:2012+A2:2019 - Sustainability of construction works
- EU Taxonomy for Sustainable Activities# General Attributes

## Aspect Overview

### Aspect Name
**Name**: General Attributes

### Aspect Category
- [ ] Physical Properties
- [ ] Chemical Properties
- [ ] Delivery Conditions
- [ ] Processing Information
- [ ] Quality Attributes
- [ ] Compliance Data
- [ ] Sustainability Metrics
- [x] Other: **Document Management & Identification**

### Priority
- [x] Core (Required)
- [ ] Standard (Recommended)
- [ ] Extended (Optional)

## Data Structure

### Primary Data Elements
List the main data fields for this aspect:

| Field Name | Data Type | Required | Description | Example |
|------------|-----------|----------|-------------|---------|
| Id | string | Yes | Unique identifier for the passport | "dpp-2025-001234-abc" |
| Version | number | Yes | Version of the passport document | 1 |
| Language | string | No | Primary language of the passport | "en" |

### Sub-aspects

#### Sub-aspect 1: Identification
- **Description**: Unique identification and reference information
- **Data Elements**:
  - Id (unique passport identifier)
  - Language (primary language)

## Validation Rules

- Timestamps must be valid ISO 8601 format with timezone
- Language must be valid ISO 639-1 code

### Business Rules

- 

## Use Cases

### Primary Use Cases
1. **Passport Identification**: Uniquely identifying and referencing digital passports

### Integration Points
Where does this aspect connect with other parts of the format?
- **All Aspects**: General attributes apply to the entire passport document
- **Format Extensions**: Schema version compatibility checking

## Implementation Considerations

### Technical Requirements
- UUID generation for unique identifiers
- Multi-language support infrastructure

### Standards Compliance
- ISO 8601 for timestamps
- ISO 639-1 for language codes
- RFC 4122 for UUID format

### Industry Practices
- Maintain audit trails for all changes
- Support both machine and human-readable formats
- Consider regulatory retention requirements

## JSON Schema Example

```json
{
  "type": "object",
  "properties": {
    "Id": {
      "type": "string",
      "format": "uuid",
      "description": "Unique identifier for the passport (UUID v4)"
    },
    "Version": {
      "type": "number",
      "minimum": 1,
      "description": "Version of the passport"
    },
    "Language": {
      "type": "string",
      "pattern": "^[A-Z]{2}",
      "default": "EN",
      "description": "Primary language using ISO 639-1 code"
    }
  },
  "required": ["Id", "Version", "Language"],
  "additionalProperties": false
}
```

## Sample Data

```json
{
  "Id": "550e8400-e29b-41d4-a716-446655440000",
  "Version": 1,
  "Language": "EN"
}
```

## Notes

### Implementation Notes
- Id generation should be deterministic and meaningful where possible
- Multi-language support may require additional localization fields

### Related Aspects
- **All Aspects**: General attributes apply to the entire passport document
- **Format Extensions**: Schema version compatibility and extension management
- **General Attachment Information**: Version control for attached documents
- **QR Code and Visual Rendering**: Id and Version information in rendered outputs

### References
- ISO 8601:2019 (Date and time format)
- ISO 639-1:2002 (Language codes)
- RFC 4122 (UUID specification)
- Dublin Core Metadata Initiative
- W3C Web Annotation Data Model# Regulatory Markings and Certifications

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
- Various national and regional marking requirementsHere's the updated Measurements FAM based on the Liberty certificate insights:
# Measurements

## Aspect Overview

### Aspect Name

**Name**: Measurements

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

| Field Name         | Data Type | Required | Description                                    | Example               |
| ------------------ | --------- | -------- | ---------------------------------------------- | --------------------- |
| PropertySymbol     | string    | Yes      | Standardized technical symbol for the property | "Rm", "HV", "C"       |
| PropertyName       | string    | No       | Human-readable name in specified language      | "Tensile Strength"    |
| PropertyId         | string    | No       | Identifier from standard catalog               | "1039"                |
| Unit               | string    | Yes      | Unit of measurement                            | "MPa", "%", "HV"      |
| Method             | string    | No       | Testing method or standard used                | "EN ISO 6892-1"       |
| TestConditions     | string    | No       | Conditions under which test was performed      | "23°C, 50% RH"        |
| PropertiesStandard | string    | No       | Reference to standard catalog                  | "CAMPUS", "ISO 80000" |
| Formula            | string    | No       | For calculated values                          | "C+Mn/6+(Cr+Mo+V)/5"  |
| ResultType         | enum      | Yes      | Type of result data structure                  | "numeric", "boolean"  |
| Result             | object    | Yes      | Measured result with constraints               | See Result types      |
| Grade              | string    | No       | Grade or class classification                  | "A", "B", "Pass"      |
| SampleLocation     | string    | No       | Location where sample was taken                | "Centre", "Mid-Radial"|
| SampleIdentifier   | string    | No       | Unique identifier for the test specimen        | "3749168"             |
| TestGroupId        | string    | No       | Identifier to group related measurements       | "MECH-001"            |

### Sub-aspects

Break down into specific components:

#### Sub-aspect 1: Result Types

- **Description**: Different types of measurement results with inline constraints
- **Data Elements**:
  - NumericResult (single values with operator, min/max/target)
  - BooleanResult (pass/fail with expected)
  - StringResult (text with allowed values)
  - RangeResult (min-max ranges)
  - ArrayResult (multiple values at parameters with operator support)

#### Sub-aspect 2: Numeric Precision and Operators

- **Description**: Handling significant figures, decimal places, and comparison operators
- **Data Elements**:
  - DecimalPlaces (integer)
  - Operator (enum: "=", "<", "≤", ">", "≥")
  - RoundingStandard (string)
  - RoundingContext (enum)

#### Sub-aspect 3: Statistical Data

- **Description**: Individual measurements and statistics
- **Data Elements**:
  - IndividualValues (array)
  - IndividualIdentifiers (array) - specimen IDs for each value
  - Statistics.Average (number)
  - Statistics.StandardDeviation (number)
  - Statistics.Range (number)
  - Statistics.Count (integer)

#### Sub-aspect 4: Test Groups

- **Description**: Grouping of related measurements under common test conditions
- **Data Elements**:
  - TestGroupId (string)
  - TestGroupName (string)
  - CommonTestConditions (string)
  - TestGroupStandard (string)

#### Sub-aspect 5: Sample Metadata

- **Description**: Enhanced sample location and identification
- **Data Elements**:
  - SampleLocation (string) - physical location
  - SampleIdentifier (string) - unique ID
  - SampleOrientation (string) - T/L/S, Top/Bottom
  - SampleDepth (number) - depth from surface

## Validation Rules

### Required Validations

- PropertySymbol and Unit are always required
- Actual must contain a valid Result object
- Result.Value must be present
- For arrays: Values.length must equal Parameters.length
- If Operator is present, validate accordingly (e.g., "<" means actual value is less than stated)
- If IndividualValues present, IndividualIdentifiers length must match

### Format Validations

- PropertySymbol must match standard notation (e.g., "Rm", "Re", "A")
- Unit must be valid SI or accepted industry unit
- Method should reference recognized standard
- Numeric values must respect DecimalPlaces when rendered
- Operator must be from allowed set: "=", "<", "≤", ">", "≥"
- Grade should follow standard classifications when applicable

### Business Rules

- If Minimum/Maximum present, validate Value against constraints
- For ExclusiveMinimum/Maximum, use exclusive comparison
- When Operator is "<", value represents upper detection/reporting limit
- BooleanResult comparison with Expected determines pass/fail
- StringResult must match AllowedValues if specified
- Interpretation should align with validation results
- TestGroupId should be consistent across related measurements

## Use Cases

### Primary Use Cases

1. **Material Testing**: Tensile tests, hardness tests, impact tests
2. **Chemical Analysis**: Composition percentages with max limits, trace elements with detection limits
3. **Quality Control**: Multi-point measurements (Jominy curves)
4. **Compliance Verification**: Pass/fail criteria for specifications
5. **Statistical Process Control**: Individual values with statistics
6. **Trace Analysis**: Values below detection limits (e.g., "<2 ppm")
7. **Test Grouping**: Related tests under common conditions
8. **Multi-Specimen Testing**: Track individual test specimens

### Integration Points

Where does this aspect connect with other parts of the format?

- **Product Identification**: Links measurements to specific batch/heat
- **Standards Compliance**: References testing standards and specifications
- **Certificates**: Core data for test certificates (CoA, 3.1, etc.)
- **Traceability**: Connects to test equipment and operators
- **Test Groups**: Links related measurements together
- **Sample Management**: Tracks specimen chain of custody

## Implementation Considerations

### Technical Requirements

- Support for multiple result types (numeric, boolean, string, range, array)
- Preservation of significant figures through DecimalPlaces
- Support for comparison operators ("<", "≤", etc.)
- Validation engine for min/max constraints
- Rendering logic for proper decimal display and operators
- Statistical calculations for grouped measurements
- Test grouping mechanism for related measurements
- Enhanced sample tracking capabilities

### Standards Compliance

- ASTM E29 for rounding practices
- ISO 80000 for quantities and units
- EN 10204 for certificate types
- Industry-specific testing standards (ASTM, ISO, EN, DIN)
- Laboratory reporting standards for detection limits
- ISO/IEC 17025 for testing competence

### Industry Practices

- Hardness tests report individual values plus average
- Chemical composition uses minimum and maximum limits
- Trace elements often reported as "less than" values
- Mechanical properties use minimum and maximum requirements
- Jominy tests use distance-based array data
- Different decimal places for different properties
- Test specimens tracked individually
- Related tests grouped under common conditions

## JSON Schema Example

```json
{
  "type": "object",
  "properties": {
    "Measurement": {
      "type": "object",
      "properties": {
        "PropertySymbol": {
          "type": "string",
          "pattern": "^[A-Za-z][A-Za-z0-9_-]*$"
        },
        "PropertyName": {
          "type": "string"
        },
        "PropertyId": {
          "type": "string"
        },
        "Unit": {
          "type": "string"
        },
        "Method": {
          "type": "string"
        },
        "TestConditions": {
          "type": "string"
        },
        "PropertiesStandard": {
          "type": "string"
        },
        "Formula": {
          "type": "string"
        },
        "Grade": {
          "type": "string",
          "examples": ["A", "B", "C", "Pass", "Fail", "Class 1", "Class 2"]
        },
        "SampleLocation": {
          "type": "string",
          "examples": ["Centre", "Mid-Radial", "Surface", "1/4 thickness"]
        },
        "SampleIdentifier": {
          "type": "string"
        },
        "TestGroupId": {
          "type": "string"
        },
        "ResultType": {
          "type": "string",
          "enum": ["numeric", "boolean", "string", "range", "array"]
        },
        "Result": {
          "oneOf": [
            { "$ref": "#/$defs/NumericResult" },
            { "$ref": "#/$defs/BooleanResult" },
            { "$ref": "#/$defs/StringResult" },
            { "$ref": "#/$defs/RangeResult" },
            { "$ref": "#/$defs/ArrayResult" }
          ]
        }
      },
      "required": ["PropertySymbol", "Unit", "ResultType", "Result"],
      "additionalProperties": false
    },
    "NumericResult": {
      "type": "object",
      "properties": {
        "Value": { "type": "number" },
        "Operator": {
          "type": "string",
          "enum": ["=", "<", "≤", ">", "≥"],
          "default": "=",
          "description": "Comparison operator for the value"
        },
        "DecimalPlaces": { "type": "integer", "minimum": 0 },
        "Minimum": { "type": "number" },
        "Maximum": { "type": "number" },
        "ExclusiveMinimum": { "type": "number" },
        "ExclusiveMaximum": { "type": "number" },
        "Target": { "type": "number" },
        "IndividualValues": {
          "type": "array",
          "items": { "type": "number" }
        },
        "IndividualIdentifiers": {
          "type": "array",
          "items": { "type": "string" },
          "description": "Specimen identifiers corresponding to IndividualValues"
        },
        "Statistics": {
          "type": "object",
          "properties": {
            "Average": { "type": "number" },
            "StandardDeviation": { "type": "number" },
            "Range": { "type": "number" },
            "Count": { "type": "integer" }
          }
        },
        "Interpretation": {
          "type": "string",
          "enum": [
            "In Specification",
            "Out of Specification",
            "Conditionally Acceptable",
            "Not Evaluated"
          ]
        }
      },
      "required": ["Value"]
    },
    "ArrayResult": {
      "type": "object",
      "properties": {
        "ParameterName": { "type": "string" },
        "ParameterUnit": { "type": "string" },
        "ValueName": { "type": "string" },
        "ValueUnit": { "type": "string" },
        "DecimalPlaces": { "type": "integer", "minimum": 0 },
        
        "Data": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "Parameter": { 
                "oneOf": [
                  { "type": "string" },
                  { "type": "number" }
                ]
              },
              "Value": { "type": "number" },
              "StringValue": { "type": "string" },
              "Operator": {
                "type": "string",
                "enum": ["=", "<", "≤", ">", "≥"],
                "default": "="
              },
              "Minimum": { "type": "number" },
              "Maximum": { "type": "number" },
              "Target": { "type": "number" },
              "Status": {
                "type": "string",
                "enum": ["Pass", "Fail", "Warning", "Info"]
              },
              "AdditionalValues": {
                "type": "object",
                "description": "For tests with multiple values per parameter"
              }
            },
            "required": ["Parameter"],
            "oneOf": [
              { "required": ["Value"] },
              { "required": ["StringValue"] }
            ]
          }
        },
        
        "Statistics": {
          "type": "object",
          "properties": {
            "Mean": { "type": "number" },
            "StandardDeviation": { "type": "number" },
            "Range": { "type": "number" },
            "Minimum": { "type": "number" },
            "Maximum": { "type": "number" },
            "Count": { "type": "integer" },
            "CoefficientOfVariation": { "type": "number" }
          }
        },
        
        "CurveFit": {
          "type": "object",
          "properties": {
            "Equation": { "type": "string" },
            "FitType": {
              "type": "string",
              "enum": ["Linear", "Polynomial", "Power", "Exponential", "Logarithmic", "Custom"]
            },
            "Coefficients": { "type": "object" },
            "R2": { "type": "number", "minimum": 0, "maximum": 1 },
            "RMSE": { "type": "number" }
          }
        },
        
        "SpecificationBand": {
          "type": "object",
          "properties": {
            "UpperCurve": {
              "type": "array",
              "items": {
                "type": "array",
                "items": { "type": "number" },
                "minItems": 2,
                "maxItems": 2
              }
            },
            "LowerCurve": {
              "type": "array",
              "items": {
                "type": "array",
                "items": { "type": "number" },
                "minItems": 2,
                "maxItems": 2
              }
            },
            "Standard": { "type": "string" },
            "Grade": { "type": "string" }
          }
        },
        
        "DerivedResults": {
          "type": "object",
          "description": "Test-specific calculated values",
          "additionalProperties": {
            "type": "object",
            "properties": {
              "Value": { 
                "oneOf": [
                  { "type": "number" },
                  { "type": "string" }
                ]
              },
              "Unit": { "type": "string" },
              "Description": { "type": "string" }
            }
          }
        },
        
        "TestConditions": {
          "type": "object",
          "description": "Test-specific parameters and conditions",
          "additionalProperties": true
        },
        
        "GraphConfiguration": {
          "type": "object",
          "properties": {
            "GraphType": {
              "type": "string",
              "enum": ["XY-Curve", "Bar", "Scatter", "HeatMap"]
            },
            "XAxisLabel": { "type": "string" },
            "YAxisLabel": { "type": "string" },
            "XAxisScale": {
              "type": "string",
              "enum": ["Linear", "Logarithmic"]
            },
            "YAxisScale": {
              "type": "string",
              "enum": ["Linear", "Logarithmic"]
            },
            "ShowSpecificationBand": { "type": "boolean" },
            "ShowCurveFit": { "type": "boolean" }
          }
        },
        
        "Interpretation": {
          "type": "string"
        },
        
        "OverallStatus": {
          "type": "string",
          "enum": [
            "In Specification",
            "Out of Specification",
            "Conditionally Acceptable",
            "Not Evaluated"
          ]
        }
      },
      
      "required": ["ParameterName", "Data"]
    },
    "BooleanResult": {
      "type": "object",
      "properties": {
        "Value": { "type": "boolean" },
        "Expected": { "type": "boolean" },
        "PassCriteria": {
          "type": "string",
          "description": "Description of what constitutes a pass"
        },
        "Interpretation": {
          "type": "string",
          "enum": [
            "In Specification",
            "Out of Specification",
            "Conditionally Acceptable",
            "Not Evaluated"
          ]
        }
      },
      "required": ["Value"]
    },
    "StringResult": {
      "type": "object",
      "properties": {
        "Value": { "type": "string" },
        "Interpretation": {
          "type": "string",
          "enum": [
            "In Specification",
            "Out of Specification",
            "Conditionally Acceptable",
            "Not Evaluated"
          ]
        }
      },
      "required": ["Value"]
    },
    "RangeResult": {
      "type": "object",
      "properties": {
        "MinValue": { "type": "number" },
        "MaxValue": { "type": "number" },
        "Unit": { "type": "string" },
        "DecimalPlaces": { "type": "integer", "minimum": 0 },
        "TargetMin": { "type": "number" },
        "TargetMax": { "type": "number" },
        "ToleranceMin": { "type": "number" },
        "ToleranceMax": { "type": "number" },
        "Interpretation": {
          "type": "string",
          "enum": [
            "In Specification",
            "Out of Specification",
            "Conditionally Acceptable",
            "Not Evaluated"
          ]
        }
      },
      "required": ["MinValue", "MaxValue"]
    }
  }
}
```

## Sample Data

```json
{
  "Measurements": [
    {
      "PropertySymbol": "Rm",
      "PropertyName": "Tensile Strength",
      "Unit": "MPa",
      "Method": "ASTM E8-16a",
      "TestGroupId": "MECH-001",
      "SampleLocation": "Centre",
      "SampleIdentifier": "3758176",
      "ResultType": "numeric",
      "Result": {
        "Value": 245.0,
        "Operator": "=",
        "DecimalPlaces": 1,
        "Minimum": 235,
        "IndividualValues": [243.0, 244.0, 248.0],
        "IndividualIdentifiers": ["3758180", "3758181", "3758182"],
        "Statistics": {
          "Average": 245.0,
          "Range": 5.0,
          "Count": 3
        },
        "Interpretation": "In Specification"
      },
      "Grade": "B"
    },
    {
      "PropertySymbol": "HRC-J",
      "PropertyName": "Jominy Hardenability",
      "Unit": "HRc",
      "Method": "ASTM A255-10",
      "TestConditions": "927C for 01:00hr Air Cool in 35mm Dia",
      "ResultType": "array",
      "Result": {
        "ParameterName": "Distance from quenched end",
        "ParameterUnit": "16ths inch",
        "ValueName": "Hardness",
        "ValueUnit": "HRc",
        "DecimalPlaces": 1,
        "Data": [
          {
            "Parameter": 0.5,
            "Value": 57.5,
            "Minimum": 55,
            "Maximum": 60,
            "Status": "Pass"
          },
          {
            "Parameter": 1.25,
            "Value": 57.0,
            "Minimum": 50,
            "Maximum": 58,
            "Status": "Pass"
          },
          {
            "Parameter": 2.0,
            "Value": 45.2,
            "Minimum": 40,
            "Maximum": 50,
            "Status": "Pass"
          }
        ],
        "Statistics": {
          "Mean": 53.2,
          "StandardDeviation": 6.8,
          "Range": 12.3,
          "Minimum": 45.2,
          "Maximum": 57.5,
          "Count": 3
        },
        "CurveFit": {
          "Equation": "y = 58.1 * exp(-0.32 * x)",
          "FitType": "Exponential",
          "Coefficients": {
            "a": 58.1,
            "b": -0.32
          },
          "R2": 0.97,
          "RMSE": 1.2
        },
        "GraphConfiguration": {
          "GraphType": "XY-Curve",
          "XAxisLabel": "Distance from quenched end (inches)",
          "YAxisLabel": "Hardness (HRc)",
          "XAxisScale": "Linear",
          "YAxisScale": "Linear",
          "ShowSpecificationBand": true,
          "ShowCurveFit": true
        },
        "Interpretation": "Hardenability curve follows expected exponential decay pattern",
        "OverallStatus": "In Specification"
      }
    },
    {
      "PropertySymbol": "MagTest",
      "PropertyName": "Magnetic Particle Test",
      "Unit": "Pass/Fail",
      "Method": "ASTM E709",
      "TestGroupId": "NDT-001",
      "ResultType": "boolean",
      "Result": {
        "Value": true,
        "Expected": true,
        "PassCriteria": "No linear indications greater than 1.6mm",
        "Interpretation": "In Specification"
      }
    },
    {
      "PropertySymbol": "HeatTreat",
      "PropertyName": "Heat Treatment Condition",
      "Unit": "Condition",
      "Method": "Company Standard",
      "TestGroupId": "PROC-001",
      "ResultType": "string",
      "Result": {
        "Value": "Normalized",
        "Interpretation": "In Specification"
      }
    },
    {
      "PropertySymbol": "Remarks",
      "PropertyName": "Inspection Remarks",
      "Unit": "Text",
      "Method": "Visual Inspection",
      "TestGroupId": "INSP-001",
      "ResultType": "string",
      "Result": {
        "Value": "Minor surface oxidation observed on edges, within acceptable limits",
        "Interpretation": "In Specification"
      }
    },
    {
      "PropertySymbol": "TempRange",
      "PropertyName": "Operating Temperature Range",
      "Unit": "°C",
      "Method": "Design Specification",
      "TestGroupId": "DESIGN-001",
      "ResultType": "range",
      "Result": {
        "MinValue": -40,
        "MaxValue": 200,
        "Unit": "°C",
        "DecimalPlaces": 0,
        "TargetMin": -20,
        "TargetMax": 150,
        "ToleranceMin": -45,
        "ToleranceMax": 220,
        "Interpretation": "In Specification"
      }
    }
  ]
}
```

## Notes

### Implementation Notes

- DecimalPlaces determines display format, not storage precision
- Validation occurs on numeric values, not string representations
- Support localization of decimal separators at rendering time
- Support for visualization of exclusiveMinimum and exclusiveMaximum
- Operator field enables proper rendering of "less than" values common in trace analysis
- When Operator is "<", the Value represents the detection or reporting limit
- TestGroupId enables linking related measurements
- IndividualIdentifiers track specific test specimens
- Grade field supports various classification systems

### Related Aspects

- Product Identification (links measurements to products)
- Equipment Calibration (measurement uncertainty)
- Personnel Qualification (who performed tests)
- Environmental Conditions (ambient test conditions)
- Laboratory Information (detection limits, methods)
- Test Groups (related measurements under common conditions)
- Sample Management (specimen tracking and chain of custody)

### References

- ASTM E29-22: Standard Practice for Using Significant Digits
- ISO/IEC 17025: Testing and Calibration Laboratories
- EN 10204: Types of Inspection Documents
- ISO 80000-1: Quantities and Units
- ASTM E1019: Standard Test Methods for Determination of Carbon, Sulfur, Nitrogen, and Oxygen in Steel
- ASTM E8: Standard Test Methods for Tension Testing of Metallic Materials
- ASTM A255: Standard Test Methods for Determining Hardenability of Steel# Mechanical Properties

## Aspect Overview

### Aspect Name

**Name**: Mechanical Properties

### Aspect Category

- [x] Physical Properties
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
| TestGroupId | string | Yes | Unique identifier for the test group | "MECH-001" |
| TestGroupName | string | No | Descriptive name for the test group | "Tensile Properties" |
| TestStandard | string | Yes | Primary test standard | "ASTM E8-16a" |
| SampleHeatTreatment | object | No | Heat treatment applied to test samples | See sub-aspect |
| TestTemperature | number | No | Temperature at which tests were performed | 23 |
| TestTemperatureUnit | string | No | Unit for test temperature | "°C" |
| TestEnvironment | string | No | Environment conditions | "Air", "Vacuum" |
| Properties | array[Measurement] | Yes | Individual mechanical property measurements | See Measurements FAM |

### Sub-aspects

Break down into specific components:

#### Sub-aspect 1: Tensile Properties

- **Description**: Properties derived from tensile testing
- **Common Properties**:
  - UTS/Rm: Ultimate Tensile Strength
  - YS/Re/Rp0.2: Yield Strength (0.2% offset)
  - Elongation/A: Percentage elongation
  - R of A/Z: Reduction of area
  - E: Modulus of elasticity
  - n: Strain hardening exponent
  - Proportional Limit
  - Fracture Position (when applicable)

#### Sub-aspect 2: Impact Properties

- **Description**: Properties from impact testing (Charpy, Izod)
- **Common Properties**:
  - KV/CVN: Charpy V-notch impact energy
  - KU: Charpy U-notch impact energy
  - Lateral Expansion
  - Shear Fracture Percentage
  - DBTT: Ductile-Brittle Transition Temperature
  - Test Geometry (specimen dimensions)

#### Sub-aspect 3: Hardness Properties

- **Description**: Various hardness measurements
- **Common Types**:
  - HB/HBW: Brinell hardness
  - HV: Vickers hardness (HV1, HV10, HV30)
  - HRC/HRB/HRA: Rockwell hardness scales
  - HK: Knoop hardness
  - Shore hardness
  - Conversion between scales

#### Sub-aspect 4: Sample Heat Treatment

- **Description**: Heat treatment applied to test specimens
- **Data Elements**:
  - Process: String - Treatment process name
  - Temperature: Number - Process temperature
  - TemperatureUnit: String - Temperature unit
  - Duration: String - Time duration
  - CoolingMethod: String - Cooling method
  - Sequence: Array - Multiple step processes

#### Sub-aspect 5: Fracture Mechanics

- **Description**: Fracture toughness and related properties
- **Common Properties**:
  - KIC: Plane strain fracture toughness
  - JIC: J-integral at crack initiation
  - CTOD: Crack tip opening displacement
  - Fatigue crack growth rate (da/dN)
  - Threshold stress intensity (ΔKth)

## Validation Rules

### Required Validations

- TestGroupId must be unique within the document
- TestStandard must be a recognized standard
- All Properties must follow Measurement schema
- Temperature values must be reasonable for material type
- Linked measurements should have same TestGroupId

### Format Validations

- TestStandard format: organization + number + year (e.g., "ASTM E8-16a")
- Temperature units must be °C, °F, or K
- Duration format should be clear (e.g., "01:00hr", "60min", "3600s")
- Property symbols must match standard notation

### Business Rules

- Tensile properties typically reported together
- Impact tests usually at specific temperatures
- Hardness conversions only valid within ranges
- Heat treatment affects all mechanical properties
- Multiple specimens typical for statistical validity
- Fracture position relevant for acceptance criteria

## Use Cases

### Primary Use Cases

1. **Material Certification**: Verify mechanical properties meet specifications
2. **Design Data**: Provide engineering design allowables
3. **Quality Control**: Batch release testing
4. **Failure Analysis**: Compare properties to requirements
5. **Material Selection**: Choose materials based on properties
6. **Heat Treatment Validation**: Verify treatment effectiveness
7. **Statistical Analysis**: Process capability studies

### Integration Points

Where does this aspect connect with other parts of the format?

- **Chemical Analysis**: Composition affects mechanical properties
- **Product**: Links to specific product forms and sizes
- **Heat Treatment**: Processing history affects properties
- **Standards Compliance**: Properties must meet specifications
- **Measurements**: Uses measurement schema for values
- **Sample Management**: Specimen preparation and identification

## Implementation Considerations

### Technical Requirements

- Group related properties under common test conditions
- Support for multiple test temperatures
- Handle both individual and average values
- Support various specimen geometries
- Enable statistical analysis of results
- Track heat treatment of samples

### Standards Compliance

- ASTM E8/E8M: Tension Testing of Metallic Materials
- ISO 6892: Metallic materials - Tensile testing
- ASTM E23: Notched Bar Impact Testing
- ISO 148: Metallic materials - Charpy impact test
- ASTM E18: Rockwell Hardness
- ISO 6506: Brinell hardness
- ASTM E399: Fracture Toughness Testing

### Industry Practices

- Report average and individual values
- Specify test temperature for impact tests
- Include sample heat treatment
- Report fracture location for tensile tests
- Multiple hardness scales common
- Room temperature assumed if not specified
- Specimen orientation affects properties

## JSON Schema Example

```json
{
  "type": "object",
  "properties": {
    "MechanicalProperties": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "TestGroupId": {
            "type": "string",
            "description": "Unique identifier for this test group"
          },
          "TestGroupName": {
            "type": "string",
            "enum": [
              "Tensile Properties",
              "Impact Properties",
              "Hardness Testing",
              "Fracture Toughness",
              "Fatigue Properties"
            ]
          },
          "TestStandard": {
            "type": "string"
          },
          "SampleHeatTreatment": {
            "type": "object",
            "properties": {
              "Description": { "type": "string" },
              "Steps": {
                "type": "array",
                "items": {
                  "type": "object",
                  "properties": {
                    "Process": {
                      "type": "string",
                      "enum": ["Normalise", "Harden", "Temper", "Anneal", "Quench", "Age"]
                    },
                    "Temperature": { "type": "number" },
                    "TemperatureUnit": { "type": "string", "enum": ["°C", "°F", "K"] },
                    "Duration": { "type": "string" },
                    "CoolingMethod": {
                      "type": "string",
                      "enum": ["Air Cool", "Oil Quench", "Water Quench", "Furnace Cool"]
                    }
                  }
                }
              }
            }
          },
          "TestTemperature": { "type": "number" },
          "TestTemperatureUnit": { 
            "type": "string", 
            "enum": ["°C", "°F", "K"],
            "default": "°C"
          },
          "TestEnvironment": {
            "type": "string",
            "enum": ["Air", "Vacuum", "Inert Gas", "Corrosive"]
          },
          "Properties": {
            "type": "array",
            "items": { "$ref": "#/$defs/Measurement" }
          }
        },
        "required": ["TestGroupId", "TestStandard", "Properties"]
      }
    }
  }
}
```

## Sample Data

```json
{
  "MechanicalProperties": [
    {
      "TestGroupId": "MECH-001",
      "TestGroupName": "Tensile Properties",
      "TestStandard": "ASTM E8-16a",
      "SampleHeatTreatment": {
        "Description": "Standard heat treatment per specification",
        "Steps": [
          {
            "Process": "Normalise",
            "Temperature": 927,
            "TemperatureUnit": "°C",
            "Duration": "01:00hr",
            "CoolingMethod": "Air Cool"
          },
          {
            "Process": "Harden",
            "Temperature": 871,
            "TemperatureUnit": "°C",
            "Duration": "01:00hr",
            "CoolingMethod": "Oil Quench"
          },
          {
            "Process": "Temper",
            "Temperature": 302,
            "TemperatureUnit": "°C",
            "Duration": "02:00hr",
            "CoolingMethod": "Air Cool"
          }
        ]
      },
      "TestTemperature": 23,
      "TestTemperatureUnit": "°C",
      "Properties": [
        {
          "PropertySymbol": "Rm",
          "PropertyName": "Ultimate Tensile Strength",
          "Unit": "MPa",
          "Method": "ASTM E8-16a",
          "SampleLocation": "Centre",
          "SampleIdentifier": "3758176",
          "ResultType": "numeric",
          "Result": {
            "Value": 245.0,
            "DecimalPlaces": 1,
            "Minimum": 235,
            "IndividualValues": [243.0, 244.0, 248.0],
            "IndividualIdentifiers": ["3758180", "3758181", "3758182"],
            "Interpretation": "In Specification"
          },
          "Grade": "B"
        },
        {
          "PropertySymbol": "Rp0.2",
          "PropertyName": "0.2% Yield Strength",
          "Unit": "MPa",
          "ResultType": "numeric",
          "Result": {
            "Value": 290.0,
            "DecimalPlaces": 1,
            "Minimum": 280,
            "Interpretation": "In Specification"
          }
        },
        {
          "PropertySymbol": "A",
          "PropertyName": "Elongation",
          "Unit": "%",
          "ResultType": "numeric",
          "Result": {
            "Value": 42.0,
            "DecimalPlaces": 1,
            "Minimum": 38.0,
            "Interpretation": "In Specification"
          }
        },
        {
          "PropertySymbol": "Z",
          "PropertyName": "Reduction of Area",
          "Unit": "%",
          "ResultType": "numeric",
          "Result": {
            "Value": 11.0,
            "DecimalPlaces": 1,
            "Minimum": 10.5,
            "Interpretation": "In Specification"
          }
        }
      ]
    },
    {
      "TestGroupId": "MECH-002",
      "TestGroupName": "Impact Properties",
      "TestStandard": "BS EN ISO 148-1:2016 Ed 3",
      "TestTemperature": -40,
      "TestTemperatureUnit": "°C",
      "Properties": [
        {
          "PropertySymbol": "KV",
          "PropertyName": "Charpy V-Notch Impact Energy",
          "Unit": "J",
          "TestConditions": "Striker Radius: 8mm",
          "ResultType": "numeric",
          "Result": {
            "Value": 29,
            "DecimalPlaces": 0,
            "Minimum": 27,
            "IndividualValues": [29, 28, 30],
            "IndividualIdentifiers": ["3749140", "3777126", null],
            "Interpretation": "In Specification"
          }
        }
      ]
    },
    {
      "TestGroupId": "MECH-003",
      "TestGroupName": "Hardness Testing",
      "TestStandard": "ASTM E10-18",
      "Properties": [
        {
          "PropertySymbol": "HBW10/3000",
          "PropertyName": "Brinell Hardness",
          "Unit": "HBW",
          "SampleLocation": "Surface",
          "SampleIdentifier": "3749176",
          "ResultType": "numeric",
          "Result": {
            "Value": 293,
            "DecimalPlaces": 0,
            "Minimum": 280,
            "Maximum": 320,
            "Interpretation": "In Specification"
          }
        }
      ]
    }
  ]
}
```

## Notes

### Implementation Notes

- Group all properties tested under same conditions
- Heat treatment critical for mechanical properties
- Support multiple test temperatures (especially impact)
- Individual specimen tracking important
- Fracture position may determine acceptance
- Consider specimen orientation effects
- Statistical analysis often required

### Related Aspects

- Chemical Analysis (composition affects properties)
- Heat Treatment (processing determines properties)
- Product Form (size effects on properties)
- Standards Compliance (property requirements)
- Sampling (specimen location matters)
- Test Equipment (calibration critical)

### References

- ASTM E8/E8M: Standard Test Methods for Tension Testing
- ISO 6892-1: Metallic materials - Tensile testing at room temperature
- ASTM E23: Standard Test Methods for Notched Bar Impact Testing
- ISO 148-1: Metallic materials - Charpy pendulum impact test
- ASTM E18: Standard Test Methods for Rockwell Hardness
- ASTM E10: Standard Test Method for Brinell Hardness
- ASTM E399: Standard Test Method for Linear-Elastic Fracture Toughness# Metallography

## Aspect Overview

### Aspect Name

**Name**: Metallography

### Aspect Category

- [x] Physical Properties
- [ ] Chemical Properties
- [ ] Delivery Conditions
- [ ] Processing Information
- [x] Quality Attributes
- [x] Compliance Data
- [ ] Sustainability Metrics
- [ ] Other: ****\_\_\_****

### Priority

- [ ] Core (Required)
- [x] Standard (Recommended)
- [ ] Extended (Optional)

## Data Structure

### Primary Data Elements

List the main data fields for this aspect:

| Field Name | Data Type | Required | Description | Example |
|------------|-----------|----------|-------------|---------|
| ExaminationId | string | Yes | Unique identifier for the metallographic examination | "METALLO-001" |
| ExaminationName | string | No | Descriptive name for the examination | "Microstructure Analysis" |
| Standard | string | Yes | Primary examination standard | "ASTM E3-11" |
| SamplePreparation | object | No | Sample preparation details | See sub-aspect |
| EtchingDetails | object | No | Etching method and conditions | See sub-aspect |
| Magnifications | array[number] | No | Magnification levels used | [100, 500, 1000] |
| Examiner | string | No | Name/ID of examiner | "Dr. Smith" |
| ExaminationDate | date | No | Date of examination | "2024-03-15" |
| Measurements | array[Measurement] | Yes | Individual metallographic measurements | See Measurements FAM |

### Sub-aspects

Break down into specific components:

#### Sub-aspect 1: Microstructure Analysis

- **Description**: Identification and quantification of phases and constituents
- **Common Measurements**:
  - Phase Content: Volume fraction of phases (ferrite, pearlite, bainite, martensite)
  - Grain Size: ASTM grain size number or linear intercept
  - Grain Shape: Aspect ratio, elongation factor
  - Phase Distribution: Homogeneity, banding assessment
  - Matrix Structure: Primary phase characteristics
  - Second Phase Particles: Size, distribution, morphology

#### Sub-aspect 2: Quantitative Metallography

- **Description**: Statistical measurements using stereological principles
- **Common Measurements**:
  - Volume Fraction: Percentage of phases/constituents
  - Number Density: Particles per unit area
  - Mean Free Path: Average distance between particles
  - Spacing Measurements: Interparticle, interlamellar spacing
  - Size Distribution: Statistical grain/particle size data
  - Connectivity: Phase connectivity measurements

#### Sub-aspect 3: Crystallographic Analysis

- **Description**: Texture and orientation measurements
- **Common Measurements**:
  - Texture Coefficients: Crystallographic texture intensity
  - Orientation Distribution: Pole figures, ODF data
  - Preferred Orientation: Texture strength and components
  - Grain Boundary Character: Coincidence site lattice boundaries
  - Misorientation: Angular relationships between grains

#### Sub-aspect 4: Sample Preparation

- **Description**: Metallographic sample preparation details
- **Data Elements**:
  - SectionOrientation: String - Sample sectioning plane
  - MountingMethod: String - Mounting material and method
  - GrindingSequence: Array - Grit sequence used
  - PolishingSteps: Array - Polishing compounds and times
  - PreparationTime: String - Total preparation time
  - AutomatedPrep: Boolean - Whether automated preparation used

#### Sub-aspect 5: Etching Details

- **Description**: Chemical etching parameters
- **Data Elements**:
  - EtchantType: String - Chemical etchant composition
  - EtchingMethod: String - Immersion, swabbing, electrolytic
  - EtchingTime: String - Duration of etching
  - Temperature: Number - Etching temperature
  - Voltage: Number - For electrolytic etching
  - PostEtchTreatment: String - Cleaning or neutralization

#### Sub-aspect 6: Image Analysis

- **Description**: Digital image analysis parameters and results
- **Data Elements**:
  - ImageResolution: String - Pixel resolution
  - AnalysisSoftware: String - Software used for analysis
  - ThresholdingMethod: String - Segmentation approach
  - CalibrationStandard: String - Length calibration reference
  - StatisticalSampling: Object - Sampling strategy and field count
  - QualityMetrics: Object - Image quality assessments

## Validation Rules

### Required Validations

- ExaminationId is always required
- At least one Measurement must be present in Measurements array
- Standard must reference recognized metallographic standard
- Magnifications should be reasonable values (10x to 50000x)
- If etching is performed, EtchingDetails should be provided
- Volume fractions should sum to ≤ 100% when measuring phases

### Format Validations

- ExaminationId must be alphanumeric with allowed separators
- ExaminationDate must be valid date format
- Magnifications must be positive integers
- Temperature values must include units when specified
- EtchingTime must follow duration format (e.g., "30s", "2min")
- Phase symbols must use standard metallographic notation

### Business Rules

- Primary phases (ferrite, austenite, etc.) typically have higher volume fractions
- Grain size measurements should specify linear intercept or planimetric method
- Texture measurements require specific sample orientations
- Image analysis results should include statistical confidence measures
- Multiple fields should be examined for statistical validity
- Etching should be appropriate for the material system

## Use Cases

### Primary Use Cases

1. **Quality Control**: Verify microstructure meets specifications
2. **Failure Analysis**: Investigate microstructural causes of failure
3. **Process Development**: Optimize heat treatment and processing
4. **Material Characterization**: Document microstructural features
5. **Research & Development**: Study phase transformations and properties
6. **Compliance Verification**: Meet industry standards and specifications
7. **Comparative Analysis**: Compare microstructures across batches
8. **Texture Analysis**: Assess forming behavior and anisotropy

### Integration Points

Where does this aspect connect with other parts of the format?

- **Chemical Analysis**: Composition affects phase formation
- **Heat Treatment**: Processing determines microstructure
- **Mechanical Properties**: Microstructure controls properties
- **Physical Properties**: Structure affects physical behavior
- **Quality Attributes**: Microstructure indicates quality
- **Test Specimens**: Links to physical sample identification
- **Standards Compliance**: Meets metallographic requirements

## Implementation Considerations

### Technical Requirements

- Support for multiple measurement types (numeric, string, array)
- Image storage and reference capabilities
- Statistical data handling for quantitative measurements
- Multi-magnification examination support
- Phase identification and quantification
- Standardized metallographic terminology
- Integration with microscopy equipment data
- Support for automated image analysis results

### Standards Compliance

- ASTM E3: Standard Guide for Preparation of Metallographic Specimens
- ASTM E112: Standard Test Methods for Determining Average Grain Size
- ASTM E1382: Standard Test Methods for Determining Average Grain Size Using Semiautomatic and Automatic Image Analysis
- ASTM E562: Standard Test Method for Determining Volume Fraction by Systematic Manual Point Count
- ASTM E1181: Standard Test Methods for Characterizing Duplex Grain Sizes
- ISO 643: Steels - Micrographic determination of the apparent grain size
- ISO 4499: Hardmetals - Metallographic determination of microstructure

### Industry Practices

- Multiple fields examined for statistical validity (typically 5-10 fields)
- Standardized etching procedures for each material system
- Appropriate magnification selection based on microstructural features
- Documentation of sample orientation relative to working direction
- Statistical analysis of quantitative measurements
- Digital image archiving with metadata
- Calibrated measurement systems with traceability

## JSON Schema Example

```json
{
  "type": "object",
  "properties": {
    "MetallographicExamination": {
      "type": "object",
      "properties": {
        "ExaminationId": {
          "type": "string"
        },
        "ExaminationName": {
          "type": "string"
        },
        "Standard": {
          "type": "string",
          "examples": ["ASTM E3-11", "ISO 643", "ASTM E112"]
        },
        "SamplePreparation": {
          "type": "object",
          "properties": {
            "SectionOrientation": {
              "type": "string",
              "enum": ["Longitudinal", "Transverse", "Through-thickness", "45-degree"]
            },
            "MountingMethod": {
              "type": "string",
              "enum": ["Compression", "Castable", "Cold", "Clamping"]
            },
            "GrindingSequence": {
              "type": "array",
              "items": { "type": "string" },
              "examples": [["240", "400", "600", "800", "1200"]]
            },
            "PolishingSteps": {
              "type": "array",
              "items": {
                "type": "object",
                "properties": {
                  "Compound": { "type": "string" },
                  "Size": { "type": "string" },
                  "Time": { "type": "string" }
                }
              }
            },
            "AutomatedPrep": { "type": "boolean" }
          }
        },
        "EtchingDetails": {
          "type": "object",
          "properties": {
            "EtchantType": {
              "type": "string",
              "examples": ["Nital", "Picral", "Marble's", "Klemm's", "Beraha's"]
            },
            "EtchingMethod": {
              "type": "string",
              "enum": ["Immersion", "Swabbing", "Electrolytic", "Ion beam"]
            },
            "EtchingTime": { "type": "string" },
            "Temperature": { "type": "number" },
            "TemperatureUnit": { "type": "string" },
            "Voltage": { "type": "number" },
            "PostEtchTreatment": { "type": "string" }
          }
        },
        "Magnifications": {
          "type": "array",
          "items": { "type": "integer", "minimum": 10, "maximum": 50000 }
        },
        "Examiner": { "type": "string" },
        "ExaminationDate": { "type": "string", "format": "date" },
        "Measurements": {
          "type": "array",
          "items": { "$ref": "#/$defs/Measurement" },
          "minItems": 1
        }
      },
      "required": ["ExaminationId", "Standard", "Measurements"]
    }
  }
}
```

## Sample Data

```json
{
  "MetallographicExamination": {
    "ExaminationId": "METALLO-001",
    "ExaminationName": "Low Carbon Steel Microstructure Analysis",
    "Standard": "ASTM E3-11",
    "SamplePreparation": {
      "SectionOrientation": "Transverse",
      "MountingMethod": "Compression",
      "GrindingSequence": ["240", "400", "600", "800", "1200"],
      "PolishingSteps": [
        {
          "Compound": "Diamond suspension",
          "Size": "6 μm",
          "Time": "5 min"
        },
        {
          "Compound": "Diamond suspension", 
          "Size": "1 μm",
          "Time": "3 min"
        },
        {
          "Compound": "Colloidal silica",
          "Size": "0.05 μm", 
          "Time": "2 min"
        }
      ],
      "AutomatedPrep": true
    },
    "EtchingDetails": {
      "EtchantType": "2% Nital",
      "EtchingMethod": "Immersion",
      "EtchingTime": "15s",
      "Temperature": 23,
      "TemperatureUnit": "°C",
      "PostEtchTreatment": "Alcohol rinse and air dry"
    },
    "Magnifications": [100, 500, 1000],
    "Examiner": "Dr. A. Metallurgist",
    "ExaminationDate": "2024-03-15",
    "Measurements": [
      {
        "PropertySymbol": "αVf",
        "PropertyName": "Ferrite Volume Fraction",
        "Unit": "%",
        "Method": "ASTM E562",
        "TestConditions": "500X magnification, 10 fields",
        "ResultType": "numeric",
        "Result": {
          "Value": 75.2,
          "DecimalPlaces": 1,
          "Minimum": 70.0,
          "Maximum": 80.0,
          "Statistics": {
            "StandardDeviation": 2.1,
            "Count": 10,
            "Range": 6.5
          },
          "Interpretation": "In Specification"
        }
      },
      {
        "PropertySymbol": "PVf",
        "PropertyName": "Pearlite Volume Fraction", 
        "Unit": "%",
        "Method": "ASTM E562",
        "TestConditions": "500X magnification, 10 fields",
        "ResultType": "numeric",
        "Result": {
          "Value": 24.8,
          "DecimalPlaces": 1,
          "Minimum": 20.0,
          "Maximum": 30.0,
          "Statistics": {
            "StandardDeviation": 2.1,
            "Count": 10,
            "Range": 6.5
          },
          "Interpretation": "In Specification"
        }
      },
      {
        "PropertySymbol": "GS",
        "PropertyName": "Ferrite Grain Size",
        "Unit": "ASTM",
        "Method": "ASTM E112",
        "TestConditions": "100X magnification, linear intercept",
        "ResultType": "numeric",
        "Result": {
          "Value": 8.5,
          "DecimalPlaces": 1,
          "Minimum": 7.0,
          "Statistics": {
            "StandardDeviation": 0.3,
            "Count": 200,
            "Range": 1.2
          },
          "Interpretation": "In Specification"
        }
      },
      {
        "PropertySymbol": "Banding",
        "PropertyName": "Microstructural Banding",
        "Unit": "Rating",
        "Method": "ASTM A588",
        "TestConditions": "100X magnification, longitudinal section",
        "ResultType": "numeric",
        "Result": {
          "Value": 2,
          "DecimalPlaces": 0,
          "Maximum": 3,
          "Interpretation": "In Specification"
        }
      },
      {
        "PropertySymbol": "PearSpacing",
        "PropertyName": "Pearlite Interlamellar Spacing",
        "Unit": "nm",
        "Method": "Linear Intercept",
        "TestConditions": "1000X magnification, 50 measurements",
        "ResultType": "numeric",
        "Result": {
          "Value": 285,
          "DecimalPlaces": 0,
          "Statistics": {
            "StandardDeviation": 45,
            "Count": 50,
            "Range": 180
          },
          "Interpretation": "Typical for this composition"
        }
      },
      {
        "PropertySymbol": "Texture",
        "PropertyName": "Crystallographic Texture Analysis",
        "Unit": "Intensity",
        "Method": "EBSD",
        "TestConditions": "20kV, 70° tilt, 1μm step size",
        "ResultType": "array",
        "Result": {
          "ParameterName": "Texture Component",
          "ParameterUnit": "Miller Indices",
          "ValueName": "Intensity",
          "ValueUnit": "Multiples of Random",
          "DecimalPlaces": 2,
          "Data": [
            {
              "Parameter": "{100}<011>",
              "Value": 2.45,
              "Status": "Pass"
            },
            {
              "Parameter": "{110}<112>",
              "Value": 1.85,
              "Status": "Pass"
            },
            {
              "Parameter": "{111}<110>",
              "Value": 0.95,
              "Status": "Pass"
            }
          ],
          "Interpretation": "Weak rolling texture typical for low carbon steel"
        }
      },
      {
        "PropertySymbol": "Cleanliness",
        "PropertyName": "Steel Cleanliness Assessment",
        "Unit": "Classification",
        "Method": "ASTM E45 Method A",
        "TestConditions": "100X magnification, worst field",
        "ResultType": "string",
        "Result": {
          "Value": "A1.5 B1.0 C0.5 D1.0 - Fine",
          "Interpretation": "In Specification"
        }
      }
    ]
  }
}
```

## Notes

### Implementation Notes

- Multiple measurement types support different metallographic analyses
- Statistical sampling critical for quantitative measurements
- Image archiving and metadata management important for traceability
- Automated analysis integration reduces subjectivity and improves repeatability
- Sample preparation details affect measurement validity
- Multiple magnifications often required for complete characterization
- Etching parameters must be documented for reproducibility

### Related Aspects

- Chemical Analysis (composition affects microstructure)
- Mechanical Properties (structure-property relationships)
- Heat Treatment (processing-microstructure relationships)
- Physical Properties (microstructure affects properties)
- Quality Attributes (microstructural quality indicators)
- Test Specimens (sample identification and tracking)
- Standards Compliance (metallographic requirements)

### References

- ASTM E3: Standard Guide for Preparation of Metallographic Specimens
- ASTM E112: Standard Test Methods for Determining Average Grain Size
- ASTM E562: Standard Test Method for Determining Volume Fraction by Systematic Manual Point Count
- ASTM E1382: Standard Test Methods for Determining Average Grain Size Using Semiautomatic and Automatic Image Analysis
- ISO 643: Steels - Micrographic determination of the apparent grain size
- ASM Handbook Vol. 9: Metallography and Microstructures
- Vander Voort, G.F.: Metallography, Principles and Practice# Metals Classification

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
- AA Registration: Aluminum Association alloy designations# Parties

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
- EN 10204: Certificate types (3.1, 3.2)# Physical Properties

## Aspect Overview

### Aspect Name

**Name**: Physical Properties

### Aspect Category

- [x] Physical Properties
- [ ] Chemical Properties
- [ ] Delivery Conditions
- [ ] Processing Information
- [ ] Quality Attributes
- [ ] Compliance Data
- [ ] Sustainability Metrics
- [ ] Other: ****\_\_\_****

### Priority

- [ ] Core (Required)
- [x] Standard (Recommended)
- [ ] Extended (Optional)

## Data Structure

### Primary Data Elements

This aspect uses the universal Measurement structure defined in the Measurements FAM. The following table shows common physical properties:

| Property Category | Common Properties | Typical Units | Example Standards |
|-------------------|-------------------|---------------|-------------------|
| Density | Density, Specific Gravity | g/cm³, kg/m³ | ASTM B311, ISO 3369 |
| Thermal | Thermal Conductivity, Expansion Coefficient, Specific Heat | W/m·K, µm/m·K, J/kg·K | ASTM E1461, ASTM E831 |
| Electrical | Electrical Resistivity, Conductivity | µΩ·cm, %IACS | ASTM B193, IEC 60468 |
| Magnetic | Permeability, Coercivity, Saturation | H/m, A/m, T | ASTM A773, IEC 60404 |
| Optical | Reflectance, Emissivity | %, - | ASTM E1933 |
| Dimensional | Grain Size, Surface Roughness | ASTM #, µm | ASTM E112, ISO 4287 |

### Sub-aspects

Break down into specific components:

#### Sub-aspect 1: Thermal Properties

- **Description**: Properties related to heat transfer and thermal behavior
- **Common Measurements**:
  - Thermal Conductivity (k): Heat transfer capability
  - Coefficient of Thermal Expansion (CTE): Dimensional change with temperature
  - Specific Heat Capacity (Cp): Heat storage capability
  - Thermal Diffusivity: Heat propagation rate
  - Melting Point/Range: Phase transition temperature
  - Glass Transition Temperature (Tg): For applicable materials

#### Sub-aspect 2: Electrical Properties

- **Description**: Properties related to electrical conduction and resistance
- **Common Measurements**:
  - Electrical Resistivity (ρ): Material's opposition to current flow
  - Electrical Conductivity (σ): Ability to conduct current
  - IACS Conductivity: Percentage of International Annealed Copper Standard
  - Dielectric Strength: For insulating materials
  - Temperature Coefficient of Resistance (TCR)

#### Sub-aspect 3: Magnetic Properties

- **Description**: Response to magnetic fields
- **Common Measurements**:
  - Magnetic Permeability (µ): Ability to support magnetic field
  - Coercivity (Hc): Resistance to demagnetization
  - Saturation Magnetization (Ms): Maximum magnetic moment
  - Remanence (Br): Residual magnetization
  - Curie Temperature: Magnetic transition temperature

#### Sub-aspect 4: Density and Porosity

- **Description**: Mass per unit volume and void content
- **Common Measurements**:
  - Density: Mass per unit volume
  - Apparent Density: Including closed porosity
  - Bulk Density: Including all voids
  - Porosity: Volume fraction of voids
  - Specific Gravity: Relative to water

#### Sub-aspect 5: Surface and Microstructural Properties

- **Description**: Surface characteristics and internal structure
- **Common Measurements**:
  - Surface Roughness (Ra, Rz): Surface texture parameters
  - Grain Size: Average grain diameter or ASTM number
  - Phase Content: Volume fraction of phases
  - Texture/Orientation: Crystallographic preferred orientation
  - Coating Thickness: For coated products

## Validation Rules

### Required Validations

- All measurements must follow the universal Measurement schema
- Temperature-dependent properties must specify test temperature
- Direction-dependent properties must specify orientation
- Statistical properties should include number of measurements

### Format Validations

- Units must be appropriate for the property type
- Method must reference recognized test standards
- Temperature conditions critical for thermal/electrical properties
- Sample preparation method may affect results

### Business Rules

- Density typically reported at room temperature unless specified
- Electrical conductivity often reported as %IACS for conductors
- Thermal expansion usually given as average over temperature range
- Magnetic properties may require specific field conditions
- Surface roughness parameters must specify measurement standard

## Use Cases

### Primary Use Cases

1. **Design Engineering**: Select materials based on physical properties
2. **Quality Control**: Verify material meets physical property specs
3. **Thermal Management**: Design heat sinks, insulation systems
4. **Electrical Systems**: Select conductors and insulators
5. **Magnetic Applications**: Design motors, transformers, shields
6. **Process Control**: Monitor property variations
7. **Failure Analysis**: Compare properties to specifications

### Integration Points

Where does this aspect connect with other parts of the format?

- **Chemical Analysis**: Composition affects physical properties
- **Processing History**: Heat treatment affects properties
- **Microstructure**: Grain size, phase content
- **Product Form**: Size and shape effects
- **Temperature Conditions**: Many properties temperature-dependent
- **Measurement Conditions**: Environmental effects

## Implementation Considerations

### Technical Requirements

- Support for temperature-dependent properties
- Handle directional properties (anisotropy)
- Enable property curves (e.g., CTE vs temperature)
- Support various measurement conditions
- Allow for derived properties (e.g., thermal diffusivity)

### Standards Compliance

- ASTM E1461: Thermal Diffusivity by Flash Method
- ASTM E831: Linear Thermal Expansion
- ASTM B193: Resistivity of Electrical Conductor Materials
- ASTM A773: DC Magnetic Properties
- ASTM E112: Determining Average Grain Size
- ISO 4287: Surface Texture Parameters
- IEC 60404: Magnetic Materials Standards

### Industry Practices

- Report test temperature for temperature-sensitive properties
- Specify measurement direction for anisotropic materials
- Include measurement uncertainty when critical
- Reference specific test methods
- Report environmental conditions (humidity, atmosphere)
- Multiple measurements for statistical confidence

## JSON Schema Example

```json
{
  "type": "object",
  "properties": {
    "PhysicalProperties": {
      "type": "array",
      "items": {
        "$ref": "#/$defs
/Measurement"
      },
      "examples": [
        {
          "PropertySymbol": "ρ",
          "PropertyName": "Density",
          "Unit": "g/cm³",
          "Method": "ASTM B311",
          "TestConditions": "20°C",
          "ResultType": "numeric",
          "Result": {
            "Value": 7.85,
            "DecimalPlaces": 2,
            "Interpretation": "In Specification"
          }
        },
        {
          "PropertySymbol": "k",
          "PropertyName": "Thermal Conductivity",
          "Unit": "W/m·K",
          "Method": "ASTM E1461",
          "TestConditions": "25°C",
          "ResultType": "numeric",
          "Result": {
            "Value": 50.2,
            "DecimalPlaces": 1,
            "Minimum": 45.0,
            "Interpretation": "In Specification"
          }
        },
        {
          "PropertySymbol": "CTE",
          "PropertyName": "Coefficient of Thermal Expansion",
          "Unit": "µm/m·K",
          "Method": "ASTM E831",
          "TestConditions": "20-100°C",
          "ResultType": "numeric",
          "Result": {
            "Value": 11.8,
            "DecimalPlaces": 1,
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
  "PhysicalProperties": [
    {
      "PropertySymbol": "ρ",
      "PropertyName": "Density",
      "Unit": "g/cm³",
      "Method": "ASTM B311",
      "TestConditions": "20°C",
      "SampleLocation": "Centre",
      "ResultType": "numeric",
      "Result": {
        "Value": 7.85,
        "DecimalPlaces": 2,
        "Target": 7.85,
        "Interpretation": "In Specification"
      }
    },
    {
      "PropertySymbol": "σ",
      "PropertyName": "Electrical Conductivity",
      "Unit": "%IACS",
      "Method": "ASTM B193",
      "TestConditions": "20°C",
      "ResultType": "numeric",
      "Result": {
        "Value": 2.9,
        "DecimalPlaces": 1,
        "Minimum": 2.5,
        "Interpretation": "In Specification"
      }
    },
    {
      "PropertySymbol": "CTE",
      "PropertyName": "Mean Coefficient of Thermal Expansion",
      "Unit": "µm/m·K",
      "Method": "ASTM E831",
      "TestConditions": "20-300°C",
      "ResultType": "array",
      "Result": {
        "ParameterName": "Temperature Range",
        "ParameterUnit": "°C",
        "ValueName": "Thermal Expansion",
        "ValueUnit": "µm/m·K",
        "DecimalPlaces": 1,
        "Data": [
          {
            "Parameter": "20-100",
            "Value": 11.8
          },
          {
            "Parameter": "20-200",
            "Value": 12.3
          },
          {
            "Parameter": "20-300",
            "Value": 12.9
          }
        ],
        "Interpretation": "In Specification"
      }
    },
    {
      "PropertySymbol": "µr",
      "PropertyName": "Relative Magnetic Permeability",
      "Unit": "-",
      "Method": "ASTM A773",
      "TestConditions": "H=800 A/m",
      "ResultType": "numeric",
      "Result": {
        "Value": 1.02,
        "DecimalPlaces": 2,
        "Maximum": 1.05,
        "Interpretation": "In Specification"
      }
    },
    {
      "PropertySymbol": "GS",
      "PropertyName": "Average Grain Size",
      "Unit": "ASTM",
      "Method": "ASTM E112",
      "TestConditions": "Longitudinal section",
      "ResultType": "numeric",
      "Result": {
        "Value": 7,
        "DecimalPlaces": 0,
        "Minimum": 5,
        "Interpretation": "In Specification"
      }
    },
    {
      "PropertySymbol": "Ra",
      "PropertyName": "Surface Roughness",
      "Unit": "µm",
      "Method": "ISO 4287",
      "TestConditions": "Cutoff 0.8mm",
      "SampleLocation": "Top surface",
      "ResultType": "numeric",
      "Result": {
        "Value": 1.2,
        "DecimalPlaces": 1,
        "Maximum": 3.2,
        "Interpretation": "In Specification"
      }
    }
  ]
}
```

## Notes

### Implementation Notes

- Many physical properties are temperature-dependent
- Some properties are directional (anisotropic)
- Measurement conditions must be clearly specified
- Units vary widely - careful validation needed
- Some properties derived from multiple measurements
- Environmental conditions may be critical

### Extensibility

This FAM provides examples of common physical properties but is not exhaustive. The universal Measurement structure allows for any physical property to be recorded with appropriate:
- Property identification (symbol, name, ID)
- Value and constraints
- Test method and conditions
- Units and interpretation

### Related Aspects

- Measurements (base structure for all properties)
- Chemical Analysis (composition affects properties)
- Processing/Heat Treatment (affects microstructure)
- Product Form (geometry affects some measurements)
- Test Conditions (temperature, environment)
- Sampling (location and orientation matter)

### References

- ASTM E1269: Specific Heat Capacity by DSC
- ASTM D792: Density and Specific Gravity
- ASTM E1530: Thermal Conductivity
- IEC 60404-4: Methods of measurement of d.c. magnetic properties
- ISO 6892-1: Metallic materials - Tensile testing
- ASTM A255: Determining Hardenability of Steel# Product Shapes and Dimensions

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
# QR Code and Visual Rendering

## Aspect Overview

### Aspect Name
**Name**: QR Code and Visual Rendering

### Aspect Category
- [ ] Physical Properties
- [ ] Chemical Properties
- [ ] Delivery Conditions
- [ ] Processing Information
- [ ] Quality Attributes
- [ ] Compliance Data
- [ ] Sustainability Metrics
- [x] Other: **Visual Identification & Rendering**

### Priority
- [ ] Core (Required)
- [x] Standard (Recommended)
- [ ] Extended (Optional)

## Data Structure

### Primary Data Elements
List the main data fields for this aspect:

| Field Name | Data Type | Required | Description | Example |
|------------|-----------|----------|-------------|---------|
| QrCodes | array | No | Array of QR code specifications | [...] |
| Barcodes | array | No | Array of barcode specifications | [...] |
| VisualElements | array | No | Array of visual rendering elements | [...] |
| RenderingFormats | array | Yes | Supported output formats | ["pdf", "html", "svg"] |
| Layout | object | No | Layout configuration for rendering | {...} |
| Styling | object | No | Styling and appearance configuration | {...} |

### Sub-aspects

#### Sub-aspect 1: QR Code Specifications
- **Description**: Configuration for QR code generation and rendering
- **Data Elements**:
  - Content (data to encode)
  - Format (URL, text, JSON, etc.)
  - ErrorCorrection (error correction level)
  - Size (dimensions and scaling)
  - Styling (colors, borders, logos)
  - Positioning (placement in rendered output)

#### Sub-aspect 2: Barcode Specifications
- **Description**: Configuration for various barcode types
- **Data Elements**:
  - Type (Code128, EAN13, DataMatrix, etc.)
  - Content (data to encode)
  - DisplayText (human-readable text)
  - Size (dimensions and scaling)
  - Positioning (placement in rendered output)

#### Sub-aspect 3: Visual Layout & Styling
- **Description**: Overall layout and appearance configuration
- **Data Elements**:
  - Layout (positioning, margins, spacing)
  - Styling (fonts, colors, borders)
  - Responsive (adaptive sizing rules)
  - Branding (logos, headers, footers)

## Validation Rules

### Required Validations
- At least one of QrCodes, Barcodes, or VisualElements must be present
- QR code Content must not exceed maximum capacity for specified error correction level
- Barcode Content must be valid for the specified barcode type
- RenderingFormats must be from supported list
- Size specifications must be positive values

### Format Validations
- QR code ErrorCorrection must be "L", "M", "Q", or "H"
- Barcode Type must be from supported list
- Color values must be valid hex, RGB, or named colors
- URLs must be valid format if specified
- Positioning coordinates must be numeric

### Business Rules
- QR codes containing URLs should be validated for accessibility
- Barcode Content should match expected format for the barcode type
- Size specifications should consider target rendering medium
- ErrorCorrection level should balance data capacity with reliability
- Visual elements should not interfere with code readability

## Use Cases

### Primary Use Cases
1. **Digital Material Passport Display**: Rendering QR codes linking to digital passport data
2. **Product Labeling**: Generating printable labels with QR codes and barcodes
3. **Compliance Documentation**: Including machine-readable codes in PDF reports

### Integration Points
Where does this aspect connect with other parts of the format?
- **General Attachment Information**: QR codes can reference attached documents
- **Product Information**: Barcodes can encode product identifiers
- **Compliance Data**: QR codes can link to certification documents
- **All Aspects**: Any data can be encoded in QR codes for mobile access

## Implementation Considerations

### Technical Requirements
- QR code generation libraries (e.g., qrcode.js, ZXing)
- Barcode generation libraries (e.g., JsBarcode, Dynamsoft)
- PDF generation capabilities (e.g., PDFKit, jsPDF)
- SVG rendering for scalable graphics
- Responsive design for different output sizes

### Standards Compliance
- ISO/IEC 18004 (QR Code specification)
- ISO/IEC 15417 (Code 128 barcode)
- ISO/IEC 15420 (EAN/UPC barcodes)
- ISO/IEC 16022 (Data Matrix)
- PDF/A standards for archival documents

### Industry Practices
- Use appropriate error correction levels for intended use
- Ensure sufficient contrast for reliable scanning
- Test readability across different devices and printers
- Include human-readable backup information
- Consider accessibility requirements for visual elements

## JSON Schema Example

```json
{
  "type": "object",
  "properties": {
    "QrCodes": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "Id": {
            "type": "string",
            "description": "Unique identifier for the QR code"
          },
          "Content": {
            "type": "string",
            "description": "Data to encode in the QR code"
          },
          "Format": {
            "type": "string",
            "enum": ["url", "text", "json", "vcard", "wifi"],
            "description": "Format of the encoded data"
          },
          "ErrorCorrection": {
            "type": "string",
            "enum": ["L", "M", "Q", "H"],
            "default": "M",
            "description": "Error correction level"
          },
          "Size": {
            "type": "object",
            "properties": {
              "Width": {
                "type": "number",
                "minimum": 1,
                "description": "Width in pixels or units"
              },
              "Height": {
                "type": "number",
                "minimum": 1,
                "description": "Height in pixels or units"
              },
              "Scale": {
                "type": "number",
                "minimum": 0.1,
                "maximum": 10,
                "default": 1,
                "description": "Scaling factor"
              }
            },
            "required": ["Width", "Height"]
          },
          "Styling": {
            "type": "object",
            "properties": {
              "ForegroundColor": {
                "type": "string",
                "pattern": "^(#[0-9A-Fa-f]{6}|rgb\\(\\d+,\\s*\\d+,\\s*\\d+\\)|[a-zA-Z]+)$",
                "default": "#000000",
                "description": "Foreground color"
              },
              "BackgroundColor": {
                "type": "string",
                "pattern": "^(#[0-9A-Fa-f]{6}|rgb\\(\\d+,\\s*\\d+,\\s*\\d+\\)|[a-zA-Z]+)$",
                "default": "#ffffff",
                "description": "Background color"
              },
              "Margin": {
                "type": "number",
                "minimum": 0,
                "default": 0,
                "description": "Margin around the QR code"
              },
              "Logo": {
                "type": "object",
                "properties": {
                  "Url": {
                    "type": "string",
                    "format": "uri",
                    "description": "URL to logo image"
                  },
                  "Size": {
                    "type": "number",
                    "minimum": 0.1,
                    "maximum": 0.3,
                    "default": 0.2,
                    "description": "Logo size as fraction of QR code"
                  }
                }
              }
            }
          },
          "Positioning": {
            "type": "object",
            "properties": {
              "X": {
                "type": "number",
                "description": "X coordinate for positioning"
              },
              "Y": {
                "type": "number",
                "description": "Y coordinate for positioning"
              },
              "Alignment": {
                "type": "string",
                "enum": ["left", "center", "right"],
                "default": "center",
                "description": "Alignment within container"
              }
            }
          },
          "Caption": {
            "type": "string",
            "description": "Human-readable caption or description"
          }
        },
        "required": ["Id", "Content", "Format", "Size"]
      }
    },
    "Barcodes": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "Id": {
            "type": "string",
            "description": "Unique identifier for the barcode"
          },
          "Type": {
            "type": "string",
            "enum": ["code128", "ean13", "ean8", "upc", "datamatrix", "pdf417"],
            "description": "Barcode type"
          },
          "Content": {
            "type": "string",
            "description": "Data to encode in the barcode"
          },
          "DisplayText": {
            "type": "boolean",
            "default": true,
            "description": "Whether to display human-readable text"
          },
          "Size": {
            "type": "object",
            "properties": {
              "Width": {
                "type": "number",
                "minimum": 1
              },
              "Height": {
                "type": "number",
                "minimum": 1
              },
              "Scale": {
                "type": "number",
                "minimum": 0.1,
                "maximum": 10,
                "default": 1
              }
            },
            "required": ["Width", "Height"]
          },
          "Positioning": {
            "type": "object",
            "properties": {
              "X": {
                "type": "number"
              },
              "Y": {
                "type": "number"
              },
              "Alignment": {
                "type": "string",
                "enum": ["left", "center", "right"],
                "default": "center"
              }
            }
          }
        },
        "required": ["Id", "Type", "Content", "Size"]
      }
    },
    "VisualElements": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "Id": {
            "type": "string",
            "description": "Unique identifier for the visual element"
          },
          "Type": {
            "type": "string",
            "enum": ["text", "image", "logo", "line", "rectangle", "circle"],
            "description": "Type of visual element"
          },
          "Content": {
            "type": "string",
            "description": "Content or source for the element"
          },
          "Styling": {
            "type": "object",
            "properties": {
              "FontSize": {
                "type": "number",
                "minimum": 1
              },
              "FontFamily": {
                "type": "string"
              },
              "Color": {
                "type": "string",
                "pattern": "^(#[0-9A-Fa-f]{6}|rgb\\(\\d+,\\s*\\d+,\\s*\\d+\\)|[a-zA-Z]+)$"
              },
              "BackgroundColor": {
                "type": "string",
                "pattern": "^(#[0-9A-Fa-f]{6}|rgb\\(\\d+,\\s*\\d+,\\s*\\d+\\)|[a-zA-Z]+)$"
              },
              "BorderWidth": {
                "type": "number",
                "minimum": 0
              },
              "BorderColor": {
                "type": "string",
                "pattern": "^(#[0-9A-Fa-f]{6}|rgb\\(\\d+,\\s*\\d+,\\s*\\d+\\)|[a-zA-Z]+)$"
              }
            }
          },
          "Positioning": {
            "type": "object",
            "properties": {
              "X": {
                "type": "number"
              },
              "Y": {
                "type": "number"
              },
              "Width": {
                "type": "number",
                "minimum": 1
              },
              "Height": {
                "type": "number",
                "minimum": 1
              },
              "Alignment": {
                "type": "string",
                "enum": ["left", "center", "right"],
                "default": "left"
              }
            }
          }
        },
        "required": ["Id", "Type", "Content"]
      }
    },
    "RenderingFormats": {
      "type": "array",
      "items": {
        "type": "string",
        "enum": ["pdf", "html", "svg", "png", "jpeg"]
      },
      "minItems": 1,
      "description": "Supported output formats for rendering"
    },
    "Layout": {
      "type": "object",
      "properties": {
        "PageSize": {
          "type": "string",
          "enum": ["A4", "A3", "A5", "letter", "legal", "custom"],
          "default": "A4",
          "description": "Page size for PDF rendering"
        },
        "Orientation": {
          "type": "string",
          "enum": ["portrait", "landscape"],
          "default": "portrait",
          "description": "Page orientation"
        },
        "Margins": {
          "type": "object",
          "properties": {
            "Top": {
              "type": "number",
              "minimum": 0,
              "default": 20
            },
            "Right": {
              "type": "number",
              "minimum": 0,
              "default": 20
            },
            "Bottom": {
              "type": "number",
              "minimum": 0,
              "default": 20
            },
            "Left": {
              "type": "number",
              "minimum": 0,
              "default": 20
            }
          }
        },
        "Responsive": {
          "type": "boolean",
          "default": true,
          "description": "Enable responsive sizing for different outputs"
        }
      }
    },
    "Styling": {
      "type": "object",
      "properties": {
        "Theme": {
          "type": "string",
          "enum": ["light", "dark", "corporate", "minimal"],
          "default": "light",
          "description": "Overall styling theme"
        },
        "FontFamily": {
          "type": "string",
          "default": "Arial, sans-serif",
          "description": "Default font family"
        },
        "PrimaryColor": {
          "type": "string",
          "pattern": "^(#[0-9A-Fa-f]{6}|rgb\\(\\d+,\\s*\\d+,\\s*\\d+\\)|[a-zA-Z]+)$",
          "default": "#000000",
          "description": "Primary color for branding"
        },
        "SecondaryColor": {
          "type": "string",
          "pattern": "^(#[0-9A-Fa-f]{6}|rgb\\(\\d+,\\s*\\d+,\\s*\\d+\\)|[a-zA-Z]+)$",
          "default": "#666666",
          "description": "Secondary color for accents"
        }
      }
    }
  },
  "required": ["RenderingFormats"],
  "anyOf": [
    {"required": ["QrCodes"]},
    {"required": ["Barcodes"]},
    {"required": ["VisualElements"]}
  ]
}
```

## Sample Data

```json
{
  "QrCodes": [
    {
      "Id": "passport-link",
      "Content": "https://passport.example.com/product/abc123",
      "Format": "url",
      "ErrorCorrection": "M",
      "Size": {
        "Width": 100,
        "Height": 100,
        "Scale": 1.0
      },
      "Styling": {
        "ForegroundColor": "#000000",
        "BackgroundColor": "#ffffff",
        "Margin": 4,
        "Logo": {
          "Url": "https://company.com/logo.png",
          "Size": 0.2
        }
      },
      "Positioning": {
        "X": 50,
        "Y": 50,
        "Alignment": "center"
      },
      "Caption": "Scan for Digital Passport"
    },
    {
      "Id": "certificate-link",
      "Content": "https://certs.example.com/carbon-footprint/xyz789",
      "Format": "url",
      "ErrorCorrection": "Q",
      "Size": {
        "Width": 80,
        "Height": 80,
        "Scale": 1.0
      },
      "Styling": {
        "ForegroundColor": "#0066cc",
        "BackgroundColor": "#ffffff",
        "Margin": 2
      },
      "Positioning": {
        "X": 200,
        "Y": 50,
        "Alignment": "center"
      },
      "Caption": "Carbon Footprint Certificate"
    }
  ],
  "Barcodes": [
    {
      "Id": "product-code",
      "Type": "code128",
      "Content": "PROD-ABC123-2025",
      "DisplayText": true,
      "Size": {
        "Width": 150,
        "Height": 30,
        "Scale": 1.0
      },
      "Positioning": {
        "X": 50,
        "Y": 200,
        "Alignment": "left"
      }
    },
    {
      "Id": "serial-number",
      "Type": "datamatrix",
      "Content": "SN:ABC123456789",
      "DisplayText": false,
      "Size": {
        "Width": 40,
        "Height": 40,
        "Scale": 1.0
      },
      "Positioning": {
        "X": 250,
        "Y": 200,
        "Alignment": "right"
      }
    }
  ],
  "VisualElements": [
    {
      "Id": "title",
      "Type": "text",
      "Content": "Digital Material Passport",
      "Styling": {
        "FontSize": 18,
        "FontFamily": "Arial, sans-serif",
        "Color": "#333333"
      },
      "Positioning": {
        "X": 50,
        "Y": 20,
        "Alignment": "left"
      }
    },
    {
      "Id": "company-logo",
      "Type": "image",
      "Content": "https://company.com/logo.png",
      "Positioning": {
        "X": 250,
        "Y": 10,
        "Width": 60,
        "Height": 30,
        "Alignment": "right"
      }
    },
    {
      "Id": "divider",
      "Type": "line",
      "Content": "",
      "Styling": {
        "Color": "#cccccc",
        "BorderWidth": 1
      },
      "Positioning": {
        "X": 50,
        "Y": 40,
        "Width": 250,
        "Height": 1
      }
    }
  ],
  "RenderingFormats": ["pdf", "html", "svg"],
  "Layout": {
    "PageSize": "A4",
    "Orientation": "portrait",
    "Margins": {
      "Top": 20,
      "Right": 20,
      "Bottom": 20,
      "Left": 20
    },
    "Responsive": true
  },
  "Styling": {
    "Theme": "corporate",
    "FontFamily": "Arial, sans-serif",
    "PrimaryColor": "#0066cc",
    "SecondaryColor": "#666666"
  }
}
```

## Notes

### Implementation Notes
- QR codes linking to digital passport data should use HTTPS URLs
- Consider implementing URL shortening for complex passport links
- Test QR code readability at different sizes and print qualities
- Include fallback mechanisms for when codes cannot be scanned
- Validate barcode Content format before generation
- Consider accessibility requirements for visual elements

### Related Aspects
- **General Attachment Information**: QR codes can reference attached files
- **Product Information**: Barcodes can encode product identifiers
- **Compliance Data**: Links to certificates and compliance documents
- **All Aspects**: Any aspect data can be encoded for mobile access

### References
- ISO/IEC 18004:2015 - Information technology — Automatic identification and data capture techniques — QR Code bar code symbology specification
- ISO/IEC 15417:2007 - Information technology — Automatic identification and data capture techniques — Code 128 bar code symbology specification
- ISO/IEC 16022:2006 - Information technology — Automatic identification and data capture techniques — Data Matrix bar code symbology specification
- PDF/A-1, PDF/A-2, PDF/A-3 standards for archival documents
- Web Content Accessibility Guidelines (WCAG) 2.1# RoHS/REACH Compliance

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
- ECHA Guidance on substances in articles# Supplementary Tests

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
- ASTM E381: Standard Method of Macroetch Testing# Sustainability

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
- EU Digital Product Passport Guidelines# Transaction Data

## Aspect Overview

### Aspect Name

**Name**: Transaction Data

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

| Field Name | Data Type | Required | Description | Example |
|------------|-----------|----------|-------------|---------|
| PurchaseOrder | object | Yes | Customer's purchase order information | See sub-aspect |
| PurchaseOrderConfirmation | object | No | Supplier's confirmation of the purchase order | See sub-aspect |
| SalesOrder | object | No | Supplier's internal sales order | See sub-aspect |
| DeliveryNote | object | Yes | Delivery/shipping documentation | See sub-aspect |
| ContractNumber | string | No | Framework contract or agreement number | "FA-2024-001" |
| ProjectReference | string | No | Customer's project reference | "PROJ-ABC-123" |
| IncoTerms | string | No | International commercial terms | "DAP", "EXW" |
| PaymentTerms | string | No | Payment terms agreed | "Net 30 days" |

### Sub-aspects

Break down into specific components:

#### Sub-aspect 1: Purchase Order

- **Description**: Customer's order placed with the supplier
- **Data Elements**:
  - OrderNumber: String - Customer's PO number
  - OrderDate: Date - Date PO was issued
  - OrderPosition: String - Line item on PO
  - Quantity: Number - Ordered quantity
  - QuantityUnit: String - Unit of measure
  - RequestedDeliveryDate: Date - Customer's requested date
  - CustomerProductId: String - Customer's material code
  - CustomerProductName: String - Customer's description
  - Specifications: Array[String] - Required specifications
  - SpecialRequirements: String - Additional requirements

#### Sub-aspect 2: Purchase Order Confirmation

- **Description**: Supplier's acknowledgment and confirmation of the PO
- **Data Elements**:
  - ConfirmationNumber: String - Supplier's confirmation ID
  - ConfirmationDate: Date - Date of confirmation
  - ConfirmedQuantity: Number - Quantity supplier can deliver
  - ConfirmedDeliveryDate: Date - Supplier's committed date
  - DeliverySchedule: Array - Multiple delivery dates/quantities
  - TechnicalContact: Person - Technical questions contact
  - CommercialContact: Person - Commercial questions contact
  - Deviations: Array[String] - Any deviations from PO
  - LeadTime: String - Production lead time

#### Sub-aspect 3: Sales Order

- **Description**: Supplier's internal sales order
- **Data Elements**:
  - SalesOrderNumber: String - Internal SO number
  - SalesOrderDate: Date - SO creation date
  - SalesOrderPosition: String - SO line item
  - ProductionOrderNumber: String - Link to production
  - PlannedProductionDate: Date - Production schedule
  - InternalProductId: String - Supplier's material code
  - InternalProductName: String - Supplier's description
  - ProductionLocation: String - Manufacturing site
  - SalesRegion: String - Sales territory/region

#### Sub-aspect 4: Delivery Note

- **Description**: Shipping/delivery documentation
- **Data Elements**:
  - DeliveryNoteNumber: String - Delivery note ID
  - DeliveryNoteDate: Date - Issue date
  - DeliveryPosition: String - Line item
  - DeliveredQuantity: Number - Actual shipped quantity
  - QuantityUnit: String - Unit of measure
  - GrossWeight: Number - Total weight including packaging
  - NetWeight: Number - Product weight only
  - WeightUnit: String - Weight unit (kg, lbs)
  - PackageCount: Number - Number of packages
  - PackageType: String - Type of packaging
  - ShippingDate: Date - Actual ship date
  - EstimatedArrival: Date - ETA at destination
  - TrackingNumber: String - Shipment tracking
  - TransportMode: String - Mode of transport
  - Carrier: String - Transport company
  - VehicleId: String - Truck/container number

## Validation Rules

### Required Validations

- PurchaseOrder.OrderNumber is required
- DeliveryNote.DeliveryNoteNumber is required
- Quantities must be positive numbers
- Dates must be in valid format
- DeliveredQuantity should not exceed OrderedQuantity (warning)

### Format Validations

- Date format: ISO 8601 (YYYY-MM-DD)
- IncoTerms: Valid 3-letter codes (EXW, DAP, CIF, etc.)
- Weight units: kg, t, lbs, MT
- Quantity units must be consistent across documents

### Business Rules

- PO date should precede confirmation date
- Confirmation date should precede delivery date
- Sales order links to purchase order
- Delivery note references both PO and SO
- Multiple deliveries may fulfill one PO
- Partial deliveries should be tracked
- Over-delivery may require approval

## Use Cases

### Primary Use Cases

1. **Order Tracking**: Follow order from placement to delivery
2. **Delivery Verification**: Match delivered goods to orders
3. **Invoice Matching**: Three-way match (PO-Receipt-Invoice)
4. **Supply Chain Visibility**: Track order status and delays
5. **Compliance Documentation**: Prove order fulfillment
6. **Dispute Resolution**: Reference for quantity/quality issues
7. **ERP Integration**: Sync with customer/supplier systems
8. **Audit Trail**: Complete transaction documentation

### Integration Points

Where does this aspect connect with other parts of the format?

- **Parties**: Links Customer, Supplier, GoodsReceiver
- **Product**: What was ordered and delivered
- **Measurements**: Quality per specifications
- **Certificates**: Which cert covers which delivery
- **Traceability**: Order to batch/heat mapping
- **Logistics**: Shipping and transport details

## Implementation Considerations

### Technical Requirements

- Support for multiple deliveries per order
- Handling of partial shipments
- Order change management
- Quantity unit conversions
- Date/time zone handling
- Document versioning

### Standards Compliance

- ISO 8601: Date and time format
- UN/EDIFACT: EDI standards
- Incoterms 2020: Trade terms
- GS1: Product identification
- Industry EDI standards (ANSI X12, EDIFACT)

### Industry Practices

- PO acknowledgment within 24-48 hours
- Delivery note accompanies shipment
- Electronic copies precede physical delivery
- Order changes require confirmation
- Framework contracts reference
- Batch/serial number tracking
- Certificate linked to delivery

## JSON Schema Example

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "properties": {
    "TransactionData": {
      "type": "object",
      "properties": {
        "PurchaseOrder": {
          "type": "object",
          "properties": {
            "Number": {
              "type": "string",
              "description": "Customer's purchase order number"
            },
            "Date": {
              "type": "string",
              "format": "date"
            },
            "Position": {
              "type": "string",
              "description": "Line item on the order"
            },
            "Quantity": {
              "type": "number",
              "minimum": 0
            },
            "QuantityUnit": {
              "type": "string",
              "enum": ["kg", "t", "lbs", "MT", "m", "m²", "m³", "pieces", "each"]
            },
            "RequestedDeliveryDate": {
              "type": "string",
              "format": "date"
            },
            "CustomerProductId": {
              "type": "string"
            },
            "CustomerProductName": {
              "type": "string"
            },
            "Specifications": {
              "type": "array",
              "items": {
                "type": "string"
              }
            },
            "SpecialRequirements": {
              "type": "string"
            }
          },
          "required": ["Number", "Date", "Quantity", "QuantityUnit"]
        },
        "PurchaseOrderConfirmation": {
          "type": "object",
          "properties": {
            "Number": {
              "type": "string"
            },
            "Date": {
              "type": "string",
              "format": "date"
            },
            "Quantity": {
              "type": "number",
              "minimum": 0
            },
            "DeliveryDate": {
              "type": "string",
              "format": "date"
            }
          }
        },
        "SalesOrder": {
          "type": "object",
          "properties": {
            "Number": {
              "type": "string"
            },
            "Date": {
              "type": "string",
              "format": "date"
            },
            "Position": {
              "type": "string"
            },
            "ProductionOrderNumber": {
              "type": "string"
            },
            "PlannedProductionDate": {
              "type": "string",
              "format": "date"
            },
            "InternalProductId": {
              "type": "string"
            },
            "InternalProductName": {
              "type": "string"
            }
          }
        },
        "DeliveryNote": {
          "type": "object",
          "properties": {
            "Number": {
              "type": "string"
            },
            "Date": {
              "type": "string",
              "format": "date"
            },
            "Position": {
              "type": "string"
            },
            "Quantity": {
              "type": "number",
              "minimum": 0
            },
            "QuantityUnit": {
              "type": "string"
            },
            "GrossWeight": {
              "type": "number",
              "minimum": 0
            },
            "NetWeight": {
              "type": "number",
              "minimum": 0
            },
            "WeightUnit": {
              "type": "string",
              "enum": ["kg", "t", "lbs", "MT"]
            },
            "PackageCount": {
              "type": "integer",
              "minimum": 1
            },
            "PackageType": {
              "type": "string",
              "examples": ["Bundle", "Pallet", "Box", "Crate", "Container"]
            },
            "ShippingDate": {
              "type": "string",
              "format": "date"
            },
            "EstimatedArrival": {
              "type": "string",
              "format": "date"
            },
            "TrackingNumber": {
              "type": "string"
            },
            "TransportMode": {
              "type": "string",
              "enum": ["Road", "Rail", "Sea", "Air", "Multimodal"]
            },
            "Carrier": {
              "type": "string"
            },
            "VehicleId": {
              "type": "string"
            }
          },
          "required": ["Number", "Date", "Quantity", "QuantityUnit"]
        },
        "ContractNumber": {
          "type": "string"
        },
        "ProjectReference": {
          "type": "string"
        },
        "IncoTerms": {
          "type": "string",
          "pattern": "^[A-Z]{3}$",
          "examples": ["EXW", "FCA", "CPT", "CIP", "DAP", "DPU", "DDP", "FAS", "FOB", "CFR", "CIF"]
        }
      },
      "required": ["PurchaseOrder", "DeliveryNote"]
    }
  },
  "required": ["TransactionData"]
}
```

## Sample Data

```json
{
  "TransactionData": {
    "PurchaseOrder": {
      "Number": "20592692(1004321)",
      "Date": "2019-07-15",
      "Position": "10",
      "Quantity": 4.488,
      "QuantityUnit": "t",
      "RequestedDeliveryDate": "2019-09-15",
      "CustomerProductId": "BMS-7-323-STEEL",
      "CustomerProductName": "Aircraft Grade Steel per Boeing Spec",
      "Specifications": [
        "E4340M TO AMS6419",
        "BS EN10204/LSS AIRCRAFT RELEASE PROCEDURE"
      ],
      "SpecialRequirements": "Vacuum Arc Remelted, 100% UT tested"
    },
    "PurchaseOrderConfirmation": {
      "Number": "OC-CB828303-01",
      "Date": "2019-07-17",
      "Quantity": 4.488,
      "DeliveryDate": "2019-09-24",
    },
    "SalesOrder": {
      "Number": "CB828303",
      "Date": "2019-07-17",
      "Position": "10",
      "ProductionOrderNumber": "WO-8R518V",
      "PlannedProductionDate": "2019-08-15",
      "InternalProductId": "E4340M-VAR",
      "InternalProductName": "E4340M Vacuum Arc Remelted Steel",
    },
    "DeliveryNote": {
      "Number": "DN-00740730/1",
      "Date": "2019-09-24",
      "Position": "1",
      "Quantity": 4.488,
      "QuantityUnit": "t",
      "GrossWeight": 4650,
      "NetWeight": 4488,
      "WeightUnit": "kg",
      "PackageCount": 3,
      "PackageType": "Bundle",
      "ShippingDate": "2019-09-24",
      "EstimatedArrival": "2019-09-26",
      "TrackingNumber": "LSS-2019-09-24-001",
      "TransportMode": "Road",
      "Carrier": "Liberty Transport Services",
      "VehicleId": "TR-UK-1234"
    },
    "ContractNumber": "FA-BOEING-2019-001",
    "ProjectReference": "737-MAX-LANDING-GEAR",
    "IncoTerms": "DAP"
  }
}
```

## Notes

### Implementation Notes

- Support multiple PO positions in single certificate
- Handle order amendments and changes
- Track partial deliveries and backorders
- Support for call-off orders from contracts
- Multi-language support for product names
- Integration with EDI systems
- Support for dropship scenarios
- Handle quantity tolerances (+/- percentages)

### Related Aspects

- Parties (buyer, seller, ship-to addresses)
- Product (what is being ordered/delivered)
- Certificates (which cert covers which delivery)
- Traceability (order to production batch link)
- Quality (specifications and requirements)
- Logistics (detailed shipping information)
- Financial (pricing and payment terms)

### References

- ISO 8601: Date and time representations
- ISO 4217: Currency codes
- Incoterms 2020: International Commercial Terms
- UN/EDIFACT: Electronic Data Interchange standards
- ANSI X12: EDI Transaction Sets
- GS1 Standards: Global Trade Item Numbers
- Industry-specific ordering standards# Validation and Declaration of Conformance

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