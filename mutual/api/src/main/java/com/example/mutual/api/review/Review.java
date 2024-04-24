package com.example.mutual.api.review;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Review {
    private int productId;
    private int reviewId;
    private String author;
    private String subject;
    private String content;
    private String serviceAddress;
}
