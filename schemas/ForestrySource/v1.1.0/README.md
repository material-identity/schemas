# ForestrySource v1.1.0 EUDR V3 mapping

Normative reference: _EUDR Information System — Operator API Reference_, DG ENV, documentation version 1.0, API specification V3, released 2026-05-29.

## Mapping contract

- Each ForestrySource `Species` entry maps to one EUDR `CommercialDescription`. Its `Measurements` map to that description's `GoodsMeasure`.
- `PercentageEstimationOrDeviation` maps to EUDR `percentageEstimationOrDeviation`. It is positive, has at most three fractional digits, and has no project-defined maximum because the reference specifies none.
- `NetWeight.Value` and `SupplementaryUnit.Value` are positive, contain at most 16 total and 6 fractional digits, and therefore have a maximum of `9999999999.999999`.
- `SupplementaryUnit.Qualifier` maps to EUDR `supplementaryUnitQualifier`. It is a dedicated required 3–4 character field so existing certificate-side `Unit` and `DisplayUnit` labels remain compatible.
- `Volume` remains available for certificate data but has no direct EUDR V3 `GoodsMeasure` target.
- EUDR's single scientific-name string is serialized as `Genus`, one U+0020 space, then `Species`. The result must contain 1–200 characters. Each component is non-empty and capped at 200; a DDS mapper must enforce the combined limit because JSON Schema cannot constrain the sum of two property lengths.

The API describes the percentage as an estimate or deviation, so rendering uses neutral wording and does not add an automatic `±` sign.

Regenerate the reference PDFs with:

```sh
node scripts/json2pdf.js --include-remote-attachments <fixture.json>
```

## Reference stability

The reference says the V3 WSDLs were not yet accessible and that contracts/documentation could change. Revalidate the published V3 contract before releasing this schema version.
