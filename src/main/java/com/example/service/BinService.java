package com.example.service;

import com.example.model.Bin;
import com.example.repository.BinRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.Date;
import java.util.List;
import java.util.ArrayList;
import java.util.Comparator;

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
>


    // Tìm thùng rác gần nhất theo bán kính (km) và giới hạn số lượng
    public List<Bin> getNearbyBins(double latitude, double longitude, double radiusKm, int limit) {
        List<Bin> all = binRepository.findAllWithWardAndProvince();
        List<Bin> within = new ArrayList<>();

        for (Bin bin : all) {
            double distance = haversineKm(latitude, longitude, bin.getLatitude(), bin.getLongitude());
            if (distance <= radiusKm) {
                within.add(bin);
            }
        }

        within.sort(Comparator.comparingDouble(b -> haversineKm(latitude, longitude, b.getLatitude(), b.getLongitude())));

        if (limit > 0 && within.size() > limit) {
            return new ArrayList<>(within.subList(0, limit));
        }
        return within;
    }

    private double haversineKm(double lat1, double lon1, double lat2, double lon2) {
        final double R = 6371.0; // Earth radius (km)
        double dLat = Math.toRadians(lat2 - lat1);
        double dLon = Math.toRadians(lon2 - lon1);
        double a = Math.sin(dLat / 2) * Math.sin(dLat / 2)
                + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2))
                * Math.sin(dLon / 2) * Math.sin(dLon / 2);
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        return R * c;
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