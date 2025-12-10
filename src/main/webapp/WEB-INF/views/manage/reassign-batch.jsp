<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html>
<head>
  <title>Giao lại batch</title>

  <link rel="stylesheet"
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
  <link rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>

  <style>
    body {
      background-color: #f8f9fa;
    }

    .content {
      margin-left: 250px;
    }

    .card {
      border: none;
      box-shadow: 0 0.125rem 0.25rem rgba(0,0,0,.075);
    }

    .card-header {
      background: linear-gradient(135deg, #10b981 0%, #059669 100%);
      border: none;
      padding: 1rem 1.25rem;
    }

    .card-header h6 {
      margin: 0;
      color: white;
      font-weight: 600;
    }

    .task-table {
      margin-bottom: 0;
    }

    .task-table thead th {
      background-color: #f8f9fa;
      border-bottom: 2px solid #dee2e6;
      font-weight: 600;
      font-size: 0.85rem;
      text-transform: uppercase;
      color: #495057;
      padding: 1rem;
    }

    .task-table tbody tr {
      transition: all 0.2s ease;
    }

    .task-table tbody tr:hover {
      background-color: #f8f9fa;
      transform: translateY(-1px);
      box-shadow: 0 0.25rem 0.5rem rgba(0,0,0,.05);
    }

    .task-table tbody td {
      padding: 1rem;
      vertical-align: middle;
      border-color: #dee2e6;
    }

    .bin-badge {
      background: linear-gradient(135deg, #10b981 0%, #059669 100%);
      color: white;
      padding: 0.4rem 0.8rem;
      border-radius: 6px;
      font-weight: 600;
      font-size: 0.85rem;
      display: inline-block;
    }

    .priority-badge {
      padding: 0.4rem 0.8rem;
      border-radius: 6px;
      font-weight: 600;
      font-size: 0.85rem;
      color: white;
      display: inline-flex;
      align-items: center;
      gap: 0.35rem;
    }

    .priority-5 { background-color: #dc3545; }
    .priority-4 { background-color: #fd7e14; }
    .priority-3 { background-color: #ffc107; color: #2d3748; }
    .priority-2 { background-color: #20c997; }
    .priority-1 { background-color: #6c757d; }

    .task-type-badge {
      padding: 0.4rem 0.8rem;
      border-radius: 6px;
      font-weight: 600;
      font-size: 0.85rem;
      display: inline-flex;
      align-items: center;
      gap: 0.35rem;
    }

    .task-type-maintenance {
      background-color: #dbeafe;
      color: #1e40af;
    }

    .task-type-collection {
      background-color: #dcfce7;
      color: #166534;
    }

    .status-badge {
      display: inline-flex;
      align-items: center;
      gap: 0.35rem;
      padding: 0.4rem 0.8rem;
      border-radius: 6px;
      font-weight: 600;
      font-size: 0.85rem;
      background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
      color: white;
    }

    .form-label {
      font-weight: 600;
      color: #495057;
      margin-bottom: 0.5rem;
      font-size: 0.9rem;
    }

    .form-select, .form-control {
      border: 1px solid #dee2e6;
      border-radius: 6px;
      padding: 0.625rem 0.875rem;
      font-size: 0.9rem;
    }

    .form-select:focus, .form-control:focus {
      border-color: #10b981;
      box-shadow: 0 0 0 0.2rem rgba(16, 185, 129, 0.15);
    }

    .alert-info {
      background-color: #e7f3ff;
      border-color: #b3d9ff;
      color: #004085;
      border-left: 4px solid #0066cc;
    }

    .btn-primary {
      background: linear-gradient(135deg, #10b981 0%, #059669 100%);
      border: none;
      padding: 0.625rem 1.5rem;
      font-weight: 600;
    }

    .btn-primary:hover {
      background: linear-gradient(135deg, #059669 0%, #047857 100%);
      transform: translateY(-1px);
      box-shadow: 0 0.25rem 0.5rem rgba(16, 185, 129, 0.3);
    }

    .btn-outline-secondary {
      border-color: #6c757d;
      color: #6c757d;
      font-weight: 600;
    }

    .btn-outline-secondary:hover {
      background-color: #6c757d;
      border-color: #6c757d;
    }

    /* Pagination Styles */
    .btn-group-sm > .btn {
      padding: 0.25rem 0.5rem;
      font-size: 0.8rem;
    }

    .table-responsive::-webkit-scrollbar {
      height: 6px;
    }

    .table-responsive::-webkit-scrollbar-track {
      background: #f1f1f1;
      border-radius: 10px;
    }

    .table-responsive::-webkit-scrollbar-thumb {
      background: #888;
      border-radius: 10px;
    }

    .table-responsive::-webkit-scrollbar-thumb:hover {
      background: #555;
    }

    @media (max-width: 768px) {
      .content {
        margin-left: 0;
      }

      .task-table {
        font-size: 0.85rem;
      }
    }
  </style>
</head>

<body>
<!-- Sidebar -->
<%@include file="../include/sidebar.jsp"%>

<!-- Main Content -->
<div class="content">
  <div class="p-4">
    <div class="row justify-content-center">
      <div class="col-lg-10">

        <!-- Page Header -->
        <div class="mb-4">
          <div class="d-flex align-items-center justify-content-between">
            <div>
              <h4 class="mb-2 text-dark fw-bold">
                <i class="fas fa-redo-alt text-success me-2"></i>
                Giao lại Batch: <span class="text-success">${batchId}</span>
              </h4>
              <p class="text-muted mb-0 small">Chọn nhân viên mới và giao lại các nhiệm vụ lỗi</p>
            </div>
            <a href="${pageContext.request.contextPath}/tasks/task-management"
               class="btn btn-outline-secondary btn-sm">
              <i class="fas fa-arrow-left me-2"></i>Quay lại
            </a>
          </div>
        </div>

        <!-- Alert Info -->
        <div class="alert alert-info d-flex align-items-center mb-4" role="alert">
          <i class="fas fa-info-circle me-2"></i>
          <div>Các nhiệm vụ dưới đây đã gặp lỗi và cần được giao lại cho nhân viên khác</div>
        </div>

        <!-- Task List Card -->
        <div class="card mb-4">
          <div class="card-header">
            <div class="d-flex align-items-center">
              <i class="fas fa-tasks me-2"></i>
              <h6>Danh sách nhiệm vụ lỗi trong batch (${fn:length(tasks)} nhiệm vụ)</h6>
            </div>
          </div>
          <div class="card-body p-0">
            <div class="table-responsive">
              <table class="table table-hover task-table">
                <thead>
                <tr class="text-center">
                  <th><i class="fas fa-hashtag me-1"></i>Mã Task</th>
                  <th><i class="fas fa-trash-alt me-1"></i>Thùng rác</th>
                  <th><i class="fas fa-briefcase me-1"></i>Loại nhiệm vụ</th>
                  <th><i class="fas fa-star me-1"></i>Độ ưu tiên</th>
                  <th><i class="fas fa-info-circle me-1"></i>Trạng thái</th>
                </tr>
                </thead>
                <tbody id="tasksList">
                <c:forEach var="t" items="${tasks}">
                  <tr class="text-center task-item">
                    <td><strong class="text-primary">${t.taskID}</strong></td>
                    <td><span class="bin-badge">Bin #${t.bin.binID}</span></td>
                    <td>
                      <c:choose>
                        <c:when test="${t.taskType == 'MAINTENANCE'}">
                            <span class="task-type-badge task-type-maintenance">
                              <i class="fas fa-wrench"></i>Bảo trì
                            </span>
                        </c:when>
                        <c:when test="${t.taskType == 'COLLECTION'}">
                            <span class="task-type-badge task-type-collection">
                              <i class="fas fa-hand-holding"></i>Thu gom
                            </span>
                        </c:when>
                        <c:otherwise>
                          <span class="task-type-badge">${t.taskType}</span>
                        </c:otherwise>
                      </c:choose>
                    </td>
                    <td>
                        <span class="priority-badge priority-${t.priority}">
                          <i class="fas fa-flag"></i>Mức ${t.priority}
                        </span>
                    </td>
                    <td>
                        <span class="status-badge">
                          <i class="fas fa-times-circle"></i>Lỗi
                        </span>
                    </td>
                  </tr>
                </c:forEach>
                </tbody>
              </table>
            </div>

            <!-- Task Pagination -->
            <c:if test="${fn:length(tasks) > 8}">
              <div class="d-flex justify-content-between align-items-center p-3 border-top">
                <small class="text-muted">
                  Hiển thị <span id="taskShowingStart">1</span>-<span id="taskShowingEnd">8</span>
                  trong <span id="taskTotal">${fn:length(tasks)}</span>
                </small>
                <div id="taskPagination" class="btn-group btn-group-sm"></div>
              </div>
            </c:if>
          </div>
        </div>

        <!-- Reassign Form -->
        <form method="post" action="${pageContext.request.contextPath}/tasks/assign/retry-batch">
          <input type="hidden" name="batchId" value="${batchId}"/>

          <div class="card mb-4">
            <div class="card-header">
              <div class="d-flex align-items-center">
                <i class="fas fa-user-check me-2"></i>
                <h6>Chọn nhân viên mới</h6>
              </div>
            </div>
            <div class="card-body p-4">
              <div class="row g-4">
                <div class="col-md-6">
                  <label class="form-label">
                    <i class="fas fa-user text-success me-1"></i>Nhân viên
                  </label>
                  <select class="form-select" name="newWorkerId" required>
                    <option value="">-- Chọn nhân viên --</option>
                    <c:forEach var="w" items="${workers}">
                      <option value="${w.accountId}">
                          ${w.fullName} (ID: ${w.accountId})
                      </option>
                    </c:forEach>
                  </select>
                </div>

                <div class="col-md-6">
                  <label class="form-label">
                    <i class="fas fa-tasks text-success me-1"></i>Loại nhiệm vụ
                  </label>
                  <div class="p-3 bg-light rounded">
                    <div class="d-flex align-items-center">
                      <i class="fas fa-recycle text-success me-2"></i>
                      <span class="fw-semibold">Giao lại batch</span>
                    </div>
                  </div>
                </div>

                <div class="col-12">
                  <label class="form-label">
                    <i class="fas fa-comment text-success me-1"></i>Ghi chú nhiệm vụ
                  </label>
                  <textarea name="notes" rows="4" class="form-control"
                            placeholder="Nhập ghi chú về lý do giao lại hoặc hướng dẫn đặc biệt..."
                            style="resize: none;">${tasks[0].notes}</textarea>
                </div>
              </div>
            </div>
          </div>

          <!-- Action Buttons -->
          <div class="d-flex gap-3 justify-content-end mb-4">
            <button type="button" class="btn btn-outline-secondary px-4" onclick="window.history.back()">
              <i class="fas fa-times me-2"></i>Hủy bỏ
            </button>
            <button type="submit" class="btn btn-primary px-4">
              <i class="fas fa-rocket me-2"></i>Giao lại toàn bộ batch
            </button>
          </div>
        </form>

      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
  // Pagination configuration for tasks
  const TASK_ITEMS_PER_PAGE = 8;
  let currentTaskPage = 1;
  let allTaskItems = Array.from(document.querySelectorAll('.task-item'));

  // Task Pagination
  function updateTaskPagination() {
    if (allTaskItems.length <= TASK_ITEMS_PER_PAGE) return;

    const totalPages = Math.ceil(allTaskItems.length / TASK_ITEMS_PER_PAGE);
    const start = (currentTaskPage - 1) * TASK_ITEMS_PER_PAGE;
    const end = Math.min(start + TASK_ITEMS_PER_PAGE, allTaskItems.length);

    document.getElementById('taskShowingStart').textContent = start + 1;
    document.getElementById('taskShowingEnd').textContent = end;
    document.getElementById('taskTotal').textContent = allTaskItems.length;

    allTaskItems.forEach(function(item, index) {
      item.style.display = (index >= start && index < end) ? 'table-row' : 'none';
    });

    const pagination = document.getElementById('taskPagination');
    pagination.innerHTML = '';

    if (totalPages > 1) {
      const prevBtn = document.createElement('button');
      prevBtn.type = 'button';
      prevBtn.className = 'btn btn-outline-secondary';
      prevBtn.innerHTML = '<i class="fas fa-chevron-left"></i>';
      prevBtn.disabled = currentTaskPage == 1;
      prevBtn.onclick = function() {
        if (currentTaskPage > 1) {
          currentTaskPage--;
          updateTaskPagination();
        }
      };
      pagination.appendChild(prevBtn);

      for (let i = 1; i <= totalPages; i++) {
        if (i == 1 || i == totalPages || (i >= currentTaskPage - 1 && i <= currentTaskPage + 1)) {
          const btn = document.createElement('button');
          btn.type = 'button';
          btn.className = i == currentTaskPage ? 'btn btn-primary' : 'btn btn-outline-secondary';
          btn.textContent = i;
          btn.onclick = function() {
            currentTaskPage = i;
            updateTaskPagination();
          };
          pagination.appendChild(btn);
        } else if (i == currentTaskPage - 2 || i == currentTaskPage + 2) {
          const span = document.createElement('span');
          span.className = 'btn btn-outline-secondary disabled';
          span.textContent = '...';
          pagination.appendChild(span);
        }
      }

      const nextBtn = document.createElement('button');
      nextBtn.type = 'button';
      nextBtn.className = 'btn btn-outline-secondary';
      nextBtn.innerHTML = '<i class="fas fa-chevron-right"></i>';
      nextBtn.disabled = currentTaskPage == totalPages;
      nextBtn.onclick = function() {
        if (currentTaskPage < totalPages) {
          currentTaskPage++;
          updateTaskPagination();
        }
      };
      pagination.appendChild(nextBtn);
    }
  }

  // Initialize
  document.addEventListener('DOMContentLoaded', function() {
    if (allTaskItems.length > TASK_ITEMS_PER_PAGE) {
      updateTaskPagination();
    }
  });
</script>
</body>
</html>