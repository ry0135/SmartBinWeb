//package com.example.controller.app;
//
//import com.example.model.Bin;
//import com.example.service.BinService;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.web.bind.annotation.*;
//
//import java.util.List;
//
//@RestController
//@RequestMapping("/api/bins")
//@CrossOrigin(origins = "*") // Cho phép Android app gọi API
//public class BinAppController {
//    @Autowired
//    private  BinService binService;
//
//
//
//    // Lấy danh sách tất cả thùng rác
//    @GetMapping
//    public List<Bin> getAllBins() {
//        return binService.getAllBins();
//    }
//
//    // Lấy chi tiết 1 thùng theo ID
//    @GetMapping("/{id}")
//    public Bin getBinById(@PathVariable int id) {
//        return binService.getBinById(id);
//    }
//
//    // Thêm thùng mới
//    @PostMapping
//    public Bin createBin(@RequestBody Bin bin) {
//        return binService.saveBin(bin);
//    }
//
//    // Cập nhật thùng
//    @PutMapping("/{id}")
//    public Bin updateBin(@PathVariable int id, @RequestBody Bin bin) {
//        bin.setBinId(id);
//        return binService.saveBin(bin);
//    }
//
//    // Xóa thùng
//    @DeleteMapping("/{id}")
//    public void deleteBin(@PathVariable int id) {
//        binService.deleteBin(id);
//    }
//}
