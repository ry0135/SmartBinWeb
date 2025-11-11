package com.example.controller.app;


import com.example.model.Notification;
import com.example.service.NotificationService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/notifications")
@RequiredArgsConstructor
@CrossOrigin(origins = "*") // Cho phép Android truy cập
public class NotificationAppController {

    private final NotificationService notificationService;

    @GetMapping("/received/{receiverId}")
    public ResponseEntity<List<Notification>> getNotificationsByAccount(@PathVariable Integer receiverId) {
        List<Notification> list = notificationService.getNotificationsByReceiverId(receiverId);
        return ResponseEntity.ok(list);
    }



    @PostMapping
    public ResponseEntity<Notification> createNotification(@RequestBody Notification notification) {
        Notification saved = notificationService.createNotification(notification);
        return ResponseEntity.ok(saved);
    }

    @PutMapping("/{id}/read")
    public ResponseEntity<Void> markAsRead(@PathVariable Integer id) {
        notificationService.markAsRead(id);
        return ResponseEntity.noContent().build();
    }
    @GetMapping("/unreadCount")
    public ResponseEntity<Integer> getUnreadCount(@RequestParam Integer receiverId) {
        int count = notificationService.getUnreadCount(receiverId);
        return ResponseEntity.ok(count);
    }
}
