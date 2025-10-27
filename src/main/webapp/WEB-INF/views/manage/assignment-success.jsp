<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html>
<%@include file="../include/head.jsp"%>
<body class="bg-light">

<div class="d-flex">
    <!-- Sidebar -->
    <%@include file="../include/sidebar.jsp"%>

    <!-- Main Content -->
    <div class="flex-grow-1" style="margin-left: 250px;">
        <!-- Header -->
        <div class="bg-white border-bottom px-4 py-3 d-flex justify-content-between align-items-center">
            <div>
                <h1 class="h4 mb-0 text-dark">
                    <i class="fas fa-check-circle text-success me-2"></i>Giao Nhiệm Vụ Thành Công
                </h1>
                <small class="text-muted">Kết quả giao nhiệm vụ cho nhân viên</small>
            </div>
            <div class="d-flex align-items-center">
                <button class="btn btn-outline-secondary position-relative">
                    <i class="fas fa-bell"></i>
                    <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
            3
          </span>
                </button>
            </div>
        </div>

        <div class="p-4">
            <!-- Success Card -->
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-header bg-success text-white border-bottom-0">
                    <h5 class="mb-0">
                        <i class="fas fa-check-circle me-2"></i>Thao tác thành công
                    </h5>
                </div>
                <div class="card-body">
                    <div class="alert alert-success border-0 mb-4">
                        <div class="d-flex align-items-center">
                            <i class="fas fa-check-circle fa-2x me-3"></i>
                            <div>
                                <h5 class="alert-heading mb-1">${message}</h5>
                                <p class="mb-0">Các nhiệm vụ đã được giao thành công cho nhân viên.</p>
                            </div>
                        </div>
                    </div>

                    <!-- Tasks Summary -->
                    <c:if test="${not empty assignedTasks}">
                        <div class="row mb-4">
                            <div class="col-md-3">
                                <div class="card bg-primary bg-opacity-10 border-primary">
                                    <div class="card-body text-center">
                                        <i class="fas fa-tasks fa-2x text-primary mb-2"></i>
                                        <h4 class="text-primary">${fn:length(assignedTasks)}</h4>
                                        <p class="mb-0 text-muted">Tổng số nhiệm vụ</p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="card bg-info bg-opacity-10 border-info">
                                    <div class="card-body text-center">
                                        <i class="fas fa-user-check fa-2x text-info mb-2"></i>
                                        <h4 class="text-info">
                                            <c:set var="uniqueWorkers" value="${assignedTasks.stream().map(t -> t.assignedTo.accountId).distinct().count()}" />
                                                ${uniqueWorkers}
                                        </h4>
                                        <p class="mb-0 text-muted">Nhân viên được giao</p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="card bg-warning bg-opacity-10 border-warning">
                                    <div class="card-body text-center">
                                        <i class="fas fa-trash-alt fa-2x text-warning mb-2"></i>
                                        <h4 class="text-warning">
                                            <c:set var="uniqueBins" value="${assignedTasks.stream().map(t -> t.bin.binID).distinct().count()}" />
                                                ${uniqueBins}
                                        </h4>
                                        <p class="mb-0 text-muted">Thùng rác xử lý</p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="card bg-success bg-opacity-10 border-success">
                                    <div class="card-body text-center">
                                        <i class="fas fa-clock fa-2x text-success mb-2"></i>
                                        <h4 class="text-success">OPEN</h4>
                                        <p class="mb-0 text-muted">Trạng thái hiện tại</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:if>

                    <!-- Detailed Tasks Table -->
                    <c:if test="${not empty assignedTasks}">
                        <div class="mt-4">
                            <h5 class="mb-3">
                                <i class="fas fa-list-check me-2"></i>Chi tiết nhiệm vụ đã giao
                            </h5>

                            <div class="table-responsive">
                                <table class="table table-striped table-hover">
                                    <thead class="table-light">
                                    <tr>
                                        <th class="fw-semibold">#</th>
                                        <th class="fw-semibold">Mã nhiệm vụ</th>
                                        <th class="fw-semibold">Mã thùng rác</th>
                                        <th class="fw-semibold">Địa chỉ</th>
                                        <th class="fw-semibold">Nhân viên</th>
                                        <th class="fw-semibold">Loại nhiệm vụ</th>
                                        <th class="fw-semibold">Ưu tiên</th>
                                        <th class="fw-semibold">Trạng thái</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="task" items="${assignedTasks}" varStatus="status">
                                        <tr>
                                            <td class="fw-medium">${status.index + 1}</td>
                                            <td>
                                                <span class="badge bg-primary">#${task.taskID}</span>
                                            </td>
                                            <td class="fw-medium">${task.bin.binCode}</td>
                                            <td>
                                                <small>
                                                        ${task.bin.street}
                                                    <c:if test="${not empty task.bin.ward}">, ${task.bin.ward.wardName}</c:if>
                                                    <c:if test="${not empty task.bin.ward and not empty task.bin.ward.province}">, ${task.bin.ward.province.provinceName}</c:if>
                                                </small>
                                            </td>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <div class="bg-primary bg-opacity-10 rounded-circle p-2 me-2">
                                                        <i class="fas fa-user text-primary"></i>
                                                    </div>
                                                    <div>
                                                        <div class="fw-medium">${task.assignedTo.fullName}</div>
                                                        <small class="text-muted">ID: ${task.assignedTo.accountId}</small>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${task.taskType == 'COLLECT'}">
                              <span class="badge bg-info">
                                <i class="fas fa-trash-alt me-1"></i> Thu gom
                              </span>
                                                    </c:when>
                                                    <c:when test="${task.taskType == 'CLEAN'}">
                              <span class="badge bg-warning">
                                <i class="fas fa-broom me-1"></i> Vệ sinh
                              </span>
                                                    </c:when>
                                                    <c:when test="${task.taskType == 'REPAIR'}">
                              <span class="badge bg-danger">
                                <i class="fas fa-tools me-1"></i> Sửa chữa
                              </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">${task.taskType}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${task.priority == 1}">
                                                        <span class="badge bg-success">Thấp</span>
                                                    </c:when>
                                                    <c:when test="${task.priority == 2}">
                                                        <span class="badge bg-warning">Trung bình</span>
                                                    </c:when>
                                                    <c:when test="${task.priority == 3}">
                                                        <span class="badge bg-danger">Cao</span>
                                                    </c:when>
                                                </c:choose>
                                            </td>
                                            <td>
                          <span class="badge bg-success">
                            <i class="fas fa-circle me-1"></i> ${task.status}
                          </span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </c:if>

                    <!-- Action Buttons -->
                    <div class="mt-4 pt-3 border-top">
                        <div class="d-flex justify-content-between">
                            <div>
                                <a href="${pageContext.request.contextPath}/tasks/task-management" class="btn btn-outline-primary">
                                    <i class="fas fa-arrow-left me-1"></i> Quay lại quản lý nhiệm vụ
                                </a>
                            </div>
                            <div>
                                <a href="${pageContext.request.contextPath}/tasks/task-management" class="btn btn-primary me-2">
                                    <i class="fas fa-plus me-1"></i> Giao thêm nhiệm vụ
                                </a>
                                <a href="${pageContext.request.contextPath}/manage" class="btn btn-success">
                                    <i class="fas fa-home me-1"></i> Về trang chủ
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Quick Stats -->
            <div class="row">
                <div class="col-md-4">
                    <div class="card border-0 shadow-sm">
                        <div class="card-body text-center">
                            <i class="fas fa-clock fa-2x text-warning mb-2"></i>
                            <h5 class="text-warning">Cần theo dõi</h5>
                            <p class="text-muted">Các nhiệm vụ sẽ bắt đầu trong vòng 24h tới</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card border-0 shadow-sm">
                        <div class="card-body text-center">
                            <i class="fas fa-check-circle fa-2x text-success mb-2"></i>
                            <h5 class="text-success">Hoàn thành gần đây</h5>
                            <p class="text-muted">Xem lịch sử nhiệm vụ đã hoàn thành</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card border-0 shadow-sm">
                        <div class="card-body text-center">
                            <i class="fas fa-chart-line fa-2x text-info mb-2"></i>
                            <h5 class="text-info">Báo cáo hiệu suất</h5>
                            <p class="text-muted">Phân tích hiệu quả công việc</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        // Add any JavaScript functionality needed for this page
        console.log("Assignment success page loaded");

        // Auto-scroll to top on page load
        window.scrollTo(0, 0);

        // Add confirmation for navigation
        const navLinks = document.querySelectorAll('a[href*="task-management"]');
        navLinks.forEach(link => {
            link.addEventListener('click', function(e) {
                if (!confirm('Bạn có muốn quay lại trang quản lý nhiệm vụ không?')) {
                    e.preventDefault();
                }
            });
        });
    });
</script>

</body>
</html>