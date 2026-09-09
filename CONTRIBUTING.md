# Contributing

Thanks for your interest in the Material Identity schemas. This document explains
how a schema change gets proposed, implemented and released, and how versioning
works. For questions and general discussion use
[GitHub Discussions](../../discussions); for security issues follow
[SECURITY.md](SECURITY.md).

## What lives where

| Path | Purpose |
| --- | --- |
| `schemas/<SchemaType>/<version>/schema.json` | The JSON Schema for one schema type at one version. Its `$id` is the published URI that consumers reference. |
| `schemas/<SchemaType>/<version>/stylesheet.xsl`, `translations.json` | XSLT and labels used to render a certificate of that version to PDF. |
| `test/fixtures/<SchemaType>/<version>/` | Example certificates (`valid_*.json`) and the reference PDF each one must render to. |
| `lib/validator.js`, `src/main/java/com/materialidentity/schemaservice/config/SchemasAndVersions.java` | The registry of schema types and versions known to the validator and to the service. |
| `src/` | The Spring Boot service that validates and renders certificates. |

## Proposing a schema change

1. **Open an issue first.** Use the *Format Enhancement Proposal (FEP)* template
   for any change to what a certificate can contain: new fields, changed
   constraints, new enum values. Use *Bug Report* for a schema that rejects valid
   data or accepts invalid data, and *Feature Request* for the service or tooling.
   Keep the title prefix the template sets (`fep:`, `bug:`, `feat:`).
2. **Name the source.** A field or constraint should trace to a standard, a
   regulation or a documented industry practice (an EN 10168 box number, an EUDR
   API field, a customer specification). Say which, and link it.
3. **Discuss before implementing.** Maintainers triage the issue. Larger FEPs go
   through the expert-group review listed in the template's acceptance criteria.
   Agree on the target schema version before opening a pull request.
4. **Open a pull request** that references the issue (`Resolves #123`). The PR
   template lists what reviewers check.

## Making the change

A schema change touches more than `schema.json`. Expect to update, in the same
pull request:

- `schema.json`: the change itself, with a `description` on every new property.
- `stylesheet.xsl` and `translations.json`: every new visible field needs a
  rendering and a label in each supported language. A field nobody can see on
  the PDF is a bug.
- `test/fixtures/<SchemaType>/<version>/`: add or extend a `valid_*.json` fixture
  that exercises the change, then regenerate its reference PDF:

  ```shell
  node scripts/json2pdf.js test/fixtures/<SchemaType>/<version>/valid_certificate_1.json
  ```

- Tests: `npm test` validates all fixtures against their schemas; `mvn test` runs
  the service tests, including rendering against the reference PDFs.

Commit messages follow Conventional Commits with the schema type as scope, for
example `feat(metals): add ProductionIdentifiers to Product (#246)`. Commits must
be GPG-signed: the `main` branch requires verified signatures and one approving
review, and CI (tests, Grype vulnerability scan, CodeQL) must pass.

## Versioning

Each schema type is versioned independently. A version is a directory
`schemas/<SchemaType>/v<major>.<minor>.<patch>/`, and the version is part of the
schema's `$id`, for example
`https://schemas.materialidentity.org/metals-schemas/v0.1.1/schema.json`.
Consumers pin a schema by its `$id`.

- **Patch** (`v1.1.0` to `v1.1.1`): clarifications, better descriptions, fixes
  that do not reject any previously valid certificate.
- **Minor** (`v1.1.0` to `v1.2.0`): additive changes such as new optional
  properties, new enum values or new optional sections.
- **Major** (`v1.x` to `v2.0.0`): anything that makes a previously valid
  certificate invalid or changes the meaning of an existing field. Versions
  below `v1.0.0` are pre-release and may take breaking changes as minor bumps.

How version directories are handled:

- **The newest version of a schema type is the working version.** Additive,
  non-breaking changes may land in it in place. A breaking change always goes
  into a new version directory.
- **Once a newer version exists, the older version is frozen.** Its
  `schema.json` does not change any more. Rendering fixes to its
  `stylesheet.xsl` or `translations.json` are still accepted, because they do
  not change what validates.
- **Adding a version** means creating the new directory (usually by copying the
  previous version), updating the `$id`, registering the version in
  `lib/validator.js` and `SchemasAndVersions.java`, and adding fixtures with
  reference PDFs under `test/fixtures/`. The commit that scaffolded
  `ForestrySource/v1.1.0` is a complete example.

Repository releases (`v1.2.1`, ...) version the service and the set of schemas
as a whole. They are cut on `main` after schema changes land, carry the release
notes and the SPDX and CycloneDX SBOMs, and are separate from the per-type schema
versions above.

## Private schemas

Some customer-specific schema types are not published in this repository. CI
pulls them from a private bucket for the maintainers' own tests. A contribution
to a public schema type never needs them.

## License

By contributing you agree that your contribution is licensed under the
[Apache License 2.0](LICENSE) that covers this repository.
