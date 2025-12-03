package com.example.controller;

import com.example.model.Account;
import com.example.model.Bin;
import com.example.model.Task;
import com.example.service.BinService;
import com.example.service.TasksService;
import com.example.service.WardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/tasks")
public class TasksController {

    @Autowired
    private TasksService taskService;
    @Autowired
    private BinService binService;
    @Autowired
    private WardService wardService;

    @GetMapping("/task-management")
    public String manage(@RequestParam(value = "binId", required = false) Integer binId,
                         @RequestParam(value = "reportId", required = false) Integer reportId,
                         Model model) {
        // Sử dụng repository trực tiếp để lấy bins với status = 1 và currentFill > 60
        List<Bin> highFillBins = binService.getActiveBinsWithHighFill();

        // Lọc bỏ bin đã có task OPEN / DOING
        List<Bin> bins = highFillBins.stream()
                .filter(bin -> !taskService.hasRestrictedTask(bin.getBinID()))
                .collect(Collectors.toList());

        model.addAttribute("bins", bins);

        // Giữ nguyên phần distinct city/ward/status/fill
        List<String> cities = bins.stream()
                .map(bin -> bin.getWard() != null && bin.getWard().getProvince() != null ?
                        bin.getWard().getProvince().getProvinceName() : "")
                .distinct()
                .filter(name -> !name.isEmpty())
                .collect(Collectors.toList());

        List<String> wards = bins.stream()
                .map(bin -> bin.getWard() != null ? bin.getWard().getWardName() : "")
                .distinct()
                .filter(name -> !name.isEmpty())
                .collect(Collectors.toList());

        List<Integer> currentFills = bins.stream()
                .map(bin -> {
                    double fill = bin.getCurrentFill();
                    if (fill >= 80) return 80;
                    else if (fill >= 40) return 40;
                    else return 0;
                })
                .distinct()
                .collect(Collectors.toList());

        model.addAttribute("cities", cities);
        model.addAttribute("wards", wards);
        model.addAttribute("currentFills", currentFills);

        model.addAttribute("binId", binId);
        model.addAttribute("reportId", reportId);
        return "manage/garbage-collection";
    }
    @GetMapping("/maintenance-management")
    public String maintenance( @RequestParam(value = "type", required = false) String type,
                               Model model) {
        List<Bin> allBins = binService.getOffLineBins();

        // Lọc bỏ bin đã có task OPEN / DOING / COMPLETED và chỉ lấy bin có status == 2
        List<Bin> bins = allBins.stream()
                .filter(bin -> !taskService.hasRestrictedTask(bin.getBinID()))
                .collect(Collectors.toList());

        model.addAttribute("bins", bins);

        // Giữ nguyên phần distinct city/ward/status/fill
        List<String> cities = bins.stream()
                .map(bin -> bin.getWard() != null && bin.getWard().getProvince() != null ?
                        bin.getWard().getProvince().getProvinceName() : "")
                .distinct()
                .filter(name -> !name.isEmpty())
                .collect(Collectors.toList());

        List<String> wards = bins.stream()
                .map(bin -> bin.getWard() != null ? bin.getWard().getWardName() : "")
                .distinct()
                .filter(name -> !name.isEmpty())
                .collect(Collectors.toList());
        model.addAttribute("type", type);
        List<Integer> statuses = bins.stream()
                .map(Bin::getStatus)
                .distinct()
                .collect(Collectors.toList());

        model.addAttribute("cities", cities);
        model.addAttribute("wards", wards);

        return "manage/maintenance";
    }

    // ================= TRANG GIAO NHIỀU TASK =================
    @GetMapping("/assign/batch")
    public String showBatchAssignPage(
            @RequestParam("binIds") String binIdsStr,
            @RequestParam("ward") int wardId,
            Model model) {

        try {
            // Chuyển đổi chuỗi binIds thành List<Integer>
            List<Integer> binIds = Arrays.stream(binIdsStr.split(","))
                    .map(String::trim)
                    .filter(s -> !s.isEmpty())
                    .map(Integer::parseInt)
                    .collect(Collectors.toList());

            if (binIds.isEmpty()) {
                return "redirect:/manage?error=Không có thùng rác nào được chọn";
            }

            List<Account> workers = taskService.getAvailableWorkers(wardId);

            model.addAttribute("workers", workers);
            model.addAttribute("binIds", binIds);
            model.addAttribute("wardId", wardId);
            model.addAttribute("wardName", "Phường " + wardId); // Thay bằng service thực tế

            return "manage/assign-task";

        } catch (Exception e) {
            return "redirect:/manage?error=" + e.getMessage();
        }
    }
    // ================= TRANG GIAO NHIỀU TASK =================
    @GetMapping("/assign/batch1")
    public String showBatchAssignPage1(
            @RequestParam("binIds") String binIdsStr,
            @RequestParam("ward") int wardId,
            Model model) {

        try {
            // Chuyển đổi chuỗi binIds thành List<Integer>
            List<Integer> binIds = Arrays.stream(binIdsStr.split(","))
                    .map(String::trim)
                    .filter(s -> !s.isEmpty())
                    .map(Integer::parseInt)
                    .collect(Collectors.toList());

            if (binIds.isEmpty()) {
                return "redirect:/manage?error=Không có thùng rác nào được chọn";
            }

            List<Bin> bins = binService.findAllByIds(binIds);
            List<Account> workers = taskService.getAvailableWorkersMaintenance(wardId);

            model.addAttribute("workers", workers);
            model.addAttribute("binIds", binIds);
            model.addAttribute("bins", bins);
            model.addAttribute("wardId", wardId);
            model.addAttribute("wardName", "Phường " + wardId); // Thay bằng service thực tế

            return "manage/assign-task-maintenance";

        } catch (Exception e) {
            return "redirect:/manage?error=" + e.getMessage();
        }
    }
    // ================= XỬ LÝ GIAO VIỆC (FORM SUBMIT) =================
    @PostMapping("/assign/batch/process")
    public String processBatchAssignment(
            @RequestParam("binIds") List<Integer> binIds,
            @RequestParam("workerId") int workerId,
            @RequestParam("taskType") String taskType,
            @RequestParam("priority") int priority,
            @RequestParam(value = "notes", required = false) String notes,
            @RequestParam int senderId,
            Model model) {

        try {
            List<Task> assignedTasks = taskService.assignMultipleTasks(
                    binIds, workerId, taskType, priority, notes,senderId
            );

            model.addAttribute("message", "Đã giao " + assignedTasks.size() + " nhiệm vụ thành công");
            model.addAttribute("assignedTasks", assignedTasks);

            return "manage/assignment-success";

        } catch (Exception e) {
            model.addAttribute("error", "Lỗi khi giao nhiệm vụ: " + e.getMessage());
            return "manage/assignment-error";
        }
    }
    @PostMapping("/assign/batch/process1")
    public String processBatchAssignment1(
            @RequestParam("binIds") List<Integer> binIds,
            @RequestParam("workerId") int workerId,
            @RequestParam("taskType") String taskType,
            @RequestParam("priority") int priority,
            @RequestParam(value = "notes", required = false) String notes,
            @RequestParam Integer  senderId,
            Model model) {

        try {
            List<Task> assignedTasks = taskService.assignMultipleTasks(binIds, workerId, taskType, priority, notes,
                    senderId != null ? senderId : 2);

            model.addAttribute("message", "Đã giao " + assignedTasks.size() + " nhiệm vụ thành công");
            model.addAttribute("assignedTasks", assignedTasks);

            return "manage/assignment-success";

        } catch (Exception e) {
            model.addAttribute("error", "Lỗi khi giao nhiệm vụ: " + e.getMessage());
            return "manage/assignment-error";
        }
    }
    // Thêm vào TasksController.java

    @GetMapping("/cancel")
    public String taskCancel(
            @RequestParam(value = "status", required = false) String status,
            @RequestParam(value = "type", required = false) String taskType,
            @RequestParam(value = "priority", required = false) Integer priority,
            Model model) {

        try {
            List<Task> tasksCancel = taskService.getCancelTasks();

            // Áp dụng filter nếu có
            List<Task> filteredTasks = tasksCancel.stream()
                    .filter(task -> status == null || status.isEmpty() || task.getStatus().equals(status))
                    .filter(task -> taskType == null || taskType.isEmpty() || task.getTaskType().equals(taskType))
                    .filter(task -> priority == null || task.getPriority() == priority)
                    .collect(Collectors.toList());

            // Nhóm task theo batchId và chỉ lấy batch có trạng thái CANCEL
            Map<String, List<Task>> tasksByBatch = new HashMap<>();
            for (Task task : filteredTasks) {
                if (task.getBatchId() != null && !task.getBatchId().isEmpty()) {
                    String batchStatus = taskService.getBatchStatus(task.getBatchId());
                    if ("CANCEL".equals(batchStatus)) {
                        tasksByBatch.computeIfAbsent(task.getBatchId(), k -> new ArrayList<>()).add(task);
                    }
                }
            }

            // Task không có batch (đơn lẻ)
            List<Task> singleTasks = filteredTasks.stream()
                    .filter(task -> task.getBatchId() == null || task.getBatchId().isEmpty())
                    .collect(Collectors.toList());

            // Thống kê theo BATCH
            Map<String, Long> batchStats = taskService.getBatchStats();

            model.addAttribute("canceltasksByBatch", tasksByBatch);
            model.addAttribute("singleTasks", singleTasks);
            model.addAttribute("statusFilter", status);
            model.addAttribute("typeFilter", taskType);
            model.addAttribute("priorityFilter", priority);

            // CHỈ THÊM THỐNG KÊ THEO BATCH
            model.addAttribute("totalBatches", batchStats.get("totalBatches"));
            model.addAttribute("openBatches", batchStats.get("openBatches"));
            model.addAttribute("doingBatches", batchStats.get("doingBatches"));
            model.addAttribute("completedBatches", batchStats.get("completedBatches"));
            model.addAttribute("cancelBatches", batchStats.get("cancelBatches"));

            return "manage/batch-cancel";

        } catch (Exception e) {
            model.addAttribute("error", "Lỗi khi lấy danh sách task đã hủy: " + e.getMessage());
            return "error";
        }
    }
    @GetMapping("/doing")
    public String getDoingTasks(
            @RequestParam(value = "type", required = false) String taskType,
            @RequestParam(value = "priority", required = false) Integer priority,
            @RequestParam(value = "worker", required = false) Integer workerId,
            Model model) {

        try {
            // Lấy tất cả task đang DOING
            List<Task> doingTasks = taskService.getDoingTasks();

            // Áp dụng filter nếu có
            List<Task> filteredDoingTasks = doingTasks.stream()
                    .filter(task -> taskType == null || taskType.isEmpty() || task.getTaskType().equals(taskType))
                    .filter(task -> priority == null || task.getPriority() == priority)
                    .filter(task -> workerId == null || (task.getAssignedTo() != null && task.getAssignedTo().getAccountId() == workerId))
                    .collect(Collectors.toList());

            // Lấy tất cả batch ID từ các task đang DOING
            Set<String> batchIdsFromDoingTasks = filteredDoingTasks.stream()
                    .filter(task -> task.getBatchId() != null && !task.getBatchId().isEmpty())
                    .map(Task::getBatchId)
                    .collect(Collectors.toSet());

            // Nhóm task theo batch - lấy tất cả task trong batch (cả DOING và COMPLETED)
            Map<String, List<Task>> doingTasksByBatch = new HashMap<>();
            for (String batchId : batchIdsFromDoingTasks) {
                List<Task> allTasksInBatch = taskService.getTasksByBatch(batchId);

                // Chỉ thêm batch nếu có ít nhất 1 task DOING và KHÔNG phải tất cả task đều COMPLETED
                boolean hasDoingTask = allTasksInBatch.stream().anyMatch(task -> "DOING".equals(task.getStatus()));
                boolean allCompleted = allTasksInBatch.stream().allMatch(task -> "COMPLETED".equals(task.getStatus()));

                if (hasDoingTask && !allCompleted) {
                    doingTasksByBatch.put(batchId, allTasksInBatch);
                }
            }

            // Task đơn lẻ đang DOING
            List<Task> singleDoingTasks = filteredDoingTasks.stream()
                    .filter(task -> task.getBatchId() == null || task.getBatchId().isEmpty())
                    .collect(Collectors.toList());

            // Thống kê theo BATCH
            Map<String, Long> batchStats = taskService.getBatchStats();

            model.addAttribute("doingTasksByBatch", doingTasksByBatch);
            model.addAttribute("singleDoingTasks", singleDoingTasks);
            model.addAttribute("typeFilter", taskType);
            model.addAttribute("priorityFilter", priority);
            model.addAttribute("workerFilter", workerId);

            // CHỈ THÊM THỐNG KÊ THEO BATCH
            model.addAttribute("totalBatches", batchStats.get("totalBatches"));
            model.addAttribute("openBatches", batchStats.get("openBatches"));
            model.addAttribute("doingBatches", batchStats.get("doingBatches"));
            model.addAttribute("completedBatches", batchStats.get("completedBatches"));
            model.addAttribute("cancelBatches", batchStats.get("cancelBatches"));

            return "manage/batch-doing";

        } catch (Exception e) {
            model.addAttribute("error", "Lỗi khi lấy danh sách task đang thực hiện: " + e.getMessage());
            return "error";
        }
    }
    @GetMapping("/open")
    public String getOpenTasks(
            @RequestParam(value = "type", required = false) String taskType,
            @RequestParam(value = "priority", required = false) Integer priority,
            @RequestParam(value = "worker", required = false) Integer workerId,
            Model model) {

        try {
            // Lấy tất cả task đang OPEN
            List<Task> openTasks = taskService.getOpenTasks();

            // Áp dụng filter nếu có
            List<Task> filteredOpenTasks = openTasks.stream()
                    .filter(task -> taskType == null || taskType.isEmpty() || task.getTaskType().equals(taskType))
                    .filter(task -> priority == null || task.getPriority() == priority)
                    .filter(task -> workerId == null || (task.getAssignedTo() != null && task.getAssignedTo().getAccountId() == workerId))
                    .collect(Collectors.toList());

            // Nhóm task theo batch và chỉ lấy batch có trạng thái OPEN
            Map<String, List<Task>> openTasksByBatch = new HashMap<>();
            for (Task task : filteredOpenTasks) {
                if (task.getBatchId() != null && !task.getBatchId().isEmpty()) {
                    String batchStatus = taskService.getBatchStatus(task.getBatchId());
                    if ("OPEN".equals(batchStatus)) {
                        openTasksByBatch.computeIfAbsent(task.getBatchId(), k -> new ArrayList<>()).add(task);
                    }
                }
            }

            // Task đơn lẻ đang OPEN
            List<Task> singleOpenTasks = filteredOpenTasks.stream()
                    .filter(task -> task.getBatchId() == null || task.getBatchId().isEmpty())
                    .collect(Collectors.toList());

            // Thống kê theo BATCH
            Map<String, Long> batchStats = taskService.getBatchStats();

            model.addAttribute("openTasksByBatch", openTasksByBatch);
            model.addAttribute("singleOpenTasks", singleOpenTasks);
            model.addAttribute("typeFilter", taskType);
            model.addAttribute("priorityFilter", priority);
            model.addAttribute("workerFilter", workerId);

            // CHỈ THÊM THỐNG KÊ THEO BATCH
            model.addAttribute("totalBatches", batchStats.get("totalBatches"));
            model.addAttribute("openBatches", batchStats.get("openBatches"));
            model.addAttribute("doingBatches", batchStats.get("doingBatches"));
            model.addAttribute("completedBatches", batchStats.get("completedBatches"));
            model.addAttribute("cancelBatches", batchStats.get("cancelBatches"));

            return "manage/batch-open";

        } catch (Exception e) {
            model.addAttribute("error", "Lỗi khi lấy danh sách task đang mở: " + e.getMessage());
            return "error";
        }
    }

    @GetMapping("/completed")
    public String getCompeleTasks(
            @RequestParam(value = "type", required = false) String taskType,
            @RequestParam(value = "priority", required = false) Integer priority,
            @RequestParam(value = "worker", required = false) Integer workerId,
            Model model) {

        try {
            // Lấy tất cả task đã COMPLETED
            List<Task> completedTasks = taskService.getCompletedTasks();

            // Áp dụng filter nếu có
            List<Task> filteredCompletedTasks = completedTasks.stream()
                    .filter(task -> taskType == null || taskType.isEmpty() || task.getTaskType().equals(taskType))
                    .filter(task -> priority == null || task.getPriority() == priority)
                    .filter(task -> workerId == null || (task.getAssignedTo() != null && task.getAssignedTo().getAccountId() == workerId))
                    .collect(Collectors.toList());

            // Nhóm task theo batch và chỉ lấy batch có trạng thái COMPLETED
            Map<String, List<Task>> completedTasksByBatch = new HashMap<>();
            for (Task task : filteredCompletedTasks) {
                if (task.getBatchId() != null && !task.getBatchId().isEmpty()) {
                    String batchStatus = taskService.getBatchStatus(task.getBatchId());
                    if ("COMPLETED".equals(batchStatus)) {
                        completedTasksByBatch.computeIfAbsent(task.getBatchId(), k -> new ArrayList<>()).add(task);
                    }
                }
            }

            // Task đơn lẻ đã COMPLETED
            List<Task> singleCompletedTasks = filteredCompletedTasks.stream()
                    .filter(task -> task.getBatchId() == null || task.getBatchId().isEmpty())
                    .collect(Collectors.toList());

            // Thống kê theo BATCH
            Map<String, Long> batchStats = taskService.getBatchStats();

            model.addAttribute("completedTasksByBatch", completedTasksByBatch);
            model.addAttribute("singleCompletedTasks", singleCompletedTasks);
            model.addAttribute("typeFilter", taskType);
            model.addAttribute("priorityFilter", priority);
            model.addAttribute("workerFilter", workerId);

            // CHỈ THÊM THỐNG KÊ THEO BATCH
            model.addAttribute("totalBatches", batchStats.get("totalBatches"));
            model.addAttribute("openBatches", batchStats.get("openBatches"));
            model.addAttribute("doingBatches", batchStats.get("doingBatches"));
            model.addAttribute("completedBatches", batchStats.get("completedBatches"));
            model.addAttribute("cancelBatches", batchStats.get("cancelBatches"));

            return "manage/batch-completed";

        } catch (Exception e) {
            model.addAttribute("error", "Lỗi khi lấy danh sách task đã hoàn thành: " + e.getMessage());
            return "error";
        }
    }
    // Xem chi tiết batch
    @GetMapping("/batch/{batchId}")
    public String viewBatchDetail(@PathVariable String batchId, Model model) {
        List<Task> batchTasks = taskService.getTasksByBatch(batchId);
        model.addAttribute("batchTasks", batchTasks);
        model.addAttribute("batchId", batchId);
        return "manage/batch-detail";
    }
    @GetMapping("/batchOpen/{batchId}")
    public String viewBatchDetailOpen(@PathVariable String batchId, Model model) {
        List<Task> batchTasks = taskService.getTasksByBatchOpen(batchId);
        model.addAttribute("batchTasks", batchTasks);
        model.addAttribute("batchId", batchId);
        return "manage/task-open";
    }
    @GetMapping("/batchDoing/{batchId}")
    public String viewBatchDetailDoing(@PathVariable String batchId, Model model) {
        List<Task> batchTasks = taskService.getTasksByBatchDoing(batchId);
        model.addAttribute("batchTasks", batchTasks);
        model.addAttribute("batchId", batchId);
        return "manage/task-doing";
    }
    @GetMapping("/batchCompleted/{batchId}")
    public String viewBatchDetailCompleted(@PathVariable String batchId, Model model) {
        List<Task> batchTasks = taskService.getTasksByBatchComplete(batchId);
        model.addAttribute("batchTasks", batchTasks);
        model.addAttribute("batchId", batchId);
        return "manage/task-completed";
    }
    @GetMapping("/batchCancel/{batchId}")
    public String viewBatchDetailCancel(@PathVariable String batchId, Model model) {
        List<Task> batchTasks = taskService.getTasksByBatchCancel(batchId);
        model.addAttribute("batchTasks", batchTasks);
        model.addAttribute("batchId", batchId);
        return "manage/task-cancel";
    }


    // Xóa batch
    @DeleteMapping("/batch/{batchId}")
    @ResponseBody
    public ResponseEntity<?> deleteBatch(@PathVariable String batchId) {
        try {
            taskService.deleteBatch(batchId);
            Map<String, String> response = new HashMap<>();
            response.put("message", "Đã xóa batch thành công");
            return ResponseEntity.ok().body(response);
        } catch (Exception e) {
            Map<String, String> response = new HashMap<>();
            response.put("error", "Lỗi khi xóa batch: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    // Cập nhật status cho cả batch
    @PutMapping("/batch/{batchId}/status")
    @ResponseBody
    public ResponseEntity<?> updateBatchStatus(@PathVariable String batchId, @RequestBody Map<String, String> request) {
        try {
            String status = request.get("status");
            taskService.updateBatchStatus(batchId, status);
            Map<String, String> response = new HashMap<>();
            response.put("message", "Đã cập nhật trạng thái batch thành công");
            return ResponseEntity.ok().body(response);
        } catch (Exception e) {
            Map<String, String> response = new HashMap<>();
            response.put("error", "Lỗi khi cập nhật batch: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    // Xóa task đơn
    @DeleteMapping("/{taskId}")
    @ResponseBody
    public ResponseEntity<?> deleteTask(@PathVariable int taskId) {
        try {
            taskService.deleteTask(taskId);
            Map<String, String> response = new HashMap<>();
            response.put("message", "Đã xóa task thành công");
            return ResponseEntity.ok().body(response);
        } catch (Exception e) {
            Map<String, String> response = new HashMap<>();
            response.put("error", "Lỗi khi xóa task: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    // Cập nhật status cho task đơn
    @PutMapping("/{taskId}/status")
    @ResponseBody
    public ResponseEntity<?> updateTaskStatus(@PathVariable int taskId, @RequestBody Map<String, String> request) {
        try {
            String status = request.get("status");
            taskService.updateTaskStatus(taskId, status);
            Map<String, String> response = new HashMap<>();
            response.put("message", "Đã cập nhật trạng thái task thành công");
            return ResponseEntity.ok().body(response);
        } catch (Exception e) {
            Map<String, String> response = new HashMap<>();
            response.put("error", "Lỗi khi cập nhật task: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    @GetMapping("/batch/{batchId}/edit")
    public String showEditBatchPage(@PathVariable String batchId, Model model) {
        try {
            List<Task> batchTasks = taskService.getTasksByBatch(batchId);
            if (batchTasks.isEmpty()) {
                return "redirect:/tasks/management?error=Batch không tồn tại";
            }

            // Lấy danh sách worker có sẵn (có thể lấy từ ward của task đầu tiên)
            Task firstTask = batchTasks.get(0);
            int wardId = firstTask.getBin().getWard().getWardId();

            List<Account> workers;
            if ("MAINTENANCE".equals(firstTask.getTaskType())) {
                workers = taskService.getAvailableWorkersMaintenance(wardId);
            } else {
                workers = taskService.getAvailableWorkers(wardId);
            }

            model.addAttribute("batchTasks", batchTasks);
            model.addAttribute("batchId", batchId);
            model.addAttribute("workers", workers);
            model.addAttribute("firstTask", firstTask);

            return "manage/update-batch";

        } catch (Exception e) {
            return "redirect:/tasks/management?error=" + e.getMessage();
        }
    }

    // ==================== CẬP NHẬT BATCH ====================
    @PostMapping("/batch/{batchId}/update")
    public String updateBatch(
            @PathVariable String batchId,
            @RequestParam("workerId") int workerId,
            @RequestParam("priority") int priority,
            @RequestParam(value = "notes", required = false) String notes,
            Model model) {

        try {
            taskService.updateBatch(batchId, workerId, priority, notes);
            model.addAttribute("message", "Cập nhật batch thành công");
            return "redirect:/tasks/open";

        } catch (Exception e) {
            model.addAttribute("error", "Lỗi khi cập nhật batch: " + e.getMessage());
            return "manage/update-error";
        }
    }
}
