package com.example.service.impl;

import com.example.model.Bin;
import com.example.repository.BinRepository;
import com.example.service.BinService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class BinServiceImpl implements BinService {

    @Autowired
    private BinRepository binRepository;

    @Override
    public List<Bin> getAllBins() {
        return binRepository.findAllOrderByLastUpdatedDesc();
    }

    @Override
    public List<Bin> getBinsByStatus(int status) {
        return binRepository.findByStatus(status);
    }

    @Override
    public Bin getBinById(int id) {
        return binRepository.findById(id).orElse(null);
    }

    @Override
    public List<Bin> getCriticalBins(double threshold) {
        return binRepository.findByCurrentFillGreaterThanEqual(threshold);
    }
    @Override
    public Bin getBinByCode(String binCode) {
        return binRepository.findByBinCode(binCode)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy thùng rác"));
    }
}