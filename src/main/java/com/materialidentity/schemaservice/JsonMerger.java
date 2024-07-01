package com.materialidentity.schemaservice;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;

import java.util.Iterator;
import java.util.Optional;

public class JsonMerger {

    private static final ObjectMapper mapper = new ObjectMapper();

    public static ObjectNode deepMerge(JsonNode source, ObjectNode target, String delimiter) {
        Iterator<String> fieldNames = source.fieldNames();
        while (fieldNames.hasNext()) {
            String fieldName = fieldNames.next();
            JsonNode valueSource = source.get(fieldName);
            if (target.has(fieldName)) {
                JsonNode valueTarget = target.get(fieldName);
                target.set(fieldName, mergeValues(valueTarget, valueSource, delimiter));
            } else {
                target.set(fieldName, valueSource);
            }
        }
        return target;
    }

    private static JsonNode mergeValues(JsonNode valueTarget, JsonNode valueSource, String delimiter) {
        if (valueSource.isObject() && valueTarget.isObject()) {
            return deepMerge(valueSource, (ObjectNode) valueTarget, delimiter);
        }
        if (valueSource.isArray() && valueTarget.isArray()) {
            return mergeArrays((ArrayNode) valueSource, (ArrayNode) valueTarget, delimiter);
        }
        return resolveConflict(valueSource, valueTarget, delimiter);
    }

    private static ArrayNode mergeArrays(ArrayNode arr1, ArrayNode arr2, String delimiter) {
        ArrayNode result = mapper.createArrayNode();
        int maxLength = Math.max(arr1.size(), arr2.size());
        for (int i = 0; i < maxLength; i++) {
            JsonNode val1 = i < arr1.size() ? arr1.get(i) : null;
            JsonNode val2 = i < arr2.size() ? arr2.get(i) : null;
            result.add((val1 != null && val2 != null) ? mergeValues(val2, val1, delimiter) : Optional.ofNullable(val1).orElse(val2));
        }
        return result;
    }

    private static JsonNode resolveConflict(JsonNode val1, JsonNode val2, String delimiter) {
        if (val1.equals(val2)) {
            return val1;
        }
        return mapper.getNodeFactory().textNode(Optional.ofNullable(delimiter).map(d -> val2.asText() + d + val1.asText()).orElse(val1.asText()));
    }
}
