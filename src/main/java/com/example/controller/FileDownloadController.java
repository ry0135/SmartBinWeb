package com.example.controller;

import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.io.File;

@Controller
@RequestMapping("/uploads")
public class FileDownloadController {

    // Cùng path với FileStorageService
    private static final String ROOT_UPLOAD_DIR = "C:/smartbin-uploads";

    @GetMapping("/{subFolder}/{fileName:.+}")
    @ResponseBody
    public ResponseEntity<Resource> downloadFile(
            @PathVariable String subFolder,
            @PathVariable String fileName
    ) {
        File file = new File(ROOT_UPLOAD_DIR + "/" + subFolder + "/" + fileName);
        if (!file.exists()) {
            return ResponseEntity.notFound().build();
        }

        Resource resource = new FileSystemResource(file);

        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION,
                        "attachment; filename=\"" + fileName + "\"")
                .body(resource);
    }
}
