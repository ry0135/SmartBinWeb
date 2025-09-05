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
        body {
            margin: 0;
            font-family: 'Segoe UI', sans-serif;
            background: #f9fafb;
        }
        .container {
            display: flex;
        }
        /* Sidebar */
        .sidebar {
            width: 240px;
            background: #fff;
            border-right: 1px solid #e5e7eb;
            padding: 20px 0;
            display: flex;
            flex-direction: column;
            height: 100vh;
        }
        .sidebar h2 {
            text-align: center;
            font-size: 18px;
            margin-bottom: 20px;
        }
        .menu {
            list-style: none;
            padding: 0;
        }
        .menu li {
            padding: 12px 20px;
            cursor: pointer;
            display: flex;
            align-items: center;
            color: #374151;
        }
        .menu li.active {
            background: #f3f4f6;
            font-weight: bold;
            border-left: 4px solid #3b82f6;
        }
        .menu li:hover {
            background: #f9fafb;
        }
        /* Main */
        .main {
            flex: 1;
            display: flex;
            flex-direction: column;
        }
        .header {
            background: #fff;
            padding: 16px 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #e5e7eb;
        }
        .header h1 {
            margin: 0;
            font-size: 20px;
        }
        .user-info {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .user-info img {
            width: 32px;
            height: 32px;
            border-radius: 50%;
        }
        /* Stats */
        .stats {
            display: flex;
            gap: 20px;
            padding: 20px;
        }
        .stat-card {
            flex: 1;
            background: #fff;
            padding: 16px;
            border-radius: 8px;
            box-shadow: 0 1px 2px rgba(0,0,0,0.05);
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .stat-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            color: #fff;
        }
        .bg-blue { background: #3b82f6; }
        .bg-orange { background: #f97316; }
        .bg-green { background: #22c55e; }
        .map-container {
            flex: 1;
            padding: 0 20px 20px 20px;
        }
        #map {
            width: 100%;
            height: 500px;
            border-radius: 8px;
            overflow: hidden;
        }
        .filter-section {
            padding: 10px 20px;
            display: flex;
            gap: 15px;
            align-items: center;
        }
        .filter-section label {
            font-weight: bold;
        }
        .table-section {
            padding: 0 20px 20px 20px;
        }
        table {
            border-collapse: collapse;
            width: 100%;
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 1px 2px rgba(0,0,0,0.05);
        }
        th, td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #e5e7eb;
        }
        th {
            background-color: #f9fafb;
            font-weight: bold;
        }
        tr:hover {
            background-color: #f3f4f6;
        }
        /* Filter section */
        .filter-section {
            padding: 12px 20px;
            display: flex;
            gap: 20px;
            align-items: center;
            background: #fff;
            border-radius: 8px;
            margin: 15px 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }
        .filter-section label {
            font-weight: 600;
            font-size: 14px;
            color: #374151;
            margin-right: 6px;
        }
        .filter-section select {
            padding: 6px 10px;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            background: #fff;
            font-size: 14px;
            color: #374151;
            outline: none;
            transition: border 0.2s;
        }
        .filter-section select:focus {
            border-color: #3b82f6;
            box-shadow: 0 0 0 2px rgba(59,130,246,0.2);
        }

        /* Table styling */
        .table-section {
            padding: 20px;
        }
        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            background: #fff;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        thead th {
            background: #f3f4f6;
            font-weight: 600;
            font-size: 14px;
            color: #374151;
            text-align: left;
            padding: 12px 16px;
            border-bottom: 2px solid #e5e7eb;
        }
        tbody td {
            font-size: 14px;
            color: #4b5563;
            padding: 12px 16px;
            border-bottom: 1px solid #e5e7eb;
        }
        tbody tr:last-child td {
            border-bottom: none;
        }
        tbody tr:hover {
            background: #f9fafb;
            transition: background 0.2s;
        }

        /* Trạng thái màu trong bảng */
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
        }
        .btn-detail:hover {
            background: #2563eb;
        }

    </style>
</head>
<body>
<div class="container">
    <%@ include file="manage-head.jsp" %>
    <!-- Stats -->
    <div class="stats">
        <div class="stat-card">
            <div class="stat-icon bg-blue">📦</div>
            <div>
                <div style="font-size:18px;font-weight:bold;">${totalBins}</div>
                <div style="color:#6b7280;">Tổng số thùng</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon bg-orange">⚠️</div>
            <div>
                <div style="font-size:18px;font-weight:bold;">${alertCount}</div>
                <div style="color:#6b7280;">Lỗi/Cảnh báo</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon bg-green">📄</div>
            <div>
                <div style="font-size:18px;font-weight:bold;">${newReports}</div>
                <div style="color:#6b7280;">Báo cáo mới</div>
            </div>
        </div>
    </div>
    <!-- Map -->
    <div class="map-container">
        <div id="map"></div>
    </div>

    <div class="filter-section">
        <label>Khu vực:</label>
        <select id="cityFilter">
            <option value="">-- Tất cả --</option>
            <c:forEach var="city" items="${cities}">
                <option value="${city}">${city}</option>
            </c:forEach>
        </select>

        <label>Phường/Xã:</label>
        <select id="wardFilter">
            <option value="">-- Tất cả --</option>
            <c:forEach var="ward" items="${wards}">
                <option value="${ward}">${ward}</option>
            </c:forEach>
        </select>

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

    <div class="table-section">
        <table border="1" width="100%" id="binTable">
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
                <tr data-city="${bin.city}" data-ward="${bin.ward}" data-status="${bin.status}" data-fill="${bin.currentFill}">
                    <td>${bin.binCode}</td>
                    <td>${bin.street}, ${bin.ward}, ${bin.city}</td>
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

                    <td><c:choose>
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

    <script>
        // Hàm chọn icon theo mức đầy
        function getBinIcon(level) {
            if (level >= 80) {
                return "data:image/svg+xml;charset=UTF-8," + encodeURIComponent(`
                    <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" fill="red" viewBox="0 0 24 24">
                        <path d="M3 6h18v2H3zm2 3h14l-1.5 12h-11z"/>
                    </svg>
                `);
            } else if (level >= 40) {
                return "data:image/svg+xml;charset=UTF-8," + encodeURIComponent(`
                    <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" fill="orange" viewBox="0 0 24 24">
                        <path d="M3 6h18v2H3zm2 3h14l-1 8h-12z"/>
                    </svg>
                `);
            } else {
                return "data:image/svg+xml;charset=UTF-8," + encodeURIComponent(`
                    <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" fill="green" viewBox="0 0 24 24">
                        <path d="M3 6h18v2H3z"/>
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
        var bins = [
            <c:forEach var="bin" items="${bins}" varStatus="loop">
            {
                code: '${bin.binCode}',
                lat: ${bin.latitude},
                lng: ${bin.longitude},
                fullness: ${bin.currentFill != null ? bin.currentFill : 0},
                address: '${bin.street}, ${bin.ward}, ${bin.city}',
                updated: '${bin.lastUpdated}',
                city: '${bin.city}',
                ward: '${bin.ward}',
                status: '${bin.status}'

            }<c:if test="${!loop.last}">,</c:if>
            </c:forEach>
        ];

        // Mảng lưu trữ các marker
        var markers = [];

        // Thêm marker cho từng bin
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
                .setPopup(popup);

            marker.addTo(map);
            marker.bin = bin; // Lưu thông tin bin vào marker
            markers.push(marker);
        });

        // Filter function
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

            // Lọc marker
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
</div> <!-- Đóng thẻ div.main -->
</div> <!-- Đóng thẻ div.container -->
</body>
</html>