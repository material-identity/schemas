package com.materialidentity.schemaservice;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.materialidentity.schemaservice.resource.ResourceLoader;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;

/**
 * Refactored TranslationLoader that uses the ResourceLoader abstraction.
 * This allows it to work with both classpath and filesystem resources.
 */
public class StandaloneTranslationLoader {

    private static final ObjectMapper objectMapper = new ObjectMapper();

    private final ResourceLoader resourceLoader;
    private final String translationFilePattern;
    private final String[] languages;

    public StandaloneTranslationLoader(ResourceLoader resourceLoader, String translationFilePattern, String[] languages) {
        this.resourceLoader = resourceLoader;
        this.translationFilePattern = translationFilePattern;
        this.languages = languages;
    }

    public JsonNode load() throws IOException {
        ObjectNode translations = objectMapper.createObjectNode();
        List<InputStream> resources = resourceLoader.getResources(translationFilePattern);
        
        for (InputStream resourceStream : resources) {
            try {
                ObjectNode resourceTranslations = loadTranslationsFromResource(resourceStream);
                JsonMerger.deepMerge(resourceTranslations, translations, null);
            } finally {
                resourceStream.close();
            }
        }
        return translations;
    }

    private ObjectNode loadTranslationsFromResource(InputStream resourceStream) throws IOException {
        JsonNode node = objectMapper.readTree(resourceStream);
        ObjectNode resourceTranslations = objectMapper.createObjectNode();

        for (String language : languages) {
            JsonNode languageNode = node.get(language);
            if (languageNode == null) continue;
            JsonMerger.deepMerge(languageNode, resourceTranslations, " / ");
        }

        return resourceTranslations;
    }
}