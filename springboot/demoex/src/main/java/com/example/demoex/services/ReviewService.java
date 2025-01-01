package com.example.demoex.services;

import com.example.demoex.repositories.ReviewRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service

public class ReviewService {
    // DI, 생성자 방식 구현
    private final ReviewRepository reviewRepository;
}