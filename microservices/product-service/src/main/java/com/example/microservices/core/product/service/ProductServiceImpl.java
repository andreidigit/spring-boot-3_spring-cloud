package com.example.microservices.core.product.service;

import com.example.microservices.core.product.persistence.ProductEntity;
import com.example.microservices.core.product.persistence.ProductReactiveRepository;
import com.example.mutual.api.exceptions.InvalidInputException;
import com.example.mutual.api.exceptions.NotFoundException;
import com.example.mutual.api.product.Product;
import com.example.mutual.api.product.ProductService;
import com.example.mutual.util.http.ServiceUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Mono;

import static java.util.logging.Level.FINE;

@RestController
public class ProductServiceImpl implements ProductService {
    public static final Logger LOG = LoggerFactory.getLogger(ProductServiceImpl.class);

    private final ServiceUtil serviceUtil;
    private final ProductReactiveRepository reactiveRepository;

    private final ProductMapper mapper;

    @Autowired
    public ProductServiceImpl(ServiceUtil serviceUtil, ProductReactiveRepository reactiveRepository, ProductMapper mapper) {
        this.serviceUtil = serviceUtil;
        this.reactiveRepository = reactiveRepository;
        this.mapper = mapper;
    }

    @Override
    public Mono<Product> getProduct(int productId) {
        if (productId < 1) {
            throw new InvalidInputException("Invalid productId: " + productId);
        }
        LOG.info("Will get product info for id={}", productId);

        return reactiveRepository.findByProductId(productId)
                .switchIfEmpty(Mono.error(new NotFoundException("No product found for productId: " + productId)))
                .log(LOG.getName(), FINE)
                .map(mapper::entityToApi)
                .map(this::setServiceAddress);
    }

    private Product setServiceAddress(Product e) {
        e.setServiceAddress(serviceUtil.getServiceAddress());
        return e;
    }

    @Override
    public Mono<Product> createProduct(Product body) {

        if (body.getProductId() < 1) {
            throw new InvalidInputException("Invalid productId: " + body.getProductId());
        }
        ProductEntity entity = mapper.apiToEntity(body);
        return reactiveRepository.save(entity)
                .log(LOG.getName(), FINE)
                .onErrorMap(
                        DuplicateKeyException.class,
                        ex -> new InvalidInputException("Duplicate key, Product Id: " + body.getProductId()))
                .map(mapper::entityToApi);
    }

    @Override
    public Mono<Void> deleteProduct(int productId) {
        if (productId < 1) {
            throw new InvalidInputException("Invalid productId: " + productId);
        }
        LOG.debug("deleteProduct: tries to delete an entity with productId: {}", productId);
        return reactiveRepository
                .findByProductId(productId)
                .log(LOG.getName(), FINE)
                .map(reactiveRepository::delete)
                .flatMap(e -> e);
    }
}
