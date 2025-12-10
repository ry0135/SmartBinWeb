package com.example.controller.app;



import com.example.dto.BinDTO;
import com.example.dto.TaskDTO;
import com.example.dto.TaskStatusUpdate;
import com.example.dto.TaskSummaryDTO;
import com.example.model.Account;
import com.example.model.ApiMessage;
import com.example.model.Notification;
import com.example.model.Task;
import com.example.repository.AccountRepository;
import com.example.repository.NotificationRepository;
import com.example.repository.TasksRepository;
import com.example.service.TasksService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.time.ZoneId;
import java.time.ZonedDateTime;
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

    @Autowired
    private AccountRepository accountRepository;
    @Autowired
    private NotificationRepository notificationRepository;

    @Autowired
    private SimpMessagingTemplate simpMessagingTemplate;
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
            dto.setAfterImage(task.getAfterImage());
            dto.setCollectedVolume(task.getCollectedVolume());
            dto.setCompletedLng(task.getCompletedLng() != null ? task.getCompletedLng() : 0.0);
            dto.setCompletedLat(task.getCompletedLat() != null ? task.getCompletedLat() : 0.0);
            if (task.getAssignedTo() != null) {
                dto.setAssignedToId(task.getAssignedTo().getAccountId());
                dto.setAssignedToName(task.getAssignedTo().getFullName());
            }

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

        // Cập nhật DB
        for (Task task : tasks) {
            task.setStatus(status.toUpperCase());
            taskRepository.save(task);
        }


        String statusUpper = status.toUpperCase();

        // ✅ NHẬN VÀ HỦY: 1 notification cho cả batch
        if (statusUpper.equals("DOING") || statusUpper.equals("CANCELLED")) {

            Task firstTask = tasks.get(0);

            try {
                List<Account> managers = accountRepository.findManagersSameProvinceByBin(firstTask.getBin().getBinID());

                String title = "";
                String message = "";

                if (statusUpper.equals("IN_PROGRESS")) {
                    title = "🚀 Nhiệm vụ mới";
                    message = "Batch " + batchId + " có " + tasks.size() + " nhiệm vụ đang được thực hiện";
                    if (firstTask.getAssignedTo() != null) {
                        message += " bởi " + firstTask.getAssignedTo().getFullName();
                    }
                } else if (statusUpper.equals("CANCELLED")) {
                    title = "⚠️ Hủy nhiệm vụ";
                    message = "Batch " + batchId + " có " + tasks.size() + " nhiệm vụ đã bị hủy";
                    if (firstTask.getAssignedTo() != null) {
                        message += " bởi " + firstTask.getAssignedTo().getFullName();
                    }
                }

                // Gửi cho tất cả workers
                for (Account manager : managers) {
                    System.out.println(">>> Creating notification for workerId = " + manager.getAccountId());

                    Notification noti = new Notification();
                    noti.setReceiverId(manager.getAccountId());
                    if (firstTask.getAssignedTo() != null) {
                        noti.setSenderId(firstTask.getAssignedTo().getAccountId());
                    } else {
                        noti.setSenderId(null);
                    }

                    noti.setTitle(title);
                    noti.setMessage(message);
                    noti.setType("TASK");
                    noti.setRead(false);
                    noti.setCreatedAt(ZonedDateTime.now(ZoneId.of("Asia/Ho_Chi_Minh")).toLocalDateTime());

                    notificationRepository.save(noti);
                }

                System.out.println("✅ Đã gửi 1 notification cho batch " + batchId);

            } catch (Exception e) {
                System.out.println("❌ LỖI LƯU THÔNG BÁO: " + e.getMessage());
                e.printStackTrace();
            }
        }
        // ✅ HOÀN THÀNH VÀ SỰ CỐ: Notification riêng cho từng task
        else if (statusUpper.equals("COMPLETED") || statusUpper.equals("ISSUE")) {

            for (Task task : tasks) {
                try {
                    List<Account> workers = accountRepository.findManagersSameProvinceByBin(task.getBin().getBinID());

                    String title = "";
                    String message = "";

                    if (statusUpper.equals("COMPLETED")) {
                        title = "✅ Hoàn thành nhiệm vụ";
                        message = "Thùng " + task.getBin().getBinCode() + " đã được thu gom";
                        if (task.getAssignedTo() != null) {
                            message += " bởi " + task.getAssignedTo().getFullName();
                        }
                    } else if (statusUpper.equals("ISSUE")) {
                        title = "❗ Sự cố nhiệm vụ";
                        message = "Thùng " + task.getBin().getBinCode() + " gặp sự cố";
                        if (task.getAssignedTo() != null) {
                            message += " - Báo cáo bởi " + task.getAssignedTo().getFullName();
                        }
                    }

                    // Gửi cho tất cả workers
                    for (Account worker : workers) {
                        System.out.println(">>> Creating notification for taskId = " + task.getTaskID() + ", workerId = " + worker.getAccountId());

                        Notification noti = new Notification();
                        noti.setReceiverId(worker.getAccountId());

                        if (task.getAssignedTo() != null) {
                            noti.setSenderId(task.getAssignedTo().getAccountId());
                        } else {
                            noti.setSenderId(null);
                        }

                        noti.setTitle(title);
                        noti.setMessage(message);
                        noti.setType("TASK");
                        noti.setRead(false);
                        noti.setCreatedAt(ZonedDateTime.now(ZoneId.of("Asia/Ho_Chi_Minh")).toLocalDateTime());

                        notificationRepository.save(noti);
                    }

                } catch (Exception e) {
                    System.out.println("❌ LỖI LƯU THÔNG BÁO cho task " + task.getTaskID() + ": " + e.getMessage());
                    e.printStackTrace();
                }
            }

            System.out.println("✅ Đã gửi " + tasks.size() + " notifications cho từng task");
        }

        // 🔄 Convert Task → TaskDTO để gửi Websocket
        List<TaskDTO> dtoList = tasks.stream().map(task -> {
            TaskDTO dto = new TaskDTO();

            dto.setTaskID(task.getTaskID());
            dto.setTaskType(task.getTaskType());
            dto.setPriority(task.getPriority());
            dto.setStatus(task.getStatus());
            dto.setNotes(task.getNotes());
            dto.setBatchId(task.getBatchId());
            dto.setBin(new BinDTO(task.getBin()));
            dto.setCreatedAt(task.getCreatedAt());
            dto.setCompletedAt(task.getCompletedAt());
            dto.setAfterImage(task.getAfterImage());
            dto.setCollectedVolume(task.getCollectedVolume());
            dto.setCompletedLng(task.getCompletedLng() != null ? task.getCompletedLng() : 0.0);
            dto.setCompletedLat(task.getCompletedLat() != null ? task.getCompletedLat() : 0.0);

            if (task.getAssignedTo() != null) {
                dto.setAssignedToId(task.getAssignedTo().getAccountId());
                dto.setAssignedToName(task.getAssignedTo().getFullName());
            }

            return dto;
        }).collect(Collectors.toList());

        // 🔔 Tạo object update
        TaskStatusUpdate update = new TaskStatusUpdate(batchId, status.toUpperCase(), dtoList);

        // 📝 LOG để debug
        System.out.println("=== SENDING WEBSOCKET ===");
        System.out.println("BatchId: " + update.getBatchId());
        System.out.println("Status: " + update.getStatus());
        System.out.println("Tasks count: " + (update.getTasks() != null ? update.getTasks().size() : "NULL"));
        System.out.println("=========================");

        // 🔔 Gửi WebSocket thông báo thay đổi task
        simpMessagingTemplate.convertAndSend(
                "/topic/task-updates",
                update
        );

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


    @PostMapping("/batch/report-issue")
    public ResponseEntity<ApiMessage> reportBatchIssue(
            @RequestParam int workerId,
            @RequestParam String batchId,
            @RequestParam String reason
    ) {
        try {
            System.out.println("📢 Báo cáo sự cố batch — WorkerId=" + workerId + " | BatchId=" + batchId);

            // 1. Lấy danh sách task trong batch
            List<Task> tasks = taskRepository.findTaskByBatchId(batchId);

            if (tasks == null || tasks.isEmpty()) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(new ApiMessage("NOT_FOUND",
                                "Không tìm thấy nhiệm vụ nào trong batch " + batchId));
            }

            // 2. Chỉ chọn task KHÔNG HOÀN THÀNH
            List<Task> needUpdate = tasks.stream()
                    .filter(t -> !"COMPLETED".equalsIgnoreCase(t.getStatus()))
                    .toList();

            // Nếu tất cả task đã completed → không báo cáo sự cố được
            if (needUpdate.isEmpty()) {
                return ResponseEntity.ok(
                        new ApiMessage(
                                "NO_ACTION",
                                "Tất cả task trong batch " + batchId + " đã hoàn thành — không có mục nào để báo cáo."
                        )
                );
            }

            // 3. Update task chưa hoàn thành → ISSUE
            for (Task task : needUpdate) {
                task.setStatus("ISSUE");
                task.setIssueReason("Sự cố: " + reason);
                taskRepository.save(task);
            }

            // 4. Notifications cho managers
            Task sample = needUpdate.get(0);
            int binId = sample.getBin().getBinID();

            List<Account> managers = accountRepository.findManagersSameProvinceByBin(binId);

            String message = "Batch " + batchId + " gặp sự cố. "
                    + needUpdate.size() + " nhiệm vụ bị ảnh hưởng. Lý do: " + reason;

            for (Account m : managers) {
                Notification noti = new Notification();
                noti.setReceiverId(m.getAccountId());
                noti.setSenderId(workerId);
                noti.setTitle("❗Báo cáo sự cố ");
                noti.setMessage(message);
                noti.setType("ISSUE_TASK");
                noti.setRead(false);
                noti.setCreatedAt(ZonedDateTime.now(ZoneId.of("Asia/Ho_Chi_Minh")).toLocalDateTime());

                notificationRepository.save(noti);
            }

            // 5. WebSocket realtime update
            Map<String, Object> wsData = new HashMap<>();
            wsData.put("type", "BATCH_ISSUE");
            wsData.put("batchId", batchId);
            wsData.put("reason", reason);
            wsData.put("affectedTaskCount", needUpdate.size());

            simpMessagingTemplate.convertAndSend("/topic/task-updates", wsData);

            return ResponseEntity.ok(
                    new ApiMessage(
                            "SUCCESS",
                            "Đã báo cáo sự cố cho " + needUpdate.size() +
                                    " nhiệm vụ chưa hoàn thành trong batch " + batchId
                    )
            );

        } catch (Exception e) {
            System.err.println("❌ Lỗi khi báo cáo batch: " + e.getMessage());
            e.printStackTrace();

            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ApiMessage("ERROR",
                            "Lỗi server khi xử lý báo cáo batch: " + e.getMessage()));
        }
    }

    /**
     * API 2: Báo cáo sự cố cho 1 task cụ thể
     * POST /api/tasks/{taskId}/report-issue
     */
    @PutMapping("/{taskId}/report-issue")
    public ResponseEntity<?> reportTaskIssue(
            @PathVariable int taskId,
            @RequestParam String reason) {

        Task task = taskRepository.findById(taskId).orElse(null);
        if (task == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body("❌ Task không tồn tại");
        }

        task.setStatus("ISSUE");
        task.setIssueReason(reason);
        taskRepository.save(task);

        // Gửi thông báo
        List<Account> managers = accountRepository.findManagersSameProvinceByBin(task.getBin().getBinID());

        for (Account manager : managers) {
            Notification noti = new Notification();
            noti.setReceiverId(manager.getAccountId());
            noti.setSenderId(task.getAssignedTo() != null ? task.getAssignedTo().getAccountId() : null);
            noti.setTitle("❗ Sự cố nhiệm vụ");
            noti.setMessage("Thùng " + task.getBin().getBinCode() + " gặp sự cố: " + reason);
            noti.setType("ISSUE_TASK");
            noti.setRead(false);
            noti.setCreatedAt(ZonedDateTime.now(ZoneId.of("Asia/Ho_Chi_Minh")).toLocalDateTime());
            notificationRepository.save(noti);
        }
        Map<String, Object> update = new HashMap<>();
        update.put("taskId", taskId);
        update.put("binCode", task.getBin().getBinCode());
        update.put("status", "ISSUE");
        update.put("reason", reason);
        update.put("type", "TASK_ISSUE");

        simpMessagingTemplate.convertAndSend("/topic/task-updates", update);

        System.out.println(">>> Realtime sent: TASK_ISSUE");
        return ResponseEntity.ok("Đã đánh dấu sự cố cho task " + taskId);
    }


}

