package com.example.service;

import com.example.model.Bin;
import com.example.repository.BinRepository;
import com.example.repository.WardRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.*;

@Service
public class BinService {

    @Autowired
    private BinRepository binRepository;

    @Autowired
    private WardRepository wardRepository;

    // ================== Helpers ==================
    /** Tạo mã tạm để thỏa NOT NULL + UNIQUE trước khi insert */
    private String tempCode() {
        return "TMP-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
    }

    /** Ví dụ chuẩn hóa mã theo BinID: DN + 3 chữ số -> DN001, DN045, ... */
    private String normalizeCodeById(int binId) {
        return "DN" + String.format("%03d", binId);
    }

    /** Validate input khi tạo mới */
    private void validateCreateInput(Bin input) {
        // Ward phải hợp lệ
        if (input.getWardID() <= 0 || !wardRepository.existsById(input.getWardID())) {
            throw new IllegalArgumentException("Vui lòng chọn phường hợp lệ");
        }
        // Giá trị số
        if (input.getCurrentFill() < 0) {
            throw new IllegalArgumentException("% đầy không được âm");
        }
        if (input.getCapacity() < 0) {
            throw new IllegalArgumentException("Dung tích phải >= 0");
        }
    }

    /** Áp mặc định an toàn */
    private void applyDefaults(Bin b) {
        if (b.getCapacity() <= 0) b.setCapacity(120.0);
        // Nếu status không hợp lệ (không phải 0/1/2) thì mặc định 1 (hoạt động)
        if (b.getStatus() != 0 && b.getStatus() != 1 && b.getStatus() != 2) {
            b.setStatus(1);
        }
        if (b.getLastUpdated() == null) b.setLastUpdated(new Date());
    }


    // Sử dụng JOIN FETCH để lấy tất cả dữ liệu
    public List<Bin> getAllBins() {
        return binRepository.findAllWithWardAndProvince();
    }
    public List<Bin> getActiveBinsWithHighFill() {
        return binRepository.findActiveBinsWithHighFill();
    }
    public List<Bin> getOffLineBins() {
        return binRepository.findOffLineBins();
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
    // ================== CREATE (Admin) — luôn tự gen BinCode ==================
    @Transactional
    public Bin createBin(Bin input) {
        validateCreateInput(input);
        applyDefaults(input);

        // B1: gán mã tạm để thỏa NOT NULL + UNIQUE ngay từ insert
        String tmp;
        do { tmp = tempCode(); } while (binRepository.existsByBinCode(tmp));
        input.setBinCode(tmp);
        input.setLastUpdated(new Date());

        // Lưu để có BinID
        Bin saved = binRepository.save(input);

        // B2: chuẩn hoá mã cuối cùng dựa theo BinID (VD: DN001)
        String base = normalizeCodeById(saved.getBinID());
        String finalCode = base;
        int suffix = 0;
        while (binRepository.existsByBinCode(finalCode)) {
            finalCode = base + "-" + (++suffix);
        }

        saved.setBinCode(finalCode);
        saved.setLastUpdated(new Date());
        return binRepository.save(saved);
    }

    // ================== UPDATE (Admin) — KHÔNG cho sửa BinCode ==================
    public boolean isBinCodeTakenByOther(String binCode, int currentId) {
        if (binCode == null) return false;
        Bin found = binRepository.findByBinCode(binCode.trim());
        return found != null && found.getBinID() != currentId;
    }

    @Transactional
    public Bin updateBin(int id, Bin input) {
        Bin existing = binRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy BinID=" + id));

        // validate cơ bản
        if (input.getWardID() <= 0 || !wardRepository.existsById(input.getWardID())) {
            throw new IllegalArgumentException("Vui lòng chọn phường hợp lệ");
        }
        if (input.getCurrentFill() < 0) throw new IllegalArgumentException("% đầy không được âm");
        if (input.getCapacity() <= 0) input.setCapacity(120.0);

        // KHÔNG cho sửa BinCode
        // existing.setBinCode(...);

        existing.setStreet(input.getStreet());
        existing.setWardID(input.getWardID());
        existing.setLatitude(input.getLatitude());
        existing.setLongitude(input.getLongitude());
        existing.setCapacity(input.getCapacity());
        existing.setCurrentFill(Math.max(0, input.getCurrentFill()));
        existing.setStatus(input.getStatus());
        existing.setLastUpdated(new Date());

        return binRepository.save(existing);
    }

    // ================== XÓA (khuyến nghị: kiểm tra FK Tasks trước) ==================
    @Autowired
    private com.example.repository.TaskGateway taskGateway;

    public void delete(int id) {
        long cnt = taskGateway.countByBinId(id);
        if (cnt > 0) {
            throw new IllegalStateException("Không thể xoá: thùng đang được tham chiếu bởi " + cnt + " task.");
        }
        binRepository.deleteById(id);
    }

    public void deleteBin(int id) {
        Bin bin = binRepository.findById(id).orElse(null);
        if (bin != null) {
            binRepository.delete(bin);
        }
    }
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