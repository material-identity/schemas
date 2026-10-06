// Metals v0.1.1 renders its labels from translation.json (material-identity/schemas#331). An
// English-only certificate (Interfer's production certificates) must render exactly as it did
// before the lookups existed, so every key the stylesheet reads must carry an EN value that is
// character-identical to the stylesheet's fallback literal. Any English drift fails here.
const fs = require('fs');
const path = require('path');

const versionDir = path.resolve(__dirname, '../schemas/Metals/v0.1.1');
const stylesheet = fs.readFileSync(path.join(versionDir, 'stylesheet.xsl'), 'utf8');
const translations = JSON.parse(
  fs.readFileSync(path.join(versionDir, 'translation.json'), 'utf8')
);
const schema = JSON.parse(fs.readFileSync(path.join(versionDir, 'schema.json'), 'utf8'));
const EN = translations.EN.DigitalMaterialPassport;
const DE = translations.DE.DigitalMaterialPassport;

// mi:label('Key', 'Fallback') with two string literals
const staticCall = /mi:label\('([^']*)', '([^']*)'\)/g;
const staticLookups = [...stylesheet.matchAll(staticCall)].map(([, key, fallback]) => ({
  key,
  fallback,
}));

// Lookups whose key comes from the data; each is checked against the schema below.
const dynamicCalls = [
  // production identifier types
  "mi:label(Type, replace(replace(Type, '([a-z])([A-Z])', '$1 $2'), ' Id$', ' ID'))",
  // dimensional tolerance rows
  "mi:label(concat(name(), 'Tolerance'), concat(replace(name(), '([a-z])([A-Z])', '$1 $2'), ' Tolerance'))",
  // business transaction rows (Order / Delivery / Contract)
  'mi:label(name(), name())',
];

// The same fallback computations the stylesheet runs, in JavaScript
const splitCamel = (name) => name.replace(/([a-z])([A-Z])/g, '$1 $2');
const identifierLabel = (type) => splitCamel(type).replace(/ Id$/, ' ID');
const toleranceLabel = (name) => `${splitCamel(name)} Tolerance`;

const identifierTypes = schema.$defs.ProductionIdentifier.properties.Type.enum;
const toleranceNames = Object.keys(
  schema.$defs.DimensionalTolerances.properties.Tolerances.properties
);
const transactionRows = ['Order', 'Delivery', 'Contract'];

const allLookups = [
  ...staticLookups,
  ...identifierTypes.map((type) => ({ key: type, fallback: identifierLabel(type) })),
  ...toleranceNames.map((name) => ({ key: `${name}Tolerance`, fallback: toleranceLabel(name) })),
  ...transactionRows.map((row) => ({ key: row, fallback: row })),
];

describe('Metals v0.1.1 label lookups', () => {
  test('every mi:label call is either a static literal pair or a known dynamic lookup', () => {
    const total = stylesheet.split('mi:label(').length - 1;
    dynamicCalls.forEach((call) => expect(stylesheet).toContain(call));
    expect(total).toBe(staticLookups.length + dynamicCalls.length);
  });

  test('covers the labels the stylesheet prints', () => {
    // a floor, so a refactor that silently drops the lookups fails
    expect(staticLookups.length).toBeGreaterThanOrEqual(90);
  });

  test.each(allLookups.map(({ key, fallback }) => [key, fallback]))(
    'EN %s equals the fallback literal "%s"',
    (key, fallback) => {
      expect(EN[key]).toBe(fallback);
    }
  );

  test.each([...new Set(allLookups.map(({ key }) => key))])('DE defines %s', (key) => {
    expect(DE[key]).toEqual(expect.any(String));
    expect(DE[key].length).toBeGreaterThan(0);
  });

  test.each([...new Set(allLookups.map(({ key }) => key))])(
    '%s is a legal XML element name, so Root/Translations carries it unchanged',
    (key) => {
      expect(key).toMatch(/^[A-Za-z_][A-Za-z0-9._-]*$/);
    }
  );

  test('the bilingual fixture lists both languages', () => {
    const fixture = JSON.parse(
      fs.readFileSync(
        path.resolve(__dirname, 'fixtures/Metals/v0.1.1/valid_bilingual_labels.json'),
        'utf8'
      )
    );
    expect(fixture.DigitalMaterialPassport.Languages).toEqual(['EN', 'DE']);
    expect(fixture.DigitalMaterialPassport.ChemicalAnalysis.CastNumber).toBeDefined();
  });
});
