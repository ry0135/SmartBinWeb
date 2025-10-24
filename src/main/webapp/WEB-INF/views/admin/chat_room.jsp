<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Chat – Hội thoại</title>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>

    <style>
        :root{
            --primary-green:#22c55e; --secondary-green:#16a34a;
            --light-green:#f0fdf4; --border-green:#d1fae5; --text-green:#166534;
            --bg:#f8fafc;
        }
        body{ background:var(--bg); }
        .chat-shell{ max-width:900px; margin:auto; }
        .chat-card{ border:1px solid var(--border-green); border-radius:16px; overflow:hidden; box-shadow:0 2px 6px rgba(0,0,0,.06); background:#fff; }
        .chat-header{ background:var(--light-green); border-bottom:1px solid var(--border-green); color:var(--text-green); font-weight:700; }
        .chat-body{ height:60vh; overflow-y:auto; padding:16px; background:#fff; }
        .msg{ max-width:68%; padding:10px 12px; border-radius:12px; margin-bottom:10px; word-break:break-word; }
        .from-me{ margin-left:auto; background:#dcfce7; border:1px solid var(--border-green); }
        .from-them{ margin-right:auto; background:#f3f4f6; border:1px solid #e5e7eb; }
        .msg-time{ font-size:.75rem; color:#64748b; margin-top:4px; }
        .chat-footer{ border-top:1px solid var(--border-green); background:#fff; }
        .btn-send{ background:var(--primary-green); border-color:var(--secondary-green); color:#fff; }
        .btn-send:hover{ background:var(--secondary-green); border-color:var(--secondary-green); color:#fff; }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/admin/header_admin.jsp"/>

<div class="container py-4 chat-shell">
    <div class="chat-card">
        <div class="chat-header p-3 d-flex justify-content-between align-items-center">
            <div><i class="bi bi-chat-dots me-2"></i>Hội thoại</div>
            <div>
                <a class="btn btn-sm btn-outline-success" href="javascript:location.reload()">Làm mới</a>
            </div>
        </div>

        <!-- Lịch sử -->
        <div id="chatBody" class="chat-body">
            <c:set var="meId" value="${sessionScope.currentUser != null ? sessionScope.currentUser.accountId : 0}"/>
            <c:forEach var="m" items="${conversation}">
                <div class="d-flex ${m.sender.accountId == meId ? 'justify-content-end' : 'justify-content-start'}">
                    <div class="msg ${m.sender.accountId == meId ? 'from-me' : 'from-them'}">
                        <div><c:out value="${m.message}"/></div>
                        <div class="msg-time">
                            <fmt:formatDate value="${m.sentAt}" pattern="dd/MM/yyyy HH:mm"/>
                            <c:if test="${m.sender.accountId == meId}">
                                • <span><c:out value="${m.read ? 'Đã đọc' : 'Đã gửi'}"/></span>
                            </c:if>
                        </div>
                    </div>
                </div>
            </c:forEach>

            <c:if test="${empty conversation}">
                <div class="text-center text-muted py-5">Chưa có tin nhắn. Hãy gửi tin đầu tiên 👋</div>
            </c:if>
        </div>

        <!-- Gửi tin -->
        <div class="chat-footer p-3">
            <form method="post" action="${pageContext.request.contextPath}/chat/send" class="row g-2"
                  onsubmit="return trimCheck()">
                <input type="hidden" name="receiverId" value="${receiverId}"/>
                <div class="col-12 col-md-10">
                    <textarea class="form-control" name="message" rows="2" placeholder="Nhập tin nhắn..." required></textarea>
                </div>
                <div class="col-12 col-md-2 d-grid">
                    <button class="btn btn-send" type="submit">
                        <i class="bi bi-send-fill me-1"></i> Gửi
                    </button>
                </div>
            </form>
        </div>
    </div>

    <div class="mt-3">
        <c:if test="${sessionScope.currentUser != null && sessionScope.currentUser.role == 1}">
            <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/chat/admin">
                ← Danh sách Manager
            </a>
        </c:if>
    </div>
</div>

<!-- Lib SockJS + STOMP -->
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>

<script>
    // Auto scroll về cuối khi mở trang
    (function(){ var el = document.getElementById('chatBody'); if(el){ el.scrollTop = el.scrollHeight; } })();

    function trimCheck(){
        var ta = document.querySelector('textarea[name="message"]'); // <-- FIX selector
        if(!ta) return true;
        ta.value = ta.value.trim();
        return ta.value.length > 0;
    }

    // ===== Realtime subscribe qua STOMP =====
    (function(){
        var meId = ${meId};
        var receiverId = ${receiverId};

        // cùng quy ước với server: /topic/chat.{minId}.{maxId}
        var a = Math.min(meId, receiverId);
        var b = Math.max(meId, receiverId);
        var topic = "/topic/chat." + a + "." + b;

        var ctx = "${pageContext.request.contextPath}";
        var sock = new SockJS(ctx + "/ws");
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

            var row = document.createElement('div');
            row.className = 'd-flex ' + (isMe ? 'justify-content-end' : 'justify-content-start');

            var msg = document.createElement('div');
            msg.className = 'msg ' + (isMe ? 'from-me' : 'from-them');

            var content = document.createElement('div');
            content.textContent = m.message;
            msg.appendChild(content);

            var meta = document.createElement('div');
            meta.className = 'msg-time';
            var dateStr = formatDate(m.sentAt);
            meta.innerHTML = dateStr + (isMe ? ' • <span>' + (m.read ? 'Đã đọc' : 'Đã gửi') + '</span>' : '');
            msg.appendChild(meta);

            row.appendChild(msg);
            chatBody.appendChild(row);
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
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>
</body>
</html>
