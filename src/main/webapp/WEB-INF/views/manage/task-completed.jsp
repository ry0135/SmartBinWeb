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
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 6px;
            cursor: pointer;
            transition: transform 0.2s;
            border: 2px solid #e0e0e0;
        }
        .task-image:hover {
            transform: scale(1.1);
            border-color: #007bff;
        }
        .modal-image {
            max-width: 100%;
            max-height: 80vh;
            object-fit: contain;
        }
        .no-image-placeholder {
            width: 80px;
            height: 80px;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #f8f9fa;
            border: 2px dashed #dee2e6;
            border-radius: 6px;
        }
        .external-image {
            border-color: #28a745;
        }
    </style>
</head>
<body class="bg-light">
<div class="container-fluid">
    <div class="row">
        <%@include file="../include/sidebar.jsp"%>

        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2">Chi tiết Batch đã hoàn thành: ${batchId}</h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <button class="btn btn-sm btn-outline-secondary" onclick="window.history.back()">
                        <i class="fas fa-arrow-left"></i> Quay lại
                    </button>
                </div>
            </div>

            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">Danh sách Task đã hoàn thành</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-bordered table-hover">
                            <thead class="table-light">
                            <tr>
                                <th style="width: 5%;">ID</th>
                                <th style="width: 15%;">Hình ảnh hoàn thành</th>
                                <th style="width: 10%;">Thùng rác</th>
                                <th style="width: 10%;">Loại</th>
                                <th style="width: 10%;">Mức độ</th>
                                <th style="width: 10%;">Người thực hiện</th>
                                <th style="width: 12%;">Trạng thái</th>
                                <th style="width: 15%;">Ngày hoàn thành</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="task" items="${batchTasks}">
                                <tr>
                                    <td>${task.taskID}</td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${task.afterImage != null && !empty task.afterImage}">
                                                <c:choose>
                                                    <c:when test="${task.afterImage.startsWith('http')}">
                                                        <!-- External image (Firebase) -->
                                                        <img src="${task.afterImage}"
                                                             class="task-image external-image"
                                                             alt="Task Image"
                                                             onclick="showImage('${task.afterImage}', ${task.taskID})"
                                                             onerror="handleImageError(this)">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <!-- Local image -->
                                                        <img src="${pageContext.request.contextPath}${task.afterImage}"
                                                             class="task-image"
                                                             alt="Task Image"
                                                             onclick="showImage('${pageContext.request.contextPath}${task.afterImage}', ${task.taskID})"
                                                             onerror="handleImageError(this)">
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="no-image-placeholder">
                                                    <span class="text-muted">
                                                        <i class="fas fa-image"></i>
                                                    </span>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${task.bin != null}">
                                                <span class="badge bg-secondary">
                                                    <i class="fas fa-trash"></i> ${task.bin.binCode}
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">-</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <span class="badge ${task.taskType == 'COLLECT' ? 'bg-primary' : task.taskType == 'CLEAN' ? 'bg-info' : 'bg-warning'}">
                                            <c:choose>
                                                <c:when test="${task.taskType == 'COLLECT'}">
                                                    <i class="fas fa-hand-holding"></i> Thu gom
                                                </c:when>
                                                <c:when test="${task.taskType == 'CLEAN'}">
                                                    <i class="fas fa-broom"></i> Dọn dẹp
                                                </c:when>
                                                <c:when test="${task.taskType == 'MAINTENANCE'}">
                                                    <i class="fas fa-tools"></i> Bảo trì
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="fas fa-tasks"></i> ${task.taskType}
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${task.priority == 1}">
                                                <span class="badge bg-danger">
                                                    <i class="fas fa-exclamation-circle"></i> Cực cao
                                                </span>
                                            </c:when>
                                            <c:when test="${task.priority == 2}">
                                                <span class="badge bg-warning text-dark">
                                                    <i class="fas fa-arrow-up"></i> Cao
                                                </span>
                                            </c:when>
                                            <c:when test="${task.priority == 3}">
                                                <span class="badge bg-info text-dark">
                                                    <i class="fas fa-minus"></i> Trung bình
                                                </span>
                                            </c:when>
                                            <c:when test="${task.priority == 4}">
                                                <span class="badge bg-secondary">
                                                    <i class="fas fa-arrow-down"></i> Thấp
                                                </span>
                                            </c:when>
                                            <c:when test="${task.priority == 5}">
                                                <span class="badge bg-dark">
                                                    <i class="fas fa-level-down-alt"></i> Rất thấp
                                                </span>
                                            </c:when>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${task.assignedTo != null}">
                                                <small>${task.assignedTo.fullName}</small>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">-</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <span class="badge bg-success">
                                            <i class="fas fa-check-circle"></i> HOÀN THÀNH
                                        </span>
                                    </td>
                                    <td>
                                        <small class="text-muted">
                                            <i class="fas fa-check-circle"></i> ${task.completedAt}
                                        </small>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty batchTasks}">
                                <tr>
                                    <td colspan="8" class="text-center text-muted py-4">
                                        <i class="fas fa-inbox fa-3x mb-3"></i>
                                        <p>Không có task nào trong batch này</p>
                                    </td>
                                </tr>
                            </c:if>
                            </tbody>
                        </table>
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
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fas fa-image"></i> Hình ảnh hoàn thành Task #<span id="modalTaskId"></span>
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body text-center">
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
        parent.innerHTML = '<div class="no-image-placeholder"><span class="text-muted"><i class="fas fa-image"></i></span></div>';
    }

    function handleModalImageError(img) {
        img.style.display = 'none';
        const modalBody = document.querySelector('.modal-body');
        modalBody.innerHTML = '<div class="alert alert-warning"><i class="fas fa-exclamation-triangle"></i> Không thể tải hình ảnh</div>';
    }

    // Keyboard navigation - ESC to close
    document.addEventListener('keydown', function(e) {
        const modalElement = document.getElementById('imageModal');
        if(modalElement && modalElement.classList.contains('show')) {
            if(e.key === 'Escape') {
                if(modal) {
                    modal.hide();
                }
            }
        }
    });
</script>
</body>
</html>