<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Địa điểm</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body class="bg-light">

<%@ include file="/WEB-INF/views/admin/header_admin.jsp" %>

<div class="container py-5">

    <!-- Tiêu đề trang -->
    <h2 class="text-center mb-5 text-success fw-bold">
        🗺️ Quản lý Địa điểm
    </h2>

    <!-- Hiển thị thông báo -->
    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show text-center" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <c:if test="${not empty success}">
        <div class="alert alert-success alert-dismissible fade show text-center" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i>${success}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- =================== FORM THÊM TỈNH =================== -->
    <div class="card shadow-sm mb-4 border-0">
        <div class="card-header bg-success text-white fw-semibold">
            ➕ Thêm Tỉnh / Thành phố
        </div>
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/admin/locations/add-province" method="post">
                <div class="row g-3 align-items-center">
                    <div class="col-md-8">
                        <input type="text" name="provinceName" class="form-control" placeholder="Nhập tên tỉnh / thành phố..." required>
                    </div>
                    <div class="col-md-4 text-end">
                        <button type="submit" class="btn btn-success px-4">
                            <i class="bi bi-plus-circle me-1"></i> Thêm
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- =================== FORM THÊM PHƯỜNG =================== -->
    <div class="card shadow-sm border-0">
        <div class="card-header bg-success text-white fw-semibold">
            ➕ Thêm Phường / Xã
        </div>
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/admin/locations/add-ward" method="post">
                <div class="row g-3 align-items-center">
                    <div class="col-md-4">
                        <select name="provinceId" class="form-select" required>
                            <option value="">-- Chọn tỉnh / thành phố --</option>
                            <c:forEach var="p" items="${provinces}">
                                <option value="${p.provinceId}">${p.provinceName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <input type="text" name="wardName" class="form-control" placeholder="Nhập tên phường / xã..." required>
                    </div>
                    <div class="col-md-4 text-end">
                        <button type="submit" class="btn btn-success w-100">
                            <i class="bi bi-plus-circle me-1"></i> Thêm
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- =================== DANH SÁCH HIỂN THỊ =================== -->
    <div class="card shadow-sm border-0 mt-5">
        <div class="card-header bg-white fw-bold text-success border-bottom">
            📋 Danh sách các Tỉnh / Phường
        </div>
        <div class="card-body">
            <table class="table table-hover align-middle text-center">
                <thead class="table-success">
                <tr>
                    <th>#</th>
                    <th>Tên Tỉnh / Thành phố</th>
                    <th>Tên Phường / Xã</th>
                    <th>Hành động</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="w" items="${wards}" varStatus="loop">
                    <tr>
                        <td>${loop.index + 1}</td>
                        <td>${w.province.provinceName}</td>
                        <td>${w.wardName}</td>
                        <td>
                            <!-- Nút sửa -->
                            <button class="btn btn-outline-primary btn-sm"
                                    data-bs-toggle="modal"
                                    data-bs-target="#editWardModal${w.wardId}">
                                <i class="bi bi-pencil-square"></i> Sửa
                            </button>

                            <!-- Nút xóa -->
                            <form action="${pageContext.request.contextPath}/admin/locations/delete-ward"
                                  method="post" class="d-inline">
                                <input type="hidden" name="wardId" value="${w.wardId}">
                                <button type="submit" class="btn btn-outline-danger btn-sm"
                                        onclick="return confirm('Bạn có chắc muốn xóa phường này?');">
                                    <i class="bi bi-trash"></i> Xóa
                                </button>
                            </form>

                            <!-- Modal sửa phường -->
                            <div class="modal fade" id="editWardModal${w.wardId}" tabindex="-1" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <form action="${pageContext.request.contextPath}/admin/locations/update-ward" method="post">
                                            <div class="modal-header bg-success text-white">
                                                <h5 class="modal-title">✏️ Sửa Phường / Xã</h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                            </div>
                                            <div class="modal-body">
                                                <input type="hidden" name="wardId" value="${w.wardId}">
                                                <div class="mb-3">
                                                    <label class="form-label">Tên hiện tại</label>
                                                    <input type="text" class="form-control" value="${w.wardName}" name="wardName" required>
                                                </div>
                                            </div>
                                            <div class="modal-footer">
                                                <button type="submit" class="btn btn-success">Lưu thay đổi</button>
                                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </td>

                    </tr>
                </c:forEach>

                <c:if test="${empty wards}">
                    <tr>
                        <td colspan="4" class="text-muted">Chưa có dữ liệu phường nào.</td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<footer class="text-center mt-5 py-3 text-muted small">
    © 2025 SmartBin Management System
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
