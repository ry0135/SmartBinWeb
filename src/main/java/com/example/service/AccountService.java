package com.example.service;

import com.example.model.Account;
import com.example.repository.AccountRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
public class AccountService {
    @Autowired
    private AccountRepository accountRepository;

    @Autowired
    private EmailService emailService;

    @Autowired
    private RandomService randomService;

    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

     //PHƯƠNG THỨC MỚI CHO LOGIN
    @Transactional(readOnly = true)
    public Optional<Account> authenticate(String email, String password) {
        Account account = accountRepository.findByEmailAccount(email);

        if (account != null && passwordEncoder.matches(password, account.getPassword())) {
            return Optional.of(account);
        }
        return Optional.empty();
    }
//    @Transactional(readOnly = true)
//    public Optional<Account> authenticate(String email, String password) {
//        Account account = accountRepository.findByEmailAccount(email);
//
//        // So sánh trực tiếp với mật khẩu trong database (không mã hóa)
//        if (account != null && account.getPassword().equals(password)) {
//            return Optional.of(account);
//        }
//
//        return Optional.empty();
//    }

    // CÁC PHƯƠNG THỨC HIỆN CÓ GIỮ NGUYÊN...
    @Transactional
    public void save(Account account) {
        String code = randomService.generateRandomCode();
        String encodedPassword = passwordEncoder.encode(account.getPassword());
        account.setPassword(encodedPassword);
        account.setCode(code);

        accountRepository.save(account);
        emailService.sendCodeToEmail(account.getEmail(), code);
    }

    @Transactional(readOnly = true)
    public boolean isEmailExistsAndIsVerifiedTrue(String email) {
        return accountRepository.existsByEmailAndIsVerifiedTrue(email);
    }

    @Transactional(readOnly = true)
    public boolean isEmailExistsAndIsVerifiedFalse(String email) {
        return accountRepository.existsByEmailAndIsVerifiedFalse(email);
    }



    @Transactional
    public boolean verifyCodeAndUpdateStatus(String email, String code) {
        Account account = accountRepository.findByEmailAndCode(email, code);
        if (account != null) {
            account.setStatus(1);
            accountRepository.save(account);
            return true;
        }
        return false;
    }

    @Transactional(readOnly = true)
    public Account verify(String email, String rawPassword) {
        Account acc = accountRepository.findByEmailAccount(email);
        if (acc != null && rawPassword != null) {
            if (passwordEncoder.matches(rawPassword, acc.getPassword())) {
                return acc;
            }
        }
        return null;
    }

    public void updateFcmToken(int workerId, String token) {
        Account worker = accountRepository.findByAccountId(workerId);

        worker.setFcmToken(token);
        accountRepository.save(worker);
    }

    public String getFcmTokenByWorkerId(int workerId) {
        return accountRepository.findFcmTokenByAccountId(workerId);
    }
    // ========= FORGOT / RESET PASSWORD (ADD-ON) =========

    /** B1: Yêu cầu đặt lại mật khẩu — tạo mã, lưu vào Account.code và gửi email (không lộ tồn tại email) */
    @Transactional
    public void startResetPassword(String email) {
        Account acc = accountRepository.findByEmailAccount(email);
        if (acc == null) {
            // Không tiết lộ sự tồn tại của email để đảm bảo bảo mật
            return;
        }
        String code = randomService.generateRandomCode();
        acc.setCode(code);
        accountRepository.save(acc);

        // Gửi email chứa mã xác minh đặt lại mật khẩu
        emailService.sendVerifyCodeAndUpdatePassword(email, code);
    }

    /** (Tuỳ chọn) Kiểm tra nhanh mã xác minh có khớp email không */
    @Transactional(readOnly = true)
    public boolean checkResetCode(String email, String code) {
        Account acc = accountRepository.findByEmailAndCode(email, code);
        return acc != null;
    }

    /** B2: Đặt mật khẩu mới nếu mã hợp lệ (mã hoá BCrypt) và xoá mã sau khi dùng */
    @Transactional
    public boolean resetPassword(String email, String code, String newPassword) {
        Account acc = accountRepository.findByEmailAndCode(email, code);
        if (acc == null) return false;

        String encoded = passwordEncoder.encode(newPassword);
        acc.setPassword(encoded);
        acc.setCode(null); // Xoá mã sau khi đổi mật khẩu thành công
        accountRepository.save(acc);
        return true;
    }

    /** (Tuỳ chọn) Gửi lại mã đặt lại mật khẩu */
    @Transactional
    public void resendResetCode(String email) {
        Account acc = accountRepository.findByEmailAccount(email);
        if (acc == null) return;

        String code = randomService.generateRandomCode();
        acc.setCode(code);
        accountRepository.save(acc);

        emailService.sendVerifyCodeAndUpdatePassword(email, code);
    }

    // ========= AUTH (ADD-ON) =========
    /** Phiên bản đăng nhập dùng BCrypt (giữ riêng, KHÔNG xoá method authenticate cũ) */
    @Transactional(readOnly = true)
    public Optional<Account> authenticateBCrypt(String email, String password) {
        Account account = accountRepository.findByEmailAccount(email);
        if (account != null && passwordEncoder.matches(password, account.getPassword())) {
            return Optional.of(account);
        }
        return Optional.empty();
    }

}