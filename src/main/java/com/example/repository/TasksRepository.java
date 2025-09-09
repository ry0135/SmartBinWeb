    package com.example.repository;

    import com.example.model.Tasks;
    import org.springframework.data.jpa.repository.JpaRepository;
    import org.springframework.data.jpa.repository.Query;
    import org.springframework.data.repository.query.Param;

    public interface TasksRepository extends JpaRepository<Tasks, Integer> {

        // Đếm số task đang mở/doing của nhân viên
        @Query("SELECT COUNT(t) FROM Tasks t WHERE t.assignedTo.accountId = :workerId AND t.status IN ('OPEN','DOING')")
        int countOpenTasksByWorker(@Param("workerId") int workerId);

        // Trong TasksRepository.java
        @Query("SELECT COUNT(t) FROM Tasks t WHERE t.bin.binID = :binId AND t.status IN ('OPEN','DOING')")
        int countOpenTasksByBin(@Param("binId") int binId);
    }
