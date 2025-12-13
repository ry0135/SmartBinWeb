package com.example.service;
import com.example.model.Notification;
import com.example.model.Task;
import com.example.repository.NotificationRepository;
import com.example.repository.TasksRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;

@Service
public class TaskOpenSchedulerService {

    @Autowired
    private TasksRepository taskRepository;

    @Autowired
    private NotificationRepository notificationRepository;

    @Autowired
    private AccountService accountService;

    @Autowired
    private FcmService fcmService;

    // chạy mỗi 5 phút
    @Scheduled(fixedRate = 5 * 60 * 1000)
    public void handleOpenTasksNotAccepted() {

        List<Task> tasks = taskRepository.findOpenAssignedTasks();
        Date now = new Date();

        for (Task task : tasks) {

            Date createdAt = task.getCreatedAt();
            if (createdAt == null) continue;

            long diffMillis = now.getTime() - createdAt.getTime();
            long diffHours = diffMillis / (1000 * 60 * 60);

            int workerId = task.getAssignedTo().getAccountId();

            // 🔔 Nhắc nhở sau 1 giờ (chỉ 1 lần)
            if (diffHours >= 1 && diffHours < 3) {
                if (!hasReminderSent(workerId)) {
                    sendReminder(task, workerId);
                }
            }

            // ❗ ISSUE sau 3 giờ
            if (diffHours >= 3) {
                task.setStatus("ISSUE");
                task.setIssueReason("Nhân viên không nhận nhiệm vụ");
                taskRepository.save(task);
            }
        }
    }

    // ===== helper methods =====

    private boolean hasReminderSent(int workerId) {
        return notificationRepository
                .existsByReceiverIdAndType(workerId, "TASK_REMINDER");
    }

    private void sendReminder(Task task, int workerId) {

        Notification noti = new Notification();
        noti.setReceiverId(workerId);
        noti.setTitle("Nhắc nhở nhận nhiệm vụ");
        noti.setMessage("Vui lòng nhận nhiệm vụ được giao.");
        noti.setType("TASK_REMINDER");
        noti.setRead(false);
        noti.setCreatedAt(LocalDateTime.now());

        notificationRepository.save(noti);

        String token = accountService.getFcmTokenByWorkerId(workerId);
        if (token != null && !token.isEmpty()) {
            fcmService.sendNotification(
                    token,
                    "Nhắc nhở nhiệm vụ",
                    "Bạn có nhiệm vụ chưa nhận",
                    task.getBatchId()
            );
        }
    }
}
