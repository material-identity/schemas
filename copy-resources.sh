# This script copies the resources from the schemas directory 
# to the src/main/resources/schemas directory before the build step
mkdir -p ./src/main/resources/schemas/
rm -rf ./src/main/resources/schemas/*
rsync -avm --include='*/' --include='translations.json' --include='stylesheet.xsl' --include='schema.json' --exclude='*' ./schemas/ ./src/main/resources/schemas/
mkdir -p ./src/test/resources/schemas/
rm -rf ./src/test/resources/schemas/*
rsync -avm --include='*/' ./test/fixtures/ ./src/test/resources/schemas/