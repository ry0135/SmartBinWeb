package com.example.repository;

import com.example.model.AiChatLogs;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AiChatLogsRepository extends JpaRepository<AiChatLogs, Integer> {

    // Lịch sử của 1 account, cũ -> mới
    List<AiChatLogs> findByAccountIdOrderByCreatedAtAsc(Integer accountId);

    // Fallback: lấy 200 log mới nhất (nếu chưa có accountId)
    List<AiChatLogs> findTop200ByOrderByCreatedAtDesc();
}
