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


// const url = 'http://localhost:8080/render';
const url = 'http://localhost:8080/api/validate';
// const url = 'https://schema-service-4451088b7fea.herokuapp.com/render';

// axios.post(url, json_data, {
//     responseType: 'arraybuffer',
//     params: { schemaType: 'CoA', schemaVersion: 'v1.1.0', languages: 'CN, EN' },
// })
//     .then(response => {
//         if (response.status === 200) {
//             fs.writeFileSync('output.pdf', response.data, 'binary');
//             console.log(response.data);
//             console.log("PDF saved as 'output.pdf'.");
//         } else {
//             console.log('Error:', response.status);
//         }
//     })
//     .catch(error => {
//         console.error('Error:', error.message);
//     });


axios.post(url, merged_json_data_schema, {
    params: { schemaType: 'CoA', schemaVersion: 'v1.1.0' },
})
    .then(response => {
        if (response.status === 200) {
            const isSuccess = response.data;
            console.log('Success:', isSuccess);
        } else {
            console.log('Error:', response.status);
        }
    })
    .catch(error => {
        console.error('Error:', error.message);
    });