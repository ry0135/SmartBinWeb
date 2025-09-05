package com.example.service;

import com.example.model.Bin;
import com.example.repository.BinRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public interface BinService {
    List<Bin> getAllBins();
    List<Bin> getBinsByStatus(int status);
    Bin getBinById(int id);
    List<Bin> getCriticalBins(double threshold); // Bổ sung thêm

    Bin getBinByCode(String binCode) ;



}