package com.example.dto;

import javax.persistence.Column;
import java.util.Date;

public class TaskDTO {
    private int taskID;
    private String taskType;
    private int priority;
    private String status;
    private String notes;
    private String batchId;
    private BinDTO bin;
    private Date createdAt;
    private Date completedAt;

    private Double completedLat;
    private Double completedLng;
    private String afterImage;
    private Double collectedVolume;
    private String issueReason;
    private int assignedToId;
    private String assignedToName;

    public int getAssignedToId() {
        return assignedToId;
    }

    public void setAssignedToId(int assignedToId) {
        this.assignedToId = assignedToId;
    }

    public String getAssignedToName() {
        return assignedToName;
    }

    public void setAssignedToName(String assignedToName) {
        this.assignedToName = assignedToName;
    }

    public String getIssueReason() {
        return issueReason;
    }

    public void setIssueReason(String issueReason) {
        this.issueReason = issueReason;
    }

    public int getTaskID() {
        return taskID;
    }

    public void setTaskID(int taskID) {
        this.taskID = taskID;
    }

    public String getTaskType() {
        return taskType;
    }

    public void setTaskType(String taskType) {
        this.taskType = taskType;
    }

    public int getPriority() {
        return priority;
    }

    public void setPriority(int priority) {
        this.priority = priority;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public String getBatchId() {
        return batchId;
    }

    public void setBatchId(String batchId) {
        this.batchId = batchId;
    }

    public BinDTO getBin() {
        return bin;
    }

    public void setBin(BinDTO bin) {
        this.bin = bin;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getCompletedAt() {
        return completedAt;
    }

    public void setCompletedAt(Date completedAt) {
        this.completedAt = completedAt;
    }

    public Double getCompletedLat() {
        return completedLat;
    }

    public void setCompletedLat(Double completedLat) {
        this.completedLat = completedLat;
    }

    public Double getCompletedLng() {
        return completedLng;
    }

    public void setCompletedLng(Double completedLng) {
        this.completedLng = completedLng;
    }

    public String getAfterImage() {
        return afterImage;
    }

    public void setAfterImage(String afterImage) {
        this.afterImage = afterImage;
    }

    public Double getCollectedVolume() {
        return collectedVolume;
    }

    public void setCollectedVolume(Double collectedVolume) {
        this.collectedVolume = collectedVolume;
    }
}
