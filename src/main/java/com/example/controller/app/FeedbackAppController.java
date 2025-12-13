package com.example.controller.app;

import com.example.model.Feedback;
import com.example.model.ApiResponse;
import com.example.model.Report;
import com.example.repository.ReportRepository;
import com.example.service.FeedbackService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.persistence.EntityNotFoundException;
import java.time.LocalDateTime;
import java.util.List;
@RestController
@RequestMapping("api/feedbacks")
@CrossOrigin(origins = "*")
public class FeedbackAppController {

    @Autowired
    private FeedbackService feedbackService;
    
    @Autowired
    private ReportRepository reportRepository;
    // Tạo đánh giá mới từ app
    @PostMapping("/create")
    public ResponseEntity<ApiResponse<Feedback>> createFeedback(
            @RequestBody FeedbackRequest request) {
        try {
            // Gọi Service để xử lý cả 2 thao tác trong 1 Transaction
            Feedback createdFeedback = feedbackService.createFeedbackAndUpdateReport(request);

            return ResponseEntity.ok(
                    ApiResponse.success("Đánh giá đã được tạo thành công", createdFeedback)
            );

        } catch (EntityNotFoundException e) { // Bắt lỗi Report không tồn tại
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error(e.getMessage()));
        } catch (Exception e) {
            // Đây là nơi bắt các lỗi giao dịch/Rollback
            // Log e.printStackTrace() để xem lỗi gốc là gì
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR) // Dùng 500 cho lỗi server/rollback
                    .body(ApiResponse.error("Lỗi server khi tạo đánh giá: " + e.getMessage()));
        }
    }

    // Lấy đánh giá theo người dùng
    @GetMapping("/user/{accountId}")
    public ResponseEntity<ApiResponse<List<Feedback>>> getFeedbacksByUser(@PathVariable Integer accountId) {
        try {
            List<Feedback> feedbacks = feedbackService.getFeedbacksByAccountId(accountId);
            return ResponseEntity.ok(ApiResponse.success("Lấy danh sách đánh giá thành công", feedbacks));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                .body(ApiResponse.error("Có lỗi xảy ra: " + e.getMessage()));
        }
    }

    // Lấy thống kê đánh giá theo phường
//    @GetMapping("/ward/{wardId}/stats")
//    public ResponseEntity<ApiResponse<FeedbackService.FeedbackStats>> getFeedbackStatsByWard(@PathVariable Integer wardId) {
//        try {
//            FeedbackService.FeedbackStats stats = feedbackService.getFeedbackStatsByWardId(wardId);
//            return ResponseEntity.ok(ApiResponse.success("Lấy thống kê đánh giá thành công", stats));
//        } catch (Exception e) {
//            return ResponseEntity.badRequest()
//                .body(ApiResponse.error("Có lỗi xảy ra: " + e.getMessage()));
//        }
//    }

    // Lấy đánh giá theo phường
//    @GetMapping("/ward/{wardId}")
//    public ResponseEntity<ApiResponse<List<Feedback>>> getFeedbacksByWard(@PathVariable Integer wardId) {
//        try {
//            List<Feedback> feedbacks = feedbackService.getFeedbacksByWardId(wardId);
//            return ResponseEntity.ok(ApiResponse.success("Lấy danh sách đánh giá theo phường thành công", feedbacks));
//        } catch (Exception e) {
//            return ResponseEntity.badRequest()
//                .body(ApiResponse.error("Có lỗi xảy ra: " + e.getMessage()));
//        }
//    }

    // Lấy đánh giá theo báo cáo
    @GetMapping("/report/{reportId}")
    public ResponseEntity<ApiResponse<List<Feedback>>> getFeedbacksByReport(@PathVariable Integer reportId) {
        try {
            List<Feedback> feedbacks = feedbackService.getFeedbacksByReportId(reportId);
            return ResponseEntity.ok(ApiResponse.success("Lấy danh sách đánh giá theo báo cáo thành công", feedbacks));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                .body(ApiResponse.error("Có lỗi xảy ra: " + e.getMessage()));
        }
    }

    // Lấy tất cả đánh giá
    @GetMapping
    public ResponseEntity<ApiResponse<List<Feedback>>> getAllFeedbacks() {
        try {
            List<Feedback> feedbacks = feedbackService.getAllFeedbacks();
            return ResponseEntity.ok(ApiResponse.success("Lấy danh sách đánh giá thành công", feedbacks));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                .body(ApiResponse.error("Có lỗi xảy ra: " + e.getMessage()));
        }
    }

    // Lấy thống kê tổng quan
    @GetMapping("/stats/overall")
    public ResponseEntity<ApiResponse<FeedbackService.OverallFeedbackStats>> getOverallFeedbackStats() {
        try {
            FeedbackService.OverallFeedbackStats stats = feedbackService.getOverallFeedbackStats();
            return ResponseEntity.ok(ApiResponse.success("Lấy thống kê tổng quan thành công", stats));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                .body(ApiResponse.error("Có lỗi xảy ra: " + e.getMessage()));
        }
    }

    // Lấy đánh giá theo rating
    @GetMapping("/rating/{rating}")
    public ResponseEntity<ApiResponse<List<Feedback>>> getFeedbacksByRating(@PathVariable Integer rating) {
        try {
            List<Feedback> feedbacks = feedbackService.getFeedbacksByRatingRange(rating, rating);
            return ResponseEntity.ok(ApiResponse.success("Lấy danh sách đánh giá theo điểm thành công", feedbacks));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                .body(ApiResponse.error("Có lỗi xảy ra: " + e.getMessage()));
        }
    }

    // Lấy đánh giá theo khoảng rating
    @GetMapping("/rating/{minRating}/{maxRating}")
    public ResponseEntity<ApiResponse<List<Feedback>>> getFeedbacksByRatingRange(@PathVariable Integer minRating,
                                                                                @PathVariable Integer maxRating) {
        try {
            List<Feedback> feedbacks = feedbackService.getFeedbacksByRatingRange(minRating, maxRating);
            return ResponseEntity.ok(ApiResponse.success("Lấy danh sách đánh giá theo khoảng điểm thành công", feedbacks));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                .body(ApiResponse.error("Có lỗi xảy ra: " + e.getMessage()));
        }
    }

    // Inner class cho request
    public static class FeedbackRequest {
        private Integer accountId;
        private Integer rating;
        private String comment;
        private Integer reportId;

        // Getters and setters
        public Integer getAccountId() { return accountId; }
        public void setAccountId(Integer accountId) { this.accountId = accountId; }


        public Integer getRating() { return rating; }
        public void setRating(Integer rating) { this.rating = rating; }

        public String getComment() { return comment; }
        public void setComment(String comment) { this.comment = comment; }

        public Integer getReportId() { return reportId; }
        public void setReportId(Integer reportId) { this.reportId = reportId; }
    }
}
