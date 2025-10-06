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
