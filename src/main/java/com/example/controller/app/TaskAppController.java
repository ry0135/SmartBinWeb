package com.example.controller.app;



import com.example.dto.BinDTO;
import com.example.dto.TaskDTO;
import com.example.dto.TaskSummaryDTO;
import com.example.model.Task;
import com.example.service.TasksService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/tasks")
public class TaskAppController {

    @Autowired
    private TasksService taskService;

    // 1. Đếm số task mở theo worker
    @GetMapping("/count/worker/{workerId}")
    public int countOpenTasksByWorker(@PathVariable int workerId) {
        return taskService.countOpenTasksByWorker(workerId);
    }


    // 3. Lấy danh sách batch (gom nhóm) theo worker
    @GetMapping("/summary/{workerId}")
    public List<TaskSummaryDTO> getTaskSummaryByWorker(@PathVariable int workerId) {
        return taskService.getTaskSummaryByAssignedTo(workerId);
    }

    @GetMapping("/batch/{workerId}/{batchId}")
    public ResponseEntity<List<TaskDTO>> getTasksInBatch(@PathVariable int workerId, @PathVariable String batchId) {
        List<Task> tasks = taskService.getTasksInBatch(workerId, batchId);
        List<TaskDTO> dtos = tasks.stream().map(task -> {
            TaskDTO dto = new TaskDTO();
            dto.setTaskID(task.getTaskID());
            dto.setTaskType(task.getTaskType());
            dto.setPriority(task.getPriority());
            dto.setStatus(task.getStatus());
            dto.setNotes(task.getNotes());
            dto.setBatchId(task.getBatchId());
            dto.setBin(new BinDTO(task.getBin())); // tránh lazy
            dto.setCreatedAt(task.getCreatedAt());
            dto.setCompletedAt(task.getCompletedAt());
            return dto;
        }).collect(Collectors.toList());

        return ResponseEntity.ok(dtos);
    }


}

