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

## Geometry (harvest units)

Normative reference for this section: the EUDR Information System's _GeoJSON description_ and _validation rules_ (Operator API Reference v1.2). Applied in place in v1.1.0 (material-identity/schemas#327, #336):

- `Feature.geometry` accepts `Point`, `Polygon`, `MultiPolygon` and `GeometryCollection`; `MultiPolygon` is also accepted as a `GeometryCollection` member. GIS exports of tenures and cutting permits routinely produce `MultiPolygon`.
- Every linear ring has at least 4 positions (RFC 7946 §3.1.6). Ring closure (first position equal to the last) is required by RFC 7946 and by TRACES but cannot be expressed in JSON Schema; it is not enforced here.
- A `Point` is accepted by TRACES only for plots of at most 4 ha. A `Feature` whose geometry is a `Point` therefore requires `properties.Area` in hectares, between 0.0001 and 4. Larger plots are described as `Polygon` or `MultiPolygon`. The rule applies to the feature's own geometry, not to points inside a `GeometryCollection`.
- `properties.ProducerCountry` stays optional in v1.1.0 for backwards compatibility with published certificates. The EUDR Information System requires it per feature on upload, and the EU-minimum families (ForestrySourceEU, ForestryOutputEU) require it in the schema; the platform UI enforces it for v1.1.0.
- The geometry definitions (`Coordinates`, `PolygonCoordinates`, `Point`, `Polygon`, `MultiPolygon`, `GeometryCollection`, `Feature`, `Location`) are one shared block. `test/shared/forestry-geometry-block.json` holds the canonical text and `test/forestry-source-v1.1.spec.js` asserts that this schema matches it; the EU families join that assertion when they are published.

Regenerate the reference PDFs with:

```sh
node scripts/json2pdf.js --include-remote-attachments <fixture.json>
```

## Reference stability

The reference says the V3 WSDLs were not yet accessible and that contracts/documentation could change. Revalidate the published V3 contract before releasing this schema version.
