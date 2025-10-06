# General Attributes

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
- W3C Web Annotation Data Model