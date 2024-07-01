package com.materialidentity.schemaservice;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;

import java.io.IOException;
import java.io.InputStream;

public class TranslationLoader {

    private static final ObjectMapper objectMapper = new ObjectMapper();

    private final String translationFilePattern;
    private final String[] languages;

    public TranslationLoader(String translationFilePattern, String[] languages) {
        this.translationFilePattern = translationFilePattern;
        this.languages = languages;
    }

    public JsonNode load() throws IOException {
        PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
        ObjectNode translations = objectMapper.createObjectNode();
        Resource[] resources = resolver.getResources("classpath*:" + translationFilePattern);
        for (Resource resource : resources) {
            ObjectNode resourceTranslations = loadTranslationsFromResource(resource);
            JsonMerger.deepMerge(resourceTranslations, translations, null);
        }
        return translations;
    }

    private ObjectNode loadTranslationsFromResource(Resource resource) throws IOException {
        InputStream is = resource.getInputStream();
        JsonNode node = objectMapper.readTree(is);
        ObjectNode resourceTranslations = objectMapper.createObjectNode();

        for (String language : languages) {
            JsonNode languageNode = node.get(language);
            if (languageNode == null) continue;
            JsonMerger.deepMerge(languageNode, resourceTranslations, " / ");
        }

        return resourceTranslations;
    }
}
