package com.example.microservices.core.recommendation.persistence;

import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import reactor.core.publisher.Flux;

public interface RecommendationReactiveRepository extends ReactiveCrudRepository<RecommendationEntity, String> {

    Flux<RecommendationEntity> findByProductId(int productId);
}
