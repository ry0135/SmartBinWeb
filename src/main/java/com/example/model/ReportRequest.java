package com.example.model;

import java.util.List;

public class ReportRequest {

    private Integer binId;
    private Integer accountId;
    private String reportType;
    private String description;
    private List<String> images;

    // Constructors
    public ReportRequest() {}

    public ReportRequest(Integer binId, Integer accountId, String reportType,
                         String description, List<String> images) {
        this.binId = binId;
        this.accountId = accountId;
        this.reportType = reportType;
        this.description = description;
        this.images = images;
    }
    
    // Getters and Setters


    public List<String> getImages() {
        return images;
    }

    public void setImages(List<String> images) {
        this.images = images;
    }

    public Integer getBinId() {
        return binId;
    }
    
    public void setBinId(Integer binId) {
        this.binId = binId;
    }
    
    public Integer getAccountId() {
        return accountId;
    }
    
    public void setAccountId(Integer accountId) {
        this.accountId = accountId;
    }
    
    public String getReportType() {
        return reportType;
    }
    
    public void setReportType(String reportType) {
        this.reportType = reportType;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public String toString() {
        return "ReportRequest{" +

                ", binId=" + binId +
                ", accountId=" + accountId +
                ", reportType='" + reportType + '\'' +
                ", description='" + description + '\'' +
                '}';
    }
}















