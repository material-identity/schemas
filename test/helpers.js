const { promisify } = require('util');
const { Agent: HttpAgent } = require('http');
const { Agent: HttpsAgent } = require('https');
const axios = require('axios');
const fs = require('fs');

// these are copies from schema-tools-utils as the originals will be deprecated eventually

function readFile(path, encoding) {
  return promisify(fs.readFile)(path, encoding);
}

function statFile(path) {
  return promisify(fs.stat)(path);
}

const axiosInstance = axios.create({
  timeout: 8000,
  httpAgent: new HttpAgent({ keepAlive: true }),
  httpsAgent: new HttpsAgent({ keepAlive: true }),
  maxRedirects: 10,
  maxContentLength: 50 * 1000 * 1000,
});

async function loadExternalFile(
  filePath,
  type = 'json',
) {
  let result;
  if (filePath.startsWith('http')) {
    const options = {
      responseType: type,
    };
    const { data } = await axiosInstance.get(filePath, options);
    result = data;
  } else {
    const stats = await statFile(filePath);
    if (!stats.isFile()) {
      throw new Error(`Loading error: ${filePath} is not a file`);
    }
    switch (type) {
      case 'json':
        result = JSON.parse((await readFile(filePath, 'utf8')));
        break;
      case 'text':
        result = await readFile(filePath, 'utf-8');
        break;
      case 'arraybuffer':
        result = await readFile(filePath, null);
        break;
      default:
        result = fs.createReadStream(filePath);
    }
  }
  return result;
}

module.exports = {
  loadExternalFile,
};