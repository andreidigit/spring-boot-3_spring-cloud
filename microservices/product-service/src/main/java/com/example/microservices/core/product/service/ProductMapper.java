package com.example.microservices.core.product.service;

import com.example.microservices.core.product.persistence.ProductEntity;
import com.example.mutual.api.product.Product;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Mappings;

@Mapper(componentModel = "spring")
public interface ProductMapper {
    @Mappings({@Mapping(target = "serviceAddress", ignore = true)})
    Product entityToApi(ProductEntity entity);

    @Mappings({
            @Mapping(target = "id", ignore = true), @Mapping(target = "version", ignore = true)
    })
    ProductEntity apiToEntity(Product api);
}
