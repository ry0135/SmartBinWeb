<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<%@include file="../include/head.jsp"%>
<body>
<div class="container">
    <!-- Sidebar -->
   <%@include file="../include/sidebar.jsp"%>

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
                                onclick="location.href='${pageContext.request.contextPath}/tasks/task-management'">
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