package com.example.mutual.api.composite.product;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.List;

@NoArgsConstructor
@AllArgsConstructor
@Getter
public class ProductAggregate {
    private int productId = 0;
    private String name = null;
    private int weight = 0;
    private List<RecommendationSummary> recommendations = null;
    private List<ReviewSummary> reviews = null;
    private ServiceAddresses serviceAddresses = null;
}
