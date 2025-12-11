<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Danh sách hủy - ${batchId}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }

        .pagination-container {
            display: flex;
            justify-content: center;
            margin-top: 20px;
        }

        .page-size-selector {
            width: 80px;
            display: inline-block;
        }

        .table-controls {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }

        .pagination .page-item.active .page-link {
            background-color: #dc3545;
            border-color: #dc3545;
        }

        .pagination .page-link {
            color: #dc3545;
            transition: all 0.3s ease;
        }

        .pagination .page-link:hover {
            color: #bb2d3b;
            background-color: rgba(220, 53, 69, 0.1);
            transform: translateY(-2px);
        }

        .card {
            border: none;
            border-radius: 12px;
            overflow: hidden;
        }

        .table-hover tbody tr {
            transition: all 0.2s ease;
        }

        .table-hover tbody tr:hover {
            background-color: rgba(220, 53, 69, 0.05);
            transform: scale(1.005);
        }

        /* Reason Display Styles */
        .reason-cell {
            max-width: 300px;
        }

        .reason-badge {
            background: linear-gradient(135deg, #fff5f5 0%, #ffe5e5 100%);
            border: 1px solid #dc3545;
            border-left: 4px solid #dc3545;
            padding: 12px 16px;
            border-radius: 8px;
            display: inline-block;
            max-width: 100%;
            transition: all 0.3s ease;
        }

        .reason-badge:hover {
            box-shadow: 0 4px 12px rgba(220, 53, 69, 0.2);
            transform: translateY(-2px);
        }

        .reason-text {
            color: #721c24;
            font-size: 0.9rem;
            line-height: 1.5;
            margin: 0;
            word-wrap: break-word;
        }

        .reason-icon {
            color: #dc3545;
            margin-right: 8px;
            font-size: 1.1rem;
        }

        .no-reason {
            color: #6c757d;
            font-style: italic;
            padding: 8px 12px;
            background-color: #f8f9fa;
            border-radius: 6px;
            display: inline-block;
        }

        /* Badge animations */
        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-5px); }
            75% { transform: translateX(5px); }
        }

        .badge.bg-danger {
            animation: shake 3s infinite;
        }

        /* Priority badge styles */
        .badge {
            font-weight: 500;
            padding: 0.5rem 0.75rem;
        }

        /* Empty state */
        .empty-state {
            padding: 4rem 2rem;
            text-align: center;
        }

        .empty-state i {
            font-size: 4rem;
            opacity: 0.3;
            margin-bottom: 1.5rem;
        }
    </style>
</head>
<body class="bg-light">
<div class="container-fluid">
    <div class="row">
        <%@include file="../include/sidebar.jsp"%>

        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2 fw-bold text-danger">
                    <i class="fas fa-ban me-2"></i>Danh sách Task đã hủy
                </h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <span class="badge bg-danger me-3 fs-6">
                        <i class="fas fa-hashtag me-1"></i>Batch: ${batchId}
                    </span>
                    <button class="btn btn-outline-primary" onclick="window.history.back()">
                        <i class="fas fa-arrow-left me-2"></i>Quay lại
                    </button>
                </div>
            </div>

            <div class="card shadow-sm">
                <div class="card-header bg-danger text-white py-3">
                    <h5 class="mb-0">
                        <i class="fas fa-times-circle me-2"></i>Danh sách Task đã hủy
                    </h5>
                </div>
                <div class="card-body p-0">
                    <!-- Controls for pagination -->
                    <div class="table-controls p-3 border-bottom bg-light">
                        <div class="d-flex align-items-center">
                            <span class="me-2 text-muted">Hiển thị:</span>
                            <select id="pageSize" class="form-select form-select-sm page-size-selector">
                                <option value="5">5</option>
                                <option value="10" selected>10</option>
                                <option value="20">20</option>
                                <option value="50">50</option>
                            </select>
                            <span class="ms-2 text-muted">dòng mỗi trang</span>
                        </div>
                        <div class="d-flex align-items-center">
                            <span id="pageInfo" class="text-muted"></span>
                        </div>
                    </div>

                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                            <tr>
                                <th class="px-4 py-3 text-center">ID</th>
                                <th class="py-3 text-center">Thùng rác</th>
                                <th class="py-3 text-center">Loại</th>
                                <th class="py-3 text-center">Mức độ</th>
                                <th class="py-3 text-center">Trạng thái</th>
                                <th class="py-3">Lý do hủy</th>
                                <th class="py-3">Ngày hủy</th>
                            </tr>
                            </thead>
                            <tbody id="taskTableBody">
                            <c:forEach var="task" items="${batchTasks}">
                                <tr>
                                    <td class="px-4 py-3 fw-bold text-primary text-center">#${task.taskID}</td>
                                    <td class="py-3 text-center">
                                        <c:if test="${task.bin != null}">
                                            <span class="badge bg-secondary fs-6">
                                                <i class="fas fa-trash me-1"></i>${task.bin.binCode}
                                            </span>
                                        </c:if>
                                    </td>
                                    <td class="py-3 text-center">
                                        <span class="badge ${task.taskType == 'COLLECTION' ? 'bg-primary' : 'bg-warning'}" data-task-type="${task.taskType}">
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
                                    <td class="py-3 text-center">
                                        <span class="badge ${task.priority == 5 ? 'bg-danger' : task.priority == 4 ? 'bg-warning text-dark' : task.priority == 3 ? 'bg-info text-dark' : task.priority == 2 ? 'bg-secondary' : 'bg-dark'} px-3 py-2">
                                            <c:choose>
                                                <c:when test="${task.priority == 5}">
                                                    <i class="fas fa-exclamation-circle me-1"></i>Cực cao
                                                </c:when>
                                                <c:when test="${task.priority == 4}">
                                                    <i class="fas fa-arrow-up me-1"></i>Cao
                                                </c:when>
                                                <c:when test="${task.priority == 3}">
                                                    <i class="fas fa-minus me-1"></i>Trung bình
                                                </c:when>
                                                <c:when test="${task.priority == 2}">
                                                    <i class="fas fa-arrow-down me-1"></i>Thấp
                                                </c:when>
                                                <c:when test="${task.priority == 1}">
                                                    <i class="fas fa-level-down-alt me-1"></i>Rất thấp
                                                </c:when>
                                            </c:choose>
                                        </span>
                                    </td>
                                    <td class="py-3 text-center">
                                        <span class="badge bg-danger px-3 py-2 fs-6">
                                            <i class="fas fa-times-circle me-1"></i>ĐÃ HỦY
                                        </span>
                                    </td>
                                    <td class="py-3 reason-cell">
                                        <c:choose>
                                            <c:when test="${not empty task.issueReason}">
                                                <div class="reason-badge">
                                                    <i class="fas fa-comment-alt reason-icon"></i>
                                                    <p class="reason-text d-inline">${task.issueReason}</p>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="no-reason">
                                                    <i class="fas fa-question-circle me-1"></i>
                                                    Không có lý do
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="py-3">
                                        <div class="d-flex align-items-center">
                                            <i class="far fa-calendar-times text-danger me-2"></i>
                                            <small class="text-muted">${task.updatedAt}</small>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty batchTasks}">
                                <tr>
                                    <td colspan="7" class="text-center">
                                        <div class="empty-state">
                                            <i class="fas fa-inbox text-muted d-block"></i>
                                            <h5 class="text-muted mb-2">Không có task nào đã hủy</h5>
                                            <p class="text-muted mb-0">Batch này chưa có task nào bị hủy</p>
                                        </div>
                                    </td>
                                </tr>
                            </c:if>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination controls -->
                    <div class="pagination-container p-3 border-top bg-light">
                        <nav aria-label="Page navigation">
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Get all task rows
        const allTasks = Array.from(document.querySelectorAll('#taskTableBody tr'));
        const tableBody = document.getElementById('taskTableBody');
        const paginationElement = document.getElementById('pagination');
        const pageSizeSelector = document.getElementById('pageSize');
        const pageInfoElement = document.getElementById('pageInfo');

        // Initialize pagination variables
        let currentPage = 1;
        let pageSize = parseInt(pageSizeSelector.value);
        let totalPages = 0;

        // Function to update the table display
        function updateTableDisplay() {
            // Clear the table body
            tableBody.innerHTML = '';

            // Calculate start and end indices for current page
            const startIndex = (currentPage - 1) * pageSize;
            const endIndex = Math.min(startIndex + pageSize, allTasks.length);

            // Add tasks for current page
            for (let i = startIndex; i < endIndex; i++) {
                tableBody.appendChild(allTasks[i].cloneNode(true));
            }

            // Update page info
            const startTask = allTasks.length > 0 ? startIndex + 1 : 0;
            const endTask = endIndex;
            pageInfoElement.innerHTML = `<i class="fas fa-info-circle me-2"></i>Hiển thị <strong class="text-danger">${startTask}-${endTask}</strong> của <strong class="text-danger">${allTasks.length}</strong> tasks`;

            // Update pagination controls
            updatePaginationControls();
        }

        // Function to update pagination controls
        function updatePaginationControls() {
            // Clear existing pagination
            paginationElement.innerHTML = '';

            // Calculate total pages
            totalPages = Math.ceil(allTasks.length / pageSize);

            // Don't show pagination if there's only one page
            if (totalPages <= 1) {
                return;
            }

            // First button
            const firstLi = document.createElement('li');
            firstLi.className = `page-item ${currentPage == 1 ? 'disabled' : ''}`;
            firstLi.innerHTML = `<a class="page-link" href="#" title="Trang đầu">
                <i class="fas fa-angle-double-left"></i>
            </a>`;
            firstLi.addEventListener('click', function(e) {
                e.preventDefault();
                if (currentPage > 1) {
                    currentPage = 1;
                    updateTableDisplay();
                }
            });
            paginationElement.appendChild(firstLi);

            // Previous button
            const prevLi = document.createElement('li');
            prevLi.className = `page-item ${currentPage == 1 ? 'disabled' : ''}`;
            prevLi.innerHTML = `<a class="page-link" href="#" title="Trang trước">
                <i class="fas fa-chevron-left"></i>
            </a>`;
            prevLi.addEventListener('click', function(e) {
                e.preventDefault();
                if (currentPage > 1) {
                    currentPage--;
                    updateTableDisplay();
                }
            });
            paginationElement.appendChild(prevLi);

            // Page numbers
            const maxVisiblePages = 5;
            let startPage = Math.max(1, currentPage - Math.floor(maxVisiblePages / 2));
            let endPage = Math.min(totalPages, startPage + maxVisiblePages - 1);

            // Adjust start page if we're near the end
            if (endPage - startPage + 1 < maxVisiblePages) {
                startPage = Math.max(1, endPage - maxVisiblePages + 1);
            }

            // First page if needed
            if (startPage > 1) {
                const firstPageLi = document.createElement('li');
                firstPageLi.className = 'page-item';
                firstPageLi.innerHTML = `<a class="page-link" href="#">1</a>`;
                firstPageLi.addEventListener('click', function(e) {
                    e.preventDefault();
                    currentPage = 1;
                    updateTableDisplay();
                });
                paginationElement.appendChild(firstPageLi);

                // Ellipsis if needed
                if (startPage > 2) {
                    const ellipsisLi = document.createElement('li');
                    ellipsisLi.className = 'page-item disabled';
                    ellipsisLi.innerHTML = `<span class="page-link">...</span>`;
                    paginationElement.appendChild(ellipsisLi);
                }
            }

            // Page numbers
            for (let i = startPage; i <= endPage; i++) {
                const pageLi = document.createElement('li');
                pageLi.className = `page-item ${i == currentPage ? 'active' : ''}`;
                pageLi.innerHTML = `<a class="page-link" href="#">${i}</a>`;
                pageLi.addEventListener('click', function(e) {
                    e.preventDefault();
                    currentPage = i;
                    updateTableDisplay();
                });
                paginationElement.appendChild(pageLi);
            }

            // Last page if needed
            if (endPage < totalPages) {
                // Ellipsis if needed
                if (endPage < totalPages - 1) {
                    const ellipsisLi = document.createElement('li');
                    ellipsisLi.className = 'page-item disabled';
                    ellipsisLi.innerHTML = `<span class="page-link">...</span>`;
                    paginationElement.appendChild(ellipsisLi);
                }

                const lastPageLi = document.createElement('li');
                lastPageLi.className = 'page-item';
                lastPageLi.innerHTML = `<a class="page-link" href="#">${totalPages}</a>`;
                lastPageLi.addEventListener('click', function(e) {
                    e.preventDefault();
                    currentPage = totalPages;
                    updateTableDisplay();
                });
                paginationElement.appendChild(lastPageLi);
            }

            // Next button
            const nextLi = document.createElement('li');
            nextLi.className = `page-item ${currentPage == totalPages ? 'disabled' : ''}`;
            nextLi.innerHTML = `<a class="page-link" href="#" title="Trang sau">
                <i class="fas fa-chevron-right"></i>
            </a>`;
            nextLi.addEventListener('click', function(e) {
                e.preventDefault();
                if (currentPage < totalPages) {
                    currentPage++;
                    updateTableDisplay();
                }
            });
            paginationElement.appendChild(nextLi);

            // Last button
            const lastLi = document.createElement('li');
            lastLi.className = `page-item ${currentPage == totalPages ? 'disabled' : ''}`;
            lastLi.innerHTML = `<a class="page-link" href="#" title="Trang cuối">
                <i class="fas fa-angle-double-right"></i>
            </a>`;
            lastLi.addEventListener('click', function(e) {
                e.preventDefault();
                if (currentPage < totalPages) {
                    currentPage = totalPages;
                    updateTableDisplay();
                }
            });
            paginationElement.appendChild(lastLi);
        }

        // Event listener for page size change
        pageSizeSelector.addEventListener('change', function() {
            pageSize = parseInt(this.value);
            currentPage = 1; // Reset to first page when changing page size
            updateTableDisplay();
        });

        // Initialize the table display
        updateTableDisplay();
    });
</script>
</body>
</html>