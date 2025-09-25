<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html>
<%@include file="../include/head.jsp"%>
<body>

<!-- Sidebar -->
<%@include file="../include/sidebar.jsp"%>

<!-- Main Content -->
<div class="flex-grow-1" style="margin-left: 250px;">
  <!-- Header -->


  <!-- Content -->
  <div class="content p-4">
    <div class="row justify-content-center">
      <div class="col-lg-10">
        <!-- Page Header -->
        <div class="mb-4">
          <h2 class="h3 mb-2 text-dark">Giao nhiệm vụ bảo trì</h2>
          <p class="text-muted mb-0">Danh sách nhân viên trong phường phù hợp</p>
        </div>

        <!-- Assignment Form -->
        <form action="${pageContext.request.contextPath}/tasks/assign/batch/process1" method="post">
          <c:forEach var="binId" items="${binIds}">
            <input type="hidden" name="binIds" value="${binId}">
          </c:forEach>

          <!-- Main Card -->
          <div class="card border-0 shadow-sm">
            <!-- Card Header -->
            <div class="card-header bg-white border-bottom py-3">
              <div class="d-flex align-items-center">
                <div class="bg-primary text-white rounded-3 p-2 me-3">
                  <i class="fas fa-trash"></i>
                </div>
                <h5 class="mb-0 text-dark">Thông tin thùng rác</h5>
              </div>
            </div>

            <div class="card-body p-4">
              <!-- Bin Info -->
              <div class="alert alert-info mb-4">
                <p class="mb-0">
                  Đang giao nhiệm vụ của thùng rác
                  <span class="badge bg-primary">#${binId}</span>
                </p>
              </div>

              <!-- Form Section -->
              <div class="row g-4 mb-4">
                <div class="col-md-6">
                  <label class="form-label fw-semibold" for="taskType">
                    <i class="fas fa-tasks me-1"></i> Loại nhiệm vụ
                  </label>
                  <select class="form-select" id="taskType" name="taskType" required>
                    <option value="MAINTENANCE">Bảo trì</option>
                  </select>
                </div>

                <div class="col-md-6">
                  <label class="form-label fw-semibold" for="priority">
                    <i class="fas fa-exclamation-circle me-1"></i>
                    Độ ưu tiên: <span id="priority-value" class="text-warning">3 - Trung bình</span>
                  </label>
                  <div class="mt-2">
                    <input type="range" class="form-range" id="priority" name="priority"
                           min="1" max="5" value="3" required>
                    <div class="d-flex justify-content-between mt-1">
                      <small class="text-muted">1</small>
                      <small class="text-muted">2</small>
                      <small class="text-muted">3</small>
                      <small class="text-muted">4</small>
                      <small class="text-muted">5</small>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Workers Table -->
              <div class="table-responsive mb-4">
                <table class="table table-hover">
                  <thead class="table-light">
                  <tr>
                    <th width="60" class="text-center">Chọn</th>
                    <th>Nhân viên</th>
                    <th>Phường</th>
                    <th>Nhiệm vụ hiện tại</th>
                  </tr>
                  </thead>
                  <tbody>
                  <c:forEach var="worker" items="${workers}">
                    <tr class="worker-row" style="cursor: pointer;">
                      <td class="text-center">
                        <div class="form-check">
                          <input class="form-check-input" type="radio"
                                 name="workerId" value="${worker.accountId}" required>
                        </div>
                      </td>
                      <td>
                        <div>
                          <div class="fw-semibold text-dark">${worker.fullName}</div>
                          <small class="text-muted">${worker.email}</small>
                        </div>
                      </td>
                      <td>
                        <span class="badge bg-light text-dark">${worker.ward.wardName}</span>
                      </td>
                      <td>
                        <c:set var="taskCount" value="${worker.taskCount}" />
                        <span class="badge ${taskCount <= 2 ? 'bg-success' : taskCount <= 5 ? 'bg-warning' : 'bg-danger'}">
                                                    <i class="fas fa-tasks me-1"></i> ${taskCount} nhiệm vụ
                                                </span>
                      </td>
                    </tr>
                  </c:forEach>
                  </tbody>
                </table>
              </div>

              <!-- Notes Section -->
              <div class="mb-4">
                <label class="form-label fw-semibold" for="notes">
                  <i class="fas fa-sticky-note me-1"></i> Ghi chú nhiệm vụ
                </label>
                <textarea class="form-control" id="notes" name="notes" rows="4"
                          placeholder="Thêm ghi chú cho nhiệm vụ này..."></textarea>
              </div>

              <!-- Action Buttons -->
              <div class="d-flex gap-3">
                <button type="submit" class="btn btn-primary">
                  <i class="fas fa-paper-plane me-2"></i> Giao nhiệm vụ
                </button>
                <a href="${pageContext.request.contextPath}/tasks/task-management"
                   class="btn btn-secondary">
                  <i class="fas fa-times me-2"></i> Hủy bỏ
                </a>
              </div>
            </div>
          </div>
        </form>
      </div>
    </div>
  </div>
</div>

<script>
  // Add selected row styling
  const style = document.createElement('style');
  style.textContent = `
    .worker-row.selected {
        background-color: #e3f2fd !important;
    }
    .worker-row:hover {
        background-color: #f8f9fa !important;
    }
`;
  document.head.appendChild(style);

  // Handle row selection
  document.querySelectorAll('.worker-row').forEach(row => {
    row.addEventListener('click', (e) => {
      // Only handle click if not clicking directly on radio button
      if (!e.target.closest('input[type="radio"]')) {
        const radio = row.querySelector('input[type="radio"]');
        if (radio) {
          radio.checked = true;
          // Update visual state
          document.querySelectorAll('.worker-row').forEach(r => r.classList.remove('selected'));
          row.classList.add('selected');
        }
      } else {
        // If clicking on radio, update selection
        document.querySelectorAll('.worker-row').forEach(r => r.classList.remove('selected'));
        row.classList.add('selected');
      }
    });
  });

  // Handle priority slider
  const prioritySlider = document.getElementById('priority');
  const priorityValue = document.getElementById('priority-value');

  // Priority data with descriptions and colors
  const priorityData = {
    1: { text: '1 - Rất thấp', color: 'text-success' },
    2: { text: '2 - Thấp', color: 'text-info' },
    3: { text: '3 - Trung bình', color: 'text-warning' },
    4: { text: '4 - Cao', color: 'text-danger' },
    5: { text: '5 - Rất cao', color: 'text-danger' }
  };

  // Update priority display
  prioritySlider.addEventListener('input', function() {
    const value = this.value;
    const data = priorityData[value];

    // Remove all color classes
    priorityValue.className = priorityValue.className.replace(/text-\w+/g, '');

    // Set new text and color
    priorityValue.textContent = data.text;
    priorityValue.classList.add(data.color);
  });

  // Initialize on page load
  document.addEventListener('DOMContentLoaded', function() {
    prioritySlider.dispatchEvent(new Event('input'));
  });

  // Form validation
  document.querySelector('form').addEventListener('submit', function(e) {
    const selectedWorker = document.querySelector('input[name="workerId"]:checked');
    if (!selectedWorker) {
      e.preventDefault();
      alert('Vui lòng chọn một nhân viên!');
      return false;
    }

    const taskType = document.getElementById('taskType').value;
    if (!taskType) {
      e.preventDefault();
      alert('Vui lòng chọn loại nhiệm vụ!');
      return false;
    }

    return true;
  });
</script>
</body>
</html>