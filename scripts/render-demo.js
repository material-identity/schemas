const axios = require('axios');
const fs = require('fs');
const path = require('path');

const certificatePath = path.join(
  __dirname,
  // "../src/main/resources/schemas/EN10168/v0.4.1/valid-cert1.json",
  // '../src/main/resources/schemas/CoA/v1.1.0/valid-cert.json',
   '../src/main/resources/schemas/TKR/v0.0.4/valid-cert3.json',
);
const certificate = fs.readFileSync(certificatePath);

const url = 'http://localhost:8081/api/render';
// const url = 'https://schema-service-4451088b7fea.herokuapp.com/api/render';

(async () => {
  try {
    const response = await axios.post(url, certificate, {
      headers: {
        'Content-Type': 'application/json',
      },
      responseType: 'arraybuffer',
      params: {
        schemaType: 'TKR',
        schemaVersion: 'v0.0.4',
        languages: 'EN',
      },
    });
    
    if (response.status === 200) {
      fs.writeFileSync('output.pdf', response.data, 'binary');
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
