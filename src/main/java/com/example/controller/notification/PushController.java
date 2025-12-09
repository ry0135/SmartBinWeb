package com.example.controller.notification;


import com.example.dto.PushSubscriptionDTO;
import com.example.service.PushNotificationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/push")
public class PushController {

    @Autowired
    private PushNotificationService pushNotificationService;

    @PostMapping("/subscribe")
    public ResponseEntity<Void> subscribe(@RequestBody PushSubscriptionDTO dto) {
        pushNotificationService.addSubscription(dto);
        return ResponseEntity.ok().build();
    }

    // Test manual (nếu muốn)
    @PostMapping("/test")
    public ResponseEntity<Void> testPush(
            @RequestParam String title,
            @RequestParam String body) {

        pushNotificationService.sendToAll(title, body);
        return ResponseEntity.ok().build();
    }
}

