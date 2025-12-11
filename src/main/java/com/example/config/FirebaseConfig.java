package com.example.config;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import org.springframework.context.annotation.Configuration;

import javax.annotation.PostConstruct;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;

@Configuration
public class FirebaseConfig {

    // JSON khi chạy SERVER (file mount từ docker-compose)
    private static final String SERVER_JSON_PATH = "/usr/local/tomcat/firebase.json";

    // JSON khi chạy LOCAL (trong resources)
    private static final String LOCAL_RESOURCE_JSON = "smartbin-80c9f-60ba8974817a.json";

    @PostConstruct
    public void init() {
        try {

            // Nếu Firebase đã khởi tạo → bỏ qua
            if (!FirebaseApp.getApps().isEmpty()) {
                System.out.println("Firebase already initialized → SKIP");
                return;
            }

            InputStream serviceAccount = loadFirebaseCredentials();

            FirebaseOptions options = FirebaseOptions.builder()
                    .setCredentials(GoogleCredentials.fromStream(serviceAccount))
                    .build();

            FirebaseApp.initializeApp(options);
            System.out.println("⭐ Firebase initialized successfully!");

        } catch (Exception e) {
            System.err.println("❌ Firebase initialization failed!");
            e.printStackTrace();
        }
    }

    /**
     * Ưu tiên sử dụng JSON theo thứ tự:
     * 1. File mount trong container (SERVER)
     * 2. File trong resources (LOCAL)
     */
    private InputStream loadFirebaseCredentials() throws Exception {

        // ============================
        // 1) SERVER MODE (Docker)
        // ============================
        File serverFile = new File(SERVER_JSON_PATH);

        if (serverFile.exists()) {
            System.out.println("Using Firebase credentials from SERVER: " + SERVER_JSON_PATH);
            return new FileInputStream(serverFile);
        }

        // ============================
        // 2) LOCAL MODE (resources)
        // ============================
        System.out.println("Using Firebase credentials from LOCAL resources: " + LOCAL_RESOURCE_JSON);

        InputStream resourceStream =
                getClass().getClassLoader().getResourceAsStream(LOCAL_RESOURCE_JSON);

        if (resourceStream == null) {
            throw new RuntimeException("ERROR: Firebase JSON NOT FOUND in resources!");
        }

        return resourceStream;
    }
}
