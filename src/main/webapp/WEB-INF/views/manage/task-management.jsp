<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8" />
  <title>Trash Bin App - Task Assignment</title>
  <link href="https://unpkg.com/@vietmap/vietmap-gl-js@6.0.0/dist/vietmap-gl.css" rel="stylesheet" />
  <script src="https://unpkg.com/@vietmap/vietmap-gl-js@6.0.0/dist/vietmap-gl.js"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">  <style>
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

  /* Container chính - ĐÃ SỬA */
  .container {
    display: flex;
    min-height: 100vh;
    position: relative;
  }

  /* Sidebar - ĐÃ SỬA */
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
    z-index: 1000;
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

  /* Main content - ĐÃ SỬA */
  .main-content {
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
  .user-info {
    display: flex;
    align-items: center;
    gap: 12px;
  }

  .user-info img {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    object-fit: cover;
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
    font-size: 13px;
  }

  /* Content Area */
  .content {
    padding: 24px;
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
    padding: 24px;
    box-shadow: 0 1px 3px rgba(0,0,0,0.1);
    overflow: hidden;
  }

  .table-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
  }

  .table-header h3 {
    font-size: 20px;
    color: #1f2937;
    font-weight: 700;
  }

  .export-btn {
    background: #22c55e;
    color: white;
    border: none;
    padding: 10px 16px;
    border-radius: 8px;
    cursor: pointer;
    font-weight: 600;
    display: flex;
    align-items: center;
    gap: 8px;
    transition: all 0.2s;
  }

  .export-btn:hover {
    background: #16a34a;
    transform: translateY(-2px);
  }

  /* Selection actions */
  .selection-actions {
    display: flex;
    align-items: center;
    gap: 16px;
    margin-bottom: 20px;
    padding: 12px 16px;
    background: #f8fafc;
    border-radius: 8px;
  }

  .selection-badge {
    background: #3b82f6;
    color: white;
    padding: 6px 12px;
    border-radius: 20px;
    font-size: 14px;
    display: inline-flex;
    align-items: center;
    gap: 6px;
    font-weight: 500;
  }

  .table-actions {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
  }

  /* Table */
  table {
    width: 100%;
    border-collapse: collapse;
  }

  thead {
    background: #f8fafc;
  }

  th {
    text-align: left;
    padding: 16px;
    font-weight: 600;
    color: #1f2937;
    border-bottom: 2px solid #e5e7eb;
  }

  td {
    padding: 16px;
    border-bottom: 1px solid #e5e7eb;
    color: #6b7280;
  }

  tbody tr {
    transition: all 0.2s;
  }

  tbody tr:hover {
    background: #f8fafc;
  }

  .status-online {
    color: #22c55e;
    font-weight: 600;
    display: flex;
    align-items: center;
    gap: 6px;
  }

  .status-offline {
    color: #ef4444;
    font-weight: 600;
    display: flex;
    align-items: center;
    gap: 6px;
  }

  .status-warning {
    color: #f59e0b;
    font-weight: 600;
    display: flex;
    align-items: center;
    gap: 6px;
  }

  .btn-detail {
    padding: 8px 16px;
    background: #3b82f6;
    color: #fff;
    border-radius: 6px;
    text-decoration: none;
    font-size: 14px;
    display: inline-flex;
    align-items: center;
    gap: 6px;
    transition: all 0.2s;
    font-weight: 500;
  }

  .btn-detail:hover {
    background: #2563eb;
    transform: translateY(-2px);
  }

  /* Checkbox styling */
  input[type="checkbox"] {
    width: 18px;
    height: 18px;
    accent-color: #3b82f6;
    cursor: pointer;
  }

  /* Utility classes */
  .d-none {
    display: none !important;
  }

  .text-center {
    text-align: center;
  }

  /* Map controls */
  .map-controls {
    position: absolute;
    top: 10px;
    right: 10px;
    z-index: 2;
    display: flex;
    flex-direction: column;
    gap: 8px;
  }

  .map-control-btn {
    background: white;
    border: 1px solid #e5e7eb;
    padding: 8px 12px;
    border-radius: 6px;
    cursor: pointer;
    font-size: 14px;
    display: flex;
    align-items: center;
    gap: 6px;
    box-shadow: 0 1px 3px rgba(0,0,0,0.1);
    transition: all 0.2s;
  }

  .map-control-btn:hover {
    background: #f8fafc;
    transform: translateY(-2px);
  }

  .marker-selected {
    filter: drop-shadow(0 0 8px #3b82f6);
    transform: scale(1.2);
    transition: transform 0.2s ease;
  }

  /* Responsive - ĐÃ SỬA */
  @media (max-width: 1024px) {
    .sidebar {
      width: 200px;
    }
    .main-content {
      margin-left: 200px;
      width: calc(100% - 200px);
    }
  }

  @media (max-width: 768px) {
    .sidebar {
      width: 100%;
      height: auto;
      position: relative;
      display: none;
    }

    .main-content {
      margin-left: 0;
      width: 100%;
    }

    .menu-mobile-toggle {
      display: block;
      position: fixed;
      top: 15px;
      left: 15px;
      z-index: 101;
      background: #3b82f6;
      color: white;
      border: none;
      border-radius: 4px;
      padding: 8px 12px;
      cursor: pointer;
    }

    .sidebar.active {
      display: flex;
      z-index: 100;
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

    .table-header {
      flex-direction: column;
      align-items: flex-start;
      gap: 16px;
    }

    .selection-actions {
      flex-wrap: wrap;
    }
  }

  /* Custom checkbox for select all */
  .checkbox-container {
    display: flex;
    align-items: center;
    gap: 8px;
    cursor: pointer;
  }
</style>
</head>
<body>
<!-- Sidebar -->
<div class="sidebar">
  <h2>Trash Bin App</h2>
  <ul class="menu">
    <li onclick="location.href='${pageContext.request.contextPath}/manage'">📊 Dashboard</li>
    <li class="active"onclick="location.href='${pageContext.request.contextPath}/tasks/task-management'">📋 Giao nhiệm vụ</li>
    <li onclick="location.href='${pageContext.request.contextPath}/list_bins'">🗑️ Danh sách thùng rác</li>
    <li>⚠️ Báo cáo</li>
    <li>👤 Người dùng</li>
    <li>⚙️ Cài đặt</li>
  </ul>
</div>

<!-- Main Content -->
<div class="main-content">
  <div class="header">
    <h1>Giao Nhiệm Vụ Thu Gom</h1>
    <div class="header-actions">
      <button class="notification-btn">
        <i class="fas fa-bell"></i>
        <span class="notification-badge">3</span>
      </button>
    </div>
  </div>


    <div class="map-container">
      <div class="map-header">
        <h3>Bản đồ thùng rác</h3>
      </div>
      <div id="map">
        <div class="map-controls">
          <button id="selectAllOnMap" class="map-control-btn">
            <i class="fas fa-check-square"></i> Chọn tất cả trên bản đồ
          </button>
          <button id="clearMapSelection" class="map-control-btn">
            <i class="fas fa-times-circle"></i> Bỏ chọn tất cả
          </button>
        </div>
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

      <!-- Selection actions -->
      <div class="selection-actions d-none" id="selectionActions">
        <div class="checkbox-container">
          <input type="checkbox" id="selectAllVisible" />
          <label for="selectAllVisible">Chọn tất cả hiển thị</label>
        </div>
        <div class="selection-badge" id="selectionBadge">
          <span id="selectedCount">0</span> thùng được chọn
        </div>
        <button id="assignTaskBtn" class="export-btn">
          <i class="fas fa-tasks"></i> Giao nhiệm vụ
        </button>
      </div>

      <table id="binTable">
        <thead>
        <tr>
          <th width="50px">
            <div class="checkbox-container">
              <input type="checkbox" id="selectAll" />
              <label for="selectAll"></label>
            </div>
          </th>
          <th>Mã</th>
          <th>Địa chỉ</th>
          <th>Đầy (%)</th>
          <th>Mức chứa</th>
          <th>Hoạt Động</th>

        </tr>
        </thead>
        <tbody>
        <c:forEach var="bin" items="${bins}">
          <tr data-city="${bin.ward.province.provinceName}"
              data-ward="${bin.ward.wardName}"
              data-status="${bin.status}"
              data-fill="${bin.currentFill}"
              data-bin-id="${bin.binID}"
              data-ward-id="${bin.ward.wardId}">
            <td class="text-center">
              <input type="checkbox" class="bin-checkbox" value="${bin.binID}"
                     data-ward-id="${bin.ward.wardId}"
                     data-ward-name="${bin.ward.wardName}">
            </td>
            <td>${bin.binCode}</td>
            <td>${bin.street},
              <c:if test="${not empty bin.ward}">${bin.ward.wardName}</c:if>
              <c:if test="${not empty bin.ward and not empty bin.ward.province}">, ${bin.ward.province.provinceName}</c:if>
            </td>
            <td>
              <div class="progress-container" style="display: flex; align-items: center; gap: 8px;">
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

            </td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
    </div>
  </div>
</div>

  <script>
    document.addEventListener("DOMContentLoaded", function () {
      // ===== inject small CSS for selected row/marker =====
      (function injectStyles() {
        const css = `
        tr.row-selected { background: #f0f9ff !important; }
        .marker-selected { transform: scale(1.25); filter: drop-shadow(0 6px 10px rgba(59,130,246,0.25)); }
      `;
        const s = document.createElement("style");
        s.appendChild(document.createTextNode(css));
        document.head.appendChild(s);
      })();

      // ===== DOM elements =====
      const selectAll = document.getElementById("selectAll");
      const selectAllVisible = document.getElementById("selectAllVisible");
      const selectionActions = document.getElementById("selectionActions");
      const selectedCount = document.getElementById("selectedCount");
      const assignTaskBtn = document.getElementById("assignTaskBtn");
      const tbody = document.querySelector("#binTable tbody");
      const allRows = document.querySelectorAll("#binTable tbody tr");

      // ===== state =====
      let currentFilter = { city: "", ward: "", status: "", fill: "" };
      let markers = []; // will hold VietMap Marker objects

      // ===== helpers =====
      function getAllCheckboxes() {
        return Array.from(document.querySelectorAll(".bin-checkbox"));
      }
      function getVisibleCheckboxes() {
        return getAllCheckboxes().filter(cb => cb.closest("tr").style.display !== "none");
      }
      function checkSameWard(selectedCheckboxes) {
        if (!selectedCheckboxes || selectedCheckboxes.length === 0) return true;
        const firstWardId = selectedCheckboxes[0].getAttribute("data-ward-id");
        return selectedCheckboxes.every(cb => cb.getAttribute("data-ward-id") === firstWardId);
      }
      function findMarkerByBinId(binId) {
        return markers.find(m => String(m.bin.id) === String(binId));
      }
      function highlightRowForCheckbox(cb) {
        const row = cb.closest("tr");
        if (!row) return;
        if (cb.checked) row.classList.add("row-selected");
        else row.classList.remove("row-selected");
      }
      function highlightMarkerForBin(binId, highlight) {
        const m = findMarkerByBinId(binId);
        if (!m) return;
        const el = m.getElement();
        if (highlight) el.classList.add("marker-selected");
        else el.classList.remove("marker-selected");
      }

      // ===== selection UI update =====
      function updateSelectionUI() {
        const visible = getVisibleCheckboxes();
        const selected = visible.filter(cb => cb.checked);
        const count = selected.length;
        selectedCount.textContent = count;

        if (count > 0) {
          selectionActions.classList.remove("d-none");
          if (!checkSameWard(selected)) {
            assignTaskBtn.disabled = true;
            assignTaskBtn.title = "Không thể giao nhiệm vụ cho nhiều phường khác nhau";
            assignTaskBtn.style.opacity = "0.6";
            assignTaskBtn.style.cursor = "not-allowed";
            if (!document.getElementById("wardWarning")) {
              const warning = document.createElement("div");
              warning.id = "wardWarning";
              warning.style.color = "#ef4444";
              warning.style.marginTop = "10px";
              warning.style.fontSize = "14px";
              warning.innerHTML = "⚠️ Chỉ có thể chọn thùng rác trong cùng một phường/xã";
              selectionActions.appendChild(warning);
            }
          } else {
            assignTaskBtn.disabled = false;
            assignTaskBtn.title = "";
            assignTaskBtn.style.opacity = "1";
            assignTaskBtn.style.cursor = "pointer";
            const w = document.getElementById("wardWarning"); if (w) w.remove();
          }

          const allVisibleChecked = visible.length > 0 && visible.every(cb => cb.checked);
          selectAll.checked = allVisibleChecked;
          selectAllVisible.checked = allVisibleChecked;
        } else {
          selectionActions.classList.add("d-none");
          selectAll.checked = false;
          selectAllVisible.checked = false;
          const w = document.getElementById("wardWarning"); if (w) w.remove();
        }
      }

      function toggleSelectAll(masterCheckbox) {
        const isChecked = masterCheckbox.checked;
        getVisibleCheckboxes().forEach(cb => {
          cb.checked = isChecked;
          highlightRowForCheckbox(cb);
          highlightMarkerForBin(cb.value, isChecked);
        });
        updateSelectionUI();
      }

      // ===== handle checkbox change via event delegation on tbody =====
      tbody.addEventListener("change", function (e) {
        if (e.target && e.target.matches(".bin-checkbox")) {
          const cb = e.target;
          highlightRowForCheckbox(cb);
          highlightMarkerForBin(cb.value, cb.checked);
          updateSelectionUI();
        }
      });

      // ===== assign task button =====
      assignTaskBtn.addEventListener("click", function () {
        const selected = Array.from(document.querySelectorAll(".bin-checkbox:checked"));
        if (selected.length === 0) {
          alert("Vui lòng chọn ít nhất 1 thùng rác!");
          return;
        }
        if (!checkSameWard(selected)) {
          alert("Không thể giao nhiệm vụ cho thùng rác từ nhiều phường khác nhau!");
          return;
        }
        const form = document.createElement("form");
        form.method = "GET";
        form.action = "${pageContext.request.contextPath}/tasks/assign/batch";
        form.style.display = "none";
        const binIdsInput = document.createElement("input");
        binIdsInput.type = "hidden";
        binIdsInput.name = "binIds";
        binIdsInput.value = selected.map(cb => cb.value).join(",");
        form.appendChild(binIdsInput);
        const wardInput = document.createElement("input");
        wardInput.type = "hidden";
        wardInput.name = "ward";
        wardInput.value = selected[0].getAttribute("data-ward-id");
        form.appendChild(wardInput);
        document.body.appendChild(form);
        form.submit();
      });

      // ===== map init & marker logic =====
      let map;
      try {
        map = new vietmapgl.Map({
          container: "map",
          style: "https://maps.vietmap.vn/maps/styles/tm/style.json?apikey=ecdbd35460b2d399e18592e6264186757aaaddd8755b774c",
          center: [108.2068, 16.0471],
          zoom: 12
        });
        map.addControl(new vietmapgl.NavigationControl());
      } catch (err) {
        console.error("VietMap init error:", err);
      }

      // === bins array is generated by JSP, keep as-is ===
      const bins = [
        <c:forEach var="bin" items="${bins}" varStatus="loop">
        {
          id: "${bin.binID}",
          code: "${bin.binCode}",
          lat: ${bin.latitude},
          lng: ${bin.longitude},
          fullness: ${bin.currentFill != null ? bin.currentFill : 0},
          address: "${bin.street}, ${bin.ward.wardName}, ${bin.ward.province.provinceName}",
          updated: "${bin.lastUpdated}",
          city: "${bin.ward.province.provinceName}",
          ward: "${bin.ward.wardName}",
          status: "${bin.status}"
        }<c:if test="${!loop.last}">,</c:if>
        </c:forEach>
      ];

      function getBinIcon(level) {
        if (level >= 80) {
          return "data:image/svg+xml;charset=UTF-8," + encodeURIComponent(
                  '<svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" fill="red" viewBox="0 0 24 24"><path d="M3 6h18v2H3zm2 2h14v14H5z"/><rect x="5" y="8" width="14" height="12" fill="rgba(0,0,0,0.3)"/></svg>'
          );
        } else if (level >= 40) {
          return "data:image/svg+xml;charset=UTF-8," + encodeURIComponent(
                  '<svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" fill="orange" viewBox="0 0 24 24"><path d="M3 6h18v2H3zm2 2h14v14H5z"/><rect x="5" y="12" width="14" height="8" fill="rgba(0,0,0,0.3)"/></svg>'
          );
        } else {
          return "data:image/svg+xml;charset=UTF-8," + encodeURIComponent(
                  '<svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" fill="green" viewBox="0 0 24 24"><path d="M3 6h18v2H3zm2 2h14v14H5z"/><rect x="5" y="16" width="14" height="4" fill="rgba(0,0,0,0.3)"/></svg>'
          );
        }
      }

      function addMarkers() {
        try {
          // remove existing markers
          markers.forEach(m => m.remove());
          markers = [];

          bins.forEach(bin => {
            const el = document.createElement("img");
            el.src = getBinIcon(bin.fullness);
            el.style.width = "32px";
            el.style.height = "32px";
            el.style.cursor = "pointer";
            // set data attribute for convenience
            el.dataset.binId = String(bin.id);

            const popup = new vietmapgl.Popup({ offset: 25 }).setHTML(
                    "<b>Mã:</b> " + bin.code +
                    "<br><b>Địa chỉ:</b> " + bin.address +
                    "<br><b>Đầy:</b> " + bin.fullness + "%" +
                    "<br><b>Trạng thái:</b> " + (bin.status == 1 ? "Online" : "Offline") +
                    "<br><b>Cập nhật:</b> " + bin.updated
            );

            const marker = new vietmapgl.Marker({ element: el })
                    .setLngLat([bin.lng, bin.lat])
                    .setPopup(popup)
                    .addTo(map);

            marker.bin = bin;
            markers.push(marker);

            // click trên marker: toggle checkbox + open popup
            el.addEventListener("click", function (ev) {
              try {
                // toggle checkbox corresponding to this bin
                const binId = this.dataset.binId;
                const cb = document.querySelector('.bin-checkbox[value="' + binId + '"]');
                if (cb) {
                  cb.checked = !cb.checked;
                  highlightRowForCheckbox(cb);
                  highlightMarkerForBin(binId, cb.checked);
                  updateSelectionUI();
                }
                // ✅ thêm đoạn này để marker đổi trạng thái
                if (cb && cb.checked) {
                  el.classList.add("marker-selected");
                } else {
                  el.classList.remove("marker-selected");
                }
                // open popup
                popup.addTo(map);
              } catch (err) {
                console.error("marker click error:", err);
              }
            });
          });
        } catch (err) {
          console.error("addMarkers error:", err);
        }
      }

      if (map) {
        map.on("load", addMarkers);
      } else {
        // if map initialization failed, still try to call addMarkers (it will likely fail but logged)
        try { addMarkers(); } catch(e){ console.error(e); }
      }

      // ===== filter logic (kept behavior) =====
      function applyFilter() {
        currentFilter.city = document.getElementById("cityFilter").value;
        currentFilter.ward = document.getElementById("wardFilter").value;
        currentFilter.status = document.getElementById("statusFilter").value;
        currentFilter.fill = document.getElementById("fillFilter").value;

        allRows.forEach(function (row) {
          const rowCity = row.getAttribute("data-city");
          const rowWard = row.getAttribute("data-ward");
          const rowStatus = row.getAttribute("data-status");
          const rowFill = parseInt(row.getAttribute("data-fill")) || 0;

          let matchFill = true;
          if (currentFilter.fill) {
            const fillValue = parseInt(currentFilter.fill);
            if (fillValue === 80) matchFill = rowFill >= 80;
            else if (fillValue === 40) matchFill = rowFill >= 40 && rowFill < 80;
            else if (fillValue === 0) matchFill = rowFill < 40;
          }

          const match =
                  (!currentFilter.city || currentFilter.city === rowCity) &&
                  (!currentFilter.ward || currentFilter.ward === rowWard) &&
                  (!currentFilter.status || currentFilter.status === rowStatus) &&
                  matchFill;

          row.style.display = match ? "" : "none";
          // un-select hidden rows (as before)
          if (!match) {
            const cb = row.querySelector(".bin-checkbox");
            if (cb) {
              cb.checked = false;
              highlightRowForCheckbox(cb);
              highlightMarkerForBin(cb.value, false);
            }
          }
        });

        markers.forEach((marker) => {
          const bin = marker.bin;
          let matchFill = true;
          if (currentFilter.fill) {
            const fillValue = parseInt(currentFilter.fill);
            if (fillValue === 80) matchFill = bin.fullness >= 80;
            else if (fillValue === 40) matchFill = bin.fullness >= 40 && bin.fullness < 80;
            else if (fillValue === 0) matchFill = bin.fullness < 40;
          }
          const match =
                  (!currentFilter.city || currentFilter.city === bin.city) &&
                  (!currentFilter.ward || currentFilter.ward === bin.ward) &&
                  (!currentFilter.status || currentFilter.status === bin.status) &&
                  matchFill;
          try {
            marker.getElement().style.display = match ? "block" : "none";
          } catch (err) {
            // ignore if marker not fully available
          }
        });

        updateSelectionUI();
      }

      ["cityFilter", "wardFilter", "statusFilter", "fillFilter"].forEach((id) => {
        const el = document.getElementById(id);
        if (el) el.addEventListener("change", applyFilter);
      });

      // select-all handlers
      if (selectAll) selectAll.addEventListener("change", function () { toggleSelectAll(this); });
      if (selectAllVisible) selectAllVisible.addEventListener("change", function () { toggleSelectAll(this); });

      // initial UI update
      updateSelectionUI();
    });
  </script>

</body>
</html>