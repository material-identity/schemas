package com.materialidentity.schemaservice;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Locale;

import org.apache.pdfbox.Loader;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.PDPageContentStream;
import org.apache.pdfbox.pdmodel.common.PDRectangle;
import org.apache.pdfbox.pdmodel.font.PDType0Font;
import org.apache.pdfbox.pdmodel.graphics.state.PDExtendedGraphicsState;
import org.apache.pdfbox.util.Matrix;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * Stamps the test-mode preview watermark (material-identity/schema#181): diagonal,
 * semi-transparent text on every page of the finished PDF. Runs as a post-render step in
 * {@link PDFBuilder}, mirroring {@link AttachmentManager}/{@link EmbedManager}, so all certificate
 * families are covered by one hook. The transparency overlay and the additionally embedded font
 * make the output deliberately <b>not PDF/A</b> — a preview is explicitly not a valid certificate.
 */
public class WatermarkManager {

    public static final String FALLBACK_TEXT_EN = "PREVIEW — NOT A VALID CERTIFICATE";

    private static final ObjectMapper objectMapper = new ObjectMapper();

    private static final float ALPHA = 0.25f;
    private static final float GRAY = 0.55f;
    /** The text spans this fraction of the page diagonal. */
    private static final float DIAGONAL_FRACTION = 0.8f;

    private final String text;

    public WatermarkManager(String text) {
        this.text = text;
    }

    /**
     * Resolve the watermark text for the certificate's primary language from the family's
     * translations file ({@code <LANG>.WatermarkPreview}; the pattern also matches Metals'
     * singular {@code translation.json}). Falls back to the English block, then to the English
     * constant — families without translations (Bluemint) must still watermark.
     */
    public static String resolveText(String translationFilePattern, String primaryLanguage) {
        String lang = primaryLanguage.toUpperCase(Locale.ROOT);
        // Broaden "translations*.json" to "translation*.json" so Metals' singular
        // translation.json (unmatched by the render pipeline's pattern) is found too.
        String pattern = translationFilePattern.replace("translations*", "translation*");
        try {
            PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
            for (Resource resource : resolver.getResources("classpath*:" + pattern)) {
                JsonNode tree;
                try (InputStream is = resource.getInputStream()) {
                    tree = objectMapper.readTree(is);
                }
                JsonNode text = tree.path(lang).path("WatermarkPreview");
                if (text.isTextual()) {
                    return text.asText();
                }
                JsonNode en = tree.path("EN").path("WatermarkPreview");
                if (en.isTextual()) {
                    return en.asText();
                }
            }
        } catch (IOException e) {
            // A missing or broken translations file must not fail the render; stamp the fallback.
        }
        return FALLBACK_TEXT_EN;
    }

    public byte[] stamp(byte[] pdf) throws IOException {
        try (PDDocument document = Loader.loadPDF(pdf)) {
            PDType0Font font = PDType0Font.load(document, fontStream(text), true);
            for (PDPage page : document.getPages()) {
                stampPage(document, page, font);
            }
            ByteArrayOutputStream output = new ByteArrayOutputStream();
            document.save(output);
            return output.toByteArray();
        }
    }

    private void stampPage(PDDocument document, PDPage page, PDType0Font font) throws IOException {
        PDRectangle box = page.getMediaBox();
        float w = box.getWidth();
        float h = box.getHeight();
        float diagonal = (float) Math.hypot(w, h);
        float unitWidth = font.getStringWidth(text) / 1000f; // glyph-space width at font size 1
        float fontSize = DIAGONAL_FRACTION * diagonal / unitWidth;
        float textWidth = unitWidth * fontSize;

        try (PDPageContentStream cs = new PDPageContentStream(document, page,
                PDPageContentStream.AppendMode.APPEND, true, true)) {
            PDExtendedGraphicsState alpha = new PDExtendedGraphicsState();
            alpha.setNonStrokingAlphaConstant(ALPHA);
            cs.setGraphicsStateParameters(alpha);
            cs.setNonStrokingColor(GRAY, GRAY, GRAY);
            cs.beginText();
            cs.setFont(font, fontSize);
            // Baseline through the page center, rotated along the diagonal, centered lengthwise.
            Matrix position = Matrix.getRotateInstance(Math.atan2(h, w), w / 2f, h / 2f);
            position.concatenate(Matrix.getTranslateInstance(-textWidth / 2f, 0));
            cs.setTextMatrix(position);
            cs.showText(text);
            cs.endText();
        }
    }

    /** Noto Sans for Latin scripts; Noto Sans SC when the resolved text carries CJK glyphs. */
    private InputStream fontStream(String text) {
        String font = containsCjk(text) ? "fonts/NotoSansSC-Regular.ttf"
                : "fonts/NotoSans-Regular.ttf";
        InputStream is = getClass().getClassLoader().getResourceAsStream(font);
        if (is == null) {
            throw new IllegalStateException("Watermark font not on classpath: " + font);
        }
        return is;
    }

    private static boolean containsCjk(String text) {
        return text.codePoints().anyMatch(cp -> cp >= 0x2E80 && cp <= 0x9FFF);
    }
}
