package com.example.model;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Tasks")
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
public class Task {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "TaskID")
    private int taskID;

    @ManyToOne
    @JoinColumn(name = "BinID")
    private Bin bin;

    @ManyToOne
    @JoinColumn(name = "AssignedTo")
    private Account assignedTo;

    @Column(name = "TaskType")
    private String taskType; // COLLECT, CLEAN, REPAIR

    @Column(name = "Priority")
    private int priority; // 1: High, 2: Medium, 3: Low

    @Column(name = "Status")
    private String status; // OPEN, DOING, COMPLETED, CANCELLED

    @Column(name = "Notes", length = 500)
    private String notes;

    @Temporal(TemporalType.TIMESTAMP)
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "Asia/Ho_Chi_Minh")
    @Column(name = "CreatedAt")
    private Date createdAt;

    @Temporal(TemporalType.TIMESTAMP)
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "Asia/Ho_Chi_Minh")
    @Column(name = "UpdatedAt")
    private Date updatedAt;
    @Temporal(TemporalType.TIMESTAMP)
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "Asia/Ho_Chi_Minh")
    @Column(name = "CompletedAt")
    private Date completedAt;

    // Thêm trường mới cho giao nhiều task
    @Column(name = "BatchID")
    private String batchId; // ID để nhóm các task được giao cùng lúc


    @Column(name = "CompletedLat")
    private Double completedLat;

    @Column(name = "CompletedLng")
    private Double completedLng;

    @Column(name = "AfterImage", length = 500)
    private String afterImage;

    @Column(name = "collectedvolume")
    private Double collectedVolume;

    @Column(name = "IssueReason")
    private String issueReason;
    // Constructors
    public Task() {
        this.createdAt = new Date();
        this.status = "OPEN";
    }

    // Getters and Setters
    public int getTaskID() { return taskID; }
    public void setTaskID(int taskID) { this.taskID = taskID; }

    public Bin getBin() { return bin; }
    public void setBin(Bin bin) { this.bin = bin; }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getIssueReason() {
        return issueReason;
    }

    public void setIssueReason(String issueReason) {
        this.issueReason = issueReason;
    }

    public Account getAssignedTo() { return assignedTo; }
    public void setAssignedTo(Account assignedTo) { this.assignedTo = assignedTo; }

    public String getTaskType() { return taskType; }
    public void setTaskType(String taskType) { this.taskType = taskType; }

    public int getPriority() { return priority; }
    public void setPriority(int priority) { this.priority = priority; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public Date getCompletedAt() { return completedAt; }
    public void setCompletedAt(Date completedAt) { this.completedAt = completedAt; }

    public String getBatchId() { return batchId; }
    public void setBatchId(String batchId) { this.batchId = batchId; }

    public Date getUpdateAt() {
        return updatedAt;
    }

    public void setUpdateAt(Date updateAt) {
        this.updatedAt = updateAt;
    }

    public void setCompletedLat(double completedLat) {
        this.completedLat = completedLat;
    }

    public Double getCompletedLat() {
        return completedLat;
    }

    public Double getCompletedLng() {
        return completedLng;
    }

    public void setCompletedLng(double completedLng) {
        this.completedLng = completedLng;
    }

    public String getAfterImage() {
        return afterImage;
    }

    public void setAfterImage(String afterImage) {
        this.afterImage = afterImage;
    }

    public void setCompletedLat(Double completedLat) {
        this.completedLat = completedLat;
    }

    public void setCompletedLng(Double completedLng) {
        this.completedLng = completedLng;
    }

    public Double getCollectedVolume() {
        return collectedVolume;
    }

    public void setCollectedVolume(Double collectedVolume) {
        this.collectedVolume = collectedVolume;
    }
}