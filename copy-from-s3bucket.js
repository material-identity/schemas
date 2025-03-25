require('dotenv').config();
const fs = require('fs');
const path = require('path');
const { S3, ListObjectsV2Command, GetObjectCommand } = require('@aws-sdk/client-s3');

const {
  SCHEMAS_PRIVATE_AWS_ACCESS_KEY_ID,
  SCHEMAS_PRIVATE_AWS_SECRET_ACCESS_KEY,
  SCHEMAS_PRIVATE_AWS_REGION,
  SCHEMAS_PRIVATE_S3_BUCKET_NAME,
} = process.env;

const s3 = new S3({
  region: SCHEMAS_PRIVATE_AWS_REGION,
  credentials: {
    accessKeyId: SCHEMAS_PRIVATE_AWS_ACCESS_KEY_ID,
    secretAccessKey: SCHEMAS_PRIVATE_AWS_SECRET_ACCESS_KEY,
  },
});

async function listFiles() {
  const params = { Bucket: SCHEMAS_PRIVATE_S3_BUCKET_NAME };
  try {
    const data = await s3.send(new ListObjectsV2Command(params));
    return data.Contents?.map(item => item.Key) || [];
  } catch (error) {
    console.error('Error listing files:', error.message);
    return [];
  }
}

async function downloadFile(fullFileName) {
  if (fullFileName.endsWith('/')) {
    return;
  }

  let baseDir = '';

  if (fullFileName.startsWith('test/fixtures/')) {
    baseDir = path.join(__dirname, 'test/fixtures');
  } else if (fullFileName.startsWith('schemas/')) {
    baseDir = path.join(__dirname, 'schemas');
  } else {
    console.warn(`Skipping file with unrecognized structure: ${fullFileName}`);
    return;
  }

  // Rekonstruiši relativnu strukturu
  const relativePath = fullFileName.replace(/^test\/fixtures\//, '').replace(/^schemas\//, '');
  const localFilePath = path.join(baseDir, relativePath);

  // Kreiraj sve potrebne direktorijume
  const localDir = path.dirname(localFilePath);
  if (!fs.existsSync(localDir)) {
    fs.mkdirSync(localDir, { recursive: true });
  }

  const params = { Bucket: SCHEMAS_PRIVATE_S3_BUCKET_NAME, Key: fullFileName };

  try {
    const { Body } = await s3.send(new GetObjectCommand(params));
    const fileStream = fs.createWriteStream(localFilePath);
    Body.pipe(fileStream);
    console.log(`Downloaded: ${fullFileName} -> ${localFilePath}`);
  } catch (error) {
    console.error(`Error downloading ${fullFileName}:`, error.message);
  }
}

async function main() {
  if (!SCHEMAS_PRIVATE_S3_BUCKET_NAME) {
    console.error('SCHEMAS_PRIVATE_S3_BUCKET_NAME is not defined. Skipping download.');
    return;
  }

  const files = await listFiles();
  await Promise.all(files.map(downloadFile));
  console.log('All files downloaded.');
}

main();
