const Ajv2019 = require('ajv/dist/2019');
const draft7MetaSchema = require('ajv/dist/refs/json-schema-draft-07.json');
const addFormats = require('ajv-formats');
const fs = require('fs');
const { resolve, join } = require('path');
const { loadExternalFile } = require('./helpers');

// add new certs and versions here
const fixtureVersions = {
  CoA: ['v1.1.0'],
  EN10168: ['v0.4.1', 'v0.5.0'],
  Forestry: ['v0.0.1'],
  ForestrySource: ['v0.0.1'],
  TKR: ['v0.0.4'],
  "E-CoC": ['v1.0.0'],
  Bluemint: ['v1.0.0'],
  Metals: ['v0.0.1'],
  HKM: ['v1.0.0'],
}

function getCertPaths() {
  const validCerts = [];
  Object.keys(fixtureVersions).forEach((cert) => {
    fixtureVersions[cert].forEach((version) => {
      validCerts.push(`${cert}/${version}`);
    });
  });
  return validCerts;
}

const createAjvInstance = () => {
  const ajv = new Ajv2019({
    loadSchema: (uri) => loadExternalFile(uri, 'json'),
    strictSchema: true,
    strictNumbers: true,
    strictRequired: true, 
    strictTypes: true,
    allErrors: true,
    discriminator: true,
  });
  ajv.addKeyword('meta:license');
  ajv.addMetaSchema(draft7MetaSchema);
  addFormats(ajv);
  return ajv;
};

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
    
    const regex = /valid_.+\.json/
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
