<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Chat – Danh sách Manager</title>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>

    <style>
        :root{
            --primary-green:#22c55e; --secondary-green:#16a34a;
            --light-green:#f0fdf4; --border-green:#d1fae5;
            --text-green:#166534; --muted:#6b7280; --border:#e5e7eb;
        }
        .sb-card{ border:1px solid var(--border-green); border-radius:14px; box-shadow:0 1px 2px rgba(0,0,0,.05); }
        .sb-card .card-header{ background:var(--light-green); border-bottom:1px solid var(--border-green); color:var(--text-green); font-weight:700 }
        .manager-item{ border:1px solid var(--border); border-radius:12px; padding:12px 14px; transition:.2s; }
        .manager-item:hover{ background:#fff; transform: translateY(-2px); box-shadow:0 4px 8px rgba(0,0,0,.06); }
        .last-msg{ color:var(--muted); font-size:.9rem }
        .badge-unread{ background:#ef4444; }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/admin/header_admin.jsp"/>

<div class="container my-4" style="max-width:1000px;">
    <div class="sb-card card">
        <div class="card-header d-flex justify-content-between align-items-center">
            <div><i class="bi bi-chat-dots me-2"></i>Chat – Chọn Manager</div>
            <a class="btn btn-sm btn-outline-success" href="${pageContext.request.contextPath}/chat/admin">
                Làm mới
            </a>
        </div>

        <div class="card-body">
            <c:if test="${empty managerChats}">
                <div class="text-center text-muted py-4">Chưa có quản lý nào để chat.</div>
            </c:if>

            <div class="vstack gap-2">
                <c:forEach var="m" items="${managerChats}">
                    <a class="manager-item text-decoration-none text-reset"
                       href="${pageContext.request.contextPath}/chat/admin/${m.manager.accountId}">
                        <div class="d-flex align-items-center">
                            <div class="me-3">
                                <div class="rounded-circle bg-success-subtle d-flex align-items-center justify-content-center"
                                     style="width:42px;height:42px;">
                                    <i class="bi bi-person-fill text-success"></i>
                                </div>
                            </div>
                            <div class="flex-grow-1">
                                <div class="d-flex justify-content-between">
                                    <div class="fw-semibold">
                                        <c:out value="${m.manager.fullName}"/>
                                    </div>
                                    <div class="text-nowrap text-muted" style="font-size:.85rem;">
                                        <c:if test="${m.lastMessage != null}">
                                            <fmt:formatDate value="${m.lastMessage.sentAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </c:if>
                                    </div>
                                </div>
                                <div class="d-flex justify-content-between">
                                    <div class="last-msg text-truncate" style="max-width: 75%;">
                                        <c:out value="${m.lastMessage != null ? m.lastMessage.message : 'Chưa có tin nhắn'}"/>
                                    </div>
                                    <c:if test="${m.unreadCount > 0}">
                                        <span class="badge badge-unread"><c:out value="${m.unreadCount}"/></span>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </a>
                </c:forEach>

            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>
</body>
</html>
