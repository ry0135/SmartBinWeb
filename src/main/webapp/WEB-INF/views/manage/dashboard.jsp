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
            <div class="d-flex align-items-center position-relative">

                <!-- Nút chuông -->
                <button id="btnNotification" class="btn btn-outline-secondary position-relative">
                    🔔
                    <c:if test="${count > 0}">
            <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                    ${count}
            </span>
                    </c:if>
                </button>

                <!-- DROPDOWN THÔNG BÁO -->
                <div id="notificationDropdown"
                     class="position-absolute bg-white shadow rounded p-3"
                     style="top: 50px; right: 0; width: 360px; display: none; z-index: 999;">

                    <!-- Tabs -->
                    <div class="d-flex border-bottom mb-2">
                        <button id="tab-all" class="btn btn-link px-2 me-2 active" onclick="showTab('all')">Tất cả</button>
                        <button id="tab-unread" class="btn btn-link px-2" onclick="showTab('unread')">Chưa đọc</button>
                        <button id="tab-read" class="btn btn-link px-2" onclick="showTab('read')">Đã đọc</button>
                    </div>

                    <!-- Danh sách thông báo -->
                    <div id="notificationList">
                        <c:forEach var="noti" items="${notifications}">
                            <div class="d-flex align-items-start py-2 border-bottom noti-item"
                                 data-read="${noti.read}">

                                <!-- Icon loại -->
                                <div class="me-2">
                                    <c:choose>
                                        <c:when test="${noti.type == 'INFO'}">
                                            <span class="badge bg-primary">i</span>
                                        </c:when>
                                        <c:when test="${noti.type == 'WARNING'}">
                                            <span class="badge bg-warning text-dark">!</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary">*</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <!-- Nội dung -->
                                <div class="flex-grow-1">
                                    <div class="fw-semibold">${noti.title}</div>
                                    <div class="text-muted small">${noti.message}</div>
                                    <div class="text-muted small">${noti.createdAt}</div>
                                </div>

                                <!-- Chấm xanh -->
                                <c:if test="${noti.read == false}">
                                    <span class="ms-2" style="color:#0d6efd;">●</span>
                                </c:if>
                            </div>
                        </c:forEach>
                    </div>
                </div>
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
                <div class="col-md-3">
                    <div class="card border-0 shadow-sm h-100">
                        <div class="card-header bg-white border-bottom-0 py-2">
                            <h6 class="mb-0">
                                <i class="fas fa-filter me-2"></i>Bộ lọc
                            </h6>
                        </div>
                        <div class="card-body py-3">
                            <div class="mb-2">
                                <label for="cityFilter" class="form-label fw-semibold small mb-1">
                                    <i class="fas fa-city me-1 text-primary"></i>Khu vực:
                                </label>
                                <select class="form-select form-select-sm" id="cityFilter">
                                    <option value="">-- Tất cả --</option>
                                    <c:forEach var="city" items="${cities}">
                                        <option value="${city}">${city}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="mb-2">
                                <label for="wardFilter" class="form-label fw-semibold small mb-1">
                                    <i class="fas fa-map-marker-alt me-1 text-success"></i>Phường/Xã:
                                </label>
                                <select class="form-select form-select-sm" id="wardFilter">
                                    <option value="">-- Tất cả --</option>
                                    <c:forEach var="ward" items="${wards}">
                                        <option value="${ward}">${ward}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="mb-2">
                                <label for="fillFilter" class="form-label fw-semibold small mb-1">
                                    <i class="fas fa-chart-bar me-1 text-warning"></i>Mức đầy:
                                </label>
                                <select class="form-select form-select-sm" id="fillFilter">
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
                                <label class="form-label fw-semibold small mb-1">Hoạt động:</label>
                                <select class="form-select form-select-sm" id="statusFilter">
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
                            <div class="alert alert-info py-2 mb-2">
                                <small>
                                    <strong id="resultCount">0</strong> thùng rác
                                </small>
                            </div>

                            <!-- Quick Actions -->
                            <div class="d-grid gap-2">

                                <button class="btn btn-outline-primary btn-sm" onclick="focusOnResults()">
                                    📍 Xem bản đồ
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Map Section - Right Side -->
                <div class="col-md-9">
                    <div class="card border-0 shadow-sm h-100">
                        <div class="card-header bg-white border-bottom d-flex justify-content-between align-items-center py-2">
                            <h6 class="mb-0">🗺️ Bản đồ thùng rác</h6>
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
                            <div id="map" style="height: 400px;" class="rounded-bottom"></div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Table Section with Pagination -->
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-white border-bottom d-flex justify-content-between align-items-center py-2">
                    <h6 class="mb-0">📋 Danh sách thùng rác</h6>
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
                        <div class="text-muted small">
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

<!-- ====================== LIBRARIES ====================== -->
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>

<script>
    // ====================== REALTIME SOCKET ======================
    var socket = new SockJS('https://smartbin-vn.duckdns.org/ws-bin-sockjs');
    var stompClient = Stomp.over(socket);

    stompClient.connect({}, function (frame) {
        console.log("✅ WebSocket connected: " + frame);

        stompClient.subscribe('/topic/binUpdates', function (message) {
            var bin = JSON.parse(message.body);
            console.log("📡 Cập nhật mới:", bin);
            updateBinRow(bin);
            updateBinMarker(bin);
        });

        stompClient.subscribe('/topic/binRemoved', function (message) {
            var bin = JSON.parse(message.body);
            console.log("🗑 Bin bị xóa:", bin.binID);
            removeBinRow(bin.binID);
            removeBinMarker(bin.binID);
        });
    });


    // ======= Cập nhật trong bảng =======
    function updateBinRow(bin) {
        const rows = document.querySelectorAll("#binTableBody tr");
        let found = false;

        rows.forEach(row => {
            const code = row.querySelector("td:first-child").textContent.trim();
            if (code === bin.binCode) {
                found = true;
                const fillCell = row.querySelector("td:nth-child(3) span");
                const statusCell = row.querySelector("td:nth-child(5) span");

                fillCell.textContent = bin.currentFill + "%";
                fillCell.className = "badge " + (
                    bin.currentFill >= 80 ? "bg-danger" :
                        bin.currentFill >= 40 ? "bg-warning" : "bg-success"
                );

                statusCell.textContent = (bin.status == 1 ? "Online" : "Offline");
                statusCell.className = "badge " + (bin.status == 1 ? "bg-success" : "bg-secondary");

                row.setAttribute("data-fill", bin.currentFill);
                row.setAttribute("data-status", bin.status);
            }
        });

        if (!found) {
            const tbody = document.getElementById("binTableBody");
            const newRow = document.createElement("tr");

            newRow.setAttribute("data-city", bin.ward && bin.ward.province ? bin.ward.province.provinceName : '');
            newRow.setAttribute("data-ward", bin.ward ? bin.ward.wardName : '');
            newRow.setAttribute("data-status", bin.status);
            newRow.setAttribute("data-fill", bin.currentFill);

            newRow.innerHTML = `
            <td class="fw-medium">\${bin.binCode}</td>
            <td>\${bin.street}\${bin.ward ? ', ' + bin.ward.wardName : ''}\${bin.ward && bin.ward.province ? ', ' + bin.ward.province.provinceName : ''}</td>
            <td><span class="badge \${bin.currentFill >= 80 ? 'bg-danger' : bin.currentFill >= 40 ? 'bg-warning' : 'bg-success'}">\${bin.currentFill}%</span></td>
            <td>\${bin.capacity || 0}</td>
            <td><span class="badge \${bin.status == 1 ? 'bg-success' : 'bg-secondary'}">\${bin.status == 1 ? 'Online' : 'Offline'}</span></td>
            <td><a href="${pageContext.request.contextPath}/manage/bin/\${bin.binID}" class="btn btn-primary btn-sm">Chi tiết</a></td>
        `;
            tbody.prepend(newRow);
            allRows.unshift(newRow);
            displayPage(currentPage);
        }
    }

    // ======= Cập nhật marker bản đồ =======
    // ======= Cập nhật marker bản đồ =======
    function updateBinMarker(bin) {
        if (!markers || markers.length === 0) return;

        let marker = markers.find(m => m.bin.code === bin.binCode);
        if (marker) {
            marker.bin.fullness = bin.currentFill;
            marker.bin.status = bin.status;
            marker.bin.lat = bin.latitude;
            marker.bin.lng = bin.longitude;
            marker.bin.address = bin.street;
            // 🎯 THÊM CẬP NHẬT CITY VÀ WARD
            marker.bin.city = bin.ward && bin.ward.province ? bin.ward.province.provinceName : '';
            marker.bin.ward = bin.ward ? bin.ward.wardName : '';

            marker.setLngLat([bin.longitude, bin.latitude]);
            marker.getElement().src = getBinIcon(bin.currentFill, bin.status);

            // 🎯 QUAN TRỌNG: Cập nhật nội dung popup
            var popupHtml =
                "<b>Mã:</b> " + bin.binCode +
                "<br><b>Địa chỉ:</b> " + bin.street +
                "<br><b>Đầy:</b> " + bin.currentFill + "%" +
                "<br><b>Trạng thái:</b> " + (bin.status == 1 ? "Online" : "Offline") +
                "<br><b>Cập nhật:</b> " + new Date().toLocaleString() +
                "<br><div id='predict-" + bin.binID + "' class='mt-2 text-muted'>⚡ Bấm vào để dự đoán...</div>";

            marker.setPopup(new vietmapgl.Popup({ offset: 25 }).setHTML(popupHtml));

        } else {
            // Code thêm marker mới (giữ nguyên)
            var el = document.createElement("img");
            el.src = getBinIcon(bin.currentFill, bin.status);
            el.style.width = "32px";
            el.style.height = "32px";

            var popupHtml =
                "<b>Mã:</b> " + bin.binCode +
                "<br><b>Địa chỉ:</b> " + bin.street +
                "<br><b>Đầy:</b> " + bin.currentFill + "%" +
                "<br><b>Trạng thái:</b> " + (bin.status == 1 ? "Online" : "Offline") +
                "<br><b>Cập nhật:</b> " + new Date().toLocaleString() +
                "<br><div id='predict-" + bin.binID + "' class='mt-2 text-muted'>⚡ Bấm vào để dự đoán...</div>";

            var popup = new vietmapgl.Popup({ offset: 25 }).setHTML(popupHtml);

            var newMarker = new vietmapgl.Marker({ element: el })
                .setLngLat([bin.longitude, bin.latitude])
                .setPopup(popup)
                .addTo(map);

            newMarker.bin = {
                id: bin.binID,
                code: bin.binCode,
                binID: bin.binID,
                lat: bin.latitude,
                lng: bin.longitude,
                fullness: bin.currentFill,
                status: bin.status,
                city: bin.ward && bin.ward.province ? bin.ward.province.provinceName : '',
                ward: bin.ward ? bin.ward.wardName : ''
            };
            markers.push(newMarker);
        }
    }

    // ======= Xóa bin =======
    function removeBinRow(binID) {
        const rows = document.querySelectorAll("#binTableBody tr");
        rows.forEach(row => {
            const link = row.querySelector("a");
            if (link && link.href.includes("/manage/bin/" + binID)) {
                const index = allRows.indexOf(row);
                if (index > -1) allRows.splice(index, 1);
                row.remove();
                displayPage(currentPage);
            }
        });
    }

    function removeBinMarker(binID) {
        if (!markers || markers.length === 0) return;
        const index = markers.findIndex(m => m.bin.binID === binID);
        if (index !== -1) {
            markers[index].remove();
            markers.splice(index, 1);
        }
    }

    // ====================== BẢN ĐỒ ======================
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

    // 🌍 Khởi tạo bản đồ VietMap
    var map = new vietmapgl.Map({
        container: "map",
        style: "https://maps.vietmap.vn/maps/styles/tm/style.json?apikey=ecdbd35460b2d399e18592e6264186757aaaddd8755b774c",
        center: [108.2068, 16.0471],
        zoom: 12
    });

    map.addControl(new vietmapgl.NavigationControl());

    // 📦 Dữ liệu thùng rác render từ backend
    var bins = [
        <c:forEach var="bin" items="${bins}" varStatus="loop">
        {
            id: '${bin.binID}',
            code: '${bin.binCode}',
            lat: ${bin.latitude},
            lng: ${bin.longitude},
            fullness: ${bin.currentFill != null ? bin.currentFill : 0},
            address: '${bin.street}, ${bin.ward.wardName}, ${bin.ward.province.provinceName}',
            updated: '${bin.lastUpdated}',
            status: ${bin.status},
            // 🎯 THÊM 2 DÒNG NÀY
            city: '${bin.ward.province.provinceName}',
            ward: '${bin.ward.wardName}'
        }<c:if test="${!loop.last}">,</c:if>
        </c:forEach>
    ];

    var markers = [];

    // 🧠 Khi bản đồ load xong → thêm markers
    map.on('load', function() {
        bins.forEach(function(bin) {
            const el = document.createElement("img");
            el.src = getBinIcon(bin.fullness, bin.status);
            el.style.width = "32px";
            el.style.height = "32px";

            // 🧱 Popup HTML đơn giản hơn (cộng chuỗi)
            var popupHtml =
                "<b>Mã:</b> " + bin.code +
                "<br><b>Địa chỉ:</b> " + bin.address +
                "<br><b>Đầy:</b> " + bin.fullness + "%" +
                "<br><b>Trạng thái:</b> " + (bin.status == 1 ? "Online" : "Offline") +
                "<br><b>Cập nhật:</b> " + new Date(bin.updated).toLocaleString() +
                "<br><div id='predict-" + bin.id + "' class='mt-2 text-muted'>⚡ Bấm vào để dự đoán...</div>";

            var popup = new vietmapgl.Popup({ offset: 25 }).setHTML(popupHtml);

            var marker = new vietmapgl.Marker({ element: el })
                .setLngLat([bin.lng, bin.lat])
                .setPopup(popup)
                .addTo(map);

            marker.bin = bin;
            markers.push(marker);

            // 💡 Khi người dùng click vào marker → popup mở → gọi AI Predict
            marker.getElement().addEventListener("click", function() {
                setTimeout(() => {
                    // Đảm bảo phần tử #predict-x đã render trong popup
                    const box = document.getElementById("predict-" + bin.id);
                    if (!box) return;
                    box.innerHTML = "⏳ Đang dự đoán...";
                    if (bin.status === 1 && bin.fullness < 100) {
                        autoPredictBin(bin, marker, el);
                    } else {
                        box.innerHTML = "⚠️ Offline hoặc đã đầy";
                    }
                }, 300); // chờ popup render
            });
        });
    });


    // 🔮 Hàm gọi AI Predict
    async function autoPredictBin(bin, marker, iconElement) {
        const box = document.getElementById("predict-" + bin.id);
        if (!box) return;

        try {
            const res = await fetch("<%=request.getContextPath()%>/api/ai/predict?binId=" + bin.id + "&currentFill=" + bin.fullness);
            const data = await res.json();
            console.log("📡 AI response:", data);

            if (data.status === "success") {
                var msg = "🧠 <b>Đầy vào:</b> " + data.predicted_full_time +
                    "<br>⏰ Còn ~<b>" + data.hours_left.toFixed(1) + "</b> giờ";
                var color = "text-success";
                var danger = false;

                if (data.hours_left < 3) {
                    msg = "⚠️ <b>Sắp đầy trong " + data.hours_left.toFixed(1) + "h!</b><br>🧹 Cần thu gom sớm";
                    color = "text-danger";
                    danger = true;
                }

                box.className = color;
                box.innerHTML = msg;

                // 💡 Nhấp nháy nếu sắp đầy
                if (danger) {
                    let blink = true;
                    setInterval(() => {
                        iconElement.style.opacity = blink ? "0.5" : "1";
                        blink = !blink;
                    }, 700);
                }

            } else {
                box.className = "text-warning";
                box.innerHTML = "⚠️ " + (data.message || "Không thể dự đoán");
            }
        } catch (e) {
            console.error("❌ AI lỗi:", e);
            box.className = "text-danger";
            box.innerHTML = "❌ Không thể kết nối tới AI server";
        }
    }
    // ==================== PHÂN TRANG ====================
    var currentPage = 1;
    var itemsPerPage = 25;
    var allRows = [];

    document.addEventListener('DOMContentLoaded', function() {
        initializePagination();
    });

    function initializePagination() {
        allRows = Array.from(document.querySelectorAll("#binTable tbody tr"));
        displayPage(1);

        document.getElementById("cityFilter").addEventListener("change", function() {
            applyFilter();
            displayPage(1);
        });

        document.getElementById("wardFilter").addEventListener("change", function() {
            applyFilter();
            displayPage(1);
        });

        document.getElementById("statusFilter").addEventListener("change", function() {
            applyFilter();
            displayPage(1);
        });

        document.getElementById("fillFilter").addEventListener("change", function() {
            applyFilter();
            displayPage(1);
        });
    }

    function applyFilter() {
        var city = document.getElementById("cityFilter").value;
        var ward = document.getElementById("wardFilter").value;
        var status = document.getElementById("statusFilter").value;
        var fill = document.getElementById("fillFilter").value;

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
                row.classList.remove('filtered-out');
            } else {
                row.classList.add('filtered-out');
            }
        });

        if (typeof markers !== 'undefined') {
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

        updateResultCount();
    }

    function displayPage(page) {
        currentPage = page;
        var visibleRows = allRows.filter(row => !row.classList.contains('filtered-out'));
        var totalItems = visibleRows.length;

        var startIndex = (page - 1) * itemsPerPage;
        var endIndex = Math.min(startIndex + itemsPerPage, totalItems);

        allRows.forEach(row => row.style.display = 'none');

        for (var i = startIndex; i < endIndex; i++) {
            visibleRows[i].style.display = '';
        }

        updatePaginationInfo(startIndex + 1, endIndex, totalItems);
        createPaginationButtons(totalItems);
    }

    function updatePaginationInfo(from, to, total) {
        document.getElementById("showingFrom").textContent = total > 0 ? from : 0;
        document.getElementById("showingTo").textContent = to;
        document.getElementById("totalItems").textContent = total;
    }

    function createPaginationButtons(totalItems) {
        var totalPages = Math.ceil(totalItems / itemsPerPage);
        var paginationContainer = document.getElementById("pagination");
        paginationContainer.innerHTML = '';

        if (totalPages <= 1) return;

        var prevLi = document.createElement('li');
        prevLi.className = 'page-item' + (currentPage === 1 ? ' disabled' : '');
        prevLi.innerHTML = '<a class="page-link" href="#" onclick="goToPage(' + (currentPage - 1) + '); return false;">«</a>';
        paginationContainer.appendChild(prevLi);

        var startPage = Math.max(1, currentPage - 2);
        var endPage = Math.min(totalPages, currentPage + 2);

        if (startPage > 1) {
            var firstLi = document.createElement('li');
            firstLi.className = 'page-item';
            firstLi.innerHTML = '<a class="page-link" href="#" onclick="goToPage(1); return false;">1</a>';
            paginationContainer.appendChild(firstLi);

            if (startPage > 2) {
                var dotsLi = document.createElement('li');
                dotsLi.className = 'page-item disabled';
                dotsLi.innerHTML = '<a class="page-link" href="#">...</a>';
                paginationContainer.appendChild(dotsLi);
            }
        }

        for (var i = startPage; i <= endPage; i++) {
            var pageLi = document.createElement('li');
            pageLi.className = 'page-item' + (i === currentPage ? ' active' : '');
            pageLi.innerHTML = '<a class="page-link" href="#" onclick="goToPage(' + i + '); return false;">' + i + '</a>';
            paginationContainer.appendChild(pageLi);
        }

        if (endPage < totalPages) {
            if (endPage < totalPages - 1) {
                var dotsLi = document.createElement('li');
                dotsLi.className = 'page-item disabled';
                dotsLi.innerHTML = '<a class="page-link" href="#">...</a>';
                paginationContainer.appendChild(dotsLi);
            }

            var lastLi = document.createElement('li');
            lastLi.className = 'page-item';
            lastLi.innerHTML = '<a class="page-link" href="#" onclick="goToPage(' + totalPages + '); return false;">' + totalPages + '</a>';
            paginationContainer.appendChild(lastLi);
        }

        var nextLi = document.createElement('li');
        nextLi.className = 'page-item' + (currentPage === totalPages ? ' disabled' : '');
        nextLi.innerHTML = '<a class="page-link" href="#" onclick="goToPage(' + (currentPage + 1) + '); return false;">»</a>';
        paginationContainer.appendChild(nextLi);
    }

    function goToPage(page) {
        var visibleRows = allRows.filter(row => !row.classList.contains('filtered-out'));
        var totalPages = Math.ceil(visibleRows.length / itemsPerPage);

        if (page < 1 || page > totalPages) return;

        displayPage(page);
        document.getElementById('binTable').scrollIntoView({ behavior: 'smooth', block: 'start' });
    }

    function updateResultCount() {
        var visibleRows = allRows.filter(row => !row.classList.contains('filtered-out'));
        document.getElementById("resultCount").textContent = visibleRows.length;
    }

    // ==================== TIỆN ÍCH ====================
    function exportReport() {
        alert("Chức năng xuất báo cáo đang được phát triển!");
    }

    function focusOnResults() {
        if (typeof map !== 'undefined') {
            var visibleMarkers = markers.filter(m => m._map);

            if (visibleMarkers.length > 0) {
                var bounds = new vietmapgl.LngLatBounds();
                visibleMarkers.forEach(m => {
                    bounds.extend([m.bin.lng, m.bin.lat]);
                });
                map.fitBounds(bounds, { padding: 50 });
            }
        }
    }

    function resetMapView() {
        if (typeof map !== 'undefined') {
            map.flyTo({
                center: [108.2068, 16.0471],
                zoom: 12
            });
        }
    }
</script>

<script>
    document.getElementById("btnNotification").addEventListener("click", function () {
        const dropdown = document.getElementById("notificationDropdown");
        dropdown.style.display = dropdown.style.display === "none" ? "block" : "none";
    });

    // Ẩn dropdown khi click ra ngoài
    document.addEventListener("click", function(e) {
        const btn = document.getElementById("btnNotification");
        const dropdown = document.getElementById("notificationDropdown");

        if (!btn.contains(e.target) && !dropdown.contains(e.target)) {
            dropdown.style.display = "none";
        }
    });

</script>
<script>
    window.showTab = function(tab) {
        const items = document.querySelectorAll(".noti-item");
        items.forEach(item => {
            const readAttr = item.getAttribute("data-read");
            const isRead = readAttr === "true"; // chuyển string sang boolean
            if (tab === 'all') {
                item.style.display = 'flex';
            } else if (tab === 'unread') {
                item.style.display = !isRead ? 'flex' : 'none';
            }
        });

        // Cập nhật active button
        const buttons = document.querySelectorAll("#notificationDropdown .btn-link");
        buttons.forEach(b => b.classList.remove("active"));
        if(tab === 'all') buttons[0].classList.add("active");
        else buttons[1].classList.add("active");
    }
</script>
<script>
    function showTab(tab) {
        console.log("TAB CLICKED:", tab);

        const items = document.querySelectorAll(".noti-item");

        // Xóa inline CSS trước (để tránh lỗi hiển thị)
        items.forEach(function(item) {
            console.log("BEFORE:", item.style.display);  // ← Log này bạn đang cần
            item.style.display = "";
        });

        // Lọc theo trạng thái
        items.forEach(function(item) {
            let readValue = (item.getAttribute("data-read") || "")
                .trim().toLowerCase();

            const isRead = (readValue === "true" || readValue === "1");

            if (tab === "all") {
                item.style.display = "flex";
            } else if (tab === "unread") {
                item.style.display = isRead ? "none" : "flex";
            } else if (tab === "read") {
                item.style.display = isRead ? "flex" : "none";
            }

            console.log("AFTER:", tab, "| read =", readValue, "| isRead =", isRead, "| final display =", item.style.display);
        });

        // Active nút tab
        document.querySelectorAll("#notificationDropdown .btn-link")
            .forEach(btn => btn.classList.remove("active"));

        const activeBtn = document.querySelector("#tab-" + tab);
        if (activeBtn) activeBtn.classList.add("active");
    }
</script>
</body>
</html>