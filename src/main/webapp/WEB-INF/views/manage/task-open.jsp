<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Chi tiết Batch đang mở - ${batchId}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .action-btn {
            transition: transform 0.2s;
        }
        .action-btn:hover {
            transform: scale(1.05);
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
                                        <span class="badge ${task.taskType == 'COLLECT' ? 'bg-primary' : task.taskType == 'CLEAN' ? 'bg-info' : 'bg-warning'} fs-6">
                                            <c:choose>
                                                <c:when test="${task.taskType == 'COLLECT'}">
                                                    <i class="fas fa-hand-holding me-1"></i>Thu gom
                                                </c:when>
                                                <c:when test="${task.taskType == 'CLEAN'}">
                                                    <i class="fas fa-broom me-1"></i>Dọn dẹp
                                                </c:when>
                                                <c:when test="${task.taskType == 'MAINTENANCE'}">
                                                    <i class="fas fa-tools me-1"></i>Bảo trì
                                                </c:when>
                                                <c:otherwise>
                                                    ${task.taskType}
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${task.priority == 1}">
                                                <span class="badge bg-danger fs-6">
                                                    <i class="fas fa-exclamation-circle me-1"></i>Cực cao
                                                </span>
                                            </c:when>
                                            <c:when test="${task.priority == 2}">
                                                <span class="badge bg-warning text-dark fs-6">
                                                    <i class="fas fa-arrow-up me-1"></i>Cao
                                                </span>
                                            </c:when>
                                            <c:when test="${task.priority == 3}">
                                                <span class="badge bg-info text-dark fs-6">
                                                    <i class="fas fa-minus me-1"></i>Trung bình
                                                </span>
                                            </c:when>
                                            <c:when test="${task.priority == 4}">
                                                <span class="badge bg-secondary fs-6">
                                                    <i class="fas fa-arrow-down me-1"></i>Thấp
                                                </span>
                                            </c:when>
                                            <c:when test="${task.priority == 5}">
                                                <span class="badge bg-dark fs-6">
                                                    <i class="fas fa-level-down-alt me-1"></i>Rất thấp
                                                </span>
                                            </c:when>
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
                                        <button class="btn btn-sm btn-outline-primary action-btn me-2"
                                                onclick="updateTask(${task.taskID})"
                                                title="Cập nhật">
                                            <i class="fas fa-edit me-1"></i>Sửa
                                        </button>
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
                <c:if test="${totalPages > 1}">
                    <div class="card-footer bg-white">
                        <div class="d-flex justify-content-between align-items-center">
                            <div class="text-muted">
                                <c:choose>
                                    <c:when test="${not empty batchTasks}">
                                        Hiển thị <strong>${(currentPage - 1) * pageSize + 1}</strong>
                                        đến <strong>${(currentPage - 1) * pageSize + batchTasks.size()}</strong>
                                        trong tổng số <strong>${totalTasks}</strong> task
                                    </c:when>
                                    <c:otherwise>
                                        Tổng số <strong>0</strong> task
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <nav aria-label="Phân trang">
                                <ul class="pagination mb-0">
                                    <!-- Previous -->
                                    <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                                        <a class="page-link" href="?batchId=${batchId}&page=${currentPage - 1}" aria-label="Previous">
                                            <i class="fas fa-chevron-left"></i>
                                        </a>
                                    </li>

                                    <!-- First page -->
                                    <c:if test="${currentPage > 3}">
                                        <li class="page-item">
                                            <a class="page-link" href="?batchId=${batchId}&page=1">1</a>
                                        </li>
                                        <c:if test="${currentPage > 4}">
                                            <li class="page-item disabled">
                                                <span class="page-link">...</span>
                                            </li>
                                        </c:if>
                                    </c:if>

                                    <!-- Page numbers -->
                                    <c:forEach begin="${currentPage - 2 < 1 ? 1 : currentPage - 2}"
                                               end="${currentPage + 2 > totalPages ? totalPages : currentPage + 2}"
                                               var="i">
                                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                                            <a class="page-link" href="?batchId=${batchId}&page=${i}">${i}</a>
                                        </li>
                                    </c:forEach>

                                    <!-- Last page -->
                                    <c:if test="${currentPage < totalPages - 2}">
                                        <c:if test="${currentPage < totalPages - 3}">
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
                                        <a class="page-link" href="?batchId=${batchId}&page=${currentPage + 1}" aria-label="Next">
                                            <i class="fas fa-chevron-right"></i>
                                        </a>
                                    </li>
                                </ul>
                            </nav>
                        </div>
                    </div>
                </c:if>
            </div>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function updateTask(taskId) {
        // Chuyển hướng đến trang cập nhật task
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
                        alert('Xóa task thành công!');
                        location.reload();
                    } else {
                        alert('Xóa task thất bại!');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Có lỗi xảy ra!');
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
                        alert('Xóa batch thành công!');
                        window.location.href = '${pageContext.request.contextPath}/tasks/management';
                    } else {
                        alert('Xóa batch thất bại!');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Có lỗi xảy ra!');
                });
        }
    }
</script>
</body>
</html>