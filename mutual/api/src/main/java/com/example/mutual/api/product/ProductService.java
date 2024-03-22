package com.example.mutual.api.product;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

public interface ProductService {

    /**
     * Sample usage: "curl $HOST:$PORT/product/1"
     * @param productId Id of the product
     * @return Product
     */
    @GetMapping(value = "/product/{productId}", produces = "application/json")
    Product getProduct(@PathVariable int productId);
}
