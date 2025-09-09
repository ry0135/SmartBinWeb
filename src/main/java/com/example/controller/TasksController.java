package com.example.controller;

import com.example.model.Account;
import com.example.model.Bin;
import com.example.model.Tasks;
import com.example.service.BinService;
import com.example.service.TasksService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/tasks")
public class TasksController {

    @Autowired
    private TasksService taskService;

    @Autowired
    private BinService binService;

    @GetMapping("/assign/{binId}")
    public String showAssignPage(@PathVariable int binId, Model model) {
        Bin bin = binService.getBinById(binId);
        if (bin == null) {
            return "redirect:/manage";
        }

        List<Account> workers = taskService.getAvailableWorkers(bin.getWardID());

        Map<Integer, Integer> taskCountMap = new HashMap<>();
        for (Account w : workers) {
            taskCountMap.put(w.getAccountId(), taskService.countOpenTasksByWorker(w.getAccountId()));
        }

        model.addAttribute("workers", workers);
        model.addAttribute("taskCountMap", taskCountMap);
        model.addAttribute("binId", binId);
        return "manage/assign-task";
    }

    @PostMapping("/assign")
    public String assignTask(@RequestParam int binId,
                             @RequestParam int workerId,
                             @RequestParam String taskType,
                             @RequestParam int priority,
                             @RequestParam(required = false) String notes) {
        Tasks task = taskService.assignTask(binId, workerId, taskType, priority, notes);
        return "redirect:/manage/bin/" + binId;
    }
}