package com.example.service;

import com.google.cloud.storage.Blob;
import com.google.cloud.storage.Bucket;
import com.google.firebase.FirebaseApp;
import com.google.firebase.cloud.StorageClient;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@Service
public class FirebaseStorageService {


    //  Upload file lên Firebase Storage
    public String uploadFile(MultipartFile file, String folder) throws IOException {
        try {
            // ✅ KIỂM TRA FIREBASE ĐÃ INIT CHƯA
            if (FirebaseApp.getApps().isEmpty()) {
                throw new RuntimeException("Firebase chưa được khởi tạo");
            }

            // Lấy bucket
            Bucket bucket = StorageClient.getInstance().bucket();
            System.out.println("📦 Using bucket: " + bucket.getName());

            // Tạo tên file
            String fileName = folder + "/" + System.currentTimeMillis() + "_" + file.getOriginalFilename();

            // Upload file
            Blob blob = bucket.create(fileName, file.getBytes(), file.getContentType());

            // Tạo URL
            String downloadUrl = String.format(
                    "https://firebasestorage.googleapis.com/v0/b/%s/o/%s?alt=media",
                    bucket.getName(),
                    java.net.URLEncoder.encode(fileName, "UTF-8").replace("+", "%20")
            );

            System.out.println("✅ File uploaded: " + downloadUrl);
            return downloadUrl;

        } catch (Exception e) {
            System.err.println("❌ Firebase upload error: " + e.getMessage());
            throw new IOException("Lỗi upload Firebase: " + e.getMessage(), e);
        }
    }
}
