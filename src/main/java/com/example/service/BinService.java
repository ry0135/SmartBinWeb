package com.example.service;

import com.example.model.Bin;
import com.example.repository.BinRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class BinService {
    @Autowired
    private  BinRepository binRepository;

    public BinService(BinRepository binRepository) {
        this.binRepository = binRepository;
    }

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