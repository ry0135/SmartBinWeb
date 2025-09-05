package com.example.service;


import com.example.model.Bin;
import com.example.repository.BinRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;



import java.util.Date;

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



    @Autowired
    private BinRepository binRepository;

    public Bin saveOrUpdateBin(Bin bin) {
        // Nếu muốn update theo binCode
        Bin existing = binRepository.findByBinCode(bin.getBinCode());

        if (existing == null) {
            // chưa có thì tạo mới
            bin.setCapacity(bin.getCapacity() == 0 ? 50.0 : bin.getCapacity());
            return binRepository.save(bin);
        } else {
            // có rồi thì cập nhật
            existing.setLatitude(bin.getLatitude());
            existing.setLongitude(bin.getLongitude());
            existing.setCurrentFill(bin.getCurrentFill());
            existing.setStatus(bin.getStatus());
            existing.setStreet(bin.getStreet());
            existing.setWard(bin.getWard());
            existing.setCity(bin.getCity());
            existing.setLastUpdated(new Date());

            return binRepository.save(existing);
        }
    }

    // 👉 Hàm mới để lấy toàn bộ danh sách thùng rác
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


}

