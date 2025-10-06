# PCF Extension (Catena-X) - Replacement Extension

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

This approach allows the DMP to support multiple industry-specific carbon footprint formats (Catena-X for automotive, RMI for steel, etc.) without any modifications to the core schema, demonstrating true extensibility and future-proofing.