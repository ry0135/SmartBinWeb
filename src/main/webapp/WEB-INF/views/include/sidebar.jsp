<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- SockJS + STOMP -->
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>

<style>
  /* Hiệu ứng cho sidebar links */
  .sidebar-link {
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    position: relative;
    overflow: hidden;
  }

  .sidebar-link::before {
    content: '';
    position: absolute;
    left: 0;
    top: 0;
    height: 100%;
    width: 3px;
    background: #28a745;
    transform: scaleY(0);
    transition: transform 0.3s ease;
  }

  .sidebar-link:hover {
    background-color: rgba(40, 167, 69, 0.1) !important;
    transform: translateX(5px);
    padding-left: 1rem !important;
  }

  .sidebar-link:active {
    transform: scale(0.98) translateX(5px);
  }

  .sidebar-link.active {
    background-color: #28a745 !important;
    color: white !important;
    font-weight: 600;
    box-shadow: 0 2px 8px rgba(40, 167, 69, 0.3);
  }

  .sidebar-link.active::before {
    transform: scaleY(1);
  }

  /* Hiệu ứng ripple khi click */
  .sidebar-link {
    position: relative;
    overflow: hidden;
  }

  .ripple {
    position: absolute;
    border-radius: 50%;
    background: rgba(255, 255, 255, 0.6);
    transform: scale(0);
    animation: ripple-animation 0.6s ease-out;
    pointer-events: none;
  }

  @keyframes ripple-animation {
    to {
      transform: scale(4);
      opacity: 0;
    }
  }

  /* Dropdown menu animation */
  .dropdown-menu {
    animation: slideDown 0.3s ease-out;
    border: none;
    box-shadow: 0 4px 12px rgba(0,0,0,0.15);
  }

  @keyframes slideDown {
    from {
      opacity: 0;
      transform: translateY(-10px);
    }
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }

  .dropdown-item {
    transition: all 0.2s ease;
  }

  .dropdown-item:hover {
    background-color: rgba(40, 167, 69, 0.1);
    padding-left: 2rem;
    color: #28a745 !important;
  }

  /* Notification popup animation */
  #notifPopup {
    position: fixed !important;
    z-index: 999999999 !important;
    pointer-events: auto !important;
    transition: all 0.3s ease;
    animation: slideInRight 0.4s ease-out;
  }

  @keyframes slideInRight {
    from {
      transform: translateX(100%);
      opacity: 0;
    }
    to {
      transform: translateX(0);
      opacity: 1;
    }
  }

  /* Icon animation */
  .sidebar-link span:first-child {
    transition: transform 0.3s ease;
  }

  .sidebar-link:hover span:first-child {
    transform: scale(1.2) rotate(5deg);
  }

  .sidebar-link.active span:first-child {
    animation: bounce 0.5s ease;
  }

  @keyframes bounce {
    0%, 100% { transform: scale(1); }
    50% { transform: scale(1.2); }
  }
</style>

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

  <script>
    window.showNotificationPopup = function(title, message) {
      console.log("🔔 showNotificationPopup called:", title, message);

      var popup = document.getElementById("notifPopup");
      if (!popup) {
        console.error("❌ Element #notifPopup not found!");
        return;
      }

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

      setTimeout(function() {
        popup.style.opacity = "0";
        setTimeout(function() {
          popup.style.display = "none";
        }, 500);
      }, 10000);

      console.log("✅ Notification popup displayed");
    };

    // Tạo hiệu ứng ripple khi click
    function createRipple(event) {
      const button = event.currentTarget;
      const ripple = document.createElement('span');
      const rect = button.getBoundingClientRect();
      const size = Math.max(rect.width, rect.height);
      const x = event.clientX - rect.left - size / 2;
      const y = event.clientY - rect.top - size / 2;

      ripple.style.width = ripple.style.height = size + 'px';
      ripple.style.left = x + 'px';
      ripple.style.top = y + 'px';
      ripple.classList.add('ripple');

      button.appendChild(ripple);

      setTimeout(() => {
        ripple.remove();
      }, 600);
    }

    // Xử lý active state cho sidebar
    document.addEventListener('DOMContentLoaded', function() {
      const currentPath = window.location.pathname;
      const sidebarLinks = document.querySelectorAll('.sidebar-link');

      // Thêm hiệu ứng ripple cho tất cả links
      sidebarLinks.forEach(link => {
        link.addEventListener('click', createRipple);

        // Kiểm tra active state
        const linkPath = link.getAttribute('data-path');
        if (linkPath && currentPath.includes(linkPath)) {
          link.classList.add('active');
        }
      });

      // Xử lý click để thêm class active
      sidebarLinks.forEach(link => {
        link.addEventListener('click', function(e) {
          // Không xử lý nếu là dropdown toggle
          if (this.classList.contains('dropdown-toggle')) {
            return;
          }

          // Xóa active khỏi tất cả links
          sidebarLinks.forEach(l => l.classList.remove('active'));

          // Thêm active vào link được click
          this.classList.add('active');
        });
      });
    });
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
          <span class="me-3 fs-5">🗑️</span>
          <span class="fw-semibold">Thùng rác</span>
        </a>
      </li>

      <li class="nav-item mb-2">
        <a href="${pageContext.request.contextPath}/reports"
           class="nav-link text-dark d-flex align-items-center py-3 px-3 rounded sidebar-link"
           data-path="/reports">
          <span class="me-3 fs-5">📑</span>
          <span class="fw-semibold">Báo cáo</span>
        </a>
      </li>

      <li class="nav-item mb-2">
        <a href="${pageContext.request.contextPath}/feedbacks"
           class="nav-link text-dark d-flex align-items-center py-3 px-3 rounded sidebar-link"
           data-path="/feedbacks">
          <span class="me-3 fs-5">🗂️</span>
          <span class="fw-semibold">Phản hồi</span>
        </a>
      </li>

      <li class="nav-item mb-2">
        <a href="${pageContext.request.contextPath}/chat/manager"
           class="nav-link text-dark d-flex align-items-center py-3 px-3 rounded sidebar-link"
           data-path="/chat/manager">
          <span class="me-3 fs-5">💬</span>
          <span class="fw-semibold">Chat với Admin</span>
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
         class="btn btn-outline-success btn-sm"
         style="transition: all 0.3s ease;">
        <i class="fas fa-sign-out-alt"></i>
      </a>
    </div>
  </div>
</div>