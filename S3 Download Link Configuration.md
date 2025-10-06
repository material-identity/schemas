# S3 Download Link Configuration

## Problem
PDF links to `HarvestUnitsDownloadURL` open the file in the browser instead of triggering a direct download.

## Solution
Set the `Content-Disposition` metadata on the S3 object to force downloads:

**Metadata Key:** `Content-Disposition`
**Metadata Value:** `attachment; filename="harvest-units.csv"`

### Method 1: AWS Console
1. Navigate to S3 in AWS Console
2. Open your bucket and locate the file
3. Select the file (checkbox)
4. Click **Actions** → **Edit metadata**
5. Click **Add metadata**
6. Select **System defined** metadata type
7. Choose **Content-Disposition** from the dropdown
8. Enter value: `attachment; filename="harvest-units.csv"` (adjust filename as needed)
9. Click **Save changes**

### Method 2: AWS CLI
For a single file:
```bash
aws s3 cp s3://your-bucket/path/to/file.csv s3://your-bucket/path/to/file.csv \
  --metadata-directive REPLACE \
  --content-disposition "attachment; filename=\"harvest-units.csv\"" \
  --acl public-read
```

For multiple files (batch update):
```bash
# List all CSV files and update metadata
aws s3 ls s3://your-bucket/path/ --recursive | grep ".csv" | awk '{print $4}' | while read file; do
  aws s3 cp s3://your-bucket/$file s3://your-bucket/$file \
    --metadata-directive REPLACE \
    --content-disposition "attachment" \
    --acl public-read
done
```

### Method 3: Programmatic Upload (Future uploads)
When uploading files via code, include the `ContentDisposition` parameter:

**AWS SDK v3 (Node.js):**
```javascript
import { S3Client, PutObjectCommand } from '@aws-sdk/client-s3';

const s3Client = new S3Client({ region: 'your-region' });

await s3Client.send(new PutObjectCommand({
  Bucket: 'your-bucket',
  Key: 'path/to/harvest-units.csv',
  Body: fileContent,
  ContentDisposition: 'attachment; filename="harvest-units.csv"',
  ACL: 'public-read'
}));
```

**AWS SDK v2 (Node.js):**
```javascript
const AWS = require('aws-sdk');
const s3 = new AWS.S3();

await s3.putObject({
  Bucket: 'your-bucket',
  Key: 'path/to/harvest-units.csv',
  Body: fileContent,
  ContentDisposition: 'attachment; filename="harvest-units.csv"',
  ACL: 'public-read'
}).promise();
```

**Python (boto3):**
```python
import boto3

s3 = boto3.client('s3')

s3.put_object(
    Bucket='your-bucket',
    Key='path/to/harvest-units.csv',
    Body=file_content,
    ContentDisposition='attachment; filename="harvest-units.csv"',
    ACL='public-read'
)
```

### Result
Once the `Content-Disposition` metadata is set, clicking the link in the PDF will download the file instead of opening it in the browser. No changes to the XSL stylesheet are required.

### Verification
To verify the metadata is set correctly:

**AWS Console:**
- Select the file → Properties tab → Metadata section

**AWS CLI:**
```bash
aws s3api head-object --bucket your-bucket --key path/to/file.csv
```

Look for `"ContentDisposition": "attachment; filename=\"harvest-units.csv\""` in the output.
