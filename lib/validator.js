const Ajv2019 = require('ajv/dist/2019');
const draft7MetaSchema = require('ajv/dist/refs/json-schema-draft-07.json');
const addFormats = require('ajv-formats');
const fs = require('fs');
const { resolve, join } = require('path');

// Schema type configurations
const SCHEMA_TYPES = {
  CoA: ['v1.1.0'],
  EN10168: ['v0.4.1', 'v0.5.0'],
  Forestry: ['v0.0.1'],
  ForestrySource: ['v0.0.1'],
  TKR: ['v0.0.4'],
  "E-CoC": ['v1.0.0'],
  Bluemint: ['v1.0.0'],
  Metals: ['v0.0.1', 'v0.1.0'],
  HKM: ['v1.0.0'],
};

/**
 * Load external file (local or remote)
 */
async function loadExternalFile(filePath, type = 'json') {
  const { promisify } = require('util');
  const readFile = promisify(fs.readFile);
  const statFile = promisify(fs.stat);

  let result;
  if (filePath.startsWith('http')) {
    const axios = require('axios');
    const { data } = await axios.get(filePath, { responseType: type });
    result = data;
  } else {
    const stats = await statFile(filePath);
    if (!stats.isFile()) {
      throw new Error(`Loading error: ${filePath} is not a file`);
    }
    switch (type) {
      case 'json':
        result = JSON.parse((await readFile(filePath, 'utf8')));
        break;
      case 'text':
        result = await readFile(filePath, 'utf-8');
        break;
      default:
        result = fs.createReadStream(filePath);
    }
  }
  return result;
}

/**
 * Create AJV instance with proper configuration
 */
function createAjvInstance() {
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
}

/**
 * Detect certificate type from JSON structure
 */
function detectCertificateType(certificate) {
  // Check RefSchemaUrl FIRST for specific patterns - this is most reliable
  if (certificate.RefSchemaUrl) {
    if (certificate.RefSchemaUrl.includes('forestry-schemas')) {
      return 'Forestry';
    }
    if (certificate.RefSchemaUrl.includes('forestry-source')) {
      return 'ForestrySource';
    }
    if (certificate.RefSchemaUrl.includes('metals')) {
      return 'Metals';
    }
    if (certificate.RefSchemaUrl.includes('e-coc')) {
      return 'E-CoC';
    }
    if (certificate.RefSchemaUrl.includes('bluemint')) {
      return 'Bluemint';
    }
    if (certificate.RefSchemaUrl.includes('tkr')) {
      return 'TKR';
    }
    if (certificate.RefSchemaUrl.includes('coa')) {
      return 'CoA';
    }
    if (certificate.RefSchemaUrl.includes('en10168')) {
      return 'EN10168';
    }
    if (certificate.RefSchemaUrl.includes('hkm')) {
      return 'HKM';
    }
  }
  
  // Fallback to structure-based detection
  if (certificate.ConcessionRequest) {
    return 'HKM';
  }
  
  // Check for EN10168 - should have Certificate field AND specific EN10168 structure
  if (certificate.Certificate && certificate.Certificate.CertificateLanguages) {
    return 'EN10168';
  }
  
  if (certificate.DigitalMaterialPassport) {
    // Check for specific fields within DMP
    if (certificate.DigitalMaterialPassport.Forestry) {
      return 'Forestry';
    }
    if (certificate.DigitalMaterialPassport.ForestrySource) {
      return 'ForestrySource';
    }
    if (certificate.DigitalMaterialPassport.Metals) {
      return 'Metals';
    }
    // Default to CoA if no specific type detected
    return 'CoA';
  }
  
  // CoA certificates have Certificate field but different structure than EN10168
  if (certificate.Certificate) {
    return 'CoA';
  }
  
  if (certificate.Languages) {
    // Default to CoA for certificates with Languages at root level
    return 'CoA';
  }
  
  throw new Error('Unable to detect certificate type from JSON structure');
}

/**
 * Get the latest version for a schema type
 */
function getLatestVersion(schemaType) {
  const versions = SCHEMA_TYPES[schemaType];
  if (!versions || versions.length === 0) {
    throw new Error(`No versions found for schema type: ${schemaType}`);
  }
  return versions[versions.length - 1];
}

/**
 * Get schema path for a given type and version
 */
function getSchemaPath(schemaType, version) {
  const projectRoot = findProjectRoot();
  return resolve(projectRoot, 'schemas', schemaType, version, 'schema.json');
}

/**
 * Find project root by looking for pom.xml
 */
function findProjectRoot() {
  let currentDir = process.cwd();
  while (!fs.existsSync(join(currentDir, 'pom.xml')) && currentDir !== '/') {
    currentDir = resolve(currentDir, '..');
  }
  if (!fs.existsSync(join(currentDir, 'pom.xml'))) {
    throw new Error('Could not find project root (pom.xml not found)');
  }
  return currentDir;
}

/**
 * Validate certificate against specific schema
 */
async function validateCertificate(certificate, schemaType, version) {
  const schemaPath = getSchemaPath(schemaType, version);
  
  if (!fs.existsSync(schemaPath)) {
    throw new Error(`Schema file not found: ${schemaPath}`);
  }
  
  const schema = JSON.parse(fs.readFileSync(schemaPath, 'utf-8'));
  const ajv = createAjvInstance();
  const validator = await ajv.compileAsync(schema);
  
  const isValid = await validator(certificate);
  
  return {
    isValid,
    errors: validator.errors,
    schemaType,
    version,
    schemaPath
  };
}

/**
 * Extract version from RefSchemaUrl if available
 */
function extractVersionFromRefSchemaUrl(certificate) {
  if (!certificate.RefSchemaUrl) {
    return null;
  }
  
  // Match version patterns like v0.4.1, v1.0.0, etc.
  const versionMatch = certificate.RefSchemaUrl.match(/v(\d+\.\d+\.\d+)/);
  return versionMatch ? `v${versionMatch[1]}` : null;
}

/**
 * Auto-detect certificate type and validate
 */
async function validateCertificateAuto(certificate) {
  const schemaType = detectCertificateType(certificate);
  
  // Try to extract version from RefSchemaUrl first, fallback to latest
  const versionFromUrl = extractVersionFromRefSchemaUrl(certificate);
  const version = versionFromUrl || getLatestVersion(schemaType);
  
  return await validateCertificate(certificate, schemaType, version);
}

/**
 * Validate certificate from file path
 */
async function validateCertificateFromFile(filePath, schemaType = null, version = null) {
  if (!fs.existsSync(filePath)) {
    throw new Error(`Certificate file not found: ${filePath}`);
  }
  
  const certificate = JSON.parse(fs.readFileSync(filePath, 'utf-8'));
  
  if (schemaType && version) {
    return await validateCertificate(certificate, schemaType, version);
  } else {
    return await validateCertificateAuto(certificate);
  }
}

/**
 * Format validation errors for display
 */
function formatValidationErrors(errors) {
  if (!errors || errors.length === 0) {
    return 'No validation errors';
  }
  
  return errors.map(error => {
    const path = error.instancePath || 'root';
    const message = error.message || 'Unknown error';
    const value = error.data !== undefined ? ` (got: ${JSON.stringify(error.data)})` : '';
    return `  - ${path}: ${message}${value}`;
  }).join('\n');
}

module.exports = {
  SCHEMA_TYPES,
  detectCertificateType,
  getLatestVersion,
  getSchemaPath,
  validateCertificate,
  validateCertificateAuto,
  validateCertificateFromFile,
  formatValidationErrors,
  createAjvInstance,
  loadExternalFile
};