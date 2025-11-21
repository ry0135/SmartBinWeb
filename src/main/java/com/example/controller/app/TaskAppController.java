package com.example.controller.app;



import com.example.dto.BinDTO;
import com.example.dto.TaskDTO;
import com.example.dto.TaskSummaryDTO;
import com.example.model.ApiMessage;
import com.example.model.Task;
import com.example.repository.TasksRepository;
import com.example.service.TasksService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/tasks")
public class TaskAppController {
    @Autowired
    private SimpMessagingTemplate messagingTemplate;
    @Autowired
    private TasksService taskService;
    @Autowired
    private TasksRepository taskRepository;
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

    @PutMapping("/{batchId}/status")
    public ResponseEntity<?> updateTaskStatus(@PathVariable String batchId, @RequestParam String status) {
        List<Task> tasks = taskRepository.findTaskByBatchId(batchId);

        if (tasks == null || tasks.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body("❌ Không tìm thấy task nào có batchId = " + batchId);
        }

        for (Task task : tasks) {
            task.setStatus(status.toUpperCase());
            taskRepository.save(task);
        }

        return ResponseEntity.ok("✅ Đã cập nhật " + tasks.size() + " nhiệm vụ trong batch " + batchId);
    }

    @PostMapping("/complete")
    public ResponseEntity<?> completeTask(
            @RequestParam("taskId") Integer taskId,
            @RequestParam("lat") Double lat,
            @RequestParam("lng") Double lng,
            @RequestParam("collectedVolume") Double collectedVolume,
            @RequestParam("image") MultipartFile image) {


        try {
            // 1️⃣ Xử lý logic upload ảnh + cập nhật DB
            String message = taskService.completeTask(taskId, lat, lng, image,collectedVolume);

            // 2️⃣ Gửi thông báo real-time đến tất cả client đang subscribe
            Map<String, Object> payload = new HashMap<>();
            payload.put("taskId", taskId);
            payload.put("status", "COMPLETED");
            messagingTemplate.convertAndSend("/topic/task-updates", payload);  // ✅ phát thông điệp tới topic

            // 3️⃣ Trả về response cho client Retrofit
            return ResponseEntity.ok(new ApiMessage("✅ " + message));

        } catch (Exception e) {
            return ResponseEntity.internalServerError()
                    .body(new ApiMessage("❌ Lỗi: " + e.getMessage()));
        }
    }



}

