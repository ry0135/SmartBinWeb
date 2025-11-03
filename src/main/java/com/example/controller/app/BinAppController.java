package com.example.controller.app;
import com.example.dto.BinDTO;
import com.example.model.Bin;
import com.example.repository.BinRepository;
import com.example.service.BinService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api/bins")
@CrossOrigin(origins = "*") // Cho phép Android app gọi API
public class BinAppController {
    @Autowired
    private BinService binService;

    @Autowired
    private BinRepository binRepository;

    // Lấy danh sách tất cả thùng rác
    @GetMapping
    public List<Bin> getAllBins() {
        return binService.getAllBins();
    }



    // Lấy chi tiết 1 thùng theo ID
    @GetMapping("/{id}")
    public Bin getBinById(@PathVariable int id) {
        return binService.getBinById(id);
    }

    @GetMapping("/dto")
    public List<BinDTO> getAllBinDTOs() {
        List<Bin> bins = binRepository.findAll();
        List<BinDTO> result = new ArrayList<>();

        for (Bin bin : bins) {
            String wardName = (bin.getWard() != null) ? bin.getWard().getWardName() : null;
            String provinceName = (bin.getWard() != null && bin.getWard().getProvince() != null)
                    ? bin.getWard().getProvince().getProvinceName()
                    : null;

            result.add(new BinDTO(
                    bin.getBinID(),
                    bin.getBinCode(),
                    bin.getLatitude(),
                    bin.getLongitude(),
                    bin.getCapacity(),
                    bin.getCurrentFill(),
                    bin.getStreet(),
                    wardName,
                    provinceName,
                    bin.getStatus(),
                    bin.getLastUpdated()
            ));
        }

        return result;
    }



    @PutMapping("/{id}")
    public ResponseEntity<?> updateBin(@PathVariable int id, @RequestBody Bin updated) {
        return binRepository.findById(id)
                .map(bin -> {
                    bin.setCurrentFill(updated.getCurrentFill());
                    bin.setStatus(updated.getStatus());
                    bin.setLastUpdated(new java.util.Date());
                    Bin saved = binRepository.save(bin);
                    return ResponseEntity.ok(saved);
                })
                .orElseGet(() -> ResponseEntity.notFound().build());
    }


}

