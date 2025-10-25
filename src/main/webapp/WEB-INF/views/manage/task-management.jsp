<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quản lý Task</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
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
            <div class="row mb-4">
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="card border-left-primary shadow h-100 py-2">
                        <div class="card-body">
                            <div class="row no-gutters align-items-center">
                                <div class="col mr-2">
                                    <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">
                                        Tổng số Task
                                    </div>
                                    <div class="h5 mb-0 font-weight-bold text-gray-800">${totalTasks}</div>
                                </div>
                                <div class="col-auto">
                                    <i class="fas fa-tasks fa-2x text-gray-300"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="card border-left-warning shadow h-100 py-2">
                        <div class="card-body">
                            <div class="row no-gutters align-items-center">
                                <div class="col mr-2">
                                    <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">
                                        Task đang mở
                                    </div>
                                    <div class="h5 mb-0 font-weight-bold text-gray-800">${openTasks}</div>
                                </div>
                                <div class="col-auto">
                                    <i class="fas fa-folder-open fa-2x text-gray-300"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="card border-left-info shadow h-100 py-2">
                        <div class="card-body">
                            <div class="row no-gutters align-items-center">
                                <div class="col mr-2">
                                    <div class="text-xs font-weight-bold text-info text-uppercase mb-1">
                                        Đang thực hiện
                                    </div>
                                    <div class="h5 mb-0 font-weight-bold text-gray-800">${doingTasks}</div>
                                </div>
                                <div class="col-auto">
                                    <i class="fas fa-spinner fa-2x text-gray-300"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="card border-left-success shadow h-100 py-2">
                        <div class="card-body">
                            <div class="row no-gutters align-items-center">
                                <div class="col mr-2">
                                    <div class="text-xs font-weight-bold text-success text-uppercase mb-1">
                                        Đã hoàn thành
                                    </div>
                                    <div class="h5 mb-0 font-weight-bold text-gray-800">${completedTasks}</div>
                                </div>
                                <div class="col-auto">
                                    <i class="fas fa-check-circle fa-2x text-gray-300"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Filter Section -->
            <div class="card mb-4">
                <div class="card-header">
                    <i class="fas fa-filter me-1"></i>
                    Bộ lọc
                </div>
                <div class="card-body">
                    <form method="get" action="${pageContext.request.contextPath}/tasks/management" class="row g-3">
                        <div class="col-md-3">
                            <label for="status" class="form-label">Trạng thái</label>
                            <select class="form-select" id="status" name="status">
                                <option value="">Tất cả</option>
                                <option value="OPEN" ${statusFilter == 'OPEN' ? 'selected' : ''}>OPEN</option>
                                <option value="DOING" ${statusFilter == 'DOING' ? 'selected' : ''}>DOING</option>
                                <option value="COMPLETED" ${statusFilter == 'COMPLETED' ? 'selected' : ''}>COMPLETED</option>
                                <option value="CANCELLED" ${statusFilter == 'CANCELLED' ? 'selected' : ''}>CANCELLED</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label for="type" class="form-label">Loại task</label>
                            <select class="form-select" id="type" name="type">
                                <option value="">Tất cả</option>
                                <option value="COLLECT" ${typeFilter == 'COLLECT' ? 'selected' : ''}>Thu gom</option>
                                <option value="CLEAN" ${typeFilter == 'CLEAN' ? 'selected' : ''}>Vệ sinh</option>
                                <option value="REPAIR" ${typeFilter == 'REPAIR' ? 'selected' : ''}>Sửa chữa</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label for="priority" class="form-label">Độ ưu tiên</label>
                            <select class="form-select" id="priority" name="priority">
                                <option value="">Tất cả</option>
                                <option value="1" ${priorityFilter == 1 ? 'selected' : ''}>Cao</option>
                                <option value="2" ${priorityFilter == 2 ? 'selected' : ''}>Trung bình</option>
                                <option value="3" ${priorityFilter == 3 ? 'selected' : ''}>Thấp</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">&nbsp;</label>
                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-primary">Lọc</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Tasks Table -->
            <div class="card">
                <div class="card-header">
                    <i class="fas fa-table me-1"></i>
                    Danh sách Task
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-bordered table-hover" id="taskTable">
                            <thead class="table-light">
                            <tr>
                                <th>ID</th>
                                <th>Thùng rác</th>
                                <th>Nhân viên</th>
                                <th>Loại</th>
                                <th>Ưu tiên</th>
                                <th>Trạng thái</th>
                                <th>Ngày tạo</th>
                                <th>Hoàn thành</th>
                                <th>Hành động</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="task" items="${tasks}">
                                <tr>
                                    <td>${task.taskID}</td>
                                    <td>
                                        <c:if test="${task.bin != null}">
                                            ${task.bin.binCode}
                                        </c:if>
                                    </td>
                                    <td>
                                        <c:if test="${task.assignedTo != null}">
                                            ${task.assignedTo.fullName}
                                        </c:if>
                                    </td>
                                    <td>
                                            <span class="badge
                                                ${task.taskType == 'COLLECT' ? 'bg-primary' :
                                                  task.taskType == 'CLEAN' ? 'bg-info' : 'bg-warning'}">
                                                    ${task.taskType}
                                            </span>
                                    </td>
                                    <td>
                                            <span class="badge
                                                ${task.priority == 1 ? 'bg-danger' :
                                                  task.priority == 2 ? 'bg-warning' : 'bg-secondary'}">
                                                <c:choose>
                                                    <c:when test="${task.priority == 1}">Cao</c:when>
                                                    <c:when test="${task.priority == 2}">Trung bình</c:when>
                                                    <c:when test="${task.priority == 3}">Thấp</c:when>
                                                </c:choose>
                                            </span>
                                    </td>
                                    <td>
                                            <span class="badge
                                                ${task.status == 'OPEN' ? 'bg-primary' :
                                                  task.status == 'DOING' ? 'bg-warning' :
                                                  task.status == 'COMPLETED' ? 'bg-success' : 'bg-secondary'}">
                                                    ${task.status}
                                            </span>
                                    </td>
                                    <td>
                                        <fmt:formatDate value="${task.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                    </td>
                                    <td>
                                        <c:if test="${task.completedAt != null}">
                                            <fmt:formatDate value="${task.completedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </c:if>
                                    </td>
                                    <td>
                                        <div class="btn-group btn-group-sm">
                                            <button class="btn btn-outline-primary"
                                                    onclick="viewTaskDetail(${task.taskID})">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                            <c:if test="${task.status == 'OPEN' || task.status == 'DOING'}">
                                                <button class="btn btn-outline-warning"
                                                        onclick="updateTaskStatus(${task.taskID}, 'COMPLETED')">
                                                    <i class="fas fa-check"></i>
                                                </button>
                                            </c:if>
                                        </div>
                                    </td>
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function viewTaskDetail(taskId) {
        window.location.href = '${pageContext.request.contextPath}/tasks/' + taskId;
    }

    function updateTaskStatus(taskId, status) {
        if(confirm('Bạn có chắc muốn cập nhật trạng thái task?')) {
            fetch('${pageContext.request.contextPath}/tasks/' + taskId + '/status', {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({status: status})
            })
                .then(response => {
                    if(response.ok) {
                        location.reload();
                    }
                });
        }
    }

    function exportTasks() {
        // Logic export tasks to Excel/PDF
        alert('Chức năng export đang được phát triển');
    }
</script>
</body>
</html>