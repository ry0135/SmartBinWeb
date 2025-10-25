package com.example.service;

import com.example.model.Account;
import com.example.model.AccountConst;
import com.example.repository.AccountRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Service
public class AdminAccountService {

    @Autowired
    private AccountRepository accountRepository;

    @Autowired
    private EmailService emailService;

    // ================= LIST =================
    public Page<Account> listManagers(Integer status, String keyword, int page, int size, Sort sort) {
        return listByRole(AccountConst.Roles.MANAGER, status, keyword, page, size, sort);
    }

    public Page<Account> listWorkers(Integer status, String keyword, int page, int size, Sort sort) {
        return listByRole(AccountConst.Roles.WORKER, status, keyword, page, size, sort);
    }

    public Page<Account> listUsers(Integer status, String keyword, int page, int size, Sort sort) {
        return listByRole(AccountConst.Roles.USER, status, keyword, page, size, sort);
    }

    private Page<Account> listByRole(int role, Integer status, String keyword, int page, int size, Sort sort) {
        Pageable pageable = PageRequest.of(Math.max(page,0), Math.max(size,1),
                sort == null ? Sort.by("createdAt").descending() : sort);

        String kw = (keyword!=null && !keyword.trim().isEmpty()) ? keyword.trim() : null;

        if (status == null && kw == null) {
            return accountRepository.findByRole(role, pageable);
        }

        if (status != null && kw == null) {
            return accountRepository.findByRoleAndStatus(role, status, pageable);
        }

        if (status == null) {
            Page<Account> p1 = accountRepository.findByRoleAndEmailContainingIgnoreCase(role, kw, pageable);
            Page<Account> p2 = accountRepository.findByRoleAndFullNameContainingIgnoreCase(role, kw, pageable);
            return mergePages(p1, p2, pageable);
        }

        Page<Account> p1 = accountRepository.findByRoleAndStatusAndEmailContainingIgnoreCase(role, status, kw, pageable);
        Page<Account> p2 = accountRepository.findByRoleAndStatusAndFullNameContainingIgnoreCase(role, status, kw, pageable);
        return mergePages(p1, p2, pageable);
    }

    private Page<Account> mergePages(Page<Account> p1, Page<Account> p2, Pageable pageable) {
        Set<Integer> seen = new HashSet<>();
        List<Account> combined = new ArrayList<>();

        for (Account a : p1.getContent()) {
            if (seen.add(a.getAccountId())) combined.add(a);
        }
        for (Account a : p2.getContent()) {
            if (seen.add(a.getAccountId())) combined.add(a);
        }

        return new PageImpl<>(combined, pageable, combined.size());
    }

    // ================= BAN / UNBAN =================
    @Transactional
    public void banAccount(int accountId, String reason, int adminId) {
        if (accountId == adminId) {
            throw new IllegalArgumentException("Không thể tự khóa chính mình.");
        }
        if (reason == null || reason.trim().length() < 3) {
            throw new IllegalArgumentException("Lý do phải >= 3 ký tự.");
        }

        Account acc = accountRepository.findById(accountId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy account id=" + accountId));

        if (acc.getStatus() == AccountConst.Status.BANNED) return;

        acc.setStatus(AccountConst.Status.BANNED);
        accountRepository.save(acc);

        try {
            emailService.sendAccountBannedEmail(acc.getEmail(), acc.getFullName(), reason);
        } catch (Exception e) {
            System.err.println("❌ Lỗi gửi mail ban: " + e.getMessage());
        }
    }

    @Transactional
    public void unbanAccount(int accountId, int adminId) {
        Account acc = accountRepository.findById(accountId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy account id=" + accountId));

        if (acc.getStatus() == AccountConst.Status.ACTIVE) return;

        acc.setStatus(AccountConst.Status.ACTIVE);
        accountRepository.save(acc);

        try {
            emailService.sendAccountReactivatedEmail(acc.getEmail(), acc.getFullName());
        } catch (Exception e) {
            System.err.println("❌ Lỗi gửi mail unban: " + e.getMessage());
        }
    }
}
