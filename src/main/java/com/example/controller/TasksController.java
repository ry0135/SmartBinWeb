package com.example.controller;

import com.example.model.Account;
import com.example.model.Bin;
import com.example.model.Task;
import com.example.service.BinService;
import com.example.service.TasksService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;
import java.util.List;
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

        return "garbage-collection";
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

        return "maintenance";
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
}