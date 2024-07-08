package com.materialidentity.schemaservice;

import org.junit.jupiter.api.Test;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.context.SpringBootTest.WebEnvironment;
import org.springframework.http.MediaType;
import org.springframework.test.web.reactive.server.WebTestClient;
import org.springframework.boot.test.autoconfigure.web.reactive.AutoConfigureWebTestClient;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@SpringBootTest(webEnvironment = WebEnvironment.RANDOM_PORT)
@AutoConfigureWebTestClient
class HttpRequestTest {

	@Test
	void renderEndpointTest(@Autowired WebTestClient webClient) throws Exception {
		Path resourceDirectory = Paths.get("src", "test", "resources");
		String testResourcesPath = resourceDirectory.toFile().getAbsolutePath();

		String jsonContent = new String(
				Files.readAllBytes(Paths.get(testResourcesPath + "/schemas/CoA/v1.1.0/valid-cert.json")));
		// byte[] expectedPdfContent = Files
		// .readAllBytes(Paths.get(testResourcesPath +
		// "/schemas/CoA/v1.1.0/valid-cert.pdf"));

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
					// TODO: verify that PDFs match
					// assertArrayEquals(responseBody, expectedPdfContent);
				});
	}
}