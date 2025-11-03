package com.example.controller.app;


import com.example.model.Province;
import com.example.model.Ward;
import com.example.service.LocationService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/location")
public class LocationController {

    private final LocationService locationService;

    public LocationController(LocationService locationService) {
        this.locationService = locationService;
    }

    @GetMapping("/provinces")
    public List<Province> getAllProvinces() {
        return locationService.getAllProvinces();
    }

    @GetMapping("/wards/{provinceId}")
    public List<Ward> getWardsByProvince(@PathVariable int provinceId) {
        return locationService.getWardsByProvince(provinceId);
    }
}

