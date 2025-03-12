# This script copies the resources from the schemas directory and from s3bucket
# to the src/main/resources/schemas directory before the build step
node --version
npm --version
npm ci
node copy-from-s3bucket.js || { echo "Failed to execute copy-from-s3bucket.js"; }
mkdir -p ./src/main/resources/schemas/
rm -rf ./src/main/resources/schemas/*
rsync -avm --include='*/' --include='translations.json' --include='stylesheet.xsl' --include='schema.json' --exclude='*' ./schemas/ ./src/main/resources/schemas/
mkdir -p ./src/test/resources/schemas/
rm -rf ./src/test/resources/schemas/*
rsync -avm --include='*/' ./test/fixtures/ ./src/test/resources/schemas/