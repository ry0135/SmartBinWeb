package com.example.repository;

import com.example.model.Feedback;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FeedbackRepository extends JpaRepository<Feedback, Integer> {

    boolean existsByAccountIdAndReportId(Integer accountId, Integer reportId);

    @Query("SELECT f FROM Feedback f JOIN FETCH f.account")
    List<Feedback> findAllWithAccount();


    // Tìm feedback theo AccountID
    List<Feedback> findByAccountIdOrderByCreatedAtDesc(Integer accountId);

    // Tìm feedback theo WardID
//    List<Feedback> findByWardIdOrderByCreatedAtDesc(Integer wardId);

    // Tìm feedback theo ReportID
    List<Feedback> findByReportIdOrderByCreatedAtDesc(Integer reportId);

    // Tính điểm trung bình theo WardID
//    @Query("SELECT AVG(f.rating) FROM Feedback f WHERE f.wardId = :wardId")
//    Double getAverageRatingByWardId(@Param("wardId") Integer wardId);

    // Đếm feedback theo WardID
//    long countByWardId(Integer wardId);

    // Đếm feedback theo rating
    long countByRating(Integer rating);

//    // Đếm feedback theo WardID và Rating
//    long countByWardIdAndRating(Integer wardId, Integer rating);

    // Tìm feedback theo khoảng rating
    @Query("SELECT f FROM Feedback f WHERE f.rating BETWEEN :minRating AND :maxRating ORDER BY f.createdAt DESC")
    List<Feedback> findByRatingBetweenOrderByCreatedAtDesc(@Param("minRating") Integer minRating, 
                                                          @Param("maxRating") Integer maxRating);

    @Query("SELECT AVG(CAST(f.rating AS double)) FROM Feedback f")
    Double avgRating();



    boolean existsByReportId(Integer reportId);
}
