package com.example.model;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "ReportStatusHistory")
public class ReportStatusHistory {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "HistoryID")
    private Integer historyId;
    
    @Column(name = "ReportID", nullable = false)
    private Integer reportId;
    
    @Column(name = "Status", nullable = false, length = 20)
    private String status;
    
    @Column(name = "Notes", length = 255)
    private String notes;
    
    @Column(name = "UpdatedBy", nullable = false)
    private Integer updatedBy;
    
    @Column(name = "CreatedAt")
    private LocalDateTime createdAt;
    
    // Relationships
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ReportID", insertable = false, updatable = false)
    private Report report;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "UpdatedBy", insertable = false, updatable = false)
    private Account updatedByAccount;
    
    // Constructors
    public ReportStatusHistory() {}
    
    public ReportStatusHistory(Integer reportId, String status, String notes, Integer updatedBy) {
        this.reportId = reportId;
        this.status = status;
        this.notes = notes;
        this.updatedBy = updatedBy;
        this.createdAt = LocalDateTime.now();
    }
    
    // Getters and Setters
    public Integer getHistoryId() { return historyId; }
    public void setHistoryId(Integer historyId) { this.historyId = historyId; }
    
    public Integer getReportId() { return reportId; }
    public void setReportId(Integer reportId) { this.reportId = reportId; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
    
    public Integer getUpdatedBy() { return updatedBy; }
    public void setUpdatedBy(Integer updatedBy) { this.updatedBy = updatedBy; }
    
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    
    public Report getReport() { return report; }
    public void setReport(Report report) { this.report = report; }
    
    public Account getUpdatedByAccount() { return updatedByAccount; }
    public void setUpdatedByAccount(Account updatedByAccount) { this.updatedByAccount = updatedByAccount; }
}


