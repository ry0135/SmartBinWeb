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
  <!-- Content -->
  <div class="content p-4">
    <div class="row justify-content-center">
      <div class="col-lg-10">
        <!-- Page Header -->
        <div class="mb-4">
          <div class="d-flex align-items-center justify-content-between">
            <div>
              <h4 class="mb-2 text-dark fw-bold">Giao Nhiệm Vụ Thu Gom</h4>
              <p class="text-muted mb-0 small">Chọn nhân viên và thiết lập chi tiết nhiệm vụ</p>
            </div>
            <a href="${pageContext.request.contextPath}/tasks/task-management"
               class="btn btn-outline-secondary btn-sm">
              <i class="fas fa-arrow-left me-2"></i>Quay lại
            </a>
          </div>
        </div>

        <!-- Assignment Form -->
        <form action="${pageContext.request.contextPath}/tasks/assign/batch/process" method="post" id="assignmentForm">
          <c:forEach var="binId" items="${binIds}">
            <input type="hidden" name="binIds" value="${binId}">
          </c:forEach>
          <input type="hidden" name="senderId" value="${sessionScope.currentAccountId}">
          <input type="hidden" name="taskType" value="COLLECTION">

          <div class="row g-3">
            <!-- Left Column - Bin Information -->
            <div class="col-lg-6">
              <div class="card border-0 shadow-sm h-100">
                <div class="card-header py-3" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                  <div class="d-flex align-items-center text-white">
                    <i class="fas fa-trash-alt me-2"></i>
                    <h6 class="mb-0">Danh sách thùng rác (${fn:length(bins)} thùng)</h6>
                  </div>
                </div>

                <div class="card-body p-3" style="max-height: 600px; overflow-y: auto;">
                  <div class="row g-2" id="binsList">
                    <c:forEach var="bin" items="${bins}">
                      <div class="col-12 bin-item">
                        <div class="card border">
                          <div class="card-body p-3">
                            <div class="d-flex align-items-start">
                              <div class="bg-primary bg-opacity-10 rounded d-flex align-items-center justify-content-center flex-shrink-0"
                                   style="width: 40px; height: 40px;">
                                <i class="fas fa-dumpster text-primary"></i>
                              </div>
                              <div class="ms-3 flex-grow-1">
                                <div class="d-flex align-items-center mb-1">
                                  <span class="badge bg-primary me-2 small">#${bin.binID}</span>
                                  <strong class="small">${bin.binCode}</strong>
                                </div>
                                <div class="text-muted" style="font-size: 0.8rem;">
                                  <div class="mb-1">
                                    <i class="fas fa-map-marker-alt me-1"></i>${bin.street}
                                  </div>
                                  <div>
                                    <i class="fas fa-map me-1"></i>${bin.ward.wardName}, ${bin.ward.province.provinceName}
                                  </div>
                                </div>
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                    </c:forEach>
                  </div>

                  <!-- Bin Pagination -->
                  <c:if test="${fn:length(bins) > 8}">
                    <div class="d-flex justify-content-between align-items-center mt-3 pt-3 border-top">
                      <small class="text-muted">
                        Hiển thị <span id="binShowingStart">1</span>-<span id="binShowingEnd">8</span>
                        trong <span id="binTotal">${fn:length(bins)}</span>
                      </small>
                      <div id="binPagination" class="btn-group btn-group-sm"></div>
                    </div>
                  </c:if>
                </div>
              </div>
            </div>

            <!-- Right Column - Worker Selection -->
            <div class="col-lg-6">
              <div class="card border-0 shadow-sm h-100">
                <div class="card-header py-3" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">
                  <div class="d-flex align-items-center justify-content-between text-white">
                    <div class="d-flex align-items-center">
                      <i class="fas fa-user-check me-2"></i>
                      <h6 class="mb-0">Chọn nhân viên (${fn:length(workers)})</h6>
                    </div>
                    <div class="selected-worker-badge bg-white text-dark px-3 py-1 rounded-pill"
                         id="selectedBadge" style="display: none;">
                      <small class="fw-semibold">
                        <i class="fas fa-check-circle text-success me-1"></i>
                        <span id="selectedWorkerName"></span>
                      </small>
                    </div>
                  </div>
                </div>

                <div class="card-body p-3" style="max-height: 600px; overflow-y: auto;">
                  <div class="row g-2" id="workersList">
                    <c:forEach var="worker" items="${workers}">
                      <c:set var="taskCount" value="${worker.taskCount}" />
                      <div class="col-12 worker-item">
                        <div class="card border worker-card">
                          <div class="card-body p-3">
                            <div class="d-flex align-items-start">
                              <div class="flex-shrink-0 mt-1">
                                <div class="form-check">
                                  <input class="form-check-input" type="radio"
                                         name="workerId" value="${worker.accountId}"
                                         id="worker-${worker.accountId}" required>
                                </div>
                              </div>
                              <label class="flex-grow-1 ms-3 cursor-pointer" for="worker-${worker.accountId}">
                                <div class="d-flex align-items-start">
                                  <div class="bg-primary bg-opacity-10 rounded d-flex align-items-center justify-content-center flex-shrink-0"
                                       style="width: 40px; height: 40px;">
                                    <i class="fas fa-user text-primary"></i>
                                  </div>
                                  <div class="ms-3 flex-grow-1">
                                    <div class="fw-semibold mb-1 small">${worker.fullName}</div>
                                    <div class="text-muted mb-2" style="font-size: 0.8rem;">
                                      <i class="fas fa-envelope me-1"></i>${worker.email}
                                    </div>
                                    <div class="d-flex gap-2 flex-wrap">
                                        <span class="badge bg-light text-dark border" style="font-size: 0.7rem;">
                                          <i class="fas fa-map-marker-alt me-1"></i>${worker.ward.wardName}
                                        </span>
                                      <span class="badge ${taskCount <= 2 ? 'bg-success' : taskCount <= 5 ? 'bg-warning text-dark' : 'bg-danger'}"
                                            style="font-size: 0.7rem;">
                                          <i class="fas fa-tasks me-1"></i>${taskCount} nhiệm vụ
                                        </span>
                                    </div>
                                  </div>
                                </div>
                              </label>
                            </div>
                          </div>
                        </div>
                      </div>
                    </c:forEach>
                  </div>

                  <!-- Worker Pagination -->
                  <c:if test="${fn:length(workers) > 8}">
                    <div class="d-flex justify-content-between align-items-center mt-3 pt-3 border-top">
                      <small class="text-muted">
                        Hiển thị <span id="workerShowingStart">1</span>-<span id="workerShowingEnd">8</span>
                        trong <span id="workerTotal">${fn:length(workers)}</span>
                      </small>
                      <div id="workerPagination" class="btn-group btn-group-sm"></div>
                    </div>
                  </c:if>
                </div>
              </div>
            </div>
          </div>

          <!-- Task Details -->
          <div class="card border-0 shadow-sm mt-3 mb-4">
            <div class="card-header bg-white border-bottom py-3">
              <div class="d-flex align-items-center">
                <i class="fas fa-cog text-primary me-2"></i>
                <h6 class="mb-0 text-dark">Chi tiết nhiệm vụ</h6>
              </div>
            </div>
            <div class="card-body p-4">
              <div class="row g-4">
                <div class="col-md-6">
                  <label class="form-label fw-semibold small text-muted">
                    <i class="fas fa-tasks me-1"></i>Loại nhiệm vụ
                  </label>
                  <div class="p-3 bg-light rounded">
                    <div class="d-flex align-items-center">
                      <i class="fas fa-recycle text-primary me-2"></i>
                      <span class="fw-semibold">Thu gom rác</span>
                    </div>
                  </div>
                </div>

                <div class="col-md-6">
                  <label class="form-label fw-semibold small text-muted">
                    <i class="fas fa-exclamation-circle me-1"></i>Độ ưu tiên
                  </label>
                  <div class="priority-container">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                      <div class="priority-labels d-flex justify-content-between w-100">
                        <span class="priority-label small" data-value="1">Rất thấp</span>
                        <span class="priority-label small" data-value="2">Thấp</span>
                        <span class="priority-label small active" data-value="3">Trung bình</span>
                        <span class="priority-label small" data-value="4">Cao</span>
                        <span class="priority-label small" data-value="5">Rất cao</span>
                      </div>
                    </div>
                    <input type="range" class="form-range priority-slider" id="priority" name="priority"
                           min="1" max="5" value="3" required>
                  </div>
                </div>

                <div class="col-12">
                  <label class="form-label fw-semibold small text-muted">
                    <i class="fas fa-sticky-note me-1"></i>Ghi chú nhiệm vụ
                  </label>
                  <textarea class="form-control" id="notes" name="notes" rows="4"
                            placeholder="Thêm ghi chú chi tiết cho nhiệm vụ này..."
                            style="resize: none; font-size: 0.9rem;"></textarea>
                </div>
              </div>
            </div>
          </div>

          <!-- Action Buttons -->
          <div class="d-flex gap-3 justify-content-end mb-4">
            <button type="button" class="btn btn-light px-4" onclick="window.history.back()">
              <i class="fas fa-times me-2"></i>Hủy bỏ
            </button>
            <button type="submit" class="btn btn-primary px-4">
              <i class="fas fa-paper-plane me-2"></i>Giao nhiệm vụ
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</div>

<style>
  .worker-card {
    transition: all 0.2s ease;
    cursor: pointer;
  }

  .worker-card:hover {
    box-shadow: 0 0.25rem 0.5rem rgba(0,0,0,.1);
    transform: translateY(-1px);
  }

  .worker-item.selected .worker-card {
    background-color: #e3f2fd;
    border: 2px solid #2196F3 !important;
  }

  .cursor-pointer {
    cursor: pointer;
  }

  .form-check-input {
    width: 1.25rem;
    height: 1.25rem;
    cursor: pointer;
  }

  .form-check-input:checked {
    background-color: #2196F3;
    border-color: #2196F3;
  }

  .priority-container {
    position: relative;
  }

  .priority-labels {
    position: relative;
    padding: 0 5px;
  }

  .priority-label {
    color: #6c757d;
    font-weight: 500;
    transition: all 0.2s ease;
    cursor: pointer;
    padding: 4px 8px;
    border-radius: 4px;
  }

  .priority-label.active {
    color: #fff;
    font-weight: 600;
  }

  .priority-label[data-value="1"].active {
    background-color: #198754;
  }

  .priority-label[data-value="2"].active {
    background-color: #0dcaf0;
  }

  .priority-label[data-value="3"].active {
    background-color: #ffc107;
  }

  .priority-label[data-value="4"].active {
    background-color: #fd7e14;
  }

  .priority-label[data-value="5"].active {
    background-color: #dc3545;
  }

  .priority-slider {
    height: 8px;
    background: linear-gradient(to right,
    #198754 0%,
    #0dcaf0 25%,
    #ffc107 50%,
    #fd7e14 75%,
    #dc3545 100%);
    border-radius: 4px;
    cursor: pointer;
  }

  .priority-slider::-webkit-slider-thumb {
    width: 20px;
    height: 20px;
    background: white;
    border: 3px solid #2196F3;
    box-shadow: 0 2px 4px rgba(0,0,0,.2);
    cursor: pointer;
  }

  .priority-slider::-moz-range-thumb {
    width: 20px;
    height: 20px;
    background: white;
    border: 3px solid #2196F3;
    box-shadow: 0 2px 4px rgba(0,0,0,.2);
    cursor: pointer;
  }

  .btn-group-sm > .btn {
    padding: 0.25rem 0.5rem;
    font-size: 0.8rem;
  }

  .card-body::-webkit-scrollbar {
    width: 6px;
  }

  .card-body::-webkit-scrollbar-track {
    background: #f1f1f1;
    border-radius: 10px;
  }

  .card-body::-webkit-scrollbar-thumb {
    background: #888;
    border-radius: 10px;
  }

  .card-body::-webkit-scrollbar-thumb:hover {
    background: #555;
  }
</style>

<script>
  // Pagination configuration
  const BIN_ITEMS_PER_PAGE = 3;
  const WORKER_ITEMS_PER_PAGE = 3;
  let currentBinPage = 1;
  let currentWorkerPage = 1;

  // Get all items
  let allBinItems = Array.from(document.querySelectorAll('.bin-item'));
  let allWorkerItems = Array.from(document.querySelectorAll('.worker-item'));

  // Bin Pagination
  function updateBinPagination() {
    if (allBinItems.length <= BIN_ITEMS_PER_PAGE) return;

    const totalPages = Math.ceil(allBinItems.length / BIN_ITEMS_PER_PAGE);
    const start = (currentBinPage - 1) * BIN_ITEMS_PER_PAGE;
    const end = Math.min(start + BIN_ITEMS_PER_PAGE, allBinItems.length);

    document.getElementById('binShowingStart').textContent = start + 1;
    document.getElementById('binShowingEnd').textContent = end;
    document.getElementById('binTotal').textContent = allBinItems.length;

    allBinItems.forEach(function(item, index) {
      item.style.display = (index >= start && index < end) ? 'block' : 'none';
    });

    const pagination = document.getElementById('binPagination');
    pagination.innerHTML = '';

    if (totalPages > 1) {
      const prevBtn = document.createElement('button');
      prevBtn.type = 'button';
      prevBtn.className = 'btn btn-outline-secondary';
      prevBtn.innerHTML = '<i class="fas fa-chevron-left"></i>';
      prevBtn.disabled = currentBinPage == 1;
      prevBtn.onclick = function() {
        if (currentBinPage > 1) {
          currentBinPage--;
          updateBinPagination();
        }
      };
      pagination.appendChild(prevBtn);

      for (let i = 1; i <= totalPages; i++) {
        if (i == 1 || i == totalPages || (i >= currentBinPage - 1 && i <= currentBinPage + 1)) {
          const btn = document.createElement('button');
          btn.type = 'button';
          btn.className = i == currentBinPage ? 'btn btn-primary' : 'btn btn-outline-secondary';
          btn.textContent = i;
          btn.onclick = function() {
            currentBinPage = i;
            updateBinPagination();
          };
          pagination.appendChild(btn);
        } else if (i == currentBinPage - 2 || i == currentBinPage + 2) {
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
      nextBtn.disabled = currentBinPage == totalPages;
      nextBtn.onclick = function() {
        if (currentBinPage < totalPages) {
          currentBinPage++;
          updateBinPagination();
        }
      };
      pagination.appendChild(nextBtn);
    }
  }

  // Worker Pagination
  function updateWorkerPagination() {
    if (allWorkerItems.length <= WORKER_ITEMS_PER_PAGE) return;

    const totalPages = Math.ceil(allWorkerItems.length / WORKER_ITEMS_PER_PAGE);
    const start = (currentWorkerPage - 1) * WORKER_ITEMS_PER_PAGE;
    const end = Math.min(start + WORKER_ITEMS_PER_PAGE, allWorkerItems.length);

    document.getElementById('workerShowingStart').textContent = start + 1;
    document.getElementById('workerShowingEnd').textContent = end;
    document.getElementById('workerTotal').textContent = allWorkerItems.length;

    allWorkerItems.forEach(function(item, index) {
      item.style.display = (index >= start && index < end) ? 'block' : 'none';
    });

    const pagination = document.getElementById('workerPagination');
    pagination.innerHTML = '';

    if (totalPages > 1) {
      const prevBtn = document.createElement('button');
      prevBtn.type = 'button';
      prevBtn.className = 'btn btn-outline-secondary';
      prevBtn.innerHTML = '<i class="fas fa-chevron-left"></i>';
      prevBtn.disabled = currentWorkerPage == 1;
      prevBtn.onclick = function() {
        if (currentWorkerPage > 1) {
          currentWorkerPage--;
          updateWorkerPagination();
        }
      };
      pagination.appendChild(prevBtn);

      for (let i = 1; i <= totalPages; i++) {
        if (i == 1 || i == totalPages || (i >= currentWorkerPage - 1 && i <= currentWorkerPage + 1)) {
          const btn = document.createElement('button');
          btn.type = 'button';
          btn.className = i == currentWorkerPage ? 'btn btn-primary' : 'btn btn-outline-secondary';
          btn.textContent = i;
          btn.onclick = function() {
            currentWorkerPage = i;
            updateWorkerPagination();
          };
          pagination.appendChild(btn);
        } else if (i == currentWorkerPage - 2 || i == currentWorkerPage + 2) {
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
      nextBtn.disabled = currentWorkerPage == totalPages;
      nextBtn.onclick = function() {
        if (currentWorkerPage < totalPages) {
          currentWorkerPage++;
          updateWorkerPagination();
        }
      };
      pagination.appendChild(nextBtn);
    }
  }

  // Worker Selection
  document.querySelectorAll('.worker-item').forEach(function(item) {
    item.addEventListener('click', function(e) {
      if (e.target.tagName != 'INPUT' && !e.target.closest('label')) {
        const radio = this.querySelector('input[type="radio"]');
        radio.checked = true;
        updateWorkerSelection();
      }
    });
  });

  document.querySelectorAll('input[name="workerId"]').forEach(function(radio) {
    radio.addEventListener('change', updateWorkerSelection);
  });

  function updateWorkerSelection() {
    document.querySelectorAll('.worker-item').forEach(function(item) {
      item.classList.remove('selected');
    });

    const selected = document.querySelector('input[name="workerId"]:checked');
    if (selected) {
      const workerItem = selected.closest('.worker-item');
      workerItem.classList.add('selected');

      const workerName = workerItem.querySelector('label .fw-semibold').textContent;
      document.getElementById('selectedWorkerName').textContent = workerName;
      document.getElementById('selectedBadge').style.display = 'block';
    } else {
      document.getElementById('selectedBadge').style.display = 'none';
    }
  }

  // Priority Slider
  const prioritySlider = document.getElementById('priority');
  const priorityLabels = document.querySelectorAll('.priority-label');

  function updatePriorityDisplay() {
    const value = prioritySlider.value;
    priorityLabels.forEach(function(label) {
      if (label.dataset.value == value) {
        label.classList.add('active');
      } else {
        label.classList.remove('active');
      }
    });
  }

  prioritySlider.addEventListener('input', updatePriorityDisplay);

  priorityLabels.forEach(function(label) {
    label.addEventListener('click', function() {
      prioritySlider.value = this.dataset.value;
      updatePriorityDisplay();
    });
  });

  // Form Validation
  document.getElementById('assignmentForm').addEventListener('submit', function(e) {
    const selectedWorker = document.querySelector('input[name="workerId"]:checked');
    if (!selectedWorker) {
      e.preventDefault();
      alert('Vui lòng chọn một nhân viên!');
      return false;
    }
    return true;
  });

  // Initialize
  document.addEventListener('DOMContentLoaded', function() {
    if (allBinItems.length > BIN_ITEMS_PER_PAGE) {
      updateBinPagination();
    }
    if (allWorkerItems.length > WORKER_ITEMS_PER_PAGE) {
      updateWorkerPagination();
    }
    updatePriorityDisplay();
  });
</script>
</body>
</html>