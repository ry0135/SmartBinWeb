package com.example.dto;

import java.time.LocalDateTime;

public class ReportResponseDTO {
    private Integer reportId;
    private Integer binId;
    private Integer accountId;
    private String reportType;
    private String description;
    private String status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
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
}
