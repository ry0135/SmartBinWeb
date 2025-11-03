package com.example.controller.app;

import com.example.dto.LoginRequest;
import com.example.model.Account;
import com.example.model.ApiMessage;
import com.example.repository.AccountRepository;
import com.example.repository.WardRepository;
import com.example.service.AccountService;
import com.example.service.EmailService;
import com.example.service.RandomService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@RestController("accountControllerApp")
@RequestMapping("/api/accounts")
public class AccountAppController {
    @Autowired
    private AccountService accountService;
    @Autowired
    private WardRepository wardRepository;
    @Autowired
    private RandomService randomService;
    @Autowired
    private EmailService emailService;
    @Autowired
    private AccountRepository accountRepository;
    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    @PostMapping("/register")
    public ResponseEntity<?> registerUser(@RequestBody Account account) {

        String encodedPassword = passwordEncoder.encode(account.getPassword());
        String code = randomService.generateRandomCode();
        if (accountService.isEmailExistsAndIsVerifiedTrue(account.getEmail())){
            return ResponseEntity.status(HttpStatus.CONFLICT)
                    .body(new ApiMessage("EMAIL_REGISTERED", "Email đã đăng ký"));
        }if (accountService.isEmailExistsAndIsVerifiedFalse(account.getEmail())) {
            Optional<Account> existOpt = accountRepository.findByEmail(account.getEmail());
            if (existOpt.isPresent()) {
                Account existing = existOpt.get();
                existing.setCode(code);
                existing.setPassword(account.getPassword());
                existing.setFullName(account.getFullName());

                // cập nhật code mới
                accountRepository.save(existing);
                emailService.sendCodeToEmail(existing.getEmail(), code);

                return ResponseEntity.status(HttpStatus.OK)
                        .body(new ApiMessage("EMAIL_NOT_VERIFIED", "Email đã đăng ký nhưng chưa xác minh. Mã xác minh mới đã được gửi."));
            }
        }

        account.setPassword(encodedPassword);
        account.setCode(code);
        account.setIsVerified(false);
        account.setWardID(account.getWardID());
        accountRepository.save(account);
        emailService.sendCodeToEmail(account.getEmail(), code);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(new ApiMessage("CREATED", "Đăng ký thành công. Vui lòng kiểm tra email để xác minh."));
    }

    @PostMapping("/verificode")
    public ResponseEntity<?> verifyCode(@RequestBody Account account) {
        boolean codeVerified = accountService.verifyCodeAndUpdateStatus(account.getEmail(), account.getCode());

        if (codeVerified) {
            account.setIsVerified(true);
            return ResponseEntity.ok("Xác thực thành công!");
        } else {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Mã xác minh không hợp lệ");
        }
    }

    @PostMapping("/login")
    public ResponseEntity<?> loginFromApp(@RequestBody LoginRequest loginRequest) {
        try {
            String username = loginRequest.getEmail();
            String password = loginRequest.getPassword();

            System.out.println("Received login from: " + username + " / " + password);

            Account account = accountService.verify(username, password);

            if (account == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body("Sai tài khoản hoặc mật khẩu");
            }

            if (account.getStatus() == 0) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN)
                        .body("Tài khoản bị khóa");
            }

            account.setPassword(null); // ẩn password
            return ResponseEntity.ok(account);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Lỗi server");
        }
    }

    @PostMapping("/{id}/update-token")
    public ResponseEntity<?> updateFcmToken(
            @PathVariable int id,
            @RequestBody Map<String, String> body) {

        String token = body.get("token");
        accountService.updateFcmToken(id, token);

        Map<String, Object> response = new HashMap<>();
        response.put("status", "success");
        response.put("message", "Token updated");

        return ResponseEntity.ok(response);
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getAccountById(@PathVariable Integer id) {
        Account account = accountRepository.findByAccountId(id);
        if (account == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body("Account not found with id: " + id);
        }
        return ResponseEntity.ok(account);
    }

    @PutMapping("/update/{id}")
    public ResponseEntity<?> updateAccount(@PathVariable Integer id, @RequestBody Account updatedAccount) {
        Optional<Account> accountOpt = accountRepository.findById(id);

        if (!accountOpt.isPresent()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Account not found");
        }

        Account account = accountOpt.get();

        //  Cập nhật thông tin
        if (updatedAccount.getFullName() != null)
            account.setFullName(updatedAccount.getFullName());

        if (updatedAccount.getPhone() != null)
            account.setPhone(updatedAccount.getPhone());

        if (updatedAccount.getAddressDetail() != null)
            account.setAddressDetail(updatedAccount.getAddressDetail());

        if (updatedAccount.getAvatarUrl() != null)
            account.setAvatarUrl(updatedAccount.getAvatarUrl());

        // 🔹 Kiểm tra WardID có tồn tại không trước khi set
        if (updatedAccount.getWardID() != null) {
            Integer wardId = updatedAccount.getWardID();
            boolean wardExists = wardRepository.existsById(wardId);

            if (!wardExists) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body("WardID " + wardId + " does not exist in Wards table");
            }

            account.setWardID(wardId);
        }

        Account saved = accountRepository.save(account);
        return ResponseEntity.ok(saved);
    }

    /** Gửi mã xác minh quên mật khẩu */
    @PostMapping("/forgot-password")
    public ResponseEntity<?> forgotPassword(@RequestParam String email) {
        Optional<Account> opt = accountRepository.findByEmail(email);
        if (!opt.isPresent()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(new ApiMessage("NOT_FOUND", "Email không tồn tại"));
        }

        Account acc = opt.get();
        String code = randomService.generateRandomCode();

        acc.setCode(code);
        accountRepository.save(acc);

        emailService.sendForgotPasswordCode(email, code);
        return ResponseEntity.ok(new ApiMessage("SENT", "Đã gửi mã xác minh qua email"));
    }

    /** Kiểm tra mã xác minh quên mật khẩu (giống verify OTP) */
    @PostMapping("/verify-reset-code")
    public ResponseEntity<?> verifyResetCode(@RequestParam String email, @RequestParam String code) {
        Optional<Account> opt = accountRepository.findByEmail(email);
        if (!opt.isPresent()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(new ApiMessage("NOT_FOUND", "Email không tồn tại"));
        }

        Account acc = opt.get();

        if (!acc.getCode().equals(code)) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(new ApiMessage("INVALID", "Mã xác minh không đúng"));
        }

        return ResponseEntity.ok(new ApiMessage("VERIFIED", "Mã xác minh hợp lệ"));
    }

    /** Đặt lại mật khẩu mới */
    @PostMapping("/reset-password")
    public ResponseEntity<?> resetPassword(
            @RequestParam String email,
            @RequestParam String newPassword) {

        Optional<Account> opt = accountRepository.findByEmail(email);
        if (!opt.isPresent()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(new ApiMessage("NOT_FOUND", "Email không tồn tại"));
        }

        Account acc = opt.get();
        acc.setPassword(passwordEncoder.encode(newPassword));
        acc.setCode(null);
        acc.setIsVerified(true);
        accountRepository.save(acc);

        return ResponseEntity.ok(new ApiMessage("SUCCESS", "Đặt lại mật khẩu thành công"));
    }
}