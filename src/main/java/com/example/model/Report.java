package com.example.model;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "Reports")
public class Report {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ReportID")
    private Integer reportId;
    
    @Column(name = "BinID", nullable = false)
    private Integer binId;
    
    @Column(name = "AccountID", nullable = false)
    private Integer accountId;
    
    @Column(name = "ReportType", nullable = false, length = 50)
    private String reportType;
    
    @Column(name = "Description", length = 1000)
    private String description;
    
    @Column(name = "Status", nullable = false, length = 20)
    private String status = "RECEIVED";
    
    @Column(name = "AssignedTo")
    private Integer assignedTo;
    
    @Column(name = "TaskID")
    private Integer taskId;
    
    @Column(name = "CreatedAt")
    private LocalDateTime createdAt;
    
    @Column(name = "UpdatedAt")
    private LocalDateTime updatedAt;
    
    @Column(name = "ResolvedAt")
    private LocalDateTime resolvedAt;
    
    // Relationships
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "BinID", insertable = false, updatable = false)
    private Bin bin;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "AccountID", insertable = false, updatable = false)
    private Account account;
    
    @OneToMany(mappedBy = "report", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<ReportImage> reportImages;
    
    @OneToMany(mappedBy = "report", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<ReportStatusHistory> statusHistory;
    
    // Constructors
    public Report() {}
    
    public Report(Integer binId, Integer accountId, String reportType, String description) {
        this.binId = binId;
        this.accountId = accountId;
        this.reportType = reportType;
        this.description = description;
        this.status = "RECEIVED";
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }
    
    // Getters and Setters
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
    
    public Integer getAssignedTo() { return assignedTo; }
    public void setAssignedTo(Integer assignedTo) { this.assignedTo = assignedTo; }
    
    public Integer getTaskId() { return taskId; }
    public void setTaskId(Integer taskId) { this.taskId = taskId; }
    
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
    
    public LocalDateTime getResolvedAt() { return resolvedAt; }
    public void setResolvedAt(LocalDateTime resolvedAt) { this.resolvedAt = resolvedAt; }
    
    public Bin getBin() { return bin; }
    public void setBin(Bin bin) { this.bin = bin; }
    
    public Account getAccount() { return account; }
    public void setAccount(Account account) { this.account = account; }
    
    public List<ReportImage> getReportImages() { return reportImages; }
    public void setReportImages(List<ReportImage> reportImages) { this.reportImages = reportImages; }
    
    public List<ReportStatusHistory> getStatusHistory() { return statusHistory; }
    public void setStatusHistory(List<ReportStatusHistory> statusHistory) { this.statusHistory = statusHistory; }
}


