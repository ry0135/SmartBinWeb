package com.example.controller.manager;

import com.example.model.Report;
import com.example.service.EmailService;
import com.example.service.ReportService;
import com.example.util.ReportExportUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletResponse;
import java.net.URLEncoder;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

@Controller
public class ReportController {

    @Autowired
    private ReportService reportService;

    @Autowired
    private EmailService emailService;

    @GetMapping("/reports")
    public String listReports(Model model) {
        List<Report> reports = reportService.getAllReports();
        model.addAttribute("reports", reports);
        return "manage/report-list"; // JSP hiển thị danh sách
    }

    @GetMapping("/reports/add")
    public String showAddForm(Model model) {
        model.addAttribute("report", new Report());
        return "manage/report-add"; // JSP để nhập dữ liệu
    }

    @PostMapping("/reports/add")
    public String addReport(@ModelAttribute("report") Report report) {
        report.setCreatedAt(new Date());
        report.setStatus("OPEN"); // mặc định khi thêm
        reportService.saveReport(report);
        return "redirect:/reports";
    }

    @GetMapping("/detail/{id}")
    public String reportDetail(@PathVariable("id") int id, Model model) {
        Report report = reportService.getReportById(id);
        model.addAttribute("report", report);
        return "manage/report-detail";
    }




    // --- Export Excel (tất cả)
    @GetMapping("/export/excel")
    public void exportExcelAll(
            @RequestParam(value = "startDate", required = false) String startDate,
            @RequestParam(value = "endDate", required = false) String endDate,
            @RequestParam(value = "status", required = false) String status,
            HttpServletResponse response) throws Exception {

        String filename = "reports.xlsx";
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition",
                "attachment; filename*=UTF-8''" + URLEncoder.encode(filename, "UTF-8"));

        List<Report> reports = reportService.filterReports(startDate, endDate, status);
        ReportExportUtil.writeReportsToExcel(reports, response.getOutputStream());
    }

    // --- Export Excel (1 báo cáo)
    @GetMapping("/export/excel/{id}")
    public void exportExcelOne(@PathVariable("id") int id, HttpServletResponse response) throws Exception {
        String filename = "report-" + id + ".xlsx";
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition",
                "attachment; filename*=UTF-8''" + URLEncoder.encode(filename, "UTF-8"));
        Report report = reportService.getReportById(id);
        ReportExportUtil.writeReportsToExcel(Arrays.asList(report), response.getOutputStream());
    }

    // --- Export PDF (tất cả)
    @GetMapping("/export/pdf")
    public void exportPdfAll(
            @RequestParam(value = "startDate", required = false) String startDate,
            @RequestParam(value = "endDate", required = false) String endDate,
            @RequestParam(value = "status", required = false) String status,
            HttpServletResponse response) throws Exception {

        String filename = "reports.pdf";
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition",
                "attachment; filename*=UTF-8''" + URLEncoder.encode(filename, "UTF-8"));

        List<Report> reports = reportService.filterReports(startDate, endDate, status);
        ReportExportUtil.writeReportsToPdf(reports, response.getOutputStream(), null);
    }

    // --- Export PDF (1 báo cáo)
    @GetMapping("/export/pdf/{id}")
    public void exportPdfOne(@PathVariable("id") int id, HttpServletResponse response) throws Exception {
        String filename = "report-" + id + ".pdf";
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition",
                "attachment; filename*=UTF-8''" + URLEncoder.encode(filename, "UTF-8"));
        Report report = reportService.getReportById(id);
        ReportExportUtil.writeReportsToPdf(Arrays.asList(report), response.getOutputStream(), null);
    }



    //--edit detail
    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable("id") int id, Model model) {
        Report report = reportService.getReportById(id);
        model.addAttribute("report", report);
        return "manage/editReport"; // đường dẫn tới JSP
    }

    @PostMapping("/update")
    public String updateReport(@ModelAttribute("report") Report report) {
        reportService.updateReport(report);
        return "redirect:/reports"; // quay lại trang danh sách sau khi cập nhật
    }




    @PostMapping("/sendEmail")
    public String sendReportEmail(@RequestParam("reportId") int reportId,
                                  @RequestParam("email") String email,
                                  RedirectAttributes redirectAttributes) {
        try {
            Report report = reportService.getReportById(reportId);

            // HTML bảng báo cáo
            String htmlTable = "<table border='1' cellpadding='6' cellspacing='0' style='border-collapse:collapse;width:100%;'>"
                    + "<tr><th>ID</th><td>" + report.getReportID() + "</td></tr>"
                    + "<tr><th>BinID</th><td>" + report.getBinID() + "</td></tr>"
                    + "<tr><th>AccountID</th><td>" + report.getAccountID() + "</td></tr>"
                    + "<tr><th>Loại báo cáo</th><td>" + report.getReportType() + "</td></tr>"
                    + "<tr><th>Mô tả</th><td>" + report.getDescription() + "</td></tr>"
                    + "<tr><th>Trạng thái</th><td>" + report.getStatus() + "</td></tr>"
                    + "<tr><th>Người xử lý</th><td>"
                    + (report.getAssignedTo() != null ? report.getAssignedTo() : "Chưa có")
                    + "</td></tr>"
                    + "<tr><th>Ngày tạo</th><td>"
                    + (report.getCreatedAt() != null ? report.getCreatedAt() : "N/A")
                    + "</td></tr>"
                    + "</table>";

            // Gửi email
            emailService.sendReportEmail(email, "Báo cáo #" + reportId + " từ SmartBin", htmlTable);

            // Flash message để hiện sau redirect
            redirectAttributes.addFlashAttribute("message", "✅ Đã gửi báo cáo đến email: " + email);
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "❌ Lỗi khi gửi: " + e.getMessage());
        }

        // Quay lại trang chi tiết
        return "redirect:/detail/" + reportId;
    }
}
