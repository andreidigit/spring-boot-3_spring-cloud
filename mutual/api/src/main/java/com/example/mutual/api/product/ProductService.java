package com.example.mutual.api.product;

import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Mono;

public interface ProductService {

    /**
     * Sample usage: "curl $HOST:$PORT/product/1"
     * @param productId Id of the product
     * @return Product
     */
    @GetMapping(value = "/product/{productId}", produces = "application/json")
    Mono<Product> getProduct(@PathVariable int productId);

    /**
     * Sample usage, see below.
     *
     * curl -X POST $HOST:$PORT/product \
     *   -H "Content-Type: application/json" --data \
     *   '{"productId":123,"name":"product 123","weight":123}'
     *
     * @param body A JSON representation of the new product
     * @return A JSON representation of the newly created product
     */
    Mono<Product> createProduct(@RequestBody Product body);

    Mono<Void> deleteProduct(@PathVariable int productId);
}
