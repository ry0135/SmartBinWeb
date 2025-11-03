<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Nhiệm vụ đã hủy</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .search-highlight {
            background-color: yellow;
            font-weight: bold;
        }
        .batch-card {
            transition: all 0.3s ease;
            border-left: 4px solid #dc3545;
        }
        .batch-card:hover {
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            transform: translateY(-2px);
        }
        .task-card {
            border-left: 3px solid #dc3545;
            margin-bottom: 10px;
        }
        .batch-stats {
            font-size: 0.9rem;
        }
        .status-badge {
            font-size: 0.8rem;
        }
        .cancelled-badge {
            background-color: #dc3545;
            color: #fff;
        }
        .stats-card {
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .stats-card:hover {
            transform: translateY(-3px);
        }

        /* Pagination styles */
        .pagination {
            margin-top: 20px;
        }

        .page-link {
            color: #dc3545;
            border: 1px solid #dee2e6;
        }

        .page-link:hover {
            color: #fff;
            background-color: #dc3545;
            border-color: #dc3545;
        }

        .page-item.active .page-link {
            background-color: #dc3545;
            border-color: #dc3545;
            color: #fff;
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
                    <i class="fas fa-times-circle text-danger me-2"></i>
                    Nhiệm vụ đã hủy
                </h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <button class="btn btn-sm btn-outline-danger" onclick="exportCancelledTasks()">
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
                    Tìm kiếm & Lọc nhiệm vụ
                </div>
                <div class="card-body">
                    <form id="searchForm" class="row g-3">
                        <div class="col-md-6">
                            <label for="searchKeyword" class="form-label">Từ khóa</label>
                            <input type="text" class="form-control" id="searchKeyword"
                                   placeholder="Tìm theo batch ID, nhân viên, thùng rác..."
                                   onkeyup="performSearch()">
                        </div>
                        <div class="col-md-3">
                            <label for="searchType" class="form-label">Loại nhiệm vụ</label>
                            <select class="form-select" id="searchType" onchange="performSearch()">
                                <option value="">Tất cả</option>
                                <option value="COLLECT">Thu gom</option>
                                <option value="COLLECTION">Thu gom</option>
                                <option value="MAINTENANCE">Bảo trì</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label for="searchPriority" class="form-label">Độ ưu tiên</label>
                            <select class="form-select" id="searchPriority" onchange="performSearch()">
                                <option value="">Tất cả</option>
                                <option value="5">Rất cao</option>
                                <option value="4">Cao</option>
                                <option value="3">Trung bình</option>
                                <option value="2">Thấp</option>
                                <option value="1">Rất thấp</option>
                            </select>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Batch List -->
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <div>
                        <i class="fas fa-layer-group me-1"></i>
                        Batch đã hủy
                    </div>
                    <div class="text-muted small" id="searchResultInfo">
                        Hiển thị <span id="showingFrom">1</span> - <span id="showingTo">0</span> / <span id="totalResults">0</span> tasks
                    </div>
                </div>
                <div class="card-body">
                    <!-- Hiển thị Batch đã hủy -->
                    <div id="batchTasksSection">
                        <c:forEach var="batch" items="${tasksByBatch}">
                            <div class="card mb-3 batch-card" data-batch-card>
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-8">
                                            <div class="d-flex justify-content-between align-items-start mb-2">
                                                <h5 class="card-title mb-0">
                                                    <i class="fas fa-layer-group text-danger me-2"></i>
                                                    Batch: ${batch.key}
                                                </h5>
                                                <div>
                                                    <span class="badge bg-secondary me-2">${batch.value.size()} tasks</span>
                                                    <span class="badge cancelled-badge">ĐÃ HỦY</span>
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
                                                            <span class="badge ${batch.value[0].taskType == 'COLLECT' || batch.value[0].taskType == 'COLLECTION' ? 'bg-primary' : 'bg-warning'}" data-task-type="${batch.value[0].taskType}">
                                                                <c:choose>
                                                                    <c:when test="${batch.value[0].taskType == 'COLLECT' || batch.value[0].taskType == 'COLLECTION'}">Thu gom</c:when>
                                                                    <c:when test="${batch.value[0].taskType == 'MAINTENANCE'}">Bảo trì</c:when>
                                                                    <c:otherwise>${batch.value[0].taskType}</c:otherwise>
                                                                </c:choose>
                                                            </span>
                                                        </div>
                                                    </div>
                                                    <div class="col-sm-6">
                                                        <!-- Thống kê chi tiết -->
                                                        <c:set var="priority5" value="0"/>
                                                        <c:set var="priority4" value="0"/>
                                                        <c:set var="priority3" value="0"/>
                                                        <c:set var="priority2" value="0"/>
                                                        <c:set var="priority1" value="0"/>

                                                        <c:forEach var="task" items="${batch.value}">
                                                            <c:choose>
                                                                <c:when test="${task.priority == 5}">
                                                                    <c:set var="priority5" value="${priority5 + 1}"/>
                                                                </c:when>
                                                                <c:when test="${task.priority == 4}">
                                                                    <c:set var="priority4" value="${priority4 + 1}"/>
                                                                </c:when>
                                                                <c:when test="${task.priority == 3}">
                                                                    <c:set var="priority3" value="${priority3 + 1}"/>
                                                                </c:when>
                                                                <c:when test="${task.priority == 2}">
                                                                    <c:set var="priority2" value="${priority2 + 1}"/>
                                                                </c:when>
                                                                <c:when test="${task.priority == 1}">
                                                                    <c:set var="priority1" value="${priority1 + 1}"/>
                                                                </c:when>
                                                            </c:choose>
                                                        </c:forEach>

                                                        <div class="mb-1" data-priorities data-p5="${priority5}" data-p4="${priority4}" data-p3="${priority3}" data-p2="${priority2}" data-p1="${priority1}">
                                                            <strong>Độ ưu tiên:</strong><br>
                                                            <c:if test="${priority5 > 0}">
                                                                <span class="badge bg-danger me-1">Rất cao: ${priority5}</span>
                                                            </c:if>
                                                            <c:if test="${priority4 > 0}">
                                                                <span class="badge bg-danger me-1" style="opacity: 0.8;">Cao: ${priority4}</span>
                                                            </c:if>
                                                            <c:if test="${priority3 > 0}">
                                                                <span class="badge bg-warning me-1">TB: ${priority3}</span>
                                                            </c:if>
                                                            <c:if test="${priority2 > 0}">
                                                                <span class="badge bg-info me-1">Thấp: ${priority2}</span>
                                                            </c:if>
                                                            <c:if test="${priority1 > 0}">
                                                                <span class="badge bg-success">Rất thấp: ${priority1}</span>
                                                            </c:if>
                                                        </div>

                                                        <div class="mb-1">
                                                            <strong>Trạng thái:</strong>
                                                            <div class="progress" style="height: 8px;">
                                                                <div class="progress-bar bg-danger" style="width: 100%"></div>
                                                            </div>
                                                            <small class="text-danger">Đã hủy</small>
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
                                                <c:if test="${not empty batch.value[0].assignedTo}">
                                                    <button class="btn btn-sm btn-outline-info" onclick="contactWorker(${batch.value[0].assignedTo.accountId})">
                                                        <i class="fas fa-phone"></i> Liên hệ
                                                    </button>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Hiển thị Task đơn lẻ đã hủy -->
                    <c:if test="${not empty singleTasks}">
                        <div class="mt-4">
                            <h5 class="mb-3">
                                <i class="fas fa-list me-2"></i>
                                Task đơn lẻ đã hủy
                            </h5>
                            <c:forEach var="task" items="${singleTasks}">
                                <div class="card mb-2 task-card" data-task-card>
                                    <div class="card-body py-2">
                                        <div class="row align-items-center">
                                            <div class="col-md-2">
                                                <strong>Task #${task.taskID}</strong>
                                            </div>
                                            <div class="col-md-2">
                                                <span class="badge bg-dark">Thùng ${task.bin.binID}</span>
                                            </div>
                                            <div class="col-md-2">
                                                <span class="badge ${task.taskType == 'COLLECT' || task.taskType == 'COLLECTION' ? 'bg-primary' : 'bg-warning'}" data-task-type="${task.taskType}">
                                                    <c:choose>
                                                        <c:when test="${task.taskType == 'COLLECT' || task.taskType == 'COLLECTION'}">Thu gom</c:when>
                                                        <c:when test="${task.taskType == 'MAINTENANCE'}">Bảo trì</c:when>
                                                        <c:otherwise>${task.taskType}</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                            <div class="col-md-2">
                                                <span class="badge ${task.priority == 5 ? 'bg-danger' : task.priority == 4 ? 'bg-danger' : task.priority == 3 ? 'bg-warning' : task.priority == 2 ? 'bg-info' : 'bg-success'}"
                                                      style="${task.priority == 4 ? 'opacity: 0.8;' : ''}" data-priority="${task.priority}">
                                                    <c:choose>
                                                        <c:when test="${task.priority == 5}">Rất cao</c:when>
                                                        <c:when test="${task.priority == 4}">Cao</c:when>
                                                        <c:when test="${task.priority == 3}">Trung bình</c:when>
                                                        <c:when test="${task.priority == 2}">Thấp</c:when>
                                                        <c:when test="${task.priority == 1}">Rất thấp</c:when>
                                                        <c:otherwise>Ưu tiên ${task.priority}</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                            <div class="col-md-2">
                                                <c:if test="${not empty task.assignedTo}">
                                                    <span class="text-muted">${task.assignedTo.fullName}</span>
                                                </c:if>
                                            </div>
                                            <div class="col-md-2 text-end">
                                                <button class="btn btn-sm btn-outline-primary" onclick="viewTaskDetail(${task.taskID})" title="Xem chi tiết">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:if>

                    <!-- Hiển thị khi không có task nào -->
                    <c:if test="${empty tasksByBatch and empty singleTasks}">
                        <div class="text-center py-5" id="emptyState">
                            <i class="fas fa-times-circle fa-3x text-muted mb-3"></i>
                            <h5 class="text-muted">Không có task nào đã hủy</h5>
                            <p class="text-muted">Chưa có nhiệm vụ nào bị hủy</p>
                        </div>
                    </c:if>

                    <!-- Hiển thị khi không có kết quả tìm kiếm -->
                    <div id="noResults" class="text-center py-4" style="display: none;">
                        <i class="fas fa-search fa-3x text-muted mb-3"></i>
                        <h5 class="text-muted">Không tìm thấy task phù hợp</h5>
                        <p class="text-muted">Hãy thử điều chỉnh từ khóa tìm kiếm hoặc bộ lọc</p>
                    </div>

                    <!-- Pagination -->
                    <div class="d-flex justify-content-between align-items-center mt-4" id="paginationSection">
                        <div class="text-muted small">
                            Hiển thị <span id="pageShowingFrom">1</span> - <span id="pageShowingTo">0</span> của <span id="pageTotalItems">0</span> mục
                        </div>
                        <nav>
                            <ul class="pagination pagination-sm mb-0" id="pagination">
                                <!-- Pagination will be generated by JavaScript -->
                            </ul>
                        </nav>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // ==================== BIẾN TOÀN CỤC ====================
    let allBatchCards = [];
    let allTaskCards = [];
    let filteredItems = [];
    let currentPage = 1;
    let itemsPerPage = 5;

    // ==================== KHỞI TẠO ====================
    document.addEventListener('DOMContentLoaded', function() {
        initializePage();
    });

    function initializePage() {
        allBatchCards = Array.from(document.querySelectorAll('[data-batch-card]'));
        allTaskCards = Array.from(document.querySelectorAll('[data-task-card]'));
        filteredItems = [...allBatchCards, ...allTaskCards];

        console.log('Total batch cards:', allBatchCards.length);
        console.log('Total task cards:', allTaskCards.length);

        displayPage(1);
    }

    // ==================== TÌM KIẾM REALTIME ====================
    function performSearch() {
        const keyword = document.getElementById('searchKeyword').value.toLowerCase();
        const type = document.getElementById('searchType').value;
        const priority = document.getElementById('searchPriority').value;

        filteredItems = [];

        allBatchCards.forEach(card => {
            if (matchesFilters(card, keyword, type, priority)) {
                filteredItems.push(card);
            }
        });

        allTaskCards.forEach(card => {
            if (matchesFilters(card, keyword, type, priority)) {
                filteredItems.push(card);
            }
        });

        currentPage = 1;
        displayPage(1);

        if (keyword) {
            setTimeout(() => highlightText(keyword), 100);
        } else {
            clearHighlights();
        }
    }

    function matchesFilters(card, keyword, type, priority) {
        const cardText = card.textContent.toLowerCase();
        let isVisible = true;

        if (keyword && !cardText.includes(keyword)) {
            isVisible = false;
        }

        if (type) {
            const taskTypeElement = card.querySelector('[data-task-type]');
            if (!taskTypeElement) {
                isVisible = false;
            } else {
                const cardTaskType = taskTypeElement.getAttribute('data-task-type');
                if (type === 'COLLECT' || type === 'COLLECTION') {
                    if (cardTaskType !== 'COLLECT' && cardTaskType !== 'COLLECTION') {
                        isVisible = false;
                    }
                } else {
                    if (cardTaskType !== type) {
                        isVisible = false;
                    }
                }
            }
        }

        if (priority) {
            const priorityElement = card.querySelector('[data-priority]');
            const prioritiesElement = card.querySelector('[data-priorities]');

            let hasPriority = false;

            if (priorityElement && priorityElement.getAttribute('data-priority') === priority) {
                hasPriority = true;
            }

            if (prioritiesElement) {
                const priorityCount = parseInt(prioritiesElement.getAttribute('data-p' + priority)) || 0;
                if (priorityCount > 0) {
                    hasPriority = true;
                }
            }

            if (!hasPriority) {
                isVisible = false;
            }
        }

        return isVisible;
    }

    // ==================== PHÂN TRANG ====================
    function displayPage(page) {
        currentPage = page;
        const totalItems = filteredItems.length;
        const startIndex = (page - 1) * itemsPerPage;
        const endIndex = Math.min(startIndex + itemsPerPage, totalItems);

        [...allBatchCards, ...allTaskCards].forEach(card => {
            card.style.display = 'none';
        });

        for (let i = startIndex; i < endIndex; i++) {
            if (filteredItems[i]) {
                filteredItems[i].style.display = 'block';
            }
        }

        updatePaginationInfo(startIndex + 1, endIndex, totalItems);
        createPaginationButtons(totalItems);
        updateNoResultsMessage(totalItems);
    }

    function updatePaginationInfo(from, to, total) {
        document.getElementById('showingFrom').textContent = total > 0 ? from : 0;
        document.getElementById('showingTo').textContent = to;
        document.getElementById('totalResults').textContent = total;

        document.getElementById('pageShowingFrom').textContent = total > 0 ? from : 0;
        document.getElementById('pageShowingTo').textContent = to;
        document.getElementById('pageTotalItems').textContent = total;
    }

    function createPaginationButtons(totalItems) {
        const totalPages = Math.ceil(totalItems / itemsPerPage);
        const paginationContainer = document.getElementById('pagination');
        paginationContainer.innerHTML = '';

        if (totalPages <= 1) {
            document.getElementById('paginationSection').style.display = 'none';
            return;
        }

        document.getElementById('paginationSection').style.display = 'flex';

        const prevLi = document.createElement('li');
        prevLi.className = 'page-item' + (currentPage === 1 ? ' disabled' : '');
        prevLi.innerHTML = '<a class="page-link" href="#" onclick="goToPage(' + (currentPage - 1) + '); return false;">«</a>';
        paginationContainer.appendChild(prevLi);

        const startPage = Math.max(1, currentPage - 2);
        const endPage = Math.min(totalPages, currentPage + 2);

        if (startPage > 1) {
            const firstLi = document.createElement('li');
            firstLi.className = 'page-item';
            firstLi.innerHTML = '<a class="page-link" href="#" onclick="goToPage(1); return false;">1</a>';
            paginationContainer.appendChild(firstLi);

            if (startPage > 2) {
                const dotsLi = document.createElement('li');
                dotsLi.className = 'page-item disabled';
                dotsLi.innerHTML = '<a class="page-link" href="#">...</a>';
                paginationContainer.appendChild(dotsLi);
            }
        }

        for (let i = startPage; i <= endPage; i++) {
            const pageLi = document.createElement('li');
            pageLi.className = 'page-item' + (i === currentPage ? ' active' : '');
            pageLi.innerHTML = '<a class="page-link" href="#" onclick="goToPage(' + i + '); return false;">' + i + '</a>';
            paginationContainer.appendChild(pageLi);
        }

        if (endPage < totalPages) {
            if (endPage < totalPages - 1) {
                const dotsLi = document.createElement('li');
                dotsLi.className = 'page-item disabled';
                dotsLi.innerHTML = '<a class="page-link" href="#">...</a>';
                paginationContainer.appendChild(dotsLi);
            }

            const lastLi = document.createElement('li');
            lastLi.className = 'page-item';
            lastLi.innerHTML = '<a class="page-link" href="#" onclick="goToPage(' + totalPages + '); return false;">' + totalPages + '</a>';
            paginationContainer.appendChild(lastLi);
        }

        const nextLi = document.createElement('li');
        nextLi.className = 'page-item' + (currentPage === totalPages ? ' disabled' : '');
        nextLi.innerHTML = '<a class="page-link" href="#" onclick="goToPage(' + (currentPage + 1) + '); return false;">»</a>';
        paginationContainer.appendChild(nextLi);
    }

    function goToPage(page) {
        const totalPages = Math.ceil(filteredItems.length / itemsPerPage);
        if (page < 1 || page > totalPages) return;

        displayPage(page);
        document.querySelector('.card-header').scrollIntoView({ behavior: 'smooth', block: 'start' });
    }

    function updateNoResultsMessage(totalItems) {
        const noResults = document.getElementById('noResults');
        const emptyState = document.getElementById('emptyState');
        const keyword = document.getElementById('searchKeyword').value;
        const type = document.getElementById('searchType').value;
        const priority = document.getElementById('searchPriority').value;
        const hasFilter = keyword || type || priority;

        if (totalItems === 0 && hasFilter) {
            noResults.style.display = 'block';
            if (emptyState) emptyState.style.display = 'none';
        } else {
            noResults.style.display = 'none';
        }
    }

    // ==================== HIGHLIGHT TEXT ====================
    function highlightText(keyword) {
        clearHighlights();

        const walker = document.createTreeWalker(
            document.getElementById('batchTasksSection'),
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

    function viewTaskDetail(taskId) {
        window.location.href = '${pageContext.request.contextPath}/tasks/' + taskId;
    }

    function contactWorker(workerId) {
        alert('Liên hệ với nhân viên ID: ' + workerId + '\nChức năng đang được phát triển');
    }

    function exportCancelledTasks() {
        alert('Xuất danh sách task đã hủy\nChức năng đang được phát triển');
    }
</script>
</body>
</html>