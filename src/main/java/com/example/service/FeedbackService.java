package com.example.service;

import com.example.controller.app.FeedbackAppController;
import com.example.model.Feedback;
import com.example.model.Report;
import com.example.repository.FeedbackRepository;
import com.example.repository.ReportRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityNotFoundException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class FeedbackService {



    @Autowired
    private FeedbackRepository feedbackRepository;
    @Autowired
    private ReportRepository reportRepository;
    // Tạo feedback mới
    public Feedback createFeedback(Feedback feedback) {
        feedback.setCreatedAt(LocalDateTime.now());
        return feedbackRepository.save(feedback);
    }
    @Transactional // Đảm bảo toàn bộ logic là một giao dịch
    public Feedback createFeedbackAndUpdateReport(FeedbackAppController.FeedbackRequest request) {
        Report report = reportRepository.findByReportId(request.getReportId());

        if (report == null) {
            throw new EntityNotFoundException("Report không tồn tại"); // Hoặc exception phù hợp
        }

        // 1. Tạo feedback
        Feedback feedback = new Feedback();
        feedback.setAccountId(request.getAccountId());
        feedback.setRating(request.getRating());
        feedback.setComment(request.getComment());
        feedback.setReportId(request.getReportId());
        feedback.setCreatedAt(LocalDateTime.now());
        // Lấy WardID từ Bin của Report (Đảm bảo mối quan hệ Report -> Bin là EAGER hoặc đã được fetch)

        Feedback createdFeedback = feedbackRepository.save(feedback); // Lưu feedback

        // 2. Cập nhật trạng thái report
        report.setStatus("DONE");
        reportRepository.save(report); // Cập nhật report (Cả 2 đều commit khi phương thức này kết thúc thành công)

        return createdFeedback;
    }


    // Lấy feedback theo ID
    public Optional<Feedback> getFeedbackById(Integer feedbackId) {
        return feedbackRepository.findById(feedbackId);
    }

    // Lấy feedback theo AccountID
    public List<Feedback> getFeedbacksByAccountId(Integer accountId) {
        return feedbackRepository.findByAccountIdOrderByCreatedAtDesc(accountId);
    }

    // Lấy feedback theo WardID
    public List<Feedback> getFeedbacksByWardId(Integer wardId) {
        return feedbackRepository.findByWardIdOrderByCreatedAtDesc(wardId);
    }

    // Lấy feedback theo ReportID
    public List<Feedback> getFeedbacksByReportId(Integer reportId) {
        return feedbackRepository.findByReportIdOrderByCreatedAtDesc(reportId);
    }

    // Lấy tất cả feedback
    public List<Feedback> getAllFeedbacks() {
        return feedbackRepository.findAll();
    }

    // Tính điểm trung bình theo WardID
//    public Double getAverageRatingByWardId(Integer wardId) {
//        return feedbackRepository.getAverageRatingByWardId(wardId);
//    }

    // Đếm feedback theo WardID
//    public long countFeedbacksByWardId(Integer wardId) {
//        return feedbackRepository.countByWardId(wardId);
//    }

    // Đếm feedback theo rating
    public long countFeedbacksByRating(Integer rating) {
        return feedbackRepository.countByRating(rating);
    }

    // Đếm feedback theo WardID và Rating
//    public long countFeedbacksByWardIdAndRating(Integer wardId, Integer rating) {
//        return feedbackRepository.countByWardIdAndRating(wardId, rating);
//    }

    // Lấy feedback theo khoảng rating
    public List<Feedback> getFeedbacksByRatingRange(Integer minRating, Integer maxRating) {
        return feedbackRepository.findByRatingBetweenOrderByCreatedAtDesc(minRating, maxRating);
    }

//    // Lấy thống kê feedback theo WardID
//    public FeedbackStats getFeedbackStatsByWardId(Integer wardId) {
//        Double averageRating = getAverageRatingByWardId(wardId);
//        long totalFeedbacks = countFeedbacksByWardId(wardId);
//
//        FeedbackStats stats = new FeedbackStats();
//        stats.setWardId(wardId);
//        stats.setAverageRating(averageRating != null ? averageRating : 0.0);
//        stats.setTotalFeedbacks(totalFeedbacks);
//
//        // Đếm theo từng rating
//        for (int i = 1; i <= 5; i++) {
//            long count = countFeedbacksByWardIdAndRating(wardId, i);
//            stats.setRatingCount(i, count);
//        }
//
//        return stats;
//    }

    // Lấy thống kê tổng quan
    public OverallFeedbackStats getOverallFeedbackStats() {
        OverallFeedbackStats stats = new OverallFeedbackStats();

        // Đếm tổng feedback
        stats.setTotalFeedbacks(feedbackRepository.count());

        // Tính điểm trung bình tổng
        List<Feedback> allFeedbacks = getAllFeedbacks();
        if (!allFeedbacks.isEmpty()) {
            double totalRating = allFeedbacks.stream().mapToInt(Feedback::getRating).sum();
            stats.setOverallAverageRating(totalRating / allFeedbacks.size());
        } else {
            stats.setOverallAverageRating(0.0);
        }

        // Đếm theo từng rating
        for (int i = 1; i <= 5; i++) {
            long count = countFeedbacksByRating(i);
            stats.setRatingCount(i, count);
        }

        return stats;
    }

    // Xóa feedback
    public void deleteFeedback(Integer feedbackId) {
        feedbackRepository.deleteById(feedbackId);
    }

    // Cập nhật feedback
    public Feedback updateFeedback(Feedback feedback) {
        return feedbackRepository.save(feedback);
    }

    // Inner class cho thống kê theo phường
    public static class FeedbackStats {
        private Integer wardId;
        private Double averageRating;
        private long totalFeedbacks;
        private long[] ratingCounts = new long[6]; // index 0 không dùng, 1-5 cho rating

        // Getters and setters
        public Integer getWardId() { return wardId; }
        public void setWardId(Integer wardId) { this.wardId = wardId; }

        public Double getAverageRating() { return averageRating; }
        public void setAverageRating(Double averageRating) { this.averageRating = averageRating; }

        public long getTotalFeedbacks() { return totalFeedbacks; }
        public void setTotalFeedbacks(long totalFeedbacks) { this.totalFeedbacks = totalFeedbacks; }

        public long getRatingCount(int rating) { return ratingCounts[rating]; }
        public void setRatingCount(int rating, long count) { this.ratingCounts[rating] = count; }

        public long[] getRatingCounts() { return ratingCounts; }
        public void setRatingCounts(long[] ratingCounts) { this.ratingCounts = ratingCounts; }
    }

    // Inner class cho thống kê tổng quan
    public static class OverallFeedbackStats {
        private long totalFeedbacks;
        private Double overallAverageRating;
        private long[] ratingCounts = new long[6]; // index 0 không dùng, 1-5 cho rating

        // Getters and setters
        public long getTotalFeedbacks() { return totalFeedbacks; }
        public void setTotalFeedbacks(long totalFeedbacks) { this.totalFeedbacks = totalFeedbacks; }

        public Double getOverallAverageRating() { return overallAverageRating; }
        public void setOverallAverageRating(Double overallAverageRating) { this.overallAverageRating = overallAverageRating; }

        public long getRatingCount(int rating) { return ratingCounts[rating]; }
        public void setRatingCount(int rating, long count) { this.ratingCounts[rating] = count; }

        public long[] getRatingCounts() { return ratingCounts; }
        public void setRatingCounts(long[] ratingCounts) { this.ratingCounts = ratingCounts; }
    }

    // Xóa tất cả feedbacks
    public void deleteAllFeedbacks() {
        feedbackRepository.deleteAll();
    }
}
