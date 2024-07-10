package com.materialidentity.schemaservice;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Map;

import org.apache.pdfbox.Loader;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDDocumentNameDictionary;
import org.apache.pdfbox.pdmodel.common.filespecification.PDComplexFileSpecification;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.reactive.AutoConfigureWebTestClient;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.context.SpringBootTest.WebEnvironment;
import org.springframework.http.MediaType;
import org.springframework.test.web.reactive.server.WebTestClient;

import com.itextpdf.text.pdf.PdfReader;
import com.itextpdf.text.pdf.parser.PdfTextExtractor;
import com.materialidentity.schemaservice.config.SchemaControllerConstants;

@SpringBootTest(webEnvironment = WebEnvironment.RANDOM_PORT)
@AutoConfigureWebTestClient
class HttpRequestTest {

	@Autowired
	private WebTestClient webClient;

	@Test
	void CoA_renderEndpointTest_WithJsonAttachment() throws Exception {
		Path resourceDirectory = Paths.get("src", "test", "resources");
		String testResourcesPath = resourceDirectory.toFile().getAbsolutePath();

		String jsonContent = new String(
				Files.readAllBytes(Paths.get(testResourcesPath + "/schemas/CoA/v1.1.0/valid-cert.json")));
		byte[] expectedPdfContent = Files
				.readAllBytes(Paths.get(testResourcesPath + "/schemas/CoA/v1.1.0/valid-cert.pdf"));

		webClient
				.post().uri(uriBuilder -> uriBuilder
						.path("/api/render")
						.queryParam("schemaType", "CoA")
						.queryParam("schemaVersion", "v1.1.0")
						.queryParam("languages", "EN, FR")
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
								SchemaControllerConstants.PDF_ATTACHMENT_CERT_FILE_NAME, jsonContent.getBytes(), true);
					} catch (Exception e) {
						throw new RuntimeException("PDF comparison failed", e);
					}
				});
	}

	@Test
	void EN10168_renderEndpointTest_WithoutJsonAttachment() throws Exception {
		Path resourceDirectory = Paths.get("src", "test", "resources");
		String testResourcesPath = resourceDirectory.toFile().getAbsolutePath();

		String jsonContent = new String(
				Files.readAllBytes(Paths.get(testResourcesPath + "/schemas/EN10168/v0.4.1/valid-cert.json")));
		byte[] expectedPdfContent = Files
				.readAllBytes(Paths.get(testResourcesPath + "/schemas/EN10168/v0.4.1/valid-cert.pdf"));

		webClient
				.post().uri(uriBuilder -> uriBuilder
						.path("/api/render")
						.queryParam("schemaType", "EN10168")
						.queryParam("schemaVersion", "v0.4.1")
						.queryParam("languages", "EN")
						.queryParam("attachJson", "false")
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

	@Test
	void TKR_renderEndpointTest_WithJsonAttachment() throws Exception {
		Path resourceDirectory = Paths.get("src", "test", "resources");
		String testResourcesPath = resourceDirectory.toFile().getAbsolutePath();

		String jsonContent = new String(
				Files.readAllBytes(Paths.get(testResourcesPath + "/schemas/TKR/v0.0.4/valid-cert.json")));
		byte[] expectedPdfContent = Files
				.readAllBytes(Paths.get(testResourcesPath + "/schemas/TKR/v0.0.4/valid-cert.pdf"));

		webClient
				.post().uri(uriBuilder -> uriBuilder
						.path("/api/render")
						.queryParam("schemaType", "TKR")
						.queryParam("schemaVersion", "v0.0.4")
						.queryParam("languages", "EN")
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
								SchemaControllerConstants.PDF_ATTACHMENT_CERT_FILE_NAME, jsonContent.getBytes(), true);
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
				if (!java.util.Arrays.equals(expectedEmbeddedFileContent, embeddedFileContent)) {
					throw new AssertionError("Embedded file content does not match the expected content");
				}
			} else if (shouldExist) {
				throw new AssertionError(
						"Embedded file '" + embeddedFileName + "' not found in the PDF, but it was expected");
			}
		}
	}

}
