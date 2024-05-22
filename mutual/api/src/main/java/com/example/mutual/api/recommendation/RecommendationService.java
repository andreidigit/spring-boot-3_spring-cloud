package com.example.mutual.api.recommendation;

import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

public interface RecommendationService {

    /**
     * Sample usage: "curl $HOST:$PORT/recommendation?productId=1".
     *
     * @param productId Id of the product
     * @return the recommendations of the product
     */
    @GetMapping( value = "/recommendation", produces = "application/json")
    Flux<Recommendation> getRecommendations(
            @RequestParam(value = "productId") int productId);

    /**
     * Sample usage, see below.
     *
     * curl -X POST $HOST:$PORT/recommendation \
     *   -H "Content-Type: application/json" --data \
     *   '{"productId":123,"recommendationId":456,"author":"me","rate":5,"content":"bla-bla-bla"}'
     *
     * @param body A JSON representation of the new recommendation
     * @return A JSON representation of the newly created recommendation
     */
    Mono<Recommendation> createRecommendation(@RequestBody Recommendation body);

    Mono<Void> deleteRecommendations(@RequestParam(value = "productId")  int productId);
}
