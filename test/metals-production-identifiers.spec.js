const { createAjvInstance } = require('../lib/validator');

const schema = require('../schemas/Metals/v0.1.1/schema.json');
const translations = require('../schemas/Metals/v0.1.1/translation.json');
const baseCertificate = require('./fixtures/Metals/v0.1.1/valid_production_identifiers.json');

const IDENTIFIER_TYPES = [
  'ForgingNumber',
  'CoilId',
  'SlabNumber',
  'IngotNumber',
  'PlateNumber',
  'CastNumber',
  'StrandId',
  'BilletNumber',
  'BloomNumber',
  'Other',
];

let validate;

function certificateWithIdentifiers(identifiers) {
  const certificate = structuredClone(baseCertificate);
  if (identifiers === undefined) {
    delete certificate.DigitalMaterialPassport.Product.ProductionIdentifiers;
  } else {
    certificate.DigitalMaterialPassport.Product.ProductionIdentifiers =
      identifiers;
  }
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

describe('Metals v0.1.1 ProductionIdentifiers translations', () => {
  test.each([
    'ProductionIdentifiers',
    'CustomType',
    'Type',
    'Value',
    'Other',
    ...IDENTIFIER_TYPES.filter((type) => type !== 'Other'),
  ])('defines the %s label in every translation bundle', (key) => {
    Object.values(translations).forEach((translation) => {
      expect(translation.DigitalMaterialPassport[key]).toEqual(
        expect.any(String)
      );
      expect(translation.DigitalMaterialPassport[key].length).toBeGreaterThan(
        0
      );
    });
  });
});

describe('Metals v0.1.1 ProductionIdentifiers validation', () => {
  test('accepts the representative fixture', () => {
    expectValidation(baseCertificate, true);
  });

  test('accepts a certificate without ProductionIdentifiers (backward compatibility)', () => {
    expectValidation(certificateWithIdentifiers(undefined), true);
  });

  test.each(IDENTIFIER_TYPES)('accepts identifier type %s', (type) => {
    expectValidation(
      certificateWithIdentifiers([{ Type: type, Value: 'X-1' }]),
      true
    );
  });

  test('accepts Other with a CustomType', () => {
    expectValidation(
      certificateWithIdentifiers([
        { Type: 'Other', CustomType: 'Bundle Number', Value: 'BDL-118' },
      ]),
      true
    );
  });

  test('accepts multiple identifiers of the same type', () => {
    expectValidation(
      certificateWithIdentifiers([
        { Type: 'ForgingNumber', Value: 'F-8842-1' },
        { Type: 'ForgingNumber', Value: 'F-8842-2' },
      ]),
      true
    );
  });

  test('accepts a 100-character value', () => {
    expectValidation(
      certificateWithIdentifiers([{ Type: 'CoilId', Value: 'C'.repeat(100) }]),
      true
    );
  });

  test.each(IDENTIFIER_TYPES.filter((type) => type !== 'Other'))(
    'rejects CustomType alongside type %s',
    (type) => {
      expectValidation(
        certificateWithIdentifiers([
          { Type: type, CustomType: 'Custom', Value: 'X-1' },
        ]),
        false
      );
    }
  );

  test('rejects a missing Value', () => {
    expectValidation(certificateWithIdentifiers([{ Type: 'CoilId' }]), false);
  });

  test('rejects an empty Value', () => {
    expectValidation(
      certificateWithIdentifiers([{ Type: 'CoilId', Value: '' }]),
      false
    );
  });

  test('rejects a value above 100 characters', () => {
    expectValidation(
      certificateWithIdentifiers([{ Type: 'CoilId', Value: 'C'.repeat(101) }]),
      false
    );
  });

  test('rejects a missing Type', () => {
    expectValidation(certificateWithIdentifiers([{ Value: 'X-1' }]), false);
  });

  test('rejects an unknown Type', () => {
    expectValidation(
      certificateWithIdentifiers([{ Type: 'HeatNumber', Value: 'H-1' }]),
      false
    );
  });

  test('rejects an empty CustomType', () => {
    expectValidation(
      certificateWithIdentifiers([
        { Type: 'Other', CustomType: '', Value: 'X-1' },
      ]),
      false
    );
  });

  test('rejects a CustomType above 50 characters', () => {
    expectValidation(
      certificateWithIdentifiers([
        { Type: 'Other', CustomType: 'C'.repeat(51), Value: 'X-1' },
      ]),
      false
    );
  });

  test('rejects additional properties on an identifier', () => {
    expectValidation(
      certificateWithIdentifiers([
        { Type: 'CoilId', Value: 'C-1', Comment: 'not allowed' },
      ]),
      false
    );
  });

  test('rejects an empty identifier list', () => {
    expectValidation(certificateWithIdentifiers([]), false);
  });

  test('accepts 100 identifiers but rejects 101', () => {
    const identifier = { Type: 'CoilId', Value: 'C-1' };
    expectValidation(
      certificateWithIdentifiers(Array.from({ length: 100 }, () => identifier)),
      true
    );
    expectValidation(
      certificateWithIdentifiers(Array.from({ length: 101 }, () => identifier)),
      false
    );
  });
});
