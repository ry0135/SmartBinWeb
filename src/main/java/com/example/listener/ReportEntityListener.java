package com.example.listener;

import com.example.model.Report;
import com.example.service.PushNotificationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Component;

import javax.persistence.*;

@Component
public class ReportEntityListener {

    private static SimpMessagingTemplate messagingTemplate;
    private static PushNotificationService pushNotificationService;

    @Autowired
    public void init(SimpMessagingTemplate template,
                     PushNotificationService pushService) {
        ReportEntityListener.messagingTemplate = template;
        ReportEntityListener.pushNotificationService = pushService;
    }

    @PostPersist
    @PostUpdate
    public void afterSave(Report report) {

        if (messagingTemplate != null) {
            messagingTemplate.convertAndSend("/topic/report-updates", report);
            System.out.println("📡 [WebSocket] Report updated → ID = " + report.getReportId());
        }

        if (pushNotificationService != null) {
            pushNotificationService.sendReportNotification(report);
        }
    }

    @PostRemove
    public void afterDelete(Report report) {
        if (messagingTemplate != null) {
            messagingTemplate.convertAndSend("/topic/report-removed", report);
            System.out.println("🗑 [WebSocket] Report removed → ID = " + report.getReportId());
        }
        // Xoá report thì thường không cần push, có thể bỏ qua
    }
}
