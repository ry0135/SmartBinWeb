package com.example.dto;

import com.example.model.Task;

import java.util.List;

public class TaskStatusUpdate {
    private String batchId;
    private String status;
    private List<TaskDTO> tasks;

    // Thêm cái này vào class
    public TaskStatusUpdate() {
    }
    public TaskStatusUpdate(String batchId, String status, List<TaskDTO> tasks) {
        this.batchId = batchId;
        this.status = status;
        this.tasks = tasks;
    }

    public String getBatchId() {
        return batchId;
    }

    public void setBatchId(String batchId) {
        this.batchId = batchId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public List<TaskDTO> getTasks() {
        return tasks;
    }

    public void setTasks(List<TaskDTO> tasks) {
        this.tasks = tasks;
    }
}
