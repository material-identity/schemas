const axios = require('axios');
const fs = require('fs');
const path = require('path');

const filePath = path.join(__dirname, 'src', 'main', 'resources', 'schemas', 'CoA', 'v1.1.0', 'valid-cert.json');
const schemaPath = path.join(__dirname, 'src', 'main', 'resources', 'schemas', 'CoA', 'v1.1.0', 'schema.json');
const jsonData = require(filePath);
const jsonSchema = require(schemaPath);

const merged_json_data_schema = {
    jsonData,
    jsonSchema
}

const url = 'http://localhost:8080/api/schemas';
// const url = 'https://schema-service-4451088b7fea.herokuapp.com/api/schemas';

axios.get(url)
    .then(response => {
        if (response.status === 200) {
            console.log(response.data);
        } else {
            console.log('Error:', response.status);
        }
    })
    .catch(error => {
        console.error('Error:', error.message);
    });