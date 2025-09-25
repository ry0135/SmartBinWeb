package com.example.service;

import com.example.model.Province;
import com.example.model.Ward;
import com.example.repository.ProvinceRepository;
import com.example.repository.WardRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class LocationService {

    private final ProvinceRepository provinceRepository;
    private final WardRepository wardRepository;

    public LocationService(ProvinceRepository provinceRepository, WardRepository wardRepository) {
        this.provinceRepository = provinceRepository;
        this.wardRepository = wardRepository;
    }

    public List<Province> getAllProvinces() {
        return provinceRepository.findAll();
    }

    public List<Ward> getWardsByProvince(Long provinceId) {
        return wardRepository.findByProvince_ProvinceId(provinceId);
    }


}



