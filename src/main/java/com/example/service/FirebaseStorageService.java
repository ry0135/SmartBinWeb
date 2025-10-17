package com.example.service;

import com.google.firebase.cloud.StorageClient;
import com.google.cloud.storage.Blob;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.UUID;

@Service
public class FirebaseStorageService {

    //  Upload file lên Firebase Storage
    public String uploadFile(MultipartFile file, String folder) throws IOException {
        if (file.isEmpty()) {
            throw new IOException("File rỗng!");
        }

        String fileName = folder + "/" + UUID.randomUUID() + "_" + file.getOriginalFilename();

        Blob blob = StorageClient.getInstance()
                .bucket()
                .create(fileName, file.getBytes(), file.getContentType());

        // 🔗 Trả về link public để app Android hiển thị
        return String.format(
                "https://firebasestorage.googleapis.com/v0/b/%s/o/%s?alt=media",
                blob.getBucket(),
                fileName.replace("/", "%2F")
        );
    }
}
