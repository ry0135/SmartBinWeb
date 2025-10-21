<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Chi tiết Batch - ${batchId}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
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
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">Danh sách Task trong Batch</h5>
                    <div>
                        <button class="btn btn-danger btn-sm" onclick="deleteBatch('${batchId}')">
                            <i class="fas fa-trash"></i> Xóa Batch
                        </button>
                    </div>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-bordered table-hover">
                            <thead class="table-light">
                            <tr>
                                <th>ID</th>
                                <th>Thùng rác</th>
                                <th>Loại</th>
                                <th>Ưu tiên</th>
                                <th>Trạng thái</th>
                                <th>Ngày tạo</th>
                                <th>Hành động</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="task" items="${batchTasks}">
                                <tr>
                                    <td>${task.taskID}</td>
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
                                        <span class="badge ${task.priority == 1 ? 'bg-danger' : task.priority == 2 ? 'bg-warning' : 'bg-secondary'}">
                                            <c:choose>
                                                <c:when test="${task.priority == 1}">Cao</c:when>
                                                <c:when test="${task.priority == 2}">Trung bình</c:when>
                                                <c:when test="${task.priority == 3}">Thấp</c:when>
                                            </c:choose>
                                        </span>
                                    </td>
                                    <td>
                                        <span class="badge ${task.status == 'OPEN' ? 'bg-primary' : task.status == 'DOING' ? 'bg-warning' : task.status == 'COMPLETED' ? 'bg-success' : 'bg-secondary'}">
                                                ${task.status}
                                        </span>
                                    </td>
                                    <td>${task.createdAt}</td>
                                    <td>
                                        <div class="btn-group btn-group-sm">
                                            <button class="btn btn-outline-warning" onclick="updateTaskStatus(${task.taskID}, 'COMPLETED')">
                                                <i class="fas fa-check"></i>
                                            </button>
                                            <button class="btn btn-outline-danger" onclick="deleteTask(${task.taskID})">
                                                <i class="fas fa-trash"></i>
                                            </button>
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
                        location.reload();
                    }
                });
        }
    }

    function deleteBatch(batchId) {
        if(confirm('Bạn có chắc muốn xóa toàn bộ batch này? Tất cả task trong batch sẽ bị xóa.')) {
            fetch('${pageContext.request.contextPath}/tasks/batch/' + batchId, {
                method: 'DELETE',
                headers: {
                    'Content-Type': 'application/json',
                }
            })
                .then(response => {
                    if(response.ok) {
                        window.location.href = '${pageContext.request.contextPath}/tasks/management';
                    }
                });
        }
    }
</script>
</body>
</html>