package com.materialidentity.schemaservice;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import java.io.IOException;
import java.io.InputStream;
import java.util.Iterator;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;

public class TranslationLoader {

  private static final ObjectMapper objectMapper = new ObjectMapper();

  private String translationFilePattern;

  // TODO: implement language selector
  private String[] languages;

  public TranslationLoader(String translationFilePattern, String[] languages) {
    this.translationFilePattern = translationFilePattern;
    this.languages = languages;
  }

  public JsonNode load() throws IOException {
    PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
    JsonNode translations = objectMapper.createObjectNode();
    Resource[] resources = resolver.getResources(
      "classpath*:" + translationFilePattern
    );
    for (Resource resource : resources) {
      System.out.println(resource.getURL());

      InputStream is = resource.getInputStream();
      JsonNode node = objectMapper.readTree(is);
      translations = merge(translations, node);
    }
    return translations;
  }

  public static JsonNode merge(JsonNode mainNode, JsonNode updateNode) {
    Iterator<String> fieldNames = updateNode.fieldNames();
    while (fieldNames.hasNext()) {
      String fieldName = fieldNames.next();
      JsonNode jsonNode = mainNode.get(fieldName);
      if (jsonNode != null && jsonNode.isObject()) {
        merge(jsonNode, updateNode.get(fieldName));
      } else {
        if (mainNode instanceof ObjectNode) {
          JsonNode value = updateNode.get(fieldName);
          ((ObjectNode) mainNode).set(fieldName, value);
        }
      }
    }
    return mainNode;
  }
}
