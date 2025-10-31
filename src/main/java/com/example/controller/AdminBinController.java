package com.example.controller;

import com.example.model.Bin;
import com.example.repository.WardRepository;
import com.example.service.BinService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin/bins")
public class AdminBinController {

    private final BinService binService;
    private final WardRepository wardRepository;

    public AdminBinController(BinService binService, WardRepository wardRepository) {
        this.binService = binService;
        this.wardRepository = wardRepository;
    }

    // Trang danh sách
    @GetMapping("/list")
    public String list(Model model) {
        model.addAttribute("bins", binService.getAllBins());
        return "admin/bins"; // JSP: /WEB-INF/views/admin/bins.jsp
    }

    // Form thêm mới
    @GetMapping("/new")
    public String showCreateForm(Model model) {
        model.addAttribute("bin", new Bin());
        model.addAttribute("wards", wardRepository.findAll());
        return "admin/bin-add";
    }

    // Submit thêm mới
    @PostMapping
    public String create(@ModelAttribute("bin") Bin bin,
                         RedirectAttributes ra,
                         Model model) {
        try {
            binService.saveOrUpdateBin(bin);
            ra.addFlashAttribute("success", "Thêm thùng rác thành công");
            return "redirect:/admin/bins/list";
        } catch (Exception e) {
            model.addAttribute("wards", wardRepository.findAll());
            model.addAttribute("error", e.getMessage());
            return "admin/bin-add";
        }
    }

    // Form edit
    @GetMapping("/{id}/edit")
    public String showEdit(@PathVariable int id, Model model, RedirectAttributes ra) {
        Bin b = binService.getBinById(id);
        if (b == null) {
            ra.addFlashAttribute("error", "Không tìm thấy BinID=" + id);
            return "redirect:/admin/bins/list";
        }
        model.addAttribute("bin", b);
        model.addAttribute("wards", wardRepository.findAll());
        return "admin/bin-edit";
    }

//    // Submit update
//    @PostMapping("/{id}/update")
//    public String doUpdate(@PathVariable int id,
//                           @ModelAttribute("bin") Bin form,
//                           RedirectAttributes ra,
//                           Model model) {
//        try {
//            binService.updateBin(id, form);
//            ra.addFlashAttribute("success", "Cập nhật thành công");
//            return "redirect:/admin/bins/list";
//        } catch (Exception e) {
//            model.addAttribute("wards", wardRepository.findAll());
//            model.addAttribute("error", e.getMessage());
//            return "admin/bin-edit";
//        }
//    }
//
//    // Xoá
//    @PostMapping("/{id}/delete")
//    public String doDelete(@PathVariable int id, RedirectAttributes ra) {
//        try {
//            binService.delete(id);
//            ra.addFlashAttribute("success", "Đã xoá BinID=" + id);
//        } catch (Exception e) {
//            ra.addFlashAttribute("error", "Không thể xoá: " + e.getMessage());
//        }
//        return "redirect:/admin/bins/list";
//    }
//    @org.springframework.web.bind.annotation.InitBinder
//    public void initBinder(org.springframework.web.bind.WebDataBinder binder) {
//        // Không cho client bind vào binCode từ request (kể cả ai đó tự tạo field ẩn)
//        binder.setDisallowedFields("binCode");
//    }

}
