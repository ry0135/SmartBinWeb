package com.example.service;

import com.example.model.Ward;
import com.example.repository.WardRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class WardService {

    @Autowired
    private WardRepository wardRepository;

    // Lấy danh sách tất cả phường
    public List<Ward> getAllWards() {
        return wardRepository.findAll();
    }
    // Thêm phương thức này nếu chưa có
    public Optional<Ward> getWardById(Integer id) {
        return wardRepository.findById(id);
    }
    // Lấy danh sách phường theo tỉnh
    public List<Ward> getWardsByProvinceId(Integer provinceId) {
        return wardRepository.findByProvince_ProvinceId(provinceId);
    }

    // Tạo phường mới
    public Ward createWard(Ward ward) {
        return wardRepository.save(ward);
    }

    // Xóa phường
    public void deleteWard(Integer wardId) {
        wardRepository.deleteById(wardId);
    }
    // ✅ Thêm mới
    public boolean existsByNameAndProvince(String wardName, Integer provinceId) {
        return wardRepository.existsByWardNameIgnoreCaseAndProvince_ProvinceId(wardName.trim(), provinceId);
    }
    public Integer getProvinceId(int wardId) {
        return wardRepository.findProvinceIdByWardId(wardId);
    }
}
