package com.materialidentity.schemaservice;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.junit.jupiter.api.Assertions.fail;

import java.io.ByteArrayInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Map;
import java.util.stream.Stream;

import org.apache.pdfbox.Loader;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDDocumentNameDictionary;
import org.apache.pdfbox.pdmodel.common.filespecification.PDComplexFileSpecification;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtensionContext;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.Arguments;
import org.junit.jupiter.params.provider.ArgumentsProvider;
import org.junit.jupiter.params.provider.ArgumentsSource;
import org.opentest4j.AssertionFailedError;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.reactive.AutoConfigureWebTestClient;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.context.SpringBootTest.WebEnvironment;
import org.springframework.cache.CacheManager;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.test.web.reactive.server.WebTestClient;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.pdfbox.text.PDFTextStripper;
import com.materialidentity.schemaservice.config.SchemaControllerConstants;

@SpringBootTest(webEnvironment = WebEnvironment.RANDOM_PORT, classes = App.class)
@AutoConfigureWebTestClient
class RenderTest {

	@Autowired
	private WebTestClient webClient;

	@Autowired
	private CacheManager cacheManager;

	@BeforeEach
	void setUp() {
		cacheManager.getCache("rate-limit-bucket").clear();
	}

	@ParameterizedTest(name = "Render test for {0}")
	@ArgumentsSource(JsonPdfArgumentsProvider.class)
	void renderEndpointTest(Path jsonFilePath, Path pdfFilePath) throws Exception {
		String jsonContent = Files.readString(jsonFilePath);
		byte[] expectedPdfContent = Files.readAllBytes(pdfFilePath);
		Path basePath = Paths.get("src", "test", "resources", "schemas");
		String fileName = basePath.relativize(jsonFilePath).toString();

		webClient
				.post().uri(uriBuilder -> uriBuilder
						.path("/api/render")
						.queryParam("attachJson", "true")
						.build())
				.contentType(MediaType.APPLICATION_JSON)
				.bodyValue(jsonContent).exchange()
				.expectStatus().isOk()
				.expectBody()
				.consumeWith(response -> {
					byte[] responseBody = response.getResponseBody();
					if (responseBody == null) {
						fail("Response body is null for file: " + fileName);
					}
					try {
						assertPdfContentEquals(expectedPdfContent, responseBody, fileName);
						assertPdfContainsEmbeddedFile(responseBody,
								SchemaControllerConstants.DEFAULT_PDF_ATTACHMENT_CERT_FILE_NAME,
								jsonContent.getBytes(), true, fileName);
					} catch (Exception e) {
						throw new RuntimeException("PDF comparison failed for file: " + fileName, e);
					}
				});
	}

	@Test
	void CoA_renderEndpointTest_WithoutJsonAttachment() throws Exception {
		Path resourceDirectory = Paths.get("src", "test", "resources");
		String testResourcesPath = resourceDirectory.toFile().getAbsolutePath();
		String fileName = "valid_cert_with_attachment.json";

		String jsonContent = new String(
				Files.readAllBytes(
						Paths.get(testResourcesPath + "/schemas/CoA/v1.1.0/" + fileName)));
		byte[] expectedPdfContent = Files
				.readAllBytes(Paths.get(testResourcesPath + "/schemas/CoA/v1.1.0/valid_cert_with_attachment.pdf"));

		webClient
				.post().uri(uriBuilder -> uriBuilder
						.path("/api/render")
						.queryParam("attachJson", false)
						.build())
				.contentType(MediaType.APPLICATION_JSON)
				.bodyValue(jsonContent).exchange()
				.expectStatus().isOk()
				.expectBody()
				.consumeWith(response -> {
					byte[] responseBody = response.getResponseBody();
					if (responseBody == null) {
						fail("Response body is null for file: " + fileName);
					}
					try {
						assertPdfContentEquals(expectedPdfContent, responseBody, fileName);
						assertPdfContainsEmbeddedFile(responseBody,
								SchemaControllerConstants.DEFAULT_PDF_ATTACHMENT_CERT_FILE_NAME, 
								jsonContent.getBytes(), false, fileName);
					} catch (Exception e) {
						throw new RuntimeException("PDF comparison failed for file: " + fileName, e);
					}
				});
	}

	@Test
	void CoA_renderEndpointTest_WithoutEmbeddedPDF() throws Exception {
		Path resourceDirectory = Paths.get("src", "test", "resources");
		String testResourcesPath = resourceDirectory.toFile().getAbsolutePath();
		String fileName = "valid_cert_with_attached_pdf.json";

		String jsonContent = new String(
				Files.readAllBytes(
						Paths.get(testResourcesPath + "/schemas/CoA/v1.1.0/" + fileName)));
		byte[] expectedPdfContent = Files
				.readAllBytes(Paths.get(testResourcesPath + "/schemas/CoA/v1.1.0/valid_cert_with_attached_pdf.pdf"));

		webClient
				.post().uri(uriBuilder -> uriBuilder
						.path("/api/render")
						.queryParam("attachJson", false)
						.build())
				.contentType(MediaType.APPLICATION_JSON)
				.bodyValue(jsonContent).exchange()
				.expectStatus().isOk()
				.expectBody()
				.consumeWith(response -> {
					byte[] responseBody = response.getResponseBody();
					if (responseBody == null) {
						fail("Response body is null for file: " + fileName);
					}
					try {
						assertPdfContentEquals(expectedPdfContent, responseBody, fileName);
						assertPdfContainsEmbeddedFile(responseBody,
								SchemaControllerConstants.DEFAULT_PDF_ATTACHMENT_CERT_FILE_NAME, 
								jsonContent.getBytes(), false, fileName);
					} catch (Exception e) {
						throw new RuntimeException("PDF comparison failed for file: " + fileName, e);
					}
				});
	}

	@Test
	void CoA_renderEndpointTest_WithoutLanguages() throws Exception {
		Path resourceDirectory = Paths.get("src", "test", "resources");
		String testResourcesPath = resourceDirectory.toFile().getAbsolutePath();
		String fileName = "missing_languages.json";

		String jsonContent = new String(
				Files.readAllBytes(Paths.get(testResourcesPath + "/schemas/CoA/v1.1.0/" + fileName)));

		webClient
				.post().uri(uriBuilder -> uriBuilder
						.path("/api/render")
						.queryParam("attachJson", true)
						.build())
				.contentType(MediaType.APPLICATION_JSON)
				.bodyValue(jsonContent).exchange()
				.expectStatus().isEqualTo(HttpStatus.BAD_REQUEST)
				.expectBody()
				.jsonPath("$.message").isEqualTo("CertificateLanguages array is empty");
	}

	@Test
	void CoA_renderEndpointTest_WithoutLanguagesProperty() throws Exception {
		Path resourceDirectory = Paths.get("src", "test", "resources");
		String testResourcesPath = resourceDirectory.toFile().getAbsolutePath();
		String fileName = "missing_languages_property.json";

		String jsonContent = new String(
				Files.readAllBytes(
						Paths.get(testResourcesPath + "/schemas/CoA/v1.1.0/" + fileName)));

		webClient
				.post().uri(uriBuilder -> uriBuilder
						.path("/api/render")
						.queryParam("attachJson", true)
						.build())
				.contentType(MediaType.APPLICATION_JSON)
				.bodyValue(jsonContent).exchange()
				.expectStatus().isEqualTo(HttpStatus.BAD_REQUEST)
				.expectBody()
				.jsonPath("$.message").isEqualTo("No languages property found in the certificate");
	}

	@Test
	void CoA_renderEndpointTest_InvalidSchemaType() throws Exception {
		Path resourceDirectory = Paths.get("src", "test", "resources");
		String testResourcesPath = resourceDirectory.toFile().getAbsolutePath();
		String fileName = "invalid_schema_type.json";

		String jsonContent = new String(
				Files.readAllBytes(Paths.get(testResourcesPath + "/schemas/CoA/v1.1.0/" + fileName)));

		webClient
				.post().uri(uriBuilder -> uriBuilder
						.path("/api/render")
						.queryParam("attachJson", true)
						.build())
				.contentType(MediaType.APPLICATION_JSON)
				.bodyValue(jsonContent).exchange()
				.expectStatus().isEqualTo(HttpStatus.BAD_REQUEST)
				.expectBody()
				.jsonPath("$.message").isEqualTo("Certificate type 'invalid' is not supported.");
	}

	private void assertPdfContentEquals(byte[] expectedPdfContent, byte[] actualPdfContent,
			String fileName) throws Exception {
		try (PDDocument expectedDoc = Loader.loadPDF(expectedPdfContent);
				PDDocument actualDoc = Loader.loadPDF(actualPdfContent)) {
			PDFTextStripper stripper = new PDFTextStripper();
			String expectedText = stripper.getText(expectedDoc);
			String actualText = stripper.getText(actualDoc);

			if (!expectedText.equals(actualText)) {
				String diffMessage = generateTextDiff(expectedText, actualText);
				throw new AssertionFailedError(
						"PDF content does not match for file: " + fileName + "\n" + diffMessage,
						expectedText, actualText);
			}
		}
	}

	/**
	 * Generate a readable diff between two strings.
	 * 
	 * @param expected The expected string
	 * @param actual   The actual string
	 * @return A formatted diff message
	 */
	private String generateTextDiff(String expected, String actual) {
		StringBuilder diffBuilder = new StringBuilder();
		diffBuilder.append("Text difference summary:\n");
		
		// Add length information
		diffBuilder.append(String.format("Expected length: %d, Actual length: %d\n", 
				expected.length(), actual.length()));
		
		// Find the first difference and show context
		int firstDiffPos = findFirstDifferencePosition(expected, actual);
		if (firstDiffPos != -1) {
			int contextStart = Math.max(0, firstDiffPos - 20);
			int expectedContextEnd = Math.min(expected.length(), firstDiffPos + 50);
			int actualContextEnd = Math.min(actual.length(), firstDiffPos + 50);
			
			diffBuilder.append("First difference at position " + firstDiffPos + ":\n");
			
			// Expected context
			diffBuilder.append("Expected: \"");
			if (contextStart > 0) diffBuilder.append("...");
			diffBuilder.append(escapeSpecialChars(expected.substring(contextStart, expectedContextEnd)));
			if (expectedContextEnd < expected.length()) diffBuilder.append("...");
			diffBuilder.append("\"\n");
			
			// Actual context
			diffBuilder.append("Actual:   \"");
			if (contextStart > 0) diffBuilder.append("...");
			diffBuilder.append(escapeSpecialChars(actual.substring(contextStart, actualContextEnd)));
			if (actualContextEnd < actual.length()) diffBuilder.append("...");
			diffBuilder.append("\"\n");
			
			// Pointer to the difference
			diffBuilder.append("           ");
			for (int i = contextStart; i < firstDiffPos; i++) {
				diffBuilder.append(" ");
			}
			diffBuilder.append("^\n");
		}
		
		// Find multiple differences and their positions
		diffBuilder.append("\nDetailed differences (first 5 max):\n");
		int diffCount = 0;
		int pos = 0;
		int maxDiffs = 5;
		
		while (pos < expected.length() && pos < actual.length() && diffCount < maxDiffs) {
			if (expected.charAt(pos) != actual.charAt(pos)) {
				diffCount++;
				char expectedChar = expected.charAt(pos);
				char actualChar = actual.charAt(pos);
				diffBuilder.append(String.format("Position %d: Expected '%s' (\\u%04X), got '%s' (\\u%04X)\n", 
						pos, 
						escapeChar(expectedChar), (int)expectedChar, 
						escapeChar(actualChar), (int)actualChar));
			}
			pos++;
		}
		
		// If strings have different lengths, note where one ended
		if (expected.length() != actual.length()) {
			diffBuilder.append(String.format("\nStrings have different lengths. " +
					"First string %s at position %d.\n", 
					expected.length() < actual.length() ? "ends" : "continues", 
					Math.min(expected.length(), actual.length())));
		}
		
		return diffBuilder.toString();
	}
	
	/**
	 * Find the position of the first difference between two strings.
	 * 
	 * @param str1 First string
	 * @param str2 Second string
	 * @return Position of first difference, or -1 if strings are identical
	 */
	private int findFirstDifferencePosition(String str1, String str2) {
		int minLength = Math.min(str1.length(), str2.length());
		for (int i = 0; i < minLength; i++) {
			if (str1.charAt(i) != str2.charAt(i)) {
				return i;
			}
		}
		// If we get here and strings have different lengths, the difference
		// is that one string ended before the other
		return str1.length() != str2.length() ? minLength : -1;
	}
	
	/**
	 * Escape special characters for display.
	 * 
	 * @param str The string to escape
	 * @return Escaped string
	 */
	private String escapeSpecialChars(String str) {
		return str.replace("\n", "\\n")
				.replace("\r", "\\r")
				.replace("\t", "\\t");
	}
	
	/**
	 * Escape a single character for display.
	 * 
	 * @param c The character to escape
	 * @return String representation with special characters escaped
	 */
	private String escapeChar(char c) {
		switch (c) {
			case '\n': return "\\n";
			case '\r': return "\\r";
			case '\t': return "\\t";
			case ' ': return "space";
			default: return String.valueOf(c);
		}
	}

	private void assertPdfContainsEmbeddedFile(byte[] pdfContent, String embeddedFileName,
			byte[] expectedEmbeddedFileContent, boolean shouldExist, String sourceFileName) throws IOException {
		try (PDDocument document = Loader.loadPDF(pdfContent)) {
			PDDocumentNameDictionary names = new PDDocumentNameDictionary(document.getDocumentCatalog());

			if (names.getEmbeddedFiles() == null) {
				if (shouldExist) {
					fail("No embedded files found in the PDF for file: " + 
							sourceFileName + ", but one was expected");
				}
				return;
			}

			Map<String, PDComplexFileSpecification> embeddedFiles = names.getEmbeddedFiles().getNames();

			if (embeddedFiles.containsKey(embeddedFileName)) {
				if (!shouldExist) {
					fail("Embedded file '" + embeddedFileName + "' found in the PDF for file: " + 
							sourceFileName + ", but it was not expected");
				}

				byte[] embeddedFileContent = embeddedFiles.get(embeddedFileName).getEmbeddedFile().toByteArray();

				// Normalize and compare JSON content
				ObjectMapper objectMapper = new ObjectMapper();
				try {
					JsonNode expectedJson = objectMapper.readTree(expectedEmbeddedFileContent);
					JsonNode actualJson = objectMapper.readTree(embeddedFileContent);

					if (!expectedJson.equals(actualJson)) {
						// Find differences in JSON
						String jsonDiff = generateJsonDiff(expectedJson, actualJson);
						fail("Embedded file content does not match the expected content for file: " + 
								sourceFileName + "\n" + jsonDiff);
					}
				} catch (IOException e) {
					fail("Error parsing JSON content for file: " + sourceFileName + " - " + e.getMessage());
				}
			} else if (shouldExist) {
				fail("Embedded file '" + embeddedFileName + "' not found in the PDF for file: " + 
						sourceFileName + ", but it was expected");
			}
		}
	}
	
	/**
	 * Generate a description of differences between two JSON nodes.
	 * 
	 * @param expected Expected JSON
	 * @param actual Actual JSON 
	 * @return A description of the differences
	 */
	private String generateJsonDiff(JsonNode expected, JsonNode actual) {
		StringBuilder diff = new StringBuilder("JSON differences:\n");
		
		// Compare types
		if (expected.getNodeType() != actual.getNodeType()) {
			diff.append(String.format("Different types: expected %s, got %s\n", 
					expected.getNodeType(), actual.getNodeType()));
			return diff.toString();
		}
		
		// For objects, compare fields
		if (expected.isObject()) {
			// Find missing fields
			expected.fieldNames().forEachRemaining(fieldName -> {
				if (!actual.has(fieldName)) {
					diff.append(String.format("Field missing in actual: %s\n", fieldName));
				}
			});
			
			// Find extra fields
			actual.fieldNames().forEachRemaining(fieldName -> {
				if (!expected.has(fieldName)) {
					diff.append(String.format("Unexpected field in actual: %s\n", fieldName));
				}
			});
			
			// Compare common fields (first level only for simplicity)
			expected.fieldNames().forEachRemaining(fieldName -> {
				if (actual.has(fieldName) && !expected.get(fieldName).equals(actual.get(fieldName))) {
					diff.append(String.format("Different values for field '%s':\n", fieldName));
					diff.append(String.format("  Expected: %s\n", expected.get(fieldName)));
					diff.append(String.format("  Actual:   %s\n", actual.get(fieldName)));
				}
			});
		}
		// For arrays, compare sizes and elements
		else if (expected.isArray()) {
			if (expected.size() != actual.size()) {
				diff.append(String.format("Different array sizes: expected %d, got %d\n", 
						expected.size(), actual.size()));
			}
			
			// Compare elements (up to the smaller size)
			int minSize = Math.min(expected.size(), actual.size());
			for (int i = 0; i < minSize; i++) {
				if (!expected.get(i).equals(actual.get(i))) {
					diff.append(String.format("Different values at index %d:\n", i));
					diff.append(String.format("  Expected: %s\n", expected.get(i)));
					diff.append(String.format("  Actual:   %s\n", actual.get(i)));
				}
			}
		}
		// For simple values, show the difference
		else {
			diff.append(String.format("Different values:\n"));
			diff.append(String.format("  Expected: %s\n", expected));
			diff.append(String.format("  Actual:   %s\n", actual));
		}
		
		return diff.toString();
	}

	static class JsonPdfArgumentsProvider implements ArgumentsProvider {
		@Override
		public Stream<? extends Arguments> provideArguments(ExtensionContext context) throws Exception {
			Path basePath = Paths.get("src", "test", "resources", "schemas");

			// Ensure the directory exists
			if (!Files.exists(basePath)) {
				throw new FileNotFoundException("Directory not found: " + basePath.toAbsolutePath());
			}

			// skips e-coc since it doesn't support rendering
			return Files.walk(basePath)
					.filter(path -> path.getFileName().toString().matches("valid_.*\\.json") && !path.toString().contains("E-CoC"))
					.map(path -> {
						Path pdfPath = Paths.get(path.toString().replace(".json", ".pdf"));
						return Arguments.of(path, pdfPath);
					});
		}
	}
}