const axios = require('axios');
const path = require('path');

const filePath = path.join(
  __dirname,
  'src',
  'main',
  'resources',
  'schemas',
  'CoA',
  'v1.1.0',
  'valid-cert.json'
);
const jsonData = require(filePath);

const url = 'http://localhost:8080/api/validate';
// const url = 'https://schema-service-4451088b7fea.herokuapp.com/api/validate';

axios
  .post(url, jsonData, {
    params: { schemaType: 'CoA', schemaVersion: 'v1.1.0' },
  })
  .then((response) => {
    if (response.status === 200) {
      console.log(response.data);
    } else {
      console.log('Error:', response.status);
    }
  })
  .catch((error) => {
    console.error('Error:', error.message);
  });
