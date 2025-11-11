package com.example.controller.ai;

import com.example.service.AIPredictService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("/api/ai")
public class AIPredictController {

    @Autowired
    private AIPredictService aiService;

    @GetMapping("/predict")
    public ResponseEntity<Map<String, Object>> predictBinFullTime(
            @RequestParam int binId,
            @RequestParam double currentFill
            ) {
        String now = java.time.LocalDateTime.now().toString().replace("T", " ");

        // Nếu client không gửi currentTime thì tự động dùng thời gian hiện tại
        Map<String, Object> result = aiService.predictFullTime(binId, currentFill);
        return ResponseEntity.ok(result);
    }

    @GetMapping("/train_now")
    public ResponseEntity<Map<String, Object>> triggerTraining() {
        Map<String, Object> result = aiService.trainNow();
        return ResponseEntity.ok(result);
    }

}