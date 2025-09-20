<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

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
        <h1 class="h4 mb-0 text-dark">Quản lý thùng rác</h1>
        <div class="d-flex align-items-center">
            <button class="btn btn-outline-secondary position-relative">
                🔔
                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                    3
                </span>
            </button>
        </div>
    </div>

    <div class="content p-4">
        <!-- Filter Section -->
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-body">
                <div class="row g-3">
                    <div class="col-md-3">
                        <label for="cityFilter" class="form-label fw-semibold">Khu vực:</label>
                        <select class="form-select" id="cityFilter">
                            <option value="">-- Tất cả --</option>
                            <c:forEach var="city" items="${cities}">
                                <option value="${city}">${city}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="col-md-3">
                        <label for="wardFilter" class="form-label fw-semibold">Phường/Xã:</label>
                        <select class="form-select" id="wardFilter">
                            <option value="">-- Tất cả --</option>
                            <c:forEach var="ward" items="${wards}">
                                <option value="${ward}">${ward}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="col-md-3">
                        <label for="statusFilter" class="form-label fw-semibold">Hoạt động:</label>
                        <select class="form-select" id="statusFilter">
                            <option value="">-- Tất cả --</option>
                            <c:forEach var="s" items="${statuses}">
                                <option value="${s}">
                                    <c:choose>
                                        <c:when test="${s == 1}">Online</c:when>
                                        <c:when test="${s == 2}">Offline</c:when>
                                    </c:choose>
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="col-md-3">
                        <label for="fillFilter" class="form-label fw-semibold">Mức đầy:</label>
                        <select class="form-select" id="fillFilter">
                            <option value="">-- Tất cả --</option>
                            <c:forEach var="f" items="${currentFills}">
                                <option value="${f}">
                                    <c:choose>
                                        <c:when test="${f == 80}">Cảnh báo (>=80%)</c:when>
                                        <c:when test="${f == 40}">Trung bình (40–79%)</c:when>
                                        <c:when test="${f == 0}">Bình thường (&lt;40%)</c:when>
                                    </c:choose>
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
            </div>
        </div>

        <!-- Table Section -->
        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white border-bottom-0 d-flex justify-content-between align-items-center">
                <h5 class="mb-0">Danh sách thùng rác</h5>
                <button class="btn btn-success btn-sm">
                    <i class="fas fa-file-export me-1"></i> Xuất báo cáo
                </button>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover mb-0" id="binTable">
                        <thead class="table-light">
                        <tr>
                            <th class="fw-semibold">Mã</th>
                            <th class="fw-semibold">Địa chỉ</th>
                            <th class="fw-semibold">Đầy (%)</th>
                            <th class="fw-semibold">Mức chứa</th>
                            <th class="fw-semibold">Hoạt động</th>
                            <th class="fw-semibold">Hành động</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="bin" items="${bins}">
                            <tr data-city="${bin.ward.province.provinceName}"
                                data-ward="${bin.ward.wardName}"
                                data-status="${bin.status}"
                                data-fill="${bin.currentFill}">
                                <td class="fw-medium">${bin.binCode}</td>
                                <td>
                                        ${bin.street}<c:if test="${not empty bin.ward}">, ${bin.ward.wardName}</c:if><c:if test="${not empty bin.ward and not empty bin.ward.province}">, ${bin.ward.province.provinceName}</c:if>
                                </td>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <div class="progress me-2" style="width: 60px; height: 8px;">
                                            <div class="progress-bar ${bin.currentFill >= 80 ? 'bg-danger' : bin.currentFill >= 40 ? 'bg-warning' : 'bg-success'}"
                                                 role="progressbar"
                                                 style="width: ${bin.currentFill}%"
                                                 aria-valuenow="${bin.currentFill}"
                                                 aria-valuemin="0"
                                                 aria-valuemax="100">
                                            </div>
                                        </div>
                                        <small class="text-muted">${bin.currentFill}%</small>
                                    </div>
                                </td>
                                <td>${bin.capacity}L</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${bin.status == 1}">
                                            <span class="badge bg-success">
                                                <i class="fas fa-circle me-1"></i> Online
                                            </span>
                                        </c:when>
                                        <c:when test="${bin.status == 2}">
                                            <span class="badge bg-secondary">
                                                <i class="fas fa-circle me-1"></i> Offline
                                            </span>
                                        </c:when>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="btn-group" role="group">
                                        <button type="button" class="btn btn-outline-primary btn-sm" onclick="editBin(${bin.binID})">
                                            <i class="fas fa-edit me-1"></i> Sửa
                                        </button>
                                        <button type="button" class="btn btn-outline-danger btn-sm" onclick="deleteBin(${bin.binID})">
                                            <i class="fas fa-trash me-1"></i> Xóa
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
    </div>
</div>
<script>
    // Hàm xử lý sửa thùng rác
    function editBin(binId) {
        if (confirm('Bạn có chắc muốn chỉnh sửa thùng rác này?')) {
            window.location.href = '${pageContext.request.contextPath}/manage/bin/edit/' + binId;
        }
    }

    // Hàm xử lý xóa thùng rác
    function deleteBin(binId) {
        if (confirm('Bạn có chắc muốn xóa thùng rác này? Hành động này không thể hoàn tác.')) {
            // Gửi yêu cầu xóa đến server
            fetch('${pageContext.request.contextPath}/manage/bin/delete/' + binId, {
                method: 'DELETE',
            })
                .then(response => {
                    if (response.ok) {
                        alert('Xóa thùng rác thành công!');
                        location.reload();
                    } else {
                        alert('Có lỗi xảy ra khi xóa thùng rác.');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Có lỗi xảy ra khi xóa thùng rác.');
                });
        }
    }

    // Hàm lọc dữ liệu
    function applyFilter() {
        var city = document.getElementById("cityFilter").value;
        var ward = document.getElementById("wardFilter").value;
        var status = document.getElementById("statusFilter").value;
        var fill = document.getElementById("fillFilter").value;

        // Lọc bảng
        document.querySelectorAll("#binTable tbody tr").forEach(function(row) {
            var rowCity = row.getAttribute("data-city");
            var rowWard = row.getAttribute("data-ward");
            var rowStatus = row.getAttribute("data-status");
            var rowFill = parseInt(row.getAttribute("data-fill")) || 0;

            var matchFill = true;
            if (fill) {
                if (fill == 80) matchFill = rowFill >= 80;
                else if (fill == 40) matchFill = rowFill >= 40 && rowFill < 80;
                else if (fill == 0) matchFill = rowFill < 40;
            }

            var match = (!city || city === rowCity)
                && (!ward || ward === rowWard)
                && (!status || status === rowStatus)
                && matchFill;

            row.style.display = match ? "" : "none";
        });
    }

    // Thêm event listeners cho các bộ lọc
    document.getElementById("cityFilter").addEventListener("change", applyFilter);
    document.getElementById("wardFilter").addEventListener("change", applyFilter);
    document.getElementById("statusFilter").addEventListener("change", applyFilter);
    document.getElementById("fillFilter").addEventListener("change", applyFilter);
</script>
</body>
</html>