package com.example.repository;

import com.example.model.Report;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.stereotype.Repository;
import java.util.Date;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface ReportRepository extends JpaRepository<Report, Integer> {
    List<Report> findAll();

    Report findByReportId(Integer reportId);

    // Tìm báo cáo theo AccountID
    List<Report> findByAccountIdOrderByCreatedAtDesc(Integer accountId);

    // Tìm báo cáo theo trạng thái
    List<Report> findByStatusOrderByCreatedAtDesc(String status);

    // Tìm báo cáo theo BinID
    List<Report> findByBinIdOrderByCreatedAtDesc(Integer binId);

    // Tìm báo cáo theo AssignedTo
    List<Report> findByAssignedToOrderByCreatedAtDesc(Integer assignedTo);

    // Tìm báo cáo theo khoảng thời gian
    @Query("SELECT r FROM Report r WHERE r.createdAt BETWEEN :startDate AND :endDate ORDER BY r.createdAt DESC")
    List<Report> findByDateRange(@Param("startDate") LocalDateTime startDate,
                                 @Param("endDate") LocalDateTime endDate);

    // Đếm báo cáo theo trạng thái
    long countByStatus(String status);

    // Đếm báo cáo theo AccountID
    long countByAccountId(Integer accountId);

    // Tìm báo cáo theo ReportType
    List<Report> findByReportTypeOrderByCreatedAtDesc(String reportType);

    // Tìm báo cáo theo nhiều trạng thái
    @Query("SELECT r FROM Report r WHERE r.status IN :statuses ORDER BY r.createdAt DESC")
    List<Report> findByStatusInOrderByCreatedAtDesc(@Param("statuses") List<String> statuses);

    @Query("SELECT r FROM Report r WHERE r.bin.binID = :binId " +
            "AND r.reportType IN ('FULL','OVERLOAD') " +
            "ORDER BY r.createdAt DESC")
    Report findLatestFullOrOverload(@Param("binId") int binId);


    @Query("""
    SELECT r FROM Report r
    WHERE r.bin.binID IN :binIds
      AND r.reportType IN ('FULL', 'OVERLOAD')
      AND r.status = 'RECEIVED'
    """)
    List<Report> findFullOrOverloadReports(@Param("binIds") List<Integer> binIds);

    @Modifying(clearAutomatically = true, flushAutomatically = true)
    @Query("""
    UPDATE Report r
    SET r.status = 'IN_PROGRESS',
        r.assignedTo = :workerId,
        r.updatedAt = CURRENT_TIMESTAMP
    WHERE r.reportId IN (:ids)
    """)
    int updateReportsToInProgress(
            @Param("ids") List<Integer> reportIds,
            @Param("workerId") Integer workerId
    );


    @Modifying(clearAutomatically = true, flushAutomatically = true)
    @Query("""
UPDATE Report r
SET r.status = 'RESOLVED',
    r.updatedAt = CURRENT_TIMESTAMP,
    r.resolvedAt = CURRENT_TIMESTAMP,
    r.assignedTo = :workerId,
    r.taskId = :taskId
WHERE r.binId = :binId
  AND r.reportType IN ('FULL', 'OVERLOAD')
  AND r.status IN ('RECEIVED', 'IN_PROGRESS')
""")
    int resolveReportsByBin(
            @Param("binId") int binId,
            @Param("workerId") int workerId,
            @Param("taskId") int taskId
    );

}



