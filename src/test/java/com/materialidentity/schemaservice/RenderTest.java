package com.materialidentity.schemaservice;

import java.io.ByteArrayInputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.reactive.AutoConfigureWebTestClient;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.context.SpringBootTest.WebEnvironment;
import org.springframework.http.MediaType;
import org.springframework.test.web.reactive.server.WebTestClient;

import com.itextpdf.text.pdf.PdfReader;
import com.itextpdf.text.pdf.parser.PdfTextExtractor;

@SpringBootTest(webEnvironment = WebEnvironment.RANDOM_PORT)
@AutoConfigureWebTestClient
class HttpRequestTest {

	@Autowired
	private WebTestClient webClient;

	@Test
	void renderEndpointTestCoA() throws Exception {
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
					} catch (Exception e) {
						throw new RuntimeException("PDF comparison failed", e);
					}
				});
	}

	@Test
	void renderEndpointTestEN10168() throws Exception {
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
					} catch (Exception e) {
						throw new RuntimeException("PDF comparison failed", e);
					}
				});
	}

	@Test
	void renderEndpointTestTKR() throws Exception {
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
}
