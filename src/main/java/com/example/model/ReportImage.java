package com.example.model;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "ReportImages")
public class ReportImage {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ImageID")
    private Integer imageId;
    
    @Column(name = "ReportID", nullable = false)
    private Integer reportId;
    
    @Column(name = "ImageURL", nullable = false, length = 255)
    private String imageUrl;
    
    @Column(name = "CreatedAt")
    private LocalDateTime createdAt;
    
    // Relationship
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ReportID", insertable = false, updatable = false)
    private Report report;
    
    // Constructors
    public ReportImage() {}
    
    public ReportImage(Integer reportId, String imageUrl) {
        this.reportId = reportId;
        this.imageUrl = imageUrl;
        this.createdAt = LocalDateTime.now();
    }
    
    // Getters and Setters
    public Integer getImageId() { return imageId; }
    public void setImageId(Integer imageId) { this.imageId = imageId; }
    
    public Integer getReportId() { return reportId; }
    public void setReportId(Integer reportId) { this.reportId = reportId; }
    
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    
    public Report getReport() { return report; }
    public void setReport(Report report) { this.report = report; }
}


