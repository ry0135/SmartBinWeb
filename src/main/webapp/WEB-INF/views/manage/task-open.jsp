<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Chi tiết Batch đang mở - ${batchId}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }

        .action-btn {
            transition: all 0.3s ease;
        }

        .action-btn:hover {
            transform: scale(1.1);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }

        .card {
            border: none;
            border-radius: 12px;
        }

        .card-header {
            border-radius: 12px 12px 0 0 !important;
        }

        .table-hover tbody tr {
            transition: all 0.2s ease;
        }

        .table-hover tbody tr:hover {
            background-color: rgba(40, 167, 69, 0.05);
            transform: scale(1.01);
        }

        .badge {
            padding: 0.5rem 0.75rem;
            font-weight: 500;
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

        /* Priority badges animation */
        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }

        .badge.bg-danger {
            animation: pulse 2s infinite;
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
                    <h2 class="mb-1"><i class="fas fa-box-open text-warning me-2"></i>Chi tiết Nhiệm Vụ</h2>
                    <p class="text-muted mb-0">Mã Batch: <span class="badge bg-warning text-dark">${batchId}</span></p>
                </div>
                <div>
                    <button class="btn btn-danger me-2" onclick="deleteBatch('${batchId}')">
                        <i class="fas fa-trash-alt me-2"></i>Xóa Batch
                    </button>
                    <button class="btn btn-outline-primary" onclick="window.history.back()">
                        <i class="fas fa-arrow-left me-2"></i>Quay lại
                    </button>
                </div>
            </div>

            <!-- Task List Card -->
            <div class="card shadow-sm">
                <div class="card-header bg-warning text-dark">
                    <h5 class="mb-0"><i class="fas fa-tasks me-2"></i>Danh sách Task trong Batch</h5>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                            <tr>
                                <th class="text-center">ID</th>
                                <th class="text-center">Thùng rác</th>
                                <th class="text-center">Loại</th>
                                <th class="text-center">Mức độ</th>
                                <th class="text-center">Trạng thái</th>
                                <th>Ngày tạo</th>
                                <th class="text-center" style="width: 200px;">Hành động</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="task" items="${batchTasks}">
                                <tr>
                                    <td class="text-center fw-bold">#${task.taskID}</td>
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
                                        <span class="badge ${task.taskType == 'COLLECTION' ? 'bg-primary' : 'bg-warning'}" data-task-type="${task.taskType}">
                                            <c:choose>
                                                <c:when test="${task.taskType == 'COLLECTION'}">Thu gom</c:when>
                                                <c:when test="${task.taskType == 'MAINTENANCE'}">Bảo trì</c:when>
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
                                    <td class="text-center">
                                        <span class="badge ${task.status == 'OPEN' ? 'bg-primary' : task.status == 'DOING' ? 'bg-warning text-dark' : task.status == 'COMPLETED' ? 'bg-success' : 'bg-secondary'} fs-6">
                                            <c:choose>
                                                <c:when test="${task.status == 'OPEN'}">
                                                    <i class="fas fa-folder-open me-1"></i>Mở
                                                </c:when>
                                                <c:when test="${task.status == 'DOING'}">
                                                    <i class="fas fa-spinner me-1"></i>Đang làm
                                                </c:when>
                                                <c:when test="${task.status == 'COMPLETED'}">
                                                    <i class="fas fa-check-circle me-1"></i>Hoàn thành
                                                </c:when>
                                                <c:otherwise>
                                                    ${task.status}
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </td>
                                    <td>
                                        <small class="text-muted">
                                            <i class="far fa-calendar-plus me-1"></i>${task.createdAt}
                                        </small>
                                    </td>
                                    <td class="text-center">
                                        <button class="btn btn-sm btn-outline-danger action-btn"
                                                onclick="deleteTask(${task.taskID})"
                                                title="Xóa">
                                            <i class="fas fa-trash-alt me-1"></i>Xóa
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty batchTasks}">
                                <tr>
                                    <td colspan="7" class="text-center py-5">
                                        <i class="fas fa-inbox fa-4x text-muted mb-3 d-block"></i>
                                        <h5 class="text-muted">Không có task nào trong batch này</h5>
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
                        <div class="text-muted">
                            <c:choose>
                                <c:when test="${not empty batchTasks}">
                                    <i class="fas fa-info-circle me-2"></i>
                                    Hiển thị <strong class="text-success">${(currentPage - 1) * pageSize + 1}</strong>
                                    đến <strong class="text-success">${(currentPage - 1) * pageSize + batchTasks.size()}</strong>
                                    trong tổng số <strong class="text-success">${totalTasks}</strong> task
                                </c:when>
                                <c:otherwise>
                                    <i class="fas fa-info-circle me-2"></i>
                                    Tổng số <strong>0</strong> task
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Phân trang -->
                        <c:if test="${totalPages > 1}">
                            <nav aria-label="Phân trang">
                                <ul class="pagination mb-0">
                                    <!-- First Page -->
                                    <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                                        <a class="page-link" href="?batchId=${batchId}&page=1" aria-label="First" title="Trang đầu">
                                            <i class="fas fa-angle-double-left"></i>
                                        </a>
                                    </li>

                                    <!-- Previous -->
                                    <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                                        <a class="page-link" href="?batchId=${batchId}&page=${currentPage - 1}" aria-label="Previous" title="Trang trước">
                                            <i class="fas fa-chevron-left"></i>
                                        </a>
                                    </li>

                                    <!-- Page Numbers -->
                                    <c:set var="startPage" value="${currentPage - 2 < 1 ? 1 : currentPage - 2}" />
                                    <c:set var="endPage" value="${currentPage + 2 > totalPages ? totalPages : currentPage + 2}" />

                                    <!-- First page if not in range -->
                                    <c:if test="${startPage > 1}">
                                        <li class="page-item">
                                            <a class="page-link" href="?batchId=${batchId}&page=1">1</a>
                                        </li>
                                        <c:if test="${startPage > 2}">
                                            <li class="page-item disabled">
                                                <span class="page-link">...</span>
                                            </li>
                                        </c:if>
                                    </c:if>

                                    <!-- Page range -->
                                    <c:forEach begin="${startPage}" end="${endPage}" var="i">
                                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                                            <a class="page-link" href="?batchId=${batchId}&page=${i}">${i}</a>
                                        </li>
                                    </c:forEach>

                                    <!-- Last page if not in range -->
                                    <c:if test="${endPage < totalPages}">
                                        <c:if test="${endPage < totalPages - 1}">
                                            <li class="page-item disabled">
                                                <span class="page-link">...</span>
                                            </li>
                                        </c:if>
                                        <li class="page-item">
                                            <a class="page-link" href="?batchId=${batchId}&page=${totalPages}">${totalPages}</a>
                                        </li>
                                    </c:if>

                                    <!-- Next -->
                                    <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                                        <a class="page-link" href="?batchId=${batchId}&page=${currentPage + 1}" aria-label="Next" title="Trang sau">
                                            <i class="fas fa-chevron-right"></i>
                                        </a>
                                    </li>

                                    <!-- Last Page -->
                                    <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                                        <a class="page-link" href="?batchId=${batchId}&page=${totalPages}" aria-label="Last" title="Trang cuối">
                                            <i class="fas fa-angle-double-right"></i>
                                        </a>
                                    </li>
                                </ul>
                            </nav>
                        </c:if>

                        <!-- Page Size Selector (Optional) -->
                        <c:if test="${totalTasks > 10}">
                            <div class="d-flex align-items-center gap-2">
                                <label class="text-muted mb-0 small">Hiển thị:</label>
                                <select class="form-select form-select-sm" style="width: auto;" onchange="changePageSize(this.value)">
                                    <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                                    <option value="20" ${pageSize == 20 ? 'selected' : ''}>20</option>
                                    <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
                                    <option value="100" ${pageSize == 100 ? 'selected' : ''}>100</option>
                                </select>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function updateTask(taskId) {
        window.location.href = '${pageContext.request.contextPath}/tasks/edit/' + taskId;
    }

    function deleteTask(taskId) {
        if(confirm('Bạn có chắc muốn xóa task này?')) {
            fetch('${pageContext.request.contextPath}/tasks/' + taskId, {
                method: 'DELETE',
                headers: {
                    'Content-Type': 'application/json',
                }
            })
                .then(response => {
                    if(response.ok) {
                        showSuccessAlert('Xóa task thành công!');
                        setTimeout(() => location.reload(), 1000);
                    } else {
                        showErrorAlert('Xóa task thất bại!');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showErrorAlert('Có lỗi xảy ra!');
                });
        }
    }

    function deleteBatch(batchId) {
        if(confirm('Bạn có chắc muốn xóa toàn bộ batch này?\nTất cả task trong batch sẽ bị xóa.')) {
            fetch('${pageContext.request.contextPath}/tasks/batch/' + batchId, {
                method: 'DELETE',
                headers: {
                    'Content-Type': 'application/json',
                }
            })
                .then(response => {
                    if(response.ok) {
                        showSuccessAlert('Xóa batch thành công!');
                        setTimeout(() => {
                            window.location.href = '${pageContext.request.contextPath}/tasks/management';
                        }, 1000);
                    } else {
                        showErrorAlert('Xóa batch thất bại!');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showErrorAlert('Có lỗi xảy ra!');
                });
        }
    }

    function changePageSize(size) {
        const urlParams = new URLSearchParams(window.location.search);
        urlParams.set('pageSize', size);
        urlParams.set('page', '1'); // Reset về trang 1
        window.location.search = urlParams.toString();
    }

    function showSuccessAlert(message) {
        const alertDiv = document.createElement('div');
        alertDiv.className = 'alert alert-success alert-dismissible fade show position-fixed top-0 start-50 translate-middle-x mt-3';
        alertDiv.style.zIndex = '9999';
        alertDiv.innerHTML = `
            <i class="fas fa-check-circle me-2"></i>${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        `;
        document.body.appendChild(alertDiv);
        setTimeout(() => alertDiv.remove(), 3000);
    }

    function showErrorAlert(message) {
        const alertDiv = document.createElement('div');
        alertDiv.className = 'alert alert-danger alert-dismissible fade show position-fixed top-0 start-50 translate-middle-x mt-3';
        alertDiv.style.zIndex = '9999';
        alertDiv.innerHTML = `
            <i class="fas fa-exclamation-circle me-2"></i>${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        `;
        document.body.appendChild(alertDiv);
        setTimeout(() => alertDiv.remove(), 3000);
    }
</script>
</body>
</html>