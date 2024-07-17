package com.materialidentity.schemaservice;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.DynamicTest;
import org.junit.jupiter.api.TestFactory;
import org.junit.jupiter.api.TestInstance;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.test.autoconfigure.web.reactive.AutoConfigureWebTestClient;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.context.SpringBootTest.WebEnvironment;
import org.springframework.cache.CacheManager;
import org.springframework.test.web.reactive.server.WebTestClient;

@SpringBootTest(webEnvironment = WebEnvironment.RANDOM_PORT)
@TestInstance(TestInstance.Lifecycle.PER_CLASS)
@AutoConfigureWebTestClient
public class RateLimitTest {

    @Autowired
    private WebTestClient webClient;

    @Autowired
    private CacheManager cacheManager;

    @Value("${bucket4j.filters[0].rate-limits[0].bandwidths[0].capacity}")
    private int rateLimitCapacity;

    @BeforeAll
    void setUp() {
        cacheManager.getCache("rate-limit-bucket").clear();
    }

    @TestFactory
    Collection<DynamicTest> rateLimitTest() {
        List<DynamicTest> dynamicTests = new ArrayList<>();

        for (int i = 1; i <= rateLimitCapacity + 1; i++) {
            int repetition = i;
            DynamicTest dynamicTest = DynamicTest.dynamicTest("Test repetition " + repetition, () -> {
                if (repetition <= rateLimitCapacity) {
                    webClient.get().uri("/actuator/health")
                            .exchange()
                            .expectStatus().isOk();
                } else {
                    webClient.get().uri("/actuator/health")
                            .exchange()
                            .expectStatus().isEqualTo(429);
                }
            });
            dynamicTests.add(dynamicTest);
        }

        return dynamicTests;
    }
}
