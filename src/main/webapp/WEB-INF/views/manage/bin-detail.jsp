<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

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
            <div>
                <h1 class="h4 mb-0 text-dark">Chi tiết thùng rác</h1>
                <small class="text-muted">Xem thông tin chi tiết thùng rác ${bin.binCode}</small>
            </div>
            <div class="d-flex align-items-center">
                <button class="btn btn-outline-secondary position-relative">
                    <i class="fas fa-bell"></i>
                    <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                        3
                    </span>
                </button>
            </div>
        </div>

        <div class="p-4">
            <!-- Map + Detail Section -->
            <div class="row">
                <!-- Map Section - Bên trái -->
                <div class="col-md-6">
                    <div class="card border-0 shadow-sm h-100">
                        <div class="card-header bg-white border-bottom-0 d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">
                                <i class="fas fa-map-marker-alt me-2 text-primary"></i>Vị trí thùng rác
                            </h5>
                            <div class="btn-group btn-group-sm" role="group">
                                <button type="button" class="btn btn-outline-secondary" onclick="map.zoomIn()">
                                    <i class="fas fa-plus"></i>
                                </button>
                                <button type="button" class="btn btn-outline-secondary" onclick="map.zoomOut()">
                                    <i class="fas fa-minus"></i>
                                </button>
                                <button type="button" class="btn btn-outline-secondary" onclick="resetMapView()">
                                    <i class="fas fa-home"></i>
                                </button>
                            </div>
                        </div>
                        <div class="card-body p-0">
                            <div id="map" style="height: 400px;" class="w-100"></div>
                        </div>
                    </div>
                </div>

                <!-- Detail Section - Bên phải -->
                <div class="col-md-6">
                    <div class="card border-0 shadow-sm h-100">
                        <div class="card-header bg-white border-bottom-0">
                            <h5 class="mb-0">
                                <i class="fas fa-info-circle me-2 text-success"></i>Thông tin chi tiết
                            </h5>
                        </div>
                        <div class="card-body">
                            <!-- Bin Information -->
                            <div class="row g-3">
                                <div class="col-12">
                                    <div class="bg-light rounded p-3">
                                        <div class="row">
                                            <div class="col-sm-4">
                                                <strong class="text-muted">Mã thùng:</strong>
                                            </div>
                                            <div class="col-sm-8">
                                                <span class="badge bg-primary fs-6">${bin.binCode}</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-12">
                                    <div class="bg-light rounded p-3">
                                        <div class="row">
                                            <div class="col-sm-4">
                                                <strong class="text-muted">Địa chỉ:</strong>
                                            </div>
                                            <div class="col-sm-8">
                                                <i class="fas fa-map-marker-alt text-danger me-1"></i>
                                                ${bin.street}, ${bin.ward.wardName}, ${bin.city}
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-12">
                                    <div class="bg-light rounded p-3">
                                        <div class="row">
                                            <div class="col-sm-4">
                                                <strong class="text-muted">Dung tích:</strong>
                                            </div>
                                            <div class="col-sm-8">
                                                <i class="fas fa-tachometer-alt text-info me-1"></i>
                                                ${bin.capacity}L
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-12">
                                    <div class="bg-light rounded p-3">
                                        <div class="row align-items-center">
                                            <div class="col-sm-4">
                                                <strong class="text-muted">Mức đầy:</strong>
                                            </div>
                                            <div class="col-sm-8">
                                                <div class="d-flex align-items-center">
                                                    <div class="progress flex-grow-1 me-3" style="height: 12px;">
                                                        <div class="progress-bar
                                                            <c:choose>
                                                                <c:when test="${bin.currentFill >= 80}">bg-danger</c:when>
                                                                <c:when test="${bin.currentFill >= 40}">bg-warning</c:when>
                                                                <c:otherwise>bg-success</c:otherwise>
                                                            </c:choose>"
                                                             role="progressbar"
                                                             style="width: ${bin.currentFill}%"
                                                             aria-valuenow="${bin.currentFill}"
                                                             aria-valuemin="0"
                                                             aria-valuemax="100">
                                                        </div>
                                                    </div>
                                                    <strong class="
                                                        <c:choose>
                                                            <c:when test="${bin.currentFill >= 80}">text-danger</c:when>
                                                            <c:when test="${bin.currentFill >= 40}">text-warning</c:when>
                                                            <c:otherwise>text-success</c:otherwise>
                                                        </c:choose>">
                                                        ${bin.currentFill}%
                                                    </strong>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-12">
                                    <div class="bg-light rounded p-3">
                                        <div class="row">
                                            <div class="col-sm-4">
                                                <strong class="text-muted">Trạng thái:</strong>
                                            </div>
                                            <div class="col-sm-8">
                                                <c:choose>
                                                    <c:when test="${bin.status == 1}">
                                                        <span class="badge bg-success fs-6">
                                                            <i class="fas fa-circle me-1"></i> Online
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary fs-6">
                                                            <i class="fas fa-circle me-1"></i> Offline
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-12">
                                    <div class="bg-light rounded p-3">
                                        <div class="row">
                                            <div class="col-sm-4">
                                                <strong class="text-muted">Cập nhật cuối:</strong>
                                            </div>
                                            <div class="col-sm-8">
                                                <i class="fas fa-clock text-secondary me-1"></i>
                                                ${bin.lastUpdated}
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Warning Message if task exists -->
                            <c:if test="${hasOpenTask}">
                                <div class="alert alert-warning mt-3" role="alert">
                                    <i class="fas fa-exclamation-triangle me-2"></i>
                                    <strong>Đang có nhiệm vụ mở</strong>
                                    <p class="mb-0 mt-2">
                                        Thùng rác này đã có nhiệm vụ đang được xử lý.
                                        Vui lòng hoàn thành nhiệm vụ hiện tại trước khi giao mới.
                                    </p>
                                </div>
                            </c:if>

                            <!-- Action Buttons -->
                            <div class="d-flex gap-2 mt-4">
                                <a href="${pageContext.request.contextPath}/manage" class="btn btn-outline-secondary flex-fill">
                                    <i class="fas fa-arrow-left me-1"></i> Quay lại
                                </a>
                                <c:if test="${not hasOpenTask}">
                                    <a href="${pageContext.request.contextPath}/tasks/task-management" class="btn btn-primary flex-fill">
                                        <i class="fas fa-tasks me-1"></i> Giao nhiệm vụ
                                    </a>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
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

    function getBinIcon(level, status) {
        if (status == 2) {
            return "data:image/svg+xml;charset=UTF-8," + encodeURIComponent(`
                <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" fill="gray" viewBox="0 0 24 24">
                    <path d="M3 6h18v2H3zm2 2h14v14H5z"/>
                    <rect x="5" y="16" width="14" height="4" fill="rgba(0,0,0,0.3)"/>
                </svg>
            `);
        }
        if (level >= 80) {
            return "data:image/svg+xml;charset=UTF-8," + encodeURIComponent(`
                <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" fill="red" viewBox="0 0 24 24">
                    <path d="M3 6h18v2H3zm2 2h14v14H5z"/>
                    <rect x="5" y="8" width="14" height="12" fill="rgba(0,0,0,0.3)"/>
                </svg>
            `);
        } else if (level >= 40) {
            return "data:image/svg+xml;charset=UTF-8," + encodeURIComponent(`
                <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" fill="orange" viewBox="0 0 24 24">
                    <path d="M3 6h18v2H3zm2 2h14v14H5z"/>
                    <rect x="5" y="12" width="14" height="8" fill="rgba(0,0,0,0.3)"/>
                </svg>
            `);
        } else {
            return "data:image/svg+xml;charset=UTF-8," + encodeURIComponent(`
                <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" fill="green" viewBox="0 0 24 24">
                    <path d="M3 6h18v2H3zm2 2h14v14H5z"/>
                    <rect x="5" y="16" width="14" height="4" fill="rgba(0,0,0,0.3)"/>
                </svg>
            `);
        }
    }

    var map;
    try {
        map = new vietmapgl.Map({
            container: "map",
            style: "https://maps.vietmap.vn/maps/styles/tm/style.json?apikey=ecdbd35460b2d399e18592e6264186757aaaddd8755b774c",
            center: [binData.lng, binData.lat],
            zoom: 15
        });

        // Add navigation control
        map.addControl(new vietmapgl.NavigationControl());

        var el = document.createElement("img");
        el.src = getBinIcon(binData.fullness, binData.status);
        el.style.width = "40px";
        el.style.height = "40px";
        el.style.cursor = "pointer";

        var popup = new vietmapgl.Popup({ offset: 25 }).setHTML(
            "<div style='padding: 12px; font-family: Arial, sans-serif;'>" +
            "<h6 style='margin: 0 0 8px 0; color: #333;'><strong>Mã:</strong> " + binData.code + "</h6>" +
            "<p style='margin: 4px 0; color: #666;'><strong>Địa chỉ:</strong> " + binData.address + "</p>" +
            "<p style='margin: 4px 0; color: #666;'><strong>Đầy:</strong> " + binData.fullness + "%</p>" +
            "<p style='margin: 4px 0; color: #666;'><strong>Trạng thái:</strong> " +
            (binData.status == 1 ? "<span style='color: green;'>Online</span>" : "<span style='color: red;'>Offline</span>") + "</p>" +
            "<p style='margin: 4px 0 0 0; color: #666; font-size: 12px;'><strong>Cập nhật:</strong> " + binData.updated + "</p>" +
            "</div>"
        );

        var marker = new vietmapgl.Marker({ element: el })
            .setLngLat([binData.lng, binData.lat])
            .setPopup(popup)
            .addTo(map);

        // Auto show popup on load
        setTimeout(() => {
            marker.togglePopup();
        }, 1000);

        // Reset map view function
        window.resetMapView = function() {
            map.flyTo({
                center: [binData.lng, binData.lat],
                zoom: 15
            });
        };

    } catch (err) {
        console.error("VietMap init error:", err);
        document.getElementById("map").innerHTML = "<div class='d-flex align-items-center justify-content-center h-100 text-muted'><i class='fas fa-exclamation-triangle me-2'></i>Không thể tải bản đồ</div>";
    }
</script>

</body>
</html>