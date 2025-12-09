package com.example.service;

import com.example.dto.PushSubscriptionDTO;
import com.example.model.Report;
import com.google.gson.Gson;
import nl.martijndwars.webpush.Notification;
import nl.martijndwars.webpush.PushService;
import nl.martijndwars.webpush.Subscription;
import org.apache.http.HttpResponse;
import org.springframework.stereotype.Service;

import java.security.GeneralSecurityException;
import java.util.ArrayList;
import java.util.List;

@Service
public class PushNotificationService {

    // TODO: THAY BẰNG VAPID KEY THẬT CỦA BẠN
    private static final String PUBLIC_KEY  = "BJh5SgbkU-DlWB6JgcM_g6yZbCx7QoF1ztnxoMwr9Nk4B7CbTFW64zr94jV-wnlqciLrD59VEzokmeDpTdrATAw";
    private static final String PRIVATE_KEY = "UiYY4gYbM5DjtL4BI6J1F1NbG-gRuN0XTd79g0wER_c";

    // demo: lưu trong RAM (nếu muốn xịn hơn có thể lưu DB sau)
    private final List<PushSubscriptionDTO> subscriptions = new ArrayList<>();
    private final Gson gson = new Gson();

    public synchronized void addSubscription(PushSubscriptionDTO dto) {
        // tránh trùng endpoint
        boolean exists = subscriptions.stream()
                .anyMatch(s -> s.getEndpoint().equals(dto.getEndpoint()));
        if (!exists) {
            subscriptions.add(dto);
            System.out.println("✅ New Web Push subscription: " + dto.getEndpoint());
        }
    }

    public void sendReportNotification(Report report) {
        String title = "Báo cáo mới từ SmartBin";
        String body  = "Thùng " + report.getBin().getBinCode()
                + " vừa có báo cáo mới (ID: " + report.getReportId() + ")";

        sendToAll(title, body);
    }

    public void sendToAll(String title, String body) {
        if (subscriptions.isEmpty()) {
            System.out.println("⚠️ No subscription to send push.");
            return;
        }

        try {
            PushService pushService = new PushService(PUBLIC_KEY, PRIVATE_KEY, "mailto:admin@smartbin.vn");

            // payload gửi xuống service-worker
            String payload = gson.toJson(new PushPayload(title, body));

            for (PushSubscriptionDTO dto : subscriptions) {
                try {
                    Subscription.Keys keys = new Subscription.Keys(
                            dto.getKeys().get("p256dh"),
                            dto.getKeys().get("auth")
                    );
                    Subscription sub = new Subscription(
                            dto.getEndpoint(),
                            keys
                    );

                    Notification notification = new Notification(sub, payload);
                    HttpResponse response = pushService.send(notification);

                    System.out.println("📤 Push sent to: " + dto.getEndpoint()
                            + ", status = " + response.getStatusLine());
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

        } catch (GeneralSecurityException e) {
            e.printStackTrace();
        }
    }

    // Class con cho payload JSON
    private static class PushPayload {
        String title;
        String message;

        public PushPayload(String title, String message) {
            this.title = title;
            this.message = message;
        }
    }
}
