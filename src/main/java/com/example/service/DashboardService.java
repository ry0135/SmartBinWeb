package com.example.service;

import com.example.repository.AdminRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.text.SimpleDateFormat;
import java.time.*;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class DashboardService {

    @Autowired
    private AdminRepository adminRepository;

    private final SimpleDateFormat dayFormat = new SimpleDateFormat("dd-MM");

    // ---------- helper JSON ----------
    private String toJsonString(List<String> list) {
        return list.stream()
                .map(s -> "\"" + s + "\"")
                .collect(Collectors.joining(",", "[", "]"));
    }

    private String toJsonNumber(List<? extends Number> list) {
        return list.stream()
                .map(n -> n == null ? "0" : n.toString())
                .collect(Collectors.joining(",", "[", "]"));
    }

    // ============ KPI TỔNG ============
    public double getActiveBinPercent() {
        long total = adminRepository.countAllBins();
        if (total == 0) return 0;
        long active = adminRepository.countActiveBins();
        return Math.round(active * 1000.0 / total) / 10.0;
    }

    public double getResolvedReportPercentThisMonth() {
        LocalDate now = LocalDate.now();
        LocalDate firstDay = now.withDayOfMonth(1);
        LocalDate firstDayNextMonth = firstDay.plusMonths(1);

        LocalDateTime start = firstDay.atStartOfDay();
        LocalDateTime end = firstDayNextMonth.atStartOfDay();

        long total = adminRepository.countReportsBetween(start, end);
        if (total == 0) return 0;
        long resolved = adminRepository.countResolvedReportsBetween(start, end);

        return Math.round(resolved * 1000.0 / total) / 10.0;
    }

    public double getAvgRating() {
        Double avg = adminRepository.avgRating();
        if (avg == null) return 0;
        return Math.round(avg * 10.0) / 10.0;
    }

    public long getOpenTasksCount() {
        return adminRepository.countOpenTasks();
    }

    public long getNewReportsToday() {
        LocalDate today = LocalDate.now();
        LocalDate tomorrow = today.plusDays(1);

        LocalDateTime start = today.atStartOfDay();
        LocalDateTime end = tomorrow.atStartOfDay();

        return adminRepository.countReportsBetween(start, end);
    }

    public double getAvgResolveHours() {
        Double hours = adminRepository.avgResolveHours();
        if (hours == null) return 0;
        return Math.round(hours * 10.0) / 10.0;
    }

    public long getOverdueTasksCount() {
        return adminRepository.countOverdueTasks();
    }

    public double getOnTimeTaskPercent() {
        Object[] row = adminRepository.countOnTimeVsTotal();
        if (row == null || row.length < 2) return 0;

        Number onTime = (Number) row[0];
        Number total = (Number) row[1];
        if (total == null || total.longValue() == 0) return 0;

        double percent = onTime.doubleValue() * 100.0 / total.doubleValue();
        return Math.round(percent * 10.0) / 10.0;
    }

    public long getTotalReports() {
        return adminRepository.countAllReports();
    }

    // ============ REPORT CHARTS ============
    public Map<String, Long> getReportCountByStatus() {
        Map<String, Long> map = new LinkedHashMap<>();
        for (Object[] row : adminRepository.countReportsByStatus()) {
            String status = (String) row[0];
            Long cnt = ((Number) row[1]).longValue();
            map.put(status, cnt);
        }
        return map;
    }

    public String buildReportStatusLabelsJson() {
        return toJsonString(new ArrayList<>(getReportCountByStatus().keySet()));
    }

    public String buildReportStatusDataJson() {
        return toJsonNumber(new ArrayList<>(getReportCountByStatus().values()));
    }

    // reports by date (7 ngày gần nhất)
    public Map<String, Long> getReportsByDateLast7Days() {
        LocalDate today = LocalDate.now();
        LocalDate startDay = today.minusDays(6);

        LocalDateTime start = startDay.atStartOfDay();
        LocalDateTime end = today.plusDays(1).atStartOfDay();

        List<Object[]> rows = adminRepository.countReportsByDate(start, end);

        Map<String, Long> map = new LinkedHashMap<>();
        for (int i = 0; i < 7; i++) {
            LocalDate d = startDay.plusDays(i);
            String label = dayFormat.format(Date.from(d.atStartOfDay(ZoneId.systemDefault()).toInstant()));
            map.put(label, 0L);
        }

        for (Object[] row : rows) {
            java.sql.Date d = (java.sql.Date) row[0];
            Long cnt = ((Number) row[1]).longValue();
            LocalDate ld = d.toLocalDate();
            String label = dayFormat.format(Date.from(ld.atStartOfDay(ZoneId.systemDefault()).toInstant()));
            map.put(label, cnt);
        }
        return map;
    }

    public String buildReportTimeLabelsJson() {
        return toJsonString(new ArrayList<>(getReportsByDateLast7Days().keySet()));
    }

    public String buildReportTimeDataJson() {
        return toJsonNumber(new ArrayList<>(getReportsByDateLast7Days().values()));
    }

    public Map<String, Long> getReportsByType() {
        Map<String, Long> map = new LinkedHashMap<>();
        for (Object[] row : adminRepository.countReportsByType()) {
            String type = (String) row[0];
            Long cnt = ((Number) row[1]).longValue();
            map.put(type, cnt);
        }
        return map;
    }

    public String buildReportTypeLabelsJson() {
        return toJsonString(new ArrayList<>(getReportsByType().keySet()));
    }

    public String buildReportTypeDataJson() {
        return toJsonNumber(new ArrayList<>(getReportsByType().values()));
    }

    public String buildReportSlaLabelsJson() {
        List<String> labels = new ArrayList<>();
        for (Object[] row : adminRepository.slaOnTimeVsLate()) {
            labels.add((String) row[0]);
        }
        return toJsonString(labels);
    }

    public String buildReportSlaDataJson() {
        List<Number> values = new ArrayList<>();
        for (Object[] row : adminRepository.slaOnTimeVsLate()) {
            values.add((Number) row[1]);
        }
        return toJsonNumber(values);
    }

    public String buildTopBinsLabelsJson() {
        List<String> labels = new ArrayList<>();
        for (Object[] row : adminRepository.topReportedBins()) {
            labels.add((String) row[0]);
        }
        return toJsonString(labels);
    }

    public String buildTopBinsDataJson() {
        List<Number> values = new ArrayList<>();
        for (Object[] row : adminRepository.topReportedBins()) {
            values.add((Number) row[1]);
        }
        return toJsonNumber(values);
    }

    // ============ TASK CHARTS ============

    public String buildTaskStatusLabelsJson() {
        List<String> labels = new ArrayList<>();
        for (Object[] row : adminRepository.countTasksByStatus()) {
            labels.add((String) row[0]);
        }
        return toJsonString(labels);
    }

    public String buildTaskStatusDataJson() {
        List<Number> values = new ArrayList<>();
        for (Object[] row : adminRepository.countTasksByStatus()) {
            values.add((Number) row[1]);
        }
        return toJsonNumber(values);
    }

    public String buildTaskPriorityLabelsJson() {
        List<String> labels = new ArrayList<>();
        for (Object[] row : adminRepository.countTasksByPriority()) {
            labels.add((String) row[0]);
        }
        return toJsonString(labels);
    }

    public String buildTaskPriorityDataJson() {
        List<Number> values = new ArrayList<>();
        for (Object[] row : adminRepository.countTasksByPriority()) {
            values.add((Number) row[1]);
        }
        return toJsonNumber(values);
    }

    // Task tạo mới theo ngày (7 ngày gần nhất)
    public Map<String, Long> getTaskCreatedByDateLast7Days() {
        LocalDate today = LocalDate.now();
        LocalDate startDay = today.minusDays(6);

        Date start = Date.from(startDay.atStartOfDay(ZoneId.systemDefault()).toInstant());
        Date end = Date.from(today.plusDays(1).atStartOfDay(ZoneId.systemDefault()).toInstant());

        List<Object[]> rows = adminRepository.countTasksCreatedByDate(start, end);

        Map<String, Long> map = new LinkedHashMap<>();
        for (int i = 0; i < 7; i++) {
            LocalDate d = startDay.plusDays(i);
            String label = dayFormat.format(Date.from(d.atStartOfDay(ZoneId.systemDefault()).toInstant()));
            map.put(label, 0L);
        }

        for (Object[] row : rows) {
            java.sql.Date d = (java.sql.Date) row[0];
            Long cnt = ((Number) row[1]).longValue();
            LocalDate ld = d.toLocalDate();
            String label = dayFormat.format(Date.from(ld.atStartOfDay(ZoneId.systemDefault()).toInstant()));
            map.put(label, cnt);
        }
        return map;
    }

    // Task hoàn thành theo ngày
    public Map<String, Long> getTaskCompletedByDateLast7Days() {
        LocalDate today = LocalDate.now();
        LocalDate startDay = today.minusDays(6);

        Date start = Date.from(startDay.atStartOfDay(ZoneId.systemDefault()).toInstant());
        Date end = Date.from(today.plusDays(1).atStartOfDay(ZoneId.systemDefault()).toInstant());

        List<Object[]> rows = adminRepository.countTasksCompletedByDate(start, end);

        Map<String, Long> map = new LinkedHashMap<>();
        for (int i = 0; i < 7; i++) {
            LocalDate d = startDay.plusDays(i);
            String label = dayFormat.format(Date.from(d.atStartOfDay(ZoneId.systemDefault()).toInstant()));
            map.put(label, 0L);
        }

        for (Object[] row : rows) {
            java.sql.Date d = (java.sql.Date) row[0];
            Long cnt = ((Number) row[1]).longValue();
            LocalDate ld = d.toLocalDate();
            String label = dayFormat.format(Date.from(ld.atStartOfDay(ZoneId.systemDefault()).toInstant()));
            map.put(label, cnt);
        }
        return map;
    }

    public String buildTaskTimeLabelsJson() {
        return toJsonString(new ArrayList<>(getTaskCreatedByDateLast7Days().keySet()));
    }

    public String buildTaskCreatedDataJson() {
        return toJsonNumber(new ArrayList<>(getTaskCreatedByDateLast7Days().values()));
    }

    public String buildTaskCompletedDataJson() {
        return toJsonNumber(new ArrayList<>(getTaskCompletedByDateLast7Days().values()));
    }

    public String buildTaskPerformanceLabelsJson() {
        List<String> labels = new ArrayList<>();
        for (Object[] row : adminRepository.taskPerformanceByUser()) {
            labels.add((String) row[0]);
        }
        return toJsonString(labels);
    }

    public String buildTaskPerformanceDataJson() {
        List<Number> values = new ArrayList<>();
        for (Object[] row : adminRepository.taskPerformanceByUser()) {
            values.add((Number) row[1]);
        }
        return toJsonNumber(values);
    }

    public String buildTaskLateByUserLabelsJson() {
        List<String> labels = new ArrayList<>();
        for (Object[] row : adminRepository.lateTasksByUser()) {
            labels.add((String) row[0]);
        }
        return toJsonString(labels);
    }

    public String buildTaskLateByUserDataJson() {
        List<Number> values = new ArrayList<>();
        for (Object[] row : adminRepository.lateTasksByUser()) {
            values.add((Number) row[1]);
        }
        return toJsonNumber(values);
    }
}
