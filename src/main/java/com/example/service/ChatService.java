package com.example.service;

import com.example.model.Account;
import com.example.model.AccountConst;
import com.example.model.Chat;
import com.example.repository.AccountRepository;
import com.example.repository.ChatRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

@Service
public class ChatService {

    private final ChatRepository chatRepository;
    private final AccountRepository accountRepository;

    public ChatService(ChatRepository chatRepository, AccountRepository accountRepository) {
        this.chatRepository = chatRepository;
        this.accountRepository = accountRepository;
    }

    // ===== Helpers =====
    private Account getAccountOrThrow(int id) {
        return accountRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy account id=" + id));
    }

    private void assertAdminManagerPair(Account a, Account b) {
        int ra = a.getRole();
        int rb = b.getRole();

        boolean ok = (ra == AccountConst.Roles.ADMIN && rb == AccountConst.Roles.MANAGER)
                || (ra == AccountConst.Roles.MANAGER && rb == AccountConst.Roles.ADMIN);

        if (!ok) {
            throw new IllegalArgumentException("Chỉ cho phép chat giữa Admin (role=1) và Manager (role=2).");
        }
    }

    // ===== Core APIs =====

    /**
     * Lấy toàn bộ hội thoại (2 chiều) giữa 2 tài khoản (chỉ cho phép ADMIN <-> MANAGER).
     * Kết quả được merge và sort theo thời gian tăng dần.
     */
    @Transactional(readOnly = true)
    public List<Chat> getConversation(int accountIdA, int accountIdB) {
        Account a = getAccountOrThrow(accountIdA);
        Account b = getAccountOrThrow(accountIdB);
        assertAdminManagerPair(a, b);

        List<Chat> ab = chatRepository.findBySenderAndReceiverOrderBySentAtAsc(a, b);
        List<Chat> ba = chatRepository.findBySenderAndReceiverOrderBySentAtAsc(b, a);

        // gộp + sort
        List<Chat> merged = new ArrayList<>(ab.size() + ba.size());
        merged.addAll(ab);
        merged.addAll(ba);
        merged.sort(Comparator.comparing(Chat::getSentAt));
        return merged;
    }

    /**
     * Gửi tin nhắn (chỉ cho phép ADMIN <-> MANAGER).
     * Trả về bản ghi Chat đã lưu.
     */
    @Transactional
    public Chat sendMessage(int senderId, int receiverId, String message) {
        if (message == null || message.trim().length() == 0) {
            throw new IllegalArgumentException("Nội dung tin nhắn không được trống.");
        }
        Account sender = getAccountOrThrow(senderId);
        Account receiver = getAccountOrThrow(receiverId);
        assertAdminManagerPair(sender, receiver);

        Chat c = new Chat(sender, receiver, message.trim());
        return chatRepository.save(c);
    }

    /**
     * Đánh dấu đã đọc toàn bộ tin nhắn mà 'viewerId' nhận từ 'otherId'.
     */
    @Transactional
    public int markConversationRead(int viewerId, int otherId) {
        Account viewer = getAccountOrThrow(viewerId);
        Account other  = getAccountOrThrow(otherId);
        assertAdminManagerPair(viewer, other);

        // lấy tất cả tin nhắn other -> viewer chưa đọc
        List<Chat> unread = chatRepository.findBySenderAndReceiverOrderBySentAtAsc(other, viewer)
                .stream()
                .filter(c -> !c.isRead())
                .collect(Collectors.toList());

        unread.forEach(c -> c.setRead(true));
        chatRepository.saveAll(unread);
        return unread.size();
    }

    /**
     * Đếm số tin chưa đọc từ 'fromId' gửi tới 'toId'.
     */
    @Transactional(readOnly = true)
    public long countUnreadFromTo(int fromId, int toId) {
        Account from = getAccountOrThrow(fromId);
        Account to   = getAccountOrThrow(toId);
        assertAdminManagerPair(from, to);
        return chatRepository.countByReceiverAndSenderAndIsReadFalse(to, from);
    }

    /**
     * Dùng cho phía Admin: lấy danh sách các Manager có hội thoại với Admin này,
     * kèm tin nhắn cuối cùng & số chưa đọc. (Dữ liệu thô, Controller sẽ format)
     */
    @Transactional(readOnly = true)
    public List<ManagerChatSummary> listManagersForAdmin(int adminId) {
        Account admin = getAccountOrThrow(adminId);
        if (admin.getRole() != AccountConst.Roles.ADMIN) {
            throw new IllegalArgumentException("Chỉ Admin mới xem danh sách hội thoại với Manager.");
        }

        // Lấy toàn bộ manager (tuỳ bạn có muốn filter theo ward hay không)
        // Ở đây lấy tất cả role=MANAGER
        List<Account> managers = accountRepository.findByRole(AccountConst.Roles.MANAGER, org.springframework.data.domain.PageRequest.of(0, Integer.MAX_VALUE))
                .getContent();

        List<ManagerChatSummary> result = new ArrayList<>();
        for (Account m : managers) {
            // gộp 2 chiều rồi lấy last
            List<Chat> conv = getConversation(admin.getAccountId(), m.getAccountId());
            Chat last = conv.isEmpty() ? null : conv.get(conv.size() - 1);
            long unread = countUnreadFromTo(m.getAccountId(), admin.getAccountId()); // chưa đọc từ manager -> admin
            result.add(new ManagerChatSummary(m, last, unread));
        }
        // Sắp xếp manager theo thời điểm tin nhắn cuối (mới nhất lên đầu)
        result.sort((x, y) -> {
            Date dx = x.getLastMessage() != null ? x.getLastMessage().getSentAt() : new Date(0);
            Date dy = y.getLastMessage() != null ? y.getLastMessage().getSentAt() : new Date(0);
            return dy.compareTo(dx);
        });
        return result;
    }

    // ===== DTO tóm tắt cho danh sách hội thoại của Admin =====
    public static class ManagerChatSummary {
        private final Account manager;
        private final Chat lastMessage;
        private final long unreadCount;

        public ManagerChatSummary(Account manager, Chat lastMessage, long unreadCount) {
            this.manager = manager;
            this.lastMessage = lastMessage;
            this.unreadCount = unreadCount;
        }
        public Account getManager() { return manager; }
        public Chat getLastMessage() { return lastMessage; }
        public long getUnreadCount() { return unreadCount; }
    }
}
