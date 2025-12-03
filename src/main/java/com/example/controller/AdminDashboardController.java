package com.example.controller;

import com.example.service.DashboardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class AdminDashboardController {

    @Autowired
    private DashboardService dashboardService;

    @GetMapping("/admin/analytics")
    public String showAnalyticsDashboard(Model model) {

        // ====== KPI CARD ======
        model.addAttribute("activeBinPercent", dashboardService.getActiveBinPercent());
        model.addAttribute("resolvedReportPercent", dashboardService.getResolvedReportPercentThisMonth());
        model.addAttribute("avgRating", dashboardService.getAvgRating());
        model.addAttribute("openTasksCount", dashboardService.getOpenTasksCount());
        model.addAttribute("newReportsToday", dashboardService.getNewReportsToday());
        model.addAttribute("avgResolveHours", dashboardService.getAvgResolveHours());
        model.addAttribute("overdueTasksCount", dashboardService.getOverdueTasksCount());
        model.addAttribute("onTimeTaskPercent", dashboardService.getOnTimeTaskPercent());
        model.addAttribute("totalReports", dashboardService.getTotalReports());

        // ====== REPORT CHARTS ======
        model.addAttribute("reportStatusLabels", dashboardService.buildReportStatusLabelsJson());
        model.addAttribute("reportStatusData", dashboardService.buildReportStatusDataJson());

        model.addAttribute("reportTimeLabels", dashboardService.buildReportTimeLabelsJson());
        model.addAttribute("reportTimeData", dashboardService.buildReportTimeDataJson());

        model.addAttribute("reportTypeLabels", dashboardService.buildReportTypeLabelsJson());
        model.addAttribute("reportTypeData", dashboardService.buildReportTypeDataJson());

        model.addAttribute("reportSlaLabels", dashboardService.buildReportSlaLabelsJson());
        model.addAttribute("reportSlaData", dashboardService.buildReportSlaDataJson());

        model.addAttribute("topBinsLabels", dashboardService.buildTopBinsLabelsJson());
        model.addAttribute("topBinsData", dashboardService.buildTopBinsDataJson());

        // ====== TASK CHARTS ======
        model.addAttribute("taskStatusLabels", dashboardService.buildTaskStatusLabelsJson());
        model.addAttribute("taskStatusData", dashboardService.buildTaskStatusDataJson());

        model.addAttribute("taskPriorityLabels", dashboardService.buildTaskPriorityLabelsJson());
        model.addAttribute("taskPriorityData", dashboardService.buildTaskPriorityDataJson());

        model.addAttribute("taskTimeLabels", dashboardService.buildTaskTimeLabelsJson());
        model.addAttribute("taskCreatedData", dashboardService.buildTaskCreatedDataJson());
        model.addAttribute("taskCompletedData", dashboardService.buildTaskCompletedDataJson());

        model.addAttribute("taskPerfLabels", dashboardService.buildTaskPerformanceLabelsJson());
        model.addAttribute("taskPerfData", dashboardService.buildTaskPerformanceDataJson());

        model.addAttribute("taskLateUserLabels", dashboardService.buildTaskLateByUserLabelsJson());
        model.addAttribute("taskLateUserData", dashboardService.buildTaskLateByUserDataJson());

        // ⭐ TRẢ VỀ JSP MỚI
        return "admin/admin-report-task-dashboard";
    }
}
