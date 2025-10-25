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
        return "login"; // /WEB-INF/views/login.jsp
    }

    // Xử lý đăng nhập
    @PostMapping("/login")
    public String login(
            @RequestParam String email,
            @RequestParam String password,
            HttpSession session,
            Model model) {

        String emailTrim = email == null ? null : email.trim();
        Optional<Account> accountOpt = accountService.authenticate(emailTrim, password);

        if (!accountOpt.isPresent()) {
            model.addAttribute("error", "Email hoặc mật khẩu không đúng");
            return "login";
        }

        Account account = accountOpt.get();

        // Tài khoản bị khóa?
        if (account.getStatus() == 0) {
            model.addAttribute("error", "Tài khoản đã bị khóa");
            return "login";
        }

        // ===== LƯU SESSION (chuẩn theo Cách 1) =====
        // Các key bạn đang dùng
        session.setAttribute("currentUser", account);
        session.setAttribute("userRole", account.getRole());
        session.setAttribute("userName", account.getFullName());

        // Thêm 2 key mà AdminAccountController cần
        session.setAttribute("currentAccountId", account.getAccountId());
        session.setAttribute("account", account);
        // ==========================================

        // Điều hướng theo role (tuỳ dự án, bạn đổi URL cho phù hợp)
        switch (account.getRole()) {
            case 1: // Admin
                return "redirect:/admin/overview";
            case 2: // Manager
                return "redirect:/manage";
            case 3: // Worker (nếu có)
                return "redirect:/manager"; // hoặc trang worker riêng của bạn
            case 4: // User/Citizen (nếu cho phép đăng nhập web)
                return "redirect:/";
            default:
                model.addAttribute("error", "Không có quyền truy cập");
                return "login";
        }
    }

    // Đăng xuất
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
}
