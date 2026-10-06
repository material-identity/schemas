// SPDX-License-Identifier: Apache-2.0
package com.materialidentity.schemaservice;

import com.google.zxing.EncodeHintType;
import com.google.zxing.WriterException;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel;
import com.google.zxing.qrcode.encoder.ByteMatrix;
import com.google.zxing.qrcode.encoder.Encoder;
import com.google.zxing.qrcode.encoder.QRCode;

import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.EnumMap;
import java.util.Map;

/**
 * One QR symbol (ISO/IEC 18004) encoding one string, emitted as SVG path data.
 *
 * <p>A copy of {@code QrSymbol} in material-identity/schema's {@code :shared} (schema#447), which the
 * DPP data carrier and the legacy EN10168 pipeline there share; here it generates an EN10168 v0.5.0
 * {@code qr-code} key-value entry's symbol from its value (#346). Same encoder, quiet zone and path
 * format, so a symbol rendered by either service is the same picture.
 *
 * <p>Vector rather than raster: a PNG would have to be either an external reference or a base64
 * blob that bloats every rendered view; path data is smaller, stays sharp when printed, and is the
 * same input for an HTML view and an XSL-FO page.
 *
 * <p>The quiet zone is not decoration. ISO/IEC 18004 requires four modules of clear margin, and a
 * QR printed flush against surrounding content is one many scanners will not read.
 *
 * <p>Error-correction level M (~15 %): the data is typically a URL of moderate length, and the
 * symbol may end up on a label, a delivery note, or a certificate that has been folded and
 * handled. L would be smaller and more fragile than that use deserves.
 */
public record QrSymbol(
        String encodedData,
        int moduleCount,
        String pathData,
        boolean[][] modules) {

    /** ISO/IEC 18004 requires a four-module clear margin around the symbol. */
    public static final int QUIET_ZONE = 4;

    private static final String SVG_DATA_URI_PREFIX = "data:image/svg+xml;base64,";

    /**
     * Encode one string.
     *
     * @throws IllegalArgumentException for a blank string (an empty QR is worse than none: it
     *         scans, and yields nothing) or one too long for a single symbol
     */
    public static QrSymbol of(String data) {
        if (data == null || data.isBlank()) {
            throw new IllegalArgumentException("A QR symbol encodes a string; none was given");
        }
        Map<EncodeHintType, Object> hints = new EnumMap<>(EncodeHintType.class);
        hints.put(EncodeHintType.CHARACTER_SET, "UTF-8");

        QRCode qr;
        try {
            qr = Encoder.encode(data, ErrorCorrectionLevel.M, hints);
        } catch (WriterException e) {
            throw new IllegalArgumentException(
                    "Cannot encode as one QR symbol (" + data.length() + " characters): "
                    + abbreviate(data), e);
        }

        ByteMatrix matrix = qr.getMatrix();
        int size = matrix.getWidth();
        boolean[][] modules = new boolean[size][size];
        for (int y = 0; y < size; y++) {
            for (int x = 0; x < size; x++) {
                modules[y][x] = matrix.get(x, y) == 1;
            }
        }

        return new QrSymbol(data, size + 2 * QUIET_ZONE, buildPath(modules, size), modules);
    }

    /**
     * One SVG path covering every dark module, offset by the quiet zone.
     *
     * <p>A single path rather than one {@code <rect>} per module: a symbol of this size has several
     * hundred dark modules, and the element-per-module form would add tens of kilobytes of markup
     * to every rendered view for no visual difference. Horizontal runs are merged into one
     * rectangle each, which roughly halves it again.
     *
     * <p>Returned as an attribute value, never as markup — so a stylesheet emits the SVG elements
     * itself and nothing has to escape past the serializer.
     */
    private static String buildPath(boolean[][] modules, int size) {
        StringBuilder path = new StringBuilder();
        for (int y = 0; y < size; y++) {
            int runStart = -1;
            for (int x = 0; x <= size; x++) {
                boolean dark = x < size && modules[y][x];
                if (dark && runStart < 0) {
                    runStart = x;
                } else if (!dark && runStart >= 0) {
                    int width = x - runStart;
                    path.append('M').append(runStart + QUIET_ZONE).append(' ').append(y + QUIET_ZONE)
                        .append('h').append(width).append("v1h-").append(width).append('z');
                    runStart = -1;
                }
            }
        }
        return path.toString();
    }

    /**
     * The symbol as a zxing {@link BitMatrix}, without the quiet zone.
     *
     * <p>Exists so a test can decode the symbol back and assert it yields the encoded string
     * exactly. That round trip is what turns "the symbol encodes the value" from a claim in a
     * comment into a verified property.
     */
    public BitMatrix toBitMatrix() {
        int size = modules.length;
        BitMatrix bits = new BitMatrix(size, size);
        for (int y = 0; y < size; y++) {
            for (int x = 0; x < size; x++) {
                if (modules[y][x]) {
                    bits.set(x, y);
                }
            }
        }
        return bits;
    }

    /**
     * A standalone SVG document: black modules on a white ground, quiet zone included, scaling
     * crisply to any size. The encoded string travels in {@code data-encoded} and in the title, so
     * a viewer can say what the symbol opens without decoding it.
     */
    public String toSvg() {
        int n = moduleCount;
        String text = escape(encodedData);
        return "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 " + n + " " + n + "\""
                + " shape-rendering=\"crispEdges\" role=\"img\" aria-label=\"QR code: " + text + "\""
                + " data-encoded=\"" + text + "\" data-modules=\"" + modules.length + "\">"
                + "<title>" + text + "</title>"
                + "<rect width=\"" + n + "\" height=\"" + n + "\" fill=\"#fff\"/>"
                + "<path fill=\"#000\" d=\"" + pathData + "\"/>"
                + "</svg>\n";
    }

    /**
     * {@link #toSvg()} as a {@code data:} URI, so a stylesheet's {@code fo:external-graphic} can draw
     * the symbol with no resource fetch at all.
     */
    public String toSvgDataUri() {
        return SVG_DATA_URI_PREFIX
                + Base64.getEncoder().encodeToString(toSvg().getBytes(StandardCharsets.UTF_8));
    }

    private static String escape(String s) {
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;");
    }

    private static String abbreviate(String s) {
        return s.length() <= 80 ? s : s.substring(0, 77) + "...";
    }
}
