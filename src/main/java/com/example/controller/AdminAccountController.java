//package com.example.controller;
//
//import com.example.model.Account;
//import com.example.model.AccountConst;
//import com.example.service.AdminAccountService;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.data.domain.Page;
//import org.springframework.data.domain.Sort;
//import org.springframework.stereotype.Controller;
//import org.springframework.ui.Model;
//import org.springframework.web.bind.annotation.*;
//import org.springframework.web.servlet.mvc.support.RedirectAttributes;
//
//import javax.servlet.http.HttpSession;
//
//@Controller
//@RequestMapping("/admin/accounts")
//public class AdminAccountController {
//
//    @Autowired
//    private AdminAccountService adminAccountService;
//
//    // ========================== 1 trang – 3 khung ==========================
//    @GetMapping({"", "/"})
//    public String all(
//            @RequestParam(value = "status", required = false) Integer status,
//            @RequestParam(value = "q", required = false) String q,
//            @RequestParam(value = "pageM", defaultValue = "0") int pageM, // page cho Managers
//            @RequestParam(value = "pageW", defaultValue = "0") int pageW, // page cho Workers
//            @RequestParam(value = "pageU", defaultValue = "0") int pageU, // page cho Users
//            @RequestParam(value = "size", defaultValue = "10") int size,
//            Model model
//    ) {
//        Sort sort = Sort.by("createdAt").descending();
//
//        Page<Account> managers = adminAccountService.listManagers(status, q, pageM, size, sort);
//        Page<Account> workers  = adminAccountService.listWorkers(status,  q, pageW, size, sort);
//        Page<Account> users    = adminAccountService.listUsers(status,    q, pageU, size, sort);
//
//        model.addAttribute("status", status);
//        model.addAttribute("q", q);
//        model.addAttribute("managers", managers);
//        model.addAttribute("workers", workers);
//        model.addAttribute("users", users);
//        model.addAttribute("AccountConst", AccountConst.class); // để JSP gọi T(...)
//
//        return "admin/accounts"; // JSP hợp nhất (bước kế)
//    }
//
//    // ========================== Ban / Unban (Managers) ==========================
//    @PostMapping("/managers/{id}/ban")
//    public String banManager(@PathVariable("id") int id,
//                             @RequestParam("reason") String reason,
//                             HttpSession session,
//                             RedirectAttributes ra,
//                             @RequestParam(value = "status", required = false) Integer status,
//                             @RequestParam(value = "q", required = false) String q,
//                             @RequestParam(value = "pageM", defaultValue = "0") int pageM,
//                             @RequestParam(value = "pageW", defaultValue = "0") int pageW,
//                             @RequestParam(value = "pageU", defaultValue = "0") int pageU) {
//        int adminId = currentAdminId(session);
//        try {
//            adminAccountService.banAccount(id, reason, adminId);
//            ra.addFlashAttribute("success", "Đã khóa tài khoản #" + id);
//        } catch (Exception e) {
//            ra.addFlashAttribute("error", e.getMessage());
//        }
//        return redirectAll(status, q, pageM, pageW, pageU, "#managers");
//    }
//
//    @PostMapping("/managers/{id}/unban")
//    public String unbanManager(@PathVariable("id") int id,
//                               HttpSession session,
//                               RedirectAttributes ra,
//                               @RequestParam(value = "status", required = false) Integer status,
//                               @RequestParam(value = "q", required = false) String q,
//                               @RequestParam(value = "pageM", defaultValue = "0") int pageM,
//                               @RequestParam(value = "pageW", defaultValue = "0") int pageW,
//                               @RequestParam(value = "pageU", defaultValue = "0") int pageU) {
//        int adminId = currentAdminId(session);
//        try {
//            adminAccountService.unbanAccount(id, adminId);
//            ra.addFlashAttribute("success", "Đã mở khóa tài khoản #" + id);
//        } catch (Exception e) {
//            ra.addFlashAttribute("error", e.getMessage());
//        }
//        return redirectAll(status, q, pageM, pageW, pageU, "#managers");
//    }
//
//    // ========================== Ban / Unban (Workers) ==========================
//    @PostMapping("/workers/{id}/ban")
//    public String banWorker(@PathVariable("id") int id,
//                            @RequestParam("reason") String reason,
//                            HttpSession session,
//                            RedirectAttributes ra,
//                            @RequestParam(value = "status", required = false) Integer status,
//                            @RequestParam(value = "q", required = false) String q,
//                            @RequestParam(value = "pageM", defaultValue = "0") int pageM,
//                            @RequestParam(value = "pageW", defaultValue = "0") int pageW,
//                            @RequestParam(value = "pageU", defaultValue = "0") int pageU) {
//        int adminId = currentAdminId(session);
//        try {
//            adminAccountService.banAccount(id, reason, adminId);
//            ra.addFlashAttribute("success", "Đã khóa tài khoản #" + id);
//        } catch (Exception e) {
//            ra.addFlashAttribute("error", e.getMessage());
//        }
//        return redirectAll(status, q, pageM, pageW, pageU, "#workers");
//    }
//
//    @PostMapping("/workers/{id}/unban")
//    public String unbanWorker(@PathVariable("id") int id,
//                              HttpSession session,
//                              RedirectAttributes ra,
//                              @RequestParam(value = "status", required = false) Integer status,
//                              @RequestParam(value = "q", required = false) String q,
//                              @RequestParam(value = "pageM", defaultValue = "0") int pageM,
//                              @RequestParam(value = "pageW", defaultValue = "0") int pageW,
//                              @RequestParam(value = "pageU", defaultValue = "0") int pageU) {
//        int adminId = currentAdminId(session);
//        try {
//            adminAccountService.unbanAccount(id, adminId);
//            ra.addFlashAttribute("success", "Đã mở khóa tài khoản #" + id);
//        } catch (Exception e) {
//            ra.addFlashAttribute("error", e.getMessage());
//        }
//        return redirectAll(status, q, pageM, pageW, pageU, "#workers");
//    }
//
//    // ========================== Ban / Unban (Users) ==========================
//    @PostMapping("/users/{id}/ban")
//    public String banUser(@PathVariable("id") int id,
//                          @RequestParam("reason") String reason,
//                          HttpSession session,
//                          RedirectAttributes ra,
//                          @RequestParam(value = "status", required = false) Integer status,
//                          @RequestParam(value = "q", required = false) String q,
//                          @RequestParam(value = "pageM", defaultValue = "0") int pageM,
//                          @RequestParam(value = "pageW", defaultValue = "0") int pageW,
//                          @RequestParam(value = "pageU", defaultValue = "0") int pageU) {
//        int adminId = currentAdminId(session);
//        try {
//            adminAccountService.banAccount(id, reason, adminId);
//            ra.addFlashAttribute("success", "Đã khóa tài khoản #" + id);
//        } catch (Exception e) {
//            ra.addFlashAttribute("error", e.getMessage());
//        }
//        return redirectAll(status, q, pageM, pageW, pageU, "#users");
//    }
//
//    @PostMapping("/users/{id}/unban")
//    public String unbanUser(@PathVariable("id") int id,
//                            HttpSession session,
//                            RedirectAttributes ra,
//                            @RequestParam(value = "status", required = false) Integer status,
//                            @RequestParam(value = "q", required = false) String q,
//                            @RequestParam(value = "pageM", defaultValue = "0") int pageM,
//                            @RequestParam(value = "pageW", defaultValue = "0") int pageW,
//                            @RequestParam(value = "pageU", defaultValue = "0") int pageU) {
//        int adminId = currentAdminId(session);
//        try {
//            adminAccountService.unbanAccount(id, adminId);
//            ra.addFlashAttribute("success", "Đã mở khóa tài khoản #" + id);
//        } catch (Exception e) {
//            ra.addFlashAttribute("error", e.getMessage());
//        }
//        return redirectAll(status, q, pageM, pageW, pageU, "#users");
//    }
//
//    // ========================== Helpers ==========================
//    private String redirectAll(Integer status, String q, int pageM, int pageW, int pageU, String anchor) {
//        String ctx = "/admin/accounts";
//        StringBuilder sb = new StringBuilder("redirect:").append(ctx).append("?");
//        boolean first = true;
//        if (status != null) { sb.append("status=").append(status); first = false; }
//        if (q != null && !q.trim().isEmpty()) { sb.append(first?"":"&").append("q=").append(url(q)); first=false; }
//        if (pageM > 0) { sb.append(first?"":"&").append("pageM=").append(pageM); first=false; }
//        if (pageW > 0) { sb.append(first?"":"&").append("pageW=").append(pageW); first=false; }
//        if (pageU > 0) { sb.append(first?"":"&").append("pageU=").append(pageU); }
//        if (anchor != null) sb.append(anchor);
//        return sb.toString();
//    }
//
//    private String url(String s) {
//        try { return java.net.URLEncoder.encode(s, "UTF-8"); }
//        catch (Exception e) { return s; }
//    }
//
//    /**z
//     * Lấy adminId đang đăng nhập.
//     * Tùy dự án, bạn thay cho đúng (Spring Security hoặc session).
//     */
//    private int currentAdminId(HttpSession session) {
//        Object id = session.getAttribute("currentAccountId"); // đổi theo app của bạn
//        if (id instanceof Integer) return (Integer) id;
//
//        Object acc = session.getAttribute("account");
//        if (acc instanceof Account) return ((Account) acc).getAccountId();
//
//        throw new IllegalStateException("Không xác định admin đang đăng nhập.");
//    }
//}
