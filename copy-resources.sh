# This script copies the resources from the schemas directory 
# to the src/main/resources/schemas directory before the build step
mkdir -p ./src/main/resources/schemas/
rsync -avm --include='*/' --include='translations.json' --include='stylesheet.xsl' --exclude='*' ./schemas/ ./src/main/resources/schemas/
mkdir -p ./src/test/resources/schemas/
rsync -avm --include='*/' ./schemas/ ./src/test/resources/schemas/