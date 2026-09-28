const fs = require('fs');
const path = require('path');

const stylesheet = fs.readFileSync(
  path.resolve(__dirname, '../schemas/Metals/v0.1.1/stylesheet.xsl'),
  'utf8'
);
const fixture = JSON.parse(
  fs.readFileSync(
    path.resolve(__dirname, 'fixtures/Metals/v0.1.1/valid_word_wrap_breaks.json'),
    'utf8'
  )
);

// A soft hyphen (U+00AD) is not an invisible break marker: FOP draws its glyph wherever a
// line break is forbidden right after it (e.g. before "-20°C"), and it prints a hyphen at
// every line end it breaks at (material-identity/schema#330).
const SOFT_HYPHEN = /­|&#x0*AD;|&#173;/i;

describe('Metals v0.1.1 word-wrap breaks', () => {
  test('AddWordWrapBreaks inserts a zero-width space after whitespace', () => {
    const template = stylesheet.match(
      /<xsl:template name="AddWordWrapBreaks">[\s\S]*?<\/xsl:template>/
    );
    expect(template).not.toBeNull();
    expect(template[0]).toContain("'$1&#x200B;'");
  });

  test('the stylesheet emits no soft hyphens', () => {
    expect(stylesheet).not.toMatch(SOFT_HYPHEN);
  });

  test('the regression fixture keeps a space-before-hyphen trigger', () => {
    const names = fixture.DigitalMaterialPassport.MechanicalProperties.map(
      (property) => property.PropertyName
    );
    expect(names).toContain(
      'Impact test ISO-V at -20°C (transverse HEAD) - informative'
    );
  });
});
