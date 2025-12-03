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

    // ==========================
    // CÁC HÀM TÌM KIẾM HIỆN TẠI
    // ==========================
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
    @Query("SELECT r FROM Report r " +
            "WHERE r.status IN :statuses " +
            "ORDER BY r.createdAt DESC")
    List<Report> findByStatusInOrderByCreatedAtDesc(@Param("statuses") List<String> statuses);


    // ==========================
    // CÁC HÀM THỐNG KÊ DASHBOARD
    // ==========================

    // Tổng số báo cáo
    @Query("SELECT COUNT(r) FROM Report r")
    long countAllReports();

    // Đếm báo cáo trong khoảng thời gian (dùng cho: hôm nay, tháng này, 7 ngày gần nhất...)
    @Query("SELECT COUNT(r) FROM Report r " +
            "WHERE r.createdAt BETWEEN :start AND :end")
    long countReportsBetween(@Param("start") LocalDateTime start,
                             @Param("end") LocalDateTime end);

    // Đếm báo cáo RESOLVED trong khoảng thời gian (để tính % báo cáo xử lý trong tháng)
    @Query("SELECT COUNT(r) FROM Report r " +
            "WHERE r.status = 'RESOLVED' " +
            "AND r.createdAt BETWEEN :start AND :end")
    long countResolvedReportsBetween(@Param("start") LocalDateTime start,
                                     @Param("end") LocalDateTime end);

    // Đếm báo cáo theo trạng thái – donut chart
    @Query("SELECT r.status, COUNT(r) FROM Report r GROUP BY r.status")
    List<Object[]> countReportsByStatus();

    // Báo cáo theo ngày (line chart – dùng native SQL Server)
    @Query(
            value = "SELECT CAST(CreatedAt AS date) AS ReportDate, COUNT(*) AS Total " +
                    "FROM Reports " +
                    "WHERE CreatedAt BETWEEN :start AND :end " +
                    "GROUP BY CAST(CreatedAt AS date) " +
                    "ORDER BY ReportDate",
            nativeQuery = true
    )
    List<Object[]> countReportsByDate(@Param("start") LocalDateTime start,
                                      @Param("end") LocalDateTime end);

    // Báo cáo theo loại sự cố (ReportType) – bar chart
    @Query("SELECT r.reportType, COUNT(r) FROM Report r GROUP BY r.reportType")
    List<Object[]> countReportsByType();

    // Thời gian xử lý trung bình (giờ) – CreatedAt → ResolvedAt
    @Query(
            value = "SELECT AVG(DATEDIFF(MINUTE, CreatedAt, ResolvedAt)) / 60.0 " +
                    "FROM Reports " +
                    "WHERE ResolvedAt IS NOT NULL",
            nativeQuery = true
    )
    Double avgResolveHours();

    // SLA: báo cáo xử lý đúng hạn / trễ hạn (join với Tasks qua TaskID)
    @Query(
            value = "SELECT " +
                    "  CASE " +
                    "    WHEN t.CompletedAt IS NOT NULL AND t.dueAt IS NOT NULL AND t.CompletedAt <= t.dueAt THEN N'Đúng hạn' " +
                    "    WHEN t.CompletedAt IS NOT NULL AND t.dueAt IS NOT NULL AND t.CompletedAt > t.dueAt THEN N'Trễ hạn' " +
                    "  END AS Label, " +
                    "  COUNT(*) AS Total " +
                    "FROM Reports r " +
                    "JOIN Tasks t ON r.TaskID = t.TaskID " +
                    "WHERE t.dueAt IS NOT NULL " +
                    "  AND t.CompletedAt IS NOT NULL " +
                    "GROUP BY CASE " +
                    "  WHEN t.CompletedAt IS NOT NULL AND t.dueAt IS NOT NULL AND t.CompletedAt <= t.dueAt THEN N'Đúng hạn' " +
                    "  WHEN t.CompletedAt IS NOT NULL AND t.dueAt IS NOT NULL AND t.CompletedAt > t.dueAt THEN N'Trễ hạn' " +
                    "END",
            nativeQuery = true
    )
    List<Object[]> slaOnTimeVsLate();

    // Top 5 thùng bị báo cáo nhiều nhất – bar chart ngang
    @Query(
            value = "SELECT TOP 5 b.BinCode, COUNT(*) AS Total " +
                    "FROM Reports r " +
                    "JOIN Bins b ON r.BinID = b.BinID " +
                    "GROUP BY b.BinCode " +
                    "ORDER BY Total DESC",
            nativeQuery = true
    )
    List<Object[]> topReportedBins();

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



