package com.example.controller;

import com.example.model.Bin;
import com.example.service.BinService;
import com.example.service.TasksService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.util.List;
import java.util.stream.Collectors;

@Controller
public class ManageController {

    @Autowired
    private BinService binService;
    @Autowired
    private TasksService tasksService;

    @GetMapping("/manage")
    public String manage(Model model) {
        List<Bin> bins = binService.getAllBins();

        model.addAttribute("bins", bins);
        model.addAttribute("totalBins", bins.size());
        model.addAttribute("alertCount", bins.stream()
                .filter(b -> b.getCurrentFill() >= 80)
                .count());
        model.addAttribute("newReports", 0);

        // Lọc các giá trị duy nhất - SỬA LẠI PHẦN NÀY
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
        model.addAttribute("statuses", statuses);
        model.addAttribute("currentFills", currentFills);

        return "dashboard";
    }
    @GetMapping("/bins")
    public String listbins(Model model) {
        List<Bin> bins = binService.getAllBins();

        model.addAttribute("bins", bins);
        model.addAttribute("totalBins", bins.size());
        model.addAttribute("alertCount", bins.stream()
                .filter(b -> b.getCurrentFill() >= 80)
                .count());
        model.addAttribute("newReports", 0);

        // Lọc các giá trị duy nhất - SỬA LẠI PHẦN NÀY
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
        model.addAttribute("statuses", statuses);
        model.addAttribute("currentFills", currentFills);
        return "manage/list-bins";
    }


    @GetMapping("/manage/bin/{id}")
    public String binDetail(@PathVariable("id") int id, Model model) {
        Bin bin = binService.getBinById(id);
        if (bin == null) {
            return "redirect:/manage";
        }

        // Kiểm tra xem bin có task đang mở không
        boolean hasOpenTask = tasksService.hasOpenTask(id);

        model.addAttribute("bin", bin);
        model.addAttribute("hasOpenTask", hasOpenTask);
        return "manage/bin-detail";
    }
}