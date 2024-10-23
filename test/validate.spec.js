/* eslint-disable no-undef */
const Ajv2019 = require('ajv/dist/2019');
const draft7MetaSchema = require('ajv/dist/refs/json-schema-draft-07.json');
const addFormats = require('ajv-formats');
const fs = require('fs');
const { resolve, join } = require('path');
const { loadExternalFile } = require('./helpers');

const createAjvInstance = () => {
  const ajv = new Ajv2019({
    loadSchema: (uri) => loadExternalFile(uri, 'json'),
    strictSchema: true,
    strictNumbers: true,
    strictRequired: true,
    strictTypes: true,
    allErrors: true,
  });
  ajv.addKeyword('meta:license');
  ajv.addMetaSchema(draft7MetaSchema);
  addFormats(ajv);
  return ajv;
};

function getAllSchemaPaths(dir) {
  let schemaPaths = [];

  function findSchemas(currentDir) {
    const files = fs.readdirSync(currentDir);

    files.forEach(file => {
      const fullPath = join(currentDir, file);
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

describe('Validate', function() {
  const paths = getAllSchemaPaths(resolve(__dirname, '../schemas'));

  paths.forEach((schemaPath) => {
    it(`should validate schema ${schemaPath}`, async () => {
      const localSchema = JSON.parse(fs.readFileSync(schemaPath, 'utf-8'));

      const validateSchema = await createAjvInstance().compileAsync(localSchema);
      expect(() => validateSchema()).not.toThrow();
    });
  });
});
