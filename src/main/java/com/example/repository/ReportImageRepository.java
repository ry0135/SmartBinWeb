package com.example.repository;

import com.example.model.ReportImage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ReportImageRepository extends JpaRepository<ReportImage, Integer> {
    
    // Tìm hình ảnh theo ReportID
    List<ReportImage> findByReportIdOrderByCreatedAtDesc(Integer reportId);
    
    // Đếm số hình ảnh theo ReportID
    long countByReportId(Integer reportId);
}


