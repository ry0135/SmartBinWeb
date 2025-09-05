package com.example.controller;

import com.example.model.Bin;
import com.example.service.BinService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@RequestMapping("/manager/bins")
public class BinController {

    @Autowired
    private BinService binService;

    @GetMapping("/realtime-status")
    public String viewRealtimeStatus(Model model,
                                     @RequestParam(required = false) Integer status,
                                     @RequestParam(defaultValue = "0.8") double threshold) {

        List<Bin> bins;
        if (status != null) {
            bins = binService.getBinsByStatus(status);
        } else {
            bins = binService.getAllBins();
        }

        List<Bin> criticalBins = binService.getCriticalBins(threshold);

        model.addAttribute("bins", bins);
        model.addAttribute("criticalBins", criticalBins);
        model.addAttribute("threshold", threshold);

        return "manager/bin-status";
    }
}