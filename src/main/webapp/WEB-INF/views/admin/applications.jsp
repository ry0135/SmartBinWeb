<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"/>
  <title>Đơn đăng ký Manager - SmartBin (Admin)</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <!-- Bootstrap & Icons & Font -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet"/>

  <style>
    :root{
      --primary-green:#22c55e;
      --secondary-green:#16a34a;
      --light-green:#f0fdf4;
      --border-green:#d1fae5;
      --text-green:#166534;
      --muted-green:#6b7280;
      --white:#ffffff;
      --border-gray:#e5e7eb;
      --text-dark:#111827;
    }
    *{ box-sizing: border-box; }
    html, body{ height:100%; }
    body{
      margin:0; font-family:'Inter', system-ui, -apple-system, 'Segoe UI', Roboto, sans-serif;
      background: linear-gradient(135deg, #f0fdf4 0%, #ecfdf5 40%, #d1fae5 100%);
      color: var(--text-dark);
    }
    /* Background pattern */
    .background-pattern{
      position: fixed; inset: 0; z-index: -1;
      background-image:
              radial-gradient(circle at 25% 25%, rgba(34,197,94,0.10) 0%, transparent 50%),
              radial-gradient(circle at 75% 75%, rgba(16,185,129,0.08) 0%, transparent 50%),
              radial-gradient(circle at 50% 50%, rgba(34,197,94,0.05) 0%, transparent 70%);
      background-size: 600px 600px, 800px 800px, 1000px 1000px;
      animation: float 20s ease-in-out infinite;
    }
    @keyframes float{
      0%,100%{ transform: translate(0,0) rotate(0); }
      33%{ transform: translate(30px,-30px) rotate(1deg); }
      66%{ transform: translate(-20px,20px) rotate(-1deg); }
    }

    /* Wrapper */
    .page-wrap{ padding: 24px; }

    /* Card */
    .sb-card{
      background: var(--white);
      border: 1px solid var(--border-gray);
      border-radius: 20px;
      box-shadow: 0 20px 25px -5px rgba(0,0,0,.1), 0 10px 10px -5px rgba(0,0,0,.04);
      padding: 24px;
      position: relative; overflow: hidden;
    }
    .sb-card::before{
      content:''; position:absolute; top:0; left:0; right:0; height:4px;
      background: linear-gradient(90deg, var(--primary-green), var(--secondary-green));
    }

    /* Section header */
    .section-header{
      display:flex; align-items:center; justify-content:space-between; gap:12px; flex-wrap:wrap;
      margin-bottom: 12px;
    }
    .section-title{
      margin:0; font-size:18px; font-weight:700; letter-spacing:-.01em;
    }
    .muted{ color: var(--muted-green); }

    /* Badges */
    .badge-pill{
      border-radius: 999px; padding: .35rem .6rem; font-weight:600;
    }
    .badge-pending{ background: #fef3c7; color: #92400e; border:1px solid #fde68a; }
    .badge-approved{ background: #dcfce7; color: #166534; border:1px solid #86efac; }
    .badge-rejected{ background: #fee2e2; color: #991b1b; border:1px solid #fecaca; }

    /* Table */
    .table thead th{
      font-weight:600; color:#374151; border-bottom: 1px solid var(--border-gray);
      background: #f9fafb;
    }
    .table tbody td{ vertical-align: middle; }
    .table-hover tbody tr:hover{ background: #f9fafb; }

    /* Buttons */
    .btn-primary{
      --bs-btn-bg: var(--primary-green);
      --bs-btn-border-color: var(--primary-green);
      --bs-btn-hover-bg: var(--secondary-green);
      --bs-btn-hover-border-color: var(--secondary-green);
      border-radius:10px; font-weight:600;
    }
    .btn-outline-secondary{
      border-radius:10px; font-weight:600;
    }

    /* Search input */
    .search-input{
      max-width: 360px;
      border-radius: 10px;
      border: 1px solid var(--border-gray);
    }
    .search-input:focus{
      border-color: var(--primary-green);
      box-shadow: 0 0 0 3px rgba(34,197,94,.1);
    }

    /* Responsive */
    @media (max-width: 768px){
      .page-wrap{ padding: 16px; }
      .sb-card{ padding: 16px; border-radius: 16px; }
    }
  </style>
</head>
<body>
<div class="background-pattern"></div>

<jsp:include page="header_admin.jsp"/>

<div class="page-wrap container">
  <!-- Header tổng quan -->
  <div class="sb-card mb-4">
    <div class="d-flex align-items-center justify-content-between flex-wrap gap-3">
      <div>
        <h3 class="mb-1" style="letter-spacing:-.02em;">Đơn đăng ký Manager</h3>
        <div class="muted">Quản trị & duyệt hồ sơ ứng viên Manager</div>
      </div>
      <div class="d-flex align-items-center gap-2">
                <span class="badge-pill badge-pending">
                    <i class="bi bi-hourglass-split"></i>
                    <span class="ms-1">Chờ duyệt:</span>
                    <strong class="ms-1"><c:out value="${fn:length(pending)}"/></strong>
                </span>
        <span class="badge-pill badge-approved">
                    <i class="bi bi-check2-circle"></i>
                    <span class="ms-1">Đã duyệt:</span>
                    <strong class="ms-1"><c:out value="${fn:length(approved)}"/></strong>
                </span>
        <span class="badge-pill badge-rejected">
                    <i class="bi bi-x-circle"></i>
                    <span class="ms-1">Từ chối:</span>
                    <strong class="ms-1"><c:out value="${fn:length(rejected)}"/></strong>
                </span>
      </div>
    </div>

    <div class="mt-3 d-flex align-items-center gap-2">
      <div class="input-group search-input">
        <span class="input-group-text bg-white border-0"><i class="bi bi-search"></i></span>
        <input type="text" id="q" class="form-control border-0" placeholder="Tìm theo họ tên hoặc email...">
      </div>
      <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/admin/applications/export">
        <i class="bi bi-download"></i> Xuất danh sách
      </a>
    </div>

    <c:if test="${not empty error}">
      <div class="alert alert-danger mt-3 mb-0" role="alert">
        <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
      </div>
    </c:if>
  </div>

  <!-- Bảng CHỜ DUYỆT -->
  <div class="sb-card mb-4">
    <div class="section-header">
      <h4 class="section-title"><i class="bi bi-hourglass-split me-2"></i>Đang chờ duyệt</h4>
      <span class="muted">Có <strong>${fn:length(pending)}</strong> đơn</span>
    </div>
    <div class="table-responsive">
      <table class="table table-sm table-hover align-middle" id="tbl-pending">
        <thead>
        <tr>
          <th style="width:80px;">ID</th>
          <th>Họ tên</th>
          <th>Email</th>
          <th style="width:200px;">Ngày nộp</th>
          <th style="width:120px;"></th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="a" items="${pending}">
          <tr>
            <td>${a.applicationId}</td>
            <td>${a.fullName}</td>
            <td>${a.email}</td>
            <td><fmt:formatDate value="${a.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
            <td class="text-end">
              <a class="btn btn-sm btn-primary"
                 href="${pageContext.request.contextPath}/admin/applications/${a.applicationId}">
                <i class="bi bi-eye"></i> Xem
              </a>
            </td>
          </tr>
        </c:forEach>
        <c:if test="${fn:length(pending) == 0}">
          <tr><td colspan="5" class="text-center text-muted py-3">Không có đơn chờ duyệt</td></tr>
        </c:if>
        </tbody>
      </table>
    </div>
  </div>

  <!-- Bảng ĐÃ DUYỆT -->
  <div class="sb-card mb-4">
    <div class="section-header">
      <h4 class="section-title"><i class="bi bi-check2-circle me-2"></i>Đã duyệt</h4>
      <span class="muted">Có <strong>${fn:length(approved)}</strong> đơn</span>
    </div>
    <div class="table-responsive">
      <table class="table table-sm table-hover align-middle" id="tbl-approved">
        <thead>
        <tr>
          <th style="width:80px;">ID</th>
          <th>Họ tên</th>
          <th>Email</th>
          <th style="width:200px;">Ngày nộp</th>
          <th style="width:120px;"></th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="a" items="${approved}">
          <tr>
            <td>${a.applicationId}</td>
            <td>${a.fullName}</td>
            <td>${a.email}</td>
            <td><fmt:formatDate value="${a.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
            <td class="text-end">
              <a class="btn btn-sm btn-outline-secondary"
                 href="${pageContext.request.contextPath}/admin/applications/${a.applicationId}">
                <i class="bi bi-eye"></i> Xem
              </a>
            </td>
          </tr>
        </c:forEach>
        <c:if test="${fn:length(approved) == 0}">
          <tr><td colspan="5" class="text-center text-muted py-3">Chưa có đơn đã duyệt</td></tr>
        </c:if>
        </tbody>
      </table>
    </div>
  </div>

  <!-- Bảng ĐÃ TỪ CHỐI -->
  <div class="sb-card mb-4">
    <div class="section-header">
      <h4 class="section-title"><i class="bi bi-x-circle me-2"></i>Đã từ chối</h4>
      <span class="muted">Có <strong>${fn:length(rejected)}</strong> đơn</span>
    </div>
    <div class="table-responsive">
      <table class="table table-sm table-hover align-middle" id="tbl-rejected">
        <thead>
        <tr>
          <th style="width:80px;">ID</th>
          <th>Họ tên</th>
          <th>Email</th>
          <th style="width:200px;">Ngày nộp</th>
          <th style="width:120px;"></th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="a" items="${rejected}">
          <tr>
            <td>${a.applicationId}</td>
            <td>${a.fullName}</td>
            <td>${a.email}</td>
            <td><fmt:formatDate value="${a.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
            <td class="text-end">
              <a class="btn btn-sm btn-outline-secondary"
                 href="${pageContext.request.contextPath}/admin/applications/${a.applicationId}">
                <i class="bi bi-eye"></i> Xem
              </a>
            </td>
          </tr>
        </c:forEach>
        <c:if test="${fn:length(rejected) == 0}">
          <tr><td colspan="5" class="text-center text-muted py-3">Chưa có đơn bị từ chối</td></tr>
        </c:if>
        </tbody>
      </table>
    </div>
  </div>
</div>

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
  // Search: lọc cả 3 bảng theo tên/email
  const q = document.getElementById('q');
  const tables = ['tbl-pending','tbl-approved','tbl-rejected'].map(id => document.getElementById(id).querySelector('tbody'));

  function normalize(str){ return (str || '').toLowerCase().normalize('NFKD'); }

  q.addEventListener('input', function(){
    const term = normalize(this.value.trim());
    tables.forEach(tbody=>{
      const rows = tbody.querySelectorAll('tr');
      rows.forEach(row=>{
        // bỏ qua hàng "không có dữ liệu"
        if(row.querySelector('td[colspan]')) return;
        const name  = normalize(row.children[1]?.innerText);
        const email = normalize(row.children[2]?.innerText);
        const match = !term || name.includes(term) || email.includes(term);
        row.style.display = match ? '' : 'none';
      });
    });
  });
</script>
</body>
</html>
