const fs = require('fs');
const { resolve, join } = require('path');
const { SCHEMA_TYPES, createAjvInstance } = require('../lib/validator');

// Use schema types from validator module
const fixtureVersions = SCHEMA_TYPES;

function getCertPaths() {
  const validCerts = [];
  Object.keys(fixtureVersions).forEach((cert) => {
    fixtureVersions[cert].forEach((version) => {
      validCerts.push(`${cert}/${version}`);
    });
  });
  return validCerts;
}

// createAjvInstance is now imported from validator module

function getAllSchemaPaths(dir) {
  let schemaPaths = [];

  function findSchemas(currentDir) {
    // Check if directory exists before trying to read it
    if (!fs.existsSync(currentDir)) {
      return;
    }
    
    const files = fs.readdirSync(currentDir);

    files.forEach(file => {
      const fullPath = join(currentDir, file);
      
      // Check if path exists before trying to stat it
      if (!fs.existsSync(fullPath)) {
        return;
      }
      
      const stat = fs.statSync(fullPath);

      if (stat.isDirectory()) {
        findSchemas(fullPath);
      } else if (file === 'schema.json') {
        schemaPaths.push(fullPath);
      }
    });
  }

  findSchemas(dir);
  return schemaPaths;
}


describe('Validate schemas', function() {
  // get the schema name and versions
  const paths = getAllSchemaPaths(resolve(__dirname, '../schemas'));

  paths.forEach((schemaPath) => {
    it(`should validate schema ${schemaPath}`, async () => {
      const localSchema = JSON.parse(fs.readFileSync(schemaPath, 'utf-8'));

      const validateSchema = await createAjvInstance().compileAsync(localSchema);
      expect(() => validateSchema()).not.toThrow();
    });
  });
});

describe('Validate valid certificates against schema files', function() {
  // e.g. ["CoA/v1.1.0", "EN10168/v0.4.1", "Forestry/v0.0.1", "ForestrySource/v0.0.1", "TKR/v0.0.4"]
  const certAndVersionPaths = getCertPaths();

  certAndVersionPaths.forEach((dir) => {
    const fullDirPath = resolve(__dirname, `../test/fixtures/${dir}/`);
    const schemaPath = resolve(__dirname, '../schemas', dir, 'schema.json');
    
    // Skip if fixtures directory doesn't exist (e.g., private schemas in CI)
    if (!fs.existsSync(fullDirPath)) {
      it.skip(`${dir} - fixtures directory not available`, () => {
        console.log(`Skipping tests for ${dir} - fixtures directory not found at ${fullDirPath}`);
      });
      return;
    }
    
    // Skip if schema file doesn't exist
    if (!fs.existsSync(schemaPath)) {
      it.skip(`${dir} - schema file not available`, () => {
        console.log(`Skipping tests for ${dir} - schema.json not found at ${schemaPath}`);
      });
      return;
    }
    
    // Anchored, so invalid_*.json fixtures are not picked up as valid ones
    const regex = /^valid_.+\.json$/
    const validCerts = fs.readdirSync(fullDirPath).filter((file) => regex.test(file));
    const localSchema = JSON.parse(fs.readFileSync(schemaPath, 'utf-8'));

    validCerts.forEach((certificateName) => {
      it(`${dir} - ${certificateName} should be a valid certificate`, async () => {
        const certificatePath = resolve(__dirname, `./fixtures/`, dir, certificateName);
        const certificate = JSON.parse(fs.readFileSync(certificatePath, 'utf8'));
        const validator = await createAjvInstance().compileAsync(localSchema);
        //
        const isValid = await validator(certificate);
        if (!isValid) {
          console.error(`${dir} - ${certificateName} errors:`, validator.errors);
        }
        expect(isValid).toBe(true);
        expect(validator.errors).toBeNull();
      });
    });
  });
});

describe('Generic v0.1.0 rejects certificates without the required parties', function() {
  const fixturesDir = resolve(__dirname, './fixtures/Generic/v0.1.0');
  const schemaPath = resolve(__dirname, '../schemas/Generic/v0.1.0/schema.json');
  const parties = '/DigitalMaterialPassport/TransactionData/Parties';

  // fixture → the error that must be among the validator's errors
  const expectedErrors = {
    'invalid_missing_customer.json': { instancePath: parties, message: "must have required property 'Customer'" },
    'invalid_party_without_email.json': { instancePath: `${parties}/Manufacturer`, message: "must have required property 'Email'" },
    'invalid_party_without_identifier.json': { instancePath: `${parties}/Customer/Identifiers`, message: 'must NOT have fewer than 1 properties' },
    'invalid_identifier_empty.json': { instancePath: `${parties}/Customer/Identifiers/EORI`, message: 'must NOT have fewer than 1 characters' },
    'invalid_identifier_unknown_empty.json': { instancePath: `${parties}/Customer/Identifiers/OtherId`, message: 'must NOT have fewer than 1 characters' },
    'invalid_identifier_unknown_null.json': { instancePath: `${parties}/Customer/Identifiers/Custom`, message: 'must be string' },
  };

  it('has an expected error for every invalid fixture', () => {
    const invalidCerts = fs.readdirSync(fixturesDir).filter((file) => /^invalid_.+\.json$/.test(file));
    expect(invalidCerts.sort()).toEqual(Object.keys(expectedErrors).sort());
  });

  Object.entries(expectedErrors).forEach(([certificateName, expected]) => {
    it(`Generic/v0.1.0 - ${certificateName} should be rejected`, async () => {
      const certificate = JSON.parse(fs.readFileSync(join(fixturesDir, certificateName), 'utf8'));
      const validator = await createAjvInstance().compileAsync(JSON.parse(fs.readFileSync(schemaPath, 'utf-8')));
      expect(validator(certificate)).toBe(false);
      expect(validator.errors).toEqual(expect.arrayContaining([expect.objectContaining(expected)]));
    });
  });
});
