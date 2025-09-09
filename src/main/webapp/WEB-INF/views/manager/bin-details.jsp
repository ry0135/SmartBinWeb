<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Thông tin thùng rác</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<jsp:include page="header_manager.jsp"/>

<div class="container mt-4">
    <div class="card">
        <div class="card-header bg-success text-white">
            <h4 class="mb-0">Thông tin thùng rác ${bin.binCode}</h4>
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-6">
                    <h5>Thông tin cơ bản</h5>
                    <table class="table table-bordered">
                        <tr>
                            <th>Mã thùng</th>
                            <td>${bin.binCode}</td>
                        </tr>
                        <tr>
                            <th>Địa điểm</th>
                            <td>${bin.street}, ${bin.ward}, ${bin.city}</td>
                        </tr>
                        <tr>
                            <th>Tọa độ</th>
                            <td>${bin.latitude}, ${bin.longitude}</td>
                        </tr>
                    </table>
                </div>
                <div class="col-md-6">
                    <h5>Trạng thái</h5>
                    <table class="table table-bordered">
                        <tr>
                            <th>Dung tích</th>
                            <td>${bin.capacity} lít</td>
                        </tr>
                        <tr>
                            <th>Mức đầy hiện tại</th>
                            <td>
                                <div class="progress">
                                    <div class="progress-bar"
                                         role="progressbar"
                                         style="width: ${(bin.currentFill/bin.capacity)*100}%">
                                        ${String.format("%.1f", (bin.currentFill/bin.capacity)*100)}%
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th>Trạng thái</th>
                            <td>
                                <c:choose>
                                    <c:when test="${bin.status == 1}">
                                        <span class="badge bg-success">Hoạt động</span>
                                    </c:when>
                                    <c:when test="${bin.status == 2}">
                                        <span class="badge bg-danger">Đầy</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-warning">Bảo trì</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>

            <div class="mt-4">
                <h5>Lịch sử cảnh báo gần đây</h5>
                <table class="table table-striped">
                    <thead>
                    <tr>
                        <th>Thời gian</th>
                        <th>Loại cảnh báo</th>
                        <th>Trạng thái</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${alerts}" var="alert">
                        <tr>
                            <td>${alert.createdAt}</td>
                            <td>${alert.alertType}</td>
                            <td>${alert.status}</td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>

            <div class="text-center mt-3">
                <a href="${pageContext.request.contextPath}/manager/alerts"
                   class="btn btn-primary">
                    Quay lại danh sách
                </a>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>