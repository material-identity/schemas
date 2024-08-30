const axios = require('axios');
const fs = require('fs');
const path = require('path');
const { parseArgs } = require('node:util');

const options = {
  certificatePath: {
    type: 'string',
  },
  schemaType: {
    type: 'string',
    default: ''
  },
  schemaVersion: {
    type: 'string',
    default: ''
  },
};

const { values } = parseArgs({ options });
console.log('Values:', values);
const { certificatePath, schemaType, schemaVersion } = values;
const certificate = fs.readFileSync(path.resolve(__dirname, certificatePath));
const url = 'http://localhost:8081/api/render';
(async () => {
  try {
    const response = await axios.post(url, certificate, {
      headers: {
        'Content-Type': 'application/json',
      },
      responseType: 'arraybuffer',
      params: {
        ...(schemaType && { schemaType }),
        ...(schemaVersion && { schemaVersion }),
      },
    });
    if (response.status === 200) {
      fs.writeFileSync('./scripts/output/output.pdf', response.data, 'binary');
      console.log(response.data);
      console.log("PDF saved as 'output.pdf'.");
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
