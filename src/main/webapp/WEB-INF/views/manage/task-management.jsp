<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quản lý Task</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .search-highlight {
            background-color: yellow;
            font-weight: bold;
        }
        .batch-card {
            transition: all 0.3s ease;
            border-left: 4px solid #007bff;
        }
        .batch-card:hover {
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            transform: translateY(-2px);
        }
        .batch-stats {
            font-size: 0.9rem;
        }
        .status-badge {
            font-size: 0.8rem;
        }
        /* Style cho các stats cards có thể click */
        .stats-card-clickable {
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .stats-card-clickable:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 12px rgba(0,0,0,0.15) !important;
        }
        .stats-card-clickable.active {
            border: 2px solid #007bff;
            box-shadow: 0 0 15px rgba(0,123,255,0.4) !important;
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
                <h1 class="h2">Quản lý Task</h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <button class="btn btn-sm btn-outline-secondary" onclick="exportTasks()">
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
                    Tìm kiếm Batch
                </div>
                <div class="card-body">
                    <form id="searchForm" class="row g-3">
                        <div class="col-md-4">
                            <label for="searchKeyword" class="form-label">Từ khóa</label>
                            <input type="text" class="form-control" id="searchKeyword"
                                   placeholder="Tìm theo batch ID, nhân viên...">
                        </div>
                        <div class="col-md-2">
                            <label for="searchStatus" class="form-label">Trạng thái</label>
                            <select class="form-select" id="searchStatus">
                                <option value="">Tất cả</option>
                                <option value="OPEN">OPEN</option>
                                <option value="DOING">DOING</option>
                                <option value="COMPLETED">COMPLETED</option>
                                <option value="CANCELLED">CANCELLED</option>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <label for="searchType" class="form-label">Loại task</label>
                            <select class="form-select" id="searchType">
                                <option value="">Tất cả</option>
                                <option value="COLLECT">Thu gom</option>
                                <option value="CLEAN">Vệ sinh</option>
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
                            <label class="form-label">&nbsp;</label>
                            <div class="d-grid gap-2">
                                <button type="button" class="btn btn-primary" onclick="searchTasks()">
                                    <i class="fas fa-search"></i> Tìm kiếm
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
                        Danh sách Batch
                    </div>
                    <div class="text-muted small" id="searchResultInfo">
                        Hiển thị tất cả batch
                    </div>
                </div>
                <div class="card-body">
                    <!-- Hiển thị Batch -->
                    <div id="batchTasksSection">
                        <c:forEach var="batch" items="${tasksByBatch}">
                            <div class="card mb-3 batch-card">
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-8">
                                            <div class="d-flex justify-content-between align-items-start mb-2">
                                                <h5 class="card-title mb-0">
                                                    <i class="fas fa-layer-group text-primary me-2"></i>
                                                    Batch: ${batch.key}
                                                </h5>
                                                <span class="badge bg-secondary">${batch.value.size()} tasks</span>
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
                                                    </div>
                                                    <div class="col-sm-6">
                                                        <!-- Thống kê trạng thái -->
                                                        <c:set var="openCount" value="0"/>
                                                        <c:set var="doingCount" value="0"/>
                                                        <c:set var="completedCount" value="0"/>
                                                        <c:forEach var="task" items="${batch.value}">
                                                            <c:choose>
                                                                <c:when test="${task.status == 'OPEN'}">
                                                                    <c:set var="openCount" value="${openCount + 1}"/>
                                                                </c:when>
                                                                <c:when test="${task.status == 'DOING'}">
                                                                    <c:set var="doingCount" value="${doingCount + 1}"/>
                                                                </c:when>
                                                                <c:when test="${task.status == 'COMPLETED'}">
                                                                    <c:set var="completedCount" value="${completedCount + 1}"/>
                                                                </c:when>
                                                            </c:choose>
                                                        </c:forEach>

                                                        <div class="mb-1">
                                                            <strong>Trạng thái:</strong>
                                                            <span class="badge bg-primary status-badge">OPEN: ${openCount}</span>
                                                            <span class="badge bg-warning status-badge">DOING: ${doingCount}</span>
                                                            <span class="badge bg-success status-badge">COMPLETED: ${completedCount}</span>
                                                        </div>

                                                        <!-- Loại task chính -->
                                                        <c:if test="${not empty batch.value[0].taskType}">
                                                            <div class="mb-1">
                                                                <strong>Loại:</strong>
                                                                <span class="badge ${batch.value[0].taskType == 'COLLECT' ? 'bg-primary' : batch.value[0].taskType == 'CLEAN' ? 'bg-info' : 'bg-warning'} status-badge">
                                                                        ${batch.value[0].taskType}
                                                                </span>
                                                            </div>
                                                        </c:if>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="d-grid gap-2">
                                                <button class="btn btn-sm btn-outline-primary" onclick="viewBatchDetail('${batch.key}')">
                                                    <i class="fas fa-eye"></i> Xem chi tiết
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

                    <!-- Hiển thị khi không có batch -->
                    <c:if test="${empty tasksByBatch}">
                        <div class="text-center py-5">
                            <i class="fas fa-layer-group fa-3x text-muted mb-3"></i>
                            <h5 class="text-muted">Không có batch nào</h5>
                            <p class="text-muted">Các task sẽ được hiển thị dưới dạng batch khi có cùng batch ID</p>
                        </div>
                    </c:if>

                    <!-- Hiển thị khi không có kết quả tìm kiếm -->
                    <div id="noResults" class="text-center py-4" style="display: none;">
                        <i class="fas fa-search fa-3x text-muted mb-3"></i>
                        <h5 class="text-muted">Không tìm thấy batch phù hợp</h5>
                        <p class="text-muted">Hãy thử điều chỉnh từ khóa tìm kiếm hoặc bộ lọc</p>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // ==================== BIẾN TOÀN CỤC ====================
    var currentPage = 1;
    var batchesPerPage = 5;
    var allBatchCards = [];
    var filteredBatchCards = [];
    var currentStatusFilter = '';

    // ==================== KHỞI TẠO ====================
    document.addEventListener('DOMContentLoaded', function() {
        initializePagination();
        setupEventListeners();
    });

    function initializePagination() {
        allBatchCards = Array.from(document.querySelectorAll('.batch-card'));
        filteredBatchCards = [...allBatchCards];
        displayPage(1);
        addPaginationControls();
    }

    function setupEventListeners() {
        document.getElementById('searchKeyword').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                searchTasks();
            }
        });

        document.getElementById('searchStatus').addEventListener('change', function() {
            currentStatusFilter = '';
            removeActiveStatsCard();
            searchTasks();
        });
        document.getElementById('searchType').addEventListener('change', searchTasks);
        document.getElementById('searchPriority').addEventListener('change', searchTasks);
    }

    // ==================== LỌC THEO TRẠNG THÁI TỪ STATS CARDS ====================
    function filterByStatus(status) {
        // Cập nhật dropdown
        document.getElementById('searchStatus').value = status;

        // Cập nhật biến trạng thái hiện tại
        currentStatusFilter = status;

        // Cập nhật active state cho card
        updateActiveStatsCard(status);

        // Thực hiện tìm kiếm
        searchTasks();

        // Cuộn xuống danh sách batch
        setTimeout(() => {
            document.querySelector('.card-header').scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });
        }, 100);
    }


    // ==================== TÌM KIẾM VÀ LỌC ====================
    function searchTasks() {
        const keyword = document.getElementById('searchKeyword').value.toLowerCase();
        const status = document.getElementById('searchStatus').value;
        const type = document.getElementById('searchType').value;
        const priority = document.getElementById('searchPriority').value;

        filteredBatchCards = allBatchCards.filter(batchCard => {
            const batchText = batchCard.textContent.toLowerCase();
            let isVisible = true;

            if (keyword && !batchText.includes(keyword)) {
                isVisible = false;
            }

            if (status) {
                const statusBadges = batchCard.querySelectorAll('.badge');
                let hasMatchingStatus = false;
                statusBadges.forEach(badge => {
                    if (badge.textContent.toUpperCase().includes(status)) {
                        hasMatchingStatus = true;
                    }
                });
                if (!hasMatchingStatus) {
                    isVisible = false;
                }
            }

            if (type) {
                let hasMatchingType = false;
                const typeBadges = batchCard.querySelectorAll('.badge');
                typeBadges.forEach(badge => {
                    const badgeText = badge.textContent.toUpperCase();
                    if (type === 'COLLECT' && badgeText.includes('COLLECT')) hasMatchingType = true;
                    if (type === 'CLEAN' && badgeText.includes('CLEAN')) hasMatchingType = true;
                    if (type === 'REPAIR' && badgeText.includes('REPAIR')) hasMatchingType = true;
                });
                if (!hasMatchingType) {
                    isVisible = false;
                }
            }

            return isVisible;
        });

        currentPage = 1;
        displayPage(1);
        updateSearchInfo(keyword, status, type, priority);

        if (keyword) {
            setTimeout(() => highlightText(keyword), 100);
        } else {
            clearHighlights();
        }
    }

    function updateSearchInfo(keyword, status, type, priority) {
        const resultInfo = document.getElementById('searchResultInfo');
        const noResults = document.getElementById('noResults');
        const hasFilter = keyword || status || type || priority;

        if (hasFilter) {
            let filterText = `Tìm thấy ${filteredBatchCards.length} batch`;
            if (status) {
                filterText += ` (Trạng thái: ${status})`;
            }
            resultInfo.textContent = filterText;
        } else {
            resultInfo.textContent = 'Hiển thị tất cả batch';
        }

        if (filteredBatchCards.length === 0 && hasFilter) {
            noResults.style.display = 'block';
            if (document.getElementById('paginationWrapper')) {
                document.getElementById('paginationWrapper').style.display = 'none';
            }
        } else {
            noResults.style.display = 'none';
            if (document.getElementById('paginationWrapper')) {
                document.getElementById('paginationWrapper').style.display =
                    filteredBatchCards.length > batchesPerPage ? 'flex' : 'none';
            }
        }
    }

    // ==================== HIGHLIGHT TEXT ====================
    function highlightText(keyword) {
        clearHighlights();
        const visibleBatchCards = document.querySelectorAll('.batch-card[style="display: block;"]');
        visibleBatchCards.forEach(card => {
            highlightInElement(card, keyword);
        });
    }

    function highlightInElement(element, keyword) {
        const walker = document.createTreeWalker(
            element,
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

    // ==================== PHÂN TRANG ====================
    function displayPage(page) {
        currentPage = page;
        const totalBatches = filteredBatchCards.length;
        const startIndex = (page - 1) * batchesPerPage;
        const endIndex = Math.min(startIndex + batchesPerPage, totalBatches);

        allBatchCards.forEach(card => {
            card.style.display = 'none';
        });

        for (let i = startIndex; i < endIndex; i++) {
            filteredBatchCards[i].style.display = 'block';
        }

        updatePaginationControls();
        updatePaginationInfo(startIndex + 1, endIndex, totalBatches);

        if (page > 1) {
            document.querySelector('.card-header').scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });
        }
    }

    function addPaginationControls() {
        const cardBody = document.querySelector('#batchTasksSection').parentElement;
        const paginationWrapper = document.createElement('div');
        paginationWrapper.id = 'paginationWrapper';
        paginationWrapper.className = 'd-flex justify-content-between align-items-center mt-4 pt-3 border-top';

        const infoDiv = document.createElement('div');
        infoDiv.className = 'text-muted';
        infoDiv.innerHTML = `
        Hiển thị <strong><span id="showingFrom">1</span></strong> đến
        <strong><span id="showingTo">0</span></strong> trong tổng số
        <strong><span id="totalBatches">0</span></strong> batch
    `;

        const paginationNav = document.createElement('nav');
        paginationNav.innerHTML = '<ul class="pagination pagination-sm mb-0" id="paginationControls"></ul>';

        paginationWrapper.appendChild(infoDiv);
        paginationWrapper.appendChild(paginationNav);
        cardBody.appendChild(paginationWrapper);
    }

    function updatePaginationInfo(from, to, total) {
        document.getElementById('showingFrom').textContent = total > 0 ? from : 0;
        document.getElementById('showingTo').textContent = to;
        document.getElementById('totalBatches').textContent = total;
    }

    function updatePaginationControls() {
        const totalPages = Math.ceil(filteredBatchCards.length / batchesPerPage);
        const paginationControls = document.getElementById('paginationControls');

        if (!paginationControls) return;

        paginationControls.innerHTML = '';

        if (totalPages <= 1) {
            document.getElementById('paginationWrapper').style.display = 'none';
            return;
        }

        document.getElementById('paginationWrapper').style.display = 'flex';

        addPaginationButton(paginationControls, '«', currentPage - 1, currentPage === 1);

        let startPage = Math.max(1, currentPage - 2);
        let endPage = Math.min(totalPages, currentPage + 2);

        if (endPage - startPage < 4) {
            if (startPage === 1) {
                endPage = Math.min(totalPages, startPage + 4);
            } else if (endPage === totalPages) {
                startPage = Math.max(1, endPage - 4);
            }
        }

        if (startPage > 1) {
            addPaginationButton(paginationControls, '1', 1, false);
            if (startPage > 2) {
                addPaginationButton(paginationControls, '...', null, true);
            }
        }

        for (let i = startPage; i <= endPage; i++) {
            addPaginationButton(paginationControls, i.toString(), i, false, i === currentPage);
        }

        if (endPage < totalPages) {
            if (endPage < totalPages - 1) {
                addPaginationButton(paginationControls, '...', null, true);
            }
            addPaginationButton(paginationControls, totalPages.toString(), totalPages, false);
        }

        addPaginationButton(paginationControls, '»', currentPage + 1, currentPage === totalPages);
    }

    function addPaginationButton(container, text, page, disabled, active = false) {
        const li = document.createElement('li');
        li.className = 'page-item';
        if (disabled) li.classList.add('disabled');
        if (active) li.classList.add('active');

        const a = document.createElement('a');
        a.className = 'page-link';
        a.href = '#';
        a.textContent = text;

        if (!disabled && page !== null) {
            a.onclick = function(e) {
                e.preventDefault();
                goToPage(page);
            };
        } else {
            a.onclick = function(e) {
                e.preventDefault();
            };
        }

        li.appendChild(a);
        container.appendChild(li);
    }

    function goToPage(page) {
        const totalPages = Math.ceil(filteredBatchCards.length / batchesPerPage);
        if (page < 1 || page > totalPages) return;
        displayPage(page);
    }

    // ==================== CÁC HÀM TIỆN ÍCH ====================
    function viewBatchDetail(batchId) {
        window.location.href = '${pageContext.request.contextPath}/tasks/batch/' + batchId;
    }

    function updateBatchStatus(batchId, status) {
        if(confirm('Bạn có chắc muốn cập nhật trạng thái cho toàn bộ batch?')) {
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

    function deleteBatch(batchId) {
        if(confirm('Bạn có chắc muốn xóa toàn bộ batch này? Tất cả task trong batch sẽ bị xóa.')) {
            fetch('${pageContext.request.contextPath}/tasks/batch/' + batchId, {
                method: 'DELETE',
                headers: {
                    'Content-Type': 'application/json',
                }
            })
                .then(response => {
                    if(response.ok) {
                        alert('Xóa batch thành công!');
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

    function exportTasks() {
        alert('Chức năng export đang được phát triển');
    }

    function changeBatchesPerPage(number) {
        batchesPerPage = number;
        currentPage = 1;
        displayPage(1);
    }
</script>
</body>
</html>