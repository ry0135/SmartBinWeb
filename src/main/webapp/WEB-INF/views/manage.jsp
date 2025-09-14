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
    </style>
</head>
<body>
<div class="container">
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

    <!-- Main content -->
    <div class="main">
        <!-- Header -->
        <div class="header">
            <h1>Tổng quan</h1>
            <div class="user-info">
                <span>🔔</span>
                <span>Admin User</span>
                <img src="https://i.pravatar.cc/150?img=3" alt="User">
            </div>
        </div>

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
        </div>

        <div class="table-section">
            <table border="1" width="100%" id="binTable">
                <thead>
                <tr>
                    <th>Mã</th>
                    <th>Địa chỉ</th>
                    <th>Đầy (%)</th>
                    <th>Trạng thái</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="bin" items="${bins}">
                    <tr data-city="${bin.city}" data-ward="${bin.ward}">
                        <td>${bin.binCode}</td>
                        <td>${bin.street}, ${bin.ward}, ${bin.city}</td>
                        <td>${bin.currentFill}</td>
                        <td>
                            <c:choose>
                                <c:when test="${bin.currentFill >= 80}"><span style="color:red;">Cảnh báo</span></c:when>
                                <c:when test="${bin.currentFill >= 40}"><span style="color:orange;">Trung bình</span></c:when>
                                <c:otherwise><span style="color:green;">Bình thường</span></c:otherwise>
                            </c:choose>
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
            updated: '${bin.lastUpdated}'
        }<c:if test="${!loop.last}">,</c:if>
        </c:forEach>
    ];

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
            "<br><b>Cập nhật:</b> " + bin.updated
        );

        new vietmapgl.Marker({ element: el })
            .setLngLat([bin.lng, bin.lat])
            .setPopup(popup)
            .addTo(map);
    });
    // Filter function
    function applyFilter() {
        var city = document.getElementById("cityFilter").value;
        var ward = document.getElementById("wardFilter").value;

        // Lọc bảng
        document.querySelectorAll("#binTable tbody tr").forEach(function(row) {
            var rowCity = row.getAttribute("data-city");
            var rowWard = row.getAttribute("data-ward");
            var match = (!city || city === rowCity) && (!ward || ward === rowWard);
            row.style.display = match ? "" : "none";
        });

        // Lọc marker
        markers.forEach(function(m) {
            var match = (!city || city === m.bin.city) && (!ward || ward === m.bin.ward);
            if (match) {
                m.addTo(map);
            } else {
                m.remove();
            }
        });
    }
    document.getElementById("cityFilter").addEventListener("change", applyFilter);
    document.getElementById("wardFilter").addEventListener("change", applyFilter);
</script>



</body>
</html>
