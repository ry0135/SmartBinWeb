<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>Trash Bin App - Dashboard</title>
    <link href="https://unpkg.com/@vietmap/vietmap-gl-js@6.0.0/dist/vietmap-gl.css" rel="stylesheet" />
    <script src="https://unpkg.com/@vietmap/vietmap-gl-js@6.0.0/dist/vietmap-gl.js"></script>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', sans-serif;
            background: #f9fafb;
            display: flex;
            min-height: 100vh;
        }
        /* Sidebar */
        .sidebar {
            width: 240px;
            background: #fff;
            border-right: 1px solid #e5e7eb;
            display: flex;
            flex-direction: column;
            flex-shrink: 0;
        }
        .sidebar-header {
            padding: 20px;
            border-bottom: 1px solid #e5e7eb;
        }
        .sidebar-header h2 {
            font-size: 18px;
            color: #1f2937;
        }
        .menu {
            list-style: none;
            padding: 20px 0;
            flex-grow: 1;
        }
        .menu li {
            padding: 12px 20px;
            cursor: pointer;
            display: flex;
            align-items: center;
            color: #374151;
            transition: all 0.2s;
        }
        .menu li.active {
            background: #f3f4f6;
            font-weight: bold;
            border-left: 4px solid #3b82f6;
            color: #3b82f6;
        }
        .menu li:hover {
            background: #f9fafb;
        }
        .sidebar-footer {
            padding: 15px 20px;
            border-top: 1px solid #e5e7eb;
            margin-top: auto;
        }
        .user-info {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .user-info img {
            width: 32px;
            height: 32px;
            border-radius: 50%;
        }
        .user-details {
            font-size: 14px;
        }
        .user-details .name {
            font-weight: 600;
            color: #1f2937;
        }
        .user-details .role {
            color: #6b7280;
            font-size: 12px;
        }

        /* Main Content */
        .main-content {
            flex: 1;
            display: flex;
            flex-direction: column;
            overflow: auto;
        }
        .header {
            background: #fff;
            padding: 16px 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #e5e7eb;
            flex-shrink: 0;
        }
        .header h1 {
            margin: 0;
            font-size: 20px;
            color: #1f2937;
        }
        .header-actions {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .notification-btn {
            position: relative;
            background: none;
            border: none;
            cursor: pointer;
            font-size: 18px;
        }
        .notification-badge {
            position: absolute;
            top: -5px;
            right: -5px;
            background: #ef4444;
            color: white;
            border-radius: 50%;
            width: 18px;
            height: 18px;
            font-size: 11px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        /* Content Area */
        .content {
            padding: 20px;
            flex: 1;
            overflow-y: auto;
        }

        /* Stats */
        .stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 20px;
            margin-bottom: 24px;
        }
        .stat-card {
            background: #fff;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            display: flex;
            align-items: center;
            gap: 16px;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .stat-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .stat-icon {
            width: 50px;
            height: 50px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
        }
        .bg-blue { background: #3b82f6; }
        .bg-orange { background: #f97316; }
        .bg-green { background: #22c55e; }
        .stat-details {
            flex: 1;
        }
        .stat-value {
            font-size: 24px;
            font-weight: bold;
            color: #1f2937;
            margin-bottom: 4px;
        }
        .stat-label {
            color: #6b7280;
            font-size: 14px;
        }

        /* Map */
        .map-container {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            padding: 20px;
            margin-bottom: 24px;
        }
        .map-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 16px;
        }
        .map-header h3 {
            font-size: 18px;
            color: #1f2937;
        }
        #map {
            width: 100%;
            height: 400px;
            border-radius: 8px;
            overflow: hidden;
        }

        /* Filter section */
        .filter-section {
            background: #fff;
            border-radius: 12px;
            padding: 16px 20px;
            margin-bottom: 24px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            display: flex;
            flex-wrap: wrap;
            gap: 16px;
            align-items: center;
        }
        .filter-group {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .filter-group label {
            font-weight: 600;
            font-size: 14px;
            color: #374151;
            white-space: nowrap;
        }
        .filter-group select {
            padding: 8px 12px;
            border: 1px solid #d1d5db;
            border-radius: 8px;
            background: #fff;
            font-size: 14px;
            color: #374151;
            outline: none;
            transition: border 0.2s;
            min-width: 150px;
        }
        .filter-group select:focus {
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59,130,246,0.2);
        }

        /* Table section */
        .table-section {
            background: #fff;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        .table-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 16px;
        }
        .table-header h3 {
            font-size: 18px;
            color: #1f2937;
        }
        .export-btn {
            background: #10b981;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .export-btn:hover {
            background: #059669;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        thead {
            background: #f9fafb;
        }
        th {
            text-align: left;
            padding: 12px 16px;
            font-weight: 600;
            color: #374151;
            border-bottom: 2px solid #e5e7eb;
        }
        td {
            padding: 12px 16px;
            border-bottom: 1px solid #e5e7eb;
            color: #4b5563;
        }
        tbody tr {
            transition: background 0.2s;
        }
        tbody tr:hover {
            background: #f9fafb;
        }
        .status-online {
            color: #22c55e;
            font-weight: 600;
        }
        .status-offline {
            color: #ef4444;
            font-weight: 600;
        }
        .status-warning {
            color: #f97316;
            font-weight: 600;
        }
        .btn-detail {
            padding: 6px 12px;
            background: #3b82f6;
            color: #fff;
            border-radius: 6px;
            text-decoration: none;
            font-size: 13px;
            display: inline-block;
            transition: background 0.2s;
        }
        .btn-detail:hover {
            background: #2563eb;
        }

        /* Responsive */
        @media (max-width: 1024px) {
            .sidebar {
                width: 200px;
            }
            .stats {
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            }
        }
        @media (max-width: 768px) {
            body {
                flex-direction: column;
            }
            .sidebar {
                width: 100%;
                height: auto;
                border-right: none;
                border-bottom: 1px solid #e5e7eb;
            }
            .menu {
                display: flex;
                overflow-x: auto;
                padding: 10px 0;
            }
            .menu li {
                padding: 10px 15px;
                white-space: nowrap;
            }
            .filter-section {
                flex-direction: column;
                align-items: stretch;
            }
            .filter-group {
                width: 100%;
            }
            .filter-group select {
                width: 100%;
            }
        }
    </style>
</head>
<body>
<!-- Sidebar -->
<div class="sidebar">
    <h2>Trash Bin App</h2>
    <ul class="menu">
        <li class="active">📊 Dashboard</li>
        <li>🗑️ Danh sách thùng rác</li>
        <li>⚠️ Báo cáo</li>
        <li>👤 Người dùng</li>
        <li>⚙️ Cài đặt</li>
    </ul>
</div>

<!-- Main Content -->
<div class="main-content">
    <div class="header">
        <h1>Dashboard Quản lý Thùng Rác</h1>
        <div class="header-actions">
            <button class="notification-btn">
                🔔
                <span class="notification-badge">3</span>
            </button>
        </div>
    </div>

    <div class="content">
        <!-- Stats -->
        <div class="stats">
            <div class="stat-card">
                <div class="stat-icon bg-blue">🗑️</div>
                <div class="stat-details">
                    <div class="stat-value">${totalBins}</div>
                    <div class="stat-label">Tổng số thùng</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon bg-orange">⚠️</div>
                <div class="stat-details">
                    <div class="stat-value">${alertCount}</div>
                    <div class="stat-label">Cảnh báo</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon bg-green">📄</div>
                <div class="stat-details">
                    <div class="stat-value">${newReports}</div>
                    <div class="stat-label">Báo cáo mới</div>
                </div>
            </div>
        </div>

        <!-- Map -->
        <div class="map-container">
            <div class="map-header">
                <h3>Bản đồ thùng rác</h3>
            </div>
            <div id="map"></div>
        </div>

        <!-- Filter Section -->
        <div class="filter-section">
            <div class="filter-group">
                <label>Khu vực:</label>
                <select id="cityFilter">
                    <option value="">-- Tất cả --</option>
                    <c:forEach var="city" items="${cities}">
                        <option value="${city}">${city}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="filter-group">
                <label>Phường/Xã:</label>
                <select id="wardFilter">
                    <option value="">-- Tất cả --</option>
                    <c:forEach var="ward" items="${wards}">
                        <option value="${ward}">${ward}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="filter-group">
                <label>Hoạt động:</label>
                <select id="statusFilter">
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

            <div class="filter-group">
                <label>Mức đầy:</label>
                <select id="fillFilter">
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

        <!-- Table Section -->
        <div class="table-section">
            <div class="table-header">
                <h3>Danh sách thùng rác</h3>
                <button class="export-btn">📊 Xuất báo cáo</button>
            </div>
            <table id="binTable">
                <thead>
                <tr>
                    <th>Mã</th>
                    <th>Địa chỉ</th>
                    <th>Đầy (%)</th>
                    <th>Trạng thái</th>
                    <th>Hoạt Động</th>
                    <th>Chi tiết</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="bin" items="${bins}">
                    <tr data-city="${bin.ward.province.provinceName}"
                        data-ward="${bin.ward.wardName}"
                        data-status="${bin.status}"
                        data-fill="${bin.currentFill}">
                        <td>${bin.binCode}</td>
                        <td>${bin.street},
                            <c:if test="${not empty bin.ward}">${bin.ward.wardName}</c:if>
                            <c:if test="${not empty bin.ward and not empty bin.ward.province}">, ${bin.ward.province.provinceName}</c:if>
                        </td>
                        <td>${bin.currentFill}</td>
                        <td>
                            <c:choose>
                                <c:when test="${bin.currentFill >= 80}">
                                    <span class="status-offline">Cảnh báo</span>
                                </c:when>
                                <c:when test="${bin.currentFill >= 40}">
                                    <span class="status-warning">Trung bình</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="status-online">Bình thường</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${bin.status == 1}">Online</c:when>
                                <c:when test="${bin.status == 2}">Offline</c:when>
                            </c:choose>
                        </td>
                        <td>
                            <a href="${pageContext.request.contextPath}/manage/bin/${bin.binID}" class="btn-detail">Xem thêm</a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
    // Hàm chọn icon theo mức đầy
    function getBinIcon(level) {
        if (level >= 80) {
            return "data:image/svg+xml;charset=UTF-8," + encodeURIComponent(`
            <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" fill="red" viewBox="0 0 24 24">
                <path d="M3 6h18v2H3zm2 2h14v14H5z"/>
                <!-- Mức đầy cao -->
                <rect x="5" y="8" width="14" height="12" fill="rgba(0,0,0,0.3)"/>
            </svg>
        `);
        } else if (level >= 40) {
            return "data:image/svg+xml;charset=UTF-8," + encodeURIComponent(`
            <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" fill="orange" viewBox="0 0 24 24">
                <path d="M3 6h18v2H3zm2 2h14v14H5z"/>
                <!-- Mức đầy trung bình -->
                <rect x="5" y="12" width="14" height="8" fill="rgba(0,0,0,0.3)"/>
            </svg>
        `);
        } else {
            return "data:image/svg+xml;charset=UTF-8," + encodeURIComponent(`
            <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" fill="green" viewBox="0 0 24 24">
                <path d="M3 6h18v2H3zm2 2h14v14H5z"/>
                <!-- Mức đầy thấp -->
                <rect x="5" y="16" width="14" height="4" fill="rgba(0,0,0,0.3)"/>
            </svg>
        `);
        }
    }

    // Khởi tạo bản đồ VietMap
    var map = new vietmapgl.Map({
        container: "map",
        style: "https://maps.vietmap.vn/maps/styles/tm/style.json?apikey=ecdbd35460b2d399e18592e6264186757aaaddd8755b774c",
        center: [108.2068, 16.0471], // Đà Nẵng
        zoom: 12
    });

    // Thêm điều khiển zoom & xoay
    map.addControl(new vietmapgl.NavigationControl());

    // Danh sách bins từ backend
    // Danh sách bins từ backend - SỬA LẠI PHẦN NÀY
    var bins = [
        <c:forEach var="bin" items="${bins}" varStatus="loop">
        {
            code: '${bin.binCode}',
            lat: ${bin.latitude},
            lng: ${bin.longitude},
            fullness: ${bin.currentFill != null ? bin.currentFill : 0},
            address: '${bin.street}, ${bin.ward.wardName}, ${bin.ward.province.provinceName}',
            updated: '${bin.lastUpdated}',
            city: '${bin.ward.province.provinceName}', // SỬA THÀNH TÊN TỈNH/THÀNH PHỐ
            ward: '${bin.ward.wardName}', // SỬA THÀNH TÊN PHƯỜNG/XÃ
            status: '${bin.status}'
        }<c:if test="${!loop.last}">,</c:if>
        </c:forEach>
    ];

    // Mảng lưu trữ các marker
    var markers = [];

    // Thêm marker cho từng bin
    map.on('load', function() {
        bins.forEach(function(bin) {
            // Tạo element <img> với icon màu
            var el = document.createElement("img");
            el.src = getBinIcon(bin.fullness);
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

            marker.bin = bin; // Lưu thông tin bin vào marker
            markers.push(marker);
        });
    });

    // Filter function
    // Filter function
    function applyFilter() {
        var city = document.getElementById("cityFilter").value;
        var ward = document.getElementById("wardFilter").value;
        var status = document.getElementById("statusFilter").value;
        var fill = document.getElementById("fillFilter").value;

        // Lọc bảng - SỬA LẠI PHẦN NÀY
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

        // Lọc marker - CŨNG CẦN SỬA LẠI
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