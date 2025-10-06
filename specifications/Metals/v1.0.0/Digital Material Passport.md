# Digital Material Passport v1.0.0

## Summary
A Digital Material Passport (DMP) is a digital representation that encapsulates comprehensive information about a material used in a product. It is specific to each production batch covering the material's origin, manufacturing process, physical and chemical properties, and environmental impact. It can contain information addressing material, stakeholder, and application-specific requirements like health and safety considerations, processing instructions, or regulatory approvals. A DMP aims to promote sustainable use of materials throughout their lifecycle from production, processing, use & reuse, recycling, and recovery of materials.

This proposal defines a standardized structure for a Digital Material Passport (DMP), which serves as a comprehensive wrapper for all material-related data including product information, chemical analysis, measurements, and transaction data.

## Motivation
Current metal product data and inspection certificates lack a standardized digital format that encompasses all necessary information for effective material tracking, quality assurance, and regulatory compliance. By creating a Digital Material Passport:

1. Material data becomes machine-readable across the entire supply chain
2. Comprehensive information about origin, manufacturing, properties, and environmental impact can be tracked
3. Regulatory compliance and sustainability reporting become more efficient
4. Product lifecycle management from production to recycling is better supported
5. Stakeholder-specific and material-specific requirements can be addressed in a consistent format

### Backwards Compatibility
Backwards compatibility with the current Metals schema v1.0.0 in schemas/Metals/v1.0.0/ is not the goal. The new schema shall implement all learnings from this inital version without considering any aspects or technical details of it.

## Tasks

### Write general requirements
* Coverage steel, aluminium, titan, copper and other metals
* Flexible and extensible data structure
* Not to deep hierachary of objects
* Support for simple transformation to 
  * XML
  * AAS Submodels 
* Fundamental model for create of specifications to automate validation


#### Aspects
* All aspects can be found in `specifications/Metals/v1.0.0/fam_*.md`
* Review all and create review.md with questions, comments, enhancements and contradications found.
* Manual review
* Create an AspectModelOverview.md 
* Add to git and commit

### Write features for PDF rendering

* Use the template `.github/ISSUE_TEMPLATE/feature-request.md` to write feature requests for each numbered feature
* Store feature request as `<feat>_<title of feature>.md` in specifications/Metals/v1.0.0.

#### Features
1. PDF/A-3 compliance
2. Multi language support
  * Lookup of translations from `translation.json` 
  * Support of non-latin character sets such as Chinese, Korean and others
  * Localization of date format
  * Localization of number format
  * Localization of address format
  * Localization of phone numbers
3. Rendering in 2 languages
4. Support of rendering of inline images
  * Manufacturer logo
  * Validator stamps and signatures
  * Markings such as CE, UKCA and others
5. Numbering of pages
6. Prevention of page breaks in tables
7. Rendering of linked PDF documents, e.g. Declaration of Performance
8. Rendering of linked images, e.g. curves from tests
9. Embedding the JSON document as an attachement to the PDF


### Design the JSON Schema
* Step by step for each aspect
* Validate the JSON schema against `schema-2019-09`.
* Review implementation of each aspect and commit with link to Github issue

### Create fixtures
* Create assets for embedding in fixtures for PDF, .png, .xml, .json
* Create assets for linking in fixtures for PDF, .png, .xml, .json
* Wait until assets for linking are stored on S3 and links are provided.
* Create fixtures to cover each aspect
* Create fixture with maximum aspects and minimum aspects
* Add new schema to validate_spec.js
* Run validation

### Write features for PDF rendering

* Use the template `.github/ISSUE_TEMPLATE/feature-request.md` to write feature requests for each numbered feature
* Store feature request as `<feat>/<title of feature>.md` in specifications/Metals/v1.0.0.

#### Features
  1. PDF/A-3 compliance
  2. Multi language support
    * Lookup of translations from `translation.json` 
    * Support of non-latin character sets such as Chinese, Korean and others
    * Localization of date format
    * Localization of number format
    * Localization of address format
    * Localization of phone numbers
  3. Rendering in 2 languages
  4. Support of rendering of inline images
    * Manufacturer logo
    * Validator stamps and signatures
    * Markings such as CE, UKCA and others
  5. Numbering of pages
  6. Prevention of page breaks in tables
  7. Rendering of linked PDF documents, e.g. Declaration of Performance
  8. Rendering of linked images, e.g. curves from tests
  9. Embedding the JSON document as an attachement to the PDF
