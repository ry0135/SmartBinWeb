package com.example.service;

import com.example.model.Province;
import com.example.repository.ProvinceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ProvinceService {

    @Autowired
    private ProvinceRepository provinceRepository;

    // Lấy toàn bộ danh sách tỉnh
    public List<Province> getAllProvinces() {
        return provinceRepository.findAll();
    }

    // Lấy tỉnh theo ID
    public Optional<Province> getProvinceById(Integer id) {
        return provinceRepository.findById(id);
    }

    // Tạo tỉnh mới
    public Province createProvince(Province province) {
        return provinceRepository.save(province);
    }

    // Xóa tỉnh
    public void deleteProvince(Integer id) {
        provinceRepository.deleteById(id);
    }
    public boolean existsByName(String name) {
        return provinceRepository.existsByProvinceNameIgnoreCase(name.trim());
    }

}
