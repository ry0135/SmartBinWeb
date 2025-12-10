package com.example.config;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import org.springframework.context.annotation.Configuration;

import javax.annotation.PostConstruct;
import java.io.*;
import java.util.Base64;

@Configuration
public class FirebaseConfig {

    // 1. Đường dẫn file thật trên server (EC2)
    private static final String SERVER_JSON_PATH = "/home/ubuntu/firebase.json";

    // 2. Tên file JSON local lưu trong resources
    private static final String LOCAL_RESOURCE_JSON = "smartbin-80c9f-60ba8974817a.json";

    // 3. Tên ENV lưu chuỗi Base64
    private static final String ENV_NAME = "FIREBASE_B64";

    @PostConstruct
    public void init() {

        try {
            if (!FirebaseApp.getApps().isEmpty()) {
                System.out.println("FirebaseApp already initialized → SKIP");
                return;
            }

            InputStream firebaseStream = loadFirebaseCredentials();

            FirebaseOptions options = FirebaseOptions.builder()
                    .setCredentials(GoogleCredentials.fromStream(firebaseStream))
                    .build();

            FirebaseApp.initializeApp(options);

            System.out.println("⭐ Firebase initialized successfully!");

        } catch (Exception e) {
            System.err.println("❌ Firebase initialization failed!");
            e.printStackTrace();
        }
    }

    /**
     * Tự động chọn nguồn JSON theo thứ tự:
     * 1) ENV FIREBASE_B64
     * 2) File server /home/ubuntu/firebase.json
     * 3) File local firebase-local.json (trong resources)
     */
    private InputStream loadFirebaseCredentials() throws Exception {

        // ======================
        // 1) LOAD TỪ ENV BASE64
        // ======================
        String firebaseBase64 = System.getenv(ENV_NAME);
        if (firebaseBase64 != null && !firebaseBase64.isBlank()) {
            System.out.println("Using Firebase credentials from ENV FIREBASE_B64");

            byte[] decoded = Base64.getDecoder().decode(firebaseBase64);
            return new ByteArrayInputStream(decoded);
        }

        // ======================
        // 2) LOAD FILE TRÊN SERVER
        // ======================
        File serverFile = new File(SERVER_JSON_PATH);

        if (serverFile.exists()) {
            System.out.println("Using Firebase credentials from server file: " + SERVER_JSON_PATH);
            return new FileInputStream(serverFile);
        }

        // ======================
        // 3) LOAD FILE LOCAL (resources)
        // ======================
        System.out.println("Using Firebase credentials from resources: " + LOCAL_RESOURCE_JSON);

        InputStream resourceStream =
                getClass().getClassLoader().getResourceAsStream(LOCAL_RESOURCE_JSON);

        if (resourceStream == null) {
            throw new FileNotFoundException(
                    "firebase-local.json NOT FOUND in resources — please create file!");
        }

        return resourceStream;
    }
}
