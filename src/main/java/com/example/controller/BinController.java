package com.example.controller;

import com.example.model.Bin;
import com.example.repository.BinRepository;
import com.example.service.BinService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/sensor")
public class BinController {

    @Autowired
    private BinService binService;

    @PostMapping
    public String saveData(@RequestBody Bin bin) {
        Bin savedBin = binService.saveOrUpdateBin(bin);
        return "Saved bin: " + savedBin.getBinCode()
                + " - " + savedBin.getStreet() + ", "
                + savedBin.getWard();
    }
}
