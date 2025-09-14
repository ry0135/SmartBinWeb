package com.example.dto;

import java.util.List;

public class AssignTasksRequest {
    private List<Integer> binIds;
    private int workerId;
    private String taskType;
    private int priority;
    private String notes;

    // Constructors
    public AssignTasksRequest() {}

    public AssignTasksRequest(List<Integer> binIds, int workerId, String taskType, int priority, String notes) {
        this.binIds = binIds;
        this.workerId = workerId;
        this.taskType = taskType;
        this.priority = priority;
        this.notes = notes;
    }

    // Getters and Setters
    public List<Integer> getBinIds() { return binIds; }
    public void setBinIds(List<Integer> binIds) { this.binIds = binIds; }

    public int getWorkerId() { return workerId; }
    public void setWorkerId(int workerId) { this.workerId = workerId; }

    public String getTaskType() { return taskType; }
    public void setTaskType(String taskType) { this.taskType = taskType; }

    public int getPriority() { return priority; }
    public void setPriority(int priority) { this.priority = priority; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
}