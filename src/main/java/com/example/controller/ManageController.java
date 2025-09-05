package com.example.controller;

import com.example.model.Bin;
import com.example.service.BinService;
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

    @GetMapping("/manage")
    public String manage(Model model) {
        List<Bin> bins = binService.getAllBins();

        model.addAttribute("bins", bins);
        model.addAttribute("totalBins", bins.size());
        model.addAttribute("alertCount", bins.stream()
                .filter(b -> b.getCurrentFill() >= 80)
                .count());
        model.addAttribute("newReports", 0); // demo

        // Danh sách city/ward để làm filter
        List<String> cities = bins.stream()
                .map(Bin::getCity)
                .distinct()
                .collect(Collectors.toList());

        List<String> wards = bins.stream()
                .map(Bin::getWard)
                .distinct()
                .collect(Collectors.toList());

        List<Integer> statuses = bins.stream()
                .map(Bin::getStatus)
                .distinct()
                .collect(Collectors.toList());
        List<Integer> currentFills = bins.stream()
                .map(Bin::getCurrentFill)
                .map(fill -> fill == null ? 0 : fill)  // tránh null
                .map(fill -> {
                    if (fill >= 80) return 80;   // Cảnh báo
                    else if (fill >= 40) return 40; // Trung bình
                    else return 0;               // Bình thường
                })
                .distinct()
                .collect(Collectors.toList());

        model.addAttribute("currentFills", currentFills);


        model.addAttribute("cities", cities);
        model.addAttribute("wards", wards);
        model.addAttribute("statuses", statuses);
        return "manage/manage-content";
    }

    @GetMapping("/manage/bin/{id}")
    public String binDetail(@PathVariable("id") int id, Model model) {
        Bin bin = binService.getBinById(id);
        if (bin == null) {
            return "redirect:/manage"; // nếu không có thì quay lại
        }
        model.addAttribute("bin", bin);
        return "manage/bin-detail";
    }



}




