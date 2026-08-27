const fs = require('fs');
const path = require('path');

const versionDirectory = path.resolve(__dirname, 'fixtures/Metals/v0.1.1');
const schema = JSON.parse(
  fs.readFileSync(
    path.resolve(__dirname, '../schemas/Metals/v0.1.1/schema.json'),
    'utf8'
  )
);
const languages =
  schema.properties.DigitalMaterialPassport.properties.Languages;

describe('Metals v0.1.1 Languages', () => {
  test('declares editor-renderable string enum items', () => {
    expect(languages.items).toEqual({
      type: 'string',
      enum: ['EN', 'DE'],
    });
    expect(languages.minItems).toBe(1);
    expect(languages.uniqueItems).toBe(true);
  });

  test('keeps the fix independent of optional editor defaults', () => {
    // The enum plus uniqueItems already limits the array to two entries, while
    // a default would change editor prepopulation rather than item rendering.
    expect(languages.maxItems).toBeUndefined();
    expect(languages.default).toBeUndefined();
  });

  test('covers EN-only, DE-only, and bilingual fixtures', () => {
    const fixtureLanguages = fs
      .readdirSync(versionDirectory)
      .filter((fileName) => /^valid_.*\.json$/.test(fileName))
      .map((fileName) => {
        const fixture = JSON.parse(
          fs.readFileSync(path.join(versionDirectory, fileName), 'utf8')
        );
        return JSON.stringify(fixture.DigitalMaterialPassport.Languages);
      });

    expect(fixtureLanguages).toEqual(
      expect.arrayContaining([
        JSON.stringify(['EN']),
        JSON.stringify(['DE']),
        JSON.stringify(['EN', 'DE']),
      ])
    );
  });
});
