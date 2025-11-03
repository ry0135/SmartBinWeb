package com.example.repository;

import com.example.model.Feedback;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FeedbackRepository extends JpaRepository<Feedback, Integer> {
    @Query("SELECT f FROM Feedback f JOIN FETCH f.account")
    List<Feedback> findAllWithAccount();
}
