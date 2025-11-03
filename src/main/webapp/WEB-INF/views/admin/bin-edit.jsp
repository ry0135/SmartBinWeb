<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Sửa thùng rác #${bin.binID}</title>

  <!-- Bootstrap & Icons -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

  <style>
    /* ======= Light Green Theme - Clean & Modern ======= */
    :root{
      --primary-green:#22c55e;
      --secondary-green:#16a34a;
      --light-green:#f0fdf4;
      --border-green:#d1fae5;
      --text-green:#166534;
      --muted-green:#6b7280;
      --white:#ffffff;
      --light-gray:#f9fafb;
      --border-gray:#e5e7eb;
      --text-dark:#111827;
      --success:#10b981;
      --warning:#f59e0b;
      --danger:#ef4444;
    }

    html,body{
      height:100%;
      font-family:'Inter', system-ui, -apple-system, 'Segoe UI', Roboto, sans-serif;
    }

    body{
      margin:0;
      background: linear-gradient(135deg, #f0fdf4 0%, #ecfdf5 100%);
      color: var(--text-dark);
      overflow-y:auto;
      line-height: 1.6;
    }

    /* ======= Clean card design ======= */
    .main-card{
      background: var(--white);
      border-radius: 16px;
      border: 1px solid var(--border-green);
      box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -1px rgba(0, 0, 0, 0.03);
      padding: 32px;
      margin-top: 24px;
    }

    /* ======= Header styles ======= */
    .page-header{
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-bottom: 24px;
      padding: 24px 0;
    }

    .page-title{
      font-size: 28px;
      font-weight: 700;
      color: var(--text-dark);
      display: flex;
      align-items: center;
      gap: 12px;
      margin: 0;
    }

    .page-title i {
      color: var(--primary-green);
      font-size: 32px;
    }

    /* ======= Navigation button ======= */
    .btn-back{
      background: var(--white);
      border: 1px solid var(--border-gray);
      color: var(--muted-green);
      padding: 10px 20px;
      border-radius: 8px;
      text-decoration: none;
      font-weight: 500;
      transition: all 0.2s ease;
      display: inline-flex;
      align-items: center;
      gap: 8px;
    }

    .btn-back:hover{
      background: var(--light-gray);
      border-color: var(--primary-green);
      color: var(--primary-green);
    }

    /* ======= Info notice ======= */
    .info-notice{
      background: var(--light-green);
      border: 1px solid var(--border-green);
      border-radius: 8px;
      padding: 16px;
      margin-bottom: 24px;
      display: flex;
      align-items: center;
      gap: 12px;
    }

    .info-notice i {
      color: var(--primary-green);
      font-size: 18px;
    }

    .info-notice span {
      color: var(--text-green);
      font-size: 14px;
    }

    /* ======= Form styles ======= */
    .form-label{
      font-weight: 600;
      color: var(--text-dark);
      margin-bottom: 8px;
      font-size: 14px;
    }

    .form-label .required {
      color: var(--danger);
    }

    .form-control, .form-select{
      background: var(--white);
      border: 1px solid var(--border-gray);
      border-radius: 8px;
      padding: 12px 16px;
      font-size: 14px;
      color: var(--text-dark);
      transition: all 0.2s ease;
    }

    .form-control::placeholder{
      color: var(--muted-green);
      font-size: 14px;
    }

    .form-control:focus, .form-select:focus{
      background: var(--white);
      border-color: var(--primary-green);
      box-shadow: 0 0 0 3px rgba(34, 197, 94, 0.1);
      outline: none;
    }

    .form-text{
      color: var(--muted-green);
      font-size: 12px;
      margin-top: 4px;
    }

    .invalid-feedback{
      color: var(--danger);
      font-size: 12px;
      margin-top: 4px;
    }

    /* ======= Form validation states ======= */
    .form-control.is-valid, .form-select.is-valid {
      border-color: var(--success);
    }

    .form-control.is-invalid, .form-select.is-invalid {
      border-color: var(--danger);
    }

    /* ======= Readonly input ======= */
    .form-control[readonly] {
      background: var(--light-gray);
      color: var(--muted-green);
    }

    /* ======= Status select with colors ======= */
    .status-active { color: var(--success) !important; }
    .status-maintenance { color: var(--warning) !important; }
    .status-full { color: var(--danger) !important; }

    /* ======= Button styles ======= */
    .btn-primary{
      background: var(--primary-green);
      border: 1px solid var(--primary-green);
      color: var(--white);
      padding: 12px 24px;
      border-radius: 8px;
      font-weight: 600;
      font-size: 14px;
      transition: all 0.2s ease;
      display: inline-flex;
      align-items: center;
      gap: 8px;
    }

    .btn-primary:hover{
      background: var(--secondary-green);
      border-color: var(--secondary-green);
      transform: translateY(-1px);
      box-shadow: 0 4px 12px rgba(34, 197, 94, 0.3);
    }

    .btn-secondary{
      background: var(--white);
      border: 1px solid var(--border-gray);
      color: var(--muted-green);
      padding: 12px 24px;
      border-radius: 8px;
      font-weight: 500;
      font-size: 14px;
      transition: all 0.2s ease;
      text-decoration: none;
      display: inline-flex;
      align-items: center;
      gap: 8px;
    }

    .btn-secondary:hover{
      background: var(--light-gray);
      color: var(--text-dark);
    }

    /* ======= Alert styles ======= */
    .alert-danger {
      background: #fef2f2;
      border: 1px solid #fecaca;
      color: #b91c1c;
      border-radius: 8px;
      padding: 16px;
      display: flex;
      align-items: center;
      gap: 12px;
      margin-bottom: 24px;
    }

    /* ======= Layout ======= */
    .page-container{
      max-width: 1200px;
      margin: 0 auto;
      padding: 24px;
    }

    /* ======= Form grid ======= */
    .form-row {
      margin-bottom: 24px;
    }

    /* ======= Action buttons container ======= */
    .form-actions {
      margin-top: 32px;
      padding-top: 24px;
      border-top: 1px solid var(--border-gray);
      display: flex;
      gap: 16px;
      justify-content: flex-end;
    }

    /* ======= Responsive adjustments ======= */
    @media (max-width: 768px) {
      .page-header {
        flex-direction: column;
        align-items: flex-start;
        gap: 16px;
      }

      .main-card {
        padding: 24px 16px;
      }

      .form-actions {
        flex-direction: column-reverse;
      }

      .btn-primary, .btn-secondary {
        width: 100%;
        justify-content: center;
      }
    }
  </style>
</head>

<body>
<%@ include file="/WEB-INF/views/admin/header_admin.jsp" %>

<div class="page-container">
  <div class="page-header">
    <h1 class="page-title">
      <i class="bi bi-trash3"></i>
      Sửa thùng rác #${bin.binID}
    </h1>
    <a href="${pageContext.request.contextPath}/admin/bins/list" class="btn-back">
      <i class="bi bi-arrow-left"></i>
      Danh sách thùng
    </a>
  </div>

  <c:if test="${not empty error}">
    <div class="alert-danger">
      <i class="bi bi-exclamation-triangle"></i>
      <span>${error}</span>
    </div>
  </c:if>

  <div class="main-card">
    <div class="info-notice">
      <i class="bi bi-info-circle"></i>
      <span>Mã thùng (BinCode) sẽ được hệ thống tự sinh sau khi lưu.</span>
    </div>

    <form id="binForm" method="post" action="${pageContext.request.contextPath}/admin/bins/${bin.binID}/update" novalidate>
      <c:if test="${not empty _csrf}">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
      </c:if>

      <div class="row g-4">
        <!-- BinCode readonly -->
        <div class="col-md-4">
          <label class="form-label">Mã thùng (BinCode)</label>
          <input type="text" class="form-control" value="${bin.binCode}" readonly>
          <div class="form-text">Mã thùng được hệ thống tự sinh.</div>
        </div>

        <div class="col-md-8">
          <label class="form-label">Tên đường</label>
          <input type="text" name="street" class="form-control" maxlength="255" value="${bin.street}" placeholder="Nhập tên đường">
        </div>

        <div class="col-md-4">
          <label class="form-label">Phường <span class="required">*</span></label>
          <select name="wardID" id="wardID" class="form-select" required>
            <option value="">-- Chọn phường --</option>
            <c:forEach var="w" items="${wards}">
              <option value="${w.wardId}" ${w.wardId == bin.wardID ? 'selected="selected"' : ''}>
                  ${w.wardName}
              </option>
            </c:forEach>
          </select>
          <div class="invalid-feedback">Vui lòng chọn phường.</div>
        </div>

        <div class="col-md-4">
          <label class="form-label">Vĩ độ (Latitude)</label>
          <input type="number" step="0.000001" name="latitude" id="latitude" class="form-control" value="${bin.latitude}" placeholder="16.07177">
          <div class="form-text">Ví dụ: 16.07177</div>
          <div class="invalid-feedback">Vĩ độ hợp lệ nằm trong [-90, 90].</div>
        </div>

        <div class="col-md-4">
          <label class="form-label">Kinh độ (Longitude)</label>
          <input type="number" step="0.000001" name="longitude" id="longitude" class="form-control" value="${bin.longitude}" placeholder="108.22057">
          <div class="form-text">Ví dụ: 108.22057</div>
          <div class="invalid-feedback">Kinh độ hợp lệ nằm trong [-180, 180].</div>
        </div>

        <div class="col-md-4">
          <label class="form-label">Dung tích (lít) <span class="required">*</span></label>
          <input type="number" step="0.01" name="capacity" id="capacity" class="form-control" value="${bin.capacity}" placeholder="120">
          <div class="form-text">Dung tích tối đa của thùng</div>
          <div class="invalid-feedback">Dung tích phải lớn hơn 0.</div>
        </div>

        <div class="col-md-4">
          <label class="form-label">% đầy hiện tại</label>
          <input type="number" step="0.01" name="currentFill" id="currentFill" class="form-control" value="${bin.currentFill}" placeholder="0">
          <div class="form-text">Mức đầy hiện tại (%)</div>
          <div class="invalid-feedback">% đầy không được âm.</div>
        </div>

        <div class="col-md-4">
          <label class="form-label">Trạng thái</label>
          <select name="status" class="form-select">
            <option value="1" class="status-active" ${bin.status == 1 ? 'selected' : ''}>● Hoạt động</option>
            <option value="0" class="status-maintenance" ${bin.status == 0 ? 'selected' : ''}>● Bảo trì</option>
            <option value="2" class="status-full" ${bin.status == 2 ? 'selected' : ''}>● Đầy / Mất kết nối</option>
          </select>
        </div>
      </div>

      <div class="form-actions">
        <a href="${pageContext.request.contextPath}/admin/bins/list" class="btn-secondary">
          <i class="bi bi-x-lg"></i>
          Hủy
        </a>
        <button type="submit" class="btn-primary">
          <i class="bi bi-check-lg"></i>
          Lưu thùng rác
        </button>
      </div>
    </form>
  </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
  // Enhanced client-side validation
  (function () {
    const form  = document.getElementById('binForm');

    // Real-time validation
    const inputs = form.querySelectorAll('input, select');
    inputs.forEach(input => {
      input.addEventListener('blur', validateField);
      input.addEventListener('input', clearValidation);
    });

    function clearValidation(e) {
      e.target.classList.remove('is-invalid', 'is-valid');
    }

    function validateField(e) {
      const field = e.target;
      const value = field.value.trim();
      let isValid = true;

      switch(field.id) {
        case 'wardID':
          isValid = value !== '';
          break;
        case 'latitude':
          if (value) {
            const lat = parseFloat(value);
            isValid = !isNaN(lat) && lat >= -90 && lat <= 90;
          }
          break;
        case 'longitude':
          if (value) {
            const lng = parseFloat(value);
            isValid = !isNaN(lng) && lng >= -180 && lng <= 180;
          }
          break;
        case 'capacity':
          if (value) {
            const cap = parseFloat(value);
            isValid = !isNaN(cap) && cap > 0;
          }
          break;
        case 'currentFill':
          if (value) {
            const cf = parseFloat(value);
            isValid = !isNaN(cf) && cf >= 0;
          }
          break;
      }

      if (value !== '') {
        field.classList.toggle('is-invalid', !isValid);
        field.classList.toggle('is-valid', isValid);
      }
    }

    // Form submission validation
    form.addEventListener('submit', function (e) {
      let ok = true;
      const wardID = document.getElementById('wardID');
      const latEl  = document.getElementById('latitude');
      const lngEl  = document.getElementById('longitude');
      const capEl  = document.getElementById('capacity');
      const fillEl = document.getElementById('currentFill');

      // Validate required fields
      if (!wardID.value) {
        wardID.classList.add('is-invalid');
        ok = false;
      } else {
        wardID.classList.remove('is-invalid');
        wardID.classList.add('is-valid');
      }

      // Validate optional fields if filled
      if (latEl.value) {
        const lat = parseFloat(latEl.value);
        if (isNaN(lat) || lat < -90 || lat > 90) {
          latEl.classList.add('is-invalid');
          ok = false;
        } else {
          latEl.classList.remove('is-invalid');
          latEl.classList.add('is-valid');
        }
      }

      if (lngEl.value) {
        const lng = parseFloat(lngEl.value);
        if (isNaN(lng) || lng < -180 || lng > 180) {
          lngEl.classList.add('is-invalid');
          ok = false;
        } else {
          lngEl.classList.remove('is-invalid');
          lngEl.classList.add('is-valid');
        }
      }

      if (capEl.value) {
        const cap = parseFloat(capEl.value);
        if (isNaN(cap) || cap <= 0) {
          capEl.classList.add('is-invalid');
          ok = false;
        } else {
          capEl.classList.remove('is-invalid');
          capEl.classList.add('is-valid');
        }
      }

      if (fillEl.value) {
        const cf = parseFloat(fillEl.value);
        if (isNaN(cf) || cf < 0) {
          fillEl.classList.add('is-invalid');
          ok = false;
        } else {
          fillEl.classList.remove('is-invalid');
          fillEl.classList.add('is-valid');
        }
      }

      if (!ok) {
        e.preventDefault();
        e.stopPropagation();

        // Smooth scroll to first invalid field
        const firstInvalid = form.querySelector('.is-invalid');
        if (firstInvalid) {
          firstInvalid.scrollIntoView({ behavior: 'smooth', block: 'center' });
          setTimeout(() => firstInvalid.focus(), 300);
        }
      }
    });
  })();
</script>
</body>
</html>