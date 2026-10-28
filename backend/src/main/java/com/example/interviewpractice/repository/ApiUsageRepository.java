package com.example.interviewpractice.repository;

import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.interviewpractice.entity.ApiUsage;

public interface ApiUsageRepository extends JpaRepository<ApiUsage, UUID> {
}
