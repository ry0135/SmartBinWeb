<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8" />
  <title>Trash Bin App - Giao nhiệm vụ</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    /* Reset CSS */
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
      font-family: 'Segoe UI', sans-serif;
    }

    html, body {
      height: 100%;
      background: #f8fafc;
    }

    /* Container chính */
    .container {
      display: flex;
      min-height: 100vh;
      height: 100%;
    }

    /* Sidebar - Chiều cao 100% */
    .sidebar {
      width: 280px;
      background: #fff;
      border-right: 1px solid #e2e8f0;
      display: flex;
      flex-direction: column;
      height: 100vh;
      position: fixed;
      left: 0;
      top: 0;
      bottom: 0;
      overflow-y: auto;
      box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
      z-index: 10;
    }

    .sidebar-header {
      padding: 24px 20px 20px;
      border-bottom: 1px solid #f1f5f9;
    }

    .sidebar h2 {
      font-size: 20px;
      color: #1e293b;
      font-weight: 700;
      display: flex;
      align-items: center;
      gap: 10px;
    }

    .sidebar h2 i {
      color: #3b82f6;
    }

    .menu {
      list-style: none;
      padding: 20px 0;
      flex-grow: 1;
    }

    .menu li {
      padding: 14px 24px;
      cursor: pointer;
      display: flex;
      align-items: center;
      color: #64748b;
      transition: all 0.3s ease;
      gap: 12px;
      font-weight: 500;
    }

    .menu li.active {
      background: #f1f5f9;
      color: #3b82f6;
      font-weight: 600;
      border-left: 4px solid #3b82f6;
      margin-left: -1px;
    }

    .menu li:hover {
      background: #f8fafc;
      color: #3b82f6;
    }

    /* Main content */
    .main {
      flex: 1;
      display: flex;
      flex-direction: column;
      margin-left: 280px;
      width: calc(100% - 280px);
      min-height: 100vh;
    }

    /* Header */
    .header {
      background: #fff;
      padding: 18px 32px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      border-bottom: 1px solid #e2e8f0;
      box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
    }

    .header h1 {
      margin: 0;
      font-size: 24px;
      color: #1e293b;
      font-weight: 700;
    }

    .user-info {
      display: flex;
      align-items: center;
      gap: 16px;
    }

    .notification-bell {
      position: relative;
      cursor: pointer;
      font-size: 20px;
      color: #64748b;
    }

    .notification-badge {
      position: absolute;
      top: -5px;
      right: -5px;
      background: #ef4444;
      color: white;
      border-radius: 50%;
      width: 18px;
      height: 18px;
      font-size: 12px;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .user-info img {
      width: 40px;
      height: 40px;
      border-radius: 50%;
      border: 2px solid #e2e8f0;
    }

    /* Content */
    .content-container {
      padding: 32px;
      flex: 1;
    }

    .page-header {
      margin-bottom: 24px;
    }

    .page-title {
      font-size: 28px;
      font-weight: 700;
      color: #1e293b;
      margin-bottom: 8px;
    }

    .page-subtitle {
      color: #64748b;
      font-size: 16px;
    }

    .assignment-card {
      background: #fff;
      border-radius: 16px;
      padding: 32px;
      box-shadow: 0 4px 6px rgba(0, 0, 0, 0.04);
      margin-bottom: 24px;
      border: 1px solid #f1f5f9;
    }

    .card-header {
      display: flex;
      align-items: center;
      gap: 12px;
      margin-bottom: 24px;
      padding-bottom: 16px;
      border-bottom: 2px solid #f1f5f9;
    }

    .card-icon {
      width: 48px;
      height: 48px;
      border-radius: 12px;
      background: linear-gradient(135deg, #3b82f6, #1d4ed8);
      display: flex;
      align-items: center;
      justify-content: center;
      color: white;
      font-size: 20px;
    }

    .card-title {
      font-size: 20px;
      font-weight: 600;
      color: #1e293b;
      margin: 0;
    }

    .bin-info {
      background: #f8fafc;
      padding: 16px;
      border-radius: 12px;
      margin-bottom: 24px;
      border-left: 4px solid #3b82f6;
    }

    .bin-info p {
      margin: 0;
      color: #475569;
      font-weight: 500;
    }

    .bin-id {
      font-weight: 700;
      color: #3b82f6;
    }

    /* Table */
    .workers-table {
      width: 100%;
      border-collapse: collapse;
      margin-bottom: 24px;
    }

    .workers-table th {
      background: #f8fafc;
      padding: 16px;
      text-align: left;
      font-weight: 600;
      color: #374151;
      border-bottom: 2px solid #e2e8f0;
    }

    .workers-table td {
      padding: 16px;
      border-bottom: 1px solid #f1f5f9;
      color: #4b5563;
    }

    .workers-table tr:hover {
      background: #f8fafc;
    }

    .radio-cell {
      width: 60px;
      text-align: center;
    }

    .radio-custom {
      width: 20px;
      height: 20px;
      border: 2px solid #d1d5db;
      border-radius: 50%;
      display: inline-block;
      position: relative;
      cursor: pointer;
      transition: all 0.3s ease;
    }

    input[type="radio"] {
      display: none;
    }

    input[type="radio"]:checked + .radio-custom {
      border-color: #3b82f6;
      background: #3b82f6;
    }

    input[type="radio"]:checked + .radio-custom::after {
      content: "";
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      width: 8px;
      height: 8px;
      background: white;
      border-radius: 50%;
    }

    .worker-name {
      font-weight: 600;
      color: #1e293b;
    }

    .worker-email {
      color: #6b7280;
      font-size: 14px;
    }

    .worker-ward {
      background: #e0f2fe;
      color: #0369a1;
      padding: 4px 12px;
      border-radius: 20px;
      font-size: 14px;
      font-weight: 500;
    }

    .task-count {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      padding: 4px 12px;
      border-radius: 20px;
      font-size: 14px;
      font-weight: 500;
    }

    .count-low {
      background: #dcfce7;
      color: #166534;
    }

    .count-medium {
      background: #fef3c7;
      color: #92400e;
    }

    .count-high {
      background: #fee2e2;
      color: #991b1b;
    }

    /* Notes section */
    .notes-section {
      margin-bottom: 24px;
    }

    .notes-label {
      display: block;
      font-weight: 600;
      color: #374151;
      margin-bottom: 8px;
    }

    .notes-textarea {
      width: 100%;
      padding: 16px;
      border: 1px solid #d1d5db;
      border-radius: 12px;
      resize: vertical;
      min-height: 100px;
      font-family: inherit;
      transition: all 0.3s ease;
    }

    .notes-textarea:focus {
      outline: none;
      border-color: #3b82f6;
      box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.15);
    }

    /* Buttons */
    .action-buttons {
      display: flex;
      gap: 16px;
    }

    .btn {
      padding: 12px 24px;
      border-radius: 10px;
      font-weight: 600;
      text-decoration: none;
      display: inline-flex;
      align-items: center;
      gap: 8px;
      transition: all 0.3s ease;
      border: none;
      cursor: pointer;
    }

    .btn-primary {
      background: linear-gradient(135deg, #3b82f6, #1d4ed8);
      color: white;
    }

    .btn-primary:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(37, 99, 235, 0.2);
    }

    .btn-secondary {
      background: #f1f5f9;
      color: #475569;
    }

    .btn-secondary:hover {
      background: #e2e8f0;
      transform: translateY(-2px);
    }

    /* Style cho form elements */
    .form-section {
      margin-bottom: 24px;
    }

    .form-row {
      display: flex;
      gap: 16px;
      margin-bottom: 16px;
    }

    .form-group {
      flex: 1;
    }

    .form-label {
      display: block;
      font-weight: 600;
      color: #374151;
      margin-bottom: 8px;
    }

    .form-select, .form-input {
      width: 100%;
      padding: 12px 16px;
      border: 1px solid #d1d5db;
      border-radius: 12px;
      font-family: inherit;
      transition: all 0.3s ease;
      background: white;
    }

    .form-select:focus, .form-input:focus {
      outline: none;
      border-color: #3b82f6;
      box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.15);
    }

    /* Thêm style cho thanh kéo độ ưu tiên */
    .priority-slider-container {
      position: relative;
      margin-top: 8px;
    }

    .priority-slider {
      -webkit-appearance: none;
      width: 100%;
      height: 8px;
      border-radius: 4px;
      background: linear-gradient(to right,
      #22c55e 0%,  /* Xanh lá - mức 1 */
      #22c55e 20%, /* Xanh lá - mức 1 */
      #84cc16 20%, /* Xanh lá nhạt - mức 2 */
      #84cc16 40%, /* Xanh lá nhạt - mức 2 */
      #eab308 40%, /* Vàng - mức 3 */
      #eab308 60%, /* Vàng - mức 3 */
      #f97316 60%, /* Cam - mức 4 */
      #f97316 80%, /* Cam - mức 4 */
      #ef4444 80%, /* Đỏ - mức 5 */
      #ef4444 100% /* Đỏ - mức 5 */
      );
      outline: none;
      margin-bottom: 25px;
    }

    .priority-slider::-webkit-slider-thumb {
      -webkit-appearance: none;
      appearance: none;
      width: 22px;
      height: 22px;
      border-radius: 50%;
      background: #3b82f6;
      cursor: pointer;
      border: 2px solid #fff;
      box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
    }

    .priority-slider::-moz-range-thumb {
      width: 22px;
      height: 22px;
      border-radius: 50%;
      background: #3b82f6;
      cursor: pointer;
      border: 2px solid #fff;
      box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
    }

    .priority-labels {
      display: flex;
      justify-content: space-between;
      position: absolute;
      width: 100%;
      bottom: -20px;
    }

    .priority-labels span {
      font-size: 12px;
      font-weight: 600;
      color: #64748b;
      width: 20px;
      height: 20px;
      display: flex;
      align-items: center;
      justify-content: center;
      border-radius: 50%;
      background: #f1f5f9;
    }

    #priority-value {
      color: #eab308; /* Màu mặc định cho mức 3 */
      font-weight: 700;
      transition: color 0.3s ease;
    }

    /* Responsive */
    @media (max-width: 1200px) {
      .sidebar {
        width: 240px;
      }

      .main {
        margin-left: 240px;
        width: calc(100% - 240px);
      }
    }

    @media (max-width: 992px) {
      .sidebar {
        width: 220px;
      }

      .main {
        margin-left: 220px;
        width: calc(100% - 220px);
      }

      .content-container {
        padding: 24px;
      }
    }

    @media (max-width: 768px) {
      .container {
        flex-direction: column;
      }

      .sidebar {
        position: relative;
        width: 100%;
        height: auto;
      }

      .main {
        margin-left: 0;
        width: 100%;
      }

      .header {
        padding: 16px 20px;
      }

      .content-container {
        padding: 20px;
      }

      .action-buttons {
        flex-direction: column;
      }

      .btn {
        width: 100%;
        justify-content: center;
      }

      .form-row {
        flex-direction: column;
        gap: 16px;
      }
    }
  </style>
</head>
<body>
<div class="container">
  <!-- Sidebar -->
  <%@ include file="manage-head.jsp" %>

  <!-- Main content -->
  <div class="main">
    <!-- Header -->
    <div class="header">
      <h1>Hệ thống quản lý thùng rác</h1>
      <div class="user-info">
        <div class="notification-bell">
          <i class="fas fa-bell"></i>
          <span class="notification-badge">3</span>
        </div>
        <span>Quản lý</span>
        <img src="https://i.pravatar.cc/150?img=3" alt="User">
      </div>
    </div>

    <!-- Content -->
    <div class="content-container">
      <div class="page-header">
        <h2 class="page-title">Giao nhiệm vụ mới</h2>
        <p class="page-subtitle">Danh sách nhân viên trong phường phù hợp</p>
      </div>

      <form action="${pageContext.request.contextPath}/tasks/assign" method="post">
        <input type="hidden" name="binId" value="${binId}"/>

        <div class="assignment-card">
          <div class="card-header">
            <div class="card-icon">
              <i class="fas fa-trash"></i>
            </div>
            <h3 class="card-title">Thông tin thùng rác</h3>
          </div>

          <div class="bin-info">
            <p>Đang giao nhiệm vụ của thùng rác<span class="bin-id">#${binId}</span></p>
          </div>

          <div class="form-section">
            <div class="form-row">
              <div class="form-group">
                <label class="form-label" for="taskType">
                  <i class="fas fa-tasks"></i> Loại nhiệm vụ
                </label>
                <select class="form-select" id="taskType" name="taskType" required>
                  <option value="COLLECTION">Thu gom rác</option>
                  <option value="MAINTENANCE">Bảo trì</option>
                </select>
              </div>

              <div class="form-group">
                <label class="form-label" for="priority">
                  <i class="fas fa-exclamation-circle"></i> Độ ưu tiên: <span id="priority-value">3 - Trung bình</span>
                </label>
                <div class="priority-slider-container">
                  <input type="range" id="priority" name="priority" min="1" max="5" value="3" class="priority-slider" required>
                  <div class="priority-labels">
                    <span>1</span>
                    <span>2</span>
                    <span>3</span>
                    <span>4</span>
                    <span>5</span>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <table class="workers-table">
            <thead>
            <tr>
              <th class="radio-cell">Chọn</th>
              <th>Nhân viên</th>
              <th>Phường</th>
              <th>Nhiệm vụ hiện tại</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="worker" items="${workers}">
              <tr>
                <td class="radio-cell">
                  <label>
                    <input type="radio" name="workerId" value="${worker.accountId}" required>
                    <span class="radio-custom"></span>
                  </label>
                </td>
                <td>
                  <div class="worker-name">${worker.fullName}</div>
                  <div class="worker-email">${worker.email}</div>
                </td>
                <td>
                  <span class="worker-ward">${worker.ward.wardName}</span>
                </td>
                <td>
                  <c:set var="taskCount" value="${worker.taskCount}" />
                  <span class="task-count
                      <c:choose>
                        <c:when test="${taskCount <= 2}">count-low</c:when>
                        <c:when test="${taskCount <= 5}">count-medium</c:when>
                        <c:otherwise>count-high</c:otherwise>
                      </c:choose>">
                      <i class="fas fa-tasks"></i> ${taskCount} nhiệm vụ
                    </span>
                </td>
              </tr>
            </c:forEach>
            </tbody>
          </table>

          <div class="notes-section">
            <label class="notes-label">
              <i class="fas fa-sticky-note"></i> Ghi chú nhiệm vụ
            </label>
            <textarea class="notes-textarea" id="notes" name="notes"
                      placeholder="Thêm ghi chú cho nhiệm vụ này..."></textarea>
          </div>

          <div class="action-buttons">
            <button type="submit" class="btn btn-primary">
              <i class="fas fa-paper-plane"></i> Giao nhiệm vụ
            </button>
            <a href="${pageContext.request.contextPath}/manage/bin/${binId}" class="btn btn-secondary">
              <i class="fas fa-times"></i> Hủy bỏ
            </a>
          </div>
        </div>
      </form>
    </div>
  </div>
</div>

<script>
  // Thêm hiệu ứng khi chọn nhân viên
  document.querySelectorAll('tr').forEach(row => {
    row.addEventListener('click', (e) => {
      // Chỉ xử lý khi không click vào radio button
      if (!e.target.closest('input[type="radio"]')) {
        const radio = row.querySelector('input[type="radio"]');
        if (radio) {
          radio.checked = true;
          // Cập nhật trạng thái visual
          document.querySelectorAll('tr').forEach(r => r.classList.remove('selected'));
          row.classList.add('selected');
        }
      }
    });
  });

  // Xử lý thanh kéo độ ưu tiên
  const prioritySlider = document.getElementById('priority');
  const priorityValue = document.getElementById('priority-value');

  // Các mô tả và màu sắc tương ứng với từng mức độ ưu tiên
  const priorityData = {
    1: { text: '1 - Rất thấp', color: '#22c55e' },
    2: { text: '2 - Thấp', color: '#84cc16' },
    3: { text: '3 - Trung bình', color: '#eab308' },
    4: { text: '4 - Cao', color: '#f97316' },
    5: { text: '5 - Rất cao', color: '#ef4444' }
  };

  // Cập nhật giá trị và màu sắc khi thanh kéo thay đổi
  prioritySlider.addEventListener('input', function() {
    const value = this.value;
    priorityValue.textContent = priorityData[value].text;
    priorityValue.style.color = priorityData[value].color;

    // Cập nhật màu của thumb
    const thumb = document.querySelector('.priority-slider::-webkit-slider-thumb');
    if (thumb) {
      thumb.style.background = priorityData[value].color;
    }

    // Đối với Firefox
    document.querySelectorAll('.priority-slider::-moz-range-thumb').forEach(thumb => {
      thumb.style.background = priorityData[value].color;
    });
  });

  // Kích hoạt sự kiện ngay khi trang load để hiển thị giá trị mặc định
  document.addEventListener('DOMContentLoaded', function() {
    prioritySlider.dispatchEvent(new Event('input'));
  });
</script>
</body>
</html>