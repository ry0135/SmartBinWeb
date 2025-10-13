<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<%@include file="../include/head.jsp"%>
<body>
<!-- Sidebar -->
<%@include file="../include/sidebar.jsp"%>
<!-- Main Content -->
<div class="flex-grow-1" style="margin-left: 250px;">
    <!-- Header -->
    <div class="bg-white border-bottom px-4 py-3 d-flex justify-content-between align-items-center">
        <h1 class="h4 mb-0 text-dark">
            <c:choose>
                <c:when test="${isEdit}">Chỉnh sửa thùng rác</c:when>
                <c:otherwise>Thêm thùng rác mới</c:otherwise>
            </c:choose>
        </h1>
        <a href="${pageContext.request.contextPath}/bins" class="btn btn-outline-secondary">
            <i class="fas fa-arrow-left me-1"></i> Quay lại
        </a>
    </div>

    <div class="content p-4">
        <div class="card border-0 shadow-sm">
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/manage/bin/${isEdit ? 'update' : 'add'}" method="post">
                    <c:if test="${isEdit}">
                        <input type="hidden" name="binID" value="${bin.binID}">
                    </c:if>

                    <div class="row g-3">
                        <div class="col-md-6">
                            <label for="binCode" class="form-label fw-semibold">Mã thùng rác:</label>
                            <input type="text" class="form-control" id="binCode" name="binCode"
                                   value="${bin.binCode}" required>
                        </div>

                        <div class="col-md-6">
                            <label for="capacity" class="form-label fw-semibold">Dung tích (L):</label>
                            <input type="number" class="form-control" id="capacity" name="capacity"
                                   value="${bin.capacity}" step="0.1" required>
                        </div>

                        <div class="col-md-12">
                            <label for="street" class="form-label fw-semibold">Đường/Phố:</label>
                            <input type="text" class="form-control" id="street" name="street"
                                   value="${bin.street}" required>
                        </div>

                        <div class="col-md-6">
                            <label for="latitude" class="form-label fw-semibold">Vĩ độ:</label>
                            <input type="number" class="form-control" id="latitude" name="latitude"
                                   value="${bin.latitude}" step="0.000001" required>
                        </div>

                        <div class="col-md-6">
                            <label for="longitude" class="form-label fw-semibold">Kinh độ:</label>
                            <input type="number" class="form-control" id="longitude" name="longitude"
                                   value="${bin.longitude}" step="0.000001" required>
                        </div>

                        <div class="col-md-6">
                            <label for="currentFill" class="form-label fw-semibold">Mức đầy hiện tại (%):</label>
                            <input type="number" class="form-control" id="currentFill" name="currentFill"
                                   value="${bin.currentFill}" min="0" max="100" step="0.1" required>
                        </div>

                        <div class="col-md-6">
                            <label for="status" class="form-label fw-semibold">Trạng thái:</label>
                            <select class="form-select" id="status" name="status" required>
                                <option value="1" ${bin.status == 1 ? 'selected' : ''}>Online</option>
                                <option value="2" ${bin.status == 2 ? 'selected' : ''}>Offline</option>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label for="wardID" class="form-label fw-semibold">Mã phường/xã:</label>
                            <input type="number" class="form-control" id="wardID" name="wardID"
                                   value="${bin.wardID}" required>
                        </div>
                    </div>

                    <div class="mt-4">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save me-1"></i>
                            <c:choose>
                                <c:when test="${isEdit}">Cập nhật</c:when>
                                <c:otherwise>Thêm mới</c:otherwise>
                            </c:choose>
                        </button>
                        <a href="${pageContext.request.contextPath}/bins" class="btn btn-secondary ms-2">
                            <i class="fas fa-times me-1"></i> Hủy
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
</body>
</html>