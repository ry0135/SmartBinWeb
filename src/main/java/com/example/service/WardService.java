package com.example.service;

import com.example.model.Ward;
import com.example.repository.WardRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class WardService {

    @Autowired
    private WardRepository wardRepository;

    public List<Ward> getAllWards() {
        return wardRepository.findAllByOrderByWardNameAsc();
    }

    public Ward getWardById(int id) {
        return wardRepository.findById(id).orElse(null);
    }
}