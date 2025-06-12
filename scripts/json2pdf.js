#!/usr/bin/env node

const { existsSync } = require('fs');
const { access } = require('fs/promises');
const { join, dirname, parse } = require('node:path');
const { spawn } = require('child_process');
const { parseArgs } = require('node:util');

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
  help: {
    type: 'boolean',
    short: 'h',
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

function showHelp() {
  console.log(`
JSON to PDF Converter (Standalone)

Usage: node json2pdf.js [options] <input-file> [output-file]

Options:
  -i, --input <file>             Input JSON file path
  --certificatePath <file>       Input JSON file path (alias for --input)
  -o, --output <file>            Output PDF file path (optional, defaults to input filename with .pdf extension)
  -h, --help                     Show this help message

Examples:
  node json2pdf.js certificate.json
  node json2pdf.js --input certificate.json --output result.pdf
  node json2pdf.js --certificatePath certificate.json

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

async function convertJsonToPdf(jsonFilePath, pdfFilePath) {
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

  // Set default output file if not provided
  if (!outputFile) {
    const parsedPath = parse(inputFile);
    outputFile = join(parsedPath.dir, `${parsedPath.name}.pdf`);
  }

  console.log(`Input: ${inputFile}`);
  console.log(`Output: ${outputFile}`);

  try {
    // Convert JSON to PDF using standalone Java application
    await convertJsonToPdf(inputFile, outputFile);
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