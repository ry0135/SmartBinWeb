package com.example.model;

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
    @Column(name = "CreatedAt")
    private Date createdAt;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "CompletedAt")
    private Date completedAt;

    // Thêm trường mới cho giao nhiều task
    @Column(name = "BatchID")
    private String batchId; // ID để nhóm các task được giao cùng lúc

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
}