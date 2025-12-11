<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Chi tiết Batch đã hoàn thành - ${batchId}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }

        .card {
            border: none;
            border-radius: 12px;
            overflow: hidden;
        }

        .card-header {
            border-radius: 12px 12px 0 0 !important;
        }

        /* Image Styles */
        .task-image {
            width: 100px;
            height: 100px;
            object-fit: cover;
            cursor: pointer;
            transition: all 0.3s ease;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .task-image:hover {
            transform: scale(1.15);
            box-shadow: 0 4px 16px rgba(40, 167, 69, 0.4);
            z-index: 10;
        }

        .image-placeholder {
            width: 100px;
            height: 100px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: 8px;
            border: 2px dashed #dee2e6;
            transition: all 0.3s ease;
        }

        .image-placeholder:hover {
            background: linear-gradient(135deg, #e9ecef 0%, #dee2e6 100%);
            border-color: #adb5bd;
        }

        .modal-image {
            max-width: 100%;
            max-height: 80vh;
            object-fit: contain;
            border-radius: 8px;
        }

        /* Table Styles */
        .table-hover tbody tr {
            transition: all 0.2s ease;
        }

        .table-hover tbody tr:hover {
            background-color: rgba(40, 167, 69, 0.05);
            transform: scale(1.002);
        }

        /* Badge Styles */
        .badge {
            padding: 0.5rem 0.75rem;
            font-weight: 500;
        }

        /* Success badge animation */
        @keyframes checkPulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }

        .badge.bg-success {
            animation: checkPulse 2s infinite;
        }

        /* Pagination Styles */
        .pagination {
            gap: 0.25rem;
        }

        .page-item .page-link {
            border-radius: 8px;
            border: 1px solid #dee2e6;
            color: #28a745;
            transition: all 0.3s ease;
            margin: 0 2px;
        }

        .page-item .page-link:hover {
            background-color: #28a745;
            color: white;
            border-color: #28a745;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(40, 167, 69, 0.3);
        }

        .page-item.active .page-link {
            background-color: #28a745;
            border-color: #28a745;
            font-weight: bold;
            box-shadow: 0 4px 8px rgba(40, 167, 69, 0.4);
        }

        .page-item.disabled .page-link {
            opacity: 0.5;
        }

        /* Modal Styles */
        .modal-content {
            border-radius: 12px;
            overflow: hidden;
        }

        .modal-body.bg-dark {
            background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%) !important;
        }

        /* Empty State */
        .empty-state {
            padding: 4rem 2rem;
            text-align: center;
        }

        .empty-state i {
            font-size: 4rem;
            opacity: 0.3;
            margin-bottom: 1.5rem;
        }

        /* User Info */
        .user-info {
            display: flex;
            align-items: center;
            padding: 0.5rem 0.75rem;
            background: linear-gradient(135deg, #e8f5e9 0%, #c8e6c9 100%);
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .user-info:hover {
            transform: translateX(5px);
            box-shadow: 0 2px 8px rgba(40, 167, 69, 0.2);
        }

        .user-info i {
            color: #28a745;
            margin-right: 0.5rem;
        }

        /* Header Badge */
        .header-badge {
            font-size: 1rem;
            padding: 0.5rem 1rem;
            animation: fadeIn 0.5s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <%@include file="../include/sidebar.jsp"%>

        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">
            <!-- Header -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="mb-1">
                        <i class="fas fa-check-circle text-success me-2"></i>Chi tiết Batch Hoàn thành
                    </h2>
                    <p class="text-muted mb-0">
                        Mã Batch: <span class="badge bg-success header-badge">${batchId}</span>
                    </p>
                </div>
                <button class="btn btn-outline-success" onclick="window.history.back()">
                    <i class="fas fa-arrow-left me-2"></i>Quay lại
                </button>
            </div>

            <!-- Task List Card -->
            <div class="card shadow-sm">
                <div class="card-header bg-success text-white py-3">
                    <h5 class="mb-0">
                        <i class="fas fa-tasks me-2"></i>Danh sách Task đã hoàn thành
                    </h5>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                            <tr>
                                <th class="text-center">ID</th>
                                <th class="text-center">Hình ảnh</th>
                                <th class="text-center">Thùng rác</th>
                                <th class="text-center">Loại</th>
                                <th class="text-center">Mức độ</th>
                                <th>Người thực hiện</th>
                                <th class="text-center">Trạng thái</th>
                                <th>Ngày hoàn thành</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="task" items="${batchTasks}">
                                <tr>
                                    <td class="text-center fw-bold text-success">#${task.taskID}</td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${task.afterImage != null && !empty task.afterImage}">
                                                <c:choose>
                                                    <c:when test="${task.afterImage.startsWith('http')}">
                                                        <img src="${task.afterImage}"
                                                             class="task-image"
                                                             alt="Task Image"
                                                             onclick="showImage('${task.afterImage}', ${task.taskID})"
                                                             onerror="handleImageError(this)">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img src="${pageContext.request.contextPath}${task.afterImage}"
                                                             class="task-image"
                                                             alt="Task Image"
                                                             onclick="showImage('${pageContext.request.contextPath}${task.afterImage}', ${task.taskID})"
                                                             onerror="handleImageError(this)">
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="image-placeholder">
                                                    <i class="fas fa-image fa-2x text-muted"></i>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${task.bin != null}">
                                                <span class="badge bg-secondary fs-6">
                                                    <i class="fas fa-trash me-1"></i>${task.bin.binCode}
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">—</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <span class="badge ${task.taskType == 'COLLECTION' ? 'bg-primary' : 'bg-warning text-dark'}" data-task-type="${task.taskType}">
                                            <c:choose>
                                                <c:when test="${task.taskType == 'COLLECTION'}">
                                                    <i class="fas fa-recycle me-1"></i>Thu gom
                                                </c:when>
                                                <c:when test="${task.taskType == 'MAINTENANCE'}">
                                                    <i class="fas fa-tools me-1"></i>Bảo trì
                                                </c:when>
                                                <c:otherwise>${task.taskType}</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </td>
                                    <td class="text-center">
                                        <!-- ĐÃ ĐẢO NGƯỢC: 5 = CAO NHẤT, 1 = THẤP NHẤT -->
                                        <c:choose>
                                            <c:when test="${task.priority == 5}">
                                                <span class="badge bg-danger fs-6">
                                                    <i class="fas fa-exclamation-circle me-1"></i>Cực cao
                                                </span>
                                            </c:when>
                                            <c:when test="${task.priority == 4}">
                                                <span class="badge bg-warning text-dark fs-6">
                                                    <i class="fas fa-arrow-up me-1"></i>Cao
                                                </span>
                                            </c:when>
                                            <c:when test="${task.priority == 3}">
                                                <span class="badge bg-info text-dark fs-6">
                                                    <i class="fas fa-minus me-1"></i>Trung bình
                                                </span>
                                            </c:when>
                                            <c:when test="${task.priority == 2}">
                                                <span class="badge bg-secondary fs-6">
                                                    <i class="fas fa-arrow-down me-1"></i>Thấp
                                                </span>
                                            </c:when>
                                            <c:when test="${task.priority == 1}">
                                                <span class="badge bg-dark fs-6">
                                                    <i class="fas fa-level-down-alt me-1"></i>Rất thấp
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-light text-dark fs-6">
                                                        ${task.priority}
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${task.assignedTo != null}">
                                                <div class="user-info">
                                                    <i class="fas fa-user-check"></i>
                                                    <span>${task.assignedTo.fullName}</span>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted fst-italic">
                                                    <i class="fas fa-user-slash me-1"></i>Chưa gán
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <span class="badge bg-success fs-6">
                                            <i class="fas fa-check-circle me-1"></i>Hoàn thành
                                        </span>
                                    </td>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <i class="far fa-calendar-check text-success me-2"></i>
                                            <small class="text-muted">${task.completedAt}</small>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty batchTasks}">
                                <tr>
                                    <td colspan="8" class="text-center">
                                        <div class="empty-state">
                                            <i class="fas fa-inbox text-muted d-block"></i>
                                            <h5 class="text-muted mb-2">Không có task nào trong batch này</h5>
                                            <p class="text-muted mb-0">Batch này chưa có task hoàn thành nào</p>
                                        </div>
                                    </td>
                                </tr>
                            </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- PHÂN TRANG CẢI TIẾN -->
                <div class="card-footer bg-white border-top">
                    <div class="d-flex justify-content-between align-items-center flex-wrap gap-3">
                        <!-- Thông tin số lượng -->
                        <div class="d-flex align-items-center gap-3 flex-wrap">
                            <div class="text-muted">
                                <i class="fas fa-info-circle me-2"></i>
                                <span id="pageInfo">Hiển thị 1-10 của 0 task</span>
                            </div>

                            <!-- Page Size Selector -->
                            <div class="d-flex align-items-center gap-2">
                                <label class="text-muted mb-0 small">Hiển thị:</label>
                                <select id="pageSize" class="form-select form-select-sm" style="width: 80px;">
                                    <option value="5">5</option>
                                    <option value="10" selected>10</option>
                                    <option value="20">20</option>
                                    <option value="50">50</option>
                                </select>
                            </div>
                        </div>

                        <!-- Phân trang -->
                        <nav aria-label="Phân trang">
                            <ul class="pagination mb-0" id="pagination">
                                <!-- Pagination will be generated by JavaScript -->
                            </ul>
                        </nav>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- Modal xem ảnh -->
<div class="modal fade" id="imageModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-xl">
        <div class="modal-content">
            <div class="modal-header bg-success text-white">
                <h5 class="modal-title">
                    <i class="fas fa-image me-2"></i>Hình ảnh hoàn thành Task #<span id="modalTaskId"></span>
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body text-center bg-dark p-4">
                <img id="modalImage" src="" class="modal-image" alt="Task Image" onerror="handleModalImageError(this)">
            </div>
            <div class="modal-footer bg-light">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                    <i class="fas fa-times me-2"></i>Đóng
                </button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    let modal;

    function showImage(imageUrl, taskId) {
        if(!imageUrl || imageUrl === '') {
            showAlert('Không có hình ảnh để hiển thị', 'warning');
            return;
        }
        document.getElementById('modalImage').src = imageUrl;
        document.getElementById('modalTaskId').textContent = taskId;
        modal = new bootstrap.Modal(document.getElementById('imageModal'));
        modal.show();
    }

    function handleImageError(img) {
        img.style.display = 'none';
        const parent = img.parentElement;
        parent.innerHTML = '<div class="image-placeholder"><i class="fas fa-exclamation-triangle fa-2x text-warning"></i></div>';
    }

    function handleModalImageError(img) {
        img.style.display = 'none';
        var modalBody = document.querySelector('.modal-body');
        modalBody.innerHTML = '<div class="alert alert-warning m-3">' +
            '<i class="fas fa-exclamation-triangle me-2"></i>' +
            '<strong>Không thể tải hình ảnh</strong>' +
            '<p class="mb-0 mt-2">Hình ảnh có thể đã bị xóa hoặc đường dẫn không đúng.</p>' +
            '</div>';
    }

    function showAlert(message, type) {
        if (!type) type = 'info';

        var iconClass = 'info-circle';
        if (type == 'success') {
            iconClass = 'check-circle';
        } else if (type == 'warning') {
            iconClass = 'exclamation-triangle';
        }

        var alertDiv = document.createElement('div');
        alertDiv.className = 'alert alert-' + type + ' alert-dismissible fade show position-fixed top-0 start-50 translate-middle-x mt-3';
        alertDiv.style.zIndex = '9999';
        alertDiv.innerHTML = '<i class="fas fa-' + iconClass + ' me-2"></i>' + message + '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>';
        document.body.appendChild(alertDiv);
        setTimeout(function() { alertDiv.remove(); }, 3000);
    }

    // Close modal with Escape key
    document.addEventListener('keydown', function(e) {
        const modalElement = document.getElementById('imageModal');
        if(modalElement && modalElement.classList.contains('show') && e.key === 'Escape' && modal) {
            modal.hide();
        }
    });

    // Image loading animation
    document.querySelectorAll('.task-image').forEach(img => {
        img.addEventListener('load', function() {
            this.style.opacity = '0';
            setTimeout(() => {
                this.style.transition = 'opacity 0.5s ease';
                this.style.opacity = '1';
            }, 100);
        });
    });

    // ==================== PHÂN TRANG CLIENT-SIDE ====================
    document.addEventListener('DOMContentLoaded', function() {
        var tbody = document.querySelector('tbody');
        var allRows = Array.from(tbody.querySelectorAll('tr')).filter(function(row) {
            return !row.querySelector('.empty-state');
        });

        // Nếu không có dữ liệu, không cần phân trang
        if (allRows.length === 0) {
            document.getElementById('pageInfo').innerHTML = '<i class="fas fa-info-circle me-2"></i>Tổng số <strong>0</strong> task';
            return;
        }

        var paginationElement = document.getElementById('pagination');
        var pageSizeSelector = document.getElementById('pageSize');
        var pageInfoElement = document.getElementById('pageInfo');

        var currentPage = 1;
        var pageSize = parseInt(pageSizeSelector.value);
        var totalPages = 0;

        function updateTable() {
            tbody.innerHTML = '';

            var startIndex = (currentPage - 1) * pageSize;
            var endIndex = Math.min(startIndex + pageSize, allRows.length);

            for (var i = startIndex; i < endIndex; i++) {
                tbody.appendChild(allRows[i].cloneNode(true));
            }

            // Re-attach image event listeners
            tbody.querySelectorAll('.task-image').forEach(function(img) {
                var src = img.src;
                var onclickAttr = img.getAttribute('onclick');
                if (onclickAttr) {
                    var taskIdMatch = onclickAttr.match(/\d+/);
                    if (taskIdMatch) {
                        var taskId = taskIdMatch[0];
                        img.onclick = function() { showImage(src, taskId); };
                    }
                }

                img.addEventListener('load', function() {
                    this.style.opacity = '0';
                    setTimeout(function() {
                        img.style.transition = 'opacity 0.5s ease';
                        img.style.opacity = '1';
                    }, 100);
                });
            });

            var startTask = allRows.length > 0 ? startIndex + 1 : 0;
            var endTask = endIndex;
            pageInfoElement.innerHTML = '<i class="fas fa-info-circle me-2"></i>' +
                'Hiển thị <strong class="text-success">' + startTask + '</strong> ' +
                'đến <strong class="text-success">' + endTask + '</strong> ' +
                'trong tổng số <strong class="text-success">' + allRows.length + '</strong> task';

            updatePagination();
        }

        function updatePagination() {
            paginationElement.innerHTML = '';
            totalPages = Math.ceil(allRows.length / pageSize);

            if (totalPages <= 1) return;

            // First button
            addPageButton('first', currentPage === 1, function() { currentPage = 1; updateTable(); },
                '<i class="fas fa-angle-double-left"></i>', 'Trang đầu');

            // Previous button
            addPageButton('prev', currentPage === 1, function() { currentPage--; updateTable(); },
                '<i class="fas fa-chevron-left"></i>', 'Trang trước');

            // Page numbers
            var maxVisible = 5;
            var startPage = Math.max(1, currentPage - Math.floor(maxVisible / 2));
            var endPage = Math.min(totalPages, startPage + maxVisible - 1);

            if (endPage - startPage + 1 < maxVisible) {
                startPage = Math.max(1, endPage - maxVisible + 1);
            }

            // First page
            if (startPage > 1) {
                addPageNumber(1);
                if (startPage > 2) {
                    addEllipsis();
                }
            }

            // Page numbers
            for (var i = startPage; i <= endPage; i++) {
                addPageNumber(i);
            }

            // Last page
            if (endPage < totalPages) {
                if (endPage < totalPages - 1) {
                    addEllipsis();
                }
                addPageNumber(totalPages);
            }

            // Next button
            addPageButton('next', currentPage === totalPages, function() { currentPage++; updateTable(); },
                '<i class="fas fa-chevron-right"></i>', 'Trang sau');

            // Last button
            addPageButton('last', currentPage === totalPages, function() { currentPage = totalPages; updateTable(); },
                '<i class="fas fa-angle-double-right"></i>', 'Trang cuối');
        }

        function addPageButton(type, disabled, onClick, html, title) {
            var li = document.createElement('li');
            li.className = 'page-item' + (disabled ? ' disabled' : '');
            li.innerHTML = '<a class="page-link" href="#" title="' + title + '">' + html + '</a>';
            if (!disabled) {
                li.querySelector('a').addEventListener('click', function(e) {
                    e.preventDefault();
                    onClick();
                });
            }
            paginationElement.appendChild(li);
        }

        function addPageNumber(page) {
            var li = document.createElement('li');
            li.className = 'page-item' + (page === currentPage ? ' active' : '');
            li.innerHTML = '<a class="page-link" href="#">' + page + '</a>';
            li.querySelector('a').addEventListener('click', function(e) {
                e.preventDefault();
                currentPage = page;
                updateTable();
            });
            paginationElement.appendChild(li);
        }

        function addEllipsis() {
            var li = document.createElement('li');
            li.className = 'page-item disabled';
            li.innerHTML = '<span class="page-link">...</span>';
            paginationElement.appendChild(li);
        }

        pageSizeSelector.addEventListener('change', function() {
            pageSize = parseInt(this.value);
            currentPage = 1;
            updateTable();
        });

        updateTable();
    });
</script>
</body>
</html>