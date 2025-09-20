    package com.example.repository;

    import com.example.dto.TaskSummaryDTO;
    import com.example.model.Task;
    import org.springframework.data.jpa.repository.JpaRepository;
    import org.springframework.data.jpa.repository.Query;
    import org.springframework.data.repository.query.Param;

    import java.util.List;

    public interface TasksRepository extends JpaRepository<Task, Integer> {

        // Đếm số task đang mở/doing của nhân viên
        @Query("SELECT COUNT(t) FROM Task t WHERE t.assignedTo.accountId = :workerId AND t.status IN ('OPEN','DOING')")
        int countOpenTasksByWorker(@Param("workerId") int workerId);

        // Trong TasksRepository.java
        @Query("SELECT COUNT(t) FROM Task t WHERE t.bin.binID = :binId AND t.status IN ('OPEN','DOING')")
        int countOpenTasksByBin(@Param("binId") int binId);

        @Query("SELECT COUNT(t) FROM Task t WHERE t.bin.binID = :binId AND t.status IN ('OPEN','DOING','COMPLETED')")
        int countTasksByBinExclude(@Param("binId") int binId);

        @Query("SELECT t FROM Task t WHERE t.assignedTo.accountId = :workerId AND t.status IN ('OPEN','DOING')")
        List<Task> findOpenTasksByWorker(@Param("workerId") int workerId);
        // 1. Lấy danh sách batch (gom nhóm)
        @Query("SELECT new com.example.dto.TaskSummaryDTO(" +
                "t.batchId, t.assignedTo.accountId, MAX(t.notes), MIN(t.priority)) " +
                "FROM Task t " +
                "WHERE t.assignedTo.accountId = :assignedTo " +
                "GROUP BY t.batchId, t.assignedTo.accountId")
        List<TaskSummaryDTO> findTaskSummaryByAssignedTo(@Param("assignedTo") int assignedTo);


        // 2. Lấy chi tiết task trong batch
        List<Task> findByAssignedTo_AccountIdAndBatchIdOrderByPriorityAsc(int assignedTo, String batchId);
    }
