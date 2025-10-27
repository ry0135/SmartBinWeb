package com.example.controller.app;

import com.example.service.AccountService;
import com.example.service.FcmService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/notify")
public class NotificationController {
    @Autowired
    private final FcmService fcmService;
    @Autowired
    private final AccountService accountService;

    public NotificationController(FcmService fcmService, AccountService accountService) {
        this.fcmService = fcmService;
        this.accountService = accountService;
    }

//    @PostMapping("/send")
//    public ResponseEntity<?> sendNotification(@RequestBody Map<String, String> payload) {
//        try {
//            int workerId = Integer.parseInt(payload.get("workerId"));
//            String title = payload.getOrDefault("title", "Thông báo mới");
//            String body = payload.getOrDefault("body", "Bạn có nhiệm vụ mới");
//
//            String token = accountService.getFcmTokenByWorkerId(workerId);
//            if (token == null || token.isEmpty()) {
//                Map<String, Object> errorResponse = new HashMap<>();
//                errorResponse.put("status", "error");
//                errorResponse.put("message", "Worker chưa có token");
//                return ResponseEntity.badRequest().body(errorResponse);
//            }
//
//            String responseId = fcmService.sendNotification(token, title, body);
//
//            Map<String, Object> successResponse = new HashMap<>();
//            successResponse.put("status", "success");
//            successResponse.put("messageId", responseId);
//
//            return ResponseEntity.ok(successResponse);
//        } catch (Exception e) {
//            Map<String, Object> errorResponse = new HashMap<>();
//            errorResponse.put("status", "error");
//            errorResponse.put("message", e.getMessage());
//            return ResponseEntity.internalServerError().body(errorResponse);
//        }
//    }

}


