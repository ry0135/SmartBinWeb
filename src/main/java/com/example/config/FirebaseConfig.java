//package com.example.config;
//
//import com.google.auth.oauth2.GoogleCredentials;
//import com.google.firebase.FirebaseApp;
//import com.google.firebase.FirebaseOptions;
//import javax.annotation.PostConstruct;
//import org.springframework.context.annotation.Configuration;
//
//import java.io.IOException;
//import java.io.InputStream;
//
//@Configuration
//public class FirebaseConfig {
//
//    @PostConstruct
//    public void init() throws IOException {
//        if (FirebaseApp.getApps().isEmpty()) {
//            // load file từ resources
//            InputStream serviceAccount = getClass().getClassLoader()
//                    .getResourceAsStream("smartbin-80c9f-60ba8974817a.json");
//
//            FirebaseOptions options = FirebaseOptions.builder()
//                    .setCredentials(GoogleCredentials.fromStream(serviceAccount))
//                    .build();
//
//            FirebaseApp.initializeApp(options);
//            System.out.println("✅ Firebase Admin SDK initialized");
//        }
//    }
//}
