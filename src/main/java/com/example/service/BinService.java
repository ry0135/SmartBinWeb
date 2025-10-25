package com.example.service;

import com.example.model.Bin;
import com.example.repository.BinRepository;
import com.example.repository.WardRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional; // <-- DÙNG SPRING

import java.util.Date;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.TimeUnit;

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

    // ================== Query cho JSP/REST ==================
    public List<Bin> getAllBins() {
        return binRepository.findAllWithWardAndProvince();
    }

    public Bin getBinById(int id) {
        return binRepository.findByIdWithWardAndProvince(id).orElse(null);
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

    // ================== REST cho sensor/app ==================
    /** Tạo mới nếu chưa có theo BinCode; nếu không gửi BinCode thì tự tạo mới */
    @Transactional
    public Bin saveOrUpdateBin(Bin bin) {
        // Nếu thiếu BinCode -> xem như tạo mới (auto-gen)
        if (bin.getBinCode() == null || bin.getBinCode().trim().isEmpty()) {
            return createBin(bin);
        }

        Bin existing = binRepository.findByBinCode(bin.getBinCode().trim());
        if (existing == null) {
            applyDefaults(bin);
            bin.setBinCode(bin.getBinCode().trim());
            bin.setLastUpdated(new Date());
            return binRepository.save(bin);
        } else {
            // cập nhật các trường động
            existing.setLatitude(bin.getLatitude());
            existing.setLongitude(bin.getLongitude());
            existing.setCurrentFill(bin.getCurrentFill());
            existing.setStatus(bin.getStatus());
            existing.setStreet(bin.getStreet());
            if (bin.getWardID() > 0 && wardRepository.existsById(bin.getWardID())) {
                existing.setWardID(bin.getWardID());
            }
            existing.setLastUpdated(new Date());
            return binRepository.save(existing);
        }
    }

    // ================== CHECKER ==================
    @Scheduled(fixedRate = 60000)
    public void checkInactiveBins() {
        List<Bin> allBins = binRepository.findAll();
        long now = System.currentTimeMillis();
        for (Bin bin : allBins) {
            Date lu = bin.getLastUpdated();
            if (lu == null) continue; // phòng null
            long diffMinutes = TimeUnit.MILLISECONDS.toMinutes(now - lu.getTime());
            if (diffMinutes >= 2 && bin.getStatus() != 2) {
                bin.setStatus(2); // 2 = đầy/mất kết nối
                binRepository.save(bin);
                System.out.println("[CHECKER] Bin " + bin.getBinCode() + " mất kết nối!");
            }
        }
    }
}
