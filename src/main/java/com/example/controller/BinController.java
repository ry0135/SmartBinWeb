package com.example.controller;

import com.example.model.Bin;
import com.example.repository.BinRepository;
import com.example.service.AIPredictService;
import com.example.service.BinService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.Map;

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

    @Autowired
    private AIPredictService aiService;

//    @GetMapping("/bin/predict/{binId}")
//    @ResponseBody
//    public Map<String, Object> predictBin(@PathVariable int binId) {
//        Bin bin = binService.getBinById(binId); // lấy thông tin thùng rác từ DB
//
//        // Lấy thời gian hiện tại
//        String now = java.time.LocalDateTime.now().toString().replace("T", " ");
//
//        // Gọi hàm dự đoán từ AI
//        return aiService.predictFullTime(binId, bin.getCurrentFill());
//    }
}
