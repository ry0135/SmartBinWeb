package com.example.repository;

import com.example.model.Chat;
import com.example.model.Account;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ChatRepository extends JpaRepository<Chat, Integer> {
    List<Chat> findBySenderAndReceiverOrderBySentAtAsc(Account sender, Account receiver);
    List<Chat> findByReceiverAndSenderOrderBySentAtAsc(Account receiver, Account sender);
    // 1 chiều

    // đếm chưa đọc (from -> to)
    long countByReceiverAndSenderAndIsReadFalse(Account receiver, Account sender);
}
