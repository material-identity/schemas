const fs = require('fs');
const path = require('path');
const { SCHEMA_TYPES } = require('../lib/validator');

const fixtureDirectory = path.resolve(
  __dirname,
  'fixtures/ForestrySource/v1.1.0'
);

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
