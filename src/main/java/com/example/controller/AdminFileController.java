package com.example.controller;

import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.io.File;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.file.Path;
import java.nio.file.Paths;

@Controller
@RequestMapping("/admin/uploads")
public class AdminFileController {

    private static final String ROOT_UPLOAD_DIR = "C:/smartbin-uploads";

    @GetMapping("/download")
    public ResponseEntity<Resource> download(@RequestParam("path") String path) {
        if (!StringUtils.hasText(path)) return ResponseEntity.badRequest().build();

        String clean = path.replace("\\", "/");
        if (!clean.startsWith("/uploads/")) return ResponseEntity.badRequest().build();

        String relative = clean.replaceFirst("^/uploads/", "");
        Path filePath = Paths.get(ROOT_UPLOAD_DIR, relative).normalize();
        File file = filePath.toFile();
        if (!file.exists() || !file.isFile()) return ResponseEntity.notFound().build();

        String filename = file.getName();

        // encode tên file về RFC5987 (filename*)
        String encoded;
        try {
            encoded = URLEncoder.encode(filename, "UTF-8").replace("+", "%20");
        } catch (UnsupportedEncodingException e) {
            // Java 8 luôn có UTF-8, nhưng fallback để tránh compile error
            encoded = filename;
        }

        Resource resource = new FileSystemResource(file);

        MediaType type = MediaType.APPLICATION_OCTET_STREAM;
        if (filename.toLowerCase().endsWith(".pdf")) type = MediaType.APPLICATION_PDF;

        return ResponseEntity.ok()
                .contentType(type)
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename*=UTF-8''" + encoded)
                .body(resource);
    }
}
