package com.example.service;


import com.example.model.Account;
import com.example.repository.AccountRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class AccountService {
    @Autowired
    private AccountRepository accountRepository;

    @Autowired
    private EmailService emailService;
    @Autowired
    private RandomService randomService;


    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
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
    public boolean isEmailExistsAndIsVerifiedTrue (String email) {
        return accountRepository.existsByEmailAndIsVerifiedTrue(email);
    }

    @Transactional(readOnly = true)
    public boolean isEmailExistsAndIsVerifiedFalse (String email) {
        return accountRepository.existsByEmailAndIsVerifiedFalse(email);
    }

    @Transactional
    public boolean verifyCodeAndUpdateStatus(String email, String code) {
        Account account = accountRepository.findByEmailAndCode(email, code);
        if (account != null) {
            // Cập nhật trạng thái tài khoản
            account.setStatus(1);
            accountRepository.save(account);
            return true;
        }
        return false;
    }

    @Transactional(readOnly = true)
    public Account verify(String email, String password) {
        // Tìm tài khoản theo tên người dùng
        Account account = accountRepository.findByEmailAccount(email);
        // Nếu tài khoản được tìm thấy, kiểm tra mật khẩu
        if (account != null && passwordEncoder.matches(password, account.getPassword())) {
            return account; // Trả về tài khoản nếu xác thực thành công
        }

        return null; // Trả về null nếu không tìm thấy tài khoản hoặc mật khẩu không chính xác
    }
}
