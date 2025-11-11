package com.example.service;

import com.example.repository.BinLogRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.concurrent.ConcurrentHashMap;
import java.util.Map;

@Service
public class BinCacheService {

    @Autowired
    private BinLogRepository binLogRepository;

    private final Map<Integer, Double> binCache = new ConcurrentHashMap<>();

    public void updateBin(int binId, double currentFill) {
        binCache.put(binId, currentFill);
    }

    public Map<Integer, Double> getCache() {
        return binCache;
    }

    public void cleanOldLogs() {
        int deleted = binLogRepository.deleteOldLogs();
        System.out.println("🧹 Đã xóa " + deleted + " log cũ hơn 15 ngày khỏi tblBinLog.");
    }
}
