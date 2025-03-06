require('dotenv').config();
const fs = require('fs');
const path = require('path');
const AWS = require('aws-sdk');

const {
  AWS_ACCESS_KEY_ID,
  AWS_SECRET_ACCESS_KEY,
  AWS_REGION,
  S3_BUCKET_NAME,
} = process.env;

// Configure AWS S3
const s3 = new AWS.S3({
  accessKeyId: AWS_ACCESS_KEY_ID,
  secretAccessKey: AWS_SECRET_ACCESS_KEY,
  region: AWS_REGION
});

async function listFiles() {
  const params = {
    Bucket: S3_BUCKET_NAME
  };

  try {
    const data = await s3.listObjectsV2(params).promise();
    return data.Contents.map(item => item.Key);
  } catch (error) {
    console.error('Error listing files:', error.message);
    return [];
  }
}

async function downloadFile(fullFileName) {
  // Skip directories in S3 (by checking for a trailing slash)
  if (fullFileName.endsWith('/')) {
    return;
  }

  let targetFolder = '';
  let companyDir = '';
  let versionDir = '';

  // Extract version and companyName from the path
  const pathParts = fullFileName.split('/');

  const fileName = pathParts.pop();
  const versionNumber = pathParts.pop();
  const companyName = pathParts.pop();

  if (fullFileName.startsWith('test/fixtures/')) {
    companyDir = path.join(__dirname, 'src/test/resources/schemas', companyName);
    versionDir = path.join(companyDir, versionNumber);
    targetFolder = path.join(versionDir, fileName);
  } else if (fullFileName.startsWith('schemas/')) {
    companyDir = path.join(__dirname, 'src/main/resources/schemas', companyName);
    versionDir = path.join(companyDir, versionNumber);
    targetFolder = path.join(versionDir, fileName);
  } else {
    console.warn(`Skipping file with unrecognized structure: ${fullFileName}`);
    return;
  }

  // Ensure company and version directories exist
  if (!fs.existsSync(companyDir)) {
    fs.mkdirSync(companyDir, { recursive: true });
  }
  if (!fs.existsSync(versionDir)) {
    fs.mkdirSync(versionDir, { recursive: true });
  }

  const params = {
    Bucket: S3_BUCKET_NAME,
    Key: fullFileName
  };

  try {
    const data = await s3.getObject(params).promise();
    const dir = path.dirname(targetFolder);

    // Ensure the directory exists before writing the file
    if (!fs.existsSync(dir)) {
      console.log(`Directory does not exist, skipping: ${dir}`);
      return;
    }

    // Write the file content
    fs.writeFileSync(targetFolder, data.Body);
    console.log(`Downloaded: ${fullFileName} -> ${targetFolder}`);
  } catch (error) {
    console.error(`Error downloading ${fullFileName}:`, error.message);
  }
}

async function main() {
  if (!S3_BUCKET_NAME) {
    console.error('S3_BUCKET_NAME is not defined. Skipping download.');
    return;
  }

  const files = await listFiles();
  await Promise.all(files.map(downloadFile));
  console.log('All files downloaded.');
}

main();
