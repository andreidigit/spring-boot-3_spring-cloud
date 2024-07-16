package com.example.microservices.core.product;

import com.example.microservices.core.product.persistence.ProductReactiveRepository;
import com.example.mutual.api.event.Event;
import com.example.mutual.api.exceptions.InvalidInputException;
import com.example.mutual.api.product.Product;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.HttpStatus;
import org.springframework.test.web.reactive.server.WebTestClient;

import java.util.function.Consumer;

import static com.example.mutual.api.event.Event.Type.CREATE;
import static com.example.mutual.api.event.Event.Type.DELETE;
import static org.hamcrest.Matchers.matchesPattern;
import static org.junit.jupiter.api.Assertions.*;
import static org.springframework.boot.test.context.SpringBootTest.WebEnvironment.RANDOM_PORT;
import static org.springframework.http.HttpStatus.*;
import static org.springframework.http.MediaType.APPLICATION_JSON;

@SpringBootTest(webEnvironment = RANDOM_PORT, properties = {
        "eureka.client.enabled=false",
        "spring.cloud.config.enabled=false"})
class ProductServiceApplicationTest extends MongoDbTestBase {
    @Autowired
    private WebTestClient client;
    @Autowired
    private ProductReactiveRepository repository;
    @Autowired
    @Qualifier("messageProcessor")
    private Consumer<Event<Integer, Product>> messageProcessor;

    @BeforeEach
    void setupDb() {
        repository.deleteAll().block();
    }

    @Test
    void getProductById() {
        int productId = 1;
        assertNull(repository.findByProductId(productId).block());
        assertEquals(0, (long)repository.count().block());

        sendCreateProductEvent(productId);

        assertNotNull(repository.findByProductId(productId).block());
        assertEquals(1, (long)repository.count().block());

        getAndVerifyProduct(productId, OK)
                .jsonPath("$.productId").isEqualTo(productId);
    }

    @Test
    void getProductNotFound() {
        int productIdNotFound = 13;
        getAndVerifyProduct(productIdNotFound, NOT_FOUND)
                .jsonPath("$.path").isEqualTo("/product/" + productIdNotFound)
                .jsonPath("$.message").value(matchesPattern("^No product found for productId.*"));
    }

    @Test
    void getProductInvalidId() {
        int productIdInvalid = -1;
        getAndVerifyProduct(productIdInvalid, UNPROCESSABLE_ENTITY)
                .jsonPath("$.path").isEqualTo("/product/" + productIdInvalid)
                .jsonPath("$.message").value(matchesPattern("^Invalid productId.*"));
    }

    @Test
    void getProductInvalidParameter() {
        getAndVerifyProduct("/string", BAD_REQUEST)
                .jsonPath("$.path").isEqualTo("/product/string")
                .jsonPath("$.message").isEqualTo("Type mismatch.");
    }

    @Test
    void duplicateError() {
        int productId = 1;
        assertNull(repository.findByProductId(productId).block());
        sendCreateProductEvent(productId);
        assertNotNull(repository.findByProductId(productId).block());

        InvalidInputException thrown = assertThrows(
                InvalidInputException.class,
                () -> sendCreateProductEvent(productId),
                "Expected a InvalidInputException here!");
        assertEquals("Duplicate key, Product Id: " + productId, thrown.getMessage());
    }

    @Test
    void deleteProduct() {
        int productId = 1;
        sendCreateProductEvent(productId);
        assertNotNull(repository.findByProductId(productId).block());

        sendDeleteProductEvent(productId);
        assertNull(repository.findByProductId(productId).block());

        sendDeleteProductEvent(productId);
    }

    private WebTestClient.BodyContentSpec getAndVerifyProduct(int productId, HttpStatus expectedStatus) {
        return getAndVerifyProduct("/" + productId, expectedStatus);
    }

    private WebTestClient.BodyContentSpec getAndVerifyProduct(String productIdPath, HttpStatus expectedStatus) {
        return client.get()
                .uri("/product" + productIdPath)
                .accept(APPLICATION_JSON)
                .exchange()
                .expectStatus().isEqualTo(expectedStatus)
                .expectHeader().contentType(APPLICATION_JSON)
                .expectBody();
    }

    private void sendCreateProductEvent(int productId) {
        Product product = new Product(productId, "Name " + productId, productId, "SA");
        Event<Integer, Product> event = new Event<>(CREATE, productId, product);
        messageProcessor.accept(event);
    }

    private void sendDeleteProductEvent(int productId) {
        Event<Integer, Product> event = new Event<>(DELETE, productId, null);
        messageProcessor.accept(event);
    }
}
