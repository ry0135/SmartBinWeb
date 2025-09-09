package com.example.controller.app;

import com.example.model.Account;
import com.example.model.ApiMessage;
import com.example.repository.AccountRepository;
import com.example.service.AccountService;
import com.example.service.EmailService;
import com.example.service.RandomService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Optional;

@RestController("accountControllerApp")
@RequestMapping("/api/accounts")
public class AccountAppController {
    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
    @Autowired
    private AccountService accountService;

    @Autowired
    private RandomService randomService;

    @Autowired
    private EmailService emailService;
    @Autowired
    private AccountRepository accountRepository;


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
                existing.setFullName(account.getPassword());
                existing.setPassword(account.getPassword());
                // cập nhật code mới
                accountRepository.save(existing);
                emailService.sendCodeToEmail(existing.getEmail(), code);

                return ResponseEntity.status(HttpStatus.OK)
                        .body(new ApiMessage("EMAIL_NOT_VERIFIED", "Email đã đăng ký nhưng chưa xác minh. Mã xác minh mới đã được gửi."));
            }
        }
        account.setPassword(encodedPassword);
        account.setCode(code);
        account.setVerified(false);
        accountRepository.save(account);
        emailService.sendCodeToEmail(account.getEmail(), code);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(new ApiMessage("CREATED", "Đăng ký thành công. Vui lòng kiểm tra email để xác minh."));
    }

    @PostMapping("/verificode")
    public ResponseEntity<?> verifyCode(@RequestBody Account account) {
        boolean codeVerified = accountService.verifyCodeAndUpdateStatus(account.getEmail(), account.getCode());

        if (codeVerified) {
            account.setVerified(true);
            return ResponseEntity.ok("Xác thực thành công!");
        } else {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Mã xác minh không hợp lệ");
        }
    }

    @PostMapping("/login")
    public ResponseEntity<?> loginFromApp(@RequestBody Account loginRequest) {
        try {
            String username = loginRequest.getEmail();
            String password = loginRequest.getPassword();

            System.out.println("Received login from: " + username + " / " + password);

            Account account = accountService.verify(username, password);

            if (account == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body("Sai tài khoản hoặc mật khẩu");
            }

            if (account.getRole() == 0) {
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

}