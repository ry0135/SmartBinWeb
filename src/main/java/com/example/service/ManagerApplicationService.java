package com.example.service;

import com.example.model.Account;
import com.example.model.ManagerApplication;
import com.example.model.Ward;
import com.example.repository.AccountRepository;
import com.example.repository.ManagerApplicationRepository;
import com.example.repository.WardRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class ManagerApplicationService {

    @Autowired
    private ManagerApplicationRepository appRepo;

    @Autowired
    private AccountRepository accountRepo;

    @Autowired
    private WardRepository wardRepo; // giả định bạn đã có repository này

    @Autowired
    private EmailService emailService;

    @Autowired
    private RandomService randomService;

    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    /** Người dùng submit đơn (điền form + upload xong, truyền vào các path) */
    @Transactional
    public ManagerApplication submitApplication(String fullName, String email, String phone, String address,
                                                int wardId, String contractPath, String cmndPath) {
        ManagerApplication app = new ManagerApplication();
        app.setFullName(fullName);
        app.setEmail(email);
        app.setPhone(phone);
        app.setAddress(address);
        app.setWardID(wardId);
        app.setContractPath(contractPath);
        app.setCmndPath(cmndPath);
        app.setStatus(0); // Pending
        return appRepo.save(app);
    }

    /** Admin REJECT đơn kèm lý do, gửi email báo */
    @Transactional
    public ManagerApplication rejectApplication(int applicationId, String reason) {
        ManagerApplication app = appRepo.findByApplicationId(applicationId);
        if (app == null) throw new IllegalArgumentException("Application not found: " + applicationId);
        app.setStatus(3); // Rejected
        app.setRejectionReason(reason);
        appRepo.save(app);

        // Gửi email thông báo reject
        emailService.sendManagerRejectedEmail(app.getEmail(), app.getFullName(), reason);
        return app;
    }

    @Transactional
    public ManagerApplication approveApplication(int applicationId, String adminNotes) {
        ManagerApplication app = appRepo.findByApplicationId(applicationId);
        if (app == null) throw new IllegalArgumentException("Application not found: " + applicationId);
        if (app.getStatus() == 2 && app.getAccountId() != null) {
            // đã approve trước đó
            return app;
        }

        // 1) Login dùng CHÍNH email ứng viên (chuẩn hoá)
        String loginEmail = app.getEmail().trim().toLowerCase();

        // 2) CHẶN nếu email đã tồn tại trong hệ thống
        if (accountRepo.existsByEmail(loginEmail)) {
            throw new IllegalStateException("Email đã tồn tại trong hệ thống, vui lòng dùng email khác.");
        }

        // 3) Tạo mật khẩu tạm
        String tempPassword = randomService.generateTempPassword();

        // 4) Tạo account Manager MỚI
        Account acc = new Account();
        acc.setEmail(loginEmail);
        acc.setFullName(app.getFullName());
        acc.setPassword(passwordEncoder.encode(tempPassword));
        acc.setRole(2);            // Manager
        acc.setStatus(1);          // Active
        acc.setWardID(app.getWardID());
        acc.setIsVerified(true);   // đúng với field trong Account
        accountRepo.save(acc);

        // 5) Cập nhật application
        app.setStatus(2); // Approved
        app.setAdminNotes(adminNotes);
        app.setAccountId(acc.getAccountId());
        appRepo.save(app);

        // 6) Gửi email chào mừng kèm thông tin đăng nhập
        String wardName = "";
        Ward ward = wardRepo.findById(app.getWardID()).orElse(null);
        if (ward != null) wardName = ward.getWardName();

        emailService.sendManagerApprovedEmail(
                loginEmail,           // gửi tới email cá nhân (cũng là email đăng nhập)
                app.getFullName(),
                loginEmail,           // email đăng nhập
                tempPassword,         // mật khẩu tạm
                wardName              // tên phường
        );

        return app;
    }

    /** Tạo email hệ thống dạng manager.ward{wardId}[.seq]@smartbin.com */
    private String generateSystemEmailForManager(int wardId) {
        String domain = "smartbin.com";
        String baseLocal = "manager.ward" + wardId;
        String candidate = baseLocal + "@" + domain;
        int seq = 1;

        while (accountRepo.existsByEmail(candidate)) {
            candidate = baseLocal + "." + seq + "@" + domain;
            seq++;
        }
        return candidate;
    }

}
