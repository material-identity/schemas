const axios = require('axios');
const fs = require('fs');
const path = require('path');

function getArgumentValue(flag) {
  const index = process.argv.indexOf(flag);
  return (index !== -1 && process.argv[index + 1]) ? process.argv[index + 1] : null;
}
const certificatePathArg = getArgumentValue('--certificatePath');
const schemaTypeArg = getArgumentValue('--schemaType');
const schemaVersionArg = getArgumentValue('--schemaVersion');
const certificatePath = path.resolve(__dirname, certificatePathArg);
const certificate = fs.readFileSync(certificatePath);
const url = 'http://localhost:8081/api/render';
(async () => {
  try {
    const response = await axios.post(url, certificate, {
      headers: {
        'Content-Type': 'application/json',
      },
      responseType: 'arraybuffer',
      params: {
        schemaType: schemaTypeArg,
        schemaVersion: schemaVersionArg,
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
