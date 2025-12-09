package com.example.controller.notification;

import com.example.model.Report;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;

@Controller
public class ReportWebSocketController {
    @MessageMapping("/report/new")   // Android gửi vào /app/report/new
    @SendTo("/topic/report-updates") // web sẽ nhận tại /topic/report-updates
    public Report handleNewReport(Report report) {
        System.out.println("📩 Received from Android WS: " + report.getReportId());
        return report; // broadcast to all subscribers
    }
}
