package com.example.service;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;

@Service
public class FileStorageService {

    // Thư mục gốc lưu upload (đổi theo máy bạn)
    private static final String ROOT_UPLOAD_DIR = "C:/smartbin-uploads"; // Windows ví dụ
    // Linux: "/var/smartbin/uploads"

    // Cho phép các đuôi file này
    private static final Set<String> ALLOWED_EXT = new HashSet<>(Arrays.asList(
            ".pdf", ".jpg", ".jpeg", ".png"
    ));

    // Giới hạn dung lượng 15MB / file
    private static final long MAX_FILE_SIZE = 15L * 1024 * 1024; // 15MB

    /**
     * Lưu file vào thư mục con (vd: "contracts", "idcards") và trả về path lưu trong DB
     * Ví dụ trả về: /uploads/contracts/xxxx.pdf
     */
    public String save(MultipartFile file, String subFolder) {
        if (file == null || file.isEmpty()) return null;

        // 1) Kiểm tra dung lượng
        if (file.getSize() > MAX_FILE_SIZE) {
            throw new IllegalArgumentException("File vượt quá 15MB");
        }

        // 2) Kiểm tra phần mở rộng
        String original = file.getOriginalFilename();
        String ext = (original != null && original.lastIndexOf('.') >= 0)
                ? original.substring(original.lastIndexOf('.')).toLowerCase()
                : "";
        if (!ALLOWED_EXT.contains(ext)) {
            throw new IllegalArgumentException("Định dạng không hợp lệ (chỉ .pdf, .jpg, .jpeg, .png)");
        }

        try {
            // 3) Tạo thư mục đích nếu chưa có
            String folder = ROOT_UPLOAD_DIR + "/" + (subFolder == null ? "" : subFolder);
            Files.createDirectories(Paths.get(folder));

            // 4) Tạo tên file ngẫu nhiên, giữ nguyên phần mở rộng
            String savedName = UUID.randomUUID().toString().replace("-", "") + ext;

            // 5) Lưu file vật lý
            File dest = new File(folder, savedName);
            file.transferTo(dest);

            // 6) Trả về đường dẫn lưu trong DB (relative path, sẽ dùng controller để tải)
            return "/uploads/" + (subFolder == null ? "" : (subFolder + "/")) + savedName;

        } catch (Exception e) {
            e.printStackTrace();
            throw new IllegalStateException("Không thể lưu file. Vui lòng thử lại.");
        }
    }
}
