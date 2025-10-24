package com.example.controller;

import com.example.repository.WardRepository;
import com.example.service.FileStorageService;
import com.example.service.ManagerApplicationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@Controller
public class RegisterManagerController {

    @Autowired
    private WardRepository wardRepository;

    @Autowired
    private FileStorageService fileStorageService;

    @Autowired
    private ManagerApplicationService managerApplicationService;

    @GetMapping("/register-manager")
    public String showForm(Model model) {
        model.addAttribute("wards", wardRepository.findAllByOrderByWardNameAsc());
        // Trả về đúng view theo cây thư mục của bạn: /WEB-INF/views/manager/register-manager.jsp
        return "manage/register-manager";
    }

    @PostMapping("/register-manager")
    public String submit(
            @RequestParam String fullName,
            @RequestParam String email,
            @RequestParam(required = false) String phone,
            @RequestParam(required = false) String address,
            @RequestParam int wardID,
            @RequestParam("contractFile") MultipartFile contractFile,
            @RequestParam("cmndFile") MultipartFile cmndFile,
            Model model
    ) {
        // Validate cơ bản
        if (!StringUtils.hasText(fullName) || !StringUtils.hasText(email) || wardID <= 0) {
            model.addAttribute("error", "Vui lòng nhập đầy đủ Họ tên, Email và chọn Phường.");
            model.addAttribute("wards", wardRepository.findAllByOrderByWardNameAsc());
            return "manage/register-manager";
        }

        try {
            // Lưu file
            String contractPath = fileStorageService.save(contractFile, "contracts");
            String cmndPath     = fileStorageService.save(cmndFile, "idcards");

            // Ghi đơn đăng ký
            managerApplicationService.submitApplication(
                    fullName, email, phone, address, wardID, contractPath, cmndPath
            );

            model.addAttribute("message", "Đã gửi đơn đăng ký. Vui lòng chờ Admin xét duyệt.");
        } catch (IllegalArgumentException ex) {
            // Lỗi do mình chủ động ném ra (size/định dạng)
            model.addAttribute("error", ex.getMessage());
        } catch (Exception ex) {
            // Lỗi khác (IO, v.v.)
            model.addAttribute("error", "Có lỗi khi upload/lưu dữ liệu. Vui lòng thử lại.");
        }

        // Luôn nạp lại danh sách phường cho view
        model.addAttribute("wards", wardRepository.findAllByOrderByWardNameAsc());
        return "manage/register-manager";
    }
}
