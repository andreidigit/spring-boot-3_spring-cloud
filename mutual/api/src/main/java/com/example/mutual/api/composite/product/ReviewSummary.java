package com.example.mutual.api.composite.product;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ReviewSummary {
    private int reviewId;
    private String author;
    private String subject;
    private String content;
}
