package com.example.controller;

import com.example.model.Account;
import com.example.model.ApiResponse;
import com.example.service.AccountService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/admin")
public class AdminController {
    
    @Autowired
    private AccountService accountService;
    
    // Trang dashboard admin
    @GetMapping("/dashboard")
    public String adminDashboard(Model model) {
        model.addAttribute("title", "Admin Dashboard");
        model.addAttribute("message", "Chào mừng đến với trang quản trị");
        return "admin/dashboard";
    }
    
    // Trang quản lý tài khoản
    @GetMapping("/accounts")
    public String manageAccounts(Model model) {
        model.addAttribute("title", "Quản lý tài khoản");
        return "admin/accounts";
    }
    
    // Trang quản lý thùng rác
    @GetMapping("/bins")
    public String manageBins(Model model) {
        model.addAttribute("title", "Quản lý thùng rác");
        return "admin/bins";
    }
    
    // Trang quản lý báo cáo
    @GetMapping("/reports")
    public String manageReports(Model model) {
        model.addAttribute("title", "Quản lý báo cáo");
        return "admin/reports";
    }
    
    // Trang quản lý feedback
    @GetMapping("/feedbacks")
    public String manageFeedbacks(Model model) {
        model.addAttribute("title", "Quản lý đánh giá");
        return "admin/feedbacks";
    }
    
    // API tạo tài khoản admin

}