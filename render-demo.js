const axios = require('axios');
const fs = require('fs');
const path = require('path');

const filePath = path.join(__dirname, 'src', 'main', 'resources', 'schemas', 'CoA', 'v1.1.0', 'valid-cert.json');
const json_data = require(filePath);


const url = 'http://localhost:8080/render';
// const url = 'https://schema-service-4451088b7fea.herokuapp.com/render';

axios.post(url, json_data, {
    responseType: 'arraybuffer',
    params: { schemaType: 'CoA', schemaVersion: 'v1.1.0' },
})
    .then(response => {
        if (response.status === 200) {
            fs.writeFileSync('output.pdf', response.data, 'binary');
            console.log(response.data);
            console.log("PDF saved as 'output.pdf'.");
        } else {
            console.log('Error:', response.status);
        }
    })
    .catch(error => {
        console.error('Error:', error.message);
    });
