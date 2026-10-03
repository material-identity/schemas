package com.materialidentity.schemaservice;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.nio.file.Paths;

import org.junit.jupiter.api.Test;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.materialidentity.schemaservice.config.SchemaControllerConstants;

/**
 * The render pipeline loads Metals' singular translation.json as Root/Translations
 * (material-identity/schemas#331), with keys made legal XML names, and the test-mode watermark
 * still resolves the same text from it.
 */
class TranslationLoaderTest {

    private static final ObjectMapper MAPPER = new ObjectMapper();

    private static String pattern(String family, String version) {
        return Paths.get("schemas", family, version,
                SchemaControllerConstants.JSON_TRANSLATIONS_FILE_NAME_PATTERN).toString();
    }

    @Test
    void loadsMetalsSingularTranslationFile() throws Exception {
        JsonNode labels = new TranslationLoader(pattern("Metals", "v0.1.1"), new String[] { "EN" })
                .load().get("DigitalMaterialPassport");
        assertEquals("Cast Number", labels.get("CastNumber").asText());
    }

    @Test
    void englishOnlyCertificateGetsEnglishLabelsOnly() throws Exception {
        JsonNode labels = new TranslationLoader(pattern("Metals", "v0.1.1"), new String[] { "EN" })
                .load().get("DigitalMaterialPassport");
        assertEquals("Heat Number", labels.get("HeatNumber").asText());
        assertFalse(labels.get("HeatNumber").asText().contains(" / "));
    }

    @Test
    void bilingualCertificateJoinsLabelsInLanguageOrder() throws Exception {
        JsonNode labels = new TranslationLoader(pattern("Metals", "v0.1.1"), new String[] { "EN", "DE" })
                .load().get("DigitalMaterialPassport");
        assertEquals("Cast Number / Gussnummer", labels.get("CastNumber").asText());
    }

    @Test
    void enumValueKeysBecomeLegalXmlNames() throws Exception {
        JsonNode labels = new TranslationLoader(pattern("Metals", "v0.1.1"), new String[] { "EN" })
                .load().get("DigitalMaterialPassport");
        assertEquals("1/4 Thickness", labels.get("_1_4T").asText());
        assertEquals("Quenching and Tempering", labels.get("Quenching_and_Tempering").asText());
        assertFalse(labels.has("1/4T"));
    }

    @Test
    void sanitizingLeavesOtherFamiliesUnchanged() throws Exception {
        for (String[] familyVersion : new String[][] {
                { "CoA", "v1.1.0" }, { "EN10168", "v0.5.0" }, { "ForestrySource", "v1.1.0" } }) {
            JsonNode loaded = new TranslationLoader(pattern(familyVersion[0], familyVersion[1]),
                    new String[] { "EN", "DE" }).load();
            assertTrue(loaded.size() > 0, familyVersion[0] + " translations should load");
            assertEquals(loaded, XmlKeySanitizer.sanitize(loaded),
                    familyVersion[0] + " keys must already be legal XML names");
        }
    }

    @Test
    void metalsWatermarkTextIsUnchanged() {
        String metals = pattern("Metals", "v0.1.1");
        assertEquals("PREVIEW — NOT A VALID CERTIFICATE", WatermarkManager.resolveText(metals, "EN"));
        assertEquals("VORSCHAU — KEIN GÜLTIGES ZERTIFIKAT", WatermarkManager.resolveText(metals, "DE"));
    }

    @Test
    void sanitizerRewritesOnlyIllegalKeys() throws Exception {
        assertEquals("CastNumber", XmlKeySanitizer.sanitizeKey("CastNumber"));
        assertEquals("_1_4T", XmlKeySanitizer.sanitizeKey("1/4T"));
        assertEquals("L-T", XmlKeySanitizer.sanitizeKey("L-T"));
        assertEquals("a_b", XmlKeySanitizer.sanitizeKey("a b"));
        assertEquals("ns_name", XmlKeySanitizer.sanitizeKey("ns:name"));
        assertEquals("_", XmlKeySanitizer.sanitizeKey(""));

        JsonNode out = XmlKeySanitizer.sanitize(MAPPER.readTree("""
                { "a b": "x", "a_b": "y", "list": [ { "1st": 1 } ], "keep": "v a l / u e" }
                """));
        assertEquals(4, out.size());
        assertTrue(out.has("a_b") && out.has("_a_b"));
        assertEquals(1, out.at("/list/0/_1st").asInt());
        assertEquals("v a l / u e", out.get("keep").asText());
    }
}
