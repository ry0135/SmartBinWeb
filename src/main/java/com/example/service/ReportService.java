
package com.example.service;

import com.example.dto.ReportResponseDTO;
import com.example.model.Bin;
import com.example.model.Report;
import com.example.model.ReportImage;
import com.example.model.ReportStatusHistory;
import com.example.repository.BinRepository;
import com.example.repository.ReportImageRepository;
import com.example.repository.ReportRepository;
import com.example.repository.ReportStatusHistoryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class ReportService {

    @Autowired
    private ReportRepository reportRepository;

    @Autowired
    private BinRepository binRepository;
    @Autowired
    private ReportImageRepository reportImageRepository;

    @Autowired
    private ReportStatusHistoryRepository statusHistoryRepository;

    public List<Report> getAllReports() {
        return reportRepository.findAll();
    }
    public Report saveReport(Report report) {
        return reportRepository.save(report);
    }
    public Report getReportById(int id) {
        return reportRepository.findByReportId(id);
    }


    public void updateReport(Report report) {
        Report oldReport = reportRepository.findByReportId(report.getReportId());
        if (oldReport != null) {
            // Giữ nguyên ngày tạo ban đầu
            report.setCreatedAt(oldReport.getCreatedAt());

            // Ghi lại ngày giờ cập nhật hiện tại
            report.setUpdatedAt(LocalDateTime.now());

            reportRepository.save(report);
        }
    }

    public List<Report> filterReports(String startDate, String endDate, String status) {
        List<Report> allReports = reportRepository.findAll();

        return allReports.stream()
                .filter(r -> {
                    boolean match = true;
                    if (status != null && !status.isEmpty())
                        match = match && r.getStatus().equalsIgnoreCase(status);

                    // Ép LocalDateTime về Date
                    if (r.getCreatedAt() != null) {
                        Date createdAt = Date.from(r.getCreatedAt()
                                .atZone(ZoneId.systemDefault())
                                .toInstant());

                        if (startDate != null && !startDate.isEmpty())
                            match = match && !createdAt.before(java.sql.Date.valueOf(startDate));

                        if (endDate != null && !endDate.isEmpty())
                            match = match && !createdAt.after(java.sql.Date.valueOf(endDate));
                    }

                    return match;
                })
                .collect(Collectors.toList());
    }





    // Tạo báo cáo mới
    public Report createReport(Report report) {
        report.setCreatedAt(LocalDateTime.now());
        report.setUpdatedAt(LocalDateTime.now());
        report.setStatus("RECEIVED");

        Report savedReport = reportRepository.save(report);

        // Tạo lịch sử trạng thái
        createStatusHistory(savedReport.getReportId(), "RECEIVED", "Báo cáo được tạo", report.getAccountId());

        return savedReport;
    }

    // Cập nhật trạng thái báo cáo
    public Report updateReportStatus(Integer reportId, String newStatus, String notes, Integer updatedBy) {
        Optional<Report> reportOpt = reportRepository.findById(reportId);
        if (reportOpt.isPresent()) {
            Report report = reportOpt.get();
            report.setStatus(newStatus);
            report.setUpdatedAt(LocalDateTime.now());

            if ("DONE".equals(newStatus)) {
                report.setResolvedAt(LocalDateTime.now());
            }

            Report updatedReport = reportRepository.save(report);

            // Tạo lịch sử trạng thái
            createStatusHistory(reportId, newStatus, notes, updatedBy);

            return updatedReport;
        }
        return null;
    }
    public ReportResponseDTO convertToDTO(Report report) {
        ReportResponseDTO dto = new ReportResponseDTO(
                report.getReportId(),
                report.getBinId(),
                report.getAccountId(),
                report.getReportType(),
                report.getDescription(),
                report.getStatus(),
                report.getCreatedAt(),
                report.getUpdatedAt(),
                report.getResolvedAt()
        );

        // 🔥 Lấy bin trực tiếp từ DB (không dùng Lazy Proxy)
        Bin bin = binRepository.findById(report.getBinId()).orElse(null);

        if (bin != null) {
            dto.setBinCode(bin.getBinCode());
            dto.setBinAddress(
                    bin.getStreet() + ", " +
                            bin.getWard().getWardName() + ", " +
                            bin.getWard().getProvince().getProvinceName()
            );
        }

        return dto;
    }


    // Tạo lịch sử trạng thái
    private void createStatusHistory(Integer reportId, String status, String notes, Integer updatedBy) {
        ReportStatusHistory history = new ReportStatusHistory();
        history.setReportId(reportId);
        history.setStatus(status);
        history.setNotes(notes);
        history.setUpdatedBy(updatedBy);
        history.setCreatedAt(LocalDateTime.now());
        statusHistoryRepository.save(history);
    }

    // Lấy báo cáo theo ID
    public Optional<Report> getReportById(Integer reportId) {
        return reportRepository.findById(reportId);
    }

    // Lấy báo cáo theo AccountID
    public List<Report> getReportsByAccountId(Integer accountId) {
        return reportRepository.findByAccountIdOrderByCreatedAtDesc(accountId);
    }

    // Lấy báo cáo theo trạng thái
    public List<Report> getReportsByStatus(String status) {
        return reportRepository.findByStatusOrderByCreatedAtDesc(status);
    }

    // Lấy báo cáo theo BinID
    public List<Report> getReportsByBinId(Integer binId) {
        return reportRepository.findByBinIdOrderByCreatedAtDesc(binId);
    }

    // Lấy báo cáo theo AssignedTo
    public List<Report> getReportsByAssignedTo(Integer assignedTo) {
        return reportRepository.findByAssignedToOrderByCreatedAtDesc(assignedTo);
    }


    // Lấy báo cáo theo khoảng thời gian
    public List<Report> getReportsByDateRange(LocalDateTime startDate, LocalDateTime endDate) {
        return reportRepository.findByDateRange(startDate, endDate);
    }

    // Lấy báo cáo theo ReportType
    public List<Report> getReportsByReportType(String reportType) {
        return reportRepository.findByReportTypeOrderByCreatedAtDesc(reportType);
    }

    // Thêm hình ảnh vào báo cáo
    public ReportImage addImageToReport(Integer reportId, String imageUrl) {
        ReportImage image = new ReportImage();
        image.setReportId(reportId);
        image.setImageUrl(imageUrl);
        image.setCreatedAt(LocalDateTime.now());
        return reportImageRepository.save(image);
    }

    // Lấy hình ảnh của báo cáo
    public List<ReportImage> getReportImages(Integer reportId) {
        return reportImageRepository.findByReportIdOrderByCreatedAtDesc(reportId);
    }

    // Lấy lịch sử trạng thái của báo cáo
    public List<ReportStatusHistory> getReportStatusHistory(Integer reportId) {
        return statusHistoryRepository.findByReportIdOrderByCreatedAtDesc(reportId);
    }

    // Đếm báo cáo theo trạng thái
    public long countReportsByStatus(String status) {
        return reportRepository.countByStatus(status);
    }

    // Đếm báo cáo theo AccountID
    public long countReportsByAccountId(Integer accountId) {
        return reportRepository.countByAccountId(accountId);
    }

    // Đếm số hình ảnh theo ReportID
    public long countReportImages(Integer reportId) {
        return reportImageRepository.countByReportId(reportId);
    }

    // Xóa báo cáo
    public void deleteReport(Integer reportId) {
        reportRepository.deleteById(reportId);
    }

    // Xóa tất cả báo cáo
    public void deleteAllReports() {
        reportRepository.deleteAll();
    }



}

