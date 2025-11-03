package com.example.service;

import com.example.repository.AccountRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Random;

@Service
public class RandomService {

    @Autowired
    private AccountRepository accountRepository;

    @Transactional(readOnly = true)
    public String generateRandomCode() {
        Random random = new Random();
        int code = 100000 + random.nextInt(900000);
        return String.valueOf(code);
    }

    // ===================== ADD-ON =====================
    // Sinh mật khẩu tạm 10 ký tự: có ít nhất 1 hoa, 1 thường, 1 số
    @Transactional(readOnly = true)
    public String generateTempPassword() {
        String upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        String lower = "abcdefghijklmnopqrstuvwxyz";
        String digits = "0123456789";
        String all = upper + lower + digits;

        Random rnd = new Random();
        StringBuilder sb = new StringBuilder();

        // đảm bảo mỗi loại 1 ký tự
        sb.append(upper.charAt(rnd.nextInt(upper.length())));
        sb.append(lower.charAt(rnd.nextInt(lower.length())));
        sb.append(digits.charAt(rnd.nextInt(digits.length())));

        // bổ sung ngẫu nhiên đến đủ 10 ký tự
        for (int i = 3; i < 10; i++) {
            sb.append(all.charAt(rnd.nextInt(all.length())));
        }
        return sb.toString();
    }
}
