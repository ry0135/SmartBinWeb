package com.example.model;

public class ReportRequest {
    private Integer userId;
    private Integer binId;
    private Integer accountId;
    private String reportType;
    private String description;
    private String location;
    private Double latitude;
    private Double longitude;
    private String status;
    
    // Constructors
    public ReportRequest() {}
    
    public ReportRequest(Integer userId, Integer binId, Integer accountId, String reportType, 
                        String description, String location, Double latitude, Double longitude, String status) {
        this.userId = userId;
        this.binId = binId;
        this.accountId = accountId;
        this.reportType = reportType;
        this.description = description;
        this.location = location;
        this.latitude = latitude;
        this.longitude = longitude;
        this.status = status;
    }
    
    // Getters and Setters
    public Integer getUserId() {
        return userId;
    }
    
    public void setUserId(Integer userId) {
        this.userId = userId;
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
    
    public String getLocation() {
        return location;
    }
    
    public void setLocation(String location) {
        this.location = location;
    }
    
    public Double getLatitude() {
        return latitude;
    }
    
    public void setLatitude(Double latitude) {
        this.latitude = latitude;
    }
    
    public Double getLongitude() {
        return longitude;
    }
    
    public void setLongitude(Double longitude) {
        this.longitude = longitude;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    @Override
    public String toString() {
        return "ReportRequest{" +
                "userId=" + userId +
                ", binId=" + binId +
                ", accountId=" + accountId +
                ", reportType='" + reportType + '\'' +
                ", description='" + description + '\'' +
                ", location='" + location + '\'' +
                ", latitude=" + latitude +
                ", longitude=" + longitude +
                ", status='" + status + '\'' +
                '}';
    }
}











