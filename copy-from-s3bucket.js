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
  let files = [];
  let continuationToken = null;

  try {
    do {
      const params = {
        Bucket: SCHEMAS_PRIVATE_S3_BUCKET_NAME,
        ContinuationToken: continuationToken, // Continue if more that 1000 files
      };

      const data = await s3.send(new ListObjectsV2Command(params));
      files = files.concat(data.Contents?.map(item => item.Key) || []);
      continuationToken = data.NextContinuationToken;

    } while (continuationToken);

    console.log(`✅ Found ${files.length} files in S3.`);
    return files;

  } catch (error) {
    console.error('🚨 Error listing files:', error.message);
    process.exit(1);
  }
}

async function downloadFile(fullFileName) {
  if (fullFileName.endsWith('/')) return;

  let baseDir = '';

  if (fullFileName.startsWith('test/fixtures/')) {
    baseDir = path.join(__dirname, 'test/fixtures');
  } else if (fullFileName.startsWith('schemas/')) {
    baseDir = path.join(__dirname, 'schemas');
  } else {
    console.warn(`⚠️ Skipping unrecognized file structure: ${fullFileName}`);
    return;
  }

  const relativePath = fullFileName.replace(/^test\/fixtures\//, '').replace(/^schemas\//, '');
  const localFilePath = path.join(baseDir, relativePath);

  console.log(`📥 Downloading: ${fullFileName} -> ${localFilePath}`);

  const localDir = path.dirname(localFilePath);
  if (!fs.existsSync(localDir)) {
    fs.mkdirSync(localDir, { recursive: true });
  }

  const params = { Bucket: SCHEMAS_PRIVATE_S3_BUCKET_NAME, Key: fullFileName };

  try {
    const { Body } = await s3.send(new GetObjectCommand(params));
    const fileStream = fs.createWriteStream(localFilePath);
    Body.pipe(fileStream);

    await new Promise((resolve, reject) => {
      fileStream.on('finish', resolve);
      fileStream.on('error', reject);
    });

    console.log(`✅ Successfully downloaded: ${localFilePath}`);
  } catch (error) {
    console.error(`🚨 Error downloading ${fullFileName}:`, error.message);
    process.exit(1);
  }
}

async function main() {
  if (!SCHEMAS_PRIVATE_S3_BUCKET_NAME) {
    console.warn('⚠️ SCHEMAS_PRIVATE_S3_BUCKET_NAME is not defined. Skipping private schemas download.');
    return;
  }

  const files = await listFiles();
  await Promise.all(files.map(downloadFile));

  console.log('🎉 All files downloaded.');
}

main();
