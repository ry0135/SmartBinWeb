package com.example.controller;

import com.example.dto.AiChatRequest;
import com.example.dto.AiChatResponse;
import com.example.model.Account;
import com.example.model.AiChatLogs;
import com.example.repository.AiChatLogsRepository;
import com.example.service.AiChatService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/api/ai")
public class AiChatController {

    @Autowired
    private AiChatService aiChatService;

    @Autowired
    private AiChatLogsRepository aiChatLogsRepository;

    /**
     * API chat chính:
     * - Nhận JSON: { "message": "..." }
     * - Gọi AiChatService.ask(...)
     * - Lưu 2 log: user + ai
     * - Trả JSON: { "reply": "..." }
     */
    @PostMapping(
            value = "/chat",
            consumes = MediaType.APPLICATION_JSON_VALUE,
            produces = MediaType.APPLICATION_JSON_VALUE
    )
    @ResponseBody
    public AiChatResponse chat(@RequestBody AiChatRequest request,
                               HttpSession session) {

        String userMessage = request.getMessage();
        String aiReply = aiChatService.ask(userMessage);

        // Lấy AccountID từ session (tùy project, mình xử lý an toàn)
        Integer accountId = getCurrentAccountId(session);

        // Lưu log user
        saveChatLog(accountId, "user", userMessage);

        // Lưu log AI
        saveChatLog(accountId, "ai", aiReply);

        return new AiChatResponse(aiReply);
    }

    /**
     * (Tùy chọn) API xem lịch sử chat cho account hiện tại.
     * Có thể dùng AJAX load lịch sử nếu bạn muốn.
     */
    @GetMapping(value = "/history", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public List<AiChatLogs> history(HttpSession session) {
        Integer accountId = getCurrentAccountId(session);
        if (accountId != null) {
            return aiChatLogsRepository.findByAccountIdOrderByCreatedAtAsc(accountId);
        } else {
            // Nếu không lấy được account (ví dụ chưa login),
            // trả về 200 log mới nhất để debug/admin
            return aiChatLogsRepository.findTop200ByOrderByCreatedAtDesc();
        }
    }

    // ================== PRIVATE HELPERS ==================

    /**
     * Lấy AccountID từ session.
     * Tùy dự án bạn đặt tên attribute gì, mình thử cả 2:
     * - "loggedInAccount"
     * - "account"
     */
    private Integer getCurrentAccountId(HttpSession session) {
        try {
            Object obj = session.getAttribute("loggedInAccount");
            if (obj == null) {
                obj = session.getAttribute("account");
            }
            if (obj instanceof Account) {
                Account acc = (Account) obj;
                return acc.getAccountId(); // hoặc getAccountId() tùy tên field
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null; // fallback nếu không có account
    }

    /**
     * Lưu 1 dòng chat log vào DB
     */
    private void saveChatLog(Integer accountId, String sender, String message) {
        try {
            AiChatLogs log = new AiChatLogs();

            // Nếu không có account (null) vẫn cho phép lưu, hoặc bạn có thể bỏ qua
            if (accountId != null) {
                log.setAccountId(accountId);
            } else {
                // Nếu bạn muốn bắt buộc vẫn phải có, thì có thể return luôn:
                // return;
                log.setAccountId(0); // hoặc giá trị đặc biệt, tùy bạn
            }

            log.setSender(sender);   // "user" hoặc "ai"
            log.setMessage(message);

            aiChatLogsRepository.save(log);
        } catch (Exception e) {
            e.printStackTrace();
            // Không nên throw lỗi ra ngoài, tránh làm hỏng trải nghiệm chat
        }
    }
}
