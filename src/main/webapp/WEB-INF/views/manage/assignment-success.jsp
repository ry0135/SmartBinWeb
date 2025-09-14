<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Giao nhiệm vụ thành công</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
<div class="container mt-4">
    <div class="card">
        <div class="card-header bg-success text-white">
            <h4 class="mb-0"><i class="fas fa-check-circle"></i> Thành công</h4>
        </div>
        <div class="card-body">
            <div class="alert alert-success">
                <h5>${message}</h5>
            </div>

            <c:if test="${not empty assignedTasks}">
                <h5>Danh sách nhiệm vụ đã giao:</h5>
                <table class="table table-striped">
                    <thead>
                    <tr>
                        <th>Mã nhiệm vụ</th>
                        <th>Thùng rác</th>
                        <th>Nhân viên</th>
                        <th>Loại</th>
                        <th>Trạng thái</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="task" items="${assignedTasks}">
                        <tr>
                            <td>${task.taskID}</td>
                            <td>${task.bin.binCode}</td>
                            <td>${task.assignedTo.fullName}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${task.taskType == 'COLLECT'}">Thu gom</c:when>
                                    <c:when test="${task.taskType == 'CLEAN'}">Vệ sinh</c:when>
                                    <c:when test="${task.taskType == 'REPAIR'}">Sửa chữa</c:when>
                                </c:choose>
                            </td>
                            <td>${task.status}</td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:if>

            <div class="mt-3">
                <a href="${pageContext.request.contextPath}/manage" class="btn btn-primary">
                    <i class="fas fa-arrow-left"></i> Quay lại quản lý
                </a>
            </div>
        </div>
    </div>
</div>
</body>
</html>