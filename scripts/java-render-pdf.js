const { spawn } = require('child_process');
const path = require('path');
const fs = require('fs');
const { parseArgs } = require('node:util');

const options = {
  certificatePath: {
    type: 'string',
  },
  output: {
    type: 'string',
  },
};

const { values } = parseArgs({ options });
const { certificatePath, output } = values;

if (!certificatePath) {
  console.error('Error: --certificatePath is required');
  console.error('Usage: node java-render-pdf.js --certificatePath <path> [--output <directory>]');
  process.exit(1);
}

// Check if input file exists
if (!fs.existsSync(certificatePath)) {
  console.error(`Error: File not found: ${certificatePath}`);
  process.exit(1);
}

// Build Java command arguments
const javaArgs = [
  '-cp',
  'target/classes:target/dependency/*',
  'com.materialidentity.schemaservice.StandaloneRenderPdfCli',
  '--certificatePath',
  certificatePath
];

if (output) {
  javaArgs.push('--output', output);
}

// Check if we need to compile first
const classFile = path.join(__dirname, '..', 'target', 'classes', 'com', 'materialidentity', 'schemaservice', 'StandaloneRenderPdfCli.class');
if (!fs.existsSync(classFile)) {
  console.log('StandaloneRenderPdfCli not compiled. Running mvn compile...');
  const mvn = spawn('mvn', ['compile'], {
    cwd: path.join(__dirname, '..'),
    stdio: 'inherit'
  });
  
  mvn.on('close', (code) => {
    if (code !== 0) {
      console.error('Maven compilation failed');
      process.exit(1);
    }
    runJava();
  });
} else {
  runJava();
}

function runJava() {
  console.log('Running Java PDF renderer...');
  
  const java = spawn('java', javaArgs, {
    cwd: path.join(__dirname, '..'),
    stdio: 'inherit'
  });

  java.on('error', (err) => {
    console.error('Failed to start Java process:', err.message);
    console.error('Make sure Java is installed and in your PATH');
    process.exit(1);
  });

  java.on('close', (code) => {
    if (code !== 0) {
      console.error(`Java process exited with code ${code}`);
      process.exit(code);
    }
  });
}