package com.example.repository;

import com.example.model.ReportStatusHistory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ReportStatusHistoryRepository extends JpaRepository<ReportStatusHistory, Integer> {
    
    // Tìm lịch sử theo ReportID
    List<ReportStatusHistory> findByReportIdOrderByCreatedAtDesc(Integer reportId);
    
    // Tìm lịch sử theo UpdatedBy
    List<ReportStatusHistory> findByUpdatedByOrderByCreatedAtDesc(Integer updatedBy);
    
    // Tìm lịch sử theo trạng thái
    List<ReportStatusHistory> findByStatusOrderByCreatedAtDesc(String status);
}


