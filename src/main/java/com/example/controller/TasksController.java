package com.example.controller;

import com.example.model.Account;
import com.example.model.Bin;
import com.example.model.Task;
import com.example.service.BinService;
import com.example.service.TasksService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/tasks")
public class TasksController {

    @Autowired
    private TasksService taskService;
    @Autowired
    private BinService binService;

    @GetMapping("/task-management")
    public String manage(Model model) {
        List<Bin> allBins = binService.getAllBins();

        // Lọc bỏ bin đã có task OPEN / DOING / COMPLETED và chỉ lấy bin có status == 1
        List<Bin> bins = allBins.stream()
                .filter(bin -> bin.getStatus() == 1) // thêm điều kiện status == 1
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

        return "manage/garbage-collection";
    }
    @GetMapping("/maintenance-management")
    public String maintenance(Model model) {
        List<Bin> allBins = binService.getAllBins();

        // Lọc bỏ bin đã có task OPEN / DOING / COMPLETED và chỉ lấy bin có status == 2
        List<Bin> bins = allBins.stream()
                .filter(bin -> bin.getStatus() == 2) // thêm điều kiện status == 2
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

            List<Account> workers = taskService.getAvailableWorkersMaintenance(wardId);

            model.addAttribute("workers", workers);
            model.addAttribute("binIds", binIds);
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
            Model model) {

        try {
            List<Task> assignedTasks = taskService.assignMultipleTasks(
                    binIds, workerId, taskType, priority, notes
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
            Model model) {

        try {
            List<Task> assignedTasks = taskService.assignMultipleTasks(
                    binIds, workerId, taskType, priority, notes
            );

            model.addAttribute("message", "Đã giao " + assignedTasks.size() + " nhiệm vụ thành công");
            model.addAttribute("assignedTasks", assignedTasks);

            return "manage/assignment-success";

        } catch (Exception e) {
            model.addAttribute("error", "Lỗi khi giao nhiệm vụ: " + e.getMessage());
            return "manage/assignment-error";
        }
    }
    // Thêm vào TasksController.java

    @GetMapping("/management")
    public String taskManagement(
            @RequestParam(value = "status", required = false) String status,
            @RequestParam(value = "type", required = false) String taskType,
            @RequestParam(value = "priority", required = false) Integer priority,
            Model model) {

        List<Task> allTasks = taskService.getAllTasks();

        List<Task> filteredTasks = allTasks.stream()
                .filter(task -> status == null || status.isEmpty() || task.getStatus().equals(status))
                .filter(task -> taskType == null || taskType.isEmpty() || task.getTaskType().equals(taskType))
                .filter(task -> priority == null || task.getPriority() == priority)
                .collect(Collectors.toList());

        // Nhóm task theo batchId
        Map<String, List<Task>> tasksByBatch = filteredTasks.stream()
                .filter(task -> task.getBatchId() != null && !task.getBatchId().isEmpty())
                .collect(Collectors.groupingBy(Task::getBatchId));

        // Task không có batch (đơn lẻ)
        List<Task> singleTasks = filteredTasks.stream()
                .filter(task -> task.getBatchId() == null || task.getBatchId().isEmpty())
                .collect(Collectors.toList());

        model.addAttribute("tasksByBatch", tasksByBatch);
        model.addAttribute("singleTasks", singleTasks);
        model.addAttribute("statusFilter", status);
        model.addAttribute("typeFilter", taskType);
        model.addAttribute("priorityFilter", priority);

        // Thống kê
        model.addAttribute("totalTasks", allTasks.size());
        model.addAttribute("openTasks", allTasks.stream().filter(t -> t.getStatus().equals("OPEN")).count());
        model.addAttribute("doingTasks", allTasks.stream().filter(t -> t.getStatus().equals("DOING")).count());
        model.addAttribute("completedTasks", allTasks.stream().filter(t -> t.getStatus().equals("COMPLETED")).count());

        return "manage/task-management";
    }

    // Xem chi tiết batch
    @GetMapping("/batch/{batchId}")
    public String viewBatchDetail(@PathVariable String batchId, Model model) {
        List<Task> batchTasks = taskService.getTasksByBatch(batchId);
        model.addAttribute("batchTasks", batchTasks);
        model.addAttribute("batchId", batchId);
        return "manage/batch-detail";
    }

    // Xóa batch

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
}
