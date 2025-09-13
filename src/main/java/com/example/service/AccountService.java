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

    // PHƯƠNG THỨC MỚI CHO LOGIN
//    @Transactional(readOnly = true)
//    public Optional<Account> authenticate(String email, String password) {
//        Account account = accountRepository.findByEmailAccount(email);
//
//        if (account != null && passwordEncoder.matches(password, account.getPassword())) {
//            return Optional.of(account);
//        }
//        return Optional.empty();
//    }
    @Transactional(readOnly = true)
    public Optional<Account> authenticate(String email, String password) {
        Account account = accountRepository.findByEmailAccount(email);

        // So sánh trực tiếp với mật khẩu trong database (không mã hóa)
        if (account != null && account.getPassword().equals(password)) {
            return Optional.of(account);
        }

        return Optional.empty();
    }

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
}