package com.example.service;

import com.example.model.Feedback;
import com.example.repository.FeedbackRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.*;

@Service
public class FeedbackAIService {

    @Value("${openai.api.key}")
    private String apiKey;

    @Autowired
    private FeedbackRepository feedbackRepository;

    /**
     * Tạo phản hồi AI cho feedback cụ thể dựa trên comment và rating,
     * rồi lưu lại vào cơ sở dữ liệu.
     */
    public String generateAutoReply(String comment, int rating) {
        try {
            String prompt = "Hãy viết một phản hồi thân thiện, tự nhiên và có cảm xúc bằng tiếng Việt, " +
                    "phản hồi cho khách hàng với đánh giá " + rating +
                    " sao và nội dung: \"" + comment + "\". " +
                    "Phản hồi nên gồm 2-3 câu, thể hiện sự chuyên nghiệp, cảm ơn và mong muốn cải thiện.";


            RestTemplate restTemplate = new RestTemplate();

            Map<String, Object> body = new HashMap<>();
            body.put("model", "gpt-3.5-turbo");

            List<Map<String, String>> messages = new ArrayList<>();
            Map<String, String> systemMsg = new HashMap<>();
            systemMsg.put("role", "system");
            systemMsg.put("content", "Bạn là nhân viên chăm sóc khách hàng lịch sự.");
            messages.add(systemMsg);

            Map<String, String> userMsg = new HashMap<>();
            userMsg.put("role", "user");
            userMsg.put("content", prompt);
            messages.add(userMsg);

            body.put("messages", messages);

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            headers.setBearerAuth(apiKey);

            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(body, headers);
            Map<String, Object> response = restTemplate.postForObject(
                    "https://api.openai.com/v1/chat/completions", entity, Map.class
            );

            if (response != null && response.containsKey("choices")) {
                List<Map<String, Object>> choices = (List<Map<String, Object>>) response.get("choices");
                if (!choices.isEmpty()) {
                    Map<String, Object> choice = choices.get(0);
                    Map<String, Object> message = (Map<String, Object>) choice.get("message");
                    return message.get("content").toString().trim();
                }
            }

        } catch (Exception e) {
            System.err.println("Lỗi khi gọi API phản hồi AI: " + e.getMessage());
        }

        // fallback nếu lỗi
        if (rating <= 2) {
            return "Xin lỗi bạn về trải nghiệm chưa tốt. Chúng tôi sẽ cố gắng cải thiện sớm nhất!";
        } else if (rating == 3) {
            return "Cảm ơn bạn đã góp ý! Chúng tôi sẽ nỗ lực để phục vụ tốt hơn.";
        } else if (rating >= 4) {
            return "Cảm ơn bạn rất nhiều vì đánh giá tích cực! Mong được phục vụ bạn lần sau.";
        }
        return "Cảm ơn bạn đã phản hồi!";
    }}
