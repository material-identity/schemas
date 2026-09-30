const { createAjvInstance } = require('../lib/validator');

const schema = require('../schemas/Metals/v0.1.1/schema.json');
const translations = require('../schemas/Metals/v0.1.1/translation.json');
const baseCertificate = require('./fixtures/Metals/v0.1.1/valid_cast_number.json');

let validate;

function certificateWithIdentifiers({ heat, cast }) {
  const certificate = structuredClone(baseCertificate);
  const analysis = certificate.DigitalMaterialPassport.ChemicalAnalysis;
  delete analysis.HeatNumber;
  delete analysis.CastNumber;
  if (heat !== undefined) analysis.HeatNumber = heat;
  if (cast !== undefined) analysis.CastNumber = cast;
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

describe('Metals v0.1.1 CastNumber schema', () => {
  const analysis = schema.$defs.ChemicalAnalysis;

  test('sits directly after HeatNumber in ChemicalAnalysis', () => {
    const keys = Object.keys(analysis.properties);
    expect(keys.indexOf('CastNumber')).toBe(keys.indexOf('HeatNumber') + 1);
  });

  test('requires a heat number or a cast number, not a specific one', () => {
    expect(analysis.required).not.toContain('HeatNumber');
    expect(analysis.required).not.toContain('CastNumber');
    expect(analysis.anyOf).toEqual([
      { required: ['HeatNumber'], properties: { HeatNumber: {} } },
      { required: ['CastNumber'], properties: { CastNumber: {} } },
    ]);
  });

  test('offers DirectChillCasting as a casting method', () => {
    expect(analysis.properties.CastingMethod.enum).toContain('DirectChillCasting');
  });
});

describe('Metals v0.1.1 CastNumber translations', () => {
  test.each(['CastNumber', 'DirectChillCasting'])(
    'defines %s in every translation bundle',
    (key) => {
      Object.values(translations).forEach((translation) => {
        expect(translation.DigitalMaterialPassport[key]).toEqual(expect.any(String));
        expect(translation.DigitalMaterialPassport[key].length).toBeGreaterThan(0);
      });
    }
  );

  test('uses the DMP v1.0 German label for the cast number', () => {
    expect(translations.DE.DigitalMaterialPassport.CastNumber).toBe('Gussnummer');
  });
});

describe('Metals v0.1.1 CastNumber validation', () => {
  test('accepts the representative fixture (DC cast, cast number only)', () => {
    expectValidation(baseCertificate, true);
  });

  test('accepts a heat number only (backward compatibility)', () => {
    expectValidation(certificateWithIdentifiers({ heat: 'H-2025-0417' }), true);
  });

  test('accepts both a heat number and a cast number', () => {
    expectValidation(
      certificateWithIdentifiers({ heat: 'H-2025-0417', cast: 'DC-2025-0417' }),
      true
    );
  });

  test('rejects a chemical analysis with neither number', () => {
    expectValidation(certificateWithIdentifiers({}), false);
  });

  test.each([
    ['empty string', ''],
    ['over 100 characters', 'C'.repeat(101)],
  ])('rejects a cast number that is an %s', (_label, value) => {
    expectValidation(certificateWithIdentifiers({ cast: value }), false);
  });

  test.each([null, 417, true, ['DC-2025-0417'], { id: 'DC-2025-0417' }])(
    'rejects a non-string cast number %p',
    (value) => {
      expectValidation(certificateWithIdentifiers({ cast: value }), false);
    }
  );
});
