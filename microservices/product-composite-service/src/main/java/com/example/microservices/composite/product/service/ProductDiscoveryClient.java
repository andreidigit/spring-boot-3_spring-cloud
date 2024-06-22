package com.example.microservices.composite.product.service;

import com.example.mutual.api.product.Product;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.client.ServiceInstance;
import org.springframework.cloud.client.discovery.DiscoveryClient;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import java.util.List;

@Component
public class ProductDiscoveryClient {
    @Autowired
    private DiscoveryClient discoveryClient;
    @Autowired
    private RestTemplate restTemplate;

    public Product getProduct(Integer id) {
        List<ServiceInstance> instances = discoveryClient.getInstances("product");
        String url = String.format("%s/product/%s", instances.get(0).getUri().toString(), id);
        return restTemplate.getForObject(url, Product.class);
    }
}
