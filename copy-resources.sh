# This script copies the resources from the schemas directory 
# to the src/main/resources/schemas directory before the build step
rsync -avm --include='*/' --include='translations.json' --include='stylesheet.xsl' --exclude='*' ./schemas/ ./src/main/resources/schemas/