package com.example.listener;

import com.example.model.Report;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Component;

import javax.persistence.*;

@Component
public class ReportEntityListener {

    private static SimpMessagingTemplate messagingTemplate;

    @Autowired
    public void init(SimpMessagingTemplate template) {
        ReportEntityListener.messagingTemplate = template;
    }

    // ================= EVENTS =================

    @PostPersist     // Khi tạo mới Report
    @PostUpdate     // Khi cập nhật Report
    public void afterSave(Report report) {

        if (messagingTemplate != null) {

            messagingTemplate.convertAndSend("/topic/report-updates", report);

            System.out.println("📡 [WebSocket] Report updated → ID = " + report.getReportId());
        }
    }

    @PostRemove
    public void afterDelete(Report report) {

        if (messagingTemplate != null) {

            messagingTemplate.convertAndSend("/topic/report-removed", report);

            System.out.println("🗑 [WebSocket] Report removed → ID = " + report.getReportId());
        }
    }
}
