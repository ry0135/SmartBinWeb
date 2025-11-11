package com.example.controller.ai;

import com.example.service.AIPredictService;
import com.example.service.BinCacheService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;

public class BinLogController {

    @Autowired
    private BinCacheService binCacheService;

    @Autowired
    private AIPredictService aiService;

    @Scheduled(cron = "0 0 0 * * *")
    public void autoTrainAndCleanup() {
        System.out.println("🕛 [CRON] Bắt đầu dọn dữ liệu và huấn luyện AI...");

        // 1️⃣ Dọn log cũ 15 ngày
        binCacheService.cleanOldLogs();

        // 2️⃣ Gọi AI train
        aiService.trainNow();

        System.out.println("✅ [CRON] Đã hoàn tất quá trình huấn luyện & dọn dữ liệu!");
    }
}
