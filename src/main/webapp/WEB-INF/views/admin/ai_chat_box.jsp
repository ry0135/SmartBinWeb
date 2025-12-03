<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    #ai-chat-toggle {
        position: fixed;
        bottom: 24px;
        right: 24px;
        width: 56px;
        height: 56px;
        border-radius: 50%;
        border: none;
        cursor: pointer;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.18);
        font-size: 24px;
        background: #16a34a;
        color: #fff;
        display: flex;
        align-items: center;
        justify-content: center;
        z-index: 9999;
    }

    #ai-chat-toggle:hover {
        transform: translateY(-1px);
        filter: brightness(1.05);
    }

    #ai-chat-box {
        position: fixed;
        bottom: 92px;
        right: 24px;
        width: 360px;
        max-height: 520px;
        background: #ffffff;
        border-radius: 16px;
        box-shadow: 0 12px 30px rgba(0, 0, 0, 0.18);
        display: none;
        flex-direction: column;
        overflow: hidden;
        z-index: 9998;
        font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Inter', sans-serif;
    }

    #ai-chat-header {
        padding: 12px 16px;
        background: linear-gradient(135deg, #16a34a, #22c55e);
        color: #fff;
        display: flex;
        align-items: center;
        justify-content: space-between;
    }

    #ai-chat-header .title {
        display: flex;
        flex-direction: column;
    }

    #ai-chat-header .title span:first-child {
        font-weight: 600;
        font-size: 14px;
    }

    #ai-chat-header .title span:last-child {
        font-size: 11px;
        opacity: 0.9;
    }

    #ai-chat-header button {
        background: transparent;
        border: none;
        color: #fff;
        font-size: 18px;
        cursor: pointer;
    }

    #ai-chat-messages {
        padding: 10px 12px 12px;
        flex: 1;
        overflow-y: auto;
        background: #f4f6f9;
        font-size: 13px;
    }

    .ai-msg-row {
        display: flex;
        margin-bottom: 8px;
    }

    .ai-msg-row.user { justify-content: flex-end; }
    .ai-msg-row.ai { justify-content: flex-start; }

    .ai-bubble {
        max-width: 80%;
        border-radius: 14px;
        padding: 8px 10px;
        line-height: 1.4;
        word-break: break-word;
        white-space: pre-wrap;
    }

    .ai-bubble.user {
        background: #16a34a;
        color: #fff;
        border-bottom-right-radius: 4px;
    }

    .ai-bubble.ai {
        background: #ffffff;
        color: #111827;
        border-bottom-left-radius: 4px;
        box-shadow: 0 1px 4px rgba(15, 23, 42, 0.15);
    }

    #ai-chat-input-area {
        border-top: 1px solid #e5e7eb;
        padding: 8px;
        display: flex;
        gap: 6px;
        background: #fff;
    }

    #ai-chat-input {
        flex: 1;
        border-radius: 999px;
        border: 1px solid #d1d5db;
        padding: 8px 12px;
        font-size: 13px;
        outline: none;
    }

    #ai-chat-input:focus {
        border-color: #16a34a;
        box-shadow: 0 0 0 1px rgba(22, 163, 74, 0.2);
    }

    #ai-chat-send {
        border-radius: 999px;
        border: none;
        padding: 0 14px;
        font-size: 13px;
        font-weight: 500;
        cursor: pointer;
        background: #16a34a;
        color: #fff;
        display: flex;
        align-items: center;
        gap: 4px;
    }

    #ai-chat-send:disabled {
        opacity: 0.6;
        cursor: default;
    }

    #ai-chat-send:hover:not(:disabled) {
        filter: brightness(1.05);
    }

    .ai-typing {
        font-size: 11px;
        color: #6b7280;
        margin-bottom: 4px;
    }
</style>

<button id="ai-chat-toggle" title="Chat AI SmartBin">💬</button>

<div id="ai-chat-box">
    <div id="ai-chat-header">
        <div class="title">
            <span>SmartBin AI Assistant</span>
            <span>Hỏi về thùng rác, task, mức đầy...</span>
        </div>
        <button id="ai-chat-close">✕</button>
    </div>

    <!-- Ban đầu để trống, sẽ load từ DB -->
    <div id="ai-chat-messages"></div>

    <div id="ai-chat-input-area">
        <input id="ai-chat-input" type="text" placeholder="Nhập câu hỏi của bạn..." />
        <button id="ai-chat-send">Gửi</button>
    </div>
</div>

<script>
    (function () {
        const toggleBtn = document.getElementById('ai-chat-toggle');
        const chatBox = document.getElementById('ai-chat-box');
        const closeBtn = document.getElementById('ai-chat-close');

        const messagesEl = document.getElementById('ai-chat-messages');
        const inputEl = document.getElementById('ai-chat-input');
        const sendBtn = document.getElementById('ai-chat-send');

        const contextPath = '<c:out value="${pageContext.request.contextPath}"/>';
        const chatUrl = contextPath + '/api/ai/chat';
        const historyUrl = contextPath + '/api/ai/history';

        let historyLoaded = false;

        function scrollToBottom() {
            messagesEl.scrollTop = messagesEl.scrollHeight;
        }

        function addMessage(sender, text) {
            const row = document.createElement('div');
            row.classList.add('ai-msg-row', sender);

            const bubble = document.createElement('div');
            bubble.classList.add('ai-bubble', sender);
            bubble.textContent = text;

            row.appendChild(bubble);
            messagesEl.appendChild(row);
            scrollToBottom();
        }

        function setTyping(show) {
            let typingEl = document.getElementById('ai-typing');
            if (show) {
                if (!typingEl) {
                    typingEl = document.createElement('div');
                    typingEl.id = 'ai-typing';
                    typingEl.className = 'ai-typing';
                    typingEl.textContent = 'AI đang trả lời...';
                    messagesEl.appendChild(typingEl);
                }
            } else {
                if (typingEl) typingEl.remove();
            }
            scrollToBottom();
        }

        // 📥 Load lịch sử chat từ DB (chỉ load 1 lần khi mở chat lần đầu)
        async function loadHistoryIfNeeded() {
            if (historyLoaded) return;
            historyLoaded = true;

            try {
                setTyping(true);

                const resp = await fetch(historyUrl, {
                    method: 'GET',
                    headers: {
                        'Accept': 'application/json'
                    }
                });

                setTyping(false);

                if (!resp.ok) {
                    // Nếu lỗi history → hiển thị greeting mặc định
                    addDefaultGreeting();
                    return;
                }

                const logs = await resp.json();

                messagesEl.innerHTML = ''; // clear cũ, rồi render lịch sử

                if (!logs || logs.length === 0) {
                    // Không có lịch sử → hiển thị greeting ban đầu
                    addDefaultGreeting();
                    return;
                }

                // logs: list AiChatLogs (LogID, AccountID, Sender, Message, CreatedAt)
                logs.forEach(function (log) {
                    const sender = (log.sender === 'user') ? 'user' : 'ai';
                    addMessage(sender, log.message);
                });

            } catch (e) {
                console.error('Lỗi load history:', e);
                setTyping(false);
                // Nếu lỗi → vẫn cho greeting để UI không trống
                addDefaultGreeting();
            }
        }

        function addDefaultGreeting() {
            addMessage('ai',
                'Xin chào 👋\n' +
                'Mình là trợ lý AI của hệ thống SmartBin.\n' +
                'Bạn có thể hỏi về thùng rác, task, thống kê mức đầy, v.v.'
            );
        }

        async function sendMessage() {
            const text = inputEl.value.trim();
            if (!text) return;

            addMessage('user', text);
            inputEl.value = '';
            inputEl.focus();

            sendBtn.disabled = true;
            setTyping(true);

            try {
                const resp = await fetch(chatUrl, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({ message: text })
                });

                if (!resp.ok) throw new Error('HTTP ' + resp.status);

                const data = await resp.json();
                addMessage('ai', data.reply || '(Không có trả lời từ AI)');
            } catch (e) {
                addMessage('ai', 'Lỗi API: ' + e.message);
            } finally {
                setTyping(false);
                sendBtn.disabled = false;
            }
        }

        sendBtn.addEventListener('click', sendMessage);
        inputEl.addEventListener('keydown', function (e) {
            if (e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault();
                sendMessage();
            }
        });

        toggleBtn.addEventListener('click', function () {
            if (chatBox.style.display === 'flex') {
                chatBox.style.display = 'none';
            } else {
                chatBox.style.display = 'flex';
                // Lần đầu mở chat → load history từ DB
                loadHistoryIfNeeded();
                inputEl.focus();
            }
        });

        closeBtn.addEventListener('click', function () {
            chatBox.style.display = 'none';
        });
    })();
</script>
