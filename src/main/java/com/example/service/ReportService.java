
package com.example.service;

import com.example.model.Report;
import com.example.repository.ReportRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class ReportService {

    @Autowired
    private ReportRepository reportRepository;

    public List<Report> getAllReports() {
        return reportRepository.findAll();
    }
    public Report saveReport(Report report) {
        return reportRepository.save(report);
    }
    public Report getReportById(int id) {
        return reportRepository.findById(id);
    }
    public void updateReport(Report report) {
        Report oldReport = reportRepository.findById(report.getReportID());
        if (oldReport != null) {
            // Giữ nguyên ngày tạo ban đầu
            report.setCreatedAt(oldReport.getCreatedAt());

            // Ghi lại ngày cập nhật hiện tại
            report.setUpdatedAt(new Date());

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

                    if (startDate != null && !startDate.isEmpty() && r.getCreatedAt() != null)
                        match = match && !r.getCreatedAt().before(java.sql.Date.valueOf(startDate));

                    if (endDate != null && !endDate.isEmpty() && r.getCreatedAt() != null)
                        match = match && !r.getCreatedAt().after(java.sql.Date.valueOf(endDate));

                    return match;
                })
                .collect(Collectors.toList());
    }

}