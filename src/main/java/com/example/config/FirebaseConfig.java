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

    private static final String SERVER_PATH = "/home/ubuntu/firebase.json";

    @PostConstruct
    public void init() {

        try {
            if (!FirebaseApp.getApps().isEmpty()) {
                System.out.println("Firebase already initialized!");
                return;
            }

            InputStream serviceAccount;

            // CASE 1: SERVER — dùng file ngoài
            if (new File(SERVER_PATH).exists()) {
                System.out.println("Loading Firebase JSON from server path: " + SERVER_PATH);
                serviceAccount = new FileInputStream(SERVER_PATH);
            }
            // CASE 2: LOCAL — load từ resources
            else {
                System.out.println("Loading Firebase JSON from classpath (resources)");
                serviceAccount = getClass()
                        .getClassLoader()
                        .getResourceAsStream("smartbin-80c9f-60ba8974817a.json");

                if (serviceAccount == null) {
                    throw new RuntimeException("FIREBASE JSON NOT FOUND IN RESOURCES!");
                }
            }

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
}
