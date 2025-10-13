<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
  <title>Nhiệm vụ đang thực hiện</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
  <style>
    .search-highlight {
      background-color: yellow;
      font-weight: bold;
    }
    .batch-card {
      transition: all 0.3s ease;
      border-left: 4px solid #ffc107;
    }
    .batch-card:hover {
      box-shadow: 0 4px 8px rgba(0,0,0,0.1);
      transform: translateY(-2px);
    }
    .task-card {
      border-left: 3px solid #20c997;
      margin-bottom: 10px;
    }
    .batch-stats {
      font-size: 0.9rem;
    }
    .status-badge {
      font-size: 0.8rem;
    }
    .doing-badge {
      background-color: #ffc107;
      color: #000;
    }
    .stats-card {
      cursor: pointer;
      transition: all 0.3s ease;
    }
    .stats-card:hover {
      transform: translateY(-3px);
    }
  </style>
</head>
<body class="bg-light">
<div class="container-fluid">
  <div class="row">
    <!-- Sidebar -->
    <%@include file="../include/sidebar.jsp"%>

    <!-- Main Content -->
    <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
      <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
        <h1 class="h2">
          <i class="fas fa-play-circle text-warning me-2"></i>
          Nhiệm vụ đang hoàn thành
        </h1>
        <div class="btn-toolbar mb-2 mb-md-0">
          <button class="btn btn-sm btn-outline-warning" onclick="exportDoingTasks()">
            <i class="fas fa-download"></i> Export
          </button>
        </div>
      </div>

      <!-- Stats Cards -->
      <%@include file="../include/card.jsp"%>

      <!-- Search Section -->
      <div class="card mb-4">
        <div class="card-header">
          <i class="fas fa-search me-1"></i>
          Tìm kiếm Task đang thực hiện
        </div>
        <div class="card-body">
          <form id="searchForm" class="row g-3">
            <div class="col-md-3">
              <label for="searchKeyword" class="form-label">Từ khóa</label>
              <input type="text" class="form-control" id="searchKeyword"
                     placeholder="Tìm theo batch ID, nhân viên, thùng rác...">
            </div>
            <div class="col-md-2">
              <label for="searchType" class="form-label">Loại task</label>
              <select class="form-select" id="searchType">
                <option value="">Tất cả</option>
                <option value="COLLECT">Thu gom</option>
                <option value="REPAIR">Sửa chữa</option>
              </select>
            </div>
            <div class="col-md-2">
              <label for="searchPriority" class="form-label">Độ ưu tiên</label>
              <select class="form-select" id="searchPriority">
                <option value="">Tất cả</option>
                <option value="1">Cao</option>
                <option value="2">Trung bình</option>
                <option value="3">Thấp</option>
              </select>
            </div>
            <div class="col-md-2">
              <label for="searchWorker" class="form-label">Nhân viên</label>
              <select class="form-select" id="searchWorker">
                <option value="">Tất cả</option>
                <c:forEach var="worker" items="${uniqueWorkers}">
                  <option value="${worker.accountId}">${worker.fullName}</option>
                </c:forEach>
              </select>
            </div>
            <div class="col-md-3">
              <label class="form-label">&nbsp;</label>
              <div class="d-grid gap-2 d-md-flex">
                <button type="button" class="btn btn-warning me-2" onclick="searchDoingTasks()">
                  <i class="fas fa-search"></i> Tìm kiếm
                </button>
                <button type="button" class="btn btn-outline-secondary" onclick="clearSearch()">
                  <i class="fas fa-undo"></i> Xóa
                </button>
              </div>
            </div>
          </form>
        </div>
      </div>

      <!-- Batch List -->
      <div class="card">
        <div class="card-header d-flex justify-content-between align-items-center">
          <div>
            <i class="fas fa-layer-group me-1"></i>
            Batch đang thực hiện
          </div>
          <div class="text-muted small" id="searchResultInfo">
            Hiển thị ${totalDoingTasks} task đang thực hiện
          </div>
        </div>
        <div class="card-body">
          <!-- Hiển thị Batch đang DOING -->
          <div id="batchTasksSection">
            <c:forEach var="batch" items="${doingTasksByBatch}">
              <div class="card mb-3 batch-card">
                <div class="card-body">
                  <div class="row">
                    <div class="col-md-8">
                      <div class="d-flex justify-content-between align-items-start mb-2">
                        <h5 class="card-title mb-0">
                          <i class="fas fa-layer-group text-warning me-2"></i>
                          Batch: ${batch.key}
                        </h5>
                        <div>
                          <span class="badge bg-secondary me-2">${batch.value.size()} tasks</span>
                          <span class="badge doing-badge">ĐANG THỰC HIỆN</span>
                        </div>
                      </div>

                      <!-- Thông tin batch -->
                      <div class="batch-stats">
                        <div class="row">
                          <div class="col-sm-6">
                            <c:if test="${not empty batch.value[0].assignedTo}">
                              <div class="mb-1">
                                <strong>Nhân viên:</strong>
                                <span class="badge bg-info">${batch.value[0].assignedTo.fullName}</span>
                              </div>
                            </c:if>
                            <div class="mb-1">
                              <strong>Ngày tạo:</strong>
                                ${batch.value[0].createdAt}
                            </div>
                            <div class="mb-1">
                              <strong>Loại:</strong>
                              <span class="badge ${batch.value[0].taskType == 'COLLECT' ? 'bg-primary' : batch.value[0].taskType == 'CLEAN' ? 'bg-info' : 'bg-warning'}">
                                  ${batch.value[0].taskType}
                              </span>
                            </div>
                          </div>
                          <div class="col-sm-6">
                            <!-- Thống kê chi tiết -->
                            <c:set var="highPriority" value="0"/>
                            <c:set var="mediumPriority" value="0"/>
                            <c:set var="lowPriority" value="0"/>

                            <c:forEach var="task" items="${batch.value}">
                              <c:choose>
                                <c:when test="${task.priority == 1}">
                                  <c:set var="highPriority" value="${highPriority + 1}"/>
                                </c:when>
                                <c:when test="${task.priority == 2}">
                                  <c:set var="mediumPriority" value="${mediumPriority + 1}"/>
                                </c:when>
                                <c:when test="${task.priority == 3}">
                                  <c:set var="lowPriority" value="${lowPriority + 1}"/>
                                </c:when>
                              </c:choose>
                            </c:forEach>

                            <div class="mb-1">
                              <strong>Độ ưu tiên:</strong><br>
                              <span class="badge bg-danger me-1">Cao: ${highPriority}</span>
                              <span class="badge bg-warning me-1">TB: ${mediumPriority}</span>
                              <span class="badge bg-success">Thấp: ${lowPriority}</span>
                            </div>

                            <div class="mb-1">
                              <strong>Tiến độ:</strong>
                              <div class="progress" style="height: 8px;">
                                <div class="progress-bar bg-warning" style="width: 50%"></div>
                              </div>
                              <small class="text-muted">Đang thực hiện</small>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                    <div class="col-md-4">
                      <div class="d-grid gap-2">
                        <button class="btn btn-sm btn-outline-primary" onclick="viewBatchDetail('${batch.key}')">
                          <i class="fas fa-eye"></i> Xem chi tiết
                        </button>
                        <button class="btn btn-sm btn-outline-success" onclick="updateBatchStatus('${batch.key}', 'CONFIRM')">
                          <i class="fas fa-check"></i> Xác Nhận
                        </button>
                        <button class="btn btn-sm btn-outline-info" onclick="contactWorker(${batch.value[0].assignedTo.accountId})">
                          <i class="fas fa-phone"></i> Liên hệ
                        </button>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </c:forEach>
          </div>

          <!-- Hiển thị Task đơn lẻ đang DOING -->
          <c:if test="${not empty singleDoingTasks}">
            <div class="mt-4">
              <h5 class="mb-3">
                <i class="fas fa-list me-2"></i>
                Task đơn lẻ đang thực hiện
              </h5>
              <c:forEach var="task" items="${singleDoingTasks}">
                <div class="card mb-2 task-card">
                  <div class="card-body py-2">
                    <div class="row">
                      <div class="col-md-3">
                        <strong>Task #${task.taskID}</strong>
                      </div>
                      <div class="col-md-2">
                        <span class="badge bg-dark">Thùng ${task.bin.binID}</span>
                      </div>
                      <div class="col-md-2">
                        <span class="badge ${task.taskType == 'COLLECT' ? 'bg-primary' : task.taskType == 'CLEAN' ? 'bg-info' : 'bg-warning'}">
                            ${task.taskType}
                        </span>
                      </div>
                      <div class="col-md-2">
                        <span class="badge ${task.priority == 1 ? 'bg-danger' : task.priority == 2 ? 'bg-warning' : 'bg-success'}">
                          Ưu tiên ${task.priority}
                        </span>
                      </div>
                      <div class="col-md-3">
                        <c:if test="${not empty task.assignedTo}">
                          <span class="text-muted">${task.assignedTo.fullName}</span>
                        </c:if>
                      </div>
                    </div>
                  </div>
                </div>
              </c:forEach>
            </div>
          </c:if>

          <!-- Hiển thị khi không có task nào -->
          <c:if test="${empty doingTasksByBatch and empty singleDoingTasks}">
            <div class="text-center py-5">
              <i class="fas fa-play-circle fa-3x text-muted mb-3"></i>
              <h5 class="text-muted">Không có task nào đang thực hiện</h5>
              <p class="text-muted">Tất cả các task hiện đã hoàn thành hoặc chưa được bắt đầu</p>
            </div>
          </c:if>

          <!-- Hiển thị khi không có kết quả tìm kiếm -->
          <div id="noResults" class="text-center py-4" style="display: none;">
            <i class="fas fa-search fa-3x text-muted mb-3"></i>
            <h5 class="text-muted">Không tìm thấy task phù hợp</h5>
            <p class="text-muted">Hãy thử điều chỉnh từ khóa tìm kiếm hoặc bộ lọc</p>
          </div>
        </div>
      </div>
    </main>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
  // ==================== KHỞI TẠO ====================
  document.addEventListener('DOMContentLoaded', function() {
    initializePage();
  });

  function initializePage() {
    // Khởi tạo các sự kiện
    setupEventListeners();
  }

  function setupEventListeners() {
    document.getElementById('searchKeyword').addEventListener('keypress', function(e) {
      if (e.key === 'Enter') {
        e.preventDefault();
        searchDoingTasks();
      }
    });
  }

  // ==================== TÌM KIẾM ====================
  function searchDoingTasks() {
    const keyword = document.getElementById('searchKeyword').value.toLowerCase();
    const type = document.getElementById('searchType').value;
    const priority = document.getElementById('searchPriority').value;
    const worker = document.getElementById('searchWorker').value;

    const batchCards = document.querySelectorAll('.batch-card');
    const taskCards = document.querySelectorAll('.task-card');
    let visibleCount = 0;

    // Lọc batch cards
    batchCards.forEach(card => {
      const cardText = card.textContent.toLowerCase();
      let isVisible = true;

      if (keyword && !cardText.includes(keyword)) {
        isVisible = false;
      }

      if (type) {
        const typeBadges = card.querySelectorAll('.badge');
        let hasMatchingType = false;
        typeBadges.forEach(badge => {
          if (badge.textContent.toUpperCase().includes(type)) {
            hasMatchingType = true;
          }
        });
        if (!hasMatchingType) {
          isVisible = false;
        }
      }

      if (worker) {
        const workerText = card.textContent;
        if (!workerText.includes(worker)) {
          isVisible = false;
        }
      }

      card.style.display = isVisible ? 'block' : 'none';
      if (isVisible) visibleCount++;
    });

    // Lọc task cards
    taskCards.forEach(card => {
      const cardText = card.textContent.toLowerCase();
      let isVisible = true;

      if (keyword && !cardText.includes(keyword)) {
        isVisible = false;
      }

      if (type) {
        const typeBadges = card.querySelectorAll('.badge');
        let hasMatchingType = false;
        typeBadges.forEach(badge => {
          if (badge.textContent.toUpperCase().includes(type)) {
            hasMatchingType = true;
          }
        });
        if (!hasMatchingType) {
          isVisible = false;
        }
      }

      card.style.display = isVisible ? 'block' : 'none';
      if (isVisible) visibleCount++;
    });

    updateSearchInfo(visibleCount, keyword, type, priority, worker);

    if (keyword) {
      setTimeout(() => highlightText(keyword), 100);
    } else {
      clearHighlights();
    }
  }

  function updateSearchInfo(visibleCount, keyword, type, priority, worker) {
    const resultInfo = document.getElementById('searchResultInfo');
    const noResults = document.getElementById('noResults');
    const hasFilter = keyword || type || priority || worker;

    if (hasFilter) {
      resultInfo.textContent = `Tìm thấy ${visibleCount} task phù hợp`;
    } else {
      resultInfo.textContent = `Hiển thị ${visibleCount} task đang thực hiện`;
    }

    if (visibleCount === 0 && hasFilter) {
      noResults.style.display = 'block';
    } else {
      noResults.style.display = 'none';
    }
  }

  function clearSearch() {
    document.getElementById('searchKeyword').value = '';
    document.getElementById('searchType').value = '';
    document.getElementById('searchPriority').value = '';
    document.getElementById('searchWorker').value = '';
    searchDoingTasks();
  }

  // ==================== LỌC THEO LOẠI TASK ====================
  function filterByType(taskType) {
    document.getElementById('searchType').value = taskType;
    searchDoingTasks();
  }

  // ==================== HIGHLIGHT TEXT ====================
  function highlightText(keyword) {
    clearHighlights();

    const walker = document.createTreeWalker(
            document.body,
            NodeFilter.SHOW_TEXT,
            {
              acceptNode: function(node) {
                if (node.parentNode.nodeName === 'SCRIPT' ||
                        node.parentNode.nodeName === 'STYLE' ||
                        node.parentNode.classList.contains('search-highlight')) {
                  return NodeFilter.FILTER_REJECT;
                }
                return NodeFilter.FILTER_ACCEPT;
              }
            }
    );

    const nodesToReplace = [];
    let node;
    while (node = walker.nextNode()) {
      if (node.nodeValue.toLowerCase().includes(keyword.toLowerCase())) {
        nodesToReplace.push(node);
      }
    }

    nodesToReplace.forEach(node => {
      const regex = new RegExp(`(${keyword})`, 'gi');
      const fragment = document.createDocumentFragment();
      const parts = node.nodeValue.split(regex);

      parts.forEach(part => {
        if (part.toLowerCase() === keyword.toLowerCase()) {
          const span = document.createElement('span');
          span.className = 'search-highlight';
          span.textContent = part;
          fragment.appendChild(span);
        } else {
          fragment.appendChild(document.createTextNode(part));
        }
      });

      node.parentNode.replaceChild(fragment, node);
    });
  }

  function clearHighlights() {
    const highlights = document.querySelectorAll('.search-highlight');
    highlights.forEach(highlight => {
      const parent = highlight.parentNode;
      parent.replaceChild(document.createTextNode(highlight.textContent), highlight);
      parent.normalize();
    });
  }

  // ==================== CÁC HÀM TIỆN ÍCH ====================
  function viewBatchDetail(batchId) {
    window.location.href = '${pageContext.request.contextPath}/tasks/batch/' + batchId;
  }

  function updateBatchStatus(batchId, status) {
    if(confirm('Bạn có chắc muốn đánh dấu toàn bộ batch này là đã hoàn thành?')) {
      fetch('${pageContext.request.contextPath}/tasks/batch/' + batchId + '/status', {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({status: status})
      })
              .then(response => {
                if(response.ok) {
                  alert('Cập nhật thành công!');
                  location.reload();
                } else {
                  alert('Có lỗi xảy ra. Vui lòng thử lại!');
                }
              })
              .catch(error => {
                console.error('Error:', error);
                alert('Có lỗi xảy ra. Vui lòng thử lại!');
              });
    }
  }

  function contactWorker(workerId) {
    alert('Liên hệ với nhân viên ID: ' + workerId + '\nChức năng đang được phát triển');
  }

  function exportDoingTasks() {
    alert('Xuất danh sách task đang thực hiện\nChức năng đang được phát triển');
  }
</script>
</body>
</html>