<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- SockJS + STOMP -->
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>

<div class="d-flex flex-column vh-100 bg-white border-end position-fixed start-0 top-0"
     style="width: 250px; z-index: 1000;">

  <!-- Header -->
  <div class="p-4 border-bottom">
    <h4 class="mb-0 text-success fw-bold">
      🗑️ SmartBin
    </h4>
    <small class="text-muted">Quản lý thùng rác thông minh</small>
  </div>

  <!-- 🔔 Popup thông báo -->
  <div id="notifPopup"
       style="position: fixed;top: 20px;bottom: auto;right: 78px;
                background: #28a745; color: white; padding: 15px 18px;
                border-radius: 8px; display: none;
                box-shadow: 0 4px 12px rgba(0,0,0,0.2);
                z-index: 999999999;">
  </div>

  <style>
    #notifPopup {
      position: fixed !important;
      z-index: 999999999 !important;
      pointer-events: auto !important;
    }
  </style>

  <script>
    window.showNotificationPopup = function(title, message) {
      console.log("🔔 showNotificationPopup called:", title, message);

      var popup = document.getElementById("notifPopup");
      if (!popup) {
        console.error("❌ Element #notifPopup not found!");
        return;
      }

      // 🔥 CÁCH 2 – KHÔNG DÙNG TEMPLATE LITERAL
      popup.innerHTML =
              '<div style="display:flex;align-items:center;gap:12px;">' +
              '<div style="font-size:22px;">🔔</div>' +
              '<div style="line-height:1.3">' +
              '<div style="font-weight:bold;">' + title + '</div>' +
              '<div>' + message + '</div>' +
              '</div>' +
              '</div>';

      popup.style.display = "block";
      popup.style.opacity = "1";

      // Tự ẩn sau 10 giây
      setTimeout(function() {
        popup.style.opacity = "0";
        setTimeout(function() {
          popup.style.display = "none";
        }, 500);
      }, 10000);

      console.log("✅ Notification popup displayed");
    };
  </script>

  <script src="${pageContext.request.contextPath}/assets/js/websocket.js"></script>

  <!-- MENU -->
  <nav class="flex-grow-1 py-3">
    <ul class="nav nav-pills flex-column px-3" id="sidebar-menu">

      <li class="nav-item mb-2">
        <a href="${pageContext.request.contextPath}/manage"
           class="nav-link text-dark d-flex align-items-center py-3 px-3 rounded sidebar-link"
           data-path="/manage">
          <span class="me-3 fs-5">📊</span>
          <span class="fw-semibold">Dashboard</span>
        </a>
      </li>

      <!-- Task -->
      <li class="nav-item mb-2">
        <div class="dropdown">
          <a href="#" class="nav-link text-dark d-flex align-items-center py-3 px-3 rounded
                    sidebar-link dropdown-toggle"
             data-bs-toggle="dropdown" data-path="/tasks">
            <span class="me-3 fs-5">📋</span>
            <span class="fw-semibold">Quản lý Task</span>
          </a>
          <ul class="dropdown-menu bg-white border">
            <li>
              <a href="${pageContext.request.contextPath}/tasks/task-management"
                 class="dropdown-item text-dark sidebar-link"
                 data-path="/tasks/task-management">
                🎯 Giao nhiệm vụ
              </a>
            </li>
            <li>
              <a href="${pageContext.request.contextPath}/tasks/maintenance-management?type=maintain"
                 class="dropdown-item text-dark sidebar-link"
                 data-path="/tasks/maintenance-management">
                🔧 Bảo trì
              </a>
            </li>

            <li>
              <a href="${pageContext.request.contextPath}/tasks/open"
                 class="dropdown-item text-dark sidebar-link"
                 data-path="/tasks/open">
                📊 Quản lý nhiệm vụ
              </a>
            </li>
          </ul>
        </div>
      </li>

      <li class="nav-item mb-2">
        <a href="${pageContext.request.contextPath}/bins"
           class="nav-link text-dark d-flex align-items-center py-3 px-3 rounded sidebar-link"
           data-path="/bins">
          🗑️ Thùng rác
        </a>
      </li>

      <li class="nav-item mb-2">
        <a href="${pageContext.request.contextPath}/reports"
           class="nav-link text-dark d-flex align-items-center py-3 px-3 rounded sidebar-link"
           data-path="/reports">
          📑 Báo cáo
        </a>
      </li>

      <li class="nav-item mb-2">
        <a href="${pageContext.request.contextPath}/feedbacks"
           class="nav-link text-dark d-flex align-items-center py-3 px-3 rounded sidebar-link"
           data-path="/feedbacks">
          🗂️ Phản hồi
        </a>
      </li>

<%--      <li class="nav-item mb-2">--%>
<%--        <a href="${pageContext.request.contextPath}/settings"--%>
<%--           class="nav-link text-dark d-flex align-items-center py-3 px-3 rounded sidebar-link"--%>
<%--           data-path="/settings">--%>
<%--          ⚙️ Cài đặt--%>
<%--        </a>--%>
<%--      </li>--%>

      <li class="nav-item mb-2">
        <a href="${pageContext.request.contextPath}/chat/manager"
           class="nav-link text-dark d-flex align-items-center py-3 px-3 rounded sidebar-link"
           data-path="/chat/manager">
          💬 Chat với Admin
        </a>
      </li>

    </ul>
  </nav>

  <!-- Footer -->
  <div class="mt-auto p-3 border-top">
    <div class="d-flex align-items-center">
      <div class="bg-success rounded-circle me-3"
           style="width:45px;height:45px;display:flex;align-items:center;justify-content:center;">
        <span class="text-white fs-5">👤</span>
      </div>

      <div class="flex-grow-1">
        <div class="fw-bold small text-dark">
          <c:choose>
            <c:when test="${not empty sessionScope.user}">
              ${sessionScope.user.username}
            </c:when>
            <c:otherwise>Manager</c:otherwise>
          </c:choose>
        </div>
        <div class="text-muted small">Quản trị viên</div>
      </div>

      <a href="${pageContext.request.contextPath}/logout"
         class="btn btn-outline-success btn-sm">
        <i class="fas fa-sign-out-alt"></i>
      </a>
    </div>
  </div>
</div>
