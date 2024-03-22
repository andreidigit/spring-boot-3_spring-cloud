package com.example.mutual.api.composite.product;

public class ServiceAddresses {
    private final String compose;
    private final String product;
    private final String review;
    private final String recommend;

    public ServiceAddresses() {
        compose = null;
        product = null;
        review = null;
        recommend = null;
    }

    public ServiceAddresses(String compose, String product, String review, String recommend) {
        this.compose = compose;
        this.product = product;
        this.review = review;
        this.recommend = recommend;
    }

    public String getCompose() {
        return compose;
    }

    public String getProduct() {
        return product;
    }

    public String getReview() {
        return review;
    }

    public String getRecommend() {
        return recommend;
    }
}
