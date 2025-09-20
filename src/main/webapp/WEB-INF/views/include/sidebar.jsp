<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<div class="d-flex flex-column vh-100 bg-dark text-white position-fixed start-0 top-0" style="width: 250px; z-index: 1000;">
  <!-- Header -->
  <div class="p-4 border-bottom border-secondary">
    <h4 class="mb-0 text-primary fw-bold">
      🗑️ SmartBin
    </h4>
  </div>

  <!-- Navigation Menu -->
  <nav class="flex-grow-1 py-3">
    <ul class="nav nav-pills flex-column px-3" id="sidebar-menu">
      <li class="nav-item mb-2">
        <a href="${pageContext.request.contextPath}/manage"
           class="nav-link text-white d-flex align-items-center py-3 px-3 rounded sidebar-link"
           data-path="/manage">
          <span class="me-3 fs-5">📊</span>
          <span class="fw-semibold">Dashboard</span>
        </a>
      </li>

      <li class="nav-item mb-2">
        <a href="${pageContext.request.contextPath}/tasks/task-management"
           class="nav-link text-white d-flex align-items-center py-3 px-3 rounded sidebar-link"
           data-path="/tasks/task-management">
          <span class="me-3 fs-5">📋</span>
          <span class="fw-semibold">Giao nhiệm vụ</span>
        </a>
      </li>

      <li class="nav-item mb-2">
        <a href="${pageContext.request.contextPath}/bins"
           class="nav-link text-white d-flex align-items-center py-3 px-3 rounded sidebar-link"
           data-path="/bins">
          <span class="me-3 fs-5">🗑️</span>
          <span class="fw-semibold">Danh sách thùng rác</span>
        </a>
      </li>

      <li class="nav-item mb-2">
        <a href="${pageContext.request.contextPath}/reports"
           class="nav-link text-white d-flex align-items-center py-3 px-3 rounded sidebar-link"
           data-path="/reports">
          <span class="me-3 fs-5">⚠️</span>
          <span class="fw-semibold">Báo cáo</span>
        </a>
      </li>

      <li class="nav-item mb-2">
        <a href="${pageContext.request.contextPath}/users"
           class="nav-link text-white d-flex align-items-center py-3 px-3 rounded sidebar-link"
           data-path="/users">
          <span class="me-3 fs-5">👤</span>
          <span class="fw-semibold">Người dùng</span>
        </a>
      </li>

      <li class="nav-item mb-2">
        <a href="${pageContext.request.contextPath}/settings"
           class="nav-link text-white d-flex align-items-center py-3 px-3 rounded sidebar-link"
           data-path="/settings">
          <span class="me-3 fs-5">⚙️</span>
          <span class="fw-semibold">Cài đặt</span>
        </a>
      </li>
    </ul>
  </nav>

  <!-- User Info Footer -->
  <div class="mt-auto p-3 border-top border-secondary">
    <div class="d-flex align-items-center">
      <div class="bg-primary rounded-circle d-flex align-items-center justify-content-center me-3"
           style="width: 45px; height: 45px;">
        <span class="text-white fs-5">👤</span>
      </div>
      <div class="flex-grow-1">
        <div class="fw-bold small text-white">${sessionScope.user != null ? sessionScope.user.username : 'Manager'}</div>
        <div class="text-muted small">Quản trị viên</div>
      </div>
    </div>
  </div>
</div>

<script>
  document.addEventListener('DOMContentLoaded', function() {
    // Lấy đường dẫn hiện tại
    var currentPath = window.location.pathname;
    var contextPath = '${pageContext.request.contextPath}';

    // Loại bỏ context path để so sánh
    if (contextPath && currentPath.startsWith(contextPath)) {
      currentPath = currentPath.substring(contextPath.length);
    }

    // Tìm và đánh dấu menu item active
    var sidebarLinks = document.querySelectorAll('.sidebar-link');

    sidebarLinks.forEach(function(link) {
      var linkPath = link.getAttribute('data-path');

      // Kiểm tra exact match hoặc startsWith cho các sub-paths
      if (currentPath === linkPath ||
              (linkPath !== '/' && currentPath.startsWith(linkPath))) {

        // Xóa active class khỏi tất cả links
        sidebarLinks.forEach(function(l) {
          l.classList.remove('active', 'bg-primary');
        });

        // Thêm active class cho link hiện tại
        link.classList.add('active', 'bg-primary');
      }
    });

    // Thêm event listeners cho hover effect
    sidebarLinks.forEach(function(link) {
      link.addEventListener('mouseenter', function() {
        if (!this.classList.contains('active')) {
          this.style.backgroundColor = 'rgba(255, 255, 255, 0.1)';
        }
      });

      link.addEventListener('mouseleave', function() {
        if (!this.classList.contains('active')) {
          this.style.backgroundColor = '';
        }
      });
    });
  });
</script>