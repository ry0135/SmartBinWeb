<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="d-flex flex-column vh-100 bg-white border-end position-fixed start-0 top-0" style="width: 250px; z-index: 1000;">
  <!-- Header -->
  <div class="p-4 border-bottom">
    <h4 class="mb-0 text-success fw-bold">
      🗑️ SmartBin
    </h4>
    <small class="text-muted">Quản lý thùng rác thông minh</small>
  </div>

  <!-- Navigation Menu -->
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

      <!-- Menu Quản lý Task -->
      <li class="nav-item mb-2">
        <div class="dropdown">
          <a href="#" class="nav-link text-dark d-flex align-items-center py-3 px-3 rounded sidebar-link dropdown-toggle"
             data-bs-toggle="dropdown" data-path="/tasks">
            <span class="me-3 fs-5">📋</span>
            <span class="fw-semibold">Quản lý Task</span>
          </a>
          <ul class="dropdown-menu bg-white border">
            <li>
              <a href="${pageContext.request.contextPath}/tasks/task-management"
                 class="dropdown-item text-dark d-flex align-items-center sidebar-link"
                 data-path="/tasks/task-management">
                <span class="me-2">🎯</span>
                <span>Giao nhiệm vụ</span>
              </a>
            </li>
            <li>
              <a href="${pageContext.request.contextPath}/tasks/maintenance-management?type=maintain"
                 class="dropdown-item text-dark d-flex align-items-center sidebar-link"
                 data-path="/tasks/maintenance-management">
                <span class="me-2">🔧</span>
                <span>Bảo trì</span>
              </a>
            </li>
            <li>
              <a href="${pageContext.request.contextPath}/tasks/open"
                 class="dropdown-item text-dark d-flex align-items-center sidebar-link"
                 data-path="/tasks/management">
                <span class="me-2">📊</span>
                <span>Quản lý nhiệm vụ</span>
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
           class="nav-link text-white d-flex align-items-center py-3 px-3 rounded sidebar-link"
           data-path="/feedbacks">
          <span class="me-3 fs-5">🗂️</span>
          <span class="fw-semibold">Phản Hồi</span>
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
              Manager
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

  .dropdown-menu {
    min-width: 200px;
  }

  .dropdown-item {
    transition: all 0.2s ease;
    color: #333 !important;
  }

  .dropdown-item:hover {
    background-color: #f0f0f0 !important;
    padding-left: 20px !important;
  }

  .dropdown-item.active {
    background-color: #28a745 !important;
    color: white !important;
  }

  .nav-item .dropdown-toggle::after {
    margin-left: auto;
  }

  /* Border cho sidebar */
  .border-end {
    border-right: 1px solid #dee2e6 !important;
  }
</style>

<script>
  document.addEventListener('DOMContentLoaded', function() {
    // Lấy đường dẫn hiện tại
    var currentPath = window.location.pathname;
    var contextPath = '${pageContext.request.contextPath}';

    // Loại bỏ context path để so sánh
    if (contextPath && currentPath.startsWith(contextPath)) {
      currentPath = currentPath.substring(contextPath.length);
    }

    // Đảm bảo có dấu / ở đầu
    if (!currentPath.startsWith('/')) {
      currentPath = '/' + currentPath;
    }

    console.log('Current Path:', currentPath);

    // Tìm và đánh dấu menu item active
    var sidebarLinks = document.querySelectorAll('.sidebar-link');

    sidebarLinks.forEach(function(link) {
      var linkPath = link.getAttribute('data-path');

      if (linkPath) {
        // Kiểm tra exact match hoặc startsWith cho các sub-paths
        var isActive = currentPath === linkPath ||
                (linkPath !== '/' && currentPath.startsWith(linkPath)) ||
                (currentPath.startsWith('/tasks') && linkPath === '/tasks');

        if (isActive) {
          link.classList.add('active');
          link.style.color = 'white !important';

          // Mở dropdown nếu có
          var dropdown = link.closest('.dropdown');
          if (dropdown) {
            var dropdownToggle = dropdown.querySelector('.dropdown-toggle');
            if (dropdownToggle) {
              dropdownToggle.classList.add('active');
            }
          }
        }
      }
    });

    // Thêm event listeners cho hover effect
    sidebarLinks.forEach(function(link) {
      link.addEventListener('mouseenter', function() {
        if (!this.classList.contains('active')) {
          this.style.backgroundColor = '#f0f0f0';
        }
      });

      link.addEventListener('mouseleave', function() {
        if (!this.classList.contains('active')) {
          this.style.backgroundColor = '';
        }
      });
    });

    // Xử lý dropdown
    var dropdownToggles = document.querySelectorAll('.dropdown-toggle');
    dropdownToggles.forEach(function(toggle) {
      toggle.addEventListener('click', function(e) {
        e.preventDefault();
        var dropdown = this.closest('.dropdown');
        var menu = dropdown.querySelector('.dropdown-menu');

        // Đóng tất cả dropdown khác
        document.querySelectorAll('.dropdown-menu').forEach(function(otherMenu) {
          if (otherMenu !== menu) {
            otherMenu.classList.remove('show');
          }
        });

        // Toggle menu hiện tại
        menu.classList.toggle('show');
      });
    });

    // Đóng dropdown khi click ra ngoài
    document.addEventListener('click', function(e) {
      if (!e.target.closest('.dropdown')) {
        document.querySelectorAll('.dropdown-menu').forEach(function(menu) {
          menu.classList.remove('show');
        });
      }
    });
  });
</script>