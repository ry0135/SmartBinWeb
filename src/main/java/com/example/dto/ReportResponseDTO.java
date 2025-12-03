package com.example.dto;

import com.fasterxml.jackson.annotation.JsonFormat;

import javax.persistence.EntityListeners;
import java.time.LocalDateTime;
import java.util.List;
public class ReportResponseDTO {
    private Integer reportId;
    private Integer binId;

    private String binCode;

    private String binAddress;
    private Integer accountId;
    private String reportType;
    private String description;
    private String status;

    private boolean isReviewed;

    private List<String> images;

    // Getter và Setter
    public boolean isReviewed() {
        return isReviewed;
    }

    public void setReviewed(boolean reviewed) {
        isReviewed = reviewed;
    }
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createdAt;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime updatedAt;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime resolvedAt;


    public ReportResponseDTO(Integer reportId, Integer binId, Integer accountId,
                             String reportType, String description, String status,
                             LocalDateTime createdAt, LocalDateTime updatedAt,
                             LocalDateTime resolvedAt) {
        this.reportId = reportId;
        this.binId = binId;
        this.accountId = accountId;
        this.reportType = reportType;
        this.description = description;
        this.status = status;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.resolvedAt = resolvedAt;
    }
    public List<String> getImages() {
        return images;
    }

    public void setImages(List<String> images) {
        this.images = images;
    }
    public ReportResponseDTO(Integer reportId, Integer binId, Integer accountId,
                             String reportType, String description, String status,
                             LocalDateTime createdAt) {
        this(reportId, binId, accountId, reportType, description, status, createdAt, null, null);
    }

    public ReportResponseDTO() {}

    // 🧩 Getters & Setters
    public Integer getReportId() { return reportId; }
    public void setReportId(Integer reportId) { this.reportId = reportId; }

    public Integer getBinId() { return binId; }
    public void setBinId(Integer binId) { this.binId = binId; }

    public Integer getAccountId() { return accountId; }
    public void setAccountId(Integer accountId) { this.accountId = accountId; }

    public String getReportType() { return reportType; }
    public void setReportType(String reportType) { this.reportType = reportType; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    public LocalDateTime getResolvedAt() { return resolvedAt; }
    public void setResolvedAt(LocalDateTime resolvedAt) { this.resolvedAt = resolvedAt; }

    public String getBinCode() {
        return binCode;
    }

    public void setBinCode(String binCode) {
        this.binCode = binCode;
    }

    public String getBinAddress() {
        return binAddress;
    }

    public void setBinAddress(String binAddress) {
        this.binAddress = binAddress;
    }
}
