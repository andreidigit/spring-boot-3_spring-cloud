package com.example.mutual.api.composite.product;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class RecommendationSummary {
    private int recommendationId;
    private String author;
    private int rate;
    private String content;
}
