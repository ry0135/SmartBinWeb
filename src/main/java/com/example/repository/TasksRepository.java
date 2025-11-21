package com.example.repository;

import com.example.dto.TaskSummaryDTO;
import com.example.model.Task;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
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
                "MAX(t.status), " +
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

        @Query("SELECT t FROM Task t WHERE t.batchId = :batchId")
        List<Task> findTaskByBatchId(@Param("batchId") String batchId);

}


