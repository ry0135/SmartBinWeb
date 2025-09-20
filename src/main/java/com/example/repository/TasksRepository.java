package com.example.repository;

import com.example.model.Task;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;

public interface TasksRepository extends JpaRepository<Task, Integer> {

    @Query("SELECT COUNT(t) FROM Task t WHERE t.assignedTo.accountId = :workerId AND t.status IN ('OPEN','DOING')")
    int countOpenTasksByWorker(@Param("workerId") int workerId);

    @Query("SELECT COUNT(t) FROM Task t WHERE t.bin.binID = :binId AND t.status IN ('OPEN','DOING')")
    int countOpenTasksByBin(@Param("binId") int binId);

    // Thêm phương thức mới
    @Query("SELECT t FROM Task t WHERE t.batchId = :batchId ORDER BY t.createdAt DESC")
    List<Task> findByBatchId(@Param("batchId") String batchId);

    @Query("SELECT t FROM Task t WHERE t.assignedTo.accountId = :workerId AND t.status IN ('OPEN','DOING')")
    List<Task> findOpenTasksByWorker(@Param("workerId") int workerId);
    @Query("SELECT COUNT(t) FROM Task t WHERE t.bin.binID = :binId AND t.status IN ('OPEN','DOING','COMPLETED')")
    int countTasksByBinExclude(@Param("binId") int binId);

}