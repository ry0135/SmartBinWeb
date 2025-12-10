<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
  <title>Giao lại Batch Thành công - SmartBin</title>

  <!-- Bootstrap 5 CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- Bootstrap Icons -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
  <!-- Font Awesome -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

  <style>
    :root {
      --success-color: #28a745;
      --success-light: #d4edda;
      --primary-color: #4361ee;
      --light-bg: #f8f9fa;
    }

    body {
      background: linear-gradient(135deg, #f5f7fb 0%, #e4edf5 100%);
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      min-height: 100vh;
    }

    .success-container {
      max-width: 800px;
      margin: 0 auto;
    }

    .success-card {
      background: white;
      border-radius: 16px;
      padding: 3rem;
      box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
      border: 1px solid #e9ecef;
      margin-top: 4rem;
      position: relative;
      overflow: hidden;
    }

    .success-card::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      height: 5px;
      background: linear-gradient(90deg, var(--success-color), #20c997);
    }

    .success-icon {
      width: 100px;
      height: 100px;
      background: linear-gradient(135deg, var(--success-color), #20c997);
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      margin: 0 auto 2rem;
      animation: bounceIn 0.8s ease;
    }

    .success-icon i {
      font-size: 3rem;
      color: white;
    }

    @keyframes bounceIn {
      0% { transform: scale(0.3); opacity: 0; }
      50% { transform: scale(1.05); }
      70% { transform: scale(0.9); }
      100% { transform: scale(1); opacity: 1; }
    }

    .success-title {
      color: var(--success-color);
      font-weight: 700;
      text-align: center;
      margin-bottom: 1rem;
    }

    .success-message {
      color: #495057;
      text-align: center;
      font-size: 1.1rem;
      line-height: 1.6;
      margin-bottom: 2rem;
    }

    .info-box {
      background: var(--success-light);
      border-left: 4px solid var(--success-color);
      padding: 1.5rem;
      border-radius: 8px;
      margin: 2rem 0;
    }

    .info-item {
      display: flex;
      align-items: center;
      margin-bottom: 1rem;
      padding-bottom: 1rem;
      border-bottom: 1px dashed #c3e6cb;
    }

    .info-item:last-child {
      margin-bottom: 0;
      padding-bottom: 0;
      border-bottom: none;
    }

    .info-icon {
      width: 40px;
      height: 40px;
      background: white;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      margin-right: 1rem;
      color: var(--success-color);
      font-size: 1.2rem;
    }

    .action-buttons {
      display: flex;
      justify-content: center;
      gap: 1rem;
      margin-top: 2rem;
      flex-wrap: wrap;
    }

    .btn-success-action {
      background: linear-gradient(135deg, var(--success-color), #20c997);
      border: none;
      padding: 0.75rem 2rem;
      font-weight: 600;
      border-radius: 8px;
      color: white;
      text-decoration: none;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      transition: all 0.3s ease;
    }

    .btn-success-action:hover {
      transform: translateY(-2px);
      box-shadow: 0 6px 12px rgba(40, 167, 69, 0.3);
      color: white;
    }

    .btn-outline-action {
      background: white;
      border: 2px solid var(--primary-color);
      padding: 0.75rem 2rem;
      font-weight: 600;
      border-radius: 8px;
      color: var(--primary-color);
      text-decoration: none;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      transition: all 0.3s ease;
    }

    .btn-outline-action:hover {
      background: var(--primary-color);
      color: white;
      transform: translateY(-2px);
    }

    .confetti {
      position: absolute;
      width: 10px;
      height: 10px;
      background: var(--success-color);
      border-radius: 50%;
      animation: confetti-fall 3s linear infinite;
    }

    @keyframes confetti-fall {
      0% {
        transform: translateY(-100px) rotate(0deg);
        opacity: 1;
      }
      100% {
        transform: translateY(100vh) rotate(720deg);
        opacity: 0;
      }
    }

    .next-steps {
      background: #f8f9fa;
      border-radius: 10px;
      padding: 1.5rem;
      margin-top: 2rem;
    }

    .step-item {
      display: flex;
      align-items: flex-start;
      margin-bottom: 1rem;
    }

    .step-number {
      width: 30px;
      height: 30px;
      background: var(--primary-color);
      color: white;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      font-weight: bold;
      margin-right: 1rem;
      flex-shrink: 0;
    }

    .error-container {
      background: white;
      border-radius: 16px;
      padding: 3rem;
      box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
      margin-top: 4rem;
      border-left: 5px solid #dc3545;
    }

    .error-icon {
      width: 80px;
      height: 80px;
      background: #dc3545;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      margin: 0 auto 2rem;
    }

    .error-icon i {
      font-size: 2.5rem;
      color: white;
    }

    @media (max-width: 768px) {
      .success-card {
        padding: 2rem 1.5rem;
        margin-top: 2rem;
      }

      .action-buttons {
        flex-direction: column;
      }

      .btn-success-action, .btn-outline-action {
        width: 100%;
        margin-bottom: 0.5rem;
      }
    }
  </style>
</head>

<body class="bg-light">
<div class="container-fluid">
  <div class="row">
    <%@include file="../include/sidebar.jsp"%>

    <main class="col-md-9 ms-sm-auto col-lg-10 px-4">
  <div class="success-container">
    <c:choose>
      <c:when test="${not empty message}">
        <!-- Success State -->
        <div class="success-card">
          <!-- Confetti Effect -->
          <div id="confetti-container"></div>

          <!-- Success Icon -->
          <div class="success-icon">
            <i class="bi bi-check-circle"></i>
          </div>

          <!-- Success Title -->
          <h1 class="success-title">
            <i class="bi bi-check-circle-fill me-2"></i>
            Thành Công!
          </h1>

          <!-- Success Message -->
          <div class="success-message">
            <p>Batch đã được giao lại thành công!</p>
            <p class="text-muted">Các nhiệm vụ lỗi đã được chuyển đến nhân viên mới và thông báo đã được gửi.</p>
          </div>

          <!-- Information Box -->
          <div class="info-box">
            <div class="info-item">
              <div class="info-icon">
                <i class="bi bi-check2-circle"></i>
              </div>
              <div>
                <h6 class="fw-bold mb-1">Batch mới đã được tạo</h6>
                <p class="mb-0 text-muted">Các task lỗi đã được chuyển sang batch mới với trạng thái OPEN</p>
              </div>
            </div>

            <div class="info-item">
              <div class="info-icon">
                <i class="bi bi-bell"></i>
              </div>
              <div>
                <h6 class="fw-bold mb-1">Thông báo đã gửi</h6>
                <p class="mb-0 text-muted">Nhân viên mới đã nhận được thông báo qua FCM và hệ thống</p>
              </div>
            </div>

            <div class="info-item">
              <div class="info-icon">
                <i class="bi bi-clock-history"></i>
              </div>
              <div>
                <h6 class="fw-bold mb-1">Lịch sử được lưu lại</h6>
                <p class="mb-0 text-muted">Task cũ đã được đánh dấu CANCELLED để lưu trữ lịch sử</p>
              </div>
            </div>
          </div>

          <!-- Next Steps -->
          <div class="next-steps">
            <h5 class="fw-bold mb-3">
              <i class="bi bi-arrow-right-circle me-2"></i>
              Bước tiếp theo
            </h5>

            <div class="step-item">
              <div class="step-number">1</div>
              <div>
                <p class="fw-bold mb-1">Theo dõi tiến độ</p>
                <p class="text-muted mb-0">Kiểm tra tiến độ thực hiện của nhân viên mới</p>
              </div>
            </div>

            <div class="step-item">
              <div class="step-number">2</div>
              <div>
                <p class="fw-bold mb-1">Quản lý batch</p>
                <p class="text-muted mb-0">Xem danh sách batch đang thực hiện</p>
              </div>
            </div>

            <div class="step-item">
              <div class="step-number">3</div>
              <div>
                <p class="fw-bold mb-1">Xem báo cáo</p>
                <p class="text-muted mb-0">Kiểm tra hiệu suất xử lý task</p>
              </div>
            </div>
          </div>

          <!-- Action Buttons -->
          <div class="action-buttons">
            <a href="${pageContext.request.contextPath}/tasks/issue" class="btn-success-action">
              <i class="bi bi-list-check me-2"></i>
              Xem danh sách Batch lỗi
            </a>

            <a href="${pageContext.request.contextPath}/tasks/doing" class="btn-outline-action">
              <i class="bi bi-activity me-2"></i>
              Xem Batch đang thực hiện
            </a>

            <a href="${pageContext.request.contextPath}/tasks/task-management" class="btn-outline-action">
              <i class="bi bi-plus-circle me-2"></i>
              Tạo task mới
            </a>
          </div>

          <!-- Quick Links -->
          <div class="text-center mt-4">
            <small class="text-muted">
              <i class="bi bi-lightning-charge me-1"></i>
              Điều hướng nhanh:
              <a href="${pageContext.request.contextPath}/dashboard" class="text-decoration-none ms-2">Dashboard</a> •
              <a href="${pageContext.request.contextPath}/tasks/open" class="text-decoration-none ms-1">Task mở</a> •
              <a href="${pageContext.request.contextPath}/tasks/completed" class="text-decoration-none ms-1">Task hoàn thành</a>
            </small>
          </div>
        </div>
      </c:when>

      <c:when test="${not empty error}">
        <!-- Error State -->
        <div class="error-container">
          <div class="error-icon">
            <i class="bi bi-x-circle"></i>
          </div>

          <h1 class="text-danger text-center mb-3">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>
            Đã xảy ra lỗi
          </h1>

          <div class="alert alert-danger" role="alert">
            <h4 class="alert-heading">
              <i class="bi bi-bug me-2"></i>
              Không thể giao lại batch
            </h4>
            <p>${error}</p>
            <hr>
            <p class="mb-0">Vui lòng thử lại hoặc liên hệ quản trị viên nếu lỗi tiếp tục xảy ra.</p>
          </div>

          <div class="action-buttons">
            <a href="${pageContext.request.contextPath}/tasks/batchIssue/${param.batchId}"
               class="btn-success-action">
              <i class="bi bi-arrow-left me-2"></i>
              Quay lại trang batch
            </a>

            <a href="${pageContext.request.contextPath}/tasks/issue" class="btn-outline-action">
              <i class="bi bi-list-check me-2"></i>
              Danh sách batch lỗi
            </a>
          </div>

          <!-- Troubleshooting -->
          <div class="mt-4">
            <h6 class="fw-bold">
              <i class="bi bi-wrench me-2"></i>
              Khắc phục sự cố:
            </h6>
            <ul class="text-muted">
              <li>Kiểm tra kết nối mạng</li>
              <li>Đảm bảo nhân viên vẫn đang hoạt động</li>
              <li>Kiểm tra quyền truy cập</li>
              <li>Liên hệ quản trị viên nếu cần hỗ trợ</li>
            </ul>
          </div>
        </div>
      </c:when>

      <c:otherwise>
        <!-- Default/No Message State -->
        <div class="success-card">
          <div class="success-icon" style="background: #6c757d;">
            <i class="bi bi-question-circle"></i>
          </div>

          <h1 class="text-center mb-3">Không có thông tin</h1>

          <div class="alert alert-info" role="alert">
            <h4 class="alert-heading">
              <i class="bi bi-info-circle me-2"></i>
              Không có dữ liệu
            </h4>
            <p>Không có thông tin thành công hoặc lỗi để hiển thị.</p>
          </div>

          <div class="action-buttons">
            <a href="${pageContext.request.contextPath}/tasks/issue" class="btn-success-action">
              <i class="bi bi-arrow-left me-2"></i>
              Quay lại
            </a>
          </div>
        </div>
      </c:otherwise>
    </c:choose>
  </div>

  </main>
</div>
</div>

<!-- Bootstrap JS Bundle with Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Confetti Animation Script -->
<script>
  document.addEventListener('DOMContentLoaded', function() {
    // Only create confetti if success message exists
    if (document.querySelector('.success-title')) {
      createConfetti();
    }

    // Auto redirect after 10 seconds (optional)
    setTimeout(function() {
      // Uncomment below to enable auto redirect
      // window.location.href = '${pageContext.request.contextPath}/tasks/issue';
    }, 10000);
  });

  function createConfetti() {
    const container = document.getElementById('confetti-container');
    const colors = ['#28a745', '#20c997', '#0ca678', '#12b886', '#38d9a9'];

    for (let i = 0; i < 50; i++) {
      const confetti = document.createElement('div');
      confetti.className = 'confetti';

      // Random properties
      const size = Math.random() * 10 + 5;
      const color = colors[Math.floor(Math.random() * colors.length)];
      const left = Math.random() * 100;
      const delay = Math.random() * 3;
      const duration = Math.random() * 2 + 2;

      // Apply styles
      confetti.style.width = `${size}px`;
      confetti.style.height = `${size}px`;
      confetti.style.backgroundColor = color;
      confetti.style.left = `${left}%`;
      confetti.style.animationDelay = `${delay}s`;
      confetti.style.animationDuration = `${duration}s`;

      container.appendChild(confetti);

      // Remove confetti after animation
      setTimeout(() => {
        confetti.remove();
      }, (delay + duration) * 1000);
    }

    // Create more confetti every 500ms for 3 seconds
    let interval = setInterval(() => {
      createMoreConfetti();
    }, 500);

    // Stop creating after 3 seconds
    setTimeout(() => {
      clearInterval(interval);
    }, 3000);
  }

  function createMoreConfetti() {
    const container = document.getElementById('confetti-container');
    const colors = ['#28a745', '#20c997', '#0ca678', '#12b886', '#38d9a9'];

    for (let i = 0; i < 5; i++) {
      const confetti = document.createElement('div');
      confetti.className = 'confetti';

      const size = Math.random() * 8 + 3;
      const color = colors[Math.floor(Math.random() * colors.length)];
      const left = Math.random() * 100;
      const delay = Math.random() * 1;
      const duration = Math.random() * 1.5 + 1.5;

      confetti.style.width = `${size}px`;
      confetti.style.height = `${size}px`;
      confetti.style.backgroundColor = color;
      confetti.style.left = `${left}%`;
      confetti.style.animationDelay = `${delay}s`;
      confetti.style.animationDuration = `${duration}s`;

      container.appendChild(confetti);

      setTimeout(() => {
        if (confetti.parentNode) {
          confetti.remove();
        }
      }, (delay + duration) * 1000);
    }
  }
</script>
</body>
</html>