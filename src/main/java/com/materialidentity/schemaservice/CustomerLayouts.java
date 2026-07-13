package com.materialidentity.schemaservice;

import java.util.Map;
import java.util.Optional;

import com.fasterxml.jackson.databind.JsonNode;

/**
 * Producer VAT -> per-customer layout directory name, for certs whose stylesheet is otherwise
 * resolved purely from family + version (see {@code SchemasServiceImpl#renderPdf}). A layout name
 * here selects {@code schemas/{family}/{version}/layouts/{name}/stylesheet.xsl} instead of the
 * family's default stylesheet, if that resource exists on the classpath.
 *
 * <p>Unrelated to the {@code SchemaTypes.HKM} private schema family in this codebase (an
 * entirely different, S3-pulled certificate format) — this is purely a rendering-layout lookup
 * keyed by the producer's VAT (material-identity/schema#181, ported per material-identity/schema
 * customers/HKM/CUSTOM_LAYOUT.md).
 */
public final class CustomerLayouts {

    private static final Map<String, String> VAT_TO_LAYOUT = Map.of(
            "DE119556630", "HKM");

    private CustomerLayouts() {
    }

    /** The layout directory name for this certificate's producer, if one is registered. */
    public static Optional<String> resolve(JsonNode certificate) {
        String vat = certificate.at("/Certificate/CommercialTransaction/A01/Identifiers/VAT").asText(null);
        return Optional.ofNullable(vat).map(VAT_TO_LAYOUT::get);
    }
}
