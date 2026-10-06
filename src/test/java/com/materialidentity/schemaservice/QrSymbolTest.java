// SPDX-License-Identifier: Apache-2.0
package com.materialidentity.schemaservice;

import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.decoder.Decoder;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;

import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * The shared QR encoder, verified by decoding its output back — asserting that the encoder was
 * called with the right string would only test that the code says what it says.
 */
class QrSymbolTest {

    private static final String URL = "https://dpp.s1seven.com/dpp/sms/H26-204517";

    /** The modules an SVG's {@code M x yhWv1h-Wz} runs paint, without the quiet zone. */
    static BitMatrix modulesOf(String svg) {
        int size = Integer.parseInt(match(svg, "data-modules=\"(\\d+)\""));
        String d = match(svg, " d=\"([^\"]*)\"");
        BitMatrix bits = new BitMatrix(size, size);
        Matcher run = Pattern.compile("M(\\d+) (\\d+)h(\\d+)v1h-\\d+z").matcher(d);
        while (run.find()) {
            int x = Integer.parseInt(run.group(1)) - QrSymbol.QUIET_ZONE;
            int y = Integer.parseInt(run.group(2)) - QrSymbol.QUIET_ZONE;
            for (int i = 0; i < Integer.parseInt(run.group(3)); i++) {
                bits.set(x + i, y);
            }
        }
        return bits;
    }

    private static String match(String s, String regex) {
        Matcher m = Pattern.compile(regex).matcher(s);
        assertTrue(m.find(), "no " + regex);
        return m.group(1);
    }

    @ParameterizedTest(name = "{0}")
    @ValueSource(strings = {
        "https://dpp.s1seven.com/dpp/sms/H26-204517",
        "https://id.s1seven.com/01/09506000134352/10/H24-118273",
        "urn:epc:id:sgtin:4012345.000009.SN0001",
        "0088:4012345000009",
        "Chargen-Nr. 1607219/0001 — Prüfbescheinigung"
    })
    @DisplayName("The matrix decodes back to exactly the encoded string")
    void matrixRoundTrips(String data) throws Exception {
        assertEquals(data, new Decoder().decode(QrSymbol.of(data).toBitMatrix()).getText());
    }

    @Test
    @DisplayName("The SVG's own path data decodes back to the encoded string")
    void svgRoundTrips() throws Exception {
        String svg = QrSymbol.of(URL).toSvg();
        assertEquals(URL, new Decoder().decode(modulesOf(svg)).getText());
        assertTrue(svg.contains("<title>" + URL + "</title>"));
    }

    @Test
    @DisplayName("The data URI is the SVG, base64-encoded")
    void dataUriIsTheSvg() {
        QrSymbol symbol = QrSymbol.of(URL);
        String uri = symbol.toSvgDataUri();
        assertTrue(uri.startsWith("data:image/svg+xml;base64,"), uri.substring(0, 40));
        String decoded = new String(Base64.getDecoder().decode(uri.substring(uri.indexOf(',') + 1)),
                StandardCharsets.UTF_8);
        assertEquals(symbol.toSvg(), decoded);
    }

    @Test
    @DisplayName("Markup in the encoded string is escaped in the attributes and the title")
    void escapesMarkup() {
        String svg = QrSymbol.of("a\"<b>&c").toSvg();
        assertTrue(svg.contains("data-encoded=\"a&quot;&lt;b&gt;&amp;c\""));
        assertTrue(svg.contains("<title>a&quot;&lt;b&gt;&amp;c</title>"));
    }

    @Test
    @DisplayName("The symbol carries the ISO/IEC 18004 four-module quiet zone")
    void quietZoneIsPresent() {
        QrSymbol symbol = QrSymbol.of(URL);
        assertEquals(4, QrSymbol.QUIET_ZONE);
        assertEquals(symbol.modules().length + 2 * QrSymbol.QUIET_ZONE, symbol.moduleCount());
        assertTrue(symbol.pathData().startsWith("M" + QrSymbol.QUIET_ZONE + " " + QrSymbol.QUIET_ZONE),
                "the finder pattern's first dark run starts one quiet zone in: " + symbol.pathData());
    }

    @Test
    @DisplayName("Path data is emitted as an attribute value, never as markup")
    void pathDataIsAttributeSafe() {
        String path = QrSymbol.of(URL).pathData();
        assertFalse(path.isEmpty());
        for (char c : new char[] {'<', '>', '"', '&'}) {
            assertFalse(path.indexOf(c) >= 0, "a markup character would have to be escaped past the serializer");
        }
    }

    @Test
    @DisplayName("A blank string is refused rather than encoded as an empty symbol")
    void blankRefused() {
        assertThrows(IllegalArgumentException.class, () -> QrSymbol.of(null));
        assertThrows(IllegalArgumentException.class, () -> QrSymbol.of("   "));
    }

    @Test
    @DisplayName("A string too long for one symbol is refused with the length, not the whole string")
    void tooLongRefused() {
        String tooLong = "x".repeat(8000);
        IllegalArgumentException e = assertThrows(IllegalArgumentException.class, () -> QrSymbol.of(tooLong));
        assertTrue(e.getMessage().contains("8000 characters"), e.getMessage());
        assertTrue(e.getMessage().length() < 200, "the message must not echo the oversized input");
    }
}
