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

    // Sử dụng JOIN FETCH để lấy tất cả dữ liệu
    public List<Bin> getAllBins() {
        return binRepository.findAllWithWardAndProvince();
    }

    // Sử dụng JOIN FETCH để lấy bin theo ID với đầy đủ thông tin
    public Bin getBinById(int id) {
        return binRepository.findByIdWithWardAndProvince(id).orElse(null);
    }

    // Các phương thức khác giữ nguyên...
    public Bin saveOrUpdateBin(Bin bin) {
        Bin existing = binRepository.findByBinCode(bin.getBinCode());
        if (existing == null) {
            bin.setCapacity(bin.getCapacity() == 0 ? 50.0 : bin.getCapacity());
            return binRepository.save(bin);
        } else {
            existing.setLatitude(bin.getLatitude());
            existing.setLongitude(bin.getLongitude());
            existing.setCurrentFill(bin.getCurrentFill());
            existing.setStatus(bin.getStatus());
            existing.setStreet(bin.getStreet());
            existing.setWardID(bin.getWardID());
            existing.setLastUpdated(new Date());
            return binRepository.save(existing);
        }
    }
    public void deleteBin(int id) {
        Bin bin = binRepository.findById(id).orElse(null);
        if (bin != null) {
            binRepository.delete(bin);
        }
    }


//    @Scheduled(fixedRate = 60000)
//    public void checkInactiveBins() {
//        List<Bin> allBins = binRepository.findAll();
//        long now = System.currentTimeMillis();
//        for (Bin bin : allBins) {
//            long last = bin.getLastUpdated().getTime();
//            long diffMinutes = TimeUnit.MILLISECONDS.toMinutes(now - last);
//            if (diffMinutes >= 2 && bin.getStatus() != 2) {
//                bin.setStatus(2);
//                binRepository.save(bin);
//                System.out.println("[CHECKER] Bin " + bin.getBinCode() + " mất kết nối!");
//            }
//        }
//    }

}