<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="d-flex flex-column vh-100 bg-white border-end position-fixed start-0 top-0" style="width: 250px; z-index: 1000;">
  <!-- Header -->
  <div class="p-4 border-bottom">
    <h4 class="mb-0 text-success fw-bold">
      ♻️ SmartBin Admin
    </h4>
    <small class="text-muted">Hệ thống quản trị SmartBin</small>
  </div>

  <!-- Navigation Menu -->
  <nav class="flex-grow-1 py-3">
    <ul class="nav nav-pills flex-column px-3" id="sidebar-menu">
      <li class="nav-item mb-2">
        <a href="${pageContext.request.contextPath}/admin/dashboard"
           class="nav-link text-dark d-flex align-items-center py-3 px-3 rounded sidebar-link"
           data-path="/admin/areas">
          <span class="me-3 fs-5">📊</span>
          <span class="fw-semibold">Dashboard</span>
        </a>
      </li>
      <li class="nav-item mb-2">
        <a href="${pageContext.request.contextPath}/admin/overview"
           class="nav-link text-dark d-flex align-items-center py-3 px-3 rounded sidebar-link"
           data-path="/admin/overview">
          <span class="me-3 fs-5">📍</span>
          <span class="fw-semibold">Khu vực</span>

        </a>
      </li>
      <!-- Địa điểm -->
      <li class="nav-item mb-2">
        <a href="${pageContext.request.contextPath}/admin/locations"
           class="nav-link text-dark d-flex align-items-center py-3 px-3 rounded sidebar-link"
           data-path="/admin/locations">
          <span class="me-3 fs-5">🗺️</span>
          <span class="fw-semibold">Địa điểm</span>
        </a>
      </li>


      <li class="nav-item mb-2">
        <a href="${pageContext.request.contextPath}/admin/accounts"
           class="nav-link text-dark d-flex align-items-center py-3 px-3 rounded sidebar-link"
           data-path="/admin/accounts">
          <span class="me-3 fs-5">🧑‍💼</span>
          <span class="fw-semibold">Tài khoản</span>
        </a>
      </li>



      <li class="nav-item mb-2">
        <a href="${pageContext.request.contextPath}/admin/applications"
           class="nav-link text-dark d-flex align-items-center py-3 px-3 rounded sidebar-link"
           data-path="/admin/applications">
          <span class="me-3 fs-5">📑</span>
          <span class="fw-semibold">Hợp đồng</span>
        </a>
      </li>

      <li class="nav-item mb-2">
        <a href="${pageContext.request.contextPath}/admin/reports"
           class="nav-link text-dark d-flex align-items-center py-3 px-3 rounded sidebar-link"
           data-path="/admin/reports">
          <span class="me-3 fs-5">📈</span>
          <span class="fw-semibold">Báo cáo</span>
        </a>
      </li>

      <li class="nav-item mb-2">
        <a href="${pageContext.request.contextPath}/chat/admin"
           class="nav-link text-dark d-flex align-items-center py-3 px-3 rounded sidebar-link"
           data-path="/chat/admin">
          <span class="me-3 fs-5">💬</span>
          <span class="fw-semibold">Chat</span>
        </a>
      </li>
    </ul>
  </nav>

  <!-- User Info Footer -->
  <div class="mt-auto p-3 border-top">
    <div class="d-flex align-items-center">
      <div class="bg-success rounded-circle d-flex align-items-center justify-content-center me-3"
           style="width: 45px; height: 45px;">
        <span class="text-white fs-5">👤</span>
      </div>
      <div class="flex-grow-1">
        <div class="fw-bold small text-dark">
          <c:choose>
            <c:when test="${not empty sessionScope.user}">
              ${sessionScope.user.username}
            </c:when>
            <c:otherwise>
              Admin
            </c:otherwise>
          </c:choose>
        </div>
        <div class="text-muted small">Quản trị viên</div>
      </div>
      <a href="${pageContext.request.contextPath}/logout"
         class="btn btn-outline-success btn-sm"
         title="Đăng xuất">
        <i class="fas fa-sign-out-alt"></i>
      </a>
    </div>
  </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>

<style>
  .sidebar-link {
    transition: all 0.3s ease;
    border: none;
    color: #333 !important;
  }

  .sidebar-link:hover {
    background-color: #f0f0f0 !important;
    transform: translateX(5px);
  }

  .sidebar-link.active {
    background-color: #28a745 !important;
    color: white !important;
    box-shadow: 0 2px 8px rgba(40, 167, 69, 0.3);
  }

  .sidebar-link.active span {
    color: white !important;
  }

  /* Border sáng */
  .border-end {
    border-right: 1px solid #dee2e6 !important;
  }

  .border-top {
    border-top: 1px solid #dee2e6 !important;
  }
</style>

<script>
  document.addEventListener('DOMContentLoaded', function() {
    var currentPath = window.location.pathname;
    var contextPath = '${pageContext.request.contextPath}';
    if (contextPath && currentPath.startsWith(contextPath)) {
      currentPath = currentPath.substring(contextPath.length);
    }

    if (!currentPath.startsWith('/')) currentPath = '/' + currentPath;

    document.querySelectorAll('.sidebar-link').forEach(function(link) {
      var linkPath = link.getAttribute('data-path');
      if (linkPath && (currentPath === linkPath || currentPath.startsWith(linkPath))) {
        link.classList.add('active');
      }
    });
  });
</script>
