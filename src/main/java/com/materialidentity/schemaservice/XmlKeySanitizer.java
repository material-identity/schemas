package com.materialidentity.schemaservice;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.JsonNodeFactory;
import com.fasterxml.jackson.databind.node.ObjectNode;
import java.util.BitSet;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import org.w3c.dom.DOMException;
import org.w3c.dom.Document;

/**
 * Rewrites JSON object keys so the document survives the XmlMapper JSON → XML conversion (#269).
 * JSON Schema keywords like {@code $schema}, {@code $id}, {@code $ref} and {@code $defs} are not
 * legal XML element names, so a narrowing (a JSON Schema document) cannot enter the legacy render
 * pipeline as-is, and a Generic certificate may carry any property name at all. Every character
 * the XML parser would not accept in a name is replaced with {@code _}, and a leading character
 * that is only legal mid-name (a digit, {@code -}, {@code .}) keeps its value behind a {@code _}
 * prefix. Legality is decided by the DOM implementation itself, probed once per character into a
 * fixed table, so the output is exactly what the parser in {@code XsltTransformer} accepts
 * (supplementary characters such as emoji, and letters like µ, are rewritten; umlauts, Greek and
 * CJK are kept).
 *
 * <p>Rewritten names are allocated once per document: every key that is already legal anywhere in
 * the document is reserved first, and two different originals never share a rewritten name, so a
 * label map (rewritten name → original text) is unambiguous document-wide. Key order is preserved.
 */
public final class XmlKeySanitizer {

    /**
     * What the Generic stylesheet reads: the rewritten {@code document}, the original text of every
     * rewritten key ({@code labels}, rewritten name → original), and the element name that holds an
     * array directly inside an array ({@code arrayItem}), which no key in the document has.
     */
    public record StylesheetDocument(JsonNode document, ObjectNode labels, String arrayItem) {
    }

    private XmlKeySanitizer() {
    }

    /** A deep copy of {@code node} with every object key rewritten to a legal XML element name. */
    public static JsonNode sanitize(JsonNode node) {
        return sanitize(node, null);
    }

    /**
     * As {@link #sanitize(JsonNode)}, additionally recording every rewritten key in {@code labels}
     * (rewritten name → original text) so a stylesheet can show the author's label instead of the
     * XML-safe name.
     */
    public static JsonNode sanitize(JsonNode node, ObjectNode labels) {
        return rewrite(node, new Allocator(legalKeys(node), labels), null);
    }

    /**
     * As {@link #sanitize(JsonNode, ObjectNode)}, in the same single copy also keeping the array
     * shapes the XmlMapper conversion would lose, as it writes an array as repeated elements of its
     * key: an array directly inside an array would merge into its parent, so each one becomes an
     * object holding it under the {@code arrayItem} name; an empty array would vanish, so it
     * becomes {@code null} (an empty element). The name is {@code Item}, prefixed with {@code _}
     * until no key of the result has it.
     */
    public static StylesheetDocument forStylesheet(JsonNode node) {
        Set<String> reserved = legalKeys(node);
        String item = "Item";
        while (reserved.contains(item)) {
            item = "_" + item;
        }
        ObjectNode labels = JsonNodeFactory.instance.objectNode();
        Allocator allocator = new Allocator(reserved, labels);
        allocator.taken.add(item);
        return new StylesheetDocument(rewrite(node, allocator, item), labels, item);
    }

    private static Set<String> legalKeys(JsonNode node) {
        Set<String> reserved = new HashSet<>();
        collectLegalKeys(node, reserved);
        return reserved;
    }

    private static void collectLegalKeys(JsonNode node, Set<String> reserved) {
        if (node.isObject()) {
            node.fields().forEachRemaining(entry -> {
                if (isLegalName(entry.getKey())) {
                    reserved.add(entry.getKey());
                }
                collectLegalKeys(entry.getValue(), reserved);
            });
        } else if (node.isArray()) {
            node.forEach(element -> collectLegalKeys(element, reserved));
        }
    }

    /** {@code item}: null rewrites keys only; a name also keeps nested and empty arrays recognisable. */
    private static JsonNode rewrite(JsonNode node, Allocator allocator, String item) {
        if (node.isObject()) {
            ObjectNode out = JsonNodeFactory.instance.objectNode();
            node.fields().forEachRemaining(entry ->
                    out.set(allocator.nameFor(entry.getKey()), rewrite(entry.getValue(), allocator, item)));
            return out;
        }
        if (node.isArray()) {
            if (item != null && node.isEmpty()) {
                return JsonNodeFactory.instance.nullNode();
            }
            ArrayNode out = JsonNodeFactory.instance.arrayNode(node.size());
            node.forEach(element -> {
                JsonNode copy = rewrite(element, allocator, item);
                out.add(item != null && element.isArray() ? JsonNodeFactory.instance.objectNode().set(item, copy) : copy);
            });
            return out;
        }
        return node;
    }

    /** Document-wide allocation: one rewritten name per original, never colliding with a legal key. */
    private static final class Allocator {
        private final Set<String> taken;
        private final Map<String, String> byOriginal = new HashMap<>();
        private final ObjectNode labels;

        Allocator(Set<String> reserved, ObjectNode labels) {
            this.taken = new HashSet<>(reserved);
            this.labels = labels;
        }

        String nameFor(String original) {
            if (isLegalName(original)) {
                return original;
            }
            String known = byOriginal.get(original);
            if (known != null) {
                return known;
            }
            String name = sanitizeKey(original);
            while (taken.contains(name)) {
                name = "_" + name;
            }
            taken.add(name);
            byOriginal.put(original, name);
            if (labels != null) {
                labels.put(name, original);
            }
            return name;
        }
    }

    /** Whether the parser accepts {@code key} as an element name as it is; a colon never passes. */
    static boolean isLegalName(String key) {
        return !key.isEmpty() && isNameStartChar(key.codePointAt(0))
                && key.codePoints().skip(1).allMatch(XmlKeySanitizer::isNameChar);
    }

    /**
     * Rewrite one key character by character against the parser's own name rules; the colon is
     * rewritten too, as XML would read it as a namespace separator.
     */
    static String sanitizeKey(String key) {
        StringBuilder sb = new StringBuilder(key.length() + 1);
        key.codePoints().forEach(c -> sb.appendCodePoint(isNameChar(c) ? c : '_'));
        if (sb.isEmpty() || !isNameStartChar(sb.codePointAt(0))) {
            sb.insert(0, '_');
        }
        return sb.toString();
    }

    private static boolean isNameStartChar(int c) {
        return c <= Character.MAX_VALUE && NameChars.START.get(c);
    }

    private static boolean isNameChar(int c) {
        return c <= Character.MAX_VALUE && NameChars.PART.get(c);
    }

    /**
     * The DOM's name characters, probed once on first use (about 0.1 s) into two fixed 8 KB tables,
     * so a name check costs no allocation and no exception. Only the Basic Multilingual Plane is
     * probed: the JDK's parser follows the XML 1.0 4th-edition character tables, which admit no
     * supplementary character in a name. The colon is left out of both.
     */
    private static final class NameChars {
        static final BitSet START = new BitSet(Character.MAX_VALUE + 1);
        static final BitSet PART = new BitSet(Character.MAX_VALUE + 1);

        static {
            Document probe;
            try {
                probe = DocumentBuilderFactory.newInstance().newDocumentBuilder().newDocument();
            } catch (ParserConfigurationException e) {
                throw new IllegalStateException("No DOM implementation to probe XML names", e);
            }
            for (int c = 0; c <= Character.MAX_VALUE; c++) {
                if (c == ':') {
                    continue;
                }
                String ch = String.valueOf((char) c);
                START.set(c, accepts(probe, ch));
                PART.set(c, accepts(probe, "_" + ch));
            }
        }

        private static boolean accepts(Document probe, String name) {
            try {
                probe.createElement(name);
                return true;
            } catch (DOMException e) {
                return false;
            }
        }
    }
}
