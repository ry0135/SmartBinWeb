package com.example.repository;

import com.example.dto.TaskSummaryDTO;
import com.example.model.Task;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Date;
import java.util.List;
import java.util.Optional;

public interface TasksRepository extends JpaRepository<Task, Integer> {
        // Đếm số task đang mở/doing của nhân viên
        @Query("SELECT COUNT(t) FROM Task t WHERE t.assignedTo.accountId = :workerId AND t.status IN ('OPEN','DOING')")
        int countOpenTasksByWorker(@Param("workerId") int workerId);

        // Trong TasksRepository.java
        @Query("SELECT COUNT(t) FROM Task t WHERE t.bin.binID = :binId AND t.status IN ('OPEN','DOING')")
        int countOpenTasksByBin(@Param("binId") int binId);

        @Query("SELECT COUNT(t) FROM Task t WHERE t.bin.binID = :binId AND t.status IN ('OPEN','DOING')")
        int countTasksByBinExclude(@Param("binId") int binId);
        @Query("SELECT t FROM Task t WHERE t.batchId = :batchId ORDER BY t.createdAt DESC")
        List<Task> findByBatchId(@Param("batchId") String batchId);
        @Query("SELECT t FROM Task t WHERE t.batchId = :batchId AND t.status = 'OPEN' ORDER BY t.createdAt DESC")
        List<Task> findByBatchIdOpen(@Param("batchId") String batchId);
        @Query("SELECT t FROM Task t WHERE t.batchId = :batchId AND t.status IN ('COMPLETED','DOING') ORDER BY t.createdAt DESC")
        List<Task> findByBatchIdDoing(@Param("batchId") String batchId);
        @Query("SELECT t FROM Task t WHERE t.batchId = :batchId AND t.status = 'COMPLETED' ORDER BY t.createdAt DESC")
        List<Task> findByBatchIdCompeleted(@Param("batchId") String batchId);
        @Query("SELECT t FROM Task t WHERE t.batchId = :batchId AND t.status = 'CANCEL' ORDER BY t.createdAt DESC")
        List<Task> findByBatchIdCancel(@Param("batchId") String batchId);
        @Query("SELECT t FROM Task t WHERE t.assignedTo.accountId = :workerId AND t.status IN ('OPEN','DOING')")
        List<Task> findOpenTasksByWorker(@Param("workerId") int workerId);

        // 1. Lấy danh sách batch (gom nhóm)
        @Query("SELECT new com.example.dto.TaskSummaryDTO(" +
                "t.batchId, " +
                "t.assignedTo.accountId, " +
                "MAX(t.notes), " +
                "MIN(t.priority), " +
                // Logic mới: DOING (3) > COMPLETED (2) > ISSUE (1)
                "CASE " +
                "WHEN MAX(CASE WHEN t.status = 'DOING' THEN 3 WHEN t.status = 'COMPLETED' THEN 2 ELSE 1 END) = 3 THEN 'DOING' " +
                "WHEN MAX(CASE WHEN t.status = 'COMPLETED' THEN 2 WHEN t.status = 'DOING' THEN 3 ELSE 1 END) = 2 THEN 'COMPLETED' " +
                "ELSE 'ISSUE' " +
                "END, " +
                "MIN(t.createdAt)) " +
                "FROM Task t " +
                "WHERE t.assignedTo.accountId = :assignedTo " +
                "GROUP BY t.batchId, t.assignedTo.accountId")
        List<TaskSummaryDTO> findTaskSummaryByAssignedTo(@Param("assignedTo") int assignedTo);



        // 2. Lấy chi tiết task trong batch
        List<Task> findByAssignedTo_AccountIdAndBatchIdOrderByPriorityAsc(int assignedTo, String batchId);

        // Thêm vào TasksRepository.java

        @Modifying
        @Query("DELETE FROM Task t WHERE t.batchId = :batchId")
        void deleteByBatchId(@Param("batchId") String batchId);


        // Trong TasksRepository.java
        @Query("SELECT t FROM Task t WHERE t.status = 'DOING' ORDER BY t.createdAt DESC")
        List<Task> findDoingTasks();
        @Query("SELECT t FROM Task t WHERE t.status = 'OPEN' ORDER BY t.createdAt DESC")
        List<Task> findOpenTasks();
        @Query("SELECT t FROM Task t WHERE t.status = 'COMPLETED' ORDER BY t.createdAt DESC")
        List<Task> findCompletedTasks();
        @Query("SELECT t FROM Task t WHERE t.status = 'CANCEL' ORDER BY t.createdAt DESC")
        List<Task> findCancelTasks();

        // Lấy doing tasks theo worker
        @Query("SELECT t FROM Task t WHERE t.status = 'DOING' AND t.assignedTo.accountId = :workerId ORDER BY t.createdAt DESC")
        List<Task> findDoingTasksByWorker(@Param("workerId") int workerId);

        // Lấy doing tasks theo batch
        @Query("SELECT t FROM Task t WHERE t.status = 'DOING' AND t.batchId = :batchId ORDER BY t.createdAt DESC")
        List<Task> findDoingTasksByBatch(@Param("batchId") String batchId);
        // Đếm theo trạng thái
        @Query("SELECT t.status, COUNT(t) FROM Task t GROUP BY t.status")
        List<Object[]> countTasksByStatus();

        // Đếm theo Priority
        @Query("SELECT CAST(t.priority AS string), COUNT(t) FROM Task t GROUP BY t.priority")
        List<Object[]> countTasksByPriority();

        // Số task đang mở (OPEN + IN_PROGRESS)
        @Query("SELECT COUNT(t) FROM Task t WHERE t.status IN ('OPEN','IN_PROGRESS')")
        long countOpenTasks();

        // Task tạo mới theo ngày
        @Query(
                value = "SELECT CAST(CreatedAt AS date) AS CreatedDate, COUNT(*) AS Total " +
                        "FROM Tasks " +
                        "WHERE CreatedAt BETWEEN :start AND :end " +
                        "GROUP BY CAST(CreatedAt AS date) " +
                        "ORDER BY CreatedDate",
                nativeQuery = true
        )
        List<Object[]> countTasksCreatedByDate(@Param("start") Date start,
                                               @Param("end") Date end);

        // Task hoàn thành theo ngày
        @Query(
                value = "SELECT CAST(CompletedAt AS date) AS CompletedDate, COUNT(*) AS Total " +
                        "FROM Tasks " +
                        "WHERE CompletedAt IS NOT NULL " +
                        "  AND CompletedAt BETWEEN :start AND :end " +
                        "GROUP BY CAST(CompletedAt AS date) " +
                        "ORDER BY CompletedDate",
                nativeQuery = true
        )
        List<Object[]> countTasksCompletedByDate(@Param("start") Date start,
                                                 @Param("end") Date end);

        // Hiệu suất xử lý theo nhân viên
        @Query(
                value = "SELECT a.FullName, COUNT(*) AS Total " +
                        "FROM Tasks t " +
                        "JOIN Accounts a ON t.AssignedTo = a.AccountID " +
                        "WHERE t.Status = 'COMPLETED' " +
                        "GROUP BY a.FullName " +
                        "ORDER BY Total DESC",
                nativeQuery = true
        )
        List<Object[]> taskPerformanceByUser();

        // Task trễ theo nhân viên
        @Query(
                value = "SELECT a.FullName, COUNT(*) AS LateTotal " +
                        "FROM Tasks t " +
                        "JOIN Accounts a ON t.AssignedTo = a.AccountID " +
                        "WHERE t.dueAt IS NOT NULL " +
                        "  AND t.CompletedAt IS NOT NULL " +
                        "  AND t.CompletedAt > t.dueAt " +
                        "GROUP BY a.FullName " +
                        "ORDER BY LateTotal DESC",
                nativeQuery = true
        )
        List<Object[]> lateTasksByUser();

        // Đếm task trễ hạn
        @Query(
                value = "SELECT COUNT(*) " +
                        "FROM Tasks " +
                        "WHERE dueAt IS NOT NULL " +
                        "  AND CompletedAt IS NOT NULL " +
                        "  AND CompletedAt > dueAt",
                nativeQuery = true
        )
        long countOverdueTasks();

        // SLA task: on-time vs total
        @Query(
                value = "SELECT " +
                        "  SUM(CASE WHEN dueAt IS NOT NULL AND CompletedAt IS NOT NULL AND CompletedAt <= dueAt THEN 1 ELSE 0 END) AS OnTime, " +
                        "  SUM(CASE WHEN dueAt IS NOT NULL AND CompletedAt IS NOT NULL THEN 1 ELSE 0 END) AS TotalWithDue " +
                        "FROM Tasks",
                nativeQuery = true
        )
        Object[] countOnTimeVsTotal();

        @Query("SELECT t FROM Task t WHERE t.batchId = :batchId")
        List<Task> findTaskByBatchId(@Param("batchId") String batchId);
        @Query("SELECT t FROM Task t WHERE t.status = 'ISSUE' ORDER BY t.createdAt DESC")
        List<Task> findIssueTasks();
        @Query("SELECT t FROM Task t WHERE t.batchId = :batchId AND t.status = 'ISSUE'")
        List<Task> findIssueTasksByBatch(@Param("batchId") String batchId);

}


