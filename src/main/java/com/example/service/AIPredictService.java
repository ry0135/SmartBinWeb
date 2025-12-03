package com.example.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.http.ResponseEntity;

import java.util.HashMap;
import java.util.Map;

@Service
public class AIPredictService {

    // ✅ Địa chỉ server FastAPI (nếu test local thì dùng http://localhost:8000)
    private final String AI_URL = "http://13.228.79.109:8000/predict_full_time";

    public Map<String, Object> predictFullTime(int binId, double currentFill) {
        try {
            RestTemplate restTemplate = new RestTemplate();
            // 🔹 Gọi FastAPI bằng GET
            String url = AI_URL + "?bin_id=" + binId + "&current_fill=" + currentFill;

            ResponseEntity<String> response = restTemplate.getForEntity(url, String.class);

            // 🔹 Phân tích JSON trả về
            ObjectMapper mapper = new ObjectMapper();
            JsonNode jsonNode = mapper.readTree(response.getBody());

            Map<String, Object> result = new HashMap<>();
            result.put("bin_id", jsonNode.path("bin_id").asInt());
            result.put("current_fill", jsonNode.path("current_fill").asDouble());
            result.put("hours_left", jsonNode.path("hours_left").asDouble());
            result.put("predicted_full_time", jsonNode.path("predicted_full_time").asText());
            result.put("status", jsonNode.path("status").asText());
            result.put("message", jsonNode.path("message").asText());
            System.out.println("🔗 Gọi AI URL: " + url);
            return result;

        } catch (Exception e) {
            Map<String, Object> error = new HashMap<>();
            error.put("error", e.getMessage());
            return error;
        }
    }

    public Map<String, Object> trainNow() {
        try {
            String url = "http://13.229.57.106:8000/train_now";
            RestTemplate restTemplate = new RestTemplate();
            ResponseEntity<String> response = restTemplate.postForEntity(url, null, String.class);

            ObjectMapper mapper = new ObjectMapper();
            JsonNode json = mapper.readTree(response.getBody());

            Map<String, Object> result = new HashMap<>();
            result.put("status", json.path("status").asText());
            result.put("message", json.path("message").asText());
            return result;

        } catch (Exception e) {
            Map<String, Object> error = new HashMap<>();
            error.put("status", "error");
            error.put("message", e.getMessage());
            return error;
        }
    }
}
