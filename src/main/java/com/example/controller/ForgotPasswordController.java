package com.example.controller;

import com.example.service.AccountService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@Controller
public class ForgotPasswordController {

    @Autowired
    private AccountService accountService;

    // GET: form nhập email
    @GetMapping("/forgot-password")
    public String showForgotForm() {
        return "forgot-password"; // /WEB-INF/views/forgot-password.jsp
    }

    // POST: nhận email, tạo mã và gửi mail (nếu email tồn tại)
    @PostMapping("/forgot-password")
    public String handleForgotSubmit(HttpServletRequest request) {
        String email = request.getParameter("email");
        accountService.startResetPassword(email); // không lộ tồn tại email

        request.setAttribute("message",
                "Nếu email tồn tại, mã xác minh đã được gửi. Hãy kiểm tra hộp thư.");
        HttpSession session = request.getSession();
        session.setAttribute("fp_email", email);

        return "verify-code"; // sang trang nhập mã + mật khẩu mới
    }

    // GET: vào thẳng trang nhập mã
    @GetMapping("/verify-code")
    public String showVerifyForm() {
        return "verify-code";
    }

    // POST: xác minh mã và đổi mật khẩu
    @PostMapping("/verify-code")
    public String handleVerifySubmit(HttpServletRequest request) {
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("fp_email");
        if (!StringUtils.hasText(email)) {
            email = request.getParameter("email"); // fallback
        }

        String code = request.getParameter("code");
        String newPass = request.getParameter("newPassword");
        String confirm = request.getParameter("confirmPassword");

        if (!StringUtils.hasText(email) || !StringUtils.hasText(code)) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ Email và Mã xác minh.");
            return "verify-code";
        }
        if (!StringUtils.hasText(newPass) || newPass.length() < 6) {
            request.setAttribute("error", "Mật khẩu mới phải từ 6 ký tự trở lên.");
            return "verify-code";
        }
        if (!newPass.equals(confirm)) {
            request.setAttribute("error", "Xác nhận mật khẩu không khớp.");
            return "verify-code";
        }

        boolean ok = accountService.resetPassword(email, code, newPass);
        if (!ok) {
            request.setAttribute("error", "Mã xác minh không đúng hoặc đã hết hạn.");
            return "verify-code";
        }

        session.removeAttribute("fp_email");
        request.setAttribute("success", "Đặt lại mật khẩu thành công. Hãy đăng nhập bằng mật khẩu mới.");
        return "login"; // đổi thành view login thực tế của bạn nếu khác tên
    }
}
