package com.example.repository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;

@Repository
public class AdminRepository {

    @Autowired
    private BinRepository binRepository;

    @Autowired
    private ReportRepository reportRepository;

    @Autowired
    private TasksRepository taskRepository;

    @Autowired
    private FeedbackRepository feedbackRepository;

    // ======================
    // BINS
    // ======================

    public long countAllBins() {
        return binRepository.countAllBins();
    }

    public long countActiveBins() {
        // giả định status = 1 là hoạt động tốt
        return binRepository.countByStatus(1);
    }

    // ======================
    // FEEDBACKS
    // ======================

    public Double avgRating() {
        return feedbackRepository.avgRating();
    }

    // ======================
    // REPORTS
    // ======================

    public long countAllReports() {
        return reportRepository.countAllReports();
    }

    public long countReportsBetween(LocalDateTime start, LocalDateTime end) {
        return reportRepository.countReportsBetween(start, end);
    }

    public long countResolvedReportsBetween(LocalDateTime start, LocalDateTime end) {
        return reportRepository.countResolvedReportsBetween(start, end);
    }

    public List<Object[]> countReportsByStatus() {
        return reportRepository.countReportsByStatus();
    }

    public List<Object[]> countReportsByDate(LocalDateTime start, LocalDateTime end) {
        return reportRepository.countReportsByDate(start, end);
    }

    public List<Object[]> countReportsByType() {
        return reportRepository.countReportsByType();
    }

    public Double avgResolveHours() {
        return reportRepository.avgResolveHours();
    }

    public List<Object[]> slaOnTimeVsLate() {
        return reportRepository.slaOnTimeVsLate();
    }

    public List<Object[]> topReportedBins() {
        return reportRepository.topReportedBins();
    }

    // ======================
    // TASKS
    // ======================

    public List<Object[]> countTasksByStatus() {
        return taskRepository.countTasksByStatus();
    }

    public List<Object[]> countTasksByPriority() {
        return taskRepository.countTasksByPriority();
    }

    public long countOpenTasks() {
        return taskRepository.countOpenTasks();
    }

    public List<Object[]> countTasksCreatedByDate(Date start, Date end) {
        return taskRepository.countTasksCreatedByDate(start, end);
    }

    public List<Object[]> countTasksCompletedByDate(Date start, Date end) {
        return taskRepository.countTasksCompletedByDate(start, end);
    }

    public List<Object[]> taskPerformanceByUser() {
        return taskRepository.taskPerformanceByUser();
    }

    public List<Object[]> lateTasksByUser() {
        return taskRepository.lateTasksByUser();
    }

    public long countOverdueTasks() {
        return taskRepository.countOverdueTasks();
    }

    public Object[] countOnTimeVsTotal() {
        return taskRepository.countOnTimeVsTotal();
    }
}
