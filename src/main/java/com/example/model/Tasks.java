package com.example.model;



import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Tasks")
public class Tasks {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int taskID;

    // Liên kết thùng rác
    @ManyToOne
    @JoinColumn(name = "BinID", nullable = false)
    private Bin bin;

    // Liên kết nhân viên
    @ManyToOne
    @JoinColumn(name = "AssignedTo", nullable = false)
    private Account assignedTo;

    @Column(length = 20, nullable = false)
    private String taskType = "MAINTENANCE"; // COLLECTION / MAINTENANCE

    private int priority = 1; // 1 = thấp, 5 = cao

    @Column(length = 20, nullable = false)
    private String status = "OPEN"; // OPEN, DOING, DONE, ESCALATED

    @Column(length = 500)
    private String notes;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(updatable = false)
    private Date createdAt = new Date();

    @Temporal(TemporalType.TIMESTAMP)
    private Date dueAt;

    @Temporal(TemporalType.TIMESTAMP)
    private Date completedAt;

    @Column(length = 255)
    private String beforeImage;

    @Column(length = 255)
    private String afterImage;

    // ===== Getters & Setters =====

    public int getTaskID() {
        return taskID;
    }

    public void setTaskID(int taskID) {
        this.taskID = taskID;
    }

    public Bin getBin() {
        return bin;
    }

    public void setBin(Bin bin) {
        this.bin = bin;
    }

    public Account getAssignedTo() {
        return assignedTo;
    }

    public void setAssignedTo(Account assignedTo) {
        this.assignedTo = assignedTo;
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

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getDueAt() {
        return dueAt;
    }

    public void setDueAt(Date dueAt) {
        this.dueAt = dueAt;
    }

    public Date getCompletedAt() {
        return completedAt;
    }

    public void setCompletedAt(Date completedAt) {
        this.completedAt = completedAt;
    }

    public String getBeforeImage() {
        return beforeImage;
    }

    public void setBeforeImage(String beforeImage) {
        this.beforeImage = beforeImage;
    }

    public String getAfterImage() {
        return afterImage;
    }

    public void setAfterImage(String afterImage) {
        this.afterImage = afterImage;
    }
}

