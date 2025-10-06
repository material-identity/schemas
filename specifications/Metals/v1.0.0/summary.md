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
