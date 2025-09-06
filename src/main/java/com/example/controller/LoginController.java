package com.example.controller;

import com.example.model.Account;
import com.example.service.AccountService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;
import java.util.Optional;

@Controller
public class LoginController {

    @Autowired
    private AccountService accountService;

    // Hiển thị trang login
    @GetMapping("/login")
    public String showLoginPage() {
        return "login"; // Trả về login.jsp
    }

    // Xử lý đăng nhập
    @PostMapping("/login")
    public String login(
            @RequestParam String email,
            @RequestParam String password,
            HttpSession session,
            Model model) {

        Optional<Account> accountOpt = accountService.authenticate(email, password);

        if (accountOpt.isPresent()) {
            Account account = accountOpt.get();

            // Kiểm tra trạng thái tài khoản
            if (account.getStatus() == 0) {
                model.addAttribute("error", "Tài khoản đã bị khóa");
                return "login";
            }

            // Lưu thông tin đăng nhập vào session
            session.setAttribute("currentUser", account);
            session.setAttribute("userRole", account.getRole());
            session.setAttribute("userName", account.getFullName());

            // Chuyển hướng theo role
            if (account.getRole() == 1) { // Admin
                return "redirect:/admin/dashboard";
            } else if (account.getRole() == 2) { // Manager
                return "redirect:/home";
            } else {
                model.addAttribute("error", "Không có quyền truy cập");
                return "login";
            }

        } else {
            model.addAttribute("error", "Email hoặc mật khẩu không đúng");
            return "login";
        }
    }

    // Đăng xuất
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate(); // Xóa toàn bộ session
        return "redirect:/login";
    }
}