package com.example.controller;

import com.example.model.Province;
import com.example.model.Ward;
import com.example.service.ProvinceService;
import com.example.service.WardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

/**
 * ===============================
 *  AdminLocationController
 *  Quản lý Tỉnh / Phường (Admin)
 * ===============================
 *  URL gốc: /admin/locations
 *  View chính: /WEB-INF/views/admin/manage_locations.jsp
 */
@Controller
@RequestMapping("/admin/locations") // ✅ Đặt prefix riêng biệt
public class AdminLocationController {

    @Autowired
    private ProvinceService provinceService;

    @Autowired
    private WardService wardService;

    /**
     * [GET] Hiển thị trang quản lý địa điểm
     * URL: /admin/locations
     */
    @GetMapping
    public String showManageLocationsPage(Model model) {
        // Nạp dữ liệu từ DB vào model để JSP hiển thị
        model.addAttribute("provinces", provinceService.getAllProvinces());
        model.addAttribute("wards", wardService.getAllWards());
        return "admin/manage_locations"; // Trỏ đến file JSP
    }

    /**
     * [POST] Xử lý thêm tỉnh mới
     * URL: /admin/locations/add-province
     */
    @PostMapping("/add-province")
    public String addProvince(@RequestParam("provinceName") String provinceName, RedirectAttributes redirectAttrs) {
        if (provinceName == null || provinceName.trim().isEmpty()) {
            redirectAttrs.addFlashAttribute("error", "⚠️ Tên tỉnh không được để trống!");
            return "redirect:/admin/locations";
        }

        boolean exists = provinceService.getAllProvinces().stream()
                .anyMatch(p -> p.getProvinceName().equalsIgnoreCase(provinceName.trim()));
        if (exists) {
            redirectAttrs.addFlashAttribute("error", "❌ Tỉnh '" + provinceName + "' đã tồn tại!");
            return "redirect:/admin/locations";
        }

        Province p = new Province();
        p.setProvinceName(provinceName.trim());
        provinceService.createProvince(p);
        redirectAttrs.addFlashAttribute("success", "✅ Đã thêm tỉnh mới: " + provinceName);
        return "redirect:/admin/locations";
    }

    // ==================== PROVINCE ====================

    // Kiểm tra xem tỉnh đã tồn tại chưa
    @GetMapping("/provinces/check")
    public ResponseEntity<Boolean> checkProvinceExists(@RequestParam String name) {
        boolean exists = provinceService.existsByName(name);
        return ResponseEntity.ok(exists);
    }



    /**
     * [POST] Xử lý thêm phường mới
     * URL: /admin/locations/add-ward
     */
    @PostMapping("/add-ward")
    public String addWard(@RequestParam("provinceId") Integer provinceId,
                          @RequestParam("wardName") String wardName,
                          RedirectAttributes redirectAttrs) {
        // Kiểm tra đầu vào
        if (provinceId == null || wardName == null || wardName.trim().isEmpty()) {
            redirectAttrs.addFlashAttribute("error", "⚠️ Vui lòng chọn tỉnh và nhập tên phường!");
            return "redirect:/admin/locations";
        }

        // Lấy thông tin tỉnh
        Province province = provinceService.getProvinceById(provinceId).orElse(null);
        if (province == null) {
            redirectAttrs.addFlashAttribute("error", "⚠️ Tỉnh được chọn không tồn tại!");
            return "redirect:/admin/locations";
        }

        // Kiểm tra phường đã tồn tại trong tỉnh chưa (so sánh không phân biệt hoa/thường)
        boolean exists = wardService.existsByNameAndProvince(wardName, provinceId);
        if (exists) {
            redirectAttrs.addFlashAttribute("error",
                    "❌ Phường '" + wardName + "' đã tồn tại trong tỉnh " + province.getProvinceName() + "!");
            return "redirect:/admin/locations";
        }

        // Tạo mới phường
        Ward ward = new Ward();
        ward.setProvince(province);
        ward.setWardName(wardName.trim());
        wardService.createWard(ward);

        // Gửi thông báo thành công
        redirectAttrs.addFlashAttribute("success",
                "✅ Đã thêm phường '" + wardName + "' vào tỉnh " + province.getProvinceName() + " thành công!");
        return "redirect:/admin/locations";
    }

    /**
     * [POST] Xóa phường theo ID
     * URL: /admin/locations/delete-ward
     */
    @PostMapping("/delete-ward")
    public String deleteWard(@RequestParam("wardId") Integer wardId) {
        if (wardId != null) {
            wardService.deleteWard(wardId);
        }
        return "redirect:/admin/locations";
    }

    /**
     * [POST] Xóa tỉnh theo ID
     * URL: /admin/locations/delete-province
     */
    @PostMapping("/delete-province")
    public String deleteProvince(@RequestParam("provinceId") Integer provinceId) {
        if (provinceId != null) {
            provinceService.deleteProvince(provinceId);
        }
        return "redirect:/admin/locations";
    }
    // ==================== WARD ====================

    // Kiểm tra phường trùng trong cùng tỉnh
    @GetMapping("/wards/check")
    public ResponseEntity<Boolean> checkWardExists(
            @RequestParam String name,
            @RequestParam Integer provinceId) {
        boolean exists = wardService.existsByNameAndProvince(name, provinceId);
        return ResponseEntity.ok(exists);
    }
    /**
     * [POST] Cập nhật tên tỉnh
     * URL: /admin/locations/update-province
     */
    @PostMapping("/update-province")
    public String updateProvince(@RequestParam("provinceId") Integer provinceId,
                                 @RequestParam("provinceName") String provinceName,
                                 RedirectAttributes redirectAttrs) {
        if (provinceId == null || provinceName == null || provinceName.trim().isEmpty()) {
            redirectAttrs.addFlashAttribute("error", "⚠️ Vui lòng nhập tên tỉnh hợp lệ!");
            return "redirect:/admin/locations";
        }

        Province province = provinceService.getProvinceById(provinceId).orElse(null);
        if (province == null) {
            redirectAttrs.addFlashAttribute("error", "⚠️ Tỉnh không tồn tại!");
            return "redirect:/admin/locations";
        }

        // Kiểm tra trùng tên
        boolean exists = provinceService.getAllProvinces().stream()
                .anyMatch(p -> p.getProvinceName().equalsIgnoreCase(provinceName.trim())
                        && !p.getProvinceId().equals(provinceId));
        if (exists) {
            redirectAttrs.addFlashAttribute("error", "❌ Tỉnh '" + provinceName + "' đã tồn tại!");
            return "redirect:/admin/locations";
        }

        province.setProvinceName(provinceName.trim());
        provinceService.createProvince(province); // dùng cùng hàm save/update
        redirectAttrs.addFlashAttribute("success", "✅ Đã cập nhật tên tỉnh thành công!");
        return "redirect:/admin/locations";
    }

    /**
     * [POST] Cập nhật tên phường
     * URL: /admin/locations/update-ward
     */
    @PostMapping("/update-ward")
    public String updateWard(@RequestParam("wardId") Integer wardId,
                             @RequestParam("wardName") String wardName,
                             RedirectAttributes redirectAttrs) {
        if (wardId == null || wardName == null || wardName.trim().isEmpty()) {
            redirectAttrs.addFlashAttribute("error", "⚠️ Vui lòng nhập tên phường hợp lệ!");
            return "redirect:/admin/locations";
        }

        Ward ward = wardService.getWardById(wardId).orElse(null);
        if (ward == null) {
            redirectAttrs.addFlashAttribute("error", "⚠️ Phường không tồn tại!");
            return "redirect:/admin/locations";
        }

        boolean exists = wardService.existsByNameAndProvince(wardName.trim(), ward.getProvince().getProvinceId());
        if (exists && !ward.getWardName().equalsIgnoreCase(wardName.trim())) {
            redirectAttrs.addFlashAttribute("error",
                    "❌ Phường '" + wardName + "' đã tồn tại trong tỉnh " + ward.getProvince().getProvinceName() + "!");
            return "redirect:/admin/locations";
        }

        ward.setWardName(wardName.trim());
        wardService.createWard(ward);
        redirectAttrs.addFlashAttribute("success", "✅ Đã cập nhật phường thành công!");
        return "redirect:/admin/locations";
    }


}
