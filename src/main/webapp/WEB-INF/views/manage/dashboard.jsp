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
            <h1 class="h4 mb-0 text-dark">Dashboard Quản lý Thùng Rác</h1>
            <div class="d-flex align-items-center">
                <button class="btn btn-outline-secondary position-relative">
                    🔔
                    <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                        3
                    </span>
                </button>
            </div>
        </div>

        <div class="p-4">
            <!-- Stats Cards -->
            <div class="row g-4 mb-4">
                <div class="col-md-4">
                    <div class="card border-0 shadow-sm h-100">
                        <div class="card-body d-flex align-items-center">
                            <div class="bg-primary text-white rounded-3 p-3 me-3">
                                <span class="fs-4">🗑️</span>
                            </div>
                            <div>
                                <h3 class="h4 mb-1">${totalBins}</h3>
                                <p class="text-muted mb-0">Tổng số thùng</p>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card border-0 shadow-sm h-100">
                        <div class="card-body d-flex align-items-center">
                            <div class="bg-warning text-white rounded-3 p-3 me-3">
                                <span class="fs-4">⚠️</span>
                            </div>
                            <div>
                                <h3 class="h4 mb-1">${alertCount}</h3>
                                <p class="text-muted mb-0">Cảnh báo</p>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card border-0 shadow-sm h-100">
                        <div class="card-body d-flex align-items-center">
                            <div class="bg-success text-white rounded-3 p-3 me-3">
                                <span class="fs-4">📄</span>
                            </div>
                            <div>
                                <h3 class="h4 mb-1">${newReports}</h3>
                                <p class="text-muted mb-0">Báo cáo mới</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Main Layout: Filter Left, Map Right -->
            <div class="row g-4 mb-4">
                <!-- Filter Panel - Left Side -->
                <div class="col-md-4">
                    <div class="card border-0 shadow-sm h-100">
                        <div class="card-header bg-white border-bottom-0">
                            <h5 class="mb-0">
                                <i class="fas fa-filter me-2"></i>Bộ lọc
                            </h5>
                        </div>
                        <div class="card-body">
                            <div class="mb-3">
                                <label for="cityFilter" class="form-label fw-semibold">
                                    <i class="fas fa-city me-1 text-primary"></i>Khu vực:
                                </label>
                                <select class="form-select" id="cityFilter">
                                    <option value="">-- Tất cả --</option>
                                    <c:forEach var="city" items="${cities}">
                                        <option value="${city}">${city}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label for="wardFilter" class="form-label fw-semibold">
                                    <i class="fas fa-map-marker-alt me-1 text-success"></i>Phường/Xã:
                                </label>
                                <select class="form-select" id="wardFilter">
                                    <option value="">-- Tất cả --</option>
                                    <c:forEach var="ward" items="${wards}">
                                        <option value="${ward}">${ward}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label for="fillFilter" class="form-label fw-semibold">
                                    <i class="fas fa-chart-bar me-1 text-warning"></i>Mức đầy:
                                </label>
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




                            <div class="mb-3">
                                <label class="form-label fw-semibold">Hoạt động:</label>
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

                            <!-- Results Summary -->
                            <div class="alert alert-info">
                                <small>
                                    <strong id="resultCount">0</strong> thùng rác được tìm thấy
                                </small>
                            </div>

                            <!-- Quick Actions -->
                            <div class="d-grid gap-2">
                                <button class="btn btn-success btn-sm" onclick="exportReport()">
                                    📊 Xuất báo cáo
                                </button>
                                <button class="btn btn-outline-primary btn-sm" onclick="focusOnResults()">
                                    📍 Xem trên bản đồ
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Map Section - Right Side -->
                <div class="col-md-8">
                    <div class="card border-0 shadow-sm h-100">
                        <div class="card-header bg-white border-bottom d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">🗺️ Bản đồ thùng rác</h5>
                            <div class="btn-group btn-group-sm" role="group">
                                <button type="button" class="btn btn-outline-secondary" onclick="map.zoomIn()">
                                    ➕
                                </button>
                                <button type="button" class="btn btn-outline-secondary" onclick="map.zoomOut()">
                                    ➖
                                </button>
                                <button type="button" class="btn btn-outline-secondary" onclick="resetMapView()">
                                    🏠
                                </button>
                            </div>
                        </div>
                        <div class="card-body p-0">
                            <div id="map" style="height: 500px;" class="rounded-bottom"></div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Table Section with Pagination -->
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-white border-bottom d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">📋 Danh sách thùng rác</h5>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0" id="binTable">
                            <thead class="table-light">
                            <tr>
                                <th class="fw-semibold">Mã</th>
                                <th class="fw-semibold">Địa chỉ</th>
                                <th class="fw-semibold">Đầy (%)</th>
                                <th class="fw-semibold">Mức Chứa</th>
                                <th class="fw-semibold">Hoạt Động</th>
                                <th class="fw-semibold">Chi tiết</th>
                            </tr>
                            </thead>
                            <tbody id="binTableBody">
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
                                        <span class="badge ${bin.currentFill >= 80 ? 'bg-danger' : bin.currentFill >= 40 ? 'bg-warning' : 'bg-success'}">
                                            ${bin.currentFill}%
                                        </span>
                                    </td>
                                    <td>${bin.capacity}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${bin.status == 1}">
                                                <span class="badge bg-success">Online</span>
                                            </c:when>
                                            <c:when test="${bin.status == 2}">
                                                <span class="badge bg-secondary">Offline</span>
                                            </c:when>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/manage/bin/${bin.binID}"
                                           class="btn btn-primary btn-sm">
                                            Chi tiết
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <div class="d-flex justify-content-between align-items-center p-3 border-top">
                        <div class="text-muted">
                            Hiển thị <span id="showingFrom">1</span> đến <span id="showingTo">25</span>
                            trong tổng số <span id="totalItems">0</span> mục
                        </div>
                        <nav>
                            <ul class="pagination pagination-sm mb-0" id="pagination">
                                <!-- Pagination sẽ được tạo bởi JavaScript -->
                            </ul>
                        </nav>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // Hàm chọn icon theo mức đầy
    function getBinIcon(level, status) {
        if (status == 2) {
            return "data:image/svg+xml;charset=UTF-8," + encodeURIComponent(`
                <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" fill="gray" viewBox="0 0 24 24">
                    <path d="M3 6h18v2H3zm2 2h14v14H5z"/>
                    <rect x="5" y="16" width="14" height="4" fill="rgba(0,0,0,0.3)"/>
                </svg>
            `);
        } else if (level >= 80) {
            return "data:image/svg+xml;charset=UTF-8," + encodeURIComponent(`
                <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" fill="red" viewBox="0 0 24 24">
                    <path d="M3 6h18v2H3zm2 2h14v14H5z"/>
                    <rect x="5" y="8" width="14" height="12" fill="rgba(0,0,0,0.3)"/>
                </svg>
            `);
        } else if (level >= 40) {
            return "data:image/svg+xml;charset=UTF-8," + encodeURIComponent(`
                <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" fill="orange" viewBox="0 0 24 24">
                    <path d="M3 6h18v2H3zm2 2h14v14H5z"/>
                    <rect x="5" y="12" width="14" height="8" fill="rgba(0,0,0,0.3)"/>
                </svg>
            `);
        } else {
            return "data:image/svg+xml;charset=UTF-8," + encodeURIComponent(`
                <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" fill="green" viewBox="0 0 24 24">
                    <path d="M3 6h18v2H3zm2 2h14v14H5z"/>
                    <rect x="5" y="16" width="14" height="4" fill="rgba(0,0,0,0.3)"/>
                </svg>
            `);
        }
    }

    // Khởi tạo bản đồ VietMap
    var map = new vietmapgl.Map({
        container: "map",
        style: "https://maps.vietmap.vn/maps/styles/tm/style.json?apikey=ecdbd35460b2d399e18592e6264186757aaaddd8755b774c",
        center: [108.2068, 16.0471],
        zoom: 12
    });

    map.addControl(new vietmapgl.NavigationControl());

    var bins = [
        <c:forEach var="bin" items="${bins}" varStatus="loop">
        {
            code: '${bin.binCode}',
            lat: ${bin.latitude},
            lng: ${bin.longitude},
            fullness: ${bin.currentFill != null ? bin.currentFill : 0},
            address: '${bin.street}, ${bin.ward.wardName}, ${bin.ward.province.provinceName}',
            updated: '${bin.lastUpdated}',
            city: '${bin.ward.province.provinceName}',
            ward: '${bin.ward.wardName}',
            status: '${bin.status}'
        }<c:if test="${!loop.last}">,</c:if>
        </c:forEach>
    ];

    var markers = [];

    map.on('load', function() {
        bins.forEach(function(bin) {
            var el = document.createElement("img");
            el.src = getBinIcon(bin.fullness, bin.status);
            el.style.width = "32px";
            el.style.height = "32px";

            var popup = new vietmapgl.Popup({ offset: 25 }).setHTML(
                "<b>Mã:</b> " + bin.code +
                "<br><b>Địa chỉ:</b> " + bin.address +
                "<br><b>Đầy:</b> " + bin.fullness + "%" +
                "<br><b>Trạng thái:</b> " + (bin.status == 1 ? "Online" : "Offline") +
                "<br><b>Cập nhật:</b> " + bin.updated
            );

            var marker = new vietmapgl.Marker({ element: el })
                .setLngLat([bin.lng, bin.lat])
                .setPopup(popup)
                .addTo(map);

            marker.bin = bin;
            markers.push(marker);
        });
    });

    function applyFilter() {
        var city = document.getElementById("cityFilter").value;
        var ward = document.getElementById("wardFilter").value;
        var status = document.getElementById("statusFilter").value;
        var fill = document.getElementById("fillFilter").value;

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

        markers.forEach(function(m) {
            var matchFill = true;
            if (fill) {
                if (fill == 80) matchFill = m.bin.fullness >= 80;
                else if (fill == 40) matchFill = m.bin.fullness >= 40 && m.bin.fullness < 80;
                else if (fill == 0) matchFill = m.bin.fullness < 40;
            }

            var match = (!city || city === m.bin.city)
                && (!ward || ward === m.bin.ward)
                && (!status || status == m.bin.status)
                && matchFill;

            if (match) {
                if (!m._map) m.addTo(map);
            } else {
                if (m._map) m.remove();
            }
        });
    }

    document.getElementById("cityFilter").addEventListener("change", applyFilter);
    document.getElementById("wardFilter").addEventListener("change", applyFilter);
    document.getElementById("statusFilter").addEventListener("change", applyFilter);
    document.getElementById("fillFilter").addEventListener("change", applyFilter);
</script>
</body>
</html>