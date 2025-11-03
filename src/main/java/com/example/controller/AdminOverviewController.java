package com.example.controller;

import com.example.model.Bin;
import com.example.service.BinService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Controller
public class AdminOverviewController {

    @Autowired
    private BinService binService;

    // ✅ Khi bấm vào Dashboard hoặc truy cập /admin/overview
    @GetMapping("/admin/overview")
    public String showDashboard(Model model) {
        // Lấy toàn bộ danh sách thùng rác
        List<Bin> bins = binService.getAllBins();

        model.addAttribute("bins", bins);
        model.addAttribute("totalBins", bins.size());
        model.addAttribute("alertCount", bins.stream()
                .filter(b -> b.getCurrentFill() >= 80)
                .count());
        model.addAttribute("newReports", 0);

        return "admin/overview"; // 👉 Trỏ tới file JSP bạn vừa gửi
    }
}
