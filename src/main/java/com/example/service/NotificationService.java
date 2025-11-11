package com.example.service;

import com.example.model.Notification;
import com.example.repository.NotificationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class NotificationService {

    @Autowired
    private  NotificationRepository notificationRepository;


    public List<Notification> getNotificationsByReceiverId(Integer accountId) {
        return notificationRepository.findByReceiverIdOrderByCreatedAtDesc(accountId);
    }

    public Notification createNotification(Notification notification) {
        if (notification.getCreatedAt() == null) {
            notification.setCreatedAt(LocalDateTime.now());
        }
        return notificationRepository.save(notification);
    }
    public void markAsRead(Integer notificationId) {
        Optional<Notification> optional = notificationRepository.findById(notificationId);
        if (optional.isPresent()) {
            Notification n = optional.get();
            n.setRead(true);
            notificationRepository.save(n);
        }
    }
    public int getUnreadCount(Integer receiverId) {
        return notificationRepository.countUnreadByUserId(receiverId);
    }
}
