<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <title>Chi tiết đơn đăng ký - SmartBin (Admin)</title>
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

        /* Wrapper & card */
        .page-wrap{ padding: 24px; }
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

        /* Header */
        .title{
            margin:0; letter-spacing:-.02em; font-weight:700;
        }
        .muted{ color: var(--muted-green); }

        /* Badge trạng thái */
        .badge-pill{ border-radius:999px; padding:.35rem .6rem; font-weight:600; }
        .badge-pending{ background:#fef3c7; color:#92400e; border:1px solid #fde68a; }
        .badge-approved{ background:#dcfce7; color:#166534; border:1px solid #86efac; }
        .badge-rejected{ background:#fee2e2; color:#991b1b; border:1px solid #fecaca; }

        /* Table detail */
        .detail-table th{
            width: 220px; background:#f9fafb; color:#374151; font-weight:600;
            border-bottom:1px solid var(--border-gray);
        }
        .detail-table td{
            border-bottom:1px solid var(--border-gray);
        }

        /* Buttons */
        .btn-success{
            --bs-btn-bg: var(--primary-green);
            --bs-btn-border-color: var(--primary-green);
            --bs-btn-hover-bg: var(--secondary-green);
            --bs-btn-hover-border-color: var(--secondary-green);
            border-radius:10px; font-weight:600;
        }
        .btn-danger{ border-radius:10px; font-weight:600; }
        .btn-outline-primary, .btn-outline-secondary{ border-radius:10px; }

        /* Alerts */
        .alert{ border-radius:10px; border:none; }
        .alert-success{ background:var(--light-green); color:var(--text-green); border:1px solid var(--border-green); }
        .alert-warning{ background:#fff7ed; color:#9a3412; border:1px solid #fed7aa; }
        .alert-danger{ background:#fef2f2; color:#b91c1c; border:1px solid #fecaca; }

        @media (max-width: 768px){
            .page-wrap{ padding: 16px; }
            .sb-card{ padding: 16px; border-radius: 16px; }
        }
    </style>
</head>
<body>
<div class="background-pattern"></div>

<jsp:include page="header_admin.jsp"/>

<div class="page-wrap container" style="max-width: 920px;">
    <!-- Banner trạng thái & tiêu đề -->
    <div class="sb-card mb-4">
        <div class="d-flex align-items-start justify-content-between flex-wrap gap-3">
            <div>
                <h3 class="title">Chi tiết đơn #<c:out value="${app.applicationId}"/></h3>
                <div class="muted">
                    Nộp lúc
                    <strong><fmt:formatDate value="${app.createdAt}" pattern="dd/MM/yyyy HH:mm"/></strong>
                </div>
            </div>
            <div>
                <c:choose>
                    <c:when test="${app.status == 0}">
                        <span class="badge-pill badge-pending"><i class="bi bi-hourglass-split"></i> Pending</span>
                    </c:when>
                    <c:when test="${app.status == 2}">
                        <span class="badge-pill badge-approved"><i class="bi bi-check2-circle"></i> Approved</span>
                    </c:when>
                    <c:when test="${app.status == 3}">
                        <span class="badge-pill badge-rejected"><i class="bi bi-x-circle"></i> Rejected</span>
                    </c:when>
                    <c:otherwise>
                        <span class="badge-pill badge-pending">Trạng thái: ${app.status}</span>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Alerts -->
        <c:if test="${not empty param.approved}">
            <div class="alert alert-success mt-3 mb-0" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>Đã approve và tạo account Manager.
            </div>
        </c:if>
        <c:if test="${not empty param.rejected}">
            <div class="alert alert-warning mt-3 mb-0" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>Đã từ chối đơn đăng ký.
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger mt-3 mb-0" role="alert">
                <i class="bi bi-x-octagon-fill me-2"></i>${error}
            </div>
        </c:if>
    </div>

    <!-- Thông tin chi tiết -->
    <div class="sb-card mb-4">
        <table class="table detail-table align-middle">
            <tbody>
            <tr><th>Họ tên</th><td>${app.fullName}</td></tr>
            <tr><th>Email cá nhân</th><td>${app.email}</td></tr>
            <tr><th>SĐT</th><td>${app.phone}</td></tr>
            <tr><th>Địa chỉ</th><td>${app.address}</td></tr>
            <tr><th>Phường</th><td>${ward != null ? ward.wardName : app.wardID}</td></tr>
            <tr><th>Ngày nộp</th><td><fmt:formatDate value="${app.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td></tr>
            <tr>
                <th>Trạng thái</th>
                <td>
                    <c:choose>
                        <c:when test="${app.status == 0}">Pending</c:when>
                        <c:when test="${app.status == 2}">Approved</c:when>
                        <c:when test="${app.status == 3}">Rejected</c:when>
                        <c:otherwise>${app.status}</c:otherwise>
                    </c:choose>
                </td>
            </tr>
            <tr><th>Ghi chú Admin</th><td>${app.adminNotes}</td></tr>
            <tr><th>Lý do từ chối</th><td>${app.rejectionReason}</td></tr>
            <tr>
                <th>Hợp đồng</th>
                <td>
                    <c:if test="${not empty app.contractPath}">
                        <a class="btn btn-sm btn-outline-primary"
                           href="${app.contractPath}" target="_blank">
                            <i class="bi bi-download"></i> Tải hợp đồng
                        </a>
                    </c:if>
                </td>
            </tr>
            <tr>
                <th>CMND/CCCD</th>
                <td>
                    <c:if test="${not empty app.cmndPath}">
                        <a class="btn btn-sm btn-outline-secondary"
                           href="${app.cmndPath}" target="_blank">
                            <i class="bi bi-file-earmark-arrow-down"></i> Tải CMND/CCCD
                        </a>
                    </c:if>
                </td>
            </tr>
            </tbody>
        </table>
    </div>

    <!-- Hành động (chỉ khi Pending) -->
    <c:if test="${app.status == 0}">
        <div class="sb-card">
            <div class="row g-3">
                <div class="col-12 col-lg-6">
                    <form class="mb-0"
                          action="${pageContext.request.contextPath}/admin/applications/${app.applicationId}/approve"
                          method="post">
                        <div class="mb-2">
                            <label class="form-label">Ghi chú (tuỳ chọn)</label>
                            <textarea name="adminNotes" class="form-control" rows="2"
                                      placeholder="Ví dụ: Đủ điều kiện, tạo account ngay."></textarea>
                        </div>
                        <c:if test="${_csrf != null}">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        </c:if>
                        <button class="btn btn-success w-100">
                            <i class="bi bi-person-check"></i> Approve & Tạo Account
                        </button>
                    </form>
                </div>

                <div class="col-12 col-lg-6">
                    <form id="rejectForm" class="mb-0"
                          action="${pageContext.request.contextPath}/admin/applications/${app.applicationId}/reject"
                          method="post">
                        <div class="mb-2">
                            <label class="form-label">Lý do từ chối</label>
                            <textarea name="reason" class="form-control" rows="2" required
                                      placeholder="Vui lòng nêu rõ lý do từ chối."></textarea>
                        </div>
                        <c:if test="${_csrf != null}">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        </c:if>
                        <button class="btn btn-danger w-100" id="btnReject">
                            <i class="bi bi-x-circle"></i> Reject
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </c:if>

    <div class="text-center my-4">
        <a class="btn btn-outline-secondary"
           href="${pageContext.request.contextPath}/admin/applications">
            <i class="bi bi-arrow-left"></i> Quay lại danh sách
        </a>
    </div>
</div>

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Auto-dismiss alerts sau 5s
    document.addEventListener('DOMContentLoaded', function() {
        document.querySelectorAll('.alert').forEach(alert => {
            setTimeout(() => {
                alert.style.opacity = '0';
                alert.style.transform = 'translateY(-6px)';
                setTimeout(() => alert.remove(), 300);
            }, 5000);
        });
    });

    // Xác nhận Reject
    const rejectForm = document.getElementById('rejectForm');
    if (rejectForm) {
        rejectForm.addEventListener('submit', function(e){
            const reason = this.querySelector('textarea[name="reason"]').value.trim();
            if(!confirm('Xác nhận từ chối đơn này?' + (reason ? '\nLý do: ' + reason : ''))) {
                e.preventDefault();
            }
        });
    }
</script>
</body>
</html>
