package com.example.controller;

import com.example.model.ManagerApplication;
import com.example.repository.ManagerApplicationRepository;
import com.example.repository.WardRepository;
import com.example.service.ManagerApplicationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/admin/applications")
public class AdminApplicationController {

    @Autowired
    private ManagerApplicationRepository appRepo;

    @Autowired
    private WardRepository wardRepository;

    @Autowired
    private ManagerApplicationService appService;

    // Danh sách
    @GetMapping
    public String list(Model model) {
        model.addAttribute("pending",  appRepo.findByStatus(0));
        model.addAttribute("approved", appRepo.findByStatus(2));
        model.addAttribute("rejected", appRepo.findByStatus(3));
        return "admin/applications"; // /WEB-INF/views/admin-applications.jsp
    }

    // Chi tiết
    @GetMapping("/{id}")
    public String detail(@PathVariable("id") int id, Model model) {
        ManagerApplication app = appRepo.findByApplicationId(id);
        if (app == null) {
            model.addAttribute("error", "Không tìm thấy đơn đăng ký #" + id);
            return "admin/applications";
        }
        model.addAttribute("app", app);
        model.addAttribute("ward",
                wardRepository.findByWardId(app.getWardID()));


        return "admin/application-detail"; // /WEB-INF/views/admin-application-detail.jsp
    }

    // Approve
    @PostMapping("/{id}/approve")
    public String approve(@PathVariable("id") int id,
                          @RequestParam(required = false) String adminNotes,
                          Model model) {
        try {
            appService.approveApplication(id, adminNotes);
            return "redirect:/admin/applications/" + id + "?approved=1";
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return detail(id, model);
        }
    }

    // Reject
    @PostMapping("/{id}/reject")
    public String reject(@PathVariable("id") int id,
                         @RequestParam String reason,
                         Model model) {
        if (!StringUtils.hasText(reason)) {
            model.addAttribute("error", "Vui lòng nhập lý do từ chối.");
            return detail(id, model);
        }
        try {
            appService.rejectApplication(id, reason);
            return "redirect:/admin/applications/" + id + "?rejected=1";
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return detail(id, model);
        }
    }
}
