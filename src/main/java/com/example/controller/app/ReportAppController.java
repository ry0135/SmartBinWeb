package com.example.controller.app;

import com.example.dto.ReportResponseDTO;
import com.example.model.Report;
import com.example.model.ReportImage;
import com.example.model.ReportStatusHistory;
import com.example.model.ApiResponse;
import com.example.service.ReportService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@RestController
@RequestMapping("/api/app/reports")
@CrossOrigin(origins = "*")
public class ReportAppController {
    
    @Autowired
    private ReportService reportService;
    
    // Tạo báo cáo mới từ app
    @PostMapping
    public ResponseEntity<ApiResponse<Report>> createReport(@RequestBody ReportRequest request) {
        try {
            Report report = new Report();
            report.setBinId(request.getBinId());
            report.setAccountId(request.getAccountId());
            report.setReportType(request.getReportType());
            report.setDescription(request.getDescription());
            report.setStatus("RECEIVED");
            
            Report createdReport = reportService.createReport(report);
            
            return ResponseEntity.ok(ApiResponse.success("Báo cáo đã được tạo thành công", createdReport));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                .body(ApiResponse.error("Có lỗi xảy ra: " + e.getMessage()));
        }
    }
    
    // Lấy báo cáo theo người dùng - trả JSON thủ công để tránh lỗi serialize lazy
    @GetMapping("/user/{accountId}")
    public ResponseEntity<String> getReportsByUser(@PathVariable Integer accountId) {
        try {
            List<Report> reports = reportService.getReportsByAccountId(accountId);

            java.time.format.DateTimeFormatter iso = java.time.format.DateTimeFormatter.ISO_LOCAL_DATE_TIME;

            StringBuilder json = new StringBuilder();
            json.append("{\"status\":\"success\",\"message\":\"Lấy danh sách báo cáo thành công\",\"data\":[");

            for (int i = 0; i < reports.size(); i++) {
                Report r = reports.get(i);
                if (i > 0) json.append(",");
                json.append("{");
                json.append("\"reportId\":").append(r.getReportId()).append(",");
                json.append("\"binId\":").append(r.getBinId()).append(",");
                json.append("\"binCode\":").append(r.getBin().getBinCode()).append(",");
                json.append("\"accountId\":").append(r.getAccountId()).append(",");
                json.append("\"reportType\":\"").append(r.getReportType() != null ? r.getReportType().replace("\"", "\\\"") : "").append("\",");
                json.append("\"description\":\"").append(r.getDescription() != null ? r.getDescription().replace("\"", "\\\"") : "").append("\",");
                json.append("\"status\":\"").append(r.getStatus() != null ? r.getStatus().replace("\"", "\\\"") : "").append("\",");
                json.append("\"createdAt\":\"").append(r.getCreatedAt() != null ? iso.format(r.getCreatedAt()) : "").append("\",");
                json.append("\"updatedAt\":\"").append(r.getUpdatedAt() != null ? iso.format(r.getUpdatedAt()) : "").append("\",");
                json.append("\"resolvedAt\":\"").append(r.getResolvedAt() != null ? iso.format(r.getResolvedAt()) : "").append("\"");
                json.append("}");
            }

            json.append("]}");

            return ResponseEntity.ok()
                .header("Content-Type", "application/json; charset=UTF-8")
                .body(json.toString());
        } catch (Exception e) {
            String err = "{\"status\":\"ERROR\",\"message\":\"Có lỗi xảy ra: " + (e.getMessage() != null ? e.getMessage().replace("\"", "\\\"") : "") + "\"}";
            return ResponseEntity.ok()
                .header("Content-Type", "application/json; charset=UTF-8")
                .body(err);
        }
    }
    
    // Lấy chi tiết báo cáo
//    @GetMapping("/{reportId}")
//    public ResponseEntity<ApiResponse<Report>> getReportDetail(@PathVariable Integer reportId) {
//        try {
//            Optional<Report> report = reportService.getReportById(reportId);
//            if (report.isPresent()) {
//                return ResponseEntity.ok(ApiResponse.success("Lấy chi tiết báo cáo thành công", report.get()));
//            } else {
//                return ResponseEntity.notFound().build();
//            }
//        } catch (Exception e) {
//            return ResponseEntity.badRequest()
//                .body(ApiResponse.error("Có lỗi xảy ra: " + e.getMessage()));
//        }
//    }
    @GetMapping("/{reportId}")
    public ResponseEntity<ApiResponse<ReportResponseDTO>> getReportDetail(@PathVariable Integer reportId) {
        try {
            Optional<Report> report = reportService.getReportById(reportId);

            if (report.isPresent()) {
                ReportResponseDTO dto = reportService.convertToDTO(report.get());
                return ResponseEntity.ok(ApiResponse.success("Lấy chi tiết báo cáo thành công", dto));
            }

            return ResponseEntity.notFound().build();

        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error("Có lỗi xảy ra: " + e.getMessage()));
        }
    }

    // Lấy lịch sử trạng thái báo cáo
    @GetMapping("/{reportId}/status")
    public ResponseEntity<ApiResponse<List<ReportStatusHistory>>> getReportStatusHistory(@PathVariable Integer reportId) {
        try {
            List<ReportStatusHistory> history = reportService.getReportStatusHistory(reportId);
            return ResponseEntity.ok(ApiResponse.success("Lấy lịch sử trạng thái thành công", history));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                .body(ApiResponse.error("Có lỗi xảy ra: " + e.getMessage()));
        }
    }
    
    // Upload hình ảnh báo cáo
    @PostMapping("/{reportId}/images")
    public ResponseEntity<ApiResponse<ReportImage>> uploadReportImage(
            @PathVariable Integer reportId,
            @RequestParam("image") MultipartFile image) {
        try {
            if (image.isEmpty()) {
                return ResponseEntity.badRequest()
                    .body(ApiResponse.error("Không có hình ảnh được tải lên"));
            }
            
            // Tạo tên file unique
            String fileName = UUID.randomUUID().toString() + "_" + image.getOriginalFilename();
            
            // Lưu file vào thư mục uploads
            Path uploadPath = Paths.get("uploads/reports");
            if (!Files.exists(uploadPath)) {
                Files.createDirectories(uploadPath);
            }
            
            Path filePath = uploadPath.resolve(fileName);
            Files.copy(image.getInputStream(), filePath);
            
            // Lưu URL vào database
            String imageUrl = "/uploads/reports/" + fileName;
            ReportImage reportImage = reportService.addImageToReport(reportId, imageUrl);
            
            return ResponseEntity.ok(ApiResponse.success("Upload hình ảnh thành công", reportImage));
        } catch (IOException e) {
            return ResponseEntity.badRequest()
                .body(ApiResponse.error("Lỗi khi lưu hình ảnh: " + e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                .body(ApiResponse.error("Có lỗi xảy ra: " + e.getMessage()));
        }
    }
    
    // Lấy hình ảnh của báo cáo
    @GetMapping("/{reportId}/images")
    public ResponseEntity<ApiResponse<List<ReportImage>>> getReportImages(@PathVariable Integer reportId) {
        try {
            List<ReportImage> images = reportService.getReportImages(reportId);
            return ResponseEntity.ok(ApiResponse.success("Lấy danh sách hình ảnh thành công", images));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                .body(ApiResponse.error("Có lỗi xảy ra: " + e.getMessage()));
        }
    }
    
    // Lấy báo cáo theo trạng thái
    @GetMapping("/status/{status}")
    public ResponseEntity<ApiResponse<List<Report>>> getReportsByStatus(@PathVariable String status) {
        try {
            List<Report> reports = reportService.getReportsByStatus(status);
            return ResponseEntity.ok(ApiResponse.success("Lấy danh sách báo cáo theo trạng thái thành công", reports));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                .body(ApiResponse.error("Có lỗi xảy ra: " + e.getMessage()));
        }
    }
    
    // Lấy báo cáo theo BinID
    @GetMapping("/bin/{binId}")
    public ResponseEntity<ApiResponse<List<Report>>> getReportsByBin(@PathVariable Integer binId) {
        try {
            List<Report> reports = reportService.getReportsByBinId(binId);
            return ResponseEntity.ok(ApiResponse.success("Lấy danh sách báo cáo theo thùng rác thành công", reports));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                .body(ApiResponse.error("Có lỗi xảy ra: " + e.getMessage()));
        }
    }
    
    // Inner class cho request
    public static class ReportRequest {
        private Integer binId;
        private Integer accountId;
        private String reportType;
        private String description;
        private Double latitude;
        private Double longitude;
        
        // Getters and setters
        public Integer getBinId() { return binId; }
        public void setBinId(Integer binId) { this.binId = binId; }
        
        public Integer getAccountId() { return accountId; }
        public void setAccountId(Integer accountId) { this.accountId = accountId; }
        
        public String getReportType() { return reportType; }
        public void setReportType(String reportType) { this.reportType = reportType; }
        
        public String getDescription() { return description; }
        public void setDescription(String description) { this.description = description; }
        
        public Double getLatitude() { return latitude; }
        public void setLatitude(Double latitude) { this.latitude = latitude; }
        
        public Double getLongitude() { return longitude; }
        public void setLongitude(Double longitude) { this.longitude = longitude; }
    }
}
