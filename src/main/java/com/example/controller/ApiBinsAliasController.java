package com.example.controller;

import com.example.model.ApiResponse;
import com.example.model.Bin;
import com.example.service.BinService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/bins")
@CrossOrigin(origins = "*")
public class ApiBinsAliasController {

    @Autowired
    private BinService binService;

    // Alias: Lấy tất cả thùng rác (đổi endpoint để tránh trùng với BinAppController)
    @GetMapping("/all")
    public ResponseEntity<ApiResponse<List<Bin>>> getAllBins() {
        try {
            List<Bin> bins = binService.getAllBins();
            return ResponseEntity.ok(ApiResponse.success("Lấy danh sách thùng rác thành công", bins));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error("Có lỗi xảy ra: " + e.getMessage()));
        }
    }

    @GetMapping("/nearby")
    public ResponseEntity<List<Bin>> getNearbyBins(
            @RequestParam double latitude,
            @RequestParam double longitude) {

        List<Bin> bins = binService.getNearbyBins(latitude, longitude,5.0,10);
        return ResponseEntity.ok(bins);
    }

    // Alias: Nearby (cho phép ép tọa độ Hội An qua useHoiAn=true)
//    @GetMapping("/nearby")
//    public ResponseEntity<ApiResponse<List<Bin>>> getNearbyBins(
//            @RequestParam double latitude,
//            @RequestParam double longitude,
//            @RequestParam(defaultValue = "5.0") double radiusKm,
//            @RequestParam(defaultValue = "10") int limit,
//            @RequestParam(required = false, defaultValue = "false") boolean useHoiAn) {
//        try {
//            if (useHoiAn) {
//                latitude = 15.8801;
//                longitude = 108.3380;
//            }
//            List<Bin> nearbyBins = binService.getNearbyBins(latitude, longitude, radiusKm, limit);
//            return ResponseEntity.ok(ApiResponse.success("Lấy danh sách thùng rác gần nhất thành công", nearbyBins));
//        } catch (Exception e) {
//            return ResponseEntity.badRequest().body(ApiResponse.error("Có lỗi xảy ra: " + e.getMessage()));
//        }
//    }

    // Alias: Nearby cố định Hội An
    @GetMapping("/nearby/hoian")
    public ResponseEntity<ApiResponse<List<Bin>>> getNearbyHoiAn(
            @RequestParam(defaultValue = "5.0") double radiusKm,
            @RequestParam(defaultValue = "10") int limit) {
        try {
            List<Bin> nearbyBins = binService.getNearbyBins(15.8801, 108.3380, radiusKm, limit);
            return ResponseEntity.ok(ApiResponse.success("Lấy danh sách thùng rác gần Hội An thành công", nearbyBins));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error("Có lỗi xảy ra: " + e.getMessage()));
        }
    }
}



