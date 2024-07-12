package com.materialidentity.schemaservice;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.itextpdf.text.pdf.PdfReader;
import com.itextpdf.text.pdf.parser.PdfTextExtractor;
import com.materialidentity.schemaservice.config.SchemaControllerConstants;
import org.apache.pdfbox.Loader;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDDocumentNameDictionary;
import org.apache.pdfbox.pdmodel.common.filespecification.PDComplexFileSpecification;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtensionContext;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.Arguments;
import org.junit.jupiter.params.provider.ArgumentsProvider;
import org.junit.jupiter.params.provider.ArgumentsSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.reactive.AutoConfigureWebTestClient;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.context.SpringBootTest.WebEnvironment;
import org.springframework.http.MediaType;
import org.springframework.test.web.reactive.server.WebTestClient;

import java.io.ByteArrayInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Map;
import java.util.stream.Stream;

@SpringBootTest(webEnvironment = WebEnvironment.RANDOM_PORT)
@AutoConfigureWebTestClient
class HttpRequestTest {

	@Autowired
	private WebTestClient webClient;

	@ParameterizedTest
	@ArgumentsSource(JsonPdfArgumentsProvider.class)
	void renderEndpointTest(Path jsonFilePath, Path pdfFilePath) throws Exception {
		String jsonContent = Files.readString(jsonFilePath);
		byte[] expectedPdfContent = Files.readAllBytes(pdfFilePath);

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
					assert responseBody != null;
					try {
						assertPdfContentEquals(expectedPdfContent, responseBody);
						assertPdfContainsEmbeddedFile(responseBody,
								SchemaControllerConstants.PDF_ATTACHMENT_CERT_FILE_NAME,
								jsonContent.getBytes(), true);
					} catch (Exception e) {
						throw new RuntimeException("PDF comparison failed", e);
					}
				});
	}

	@Test
	void CoA_renderEndpointTest_WithoutJsonAttachment() throws Exception {
		Path resourceDirectory = Paths.get("src", "test", "resources");
		String testResourcesPath = resourceDirectory.toFile().getAbsolutePath();

		String jsonContent = new String(
				Files.readAllBytes(Paths.get(testResourcesPath + "/schemas/CoA/v1.1.0/valid_cert_without_attachment.json")));
		byte[] expectedPdfContent = Files
				.readAllBytes(Paths.get(testResourcesPath + "/schemas/CoA/v1.1.0/valid_cert_without_attachment.pdf"));

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
					assert responseBody != null;
					try {
						assertPdfContentEquals(expectedPdfContent, responseBody);
						assertPdfContainsEmbeddedFile(responseBody,
								SchemaControllerConstants.PDF_ATTACHMENT_CERT_FILE_NAME, jsonContent.getBytes(), false);
					} catch (Exception e) {
						throw new RuntimeException("PDF comparison failed", e);
					}
				});
	}

	private void assertPdfContentEquals(byte[] expectedPdfContent, byte[] actualPdfContent) throws Exception {
		PdfReader expectedReader = new PdfReader(new ByteArrayInputStream(expectedPdfContent));
		PdfReader actualReader = new PdfReader(new ByteArrayInputStream(actualPdfContent));

		String expectedText = PdfTextExtractor.getTextFromPage(expectedReader, 1);
		String actualText = PdfTextExtractor.getTextFromPage(actualReader, 1);

		assert expectedText.equals(actualText) : "PDF content does not match";
	}

	private void assertPdfContainsEmbeddedFile(byte[] pdfContent, String embeddedFileName,
			byte[] expectedEmbeddedFileContent, boolean shouldExist) throws IOException {
		try (PDDocument document = Loader.loadPDF(pdfContent)) {
			PDDocumentNameDictionary names = new PDDocumentNameDictionary(document.getDocumentCatalog());

			if (names.getEmbeddedFiles() == null) {
				if (shouldExist) {
					throw new AssertionError("No embedded files found in the PDF, but one was expected");
				}
				return;
			}

			Map<String, PDComplexFileSpecification> embeddedFiles = names.getEmbeddedFiles().getNames();

			if (embeddedFiles.containsKey(embeddedFileName)) {
				if (!shouldExist) {
					throw new AssertionError(
							"Embedded file '" + embeddedFileName + "' found in the PDF, but it was not expected");
				}

				byte[] embeddedFileContent = embeddedFiles.get(embeddedFileName).getEmbeddedFile().toByteArray();

				// Normalize and compare JSON content
				ObjectMapper objectMapper = new ObjectMapper();
				try {
					JsonNode expectedJson = objectMapper.readTree(expectedEmbeddedFileContent);
					JsonNode actualJson = objectMapper.readTree(embeddedFileContent);

					if (!expectedJson.equals(actualJson)) {
						throw new AssertionError("Embedded file content does not match the expected content");
					}
				} catch (IOException e) {
					throw new AssertionError("Error parsing JSON content", e);
				}
			} else if (shouldExist) {
				throw new AssertionError(
						"Embedded file '" + embeddedFileName + "' not found in the PDF, but it was expected");
			}
		}
	}

	static class JsonPdfArgumentsProvider implements ArgumentsProvider {
		@Override
		public Stream<? extends Arguments> provideArguments(ExtensionContext context) throws Exception {
			Path basePath = Paths.get("src", "test", "resources", "schemas");

			// Ensure the directory exists
			if (!Files.exists(basePath)) {
				throw new FileNotFoundException("Directory not found: " + basePath.toAbsolutePath());
			}

			// Use Files.walk to traverse directories recursively
			return Files.walk(basePath)
					.filter(path -> path.getFileName().toString().matches("valid_certificate_.*\\.json"))
					.map(path -> {
						Path pdfPath = Paths.get(path.toString().replace(".json", ".pdf"));
						return Arguments.of(path, pdfPath);
					});
		}
	}
}
