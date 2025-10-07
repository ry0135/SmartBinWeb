package com.example.controller;

import com.example.model.Feedback;
import com.example.model.ApiResponse;
import com.example.service.FeedbackService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/feedbacks")
@CrossOrigin(origins = "*")
public class FeedbackController {
    
    @Autowired
    private FeedbackService feedbackService;
    
    // Lấy tất cả feedbacks - Simple JSON version
    @GetMapping
    public ResponseEntity<String> getAllFeedbacks() {
        try {
            System.out.println("=== DEBUG: getAllFeedbacks called ===");
            List<Feedback> feedbacks = feedbackService.getAllFeedbacks();
            System.out.println("=== DEBUG: Found " + feedbacks.size() + " feedbacks ===");
            
            // Build JSON manually to avoid Spring serialization issues
            StringBuilder json = new StringBuilder();
            json.append("{\"status\":\"SUCCESS\",\"message\":\"Lấy danh sách đánh giá thành công\",\"data\":[");
            
            for (int i = 0; i < feedbacks.size(); i++) {
                Feedback feedback = feedbacks.get(i);
                if (i > 0) json.append(",");
                json.append("{");
                json.append("\"feedbackId\":").append(feedback.getFeedbackId()).append(",");
                json.append("\"accountId\":").append(feedback.getAccountId()).append(",");
                json.append("\"rating\":").append(feedback.getRating()).append(",");
                json.append("\"comment\":\"").append(feedback.getComment() != null ? feedback.getComment().replace("\"", "\\\"") : "").append("\",");
                json.append("\"createdAt\":\"").append(feedback.getCreatedAt() != null ? feedback.getCreatedAt().toString() : "").append("\"");
                json.append("}");
            }
            
            json.append("]}");
            
            return ResponseEntity.ok()
                .header("Content-Type", "application/json; charset=UTF-8")
                .body(json.toString());
                
        } catch (Exception e) {
            System.out.println("=== DEBUG: Error in getAllFeedbacks: " + e.getMessage() + " ===");
            e.printStackTrace();
            return ResponseEntity.ok()
                .header("Content-Type", "application/json; charset=UTF-8")
                .body("{\"status\":\"ERROR\",\"message\":\"Có lỗi xảy ra: " + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }
    
    // Lấy feedback theo ID
    @GetMapping("/{feedbackId}")
    public ResponseEntity<ApiResponse<Feedback>> getFeedbackById(@PathVariable Integer feedbackId) {
        try {
            Optional<Feedback> feedback = feedbackService.getFeedbackById(feedbackId);
            if (feedback.isPresent()) {
                return ResponseEntity.ok(ApiResponse.success("Lấy chi tiết đánh giá thành công", feedback.get()));
            } else {
                return ResponseEntity.notFound().build();
            }
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                .body(ApiResponse.error("Có lỗi xảy ra: " + e.getMessage()));
        }
    }
    
    // Lấy feedback theo người dùng
    @GetMapping("/user/{accountId}")
    public ResponseEntity<ApiResponse<List<Feedback>>> getFeedbacksByUser(@PathVariable Integer accountId) {
        try {
            List<Feedback> feedbacks = feedbackService.getFeedbacksByAccountId(accountId);
            return ResponseEntity.ok(ApiResponse.success("Lấy danh sách đánh giá của người dùng thành công", feedbacks));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                .body(ApiResponse.error("Có lỗi xảy ra: " + e.getMessage()));
        }
    }
    
    // Lấy feedback theo phường
    @GetMapping("/ward/{wardId}")
    public ResponseEntity<ApiResponse<List<Feedback>>> getFeedbacksByWard(@PathVariable Integer wardId) {
        try {
            List<Feedback> feedbacks = feedbackService.getFeedbacksByWardId(wardId);
            return ResponseEntity.ok(ApiResponse.success("Lấy danh sách đánh giá theo phường thành công", feedbacks));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                .body(ApiResponse.error("Có lỗi xảy ra: " + e.getMessage()));
        }
    }
    
    // Lấy thống kê feedback
    @GetMapping("/stats")
    public ResponseEntity<ApiResponse<Object>> getFeedbackStats() {
        try {
            // Tạm thời trả về null vì method chưa được implement
            return ResponseEntity.ok(ApiResponse.success("Lấy thống kê đánh giá thành công", null));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                .body(ApiResponse.error("Có lỗi xảy ra: " + e.getMessage()));
        }
    }
    
    // Tạo feedback mới (cho Android app)
    @PostMapping("/create")
    public ResponseEntity<ApiResponse<Feedback>> createFeedback(@RequestBody FeedbackRequest request) {
        try {
            Feedback feedback = new Feedback();
            feedback.setAccountId(request.getAccountId());
            feedback.setWardId(request.getWardId());
            feedback.setRating(request.getRating());
            feedback.setComment(request.getComment());
            feedback.setReportId(request.getReportId());
            
            Feedback createdFeedback = feedbackService.createFeedback(feedback);
            
            return ResponseEntity.ok(ApiResponse.success("Tạo đánh giá thành công", createdFeedback));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                .body(ApiResponse.error("Có lỗi xảy ra: " + e.getMessage()));
        }
    }
    
    // Inner class cho request
    public static class FeedbackRequest {
        private Integer accountId;
        private Integer wardId;
        private Integer rating;
        private String comment;
        private Integer reportId;
        
        // Getters and Setters
        public Integer getAccountId() { return accountId; }
        public void setAccountId(Integer accountId) { this.accountId = accountId; }
        
        public Integer getWardId() { return wardId; }
        public void setWardId(Integer wardId) { this.wardId = wardId; }
        
        public Integer getRating() { return rating; }
        public void setRating(Integer rating) { this.rating = rating; }
        
        public String getComment() { return comment; }
        public void setComment(String comment) { this.comment = comment; }
        
        public Integer getReportId() { return reportId; }
        public void setReportId(Integer reportId) { this.reportId = reportId; }
    }
}