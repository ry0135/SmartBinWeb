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
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', sans-serif;
        }

        html, body {
            height: 100%;
            background: #f9fafb;
        }

        /* Container chính */
        .container {
            display: flex;
            min-height: 100vh;
            height: 100%;
        }

        /* Sidebar - Chiều cao 100% */
        .sidebar {
            width: 240px;
            background: #fff;
            border-right: 1px solid #e5e7eb;
            display: flex;
            flex-direction: column;
            height: 100vh;
            position: fixed;
            left: 0;
            top: 0;
            bottom: 0;
            overflow-y: auto;
        }

        .sidebar h2 {
            text-align: center;
            font-size: 18px;
            margin: 20px 0;
            padding: 0 10px;
        }

        .menu {
            list-style: none;
            padding: 0;
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
        }

        .menu li:hover {
            background: #f9fafb;
        }

        /* Main content */
        .main {
            flex: 1;
            display: flex;
            flex-direction: column;
            margin-left: 240px; /* Để tránh bị sidebar che */
            width: calc(100% - 240px);
            min-height: 100vh;
        }

        /* Header */
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

        /* ========== PHẦN CHÍNH SỬA ========== */

        /* Layout chính */
        .content {
            display: flex;
            gap: 20px;
            padding: 20px;
            flex: 1;
        }

        /* Bản đồ bên trái */
        .map-container {
            flex: 1;
            min-width: 0; /* Để tránh tràn layout */
        }

        #map {
            width: 100%;
            height: 500px;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        /* Thông tin bên phải */
        .detail-card {
            flex: 0 0 400px;
            background: #fff;
            border-radius: 12px;
            padding: 24px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        .detail-card h2 {
            font-size: 20px;
            color: #1f2937;
            margin-bottom: 8px;
            padding-bottom: 12px;
            border-bottom: 2px solid #f3f4f6;
        }

        .detail-table {
            width: 100%;
            border-collapse: collapse;
        }

        .detail-table th, .detail-table td {
            padding: 12px 8px;
            border-bottom: 1px solid #f3f4f6;
            text-align: left;
        }

        .detail-table th {
            font-weight: 600;
            color: #374151;
            width: 120px;
        }

        .detail-table td {
            color: #4b5563;
            font-weight: 500;
        }

        .detail-table tr:last-child th,
        .detail-table tr:last-child td {
            border-bottom: none;
        }

        /* Nút hành động */
        .action-buttons {
            display: flex;
            gap: 12px;
            margin-top: 16px;
            padding-top: 16px;
            border-top: 2px solid #f3f4f6;
        }

        .btn-back {
            display: inline-flex;
            align-items: center;
            background: #6b7280;
            color: #fff;
            padding: 10px 16px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.2s;
        }

        .btn-back:hover {
            background: #4b5563;
            transform: translateY(-1px);
        }

        .btn-assign {
            display: inline-flex;
            align-items: center;
            background: #22c55e;
            color: #fff;
            padding: 10px 16px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 500;
            border: none;
            cursor: pointer;
            transition: all 0.2s;
        }

        .btn-assign:hover {
            background: #16a34a;
            transform: translateY(-1px);
        }

        /* Chỉ báo trạng thái */
        .status-indicator {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 4px 8px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 500;
        }

        .status-online {
            background-color: #dcfce7;
            color: #166534;
        }

        .status-offline {
            background-color: #fee2e2;
            color: #991b1b;
        }

        .fill-indicator {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .fill-bar {
            width: 60px;
            height: 8px;
            background: #e5e7eb;
            border-radius: 4px;
            overflow: hidden;
        }

        .fill-progress {
            height: 100%;
            border-radius: 4px;
        }

        .fill-low { background: #22c55e; }
        .fill-medium { background: #f59e0b; }
        .fill-high { background: #ef4444; }

        /* Responsive */
        @media (max-width: 1024px) {
            .content {
                flex-direction: column;
            }

            .detail-card {
                flex: 0 0 auto;
            }

            #map {
                height: 400px;
            }
        }

        @media (max-width: 768px) {
            .main {
                margin-left: 0;
                width: 100%;
            }

            .sidebar {
                display: none;
            }

            .action-buttons {
                flex-direction: column;
            }
        }
        /* Thêm vào phần CSS */
        .warning-message {
            background: #fffbeb;
            color: #92400e;
            padding: 12px;
            border-radius: 8px;
            border: 1px solid #fcd34d;
            margin-top: 16px;
        }

        .warning-message strong {
            display: block;
            margin-bottom: 8px;
        }

        .warning-message p {
            margin: 8px 0 0 0;
            font-size: 14px;
            line-height: 1.4;
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
            <h1>Chi tiết thùng rác</h1>
            <div class="user-info">
                <span>🔔</span>
                <span>Admin User</span>
                <img src="https://i.pravatar.cc/150?img=3" alt="User">
            </div>
        </div>

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
                    <tr><th>Địa chỉ</th><td>${bin.street}, ${bin.ward.wardName}, ${bin.city}</td></tr>
                    <tr><th>Dung tích</th><td>${bin.capacity}L</td></tr>
                    <tr>
                        <th>Hiện tại</th>
                        <td>
                            <div class="fill-indicator">
                                <div class="fill-bar">
                                    <div class="fill-progress
                                        <c:choose>
                                            <c:when test="${bin.currentFill >= 80}">fill-high</c:when>
                                            <c:when test="${bin.currentFill >= 40}">fill-medium</c:when>
                                            <c:otherwise>fill-low</c:otherwise>
                                        </c:choose>"
                                         style="width: ${bin.currentFill}%">
                                    </div>
                                </div>
                                <span>${bin.currentFill}%</span>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th>Trạng thái</th>
                        <td>
                            <span class="status-indicator
                                <c:choose>
                                    <c:when test="${bin.status == 1}">status-online</c:when>
                                    <c:otherwise>status-offline</c:otherwise>
                                </c:choose>">
                                <c:choose>
                                    <c:when test="${bin.status == 1}">Online 🟢</c:when>
                                    <c:otherwise>Offline 🔴</c:otherwise>
                                </c:choose>
                            </span>
                        </td>
                    </tr>
                    <tr><th>Cập nhật cuối</th><td>${bin.lastUpdated}</td></tr>
                </table>

                <div class="action-buttons">
                    <a href="${pageContext.request.contextPath}/manage" class="btn-back">← Quay lại</a>
                    <c:if test="${not hasOpenTask}">
                        <button type="button" class="btn-assign"
                                onclick="location.href='${pageContext.request.contextPath}/tasks/assign/${bin.binID}?ward=' + encodeURIComponent('${bin.wardID}')">
                            📋 Giao nhiệm vụ
                        </button>
                    </c:if>
                </div>

                <!-- Hiển thị thông báo nếu có task đang mở -->
                <c:if test="${hasOpenTask}">
                    <div class="warning-message">
                        <strong>⚠️ Đang có nhiệm vụ mở</strong>
                        <p>
                            Thùng rác này đã có nhiệm vụ đang được xử lý.
                            Vui lòng hoàn thành nhiệm vụ hiện tại trước khi giao mới.
                        </p>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</div>

<script>
    var binData = {
        code: "${bin.binCode}",
        address: "${bin.street}, ${bin.ward.wardName}, ${bin.city}",
        fullness: ${bin.currentFill},
        status: ${bin.status},
        updated: "${bin.lastUpdated}",
        lat: ${bin.latitude},
        lng: ${bin.longitude}
    };

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

    var map = new vietmapgl.Map({
        container: "map",
        style: "https://maps.vietmap.vn/maps/styles/tm/style.json?apikey=ecdbd35460b2d399e18592e6264186757aaaddd8755b774c",
        center: [binData.lng, binData.lat],
        zoom: 15
    });

    // Thêm điều khiển navigation
    map.addControl(new vietmapgl.NavigationControl());

    var el = document.createElement("img");
    el.src = getBinIcon(binData.fullness);
    el.style.width = "40px";
    el.style.height = "40px";

    var popup = new vietmapgl.Popup({ offset: 25 }).setHTML(
        "<div style='padding: 8px;'><b>Mã:</b> " + binData.code +
        "<br><b>Địa chỉ:</b> " + binData.address +
        "<br><b>Đầy:</b> " + binData.fullness + "%" +
        "<br><b>Trạng thái:</b> " + (binData.status == 1 ? "Online 🟢" : "Offline 🔴") +
        "<br><b>Cập nhật:</b> " + binData.updated + "</div>"
    );

    new vietmapgl.Marker({ element: el })
        .setLngLat([binData.lng, binData.lat])
        .setPopup(popup)
        .addTo(map);
</script>

</body>
</html>