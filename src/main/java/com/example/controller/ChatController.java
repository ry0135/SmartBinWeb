package com.example.controller;

import com.example.model.Account;
import com.example.model.AccountConst;
import com.example.model.Chat;
import com.example.service.ChatService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;   // <-- phát socket
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/chat")
public class ChatController {

    @Autowired
    private ChatService chatService;

    @Autowired
    private SimpMessagingTemplate messagingTemplate;  // để publish ra /topic/...

    // ========== 1️⃣ Màn hình cho Admin: chọn Manager để chat ==========
    @GetMapping("/admin")
    public String adminChatList(HttpSession session, Model model) {
        Account current = (Account) session.getAttribute("currentUser");
        if (current == null || current.getRole() != AccountConst.Roles.ADMIN) {
            return "redirect:/login";
        }
        model.addAttribute("managerChats", chatService.listManagersForAdmin(current.getAccountId()));
        return "admin/admin_chat_list"; // JSP: danh sách managers
    }

    // ========== 2️⃣ Mở khung chat giữa Admin và 1 Manager ==========
    @GetMapping("/admin/{managerId}")
    public String adminChatRoom(@PathVariable int managerId, HttpSession session, Model model) {
        Account current = (Account) session.getAttribute("currentUser");
        if (current == null || current.getRole() != AccountConst.Roles.ADMIN) {
            return "redirect:/login";
        }

        List<Chat> conversation = chatService.getConversation(current.getAccountId(), managerId);
        chatService.markConversationRead(current.getAccountId(), managerId);

        model.addAttribute("conversation", conversation);
        model.addAttribute("receiverId", managerId);
        return "admin/chat_room"; // JSP: khung chat chung
    }

    // ========== 3️⃣ Manager chat với Admin ==========
    @GetMapping("/manager")
    public String managerChat(HttpSession session, Model model) {
        Account current = (Account) session.getAttribute("currentUser");
        if (current == null || current.getRole() != AccountConst.Roles.MANAGER) {
            return "redirect:/login";
        }

        int adminId = 1; // TODO: nếu nhiều admin, query admin phù hợp
        List<Chat> conversation = chatService.getConversation(current.getAccountId(), adminId);
        chatService.markConversationRead(current.getAccountId(), adminId);

        model.addAttribute("conversation", conversation);
        model.addAttribute("receiverId", adminId);
        return "admin/chat_room";
    }

    // ========== 4️⃣ Gửi tin nhắn (lưu DB + broadcast realtime) ==========
    @PostMapping("/send")
    public String sendMessage(
            @RequestParam int receiverId,
            @RequestParam String message,
            HttpSession session
    ) {
        Account current = (Account) session.getAttribute("currentUser");
        if (current == null) return "redirect:/login";

        // 1) Lưu DB
        Chat saved = chatService.sendMessage(current.getAccountId(), receiverId, message);

        // 2) Broadcast realtime tới topic hội thoại chung
        String topic = toTopic(current.getAccountId(), receiverId);

        Map<String, Object> payload = new HashMap<>();
        payload.put("chatId", saved.getChatId());
        payload.put("senderId", saved.getSender().getAccountId());
        payload.put("receiverId", saved.getReceiver().getAccountId());
        payload.put("message", saved.getMessage());
        payload.put("sentAt", saved.getSentAt());
        payload.put("read", saved.isRead());

        messagingTemplate.convertAndSend(topic, payload);

        // 3) Quay lại đúng phòng chat
        if (current.getRole() == AccountConst.Roles.ADMIN) {
            return "redirect:/chat/admin/" + receiverId;
        } else {
            return "redirect:/chat/manager";
        }
    }

    // ===== Helper: sinh topic chung cho 2 user (thứ tự không quan trọng) =====
    private String toTopic(int aId, int bId) {
        int min = Math.min(aId, bId);
        int max = Math.max(aId, bId);
        return "/topic/chat." + min + "." + max;
    }
}
