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
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Pagination Section -->
            <div class="card-footer bg-white border-top">
                <div class="d-flex justify-content-between align-items-center">
                    <div class="d-flex align-items-center">
                        <span class="text-muted me-2">Hiển thị:</span>
                        <select class="form-select form-select-sm" id="rowsPerPage" style="width: auto;">
                            <option value="10">10</option>
                            <option value="25" selected>25</option>
                            <option value="50">50</option>
                            <option value="100">100</option>
                        </select>
                        <span class="text-muted ms-3" id="pageInfo">Hiển thị 1-25 của 100</span>
                    </div>

                    <nav>
                        <ul class="pagination pagination-sm mb-0" id="pagination">
                            <li class="page-item disabled" id="prevPage">
                                <a class="page-link" href="#" tabindex="-1">
                                    <i class="fas fa-chevron-left"></i>
                                </a>
                            </li>
                            <!-- Các số trang sẽ được tạo bởi JavaScript -->
                            <li class="page-item" id="nextPage">
                                <a class="page-link" href="#">
                                    <i class="fas fa-chevron-right"></i>
                                </a>
                            </li>
                        </ul>
                    </nav>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    let currentPage = 1;
    let rowsPerPage = 25;
    let filteredRows = [];

    // Hàm xử lý sửa thùng rác
    function editBin(binId) {
        if (confirm('Bạn có chắc muốn chỉnh sửa thùng rác này?')) {
            window.location.href = '${pageContext.request.contextPath}/manage/bin/edit/' + binId;
        }
    }

    // Hàm xử lý xóa thùng rác
    function deleteBin(binId) {
        if (confirm('Bạn có chắc muốn xóa thùng rác này? Hành động này không thể hoàn tác.')) {
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

        filteredRows = [];
        var allRows = document.querySelectorAll("#binTable tbody tr");

        allRows.forEach(function(row) {
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

            if (match) {
                filteredRows.push(row);
            }
        });

        currentPage = 1;
        displayPage();
    }

    // Hàm hiển thị trang
    function displayPage() {
        var allRows = document.querySelectorAll("#binTable tbody tr");
        allRows.forEach(row => row.style.display = "none");

        var start = (currentPage - 1) * rowsPerPage;
        var end = start + rowsPerPage;
        var rowsToShow = filteredRows.length > 0 ? filteredRows : Array.from(allRows);

        for (var i = start; i < end && i < rowsToShow.length; i++) {
            rowsToShow[i].style.display = "";
        }

        updatePagination(rowsToShow.length);
        updatePageInfo(start, end, rowsToShow.length);
    }

    // Cập nhật thông tin trang
    function updatePageInfo(start, end, total) {
        var pageInfo = document.getElementById("pageInfo");
        var displayStart = total > 0 ? start + 1 : 0;
        var displayEnd = Math.min(end, total);
        pageInfo.textContent = `Hiển thị ${displayStart}-${displayEnd} của ${total}`;
    }

    // Cập nhật phân trang
    function updatePagination(totalRows) {
        var totalPages = Math.ceil(totalRows / rowsPerPage);
        var pagination = document.getElementById("pagination");

        // Xóa các nút trang cũ (giữ lại prev và next)
        var pageItems = pagination.querySelectorAll(".page-item:not(#prevPage):not(#nextPage)");
        pageItems.forEach(item => item.remove());

        // Cập nhật nút Previous
        var prevPage = document.getElementById("prevPage");
        if (currentPage === 1) {
            prevPage.classList.add("disabled");
        } else {
            prevPage.classList.remove("disabled");
        }

        // Tạo các nút số trang
        var nextPage = document.getElementById("nextPage");
        var maxPagesToShow = 5;
        var startPage = Math.max(1, currentPage - Math.floor(maxPagesToShow / 2));
        var endPage = Math.min(totalPages, startPage + maxPagesToShow - 1);

        if (endPage - startPage < maxPagesToShow - 1) {
            startPage = Math.max(1, endPage - maxPagesToShow + 1);
        }

        // Nút trang đầu
        if (startPage > 1) {
            var firstPageLi = createPageItem(1, false);
            pagination.insertBefore(firstPageLi, nextPage);

            if (startPage > 2) {
                var dotsLi = document.createElement("li");
                dotsLi.className = "page-item disabled";
                dotsLi.innerHTML = '<span class="page-link">...</span>';
                pagination.insertBefore(dotsLi, nextPage);
            }
        }

        // Các trang ở giữa
        for (var i = startPage; i <= endPage; i++) {
            var pageLi = createPageItem(i, i === currentPage);
            pagination.insertBefore(pageLi, nextPage);
        }

        // Nút trang cuối
        if (endPage < totalPages) {
            if (endPage < totalPages - 1) {
                var dotsLi = document.createElement("li");
                dotsLi.className = "page-item disabled";
                dotsLi.innerHTML = '<span class="page-link">...</span>';
                pagination.insertBefore(dotsLi, nextPage);
            }
            var lastPageLi = createPageItem(totalPages, false);
            pagination.insertBefore(lastPageLi, nextPage);
        }

        // Cập nhật nút Next
        if (currentPage === totalPages || totalPages === 0) {
            nextPage.classList.add("disabled");
        } else {
            nextPage.classList.remove("disabled");
        }
    }

    // Tạo một item phân trang
    function createPageItem(pageNum, isActive) {
        var li = document.createElement("li");
        li.className = "page-item" + (isActive ? " active" : "");

        var a = document.createElement("a");
        a.className = "page-link";
        a.href = "#";
        a.textContent = pageNum;
        a.onclick = function(e) {
            e.preventDefault();
            if (!isActive) {
                currentPage = pageNum;
                displayPage();
            }
        };

        li.appendChild(a);
        return li;
    }

    // Xử lý nút Previous
    document.getElementById("prevPage").addEventListener("click", function(e) {
        e.preventDefault();
        if (currentPage > 1) {
            currentPage--;
            displayPage();
        }
    });

    // Xử lý nút Next
    document.getElementById("nextPage").addEventListener("click", function(e) {
        e.preventDefault();
        var allRows = document.querySelectorAll("#binTable tbody tr");
        var rowsToShow = filteredRows.length > 0 ? filteredRows : Array.from(allRows);
        var totalPages = Math.ceil(rowsToShow.length / rowsPerPage);

        if (currentPage < totalPages) {
            currentPage++;
            displayPage();
        }
    });

    // Xử lý thay đổi số hàng trên mỗi trang
    document.getElementById("rowsPerPage").addEventListener("change", function() {
        rowsPerPage = parseInt(this.value);
        currentPage = 1;
        displayPage();
    });

    // Thêm event listeners cho các bộ lọc
    document.getElementById("cityFilter").addEventListener("change", applyFilter);
    document.getElementById("wardFilter").addEventListener("change", applyFilter);
    document.getElementById("statusFilter").addEventListener("change", applyFilter);
    document.getElementById("fillFilter").addEventListener("change", applyFilter);

    // Khởi tạo hiển thị ban đầu
    window.addEventListener("DOMContentLoaded", function() {
        applyFilter();
    });
</script>
</body>
</html>