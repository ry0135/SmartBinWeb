<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Danh sách hủy - ${batchId}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
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
            background-color: #0d6efd;
            border-color: #0d6efd;
        }
        .pagination .page-link {
            color: #0d6efd;
        }
        .pagination .page-link:hover {
            color: #0a58ca;
        }
    </style>
</head>
<body class="bg-light">
<div class="container-fluid">
    <div class="row">
        <%@include file="../include/sidebar.jsp"%>

        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2 fw-bold text-primary">
                    <i class="fas fa-ban me-2"></i>Danh sách hủy: ${batchId}
                </h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <button class="btn btn-outline-primary" onclick="window.history.back()">
                        <i class="fas fa-arrow-left me-2"></i>Quay lại
                    </button>
                </div>
            </div>

            <div class="card shadow-sm border-0">
                <div class="card-header bg-danger text-white py-3">
                    <h5 class="mb-0">
                        <i class="fas fa-times-circle me-2"></i>Danh sách Task đã hủy
                    </h5>
                </div>
                <div class="card-body p-0">
                    <!-- Controls for pagination -->
                    <div class="table-controls p-3 border-bottom">
                        <div class="d-flex align-items-center">
                            <span class="me-2">Hiển thị:</span>
                            <select id="pageSize" class="form-select form-select-sm page-size-selector">
                                <option value="5">5</option>
                                <option value="10" selected>10</option>
                                <option value="20">20</option>
                                <option value="50">50</option>
                            </select>
                            <span class="ms-2">dòng mỗi trang</span>
                        </div>
                        <div class="d-flex align-items-center">
                            <span id="pageInfo" class="text-muted"></span>
                        </div>
                    </div>

                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead class="table-light">
                            <tr>
                                <th class="px-4 py-3">ID</th>
                                <th class="py-3">Thùng rác</th>
                                <th class="py-3">Loại</th>
                                <th class="py-3">Ưu tiên</th>
                                <th class="py-3">Trạng thái</th>
                                <th class="py-3">Ngày hủy</th>
                            </tr>
                            </thead>
                            <tbody id="taskTableBody">
                            <c:forEach var="task" items="${batchTasks}">
                                <tr>
                                    <td class="px-4 py-3 fw-bold text-primary">#${task.taskID}</td>
                                    <td class="py-3">
                                        <c:if test="${task.bin != null}">
                                            <span class="badge bg-secondary">${task.bin.binCode}</span>
                                        </c:if>
                                    </td>
                                    <td class="py-3">
                                            <span class="badge ${batch.value[0].taskType == 'COLLECT' || batch.value[0].taskType == 'COLLECTION' ? 'bg-primary' : 'bg-warning'}" data-task-type="${batch.value[0].taskType}">
                                <c:choose>
                                    <c:when test="${batch.value[0].taskType == 'COLLECT' || batch.value[0].taskType == 'COLLECTION'}">Thu gom</c:when>
                                    <c:when test="${batch.value[0].taskType == 'MAINTENANCE'}">Bảo trì</c:when>
                                    <c:otherwise>${batch.value[0].taskType}</c:otherwise>
                                </c:choose>
                              </span>
                                    </td>
                                    <td class="py-3">
                                            <span class="badge ${task.priority == 5 ? 'bg-danger' : task.priority == 4 ? 'bg-warning text-dark' : task.priority == 3 ? 'bg-info' : task.priority == 2 ? 'bg-secondary' : 'bg-light text-dark'} px-3 py-2">
                                                <c:choose>
                                                    <c:when test="${task.priority == 5}">
                                                        <i class="fas fa-angle-double-up me-1"></i>Rất cao (5)
                                                    </c:when>
                                                    <c:when test="${task.priority == 4}">
                                                        <i class="fas fa-angle-up me-1"></i>Cao (4)
                                                    </c:when>
                                                    <c:when test="${task.priority == 3}">
                                                        <i class="fas fa-minus me-1"></i>Trung bình (3)
                                                    </c:when>
                                                    <c:when test="${task.priority == 2}">
                                                        <i class="fas fa-angle-down me-1"></i>Thấp (2)
                                                    </c:when>
                                                    <c:when test="${task.priority == 1}">
                                                        <i class="fas fa-angle-double-down me-1"></i>Rất thấp (1)
                                                    </c:when>
                                                </c:choose>
                                            </span>
                                    </td>
                                    <td class="py-3">
                                            <span class="badge bg-danger px-3 py-2">
                                                <i class="fas fa-times-circle me-1"></i>
                                                ĐÃ HỦY
                                            </span>
                                    </td>
                                    <td class="py-3">
                                        <small class="text-muted">
                                            <i class="far fa-calendar-alt me-1"></i>${task.createdAt}
                                        </small>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty batchTasks}">
                                <tr>
                                    <td colspan="6" class="text-center py-5">
                                        <div class="text-muted">
                                            <i class="fas fa-inbox fa-3x mb-3 opacity-50"></i>
                                            <p class="mb-0">Không có task nào đã hủy</p>
                                        </div>
                                    </td>
                                </tr>
                            </c:if>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination controls -->
                    <div class="pagination-container p-3 border-top">
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
            pageInfoElement.textContent = `Hiển thị ${startTask}-${endTask} của ${allTasks.length} tasks`;

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

            // Previous button
            const prevLi = document.createElement('li');
            prevLi.className = `page-item ${currentPage == 1 ? 'disabled' : ''}`;
            prevLi.innerHTML = `<a class="page-link" href="#" aria-label="Previous">
                <span aria-hidden="true">&laquo;</span>
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
                const firstLi = document.createElement('li');
                firstLi.className = 'page-item';
                firstLi.innerHTML = `<a class="page-link" href="#">1</a>`;
                firstLi.addEventListener('click', function(e) {
                    e.preventDefault();
                    currentPage = 1;
                    updateTableDisplay();
                });
                paginationElement.appendChild(firstLi);

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

                const lastLi = document.createElement('li');
                lastLi.className = 'page-item';
                lastLi.innerHTML = `<a class="page-link" href="#">${totalPages}</a>`;
                lastLi.addEventListener('click', function(e) {
                    e.preventDefault();
                    currentPage = totalPages;
                    updateTableDisplay();
                });
                paginationElement.appendChild(lastLi);
            }

            // Next button
            const nextLi = document.createElement('li');
            nextLi.className = `page-item ${currentPage == totalPages ? 'disabled' : ''}`;
            nextLi.innerHTML = `<a class="page-link" href="#" aria-label="Next">
                <span aria-hidden="true">&raquo;</span>
            </a>`;
            nextLi.addEventListener('click', function(e) {
                e.preventDefault();
                if (currentPage < totalPages) {
                    currentPage++;
                    updateTableDisplay();
                }
            });
            paginationElement.appendChild(nextLi);
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
