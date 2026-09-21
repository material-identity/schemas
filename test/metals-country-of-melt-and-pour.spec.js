const { createAjvInstance } = require('../lib/validator');

const schema = require('../schemas/Metals/v0.1.1/schema.json');
const translations = require('../schemas/Metals/v0.1.1/translation.json');
const baseCertificate = require('./fixtures/Metals/v0.1.1/valid_country_of_melt_and_pour.json');

let validate;

function certificateWithCountries({ origin, meltAndPour }) {
  const certificate = structuredClone(baseCertificate);
  const product = certificate.DigitalMaterialPassport.Product;
  if (origin === undefined) {
    delete product.CountryOfOrigin;
  } else {
    product.CountryOfOrigin = origin;
  }
  if (meltAndPour === undefined) {
    delete product.CountryOfMeltAndPour;
  } else {
    product.CountryOfMeltAndPour = meltAndPour;
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

describe('Metals v0.1.1 CountryOfMeltAndPour schema', () => {
  const properties = schema.$defs.Product.properties;

  test('sits directly after CountryOfOrigin in Product', () => {
    const keys = Object.keys(properties);
    expect(keys.indexOf('CountryOfMeltAndPour')).toBe(
      keys.indexOf('CountryOfOrigin') + 1
    );
  });

  test('has the same shape as CountryOfOrigin (ISO 3166-1 alpha-2)', () => {
    const { description: originDescription, ...originShape } =
      properties.CountryOfOrigin;
    expect(properties.CountryOfMeltAndPour).toEqual({
      ...originShape,
      description: expect.any(String),
    });
    expect(properties.CountryOfMeltAndPour.description).not.toBe(
      originDescription
    );
  });

  test('is optional', () => {
    expect(schema.$defs.Product.required).not.toContain('CountryOfMeltAndPour');
  });
});

describe('Metals v0.1.1 CountryOfMeltAndPour translations', () => {
  test('defines the label in every translation bundle', () => {
    Object.values(translations).forEach((translation) => {
      expect(translation.DigitalMaterialPassport.CountryOfMeltAndPour).toEqual(
        expect.any(String)
      );
      expect(
        translation.DigitalMaterialPassport.CountryOfMeltAndPour.length
      ).toBeGreaterThan(0);
    });
  });
});

describe('Metals v0.1.1 CountryOfMeltAndPour validation', () => {
  test('accepts the representative fixture (origin DE, melt and pour CN)', () => {
    expectValidation(baseCertificate, true);
  });

  test('accepts a certificate without CountryOfMeltAndPour (backward compatibility)', () => {
    expectValidation(
      certificateWithCountries({ origin: 'DE', meltAndPour: undefined }),
      true
    );
  });

  test('accepts melt and pour equal to the country of origin', () => {
    expectValidation(
      certificateWithCountries({ origin: 'DE', meltAndPour: 'DE' }),
      true
    );
  });

  test('accepts melt and pour without a country of origin', () => {
    expectValidation(
      certificateWithCountries({ origin: undefined, meltAndPour: 'CN' }),
      true
    );
  });

  test.each(['AT', 'CN', 'IN', 'TR', 'US'])(
    'accepts the alpha-2 code %s',
    (code) => {
      expectValidation(
        certificateWithCountries({ origin: 'DE', meltAndPour: code }),
        true
      );
    }
  );

  test.each([
    ['lowercase', 'cn'],
    ['mixed case', 'Cn'],
    ['one letter', 'C'],
    ['alpha-3', 'CHN'],
    ['digits', '12'],
    ['letter and digit', 'C1'],
    ['leading space', ' CN'],
    ['trailing space', 'CN '],
    ['empty string', ''],
    ['country name', 'China'],
  ])('rejects %s (%p)', (_label, value) => {
    expectValidation(
      certificateWithCountries({ origin: 'DE', meltAndPour: value }),
      false
    );
  });

  test.each([null, 12, true, ['CN'], { code: 'CN' }])(
    'rejects a non-string value %p',
    (value) => {
      expectValidation(
        certificateWithCountries({ origin: 'DE', meltAndPour: value }),
        false
      );
    }
  );
});
