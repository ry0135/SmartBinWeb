<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Chat – Hội thoại</title>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>

    <style>
        :root{
            --primary: #10b981;
            --primary-dark: #059669;
            --primary-light: #d1fae5;
            --primary-lighter: #ecfdf5;
            --secondary: #6366f1;
            --bg-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --shadow-sm: 0 1px 3px rgba(0,0,0,.08);
            --shadow-md: 0 4px 12px rgba(0,0,0,.1);
            --shadow-lg: 0 10px 25px rgba(0,0,0,.12);
        }

        body{
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .chat-container{
            max-width: 960px;
            margin: 2rem auto;
            padding: 0 1rem;
        }

        .chat-card{
            border-radius: 24px;
            overflow: hidden;
            box-shadow: var(--shadow-lg);
            background: #fff;
            backdrop-filter: blur(10px);
        }

        .chat-header{
            background: var(--bg-gradient);
            color: #fff;
            padding: 1.5rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .chat-header h5{
            margin: 0;
            font-weight: 600;
            font-size: 1.25rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .chat-header .bi{
            font-size: 1.5rem;
        }

        .btn-refresh{
            background: rgba(255,255,255,.2);
            border: 1px solid rgba(255,255,255,.3);
            color: #fff;
            padding: 0.5rem 1rem;
            border-radius: 12px;
            font-size: 0.9rem;
            transition: all .3s ease;
        }

        .btn-refresh:hover{
            background: rgba(255,255,255,.3);
            border-color: rgba(255,255,255,.4);
            transform: translateY(-2px);
            color: #fff;
        }

        .chat-body{
            height: 65vh;
            overflow-y: auto;
            padding: 2rem;
            background: linear-gradient(to bottom, #fafafa 0%, #fff 100%);
            position: relative;
        }

        .chat-body::-webkit-scrollbar{
            width: 6px;
        }

        .chat-body::-webkit-scrollbar-track{
            background: #f1f1f1;
        }

        .chat-body::-webkit-scrollbar-thumb{
            background: #cbd5e1;
            border-radius: 3px;
        }

        .chat-body::-webkit-scrollbar-thumb:hover{
            background: #94a3b8;
        }

        .msg-wrapper{
            margin-bottom: 1.25rem;
            animation: slideIn .3s ease;
        }

        @keyframes slideIn{
            from{ opacity: 0; transform: translateY(10px); }
            to{ opacity: 1; transform: translateY(0); }
        }

        .msg{
            max-width: 70%;
            padding: 0.875rem 1.125rem;
            border-radius: 18px;
            word-break: break-word;
            position: relative;
            box-shadow: var(--shadow-sm);
        }

        .from-me{
            margin-left: auto;
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
            color: #fff;
            border-bottom-right-radius: 4px;
        }

        .from-them{
            margin-right: auto;
            background: #fff;
            border: 1px solid #e5e7eb;
            color: #374151;
            border-bottom-left-radius: 4px;
        }

        .msg-content{
            line-height: 1.5;
            font-size: 0.95rem;
        }

        .msg-time{
            font-size: 0.7rem;
            margin-top: 0.5rem;
            opacity: 0.8;
        }

        .from-me .msg-time{
            color: rgba(255,255,255,.9);
        }

        .from-them .msg-time{
            color: #94a3b8;
        }

        .status-badge{
            display: inline-flex;
            align-items: center;
            gap: 0.25rem;
            font-size: 0.7rem;
        }

        .empty-state{
            text-align: center;
            padding: 4rem 2rem;
            color: #94a3b8;
        }

        .empty-state i{
            font-size: 4rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }

        .chat-footer{
            border-top: 1px solid #f0f0f0;
            background: #fff;
            padding: 1.5rem 2rem;
        }

        .input-group-modern{
            display: flex;
            gap: 0.75rem;
            align-items: flex-end;
        }

        .textarea-modern{
            flex: 1;
            border: 2px solid #e5e7eb;
            border-radius: 16px;
            padding: 0.875rem 1.125rem;
            font-size: 0.95rem;
            resize: none;
            transition: all .3s ease;
            font-family: inherit;
        }

        .textarea-modern:focus{
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 4px var(--primary-lighter);
        }

        .btn-send{
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
            border: none;
            color: #fff;
            padding: 0.875rem 1.75rem;
            border-radius: 16px;
            font-weight: 600;
            font-size: 0.95rem;
            transition: all .3s ease;
            box-shadow: var(--shadow-sm);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-send:hover{
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
            background: linear-gradient(135deg, var(--primary-dark) 0%, var(--primary) 100%);
        }

        .btn-send:active{
            transform: translateY(0);
        }

        .back-button{
            background: #fff;
            border: 2px solid #e5e7eb;
            color: #64748b;
            padding: 0.75rem 1.5rem;
            border-radius: 14px;
            font-weight: 500;
            transition: all .3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            text-decoration: none;
        }

        .back-button:hover{
            border-color: var(--primary);
            color: var(--primary);
            transform: translateX(-4px);
            background: var(--primary-lighter);
        }

        @media (max-width: 768px){
            .chat-container{
                margin: 1rem auto;
            }

            .chat-card{
                border-radius: 16px;
            }

            .chat-header{
                padding: 1.25rem 1.5rem;
            }

            .chat-body{
                height: 55vh;
                padding: 1.5rem;
            }

            .msg{
                max-width: 85%;
            }

            .input-group-modern{
                flex-direction: column;
                gap: 0.5rem;
            }

            .btn-send{
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</head>
<body>

<div class="chat-container">
    <div class="chat-card">
        <div class="chat-header">
            <h5>
                <i class="bi bi-chat-dots-fill"></i>
                Hội thoại
            </h5>
            <a class="btn-refresh" href="javascript:location.reload()">
                <i class="bi bi-arrow-clockwise"></i> Làm mới
            </a>
        </div>

        <!-- Lịch sử chat -->
        <div id="chatBody" class="chat-body">
            <c:set var="meId" value="${sessionScope.currentUser != null ? sessionScope.currentUser.accountId : 0}"/>
            <c:forEach var="m" items="${conversation}">
                <div class="msg-wrapper d-flex ${m.sender.accountId == meId ? 'justify-content-end' : 'justify-content-start'}">
                    <div class="msg ${m.sender.accountId == meId ? 'from-me' : 'from-them'}">
                        <div class="msg-content">
                            <c:out value="${m.message}"/>
                        </div>
                        <div class="msg-time">
                            <fmt:formatDate value="${m.sentAt}" pattern="dd/MM/yyyy HH:mm"/>
                            <c:if test="${m.sender.accountId == meId}">
                                <span class="status-badge">
                                    <i class="bi ${m.read ? 'bi-check-all' : 'bi-check'}"></i>
                                    <c:out value="${m.read ? 'Đã đọc' : 'Đã gửi'}"/>
                                </span>
                            </c:if>
                        </div>
                    </div>
                </div>
            </c:forEach>

            <c:if test="${empty conversation}">
                <div class="empty-state">
                    <i class="bi bi-chat-heart"></i>
                    <h5>Chưa có tin nhắn</h5>
                    <p>Hãy gửi tin nhắn đầu tiên để bắt đầu cuộc trò chuyện 👋</p>
                </div>
            </c:if>
        </div>

        <!-- Form gửi tin -->
        <div class="chat-footer">
            <form method="post" action="${pageContext.request.contextPath}/chat/send"
                  onsubmit="return trimCheck()">
                <input type="hidden" name="receiverId" value="${receiverId}"/>
                <div class="input-group-modern">
                    <textarea class="textarea-modern"
                              name="message"
                              rows="2"
                              placeholder="Nhập tin nhắn của bạn..."
                              required></textarea>
                    <button class="btn-send" type="submit">
                        <i class="bi bi-send-fill"></i>
                        <span>Gửi</span>
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Nút quay lại -->
    <div class="mt-4">
        <c:if test="${sessionScope.currentUser != null && sessionScope.currentUser.role == 1}">
            <a class="back-button" href="${pageContext.request.contextPath}/chat/admin">
                <i class="bi bi-arrow-left"></i>
                Danh sách Manager
            </a>
        </c:if>
    </div>
</div>

<!-- Lib SockJS + STOMP -->
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>

<script>
    // Auto scroll về cuối khi mở trang
    (function(){
        var el = document.getElementById('chatBody');
        if(el){ el.scrollTop = el.scrollHeight; }
    })();

    function trimCheck(){
        var ta = document.querySelector('textarea[name="message"]');
        if(!ta) return true;
        ta.value = ta.value.trim();
        return ta.value.length > 0;
    }

    // ===== Realtime subscribe qua STOMP =====
    (function(){
        var meId = ${sessionScope.currentUser != null ? sessionScope.currentUser.accountId : 0};
        var receiverId = ${receiverId};

        var a = Math.min(meId, receiverId);
        var b = Math.max(meId, receiverId);
        var topic = "/topic/chat." + a + "." + b;

        var ctx = "${pageContext.request.contextPath}";
        var sock = new SockJS(ctx + "/ws-bin-sockjs");
        var stomp = Stomp.over(sock);
        stomp.debug = null;

        stomp.connect({}, function(){
            stomp.subscribe(topic, function(frame){
                try {
                    var msg = JSON.parse(frame.body);
                    appendMessage(msg);
                } catch(e){
                    console.error("Parse message error", e);
                }
            });
        });

        function appendMessage(m){
            var chatBody = document.getElementById('chatBody');
            if(!chatBody) return;

            var isMe = (m.senderId === meId);

            var wrapper = document.createElement('div');
            wrapper.className = 'msg-wrapper d-flex ' + (isMe ? 'justify-content-end' : 'justify-content-start');

            var msg = document.createElement('div');
            msg.className = 'msg ' + (isMe ? 'from-me' : 'from-them');

            var content = document.createElement('div');
            content.className = 'msg-content';
            content.textContent = m.message;
            msg.appendChild(content);

            var meta = document.createElement('div');
            meta.className = 'msg-time';
            var dateStr = formatDate(m.sentAt);
            meta.innerHTML = dateStr + (isMe ? ' <span class="status-badge"><i class="bi ' +
                (m.read ? 'bi-check-all' : 'bi-check') + '"></i> ' +
                (m.read ? 'Đã đọc' : 'Đã gửi') + '</span>' : '');
            msg.appendChild(meta);

            wrapper.appendChild(msg);
            chatBody.appendChild(wrapper);
            chatBody.scrollTop = chatBody.scrollHeight;
        }

        function formatDate(d){
            try{
                var dt = new Date(d);
                var pad = n => (n<10?'0':'') + n;
                return pad(dt.getDate()) + "/" + pad(dt.getMonth()+1) + "/" + dt.getFullYear()
                    + " " + pad(dt.getHours()) + ":" + pad(dt.getMinutes());
            }catch(e){
                return '';
            }
        }
    })();
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>