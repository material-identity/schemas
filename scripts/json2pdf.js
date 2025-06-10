#!/usr/bin/env node

const fs = require('fs/promises');
const path = require('path');
const { spawn } = require('child_process');

// Command line argument parsing
const args = process.argv.slice(2);
let inputFile = null;
let outputFile = null;

// Parse command line arguments
for (let i = 0; i < args.length; i++) {
  const arg = args[i];
  switch (arg) {
    case '--certificatePath':
    case '--input':
    case '-i':
      inputFile = args[++i];
      break;
    case '--output':
    case '-o':
      outputFile = args[++i];
      break;
    case '--help':
    case '-h':
      showHelp();
      process.exit(0);
      break;
    default:
      if (!inputFile && !arg.startsWith('-')) {
        inputFile = arg;
      } else if (!outputFile && !arg.startsWith('-')) {
        outputFile = arg;
      }
  }
}

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
  
  // Use the pre-built dependency directory instead of running Maven command
  // This is much faster and Maven has already copied all dependencies during build
  cachedClasspath = 'target/classes:target/dependency/*';
  return cachedClasspath;
}

async function convertJsonToPdf(jsonFilePath, pdfFilePath) {
  console.log('Converting JSON to PDF...');
  
  return new Promise((resolve, reject) => {
    const classpath = getClasspath();

    const javaArgs = [
      '-cp', classpath,
      'com.materialidentity.schemaservice.CommandLineApp',
      jsonFilePath,
      pdfFilePath
    ];

    const javaProcess = spawn('java', javaArgs, {
      stdio: ['pipe', 'pipe', 'pipe'],
      cwd: process.cwd()
    });

    let stdoutOutput = '';
    let errorOutput = '';

    javaProcess.stdout.on('data', (data) => {
      stdoutOutput += data.toString();
      // Clean output - no forwarding needed
    });

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
    await fs.access(inputFile);
  } catch (error) {
    console.error(`Error: Input file not found: ${inputFile}`);
    process.exit(1);
  }

  // Set default output file if not provided
  if (!outputFile) {
    const parsedPath = path.parse(inputFile);
    outputFile = path.join(parsedPath.dir, `${parsedPath.name}.pdf`);
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