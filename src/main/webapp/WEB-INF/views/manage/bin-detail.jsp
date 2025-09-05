<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>Trash Bin Detail</title>
    <link href="https://unpkg.com/@vietmap/vietmap-gl-js@6.0.0/dist/vietmap-gl.css" rel="stylesheet" />
    <script src="https://unpkg.com/@vietmap/vietmap-gl-js@6.0.0/dist/vietmap-gl.js"></script>
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', sans-serif;
            background: #f9fafb;
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
            position: fixed;
            top: 0;
            left: 0;
        }

        /* Header */
        .header {
            background: #fff;
            padding: 16px 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #e5e7eb;
            position: fixed;
            top: 0;
            left: 240px;    /* chừa khoảng sidebar */
            right: 0;
            height: 64px;
            z-index: 1000;
        }

        /* Main content */
        .main {
            margin-left: 240px;   /* chừa sidebar */
            padding: 20px;
            margin-top: 80px;     /* chừa header */
        }

        /* Content layout */
        .content {
            display: flex;
            gap: 20px;
        }

        /* Map */
        .map-container {
            flex: 2;
        }
        #map {
            width: 100%;
            height: 350px;   /* cho nhỏ lại */
            border-radius: 8px;
            overflow: hidden;
        }

        /* Detail card */
        .detail-card {
            flex: 1;
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
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

        .detail-card h2 { margin-top: 0; }

        .detail-table {
            width: 100%;
            border-collapse: collapse;
        }

        .detail-table th, .detail-table td {
            padding: 10px;
            border-bottom: 1px solid #e5e7eb;
            text-align: left;
        }
        .btn-back {
            display: inline-block;
            margin-top: 15px;
            background: #3b82f6;
            color: #fff;
            padding: 8px 16px;
            border-radius: 6px;
            text-decoration: none;
        }
        .btn-back:hover { background: #2563eb; }
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
        .btn-assign {
            display: inline-block;
            margin-top: 15px;
            background: #22c55e; /* Màu xanh lá cây */
            color: #fff;
            padding: 8px 16px;
            border-radius: 6px;
            text-decoration: none;
        }
        .btn-assign:hover {
            background: #15803d; /* Màu đậm hơn khi di chuột */
        }

    </style>
</head>
<body>
<%@ include file="manage-head.jsp" %>
<!-- Map + Detail (chia 2 cột) -->
<div class="content">

    <!-- Bản đồ bên trái -->
    <div class="map-container">
        <div id="map"></div>
    </div>

    <!-- Thông tin bên phải -->
    <div class="detail-card">
        <h2>Thông tin thùng rác</h2>
        <table class="detail-table">
            <tr><th>Mã</th><td>${bin.binCode}</td></tr>
            <tr><th>Địa chỉ</th><td>${bin.street}, ${bin.ward}, ${bin.city}</td></tr>
            <tr><th>Vĩ độ</th><td>${bin.latitude}</td></tr>
            <tr><th>Kinh độ</th><td>${bin.longitude}</td></tr>
            <tr><th>Dung tích</th><td>${bin.capacity}</td></tr>
            <tr><th>Hiện tại</th><td>${bin.currentFill}%</td></tr>
            <tr><th>Trạng thái</th>
                <td>
                    <c:choose>
                        <c:when test="${bin.status == 1}">Online</c:when>
                        <c:otherwise>Offline</c:otherwise>
                    </c:choose>
                </td>
            </tr>
            <tr><th>Lần cập nhật cuối</th><td>${bin.lastUpdated}</td></tr>
        </table>
        <a href="${pageContext.request.contextPath}/manage" class="btn-back">← Quay lại</a>
        <a href="#" id="assignTaskBtn" class="btn-back">Giao nhiệm vụ</a>
    </div>
</div>


<script>
    var binData = {
        code: "${bin.binCode}",
        address: "${bin.street}, ${bin.ward}, ${bin.city}",
        fullness: ${bin.currentFill},
        status: ${bin.status},
        updated: "${bin.lastUpdated}",
        lat: ${bin.latitude},
        lng: ${bin.longitude}
    };

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

    var map = new vietmapgl.Map({
        container: "map",
        style: "https://maps.vietmap.vn/maps/styles/tm/style.json?apikey=ecdbd35460b2d399e18592e6264186757aaaddd8755b774c",
        center: [binData.lng, binData.lat],
        zoom: 15
    });

    var el = document.createElement("img");
    el.src = getBinIcon(binData.fullness);
    el.style.width = "32px";
    el.style.height = "32px";

    var popup = new vietmapgl.Popup({ offset: 25 }).setHTML(
        "<b>Mã:</b> " + binData.code +
        "<br><b>Địa chỉ:</b> " + binData.address +
        "<br><b>Đầy:</b> " + binData.fullness + "%" +
        "<br><b>Trạng thái:</b> " + (binData.status == 1 ? "Online" : "Offline") +
        "<br><b>Cập nhật:</b> " + binData.updated
    );

    new vietmapgl.Marker({ element: el })   // ✅ phải để trong object
        .setLngLat([binData.lng, binData.lat])
        .setPopup(popup)
        .addTo(map);

</script>

</body>
</html>
