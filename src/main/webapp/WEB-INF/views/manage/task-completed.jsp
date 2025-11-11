<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Chi tiết Batch đã hoàn thành - ${batchId}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .task-image {
            width: 100px;
            height: 100px;
            object-fit: cover;
            cursor: pointer;
            transition: transform 0.2s;
        }
        .task-image:hover {
            transform: scale(1.1);
        }
        .modal-image {
            max-width: 100%;
            max-height: 80vh;
            object-fit: contain;
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
                    <h2 class="mb-1"><i class="fas fa-box-open text-primary me-2"></i>Chi tiết Batch</h2>
                    <p class="text-muted mb-0">Mã Batch: <span class="badge bg-primary">${batchId}</span></p>
                </div>
                <button class="btn btn-outline-primary" onclick="window.history.back()">
                    <i class="fas fa-arrow-left me-2"></i>Quay lại
                </button>
            </div>

            <!-- Task List Card -->
            <div class="card shadow-sm">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0"><i class="fas fa-tasks me-2"></i>Danh sách Task đã hoàn thành</h5>
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
                                    <td class="text-center fw-bold">#${task.taskID}</td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${task.afterImage != null && !empty task.afterImage}">
                                                <c:choose>
                                                    <c:when test="${task.afterImage.startsWith('http')}">
                                                        <img src="${task.afterImage}"
                                                             class="task-image rounded border border-success border-2"
                                                             alt="Task Image"
                                                             onclick="showImage('${task.afterImage}', ${task.taskID})"
                                                             onerror="handleImageError(this)">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img src="${pageContext.request.contextPath}${task.afterImage}"
                                                             class="task-image rounded border"
                                                             alt="Task Image"
                                                             onclick="showImage('${pageContext.request.contextPath}${task.afterImage}', ${task.taskID})"
                                                             onerror="handleImageError(this)">
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="d-inline-flex align-items-center justify-content-center bg-light rounded border border-secondary border-2" style="width: 100px; height: 100px;">
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
                                        <span class="badge ${task.taskType == 'COLLECT' ? 'bg-primary' : task.taskType == 'CLEAN' ? 'bg-info' : 'bg-warning'} fs-6">
                                            <c:choose>
                                                <c:when test="${task.taskType == 'COLLECT'}">
                                                    <i class="fas fa-hand-holding me-1"></i>Thu gom
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
                                    <td>
                                        <c:choose>
                                            <c:when test="${task.assignedTo != null}">
                                                <i class="fas fa-user text-muted me-2"></i>${task.assignedTo.fullName}
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">—</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <span class="badge bg-success fs-6">
                                            <i class="fas fa-check-circle me-1"></i>Hoàn thành
                                        </span>
                                    </td>
                                    <td>
                                        <small class="text-muted">
                                            <i class="far fa-calendar-check me-1"></i>${task.completedAt}
                                        </small>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty batchTasks}">
                                <tr>
                                    <td colspan="8" class="text-center py-5">
                                        <i class="fas fa-inbox fa-4x text-muted mb-3 d-block"></i>
                                        <h5 class="text-muted">Không có task nào trong batch này</h5>
                                    </td>
                                </tr>
                            </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="card-footer bg-white">
                    <div class="d-flex justify-content-between align-items-center">
                        <div class="text-muted">
                            Hiển thị <strong>${(currentPage - 1) * pageSize + 1}</strong>
                            đến <strong>${(currentPage - 1) * pageSize + batchTasks.size()}</strong>
                            trong tổng số <strong>${totalTasks}</strong> task
                        </div>
                        <nav aria-label="Phân trang">
                            <ul class="pagination mb-0">
                                <!-- Previous -->
                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
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
                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                    <a class="page-link" href="?batchId=${batchId}&page=${currentPage + 1}" aria-label="Next">
                                        <i class="fas fa-chevron-right"></i>
                                    </a>
                                </li>
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
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title">
                    <i class="fas fa-image me-2"></i>Hình ảnh hoàn thành Task #<span id="modalTaskId"></span>
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body text-center bg-dark">
                <img id="modalImage" src="" class="modal-image" alt="Task Image" onerror="handleModalImageError(this)">
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    let modal;

    function showImage(imageUrl, taskId) {
        if(!imageUrl || imageUrl === '') {
            alert('Không có hình ảnh để hiển thị');
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
        parent.innerHTML = '<div class="d-inline-flex align-items-center justify-content-center bg-light rounded border border-secondary border-2" style="width: 100px; height: 100px;"><i class="fas fa-image fa-2x text-muted"></i></div>';
    }

    function handleModalImageError(img) {
        img.style.display = 'none';
        const modalBody = document.querySelector('.modal-body');
        modalBody.innerHTML = '<div class="alert alert-warning m-3"><i class="fas fa-exclamation-triangle me-2"></i>Không thể tải hình ảnh</div>';
    }

    document.addEventListener('keydown', function(e) {
        const modalElement = document.getElementById('imageModal');
        if(modalElement && modalElement.classList.contains('show') && e.key === 'Escape' && modal) {
            modal.hide();
        }
    });
</script>
</body>
</html>