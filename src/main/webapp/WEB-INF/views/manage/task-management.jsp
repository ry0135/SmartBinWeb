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
      <h1 class="h4 mb-0 text-dark">Giao Nhiệm Vụ Thu Gom</h1>
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
      <!-- Map Section -->
      <div class="card border-0 shadow-sm mb-4">
        <div class="card-header bg-white border-bottom-0 d-flex justify-content-between align-items-center">
          <h5 class="mb-0">Bản đồ thùng rác</h5>
        </div>
        <div class="card-body position-relative">
          <div id="map" style="height: 400px;" class="rounded position-relative">
            <div class="position-absolute top-0 end-0 m-3" style="z-index: 2;">
              <div class="btn-group-vertical">
                <button id="selectAllOnMap" class="btn btn-light btn-sm shadow-sm mb-2">
                  <i class="fas fa-check-square me-1"></i> Chọn tất cả
                </button>
                <button id="clearMapSelection" class="btn btn-light btn-sm shadow-sm">
                  <i class="fas fa-times-circle me-1"></i> Bỏ chọn
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Filter Section -->
      <div class="card border-0 shadow-sm mb-4">
        <div class="card-body">
          <div class="row g-3">
            <div class="col-md-3">
              <label for="cityFilter" class="form-label fw-semibold">Khu vực:</label>
              <select class="form-select" id="cityFilter">
                <option value="">-- Tất cả --</option>
                <c:forEach var="city" items="${cities}">
                  <option value="${city}">${city}</option>
                </c:forEach>
              </select>
            </div>

            <div class="col-md-3">
              <label for="wardFilter" class="form-label fw-semibold">Phường/Xã:</label>
              <select class="form-select" id="wardFilter">
                <option value="">-- Tất cả --</option>
                <c:forEach var="ward" items="${wards}">
                  <option value="${ward}">${ward}</option>
                </c:forEach>
              </select>
            </div>

            <div class="col-md-3">
              <label for="statusFilter" class="form-label fw-semibold">Hoạt động:</label>
              <select class="form-select" id="statusFilter">
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

            <div class="col-md-3">
              <label for="fillFilter" class="form-label fw-semibold">Mức đầy:</label>
              <select class="form-select" id="fillFilter">
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
        </div>
      </div>

      <!-- Table Section -->
      <div class="card border-0 shadow-sm">
        <div class="card-header bg-white border-bottom-0 d-flex justify-content-between align-items-center">
          <h5 class="mb-0">Danh sách thùng rác</h5>
          <button class="btn btn-success btn-sm">
            <i class="fas fa-file-export me-1"></i> Xuất báo cáo
          </button>
        </div>

        <!-- Selection Actions Bar -->
        <div class="card-body border-bottom d-none" id="selectionActions">
          <div class="row align-items-center">
            <div class="col-md-4">
              <div class="form-check">
                <input class="form-check-input" type="checkbox" id="selectAllVisible">
                <label class="form-check-label fw-medium" for="selectAllVisible">
                  Chọn tất cả hiển thị
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
                <i class="fas fa-tasks me-1"></i> Giao nhiệm vụ
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
                <th class="fw-semibold">Đầy (%)</th>
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
                  <td>
                    <div class="d-flex align-items-center">
                      <div class="progress me-2" style="width: 60px; height: 8px;">
                        <div class="progress-bar ${bin.currentFill >= 80 ? 'bg-danger' : bin.currentFill >= 40 ? 'bg-warning' : 'bg-success'}"
                             role="progressbar"
                             style="width: ${bin.currentFill}%"
                             aria-valuenow="${bin.currentFill}"
                             aria-valuemin="0"
                             aria-valuemax="100">
                        </div>
                      </div>
                      <small class="text-muted">${bin.currentFill}%</small>
                    </div>
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
      </div>
    </div>
  </div>
</div>

<script>
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
    let currentFilter = { city: "", ward: "", status: "", fill: "" };
    let markers = [];

    // Helper functions
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

    // Selection UI update
    function updateSelectionUI() {
      const visible = getVisibleCheckboxes();
      const selected = visible.filter(cb => cb.checked);
      const count = selected.length;
      selectedCount.textContent = count;

      if (count > 0) {
        selectionActions.classList.remove("d-none");
        if (!checkSameWard(selected)) {
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
        markers.forEach(m => m.remove());
        markers = [];

        bins.forEach(bin => {
          const el = document.createElement("img");
          el.src = getBinIcon(bin.fullness);
          el.style.width = "32px";
          el.style.height = "32px";
          el.style.cursor = "pointer";
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

          el.addEventListener("click", function (ev) {
            try {
              const binId = this.dataset.binId;
              const cb = document.querySelector('.bin-checkbox[value="' + binId + '"]');
              if (cb) {
                cb.checked = !cb.checked;
                highlightRowForCheckbox(cb);
                highlightMarkerForBin(binId, cb.checked);
                updateSelectionUI();

                if (cb.checked) {
                  el.classList.add("marker-selected");
                } else {
                  el.classList.remove("marker-selected");
                }
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

    // Filter logic
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
          console.error("Marker display error:", err);
        }
      });

      updateSelectionUI();
    }

    // Filter event listeners
    ["cityFilter", "wardFilter", "statusFilter", "fillFilter"].forEach((id) => {
      const el = document.getElementById(id);
      if (el) el.addEventListener("change", applyFilter);
    });

    // Select all event listeners
    if (selectAll) selectAll.addEventListener("change", function () { toggleSelectAll(this); });
    if (selectAllVisible) selectAllVisible.addEventListener("change", function () { toggleSelectAll(this); });

    // Initial UI update
    updateSelectionUI();
  });
</script>

</body>
</html>