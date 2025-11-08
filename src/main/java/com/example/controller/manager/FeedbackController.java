
package com.example.controller.manager;

import com.example.model.Feedback;
import com.example.repository.FeedbackRepository;
import com.example.service.FeedbackAIService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@Controller
public class FeedbackController {

    @Autowired
    private FeedbackRepository feedbackRepository;

    @Autowired
    private FeedbackAIService aiService;

    // 🧠 Hiển thị danh sách feedback
    @GetMapping("/feedbacks")
    public String showFeedbackList(Model model) {
        List<Feedback> list = feedbackRepository.findAllWithAccount();


        // ✅ Duyệt để đảm bảo Account được load (nếu dùng lazy)
        for (Feedback f : list) {
            if (f.getAccount() != null) {
                f.getAccount().getFullName(); // ép Hibernate load tên
            }

            // ✅ Tự sinh phản hồi AI nếu chưa có
            if (f.getAutoReply() == null || f.getAutoReply().trim().isEmpty()) {
                String autoReply = aiService.generateAutoReply(f.getComment(), f.getRating());
                f.setAutoReply(autoReply);
                feedbackRepository.save(f);
            }
        }

        model.addAttribute("feedbacks", list);
        return "manage/feedback-list";
    }

    // 💬 Phản hồi thủ công của admin
    @PostMapping("/feedback/reply")
    @ResponseBody
    public String replyFeedback(@RequestParam int feedbackID, @RequestParam(required = false) String reply) {
        Optional<Feedback> optionalFeedback = feedbackRepository.findById(feedbackID);
        if (!optionalFeedback.isPresent()) {
            return "not_found";
        }

        Feedback feedback = optionalFeedback.get();

        // 🔹 Nếu admin nhập phản hồi thủ công
        if (reply != null && !reply.trim().isEmpty()) {
            feedback.setAdminReply(reply);
        }

        // 🔹 Nếu chưa có phản hồi AI thì tự sinh
        if (feedback.getAutoReply() == null || feedback.getAutoReply().trim().isEmpty()) {
            String autoReply = aiService.generateAutoReply(feedback.getComment(), feedback.getRating());
            feedback.setAutoReply(autoReply);
        }

        feedbackRepository.save(feedback);
        return "success";
    }
}
