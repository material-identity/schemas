const axios = require('axios');
const fs = require('fs');
const path = require('path');
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
console.log('Values:', values);
const { certificatePath, output } = values;

if (!certificatePath) {
  console.error('Error: --certificatePath is required');
  process.exit(1);
}

const inputPath = path.resolve(certificatePath);
const certificate = fs.readFileSync(inputPath);

// Determine output path
let outputPath;
if (output) {
  // If output directory is specified, use it with the same filename but .pdf extension
  const inputFilename = path.basename(inputPath, '.json');
  outputPath = path.join(path.resolve(output), `${inputFilename}.pdf`);
} else {
  // Default: save in the same directory as input with .pdf extension
  const inputDir = path.dirname(inputPath);
  const inputFilename = path.basename(inputPath, '.json');
  outputPath = path.join(inputDir, `${inputFilename}.pdf`);
}

const url = 'http://localhost:8001/api/render';
(async () => {
  try {
    const response = await axios.post(url, certificate, {
      headers: {
        'Content-Type': 'application/json',
      },
      responseType: 'arraybuffer',
    });
    if (response.status === 200) {
      // Ensure output directory exists
      const outputDir = path.dirname(outputPath);
      if (!fs.existsSync(outputDir)) {
        fs.mkdirSync(outputDir, { recursive: true });
      }
      
      fs.writeFileSync(outputPath, response.data, 'binary');
      console.log(`PDF saved as '${outputPath}'.`);
    } else {
      console.log('Error:', response.status);
    }
  } catch (error) {
    console.error('Error:', error.message);
    if (axios.isAxiosError(error)) {
      console.error('Error response:', error.response?.data.toString());
    }
  }
})();