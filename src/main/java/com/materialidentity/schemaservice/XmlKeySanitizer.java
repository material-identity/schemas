package com.materialidentity.schemaservice;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.JsonNodeFactory;
import com.fasterxml.jackson.databind.node.ObjectNode;
import java.util.HashSet;
import java.util.Set;

/**
 * Rewrites JSON object keys so the document survives the XmlMapper JSON → XML conversion in
 * {@link XsltTransformer}, which writes keys verbatim as element names. Metals' translation.json
 * carries enum values such as {@code 1/4T} or {@code Quenching and Tempering} as keys; loading it
 * as {@code Root/Translations} unsanitized produces XML that does not parse
 * (material-identity/schemas#331). Any character that is illegal in an XML name becomes
 * {@code _}, and a key that cannot start an XML name gets a {@code _} prefix. Legal keys pass
 * through unchanged. Ported from material-identity/schema's {@code :legacy} module.
 */
public final class XmlKeySanitizer {

    private XmlKeySanitizer() {
    }

    /** A deep copy of {@code node} with every object key rewritten to a legal XML element name. */
    public static JsonNode sanitize(JsonNode node) {
        if (node.isObject()) {
            // A key that is already legal owns its name; a rewritten key that lands on a taken
            // name moves aside with a "_" prefix. Otherwise "a b" before "a_b" would take "a_b"
            // and a lookup of a_b would read the wrong value. Key order is preserved.
            Set<String> taken = new HashSet<>();
            node.fieldNames().forEachRemaining(key -> {
                if (sanitizeKey(key).equals(key)) {
                    taken.add(key);
                }
            });
            ObjectNode out = JsonNodeFactory.instance.objectNode();
            var fields = node.fields();
            while (fields.hasNext()) {
                var entry = fields.next();
                String key = sanitizeKey(entry.getKey());
                if (!key.equals(entry.getKey())) {
                    while (taken.contains(key)) {
                        key = "_" + key;
                    }
                    taken.add(key);
                }
                out.set(key, sanitize(entry.getValue()));
            }
            return out;
        }
        if (node.isArray()) {
            ArrayNode out = JsonNodeFactory.instance.arrayNode(node.size());
            node.forEach(element -> out.add(sanitize(element)));
            return out;
        }
        return node;
    }

    /**
     * Rewrite one key: illegal characters → {@code _}, and a leading character that is only legal
     * mid-name (a digit, {@code -}, {@code .}) keeps its value behind a {@code _} prefix.
     */
    static String sanitizeKey(String key) {
        StringBuilder sb = new StringBuilder(key.length() + 1);
        for (int i = 0; i < key.length(); i++) {
            char c = key.charAt(i);
            boolean legal = Character.isLetterOrDigit(c) || c == '-' || c == '.' || c == '_';
            sb.append(legal ? c : '_');
        }
        if (sb.isEmpty() || !(Character.isLetter(sb.charAt(0)) || sb.charAt(0) == '_')) {
            sb.insert(0, '_');
        }
        return sb.toString();
    }
}
