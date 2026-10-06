// SPDX-License-Identifier: Apache-2.0
package com.materialidentity.schemaservice;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.node.ObjectNode;

/**
 * Generates the symbol of every {@code qr-code} key-value entry before the stylesheet runs (#346, mirrors schema#447).
 *
 * <p>EN10168 v0.5.0's {@code KeyValueObject.Type} has carried {@code qr-code} since the {@code url},
 * {@code phone}, {@code email} and {@code image} types were added, but nothing ever generated a
 * symbol: the stylesheet drew whatever image the value happened to hold, so a certificate had to
 * ship a hand-made picture next to the URL it showed. The rule now: <b>the value is the text the
 * symbol encodes</b> (typically a URL) and the renderer generates the symbol. A value that is
 * already a {@code data:} image URI keeps rendering as that image, so certificates issued under
 * the earlier reading render exactly as before.
 *
 * <p>Done on the JSON rather than in XSLT because Saxon-HE has no QR encoder and the
 * transformer factory registers no extension functions. The symbol arrives as an SVG {@code data:} URI, which
 * the stylesheet's existing {@code fo:external-graphic} branch draws and the sandboxed FOP resolver
 * admits without a fetch. Only the stylesheet sees the substituted document: the JSON attached to
 * the PDF stays the certificate as issued.
 */
public final class QrCodeValues {

    /** The {@code Type} whose value is encoded. */
    static final String TYPE = "qr-code";

    private QrCodeValues() {
    }

    /**
     * A copy of the certificate in which every encodable {@code qr-code} value is replaced by the
     * SVG data URI of its symbol. The given node is not modified.
     */
    public static JsonNode embedSymbols(JsonNode certificate) {
        JsonNode copy = certificate.deepCopy();
        embedInto(copy);
        return copy;
    }

    private static void embedInto(JsonNode node) {
        if (node.isObject()) {
            // Children first: a Value is text, never an object, so nothing substituted is revisited.
            node.forEach(QrCodeValues::embedInto);
            ObjectNode object = (ObjectNode) node;
            if (encodes(object)) {
                object.put("Value", QrSymbol.of(object.get("Value").asText()).toSvgDataUri());
            }
        } else if (node.isArray()) {
            node.forEach(QrCodeValues::embedInto);
        }
    }

    /** A {@code qr-code} entry whose value is text to encode rather than a ready image. */
    static boolean encodes(JsonNode object) {
        JsonNode type = object.get("Type");
        JsonNode value = object.get("Value");
        return type != null && TYPE.equals(type.asText())
                && value != null && value.isTextual()
                && !value.asText().isBlank()
                && !isDataUri(value.asText());
    }

    /** RFC 2397: the scheme is case-insensitive. */
    private static boolean isDataUri(String value) {
        return value.regionMatches(true, 0, "data:", 0, 5);
    }
}
