const fs = require('fs');
const path = require('path');
const { SCHEMA_TYPES, createAjvInstance } = require('../lib/validator');

const schema = require('../schemas/ForestrySource/v1.1.0/schema.json');
const baseCertificate = require('./fixtures/ForestrySource/v1.1.0/valid_forestry_source_DMP_01.json');
const fixtureDirectory = path.resolve(
  __dirname,
  'fixtures/ForestrySource/v1.1.0'
);

let validate;

function certificateWithMeasurements(measurements) {
  const certificate = structuredClone(baseCertificate);
  certificate.DigitalMaterialPassport.Products[0].ListOfSpecies[0].Measurements =
    measurements;
  return certificate;
}

function expectValidation(certificate, expected) {
  const valid = validate(certificate);
  if (valid !== expected) {
    console.error(validate.errors);
  }
  expect(valid).toBe(expected);
}

beforeAll(async () => {
  validate = await createAjvInstance().compileAsync(schema);
});

describe('ForestrySource v1.1.0 registration', () => {
  test('is registered and every copied fixture references v1.1.0', () => {
    expect(SCHEMA_TYPES.ForestrySource).toContain('v1.1.0');

    const fixtures = fs
      .readdirSync(fixtureDirectory)
      .filter((fileName) => /^valid_.*\.json$/.test(fileName));

    expect(fixtures.length).toBeGreaterThan(0);
    fixtures.forEach((fileName) => {
      const fixture = JSON.parse(
        fs.readFileSync(path.join(fixtureDirectory, fileName), 'utf8')
      );
      expect(fixture.RefSchemaUrl).toContain(
        '/forestry-source-schemas/v1.1.0/schema.json'
      );
    });
  });
});

describe('ForestrySource v1.1.0 EUDR quantities', () => {
  test('accepts the representative percentage-only fixture', () => {
    expectValidation(baseCertificate, true);
  });

  test('accepts a positive percentage above 100 because V3 defines no maximum', () => {
    expectValidation(
      certificateWithMeasurements({ PercentageEstimationOrDeviation: 125.125 }),
      true
    );
  });

  test.each([0, -1, 12.3456])('rejects invalid percentage %s', (value) => {
    expectValidation(
      certificateWithMeasurements({ PercentageEstimationOrDeviation: value }),
      false
    );
  });

  test('accepts the maximum six-decimal net weight', () => {
    expectValidation(
      certificateWithMeasurements({
        NetWeight: { Value: Number('9999999999.999999'), Unit: 'kg' },
      }),
      true
    );
  });

  test.each([0, -1, 10000000000, 1.0000001])(
    'rejects invalid net weight %s',
    (value) => {
      expectValidation(
        certificateWithMeasurements({
          NetWeight: { Value: value, Unit: 'kg' },
        }),
        false
      );
    }
  );

  test('requires at least one measurement', () => {
    expectValidation(certificateWithMeasurements({}), false);
  });
});

describe('ForestrySource v1.1.0 supplementary quantities', () => {
  function supplementaryUnit(Qualifier, Value = 1.123456) {
    const value = {
      Value,
      Unit: 'ton (short)',
      DisplayUnit: 'US Short Tons',
    };
    if (Qualifier !== undefined) {
      value.Qualifier = Qualifier;
    }
    return { SupplementaryUnit: value };
  }

  test.each(['STN', 'BDMT'])('accepts %s', (qualifier) => {
    expectValidation(
      certificateWithMeasurements(supplementaryUnit(qualifier)),
      true
    );
  });

  test.each([undefined, 'TO', 'TONNE'])('rejects qualifier %s', (qualifier) => {
    expectValidation(
      certificateWithMeasurements(supplementaryUnit(qualifier)),
      false
    );
  });

  test('accepts the maximum six-decimal supplementary value', () => {
    expectValidation(
      certificateWithMeasurements(
        supplementaryUnit('STN', Number('9999999999.999999'))
      ),
      true
    );
  });

  test.each([0, -1, 10000000000, 1.0000001])(
    'rejects invalid supplementary value %s',
    (value) => {
      expectValidation(
        certificateWithMeasurements(supplementaryUnit('STN', value)),
        false
      );
    }
  );
});

describe('ForestrySource v1.1.0 scientific-name components', () => {
  test('accepts a 200-character serialized boundary without a 100/100 split', () => {
    const atLimit = structuredClone(baseCertificate);
    atLimit.DigitalMaterialPassport.Products[0].ListOfSpecies[0].ScientificName.Genus =
      'G'.repeat(150);
    atLimit.DigitalMaterialPassport.Products[0].ListOfSpecies[0].ScientificName.Species =
      's'.repeat(49);
    expectValidation(atLimit, true);

    const aboveLimit = structuredClone(atLimit);
    aboveLimit.DigitalMaterialPassport.Products[0].ListOfSpecies[0].ScientificName.Genus =
      'G'.repeat(201);
    expectValidation(aboveLimit, false);
  });
});
