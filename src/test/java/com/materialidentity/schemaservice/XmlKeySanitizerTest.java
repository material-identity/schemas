package com.materialidentity.schemaservice;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.fasterxml.jackson.dataformat.xml.XmlMapper;
import java.io.StringReader;
import javax.xml.parsers.DocumentBuilderFactory;
import org.w3c.dom.DOMException;
import org.w3c.dom.Document;
import org.junit.jupiter.api.Test;
import org.xml.sax.InputSource;

/** Mirror of the schema repo's XmlKeySanitizerTest for the copy kept in this service. */
class XmlKeySanitizerTest {

    private static final ObjectMapper MAPPER = new ObjectMapper();

    @Test
    void rewritesIllegalKeysAndKeepsLegalOnes() {
        assertEquals("_id", XmlKeySanitizer.sanitizeKey("$id"));
        assertEquals("x-ui-root", XmlKeySanitizer.sanitizeKey("x-ui-root"));
        assertEquals("_1st", XmlKeySanitizer.sanitizeKey("1st"));
        assertEquals("a_b", XmlKeySanitizer.sanitizeKey("a b"));
        assertEquals("ns_name", XmlKeySanitizer.sanitizeKey("ns:name"));
        assertEquals("_", XmlKeySanitizer.sanitizeKey(""));
    }

    @Test
    void recordsOriginalTextOfRewrittenKeys() throws Exception {
        ObjectNode labels = MAPPER.createObjectNode();
        JsonNode out = XmlKeySanitizer.sanitize(MAPPER.readTree("""
            { "Proof strength (MPa)": 640, "1st inspection": "passed", "Yield/Tensile ratio": "0.8",
              "Plain": { "Coating & finish": { "Thickness [µm]": 8 } } }
            """), labels);
        assertEquals(640, out.get("Proof_strength__MPa_").asInt());
        assertEquals("passed", out.get("_1st_inspection").asText());
        assertEquals("0.8", out.get("Yield_Tensile_ratio").asText());
        assertEquals(8, out.get("Plain").get("Coating___finish").get("Thickness___m_").asInt());
        assertEquals("Proof strength (MPa)", labels.get("Proof_strength__MPa_").asText());
        assertEquals("1st inspection", labels.get("_1st_inspection").asText());
        assertEquals("Yield/Tensile ratio", labels.get("Yield_Tensile_ratio").asText());
        assertEquals("Coating & finish", labels.get("Coating___finish").asText());
        assertEquals("Thickness [µm]", labels.get("Thickness___m_").asText(), "µ (U+00B5) is a letter to Java but not an XML name char");
        assertFalse(labels.has("Plain"), "keys that were already legal are not recorded");
    }

    @Test
    void rewrittenNamesAreUniqueAcrossTheDocumentAndNeverShadowLegalKeys() throws Exception {
        ObjectNode labels = MAPPER.createObjectNode();
        JsonNode out = XmlKeySanitizer.sanitize(MAPPER.readTree("""
            { "A": { "a b": 1 }, "B": { "a/b": 2 }, "C": { "a_b": 3 }, "D": { "a b": 4 } }
            """), labels);
        assertEquals(3, out.get("C").get("a_b").asInt(), "an untouched legal key keeps its name");
        assertEquals(1, out.get("A").get("_a_b").asInt(), "the first rewrite moves aside from the legal key");
        assertEquals(2, out.get("B").get("__a_b").asInt(), "a different original never shares a rewritten name");
        assertEquals(4, out.get("D").get("_a_b").asInt(), "the same original maps to the same name everywhere");
        assertEquals("a b", labels.get("_a_b").asText());
        assertEquals("a/b", labels.get("__a_b").asText());
        assertFalse(labels.has("a_b"));
    }

    @Test
    void nestedAndEmptyArraysSurviveXmlMapper() throws Exception {
        JsonNode in = MAPPER.readTree("""
            { "Item": 0, "Rows": [[1, 2], [3]], "Mixed": [1, [2, 3]], "Empty": [], "Flat": [4, 5] }
            """);
        XmlKeySanitizer.StylesheetDocument doc = XmlKeySanitizer.forStylesheet(in);
        assertEquals("_Item", doc.arrayItem());
        String xml = new XmlMapper().writer().withRootName("Root").writeValueAsString(doc.document());
        assertEquals("<Root><Item>0</Item>"
                + "<Rows><_Item>1</_Item><_Item>2</_Item></Rows><Rows><_Item>3</_Item></Rows>"
                + "<Mixed>1</Mixed><Mixed><_Item>2</_Item><_Item>3</_Item></Mixed>"
                + "<Empty/><Flat>4</Flat><Flat>5</Flat></Root>", xml);
    }

    @Test
    void arrayItemNameIsNeverARewrittenKey() throws Exception {
        // "Item" is a legal key, so the array item takes "_Item"; "$Item" would also rewrite to
        // "_Item" and moves aside instead.
        XmlKeySanitizer.StylesheetDocument doc = XmlKeySanitizer.forStylesheet(MAPPER.readTree("""
            { "Item": 0, "$Item": 1, "Rows": [[2]] }
            """));
        assertEquals("_Item", doc.arrayItem());
        assertEquals(1, doc.document().get("__Item").asInt());
        assertEquals("$Item", doc.labels().get("__Item").asText());
        assertEquals(2, doc.document().get("Rows").get(0).get("_Item").get(0).asInt());
    }

    @Test
    void nameTableAgreesWithTheDomForEveryCharacter() throws Exception {
        Document dom = DocumentBuilderFactory.newInstance().newDocumentBuilder().newDocument();
        for (int c = 0; c <= Character.MAX_VALUE; c++) {
            String ch = String.valueOf((char) c);
            int code = c;
            assertEquals(c != ':' && domAccepts(dom, ch), XmlKeySanitizer.isLegalName(ch),
                    () -> String.format("U+%04X as a first character", code));
            assertEquals(c != ':' && domAccepts(dom, "_" + ch), XmlKeySanitizer.isLegalName("_" + ch),
                    () -> String.format("U+%04X inside a name", code));
        }
        for (int cp : new int[] {0x10000, 0x1F600, 0x20000, 0xEFFFF}) {
            String ch = new String(Character.toChars(cp));
            assertFalse(domAccepts(dom, "_" + ch), "the DOM admits no supplementary character in a name");
            assertFalse(XmlKeySanitizer.isLegalName("_" + ch));
        }
    }

    private static boolean domAccepts(Document dom, String name) {
        try {
            dom.createElement(name);
            return true;
        } catch (DOMException e) {
            return false;
        }
    }

    @Test
    void sanitizedKeysSurviveXmlMapperAndTheSecureDomParse() throws Exception {
        ObjectNode labels = MAPPER.createObjectNode();
        JsonNode out = XmlKeySanitizer.sanitize(MAPPER.readTree("""
            { "Smiley 😀": 1, "Größe": 2, "Ωμέγα": 3, "中文": 4, "µm": 5, "a\u200Cb": 6, "e\u0301": 7, "ns:name": 8 }
            """), labels);
        String xml = new XmlMapper().writer().withRootName("Root").writeValueAsString(out);
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        dbf.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
        var doc = dbf.newDocumentBuilder().parse(new InputSource(new StringReader(xml)));
        assertEquals("Root", doc.getDocumentElement().getTagName());
        assertEquals("Smiley 😀", labels.get("Smiley__").asText(), "a supplementary character is rewritten");
        assertEquals("µm", labels.get("_m").asText());
        assertEquals("a\u200Cb", labels.get("a_b").asText());
        assertEquals("ns:name", labels.get("ns_name").asText());
        assertEquals(2, out.get("Größe").asInt(), "umlauts are legal and untouched");
        assertEquals(3, out.get("Ωμέγα").asInt());
        assertEquals(4, out.get("中文").asInt());
        assertEquals(7, out.get("e\u0301").asInt(), "a combining mark is legal mid-name");
        assertFalse(labels.has("Größe"));
    }
}
