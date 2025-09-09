package com.example.service;


import com.example.model.Bin;
import com.example.repository.BinRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.scheduling.annotation.Scheduled;
import java.util.concurrent.TimeUnit;

import java.util.Date;
import java.util.List;

@Service
public class BinService {

    @Autowired

    private BinRepository binRepository;


    public Bin saveOrUpdateBin(Bin bin) {
        // Nếu muốn update theo binCode
        Bin existing = binRepository.findByBinCode(bin.getBinCode());

        if (existing == null) {
            // chưa có thì tạo mới
            bin.setCapacity(bin.getCapacity() == 0 ? 50.0 : bin.getCapacity());
            return binRepository.save(bin);
        } else {
            // có rồi thì cập nhật
            existing.setLatitude(bin.getLatitude());
            existing.setLongitude(bin.getLongitude());
            existing.setCurrentFill(bin.getCurrentFill());
            existing.setStatus(bin.getStatus());
            existing.setStreet(bin.getStreet());
            existing.setWard(bin.getWard());
            existing.setCity(bin.getCity());
            existing.setLastUpdated(new Date());

            return binRepository.save(existing);
        }
    }
    @Scheduled(fixedRate = 60000) // chạy mỗi 60 giây
    public void checkInactiveBins() {
        List<Bin> allBins = binRepository.findAll();
        long now = System.currentTimeMillis();

        for (Bin bin : allBins) {
            long last = bin.getLastUpdated().getTime();
            long diffMinutes = TimeUnit.MILLISECONDS.toMinutes(now - last);

            // Nếu quá 2 phút chưa gửi → coi như mất kết nối
            if (diffMinutes >= 2 && bin.getStatus() != 2) {
                bin.setStatus(2); // 2 = mất kết nối
                binRepository.save(bin);
                System.out.println("[CHECKER] Bin " + bin.getBinCode() + " mất kết nối!");
            }
        }
    }
    // 👉 Hàm mới để lấy toàn bộ danh sách thùng rác
    public List<Bin> getAllBins() {
        return binRepository.findAll();
    }
    public Bin getBinById(int id) {
        return binRepository.findById(id).orElse(null);
    }


    public Bin saveBin(Bin bin) {
        return binRepository.save(bin);
    }

    public void deleteBin(int id) {
        binRepository.deleteById(id);
    }
}


