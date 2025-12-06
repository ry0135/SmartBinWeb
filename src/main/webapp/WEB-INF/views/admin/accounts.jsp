<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <title>Quản trị tài khoản</title>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet"/>

  <style>
    :root{
      --primary-green:#22c55e; --secondary-green:#16a34a;
      --light-green:#f0fdf4; --border-green:#bbf7d0;
      --text-green:#166534; --muted:#6b7280;
    }
    .sb-card{border:1px solid var(--border-green);border-radius:16px;overflow:hidden;background:#fff}
    .sb-card .card-header{background:var(--light-green);border-bottom:1px solid var(--border-green)}
    .btn-apply{background:var(--primary-green);color:#fff;border-color:var(--secondary-green)}
    .btn-apply:hover{background:var(--secondary-green);color:#fff}
    .role-stack > .sb-card{margin-bottom:18px} /* xếp DỌC */
  </style>
</head>
<body>
<jsp:include page="header_admin.jsp"/>

<!-- ✅ Đẩy toàn bộ nội dung sang phải 250px để không bị sidebar đè -->
<div style="margin-left: 250px;">

  <div class="container my-4" style="max-width:1200px;">
    <h3 class="mb-2"><i class="fa-solid fa-users-gear text-success me-2"></i>Quản trị tài khoản</h3>

    <!-- Flash -->
    <c:if test="${not empty success}">
      <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="fa-solid fa-check-circle me-2"></i>${success}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      </div>
    </c:if>
    <c:if test="${not empty error}">
      <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="fa-solid fa-circle-exclamation me-2"></i>${error}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      </div>
    </c:if>

    <!-- Filter -->
    <form class="row g-2 mb-3" method="get" action="${pageContext.request.contextPath}/admin/accounts">
      <div class="col-12 col-md-3">
        <label class="form-label">Trạng thái</label>
        <select class="form-select" name="status">
          <option value=""  <c:if test="${status == null}">selected</c:if>>All</option>
          <option value="1" <c:if test="${status == 1}">selected</c:if>>Active</option>
          <option value="0" <c:if test="${status == 0}">selected</c:if>>Banned</option>
        </select>
      </div>
      <div class="col-12 col-md-6">
        <label class="form-label">Tìm (Email/Tên)</label>
        <input class="form-control" name="q" value="${fn:escapeXml(q)}" placeholder="Nhập email hoặc tên người dùng..."/>
      </div>
      <div class="col-12 col-md-3 d-flex align-items-end gap-2">
        <button class="btn btn-apply w-50" type="submit"><i class="fa-solid fa-filter me-1"></i>Apply</button>
        <a class="btn btn-outline-success w-50" href="${pageContext.request.contextPath}/admin/accounts">
          <i class="fa-solid fa-rotate-left me-1"></i>Reset
        </a>
      </div>
    </form>

    <!-- 3 khung xếp DỌC -->
    <div class="role-stack">

      <!-- MANAGERS -->
      <div class="sb-card" id="managers">
        <div class="card-header d-flex justify-content-between align-items-center px-3 py-2">
          <strong><i class="fa-solid fa-user-tie me-2"></i>Managers</strong>
          <span class="text-muted">Tổng: ${managers.totalElements}</span>
        </div>
        <div class="card-body p-0">
          <jsp:include page="accounts-role-table.jsp">
            <jsp:param name="baseUrl" value="${pageContext.request.contextPath}/admin/accounts/managers"/>
            <jsp:param name="pageObj" value="managers"/>
            <jsp:param name="anchor"  value="managers"/>
          </jsp:include>
        </div>
      </div>

      <!-- WORKERS -->
      <div class="sb-card" id="workers">
        <div class="card-header d-flex justify-content-between align-items-center px-3 py-2">
          <strong><i class="fa-solid fa-people-group me-2"></i>Workers</strong>
          <span class="text-muted">Tổng: ${workers.totalElements}</span>
        </div>
        <div class="card-body p-0">
          <jsp:include page="accounts-role-table.jsp">
            <jsp:param name="baseUrl" value="${pageContext.request.contextPath}/admin/accounts/workers"/>
            <jsp:param name="pageObj" value="workers"/>
            <jsp:param name="anchor"  value="workers"/>
          </jsp:include>
        </div>
      </div>

      <!-- USERS -->
      <div class="sb-card" id="users">
        <div class="card-header d-flex justify-content-between align-items-center px-3 py-2">
          <strong><i class="fa-solid fa-user me-2"></i>Users</strong>
          <span class="text-muted">Tổng: ${users.totalElements}</span>
        </div>
        <div class="card-body p-0">
          <jsp:include page="accounts-role-table.jsp">
            <jsp:param name="baseUrl" value="${pageContext.request.contextPath}/admin/accounts/users"/>
            <jsp:param name="pageObj" value="users"/>
            <jsp:param name="anchor"  value="users"/>
          </jsp:include>
        </div>
      </div>

    </div>
  </div>

</div> <!-- end main-content margin-left:250px -->

<!-- ===== Modal BAN dùng CHUNG (chỉ 1 cái) ===== -->
<div class="modal fade" id="banModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <form id="banForm" class="modal-content" method="post" action="">
      <div class="modal-header">
        <h5 class="modal-title"><i class="fa-solid fa-triangle-exclamation text-warning me-2"></i>Ban tài khoản</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>

      <div class="modal-body">
        <div class="mb-2 text-muted" id="banTargetInfo"></div>
        <label class="form-label">Lý do (tối thiểu 10 ký tự)</label>
        <textarea class="form-control" name="reason" rows="4" minlength="10" required></textarea>
      </div>

      <div class="modal-footer">
        <sec:csrfInput/>
        <!-- giữ filter hiện tại -->
        <c:if test="${status != null}">
          <input type="hidden" name="status" value="${status}"/>
        </c:if>
        <c:if test="${not empty q}">
          <input type="hidden" name="q" value="${fn:escapeXml(q)}"/>
        </c:if>

        <!-- chỗ để script bơm hidden pageM/pageW/pageU -->
        <span id="banExtra"></span>

        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Hủy</button>
        <button type="submit" class="btn btn-danger"><i class="fa-solid fa-ban me-1"></i>Xác nhận Ban</button>
      </div>
    </form>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
  // Modal dùng chung – lấy dữ liệu từ nút đã click
  document.addEventListener('DOMContentLoaded', function () {
    var modalEl = document.getElementById('banModal');
    if (!modalEl) return;

    modalEl.addEventListener('show.bs.modal', function (e) {
      var btn   = e.relatedTarget;           // nút Ban vừa click
      if (!btn) return;

      var id    = btn.getAttribute('data-id');
      var name  = btn.getAttribute('data-name') || ('#' + id);
      var base  = btn.getAttribute('data-base');   // /admin/accounts/{role}
      var role  = btn.getAttribute('data-role');   // managers | workers | users
      var page  = btn.getAttribute('data-page');   // số trang hiện tại của cột đó

      // cập nhật UI + action
      document.getElementById('banTargetInfo').textContent = 'ID: ' + id + ' • ' + name + ' • ' + role;
      document.getElementById('banForm').action = base + '/' + id + '/ban';

      // bơm hidden pageX tương ứng để giữ pagination
      var extra = document.getElementById('banExtra');
      extra.innerHTML = '';
      if (role === 'managers') extra.innerHTML = '<input type="hidden" name="pageM" value="'+page+'">';
      if (role === 'workers')  extra.innerHTML = '<input type="hidden" name="pageW" value="'+page+'">';
      if (role === 'users')    extra.innerHTML = '<input type="hidden" name="pageU" value="'+page+'">';

      // reset textarea
      modalEl.querySelector('textarea[name="reason"]').value = '';
    });
  });
</script>
</body>
</html>
