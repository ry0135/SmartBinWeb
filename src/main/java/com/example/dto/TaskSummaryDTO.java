package com.example.dto;

import com.fasterxml.jackson.annotation.JsonFormat;

import javax.persistence.Column;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import java.time.LocalDateTime;
import java.util.Date;

public class TaskSummaryDTO {
    private String batchId;
    private int assignedTo;
    private String note;
    private int minPriority;
    private String status;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "Asia/Ho_Chi_Minh")
    private Date createdAt;
    public TaskSummaryDTO(String batchId, int assignedTo, String note, int minPriority) {
        this.batchId = batchId;
        this.assignedTo = assignedTo;
        this.note = note;
        this.minPriority = minPriority;
    }

    public TaskSummaryDTO(String batchId, int accountId, String notes, int priority, String status) {
        this.batchId = batchId;
        this.assignedTo = accountId;
        this.note = notes;
        this.minPriority = priority;
        this.status = status;
    }

    public TaskSummaryDTO(String batchId, int accountId, String notes, int priority, String status, Date createdAt) {
        this.batchId = batchId;
        this.assignedTo = accountId;
        this.note = notes;
        this.minPriority = priority;
        this.status = status;
        this.createdAt = createdAt;
    }


    public String getBatchId() {
        return batchId;
    }

    public void setBatchId(String batchId) {
        this.batchId = batchId;
    }

    public int getAssignedTo() {
        return assignedTo;
    }

    public void setAssignedTo(int assignedTo) {
        this.assignedTo = assignedTo;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public int getMinPriority() {
        return minPriority;
    }

    public void setMinPriority(int minPriority) {
        this.minPriority = minPriority;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
    // getter & setter
}
