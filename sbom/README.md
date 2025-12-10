# Software Bill of Materials (SBOM)

This directory contains Software Bill of Materials (SBOM) files for each release of this project, generated in compliance with the EU Cyber Resilience Act (CRA) requirements.

## What is an SBOM?

A Software Bill of Materials (SBOM) is a comprehensive inventory of all software components, dependencies, and their relationships within an application. It provides transparency into the software supply chain and is a key requirement for cybersecurity compliance.

## SBOM Formats

We provide SBOMs in two industry-standard formats:

### SPDX (Software Package Data Exchange)
- **Standard**: ISO/IEC 5962
- **File**: `sbom-spdx.json`
- **Use case**: Comprehensive metadata, license compliance, regulatory reporting
- **Specification**: https://spdx.dev/

### CycloneDX
- **Standard**: OWASP project
- **File**: `sbom-cyclonedx.json`
- **Use case**: Security-focused, vulnerability tracking, dependency analysis
- **Specification**: https://cyclonedx.org/

## Accessing SBOMs

### For Released Versions

1. **GitHub Releases**: SBOM files are attached to each release as assets
   - Navigate to [Releases](../../releases)
   - Download `sbom-spdx.json` or `sbom-cyclonedx.json` from the release assets

2. **Repository**: Version-tagged SBOMs are stored in this directory
   - Path: `sbom/<version>/`
   - Contains both SPDX and CycloneDX formats

### For Pull Requests

SBOM files are generated for each pull request and available as workflow artifacts for review purposes.

## SBOM Contents

Each SBOM includes:

- **Component Inventory**: Complete list of all direct and transitive dependencies
- **Metadata**: Component names, versions, licenses, and suppliers
- **Relationships**: Dependency graph showing component relationships
- **Checksums**: SHA-256 digests for integrity verification
- **Timestamps**: Creation date and tool information

## Using SBOMs

### Vulnerability Analysis

SBOMs can be consumed by vulnerability scanners like [Grype](https://github.com/anchore/grype):

```bash
# Download SBOM from release
curl -L -o sbom-spdx.json https://github.com/<org>/<repo>/releases/download/<version>/sbom-spdx.json

# Scan for vulnerabilities
grype sbom:sbom-spdx.json
```

### License Compliance

Use SBOM tools to analyze license obligations:

```bash
# Extract license information
syft sbom-spdx.json -o table --select license
```

### Supply Chain Analysis

Examine dependency relationships and identify potential supply chain risks by analyzing the dependency graph in the SBOM.

## Generation Process

SBOMs are automatically generated using [Syft](https://github.com/anchore/syft) on every release through our CI/CD pipeline. The generation workflow:

1. Scans the entire project directory
2. Catalogs all dependencies (npm, Maven, Python, etc.)
3. Generates SBOMs in both SPDX and CycloneDX formats
4. Attaches SBOMs to GitHub releases
5. Commits version-tagged SBOMs to this directory

## Manual Generation

To manually generate an SBOM:

```bash
# Install Syft
curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin

# Generate SPDX format
syft . -o spdx-json --file sbom-spdx.json

# Generate CycloneDX format
syft . -o cyclonedx-json --file sbom-cyclonedx.json
```

## Compliance & Transparency

These SBOMs are provided to ensure:

- **EU Cyber Resilience Act (CRA) Compliance**: Meeting Annex I requirements for SBOM documentation
- **Supply Chain Transparency**: Full visibility into software components
- **Security Posture**: Enabling vulnerability tracking and risk assessment
- **License Compliance**: Documenting open source license obligations

## Questions or Issues?

For questions about SBOM contents, formats, or usage, please [open an issue](../../issues) or contact the security team.

## References

- [NTIA Minimum Elements for SBOM](https://www.ntia.gov/report/2021/minimum-elements-software-bill-materials-sbom)
- [EU Cyber Resilience Act](https://digital-strategy.ec.europa.eu/en/policies/cyber-resilience-act)
- [SPDX Specification](https://spdx.github.io/spdx-spec/)
- [CycloneDX Specification](https://cyclonedx.org/specification/overview/)
- [Syft Documentation](https://github.com/anchore/syft)
