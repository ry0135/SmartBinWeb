<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Danh sách thùng rác</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        /* ===== Light Green Theme - Clean & Modern ===== */
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
            --info:#3b82f6;
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

        /* ===== Page Layout ===== */
        .page-container{
            max-width: 1400px;
            margin: 0 auto;
            padding: 24px;
        }

        /* ===== Header Section ===== */
        .page-header{
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 24px;
            flex-wrap: wrap;
            gap: 16px;
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

        .header-actions {
            display: flex;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
        }

        /* ===== Search Input ===== */
        .search-input{
            min-width: 280px;
            background: var(--white);
            border: 1px solid var(--border-gray);
            border-radius: 8px;
            padding: 10px 16px;
            color: var(--text-dark);
            font-size: 14px;
            transition: all 0.2s ease;
        }

        .search-input::placeholder{
            color: var(--muted-green);
        }

        .search-input:focus{
            background: var(--white);
            border-color: var(--primary-green);
            box-shadow: 0 0 0 3px rgba(34, 197, 94, 0.1);
            outline: none;
        }

        /* ===== Buttons ===== */
        .btn-primary{
            background: var(--primary-green);
            border: 1px solid var(--primary-green);
            color: var(--white);
            padding: 10px 20px;
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

        .btn-outline-primary{
            color: var(--primary-green);
            border-color: var(--primary-green);
            background: transparent;
            padding: 6px 12px;
            font-size: 12px;
            border-radius: 6px;
            font-weight: 500;
            transition: all 0.2s ease;
        }

        .btn-outline-primary:hover{
            background: var(--light-green);
            color: var(--primary-green);
            border-color: var(--primary-green);
        }

        .btn-outline-danger{
            color: var(--danger);
            border-color: var(--danger);
            background: transparent;
            padding: 6px 12px;
            font-size: 12px;
            border-radius: 6px;
            font-weight: 500;
            transition: all 0.2s ease;
        }

        .btn-outline-danger:hover{
            background: #fef2f2;
            color: var(--danger);
            border-color: var(--danger);
        }

        /* ===== Main Card ===== */
        .main-card{
            background: var(--white);
            border-radius: 16px;
            border: 1px solid var(--border-green);
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -1px rgba(0, 0, 0, 0.03);
            overflow: hidden;
        }

        /* ===== Table Styling ===== */
        .table-container {
            overflow-x: auto;
        }

        table.table{
            color: var(--text-dark);
            margin-bottom: 0;
            font-size: 14px;
        }

        .table thead{
            background: var(--light-green);
            color: var(--text-green);
        }

        .table thead th{
            white-space: nowrap;
            border-color: var(--border-green) !important;
            font-weight: 600;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.025em;
            padding: 16px 12px;
        }

        .table tbody td{
            border-color: var(--border-gray) !important;
            padding: 14px 12px;
            vertical-align: middle;
        }

        .table tbody tr:hover {
            background: var(--light-gray);
        }

        /* ===== Status Badges ===== */
        .badge{
            padding: 6px 10px;
            font-size: 11px;
            font-weight: 600;
            border-radius: 6px;
            text-transform: uppercase;
            letter-spacing: 0.025em;
        }

        .badge.bg-success{
            background: var(--success) !important;
            color: white;
        }

        .badge.bg-warning{
            background: var(--warning) !important;
            color: #111 !important;
        }

        .badge.bg-danger{
            background: var(--danger) !important;
            color: white;
        }

        /* ===== Alert Messages ===== */
        .alert{
            border: 1px solid;
            border-radius: 8px;
            padding: 16px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .alert-success {
            background: #f0fdf4;
            border-color: var(--border-green);
            color: var(--text-green);
        }

        .alert-danger {
            background: #fef2f2;
            border-color: #fecaca;
            color: #b91c1c;
        }

        /* ===== Empty State ===== */
        .empty-state {
            text-align: center;
            padding: 48px 24px;
            color: var(--muted-green);
        }

        .empty-state i {
            font-size: 48px;
            color: var(--border-green);
            margin-bottom: 16px;
        }

        /* ===== Action Buttons Container ===== */
        .action-buttons {
            display: flex;
            gap: 6px;
            justify-content: flex-end;
        }

        /* ===== Responsive Design ===== */
        @media (max-width: 768px) {
            .page-header {
                flex-direction: column;
                align-items: stretch;
            }

            .header-actions {
                flex-direction: column;
                align-items: stretch;
            }

            .search-input {
                min-width: auto;
                width: 100%;
            }

            .action-buttons {
                flex-direction: column;
            }

            .btn-outline-primary,
            .btn-outline-danger {
                font-size: 14px;
                padding: 8px 16px;
            }
        }

        /* ===== Loading State (for future use) ===== */
        .loading {
            opacity: 0.6;
            pointer-events: none;
        }

        /* ===== Data Formatting ===== */
        .fw-semibold {
            font-weight: 600;
            color: var(--primary-green);
        }

        .text-muted {
            color: var(--muted-green) !important;
        }

        /* ===== Statistics Cards (future enhancement) ===== */
        .stats-card {
            background: var(--white);
            border: 1px solid var(--border-gray);
            border-radius: 12px;
            padding: 20px;
            text-align: center;
        }

        .stats-card h4 {
            color: var(--primary-green);
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 4px;
        }

        .stats-card p {
            color: var(--muted-green);
            margin: 0;
            font-size: 14px;
        }
    </style>
</head>
<body>
<%@ include file="/WEB-INF/views/admin/header_admin.jsp" %>

<div class="page-container">
    <div class="page-header">
        <h1 class="page-title">
            <i class="bi bi-trash3"></i>
            Danh sách thùng rác
        </h1>

        <div class="header-actions">
            <input id="quickSearch" class="search-input" placeholder="Tìm kiếm mã, đường, phường...">
            <a href="${pageContext.request.contextPath}/admin/bins/new" class="btn btn-primary">
                <i class="bi bi-plus-circle"></i>
                Thêm thùng rác
            </a>
        </div>
    </div>

    <!-- Flash messages -->
    <c:if test="${not empty success}">
        <div class="alert alert-success">
            <i class="bi bi-check-circle"></i>
            <span>${success}</span>
        </div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger">
            <i class="bi bi-exclamation-triangle"></i>
            <span>${error}</span>
        </div>
    </c:if>

    <div class="main-card">
        <div class="table-container">
            <table id="binsTable" class="table align-middle">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Mã thùng</th>
                    <th>Đường</th>
                    <th>Phường</th>
                    <th>Tỉnh/TP</th>
                    <th class="text-end">Dung tích</th>
                    <th class="text-end">% đầy</th>
                    <th>Trạng thái</th>
                    <th>Cập nhật</th>
                    <th class="text-center">Hành động</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${not empty bins}">
                        <c:forEach var="b" items="${bins}">
                            <tr>
                                <td>
                                    <span class="text-muted">#${b.binID}</span>
                                </td>
                                <td>
                                    <span class="fw-semibold">${b.binCode}</span>
                                </td>
                                <td>${b.street}</td>
                                <td>${b.wardName}</td>
                                <td>${b.city}</td>
                                <td class="text-end">
                                    <c:choose>
                                        <c:when test="${not empty b.capacity}">
                                            <fmt:formatNumber value="${b.capacity}" maxFractionDigits="2"/> L
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">-</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-end">
                                    <c:choose>
                                        <c:when test="${not empty b.currentFill}">
                                            <fmt:formatNumber value="${b.currentFill}" maxFractionDigits="1"/>%
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">-</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${b.status == 1}">
                                            <span class="badge bg-success">
                                                <i class="bi bi-check-circle me-1"></i>Hoạt động
                                            </span>
                                        </c:when>
                                        <c:when test="${b.status == 0}">
                                            <span class="badge bg-warning">
                                                <i class="bi bi-tools me-1"></i>Bảo trì
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-danger">
                                                <i class="bi bi-x-circle me-1"></i>Lỗi
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty b.lastUpdated}">
                                            <small class="text-muted">
                                                <fmt:formatDate value="${b.lastUpdated}" pattern="dd/MM/yyyy"/>
                                                <br>
                                                <fmt:formatDate value="${b.lastUpdated}" pattern="HH:mm"/>
                                            </small>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">-</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="action-buttons">
                                        <a class="btn btn-sm btn-outline-primary"
                                           href="${pageContext.request.contextPath}/admin/bins/${b.binID}/edit"
                                           title="Chỉnh sửa">
                                            <i class="bi bi-pencil"></i>
                                        </a>

                                        <form method="post"
                                              action="${pageContext.request.contextPath}/admin/bins/${b.binID}/delete"
                                              style="display:inline"
                                              onsubmit="return confirm('Bạn có chắc chắn muốn xóa thùng rác ${b.binCode}?\n\nThao tác này không thể hoàn tác.');">
                                            <c:if test="${not empty _csrf}">
                                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                            </c:if>
                                            <button class="btn btn-sm btn-outline-danger" title="Xóa">
                                                <i class="bi bi-trash3"></i>
                                            </button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="10">
                                <div class="empty-state">
                                    <i class="bi bi-inbox"></i>
                                    <h5>Chưa có thùng rác nào</h5>
                                    <p class="text-muted">Bắt đầu bằng cách thêm thùng rác đầu tiên của bạn.</p>
                                    <a href="${pageContext.request.contextPath}/admin/bins/new" class="btn btn-primary mt-3">
                                        <i class="bi bi-plus-circle me-1"></i>
                                        Thêm thùng rác
                                    </a>
                                </div>
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
    // Enhanced search functionality
    (function () {
        const input = document.getElementById('quickSearch');
        const table = document.getElementById('binsTable').getElementsByTagName('tbody')[0];
        const noResultsRow = document.createElement('tr');
        noResultsRow.innerHTML = `
            <td colspan="10">
                <div class="empty-state">
                    <i class="bi bi-search"></i>
                    <h6>Không tìm thấy kết quả</h6>
                    <p class="text-muted mb-0">Thử tìm kiếm với từ khóa khác.</p>
                </div>
            </td>
        `;
        noResultsRow.style.display = 'none';
        table.appendChild(noResultsRow);

        function normalize(s) {
            return (s || '').toString().toLowerCase().trim()
                .replace(/à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ/g, 'a')
                .replace(/è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ/g, 'e')
                .replace(/ì|í|ị|ỉ|ĩ/g, 'i')
                .replace(/ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ/g, 'o')
                .replace(/ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ/g, 'u')
                .replace(/ỳ|ý|ỵ|ỷ|ỹ/g, 'y')
                .replace(/đ/g, 'd');
        }

        input.addEventListener('input', function () {
            const query = normalize(this.value);
            const rows = Array.from(table.getElementsByTagName('tr')).filter(row =>
                row !== noResultsRow && row.getElementsByTagName('td').length > 1
            );
            let visibleCount = 0;

            rows.forEach(row => {
                const cells = row.getElementsByTagName('td');
                if (!cells || cells.length === 0) return;

                const binCode = normalize(cells[1].innerText);
                const street = normalize(cells[2].innerText);
                const ward = normalize(cells[3].innerText);
                const city = normalize(cells[4].innerText);

                const match = query === '' ||
                    binCode.includes(query) ||
                    street.includes(query) ||
                    ward.includes(query) ||
                    city.includes(query);

                row.style.display = match ? '' : 'none';
                if (match) visibleCount++;
            });

            // Show/hide no results message
            noResultsRow.style.display = (query !== '' && visibleCount === 0) ? '' : 'none';
        });

        // Add search icon to input
        input.style.paddingLeft = '40px';
        input.style.backgroundImage = 'url("data:image/svg+xml,%3csvg xmlns=\'http://www.w3.org/2000/svg\' fill=\'%236b7280\' viewBox=\'0 0 16 16\'%3e%3cpath d=\'M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001c.03.04.062.078.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1.007 1.007 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0z\'/%3e%3c/svg%3e")';
        input.style.backgroundRepeat = 'no-repeat';
        input.style.backgroundPosition = '12px center';
        input.style.backgroundSize = '16px 16px';
    })();

    // Add loading state to delete buttons
    document.addEventListener('DOMContentLoaded', function() {
        const deleteForms = document.querySelectorAll('form[action*="/delete"]');
        deleteForms.forEach(form => {
            form.addEventListener('submit', function(e) {
                const button = this.querySelector('button');
                button.innerHTML = '<i class="bi bi-hourglass-split"></i>';
                button.disabled = true;
            });
        });
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>