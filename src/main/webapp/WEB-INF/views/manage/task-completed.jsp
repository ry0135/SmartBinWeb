<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Chi tiết Batch đang mở - ${batchId}</title>
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
            margin: 2px;
            border: 2px solid #e0e0e0;
        }
        .task-image:hover {
            transform: scale(1.1);
            border-color: #007bff;
        }
        .images-container {
            display: flex;
            flex-wrap: wrap;
            gap: 5px;
        }
        .modal-image {
            max-width: 100%;
            max-height: 80vh;
            object-fit: contain;
        }
        .image-gallery {
            display: flex;
            gap: 10px;
            margin-top: 10px;
        }
        .gallery-thumb {
            width: 60px;
            height: 60px;
            object-fit: cover;
            border-radius: 4px;
            cursor: pointer;
            border: 2px solid transparent;
        }
        .gallery-thumb.active {
            border-color: #007bff;
        }
    </style>
</head>
<body class="bg-light">
<div class="container-fluid">
    <div class="row">
        <%@include file="../include/sidebar.jsp"%>

        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2">Chi tiết Nhiệm Vụ: ${batchId}</h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <button class="btn btn-sm btn-outline-secondary" onclick="window.history.back()">
                        <i class="fas fa-arrow-left"></i> Quay lại
                    </button>
                </div>
            </div>

            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">Danh sách Task trong Batch</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-bordered table-hover">
                            <thead class="table-light">
                            <tr>
                                <th style="width: 5%;">ID</th>
                                <th style="width: 25%;">Hình ảnh</th>
                                <th style="width: 10%;">Thùng rác</th>
                                <th style="width: 10%;">Loại</th>
                                <th style="width: 12%;">Mức độ</th>
                                <th style="width: 12%;">Trạng thái</th>
                                <th style="width: 15%;">Ngày tạo</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="task" items="${batchTasks}">
                                <tr>
                                    <td>${task.taskID}</td>
                                    <td>
<%--                                        <div class="images-container">--%>
<%--                                            <c:choose>--%>
<%--                                                <c:when test="${task.images != null && !empty task.images}">--%>
<%--                                                    <c:forEach var="image" items="${task.images}" varStatus="status">--%>
<%--                                                        <img src="${pageContext.request.contextPath}${image.imageUrl}"--%>
<%--                                                             class="task-image"--%>
<%--                                                             alt="Task Image ${status.index + 1}"--%>
<%--                                                             onclick="showImageGallery(${task.taskID}, ${status.index})"--%>
<%--                                                             onerror="this.src='${pageContext.request.contextPath}/images/no-image.png'">--%>
<%--                                                    </c:forEach>--%>
<%--                                                </c:when>--%>
<%--                                                <c:otherwise>--%>
<%--                                                    <span class="text-muted">--%>
<%--                                                        <i class="fas fa-image"></i> Không có ảnh--%>
<%--                                                    </span>--%>
<%--                                                </c:otherwise>--%>
<%--                                            </c:choose>--%>
<%--                                        </div>--%>
                                    </td>
                                    <td>
                                        <c:if test="${task.bin != null}">
                                            ${task.bin.binCode}
                                        </c:if>
                                    </td>
                                    <td>
                                        <span class="badge ${task.taskType == 'COLLECT' ? 'bg-primary' : task.taskType == 'CLEAN' ? 'bg-info' : 'bg-warning'}">
                                                ${task.taskType}
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
                                        <span class="badge ${task.status == 'OPEN' ? 'bg-primary' : task.status == 'DOING' ? 'bg-warning' : task.status == 'COMPLETED' ? 'bg-success' : 'bg-secondary'}">
                                                ${task.status}
                                        </span>
                                    </td>
                                    <td>${task.createdAt}</td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- Modal xem ảnh với gallery -->
<div class="modal fade" id="imageModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-xl">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Hình ảnh Task #<span id="modalTaskId"></span></h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body text-center">
                <img id="modalImage" src="" class="modal-image" alt="Task Image">
                <div class="image-gallery" id="imageGallery">
                    <!-- Thumbnails will be inserted here -->
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="previousImage()">
                    <i class="fas fa-chevron-left"></i> Trước
                </button>
                <span id="imageCounter" class="mx-3"></span>
                <button type="button" class="btn btn-secondary" onclick="nextImage()">
                    Sau <i class="fas fa-chevron-right"></i>
                </button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    let currentImages = [];
    let currentIndex = 0;
    let currentTaskId = 0;
    let modal;

    function showImageGallery(taskId, startIndex) {
        currentTaskId = taskId;
        currentIndex = startIndex;

        // Get all images for this task
        currentImages = [];
        <c:forEach var="task" items="${batchTasks}">
        if(${task.taskID} === taskId) {
            <c:forEach var="image" items="${task.images}">
            currentImages.push('${pageContext.request.contextPath}${image.imageUrl}');
            </c:forEach>
        }
        </c:forEach>

        showCurrentImage();
        updateGallery();

        document.getElementById('modalTaskId').textContent = taskId;
        modal = new bootstrap.Modal(document.getElementById('imageModal'));
        modal.show();
    }

    function showCurrentImage() {
        if(currentImages.length > 0) {
            document.getElementById('modalImage').src = currentImages[currentIndex];
            document.getElementById('imageCounter').textContent =
                `${currentIndex + 1} / ${currentImages.length}`;
        }
    }

    function updateGallery() {
        const gallery = document.getElementById('imageGallery');
        gallery.innerHTML = '';

        currentImages.forEach((imgSrc, index) => {
            const thumb = document.createElement('img');
            thumb.src = imgSrc;
            thumb.className = 'gallery-thumb' + (index === currentIndex ? ' active' : '');
            thumb.onclick = () => {
                currentIndex = index;
                showCurrentImage();
                updateGallery();
            };
            gallery.appendChild(thumb);
        });
    }

    function previousImage() {
        if(currentIndex > 0) {
            currentIndex--;
            showCurrentImage();
            updateGallery();
        }
    }

    function nextImage() {
        if(currentIndex < currentImages.length - 1) {
            currentIndex++;
            showCurrentImage();
            updateGallery();
        }
    }

    // Keyboard navigation
    document.addEventListener('keydown', function(e) {
        if(modal && modal._isShown) {
            if(e.key === 'ArrowLeft') {
                previousImage();
            } else if(e.key === 'ArrowRight') {
                nextImage();
            }
        }
    });
</script>
</body>
</html