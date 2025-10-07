package com.example.model;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "Feedbacks")
public class Feedback {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "FeedbackID")
    private Integer feedbackId;
    
    @Column(name = "AccountID", nullable = false)
    private Integer accountId;
    
    @Column(name = "WardID", nullable = false)
    private Integer wardId;
    
    @Column(name = "Rating", nullable = false)
    private Integer rating;
    
    @Column(name = "Comment", length = 500)
    private String comment;
    
    @Column(name = "ReportID")
    private Integer reportId;
    
    @Column(name = "CreatedAt")
    private LocalDateTime createdAt;
    
    // Relationships
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "AccountID", insertable = false, updatable = false)
    private Account account;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "WardID", insertable = false, updatable = false)
    private Ward ward;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ReportID", insertable = false, updatable = false)
    private Report report;
    
    // Constructors
    public Feedback() {}
    
    public Feedback(Integer accountId, Integer wardId, Integer rating, String comment, Integer reportId) {
        this.accountId = accountId;
        this.wardId = wardId;
        this.rating = rating;
        this.comment = comment;
        this.reportId = reportId;
        this.createdAt = LocalDateTime.now();
    }
    
    // Getters and Setters
    public Integer getFeedbackId() { return feedbackId; }
    public void setFeedbackId(Integer feedbackId) { this.feedbackId = feedbackId; }
    
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
    
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    
    public Account getAccount() { return account; }
    public void setAccount(Account account) { this.account = account; }
    
    public Ward getWard() { return ward; }
    public void setWard(Ward ward) { this.ward = ward; }
    
    public Report getReport() { return report; }
    public void setReport(Report report) { this.report = report; }
}


