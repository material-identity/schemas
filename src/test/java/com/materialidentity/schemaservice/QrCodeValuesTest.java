package com.materialidentity.schemaservice;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Base64;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

/**
 * EN10168 v0.5.0 {@code qr-code} entries get their symbol generated at render time (#346, mirrors
 * material-identity/schema#447): the value is the text the symbol encodes, a ready {@code data:}
 * image is left alone, and the given certificate is never modified. Asserted on the JSON
 * substitution and on the generated XSL-FO — {@link RenderTest} compares extracted text only, and
 * a symbol has none; it does assert that the JSON attached to the PDF is the fixture as issued.
 */
class QrCodeValuesTest {

    private static final ObjectMapper MAPPER = new ObjectMapper();
    private static final Path FIXTURE = Paths.get("test", "fixtures", "EN10168", "v0.5.0", "valid_certificate_11.json");
    private static final Path STYLESHEET = Paths.get("schemas", "EN10168", "v0.5.0", "stylesheet.xsl");
    private static final String URL = "https://dpp.example.org/dpp/steelmill/1607219-0001";
    private static final String PNG = "data:image/png;base64,iVBORw0KGgo=";

    private static ObjectNode entry(String type, String value) {
        ObjectNode entry = MAPPER.createObjectNode();
        entry.put("Key", "Digital Product Passport");
        if (value != null) entry.put("Value", value);
        entry.put("Type", type);
        return entry;
    }

    private static String svgOf(String dataUri) {
        assertTrue(dataUri.startsWith("data:image/svg+xml;base64,"), dataUri.substring(0, Math.min(40, dataUri.length())));
        return new String(Base64.getDecoder().decode(dataUri.substring(dataUri.indexOf(',') + 1)), StandardCharsets.UTF_8);
    }

    @Test
    @DisplayName("A qr-code value is replaced by the SVG data URI of the symbol encoding it")
    void urlBecomesTheSymbol() {
        JsonNode out = QrCodeValues.embedSymbols(entry("qr-code", URL));
        assertEquals(QrSymbol.of(URL).toSvg(), svgOf(out.get("Value").asText()));
        assertEquals("qr-code", out.get("Type").asText());
        assertEquals("Digital Product Passport", out.get("Key").asText());
    }

    @Test
    @DisplayName("A ready data: image keeps rendering as that image — certificates issued earlier do not change")
    void readyImageIsLeftAlone() {
        assertEquals(PNG, QrCodeValues.embedSymbols(entry("qr-code", PNG)).get("Value").asText());
        String upper = "DATA:image/png;base64,iVBORw0KGgo=";
        assertEquals(upper, QrCodeValues.embedSymbols(entry("qr-code", upper)).get("Value").asText());
    }

    @Test
    @DisplayName("Every other type, a blank value and a missing value are untouched")
    void onlyEncodableQrCodeEntriesChange() {
        for (String type : new String[] {"url", "string", "image"}) {
            assertEquals(URL, QrCodeValues.embedSymbols(entry(type, URL)).get("Value").asText(), type);
        }
        assertEquals("  ", QrCodeValues.embedSymbols(entry("qr-code", "  ")).get("Value").asText());
        assertFalse(QrCodeValues.embedSymbols(entry("qr-code", null)).has("Value"));
    }

    @Test
    @DisplayName("Entries are found anywhere in the certificate, and the given node is not modified")
    void walksTheWholeCertificateWithoutMutatingIt() throws Exception {
        JsonNode cert = MAPPER.readTree(FIXTURE.toFile());
        ((ObjectNode) cert.at("/Certificate/Validation/SupplementaryInformation"))
                .set("Z10", entry("qr-code", URL));
        String before = cert.toString();

        JsonNode out = QrCodeValues.embedSymbols(cert);

        assertEquals(before, cert.toString(), "the certificate handed in must stay as issued");
        assertEquals(URL, out.at("/Certificate/ProductDescription/SupplementaryInformation/B20/Value").asText());
        for (String pointer : new String[] {
                "/Certificate/ProductDescription/SupplementaryInformation/B21/Value",
                "/Certificate/Validation/SupplementaryInformation/Z10/Value"}) {
            assertEquals(QrSymbol.of(URL).toSvg(), svgOf(out.at(pointer).asText()), pointer);
        }
    }

    @Test
    @DisplayName("The B-section reaches the stylesheet's qr-code branch: B20 links, B21 draws the symbol")
    void foDrawsTheSymbolNextToTheLink() throws Exception {
        String fo = renderFo(FIXTURE);
        assertTrue(fo.contains("<fo:basic-link external-destination=\"" + URL + "\">"), "B20 should be a link");
        Matcher graphic = Pattern.compile(
                "<fo:external-graphic[^>]*src=\"(data:image/svg\\+xml;base64,[^\"]*)\"[^>]*/>").matcher(fo);
        assertTrue(graphic.find(), "B21 should be drawn from an SVG data URI");
        assertEquals(QrSymbol.of(URL).toSvg(), svgOf(graphic.group(1)));
        // The URL is printed once, as B20's link text; B21 carries it only inside the symbol.
        assertEquals(1, Pattern.compile(Pattern.quote(">" + URL + "<")).matcher(fo).results().count());
        assertTrue(fo.contains("B21 "), "the B21 key row is still printed");
    }

    /** The certificate's XSL-FO as the service hands it to FOP, with the working-tree stylesheet. */
    static String renderFo(Path fixture) throws Exception {
        JsonNode cert = MAPPER.readTree(fixture.toFile());
        JsonNode rendered = QrCodeValues.embedSymbols(cert);
        String[] languages = MAPPER.convertValue(cert.at("/Certificate/CertificateLanguages"), String[].class);
        String translationsPattern = Paths.get("schemas", "EN10168", "v0.5.0", "translation*.json").toString();
        ((ObjectNode) rendered).set("Translations", new TranslationLoader(translationsPattern, languages).load());

        String source = Files.readString(STYLESHEET, StandardCharsets.UTF_8);
        return new XsltTransformer(source, rendered, Paths.get("").toUri().toString()).transform();
    }
}
