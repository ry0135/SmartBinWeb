package com.example.config;

import com.example.model.Bin;
import com.example.model.BinLog;
import com.example.repository.BinLogRepository;
import com.example.repository.BinRepository;
import com.example.service.BinCacheService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.Date;
import java.util.List;
import java.util.Map;

@Configuration
@EnableScheduling
public class SchedulerConfig {


    @Autowired
    private BinRepository binRepo;

    @Autowired
    private BinLogRepository binLogRepository;
    @Autowired
    private BinRepository binRepository;
    @Autowired
    private BinCacheService cacheService;

    // Chạy mỗi 10 phút
    @Scheduled(fixedRate = 600000)
    public void saveBinLogs() {
        List<Bin> bins = binRepository.findAll();

        for (Bin bin : bins) {
            try {
                // Lấy log gần nhất của thùng
                BinLog lastLog = binLogRepository.findTopByBinIdOrderByRecordedAtDesc(bin.getBinID());

                double currentFill = bin.getCurrentFill();
                boolean shouldSave = false;


                if (lastLog == null) {
                    //  Nếu chưa có log nào → lưu luôn lần đầu
                    shouldSave = true;
                } else {
                    double lastFill = lastLog.getCurrentFill();
                    double diff = Math.abs(currentFill - lastFill);

                    if (diff >= 10) {
                        //  Nếu thay đổi >=10% → cần lưu log mới
                        shouldSave = true;
                    }
                }
                if (shouldSave) {
                    BinLog newLog = new BinLog();
                    newLog.setBinId(bin.getBinID());
                    newLog.setCurrentFill(currentFill);
                    newLog.setRecordedAt(LocalDateTime.now());
                    binLogRepository.save(newLog);

                    System.out.println("🧾 Đã lưu log BinID " + bin.getBinID() +
                            " - Fill: " + currentFill + "% (" + new Date() + ")");
                }

            } catch (Exception e) {
                System.err.println("⚠️ Lỗi khi lưu log BinID " + bin.getBinID() + ": " + e.getMessage());
            }
        }

        System.out.println("✅ Hoàn thành lưu log tự động lúc: " + new Date());
    }
}

