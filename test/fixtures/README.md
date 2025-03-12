# Fixtures Directory

This directory contains test fixtures for various certificate types and schema formats used across the Material Identity ecosystem. These fixtures serve as reference examples for implementation, testing, and validation purposes.

## Directory Structure

Fixtures are organized by certificate type and schema version:

```
fixtures/
├── README.md                       # This file
├── coa/                            # Certificate of Analysis fixtures
│   ├── v0.x.y/                     # Version-specific fixtures
│   │   ├── example_001.json        # Example certificate in JSON format
│   │   ├── example_001.pdf         # Corresponding PDF rendering
│   │   └── ...                     # More example certificates
│   └── ...                         # Other versions
│
├── en10168/                        # EN10168 certificate fixtures
│   ├── v0.4.1/                     # Version-specific fixtures
│   │   ├── valid_certificate_1.json # Example certificate in JSON format
│   │   ├── valid_certificate_1.pdf  # Corresponding PDF rendering
│   │   └── ...                     # More example certificates
│   └── ...                         # Other versions
│
├── forestry/                       # Forestry certificate fixtures
│   └── ...                         # Structure similar to above
│
└── metals/                         # Metal industry certificate fixtures
    └── ...                         # Structure similar to above
```

## Purpose

The fixtures in this directory provide:

1. **Reference Implementations**: Complete, valid examples of certificates conforming to each schema
2. **Test Data**: Data for automated testing of parsers, validators, and renderers
3. **Developer Guidance**: Practical examples of how to structure data for each schema type
4. **Validation Examples**: Sample documents to validate schema changes against
5. **Rendering Examples**: Visual reference for how each certificate should be presented

## Usage Guidelines

### Testing

Use these fixtures for testing implementations:

```javascript
// Example test code
const fixture = require('./fixtures/en10168/v0.4.1/valid_certificate_1.json');
const validator = new SchemaValidator('v0.4.1');
const result = validator.validate(fixture);
assert(result.valid);
```

### Development Reference

When implementing parsers, renderers, or UIs, refer to these fixtures to understand:
- Required and optional fields
- Data types and formats
- Relationships between components
- Rendering requirements

### Schema Validation

When proposing schema changes, test against these fixtures to ensure backward compatibility:

```bash
# Example validation command
ajv validate -s schema/en10168/v0.4.1/schema.json -d "fixtures/en10168/v0.4.1/*.json"
```

## Contributing

When adding new fixtures:

1. Place them in the appropriate certificate type and version directory
2. Use matching filenames for JSON and corresponding PDF (e.g., `certificate_001.json` and `certificate_001.pdf`)
3. Follow the naming convention of the directory
4. Ensure the fixture validates against the corresponding schema version
5. Include descriptive comments within the JSON for special features
6. Update specific READMEs in subdirectories if needed

## Special Notes

- Each certificate type directory contains its own README with specific details
- Fixtures marked with `_invalid` in the filename intentionally contain validation errors for testing validators
- The PDF renderings demonstrate how the certificate should be visualized for end users