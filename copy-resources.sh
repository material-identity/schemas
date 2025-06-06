#!/bin/bash
# This script copies the resources from the schemas directory and from s3bucket
# to the src/main/resources/schemas directory before the build step
npm ci
node copy-from-s3bucket.js || { echo "Failed to execute copy-from-s3bucket.js"; }
mkdir -p ./src/main/resources/schemas/
rm -rf ./src/main/resources/schemas/*
rsync -avm --include='*/' --include='*' ./schemas/ ./src/main/resources/schemas/
mkdir -p ./src/test/resources/schemas/
rm -rf ./src/test/resources/schemas/*
rsync -avm --include='*/' --include='*' ./test/fixtures/ ./src/test/resources/schemas/

# Build UI and copy files
cd ui || { echo "Failed to enter ui directory"; exit 1; }
npm ci
npx ng build --output-hashing none || { echo "UI build failed"; exit 1; }
cd - || { echo "Failed to return to root directory"; exit 1; }
node copy-bundled-ui.js || { echo "Failed to execute copy-bundled-ui.js"; exit 1; }
