package com.materialidentity.schemaservice;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.WriterException;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel;

import javax.imageio.ImageIO;
import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Utility class for QR code generation and processing in XSL-FO documents.
 */
public class QRCodeProcessor {

  private static final Pattern QR_CODE_PATTERN = Pattern.compile(
      "QRCODE\\[(.*?)(?:,qrColor=(.*?))?(?:,bgColor=(.*?))?(?:,size=(\\d+))?(?:,margin=(\\d+))?(?:,errorLevel=([LMQH]))?\\]");
  private static final int DEFAULT_SIZE = 200;
  private static final Color DEFAULT_QR_COLOR = Color.BLACK;
  private static final Color DEFAULT_BACKGROUND_COLOR = Color.WHITE;

  /**
   * Process an XSL-FO document string, replacing QR code placeholders with
   * base64-encoded images.
   * Placeholders should be in the format QRCODE[content] or
   * QRCODE[content,qrColor=blue,bgColor=white,size=300,margin=4,errorLevel=H]
   *
   * @param foContent The XSL-FO document content as a string
   * @return The processed document with QR code placeholders replaced
   */
  public static String processQRCodePlaceholders(String foContent) {
    Matcher matcher = QR_CODE_PATTERN.matcher(foContent);

    StringBuffer sb = new StringBuffer();
    while (matcher.find()) {
      String content = matcher.group(1);

      // Get QR color if provided
      Color qrColor = DEFAULT_QR_COLOR;
      if (matcher.groupCount() >= 2 && matcher.group(2) != null) {
        qrColor = parseColor(matcher.group(2));
      }

      // Get background color if provided
      Color bgColor = DEFAULT_BACKGROUND_COLOR;
      if (matcher.groupCount() >= 3 && matcher.group(3) != null) {
        bgColor = parseColor(matcher.group(3));
      }

      // Get size if provided
      int size = DEFAULT_SIZE;
      if (matcher.groupCount() >= 4 && matcher.group(4) != null) {
        try {
          size = Integer.parseInt(matcher.group(4));
        } catch (NumberFormatException e) {
          // Ignore and use default
        }
      }

      // Get margin if provided
      int margin = 1; // Default margin
      if (matcher.groupCount() >= 5 && matcher.group(5) != null) {
        try {
          margin = Integer.parseInt(matcher.group(5));
        } catch (NumberFormatException e) {
          // Ignore and use default
        }
      }

      // Get error correction level if provided
      ErrorCorrectionLevel errorLevel = ErrorCorrectionLevel.M; // Default level
      if (matcher.groupCount() >= 6 && matcher.group(6) != null) {
        String level = matcher.group(6);
        switch (level) {
          case "L":
            errorLevel = ErrorCorrectionLevel.L;
            break;
          case "M":
            errorLevel = ErrorCorrectionLevel.M;
            break;
          case "Q":
            errorLevel = ErrorCorrectionLevel.Q;
            break;
          case "H":
            errorLevel = ErrorCorrectionLevel.H;
            break;
        }
      }

      // Generate QR code with all the specified parameters
      String base64QrCode = generateQRCodeBase64(content, size, qrColor, bgColor, errorLevel, margin);

      // Create the data URL with the base64 image
      String replacement = "data:image/png;base64," + base64QrCode;
      matcher.appendReplacement(sb, Matcher.quoteReplacement(replacement));
    }
    matcher.appendTail(sb);

    return sb.toString();
  }

  /**
   * Generate a base64-encoded QR code image for the given content.
   *
   * @param content The content to encode in the QR code
   * @param size    The width and height of the QR code in pixels
   * @return Base64-encoded PNG image of the QR code
   */
  public static String generateQRCodeBase64(String content, int size) {
    return generateQRCodeBase64(content, size, DEFAULT_QR_COLOR, DEFAULT_BACKGROUND_COLOR);
  }

  /**
   * Generate a base64-encoded QR code image with custom colors.
   *
   * @param content         The content to encode in the QR code
   * @param size            The width and height of the QR code in pixels
   * @param qrColor         The color of the QR code modules (dark squares)
   * @param backgroundColor The background color of the QR code
   * @return Base64-encoded PNG image of the QR code
   */
  public static String generateQRCodeBase64(String content, int size, Color qrColor, Color backgroundColor) {
    return generateQRCodeBase64(content, size, qrColor, backgroundColor, ErrorCorrectionLevel.M, 1);
  }

  /**
   * Advanced QR code generation with custom parameters.
   *
   * @param content              The content to encode in the QR code
   * @param size                 The width and height of the QR code in pixels
   * @param qrColor              The color of the QR code modules (dark squares)
   * @param backgroundColor      The background color of the QR code
   * @param errorCorrectionLevel The error correction level (L, M, Q, H)
   * @param margin               The margin size around the QR code
   * @return Base64-encoded PNG image of the QR code
   */
  public static String generateQRCodeBase64(String content, int size, Color qrColor, Color backgroundColor,
      ErrorCorrectionLevel errorCorrectionLevel, int margin) {
    try {
      // Configure QR code parameters
      Map<EncodeHintType, Object> hints = new HashMap<>();
      hints.put(EncodeHintType.ERROR_CORRECTION, errorCorrectionLevel);

      // Ensure margin can be 0
      hints.put(EncodeHintType.MARGIN, Math.max(0, margin)); // Allow zero margin

      // Generate QR code
      QRCodeWriter qrCodeWriter = new QRCodeWriter();
      BitMatrix bitMatrix = qrCodeWriter.encode(
          content,
          BarcodeFormat.QR_CODE,
          size,
          size,
          hints);

      // Create BufferedImage with custom colors
      BufferedImage qrImage = new BufferedImage(size, size, BufferedImage.TYPE_INT_ARGB);
      Graphics2D graphics = qrImage.createGraphics();

      // Fill background
      graphics.setColor(backgroundColor);
      graphics.fillRect(0, 0, size, size);

      // Draw QR code
      graphics.setColor(qrColor);
      for (int x = 0; x < size; x++) {
        for (int y = 0; y < size; y++) {
          if (bitMatrix.get(x, y)) {
            graphics.fillRect(x, y, 1, 1);
          }
        }
      }

      graphics.dispose();

      // Convert to base64
      ByteArrayOutputStream baos = new ByteArrayOutputStream();
      ImageIO.write(qrImage, "png", baos);
      return Base64.getEncoder().encodeToString(baos.toByteArray());
    } catch (WriterException | IOException e) {
      throw new RuntimeException("Error generating QR code: " + e.getMessage(), e);
    }
  }

  /**
   * Parse a color from a hex string like "#FF0000" or "red".
   * 
   * @param colorStr The color string
   * @return The Color object
   */
  public static Color parseColor(String colorStr) {
    if (colorStr == null || colorStr.isEmpty()) {
      return Color.BLACK;
    }

    // Handle named colors
    if (colorStr.equalsIgnoreCase("red"))
      return Color.RED;
    if (colorStr.equalsIgnoreCase("blue"))
      return Color.BLUE;
    if (colorStr.equalsIgnoreCase("green"))
      return Color.GREEN;
    if (colorStr.equalsIgnoreCase("black"))
      return Color.BLACK;
    if (colorStr.equalsIgnoreCase("white"))
      return Color.WHITE;
    if (colorStr.equalsIgnoreCase("yellow"))
      return Color.YELLOW;
    if (colorStr.equalsIgnoreCase("cyan"))
      return Color.CYAN;
    if (colorStr.equalsIgnoreCase("magenta"))
      return Color.MAGENTA;
    if (colorStr.equalsIgnoreCase("gray") || colorStr.equalsIgnoreCase("grey"))
      return Color.GRAY;
    if (colorStr.equalsIgnoreCase("darkgray") || colorStr.equalsIgnoreCase("darkgrey"))
      return Color.DARK_GRAY;
    if (colorStr.equalsIgnoreCase("lightgray") || colorStr.equalsIgnoreCase("lightgrey"))
      return Color.LIGHT_GRAY;
    if (colorStr.equalsIgnoreCase("orange"))
      return Color.ORANGE;
    if (colorStr.equalsIgnoreCase("pink"))
      return Color.PINK;

    // Handle hex colors
    if (colorStr.startsWith("#")) {
      try {
        return Color.decode(colorStr);
      } catch (NumberFormatException e) {
        // If invalid hex, return default
        return Color.BLACK;
      }
    }

    // Handle RGB format like "rgb(255,0,0)"
    if (colorStr.startsWith("rgb(") && colorStr.endsWith(")")) {
      try {
        String[] rgb = colorStr.substring(4, colorStr.length() - 1).split(",");
        if (rgb.length == 3) {
          int r = Integer.parseInt(rgb[0].trim());
          int g = Integer.parseInt(rgb[1].trim());
          int b = Integer.parseInt(rgb[2].trim());
          return new Color(r, g, b);
        }
      } catch (Exception e) {
        // If invalid rgb, return default
      }
    }

    // Default
    return Color.BLACK;
  }
}