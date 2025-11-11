package com.example.repository;

import com.example.model.BinLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import javax.transaction.Transactional;

@Repository
public interface BinLogRepository extends JpaRepository<BinLog, Integer> {

    BinLog findTopByBinIdOrderByRecordedAtDesc(int binId);

    //  Xóa các bản ghi cũ hơn 7 ngày, nhưng chỉ nếu Bin có log mới hơn
    @Modifying
    @Transactional
    @Query(value = """
        DELETE FROM BinLog
        WHERE RecordedAt < DATEADD(DAY, -7, GETDATE())
          AND BinID IN (
              SELECT DISTINCT BinID
              FROM BinLog
              WHERE RecordedAt >= DATEADD(DAY, -7, GETDATE())
          )
        """, nativeQuery = true)
    int deleteOldLogs();
}
