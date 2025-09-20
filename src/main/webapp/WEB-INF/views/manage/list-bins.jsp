<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>Trash Bin App - Quản lý thùng rác</title>
    <link href="https://unpkg.com/@vietmap/vietmap-gl-js@6.0.0/dist/vietmap-gl.css" rel="stylesheet" />
    <script src="https://unpkg.com/@vietmap/vietmap-gl-js@6.0.0/dist/vietmap-gl.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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

        /* Filter Section */
        .filter-section {
            background: #fff;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 24px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            display: flex;
            flex-wrap: wrap;
            gap: 16px;
            align-items: center;
        }
        .filter-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }
        .filter-group label {
            font-weight: 600;
            font-size: 14px;
            color: #1f2937;
        }
        .filter-group select {
            padding: 10px 12px;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            background: #fff;
            font-size: 14px;
            color: #1f2937;
            outline: none;
            transition: all 0.2s;
            min-width: 180px;
        }
        .filter-group select:focus {
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.2);
        }

        /* Table Section */
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

        /* Nút hành động */
        .action-buttons {
            display: flex;
            gap: 8px;
        }
        .btn-edit, .btn-delete {
            padding: 6px 12px;
            border-radius: 6px;
            border: none;
            cursor: pointer;
            font-size: 13px;
            display: inline-flex;
            align-items: center;
            gap: 4px;
            transition: all 0.2s;
        }
        .btn-edit {
            background: #3b82f6;
            color: white;
        }
        .btn-edit:hover {
            background: #2563eb;
        }
        .btn-delete {
            background: #ef4444;
            color: white;
        }
        .btn-delete:hover {
            background: #dc2626;
        }

        /* Responsive */
        @media (max-width: 1024px) {
            .sidebar {
                width: 200px;
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
            .action-buttons {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
<!-- Sidebar -->
<div class="sidebar">
    <div class="sidebar-header">
        <h2>Trash Bin App</h2>
    </div>
    <ul class="menu">
        <li onclick="location.href='${pageContext.request.contextPath}/manage'">📊 Dashboard</li>
        <li onclick="location.href='${pageContext.request.contextPath}/tasks/task-management'">📋 Giao nhiệm vụ</li>
        <li class="active">🗑️ Danh sách thùng rác</li>
        <li>⚠️ Báo cáo</li>
        <li>👤 Người dùng</li>
        <li>⚙️ Cài đặt</li>
    </ul>
    <div class="sidebar-footer">
        <div class="user-info">
            <img src="https://i.pravatar.cc/150?img=3" alt="User">
            <div class="user-details">
                <div class="name">Admin User</div>
                <div class="role">Quản trị viên</div>
            </div>
        </div>
    </div>
</div>

<!-- Main Content -->
<div class="main-content">
    <div class="header">
        <h1>Quản lý thùng rác</h1>
        <div class="header-actions">
            <button class="notification-btn">
                🔔
                <span class="notification-badge">3</span>
            </button>
        </div>
    </div>

    <div class="content">
        <!-- Filter Section -->
        <div class="filter-section">
            <div class="filter-group">
                <label for="cityFilter">Khu vực:</label>
                <select id="cityFilter">
                    <option value="">-- Tất cả --</option>
                    <c:forEach var="city" items="${cities}">
                        <option value="${city}">${city}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="filter-group">
                <label for="wardFilter">Phường/Xã:</label>
                <select id="wardFilter">
                    <option value="">-- Tất cả --</option>
                    <c:forEach var="ward" items="${wards}">
                        <option value="${ward}">${ward}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="filter-group">
                <label for="statusFilter">Hoạt động:</label>
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
                <label for="fillFilter">Mức đầy:</label>
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
                <button class="export-btn">
                    <i class="fas fa-file-export"></i> Xuất báo cáo
                </button>
            </div>
            <table id="binTable">
                <thead>
                <tr>
                    <th>Mã</th>
                    <th>Địa chỉ</th>
                    <th>Đầy (%)</th>
                    <th>Mức chứa</th>
                    <th>Hoạt động</th>
                    <th>Hành động</th>
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
                        <td>
                            <div style="display: flex; align-items: center; gap: 8px;">
                                <div style="width: 60px; height: 8px; background: #e2e8f0; border-radius: 4px; overflow: hidden;">
                                    <div style="height: 100%; width: ${bin.currentFill}%;
                                            background: ${bin.currentFill >= 80 ? '#ef4444' : (bin.currentFill >= 40 ? '#f97316' : '#22c55e')};">
                                    </div>
                                </div>
                                <span>${bin.currentFill}%</span>
                            </div>
                        </td>
                        <td>${bin.capacity}L</td>
                        <td>
                            <c:choose>
                                <c:when test="${bin.status == 1}">
                                    <span class="status-online"><i class="fas fa-circle"></i> Online</span>
                                </c:when>
                                <c:when test="${bin.status == 2}">
                                    <span class="status-offline"><i class="fas fa-circle"></i> Offline</span>
                                </c:when>
                            </c:choose>
                        </td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-edit" onclick="editBin(${bin.binID})">
                                    <i class="fas fa-edit"></i> Sửa
                                </button>
                                <button class="btn-delete" onclick="deleteBin(${bin.binID})">
                                    <i class="fas fa-trash"></i> Xóa
                                </button>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
    // Hàm xử lý sửa thùng rác
    function editBin(binId) {
        if (confirm('Bạn có chắc muốn chỉnh sửa thùng rác này?')) {
            window.location.href = '${pageContext.request.contextPath}/manage/bin/edit/' + binId;
        }
    }

    // Hàm xử lý xóa thùng rác
    function deleteBin(binId) {
        if (confirm('Bạn có chắc muốn xóa thùng rác này? Hành động này không thể hoàn tác.')) {
            // Gửi yêu cầu xóa đến server
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
    }

    // Thêm event listeners cho các bộ lọc
    document.getElementById("cityFilter").addEventListener("change", applyFilter);
    document.getElementById("wardFilter").addEventListener("change", applyFilter);
    document.getElementById("statusFilter").addEventListener("change", applyFilter);
    document.getElementById("fillFilter").addEventListener("change", applyFilter);
</script>
</body>
</html>