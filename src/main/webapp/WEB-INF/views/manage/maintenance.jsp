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
      <div>
        <h1 class="h4 mb-0 text-dark">
          Giao Nhiệm Vụ Bảo Trì
        </h1>
        <small class="text-muted">Quản lý và giao nhiệm vụ cho thùng rác</small>
      </div>
      <div class="d-flex align-items-center">
        <!-- Nút chuyển đổi loại nhiệm vụ -->
        <div class="btn-group me-3" role="group">
          <a href="${pageContext.request.contextPath}/tasks/task-management"
             class="btn ${param.type != 'maintain' ? 'btn-primary' : 'btn-outline-primary'}">
            <i class="fas fa-trash-alt me-1"></i> Thu gom
          </a>
          <a href="${pageContext.request.contextPath}/tasks/maintenance-management"
             class="btn ${param.type == 'maintain' ? 'btn-primary' : 'btn-outline-primary'}">
            <i class="fas fa-tools me-1"></i> Bảo trì
          </a>
        </div>

        <button class="btn btn-outline-secondary position-relative">
          <i class="fas fa-bell"></i>
          <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
            3
          </span>
        </button>
      </div>
    </div>

    <div class="p-4">
      <!-- Filter và Map Section -->
      <div class="row mb-4">
        <!-- Filter Section - Bên trái -->
        <div class="col-md-4">
          <div class="card border-0 shadow-sm h-100">
            <div class="card-header bg-white border-bottom-0">
              <h5 class="mb-0">
                <i class="fas fa-filter me-2"></i>Bộ lọc
              </h5>
            </div>
            <div class="card-body">
              <div class="mb-3">
                <label for="cityFilter" class="form-label fw-semibold">
                  <i class="fas fa-city me-1 text-primary"></i>Khu vực:
                </label>
                <select class="form-select" id="cityFilter">
                  <option value="">-- Tất cả --</option>
                  <c:forEach var="city" items="${cities}">
                    <option value="${city}">${city}</option>
                  </c:forEach>
                </select>
              </div>

              <div class="mb-3">
                <label for="wardFilter" class="form-label fw-semibold">
                  <i class="fas fa-map-marker-alt me-1 text-success"></i>Phường/Xã:
                </label>
                <select class="form-select" id="wardFilter">
                  <option value="">-- Tất cả --</option>
                  <c:forEach var="ward" items="${wards}">
                    <option value="${ward}">${ward}</option>
                  </c:forEach>
                </select>
              </div>

              <!-- Thống kê nhanh -->
              <div class="mt-4 pt-3 border-top">
                <h6 class="text-muted mb-3">Thống kê nhanh</h6>
                <div class="row text-center">
                  <div class="col-6">
                    <div class="bg-success bg-opacity-10 rounded p-3">
                      <i class="fas fa-wifi text-success fs-4"></i>
                      <div class="small fw-bold text-success mt-2">Online</div>
                      <div class="fw-bold fs-4 text-success" id="onlineCount">0</div>
                    </div>
                  </div>
                  <div class="col-6">
                    <div class="bg-secondary bg-opacity-10 rounded p-3">
                      <i class="fas fa-wifi-slash text-secondary fs-4"></i>
                      <div class="small fw-bold text-secondary mt-2">Offline</div>
                      <div class="fw-bold fs-4 text-secondary" id="offlineCount">0</div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Map Section - Bên phải -->
        <div class="col-md-8">
          <div class="card border-0 shadow-sm h-100">
            <div class="card-header bg-white border-bottom-0 d-flex justify-content-between align-items-center">
              <h5 class="mb-0">🗺️ Bản đồ thùng rác</h5>
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
            <div class="card-body position-relative p-0">
              <div id="map" style="height: 350px;" class="w-100">
              </div>
              <!-- Map Legend -->
              <div class="position-absolute bottom-0 start-0 m-2 bg-white rounded shadow-sm p-2" style="z-index: 1000;">
                <div class="d-flex align-items-center small">
                  <div class="me-3 d-flex align-items-center">
                    <div class="bg-success rounded-circle me-1" style="width: 10px; height: 10px;"></div>
                    <span>Online</span>
                  </div>
                  <div class="me-3 d-flex align-items-center">
                    <div class="bg-secondary rounded-circle me-1" style="width: 10px; height: 10px;"></div>
                    <span>Offline</span>
                  </div>
                  <div class="d-flex align-items-center">
                    <div class="bg-dark rounded-circle me-1" style="width: 10px; height: 10px;"></div>
                    <span>Đã chọn</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Table Section -->
      <div class="card border-0 shadow-sm">
        <div class="card-header bg-white border-bottom-0 d-flex justify-content-between align-items-center">
          <h5 class="mb-0">
            <i class="fas fa-list me-2"></i>Danh sách thùng rác
          </h5>
          <div class="text-muted small">
            Tổng: <span id="totalBins">${fn:length(bins)}</span> thùng |
            Hiển thị: <span id="visibleBins">0</span> thùng
          </div>
        </div>

        <!-- Selection Actions Bar -->
        <div class="card-body border-bottom d-none" id="selectionActions">
          <div class="row align-items-center">
            <div class="col-md-4">
              <div class="form-check">
                <input class="form-check-input" type="checkbox" id="selectAllVisible">
                <label class="form-check-label fw-medium" for="selectAllVisible">
                  Chọn tất cả trang này
                </label>
              </div>
            </div>
            <div class="col-md-4">
              <span class="badge bg-primary fs-6" id="selectionBadge">
                <span id="selectedCount">0</span> thùng được chọn
              </span>
            </div>
            <div class="col-md-4 text-end">
              <button id="assignTaskBtn" class="btn btn-success">
                <i class="fas fa-tasks me-1"></i>
                Giao nhiệm vụ bảo trì
              </button>
            </div>
          </div>
          <div id="wardWarningContainer"></div>
        </div>

        <div class="card-body p-0">
          <div class="table-responsive">
            <table class="table table-hover mb-0" id="binTable">
              <thead class="table-light">
              <tr>
                <th width="50" class="text-center">
                  <div class="form-check">
                    <input class="form-check-input" type="checkbox" id="selectAll">
                  </div>
                </th>
                <th class="fw-semibold">Mã</th>
                <th class="fw-semibold">Địa chỉ</th>
                <th class="fw-semibold">Mức chứa</th>
                <th class="fw-semibold">Hoạt Động</th>
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
                    <div class="form-check">
                      <input class="form-check-input bin-checkbox" type="checkbox" value="${bin.binID}"
                             data-ward-id="${bin.ward.wardId}"
                             data-ward-name="${bin.ward.wardName}">
                    </div>
                  </td>
                  <td class="fw-medium">${bin.binCode}</td>
                  <td>
                      ${bin.street}<c:if test="${not empty bin.ward}">, ${bin.ward.wardName}</c:if><c:if test="${not empty bin.ward and not empty bin.ward.province}">, ${bin.ward.province.provinceName}</c:if>
                  </td>
                  <td>${bin.capacity}L</td>
                  <td>
                    <c:choose>
                      <c:when test="${bin.status == 1}">
                        <span class="badge bg-success">
                          <i class="fas fa-circle me-1"></i> Online
                        </span>
                      </c:when>
                      <c:when test="${bin.status == 2}">
                        <span class="badge bg-secondary">
                          <i class="fas fa-circle me-1"></i> Offline
                        </span>
                      </c:when>
                    </c:choose>
                  </td>
                </tr>
              </c:forEach>
              </tbody>
            </table>
          </div>
        </div>

        <!-- Pagination Section -->
        <div class="card-footer bg-white border-top">
          <div class="d-flex justify-content-between align-items-center">
            <div class="d-flex align-items-center">
              <span class="text-muted me-2">Hiển thị:</span>
              <select class="form-select form-select-sm" id="rowsPerPage" style="width: auto;">
                <option value="10">10</option>
                <option value="25" selected>25</option>
                <option value="50">50</option>
                <option value="100">100</option>
              </select>
              <span class="text-muted ms-3" id="pageInfo">Hiển thị 0-0 của 0</span>
            </div>

            <nav>
              <ul class="pagination pagination-sm mb-0" id="pagination">
                <li class="page-item disabled" id="prevPage">
                  <a class="page-link" href="#" tabindex="-1">
                    <i class="fas fa-chevron-left"></i>
                  </a>
                </li>
                <li class="page-item" id="nextPage">
                  <a class="page-link" href="#">
                    <i class="fas fa-chevron-right"></i>
                  </a>
                </li>
              </ul>
            </nav>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
  let currentPage = 1;
  let rowsPerPage = 25;
  let filteredRows = [];

  document.addEventListener("DOMContentLoaded", function () {
    // Add selected row styling
    const style = document.createElement('style');
    style.textContent = `
      tr.row-selected {
        background-color: #e3f2fd !important;
      }
      .marker-selected {
        transform: scale(1.25);
        filter: drop-shadow(0 6px 10px rgba(59,130,246,0.25));
        transition: all 0.2s ease;
      }
    `;
    document.head.appendChild(style);

    // DOM elements
    const selectAll = document.getElementById("selectAll");
    const selectAllVisible = document.getElementById("selectAllVisible");
    const selectionActions = document.getElementById("selectionActions");
    const selectedCount = document.getElementById("selectedCount");
    const assignTaskBtn = document.getElementById("assignTaskBtn");
    const tbody = document.querySelector("#binTable tbody");
    const allRows = document.querySelectorAll("#binTable tbody tr");
    const wardWarningContainer = document.getElementById("wardWarningContainer");

    // State
    let currentFilter = { city: "", ward: "" };
    let markers = [];

    // Helper functions
    function getAllCheckboxes() {
      return Array.from(document.querySelectorAll(".bin-checkbox"));
    }

    function getVisibleCheckboxes() {
      return getAllCheckboxes().filter(cb => {
        const row = cb.closest("tr");
        return row.style.display !== "none" && row.classList.contains("page-visible");
      });
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

      if (highlight) {
        el.src = getBlackBinIcon();
        el.classList.add("marker-selected");
      } else {
        const bin = m.bin;
        el.src = getBinIcon(bin.fullness, bin.status);
        el.classList.remove("marker-selected");
      }
    }

    // Selection UI update
    function updateSelectionUI() {
      const visible = getVisibleCheckboxes();
      const allChecked = getAllCheckboxes().filter(cb => cb.checked);
      const count = allChecked.length;
      selectedCount.textContent = count;

      if (count > 0) {
        selectionActions.classList.remove("d-none");
        if (!checkSameWard(allChecked)) {
          assignTaskBtn.disabled = true;
          assignTaskBtn.classList.add("disabled");
          wardWarningContainer.innerHTML = `
            <div class="alert alert-warning mt-2 mb-0">
              <i class="fas fa-exclamation-triangle me-1"></i>
              Chỉ có thể chọn thùng rác trong cùng một phường/xã
            </div>
          `;
        } else {
          assignTaskBtn.disabled = false;
          assignTaskBtn.classList.remove("disabled");
          wardWarningContainer.innerHTML = "";
        }

        const allVisibleChecked = visible.length > 0 && visible.every(cb => cb.checked);
        selectAll.checked = allVisibleChecked;
        selectAllVisible.checked = allVisibleChecked;
      } else {
        selectionActions.classList.add("d-none");
        selectAll.checked = false;
        selectAllVisible.checked = false;
        wardWarningContainer.innerHTML = "";
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

    // Event listeners
    tbody.addEventListener("change", function (e) {
      if (e.target && e.target.matches(".bin-checkbox")) {
        const cb = e.target;
        highlightRowForCheckbox(cb);
        highlightMarkerForBin(cb.value, cb.checked);
        updateSelectionUI();
      }
    });

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

      const urlParams = new URLSearchParams(window.location.search);
      const taskType = urlParams.get('type');

      const form = document.createElement("form");
      form.method = "GET";
      form.action = "${pageContext.request.contextPath}/tasks/assign/batch1";
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

      const typeInput = document.createElement("input");
      typeInput.type = "hidden";
      typeInput.name = "type";
      typeInput.value = taskType;
      form.appendChild(typeInput);

      document.body.appendChild(form);
      form.submit();
    });

    // Map initialization
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

    // Bins data
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

    function getBinIcon(level, status) {
      // Chỉ phân biệt theo trạng thái Online/Offline
      if (status == 2) {
        return "data:image/svg+xml;charset=UTF-8," + encodeURIComponent(
                '<svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" fill="gray" viewBox="0 0 24 24"><path d="M3 6h18v2H3zm2 2h14v14H5z"/><rect x="5" y="8" width="14" height="12" fill="rgba(0,0,0,0.3)"/></svg>'
        );
      } else {
        return "data:image/svg+xml;charset=UTF-8," + encodeURIComponent(
                '<svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" fill="green" viewBox="0 0 24 24"><path d="M3 6h18v2H3zm2 2h14v14H5z"/><rect x="5" y="8" width="14" height="12" fill="rgba(0,0,0,0.3)"/></svg>'
        );
      }
    }

    function getBlackBinIcon() {
      return "data:image/svg+xml;charset=UTF-8," + encodeURIComponent(
              '<svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" fill="black" viewBox="0 0 24 24"><path d="M3 6h18v2H3zm2 2h14v14H5z"/><rect x="5" y="8" width="14" height="12" fill="rgba(255,255,255,0.8)"/><circle cx="12" cy="14" r="2" fill="white"/></svg>'
      );
    }

    function addMarkers() {
      try {
        markers.forEach(m => m.remove());
        markers = [];

        bins.forEach(bin => {
          const el = document.createElement("img");
          el.src = getBinIcon(bin.fullness, bin.status);
          el.style.width = "32px";
          el.style.height = "32px";
          el.style.cursor = "pointer";
          el.dataset.binId = String(bin.id);

          const popup = new vietmapgl.Popup({ offset: 25 }).setHTML(
                  "<b>Mã:</b> " + bin.code +
                  "<br><b>Địa chỉ:</b> " + bin.address +
                  "<br><b>Trạng thái:</b> " + (bin.status == 1 ? "Online" : "Offline") +
                  "<br><b>Cập nhật:</b> " + bin.updated
          );

          const marker = new vietmapgl.Marker({ element: el })
                  .setLngLat([bin.lng, bin.lat])
                  .setPopup(popup)
                  .addTo(map);

          marker.bin = bin;
          markers.push(marker);

          el.addEventListener("click", function (ev) {
            try {
              const binId = this.dataset.binId;
              const cb = document.querySelector('.bin-checkbox[value="' + binId + '"]');
              if (cb) {
                cb.checked = !cb.checked;
                highlightRowForCheckbox(cb);
                highlightMarkerForBin(binId, cb.checked);
                updateSelectionUI();
              }
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
    }

    // Update statistics - CHỈ ĐẾM ONLINE/OFFLINE
    function updateStatistics() {
      let onlineCount = 0;
      let offlineCount = 0;

      filteredRows.forEach(row => {
        const status = parseInt(row.getAttribute("data-status"));

        if (status === 1) onlineCount++;
        else if (status === 2) offlineCount++;
      });

      document.getElementById("onlineCount").textContent = onlineCount;
      document.getElementById("offlineCount").textContent = offlineCount;
      document.getElementById("visibleBins").textContent = filteredRows.length;
    }

    // Pagination functions
    function displayPage() {
      allRows.forEach(row => {
        row.style.display = "none";
        row.classList.remove("page-visible");
      });

      const start = (currentPage - 1) * rowsPerPage;
      const end = start + rowsPerPage;
      const rowsToShow = filteredRows.length > 0 ? filteredRows : Array.from(allRows);

      for (let i = start; i < end && i < rowsToShow.length; i++) {
        rowsToShow[i].style.display = "";
        rowsToShow[i].classList.add("page-visible");
      }

      updatePagination(rowsToShow.length);
      updatePageInfo(start, end, rowsToShow.length);
      updateSelectionUI();
    }

    function updatePageInfo(start, end, total) {
      const pageInfo = document.getElementById("pageInfo");
      const displayStart = total > 0 ? start + 1 : 0;
      const displayEnd = Math.min(end, total);
      pageInfo.textContent = `Hiển thị ${displayStart}-${displayEnd} của ${total}`;
    }

    function updatePagination(totalRows) {
      const totalPages = Math.ceil(totalRows / rowsPerPage);
      const pagination = document.getElementById("pagination");

      const pageItems = pagination.querySelectorAll(".page-item:not(#prevPage):not(#nextPage)");
      pageItems.forEach(item => item.remove());

      const prevPage = document.getElementById("prevPage");
      if (currentPage === 1) {
        prevPage.classList.add("disabled");
      } else {
        prevPage.classList.remove("disabled");
      }

      const nextPage = document.getElementById("nextPage");
      const maxPagesToShow = 5;
      const startPage = Math.max(1, currentPage - Math.floor(maxPagesToShow / 2));
      const endPage = Math.min(totalPages, startPage + maxPagesToShow - 1);

      if (startPage > 1) {
        const firstPageLi = createPageItem(1, false);
        pagination.insertBefore(firstPageLi, nextPage);

        if (startPage > 2) {
          const dotsLi = document.createElement("li");
          dotsLi.className = "page-item disabled";
          dotsLi.innerHTML = '<span class="page-link">...</span>';
          pagination.insertBefore(dotsLi, nextPage);
        }
      }

      for (let i = startPage; i <= endPage; i++) {
        const pageLi = createPageItem(i, i === currentPage);
        pagination.insertBefore(pageLi, nextPage);
      }

      if (endPage < totalPages) {
        if (endPage < totalPages - 1) {
          const dotsLi = document.createElement("li");
          dotsLi.className = "page-item disabled";
          dotsLi.innerHTML = '<span class="page-link">...</span>';
          pagination.insertBefore(dotsLi, nextPage);
        }
        const lastPageLi = createPageItem(totalPages, false);
        pagination.insertBefore(lastPageLi, nextPage);
      }

      if (currentPage === totalPages || totalPages === 0) {
        nextPage.classList.add("disabled");
      } else {
        nextPage.classList.remove("disabled");
      }
    }

    function createPageItem(pageNum, isActive) {
      const li = document.createElement("li");
      li.className = "page-item" + (isActive ? " active" : "");

      const a = document.createElement("a");
      a.className = "page-link";
      a.href = "#";
      a.textContent = pageNum;
      a.onclick = function(e) {
        e.preventDefault();
        if (!isActive) {
          currentPage = pageNum;
          displayPage();
        }
      };

      li.appendChild(a);
      return li;
    }

    // Filter logic - CHỈ ÁP DỤNG FILTER CITY VÀ WARD
    function applyFilter() {
      currentFilter.city = document.getElementById("cityFilter").value;
      currentFilter.ward = document.getElementById("wardFilter").value;

      filteredRows = [];

      allRows.forEach(function (row) {
        const rowCity = row.getAttribute("data-city");
        const rowWard = row.getAttribute("data-ward");

        const match =
                (!currentFilter.city || currentFilter.city === rowCity) &&
                (!currentFilter.ward || currentFilter.ward === rowWard);

        if (match) {
          filteredRows.push(row);
        } else {
          const cb = row.querySelector(".bin-checkbox");
          if (cb && cb.checked) {
            cb.checked = false;
            highlightRowForCheckbox(cb);
            highlightMarkerForBin(cb.value, false);
          }
        }
      });

      markers.forEach((marker) => {
        const bin = marker.bin;

        const match =
                (!currentFilter.city || currentFilter.city === bin.city) &&
                (!currentFilter.ward || currentFilter.ward === bin.ward);

        try {
          marker.getElement().style.display = match ? "block" : "none";
        } catch (err) {
          console.error("Marker display error:", err);
        }
      });

      currentPage = 1;
      updateStatistics();
      displayPage();
    }

    // Event listeners for pagination
    document.getElementById("prevPage").addEventListener("click", function(e) {
      e.preventDefault();
      if (currentPage > 1) {
        currentPage--;
        displayPage();
      }
    });

    document.getElementById("nextPage").addEventListener("click", function(e) {
      e.preventDefault();
      const rowsToShow = filteredRows.length > 0 ? filteredRows : Array.from(allRows);
      const totalPages = Math.ceil(rowsToShow.length / rowsPerPage);

      if (currentPage < totalPages) {
        currentPage++;
        displayPage();
      }
    });

    document.getElementById("rowsPerPage").addEventListener("change", function() {
      rowsPerPage = parseInt(this.value);
      currentPage = 1;
      displayPage();
    });

    // Filter event listeners - CHỈ 2 FILTER
    ["cityFilter", "wardFilter"].forEach((id) => {
      const el = document.getElementById(id);
      if (el) el.addEventListener("change", applyFilter);
    });

    // Select all event listeners
    if (selectAll) selectAll.addEventListener("change", function () { toggleSelectAll(this); });
    if (selectAllVisible) selectAllVisible.addEventListener("change", function () { toggleSelectAll(this); });

    // Initial setup
    filteredRows = Array.from(allRows);
    updateStatistics();
    displayPage();
  });
</script>

</body>
</html>