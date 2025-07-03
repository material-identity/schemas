#!/usr/bin/env node

const { existsSync } = require('fs');
const { access } = require('fs/promises');
const { join, dirname, parse } = require('node:path');
const { spawn } = require('child_process');
const { parseArgs } = require('node:util');
const { validateCertificateFromFile, formatValidationErrors } = require('../lib/validator');

// Command line argument parsing using Node.js built-in parseArgs
const options = {
  input: {
    type: 'string',
    short: 'i',
  },
  output: {
    type: 'string',
    short: 'o',
  },
  certificatePath: {
    type: 'string',
  },
  xsltPath: {
    type: 'string',
  },
  help: {
    type: 'boolean',
    short: 'h',
  },
  'skip-validation': {
    type: 'boolean',
  },
};

const { values, positionals } = parseArgs({
  options,
  allowPositionals: true,
  strict: false  // Allow flexibility for backward compatibility
});

// Handle help first
if (values.help) {
  showHelp();
  process.exit(0);
}

// Extract input and output files with backward compatibility
let inputFile = values.input || values.certificatePath || positionals[0];
let outputFile = values.output || positionals[1];
let xsltPath = values.xsltPath;

function showHelp() {
  console.log(`
JSON to PDF Converter (Standalone)

Usage: node json2pdf.js [options] <input-file> [output-file]

Options:
  -i, --input <file>             Input JSON file path
  --certificatePath <file>       Input JSON file path (alias for --input)
  -o, --output <file>            Output PDF file path (optional, defaults to input filename with .pdf extension)
  --xsltPath <file>              Custom XSLT file path for development (overrides default)
  --skip-validation              Skip JSON schema validation before PDF generation
  -h, --help                     Show this help message

Examples:
  node json2pdf.js certificate.json
  node json2pdf.js --input certificate.json --output result.pdf
  node json2pdf.js --certificatePath certificate.json
  node json2pdf.js certificate.json --xsltPath ./schemas/EN10168/v0.5.0/stylesheet.xsl

This tool runs standalone without requiring a web service.
`);
}

// Cache the classpath to avoid running Maven every time
let cachedClasspath = null;

function getClasspath() {
  if (cachedClasspath) {
    return cachedClasspath;
  }

  // Check if Maven build has been completed

  // Find the project root by looking for pom.xml
  let projectRoot = process.cwd();
  while (!existsSync(join(projectRoot, 'pom.xml')) && projectRoot !== '/') {
    projectRoot = dirname(projectRoot);
  }

  const targetClasses = join(projectRoot, 'target', 'classes');
  const targetDependency = join(projectRoot, 'target', 'dependency');

  if (!existsSync(targetClasses)) {
    throw new Error(`
Maven build required! Please run the following commands first:

  chmod +x copy-resources.sh && mvn clean install

This will compile the Java classes and copy all dependencies to target/.
After that, you can use this script.`);
  }

  if (!existsSync(targetDependency)) {
    throw new Error(`
Dependencies not found! Please run the following command:

  mvn clean install

This will download and copy all required dependencies to target/dependency/.`);
  }

  // Use the pre-built dependency directory instead of running Maven command
  // This is much faster and Maven has already copied all dependencies during build
  cachedClasspath = `${targetClasses}:${targetDependency}/*`;
  return cachedClasspath;
}

async function convertJsonToPdf(jsonFilePath, pdfFilePath, xsltPath) {
  console.log('Converting JSON to PDF...');

  return new Promise((resolve, reject) => {
    const classpath = getClasspath();

    // Find the project root by looking for pom.xml
    let projectRoot = process.cwd();
    while (!existsSync(join(projectRoot, 'pom.xml')) && projectRoot !== '/') {
      projectRoot = dirname(projectRoot);
    }

    const javaArgs = [
      '-cp', classpath,
      'com.materialidentity.schemaservice.CommandLineApp',
      jsonFilePath,
      pdfFilePath
    ];

    // Add xslt path if provided
    if (xsltPath) {
      javaArgs.push('--xsltPath', xsltPath);
    }

    const javaProcess = spawn('java', javaArgs, {
      stdio: ['pipe', 'pipe', 'pipe'],
      cwd: projectRoot
    });

    let errorOutput = '';

    javaProcess.stderr.on('data', (data) => {
      errorOutput += data.toString();
      // Clean output - only show actual errors in error handling
    });

    javaProcess.on('error', (error) => {
      reject(new Error(`Failed to start Java process: ${error.message}`));
    });

    javaProcess.on('close', (code) => {
      if (code === 0) {
        resolve(true);
      } else {
        reject(new Error(`Java process exited with code ${code}. Error: ${errorOutput}`));
      }
    });
  });
}

async function main() {
  if (!inputFile) {
    console.error('Error: Input file is required');
    showHelp();
    process.exit(1);
  }

  // Validate input file exists
  try {
    await access(inputFile);
  } catch (error) {
    console.error(`Error: Input file not found: ${inputFile}, error: ${error.message}`);
    process.exit(1);
  }

  // Validate xslt path if provided
  if (xsltPath) {
    try {
      await access(xsltPath);
    } catch (error) {
      console.error(`Error: XSLT file not found: ${xsltPath}, error: ${error.message}`);
      process.exit(1);
    }
  }

  // Set default output file if not provided
  if (!outputFile) {
    const parsedPath = parse(inputFile);
    outputFile = join(parsedPath.dir, `${parsedPath.name}.pdf`);
  }

  console.log(`Input: ${inputFile}`);
  console.log(`Output: ${outputFile}`);
  if (xsltPath) {
    console.log(`XSLT: ${xsltPath}`);
  }

  try {
    // Validate JSON schema before PDF generation (unless skipped)
    if (!values['skip-validation']) {
      console.log('Validating certificate against JSON schema...');
      const validationResult = await validateCertificateFromFile(inputFile);
      
      if (!validationResult.isValid) {
        console.error('\n❌ Certificate validation failed:');
        console.error(`Schema: ${validationResult.schemaType} ${validationResult.version}`);
        console.error('Validation errors:');
        console.error(formatValidationErrors(validationResult.errors));
        console.error('\nUse --skip-validation to bypass validation and generate PDF anyway.');
        process.exit(1);
      }
      
      console.log(`✓ Certificate is valid (${validationResult.schemaType} ${validationResult.version})`);
    } else {
      console.log('⚠️  Skipping validation (--skip-validation flag used)');
    }

    // Convert JSON to PDF using standalone Java application
    await convertJsonToPdf(inputFile, outputFile, xsltPath);
    console.log(`✓ PDF successfully created: ${outputFile}`);
  } catch (error) {
    console.error(`Error: ${error.message}`);
    process.exit(1);
  }
}

// Handle process termination
process.on('SIGINT', () => {
  console.log('\nProcess interrupted');
  process.exit(1);
});

process.on('SIGTERM', () => {
  console.log('\nProcess terminated');
  process.exit(1);
});

// Run the main function
if (require.main === module) {
  main().catch((error) => {
    console.error(`Unexpected error: ${error.message}`);
    process.exit(1);
  });
}

module.exports = { convertJsonToPdf };