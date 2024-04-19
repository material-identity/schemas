const axios = require('axios');
const fs = require('fs');
const path = require('path');

const url = 'http://localhost:8080/render';
const params = { schemaType: 'CoA', schemaVersion: 'v1.1.0' };

const filePath = path.join(__dirname, 'src', 'main', 'resources', 'schemas', 'CoA', 'v1.1.0', 'valid-cert.json');

// Read JSON data from file
const json_data = require(filePath);

// const headers = { 'Content-Type': 'application/json' };

axios.post(url, json_data, { params })
    .then(response => {
        if (response.status === 200) {
            fs.writeFileSync('output.pdf', response.data, 'binary');
            console.log("PDF saved as 'output.pdf'.");
        } else {
            console.log('Error:', response.status);
        }
    })
    .catch(error => {
        console.error('Error:', error.message);
    });
