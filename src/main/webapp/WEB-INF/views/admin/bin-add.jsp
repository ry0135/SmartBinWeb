<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thêm thùng rác</title>

    <!-- Bootstrap & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        /* ===== Màu sắc hệ thống thùng rác (Xanh lá chủ đạo) ===== */
        :root{
            --primary-color: #8cc63f;      /* Màu xanh lá chính */
            --primary-dark: #7cb342;       /* Xanh lá đậm */
            --primary-light: #9ccc65;      /* Xanh lá sáng */
            --secondary-color: #4caf50;    /* Xanh lá phụ */
            --accent-color: #ff9800;       /* Cam nhấn */
            --text-dark: #2e7d32;          /* Chữ xanh đậm */
            --text-light: #ffffff;         /* Chữ trắng */
            --bg-light: #f1f8e9;           /* Nền sáng xanh nhạt */
            --bg-dark: #1b5e20;            /* Nền tối xanh đậm */
            --card-bg: #ffffff;            /* Nền card trắng */
            --card-border: #c5e1a5;        /* Viền card xanh nhạt */
            --input-bg: #f8fdf1;           /* Nền input xanh rất nhạt */
            --input-border: #aed581;       /* Viền input xanh */
        }

        html,body{
            height:100%;
            margin:0;
            font-family: 'Inter', 'Segoe UI', Roboto, Arial, sans-serif;
            background: linear-gradient(135deg, var(--bg-light) 0%, #e8f5e9 100%);
            color: #333;
        }

        .page-wrap{
            padding: 24px;
            background: transparent;
        }

        .page-title{
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 1rem;
        }

        .glass-card{
            border-radius: 16px;
            padding: 28px;
            background: var(--card-bg);
            border: 2px solid var(--card-border);
            box-shadow: 0 8px 32px rgba(140, 198, 63, 0.15);
            backdrop-filter: blur(10px);
        }

        .btn-outline-secondary{
            color: var(--primary-color);
            border-color: var(--primary-color);
            font-weight: 500;
        }

        .btn-outline-secondary:hover{
            background: var(--primary-color);
            border-color: var(--primary-color);
            color: white;
        }

        .form-label{
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 0.5rem;
        }

        .form-control, .form-select{
            background: var(--input-bg);
            border: 2px solid var(--input-border);
            color: #2e7d32;
            border-radius: 8px;
            padding: 10px 15px;
            font-size: 14px;
        }

        .form-control::placeholder{
            color: #81c784;
        }

        .form-control:focus, .form-select:focus{
            background: white;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(140, 198, 63, 0.25);
            color: var(--text-dark);
        }

        .invalid-feedback{
            color: #f44336;
            font-size: 12px;
        }

        .form-text{
            color: #689f38;
            font-size: 13px;
        }

        .btn-primary{
            border: none;
            font-weight: 600;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            border-radius: 8px;
            padding: 10px 24px;
            box-shadow: 0 4px 12px rgba(140, 198, 63, 0.3);
            transition: all 0.3s ease;
        }

        .btn-primary:hover{
            background: linear-gradient(135deg, var(--primary-dark), #43a047);
            box-shadow: 0 6px 16px rgba(140, 198, 63, 0.4);
            transform: translateY(-1px);
        }

        .alert-success {
            background: linear-gradient(135deg, #e8f5e9, #c8e6c9);
            border: 2px solid #a5d6a7;
            color: #2e7d32;
            border-radius: 12px;
        }

        .alert-danger {
            background: linear-gradient(135deg, #ffebee, #ffcdd2);
            border: 2px solid #ef9a9a;
            color: #c62828;
            border-radius: 12px;
        }

        /* Header đồng bộ */
        .navbar-custom {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            box-shadow: 0 4px 12px rgba(140, 198, 63, 0.25);
        }

        /* Responsive */
        @media (max-width: 768px) {
            .glass-card {
                padding: 20px;
                margin: 0 -15px;
            }

            .page-wrap {
                padding: 16px;
            }
        }
    </style>
</head>
<body>
<%@ include file="/WEB-INF/views/admin/header_admin.jsp" %>

<div class="container page-wrap">
    <div class="d-flex align-items-center justify-content-between mb-4">
        <h3 class="page-title mb-0">
            <i class="bi bi-trash-fill me-2" style="color: var(--primary-color);"></i>
            Thêm thùng rác mới
        </h3>
        <a href="${pageContext.request.contextPath}/admin/bins/list" class="btn btn-outline-secondary">
            <i class="bi bi-arrow-left me-1"></i>Danh sách thùng
        </a>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-danger mb-4">${error}</div>
    </c:if>
    <c:if test="${not empty success}">
        <div class="alert alert-success mb-4">${success}</div>
    </c:if>

    <div class="glass-card">
        <form id="binForm" method="post" action="${pageContext.request.contextPath}/admin/bins" novalidate>
            <c:if test="${not empty _csrf}">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            </c:if>

            <div class="row g-4">
                <!-- BinCode KHÔNG có input (tự sinh ở backend) -->
                <div class="col-12">
                    <div class="form-text">
                        <i class="bi bi-info-circle me-1"></i>
                        Mã thùng (BinCode) sẽ được hệ thống tự sinh sau khi lưu.
                    </div>
                </div>

                <div class="col-md-8">
                    <label class="form-label">Tên đường</label>
                    <input type="text" name="street" class="form-control" maxlength="255" placeholder="Nhập tên đường">
                </div>

                <div class="col-md-4">
                    <label class="form-label">Phường <span class="text-danger">*</span></label>
                    <select name="wardID" id="wardID" class="form-select" required>
                        <option value="">-- Chọn phường --</option>
                        <c:forEach var="w" items="${wards}">
                            <option value="${w.wardId}">${w.wardName}</option>
                        </c:forEach>
                    </select>
                    <div class="invalid-feedback">Vui lòng chọn phường</div>
                </div>

                <div class="col-md-4">
                    <label class="form-label">Vĩ độ (Latitude)</label>
                    <input type="number" step="0.000001" name="latitude" id="latitude" class="form-control" placeholder="16.07177">
                    <div class="form-text">Ví dụ: 16.07177</div>
                    <div class="invalid-feedback">Vĩ độ hợp lệ nằm trong [-90, 90]</div>
                </div>

                <div class="col-md-4">
                    <label class="form-label">Kinh độ (Longitude)</label>
                    <input type="number" step="0.000001" name="longitude" id="longitude" class="form-control" placeholder="108.22057">
                    <div class="form-text">Ví dụ: 108.22057</div>
                    <div class="invalid-feedback">Kinh độ hợp lệ nằm trong [-180, 180]</div>
                </div>

                <div class="col-md-4">
                    <label class="form-label">Dung tích (lít) <span class="text-danger">*</span></label>
                    <input type="number" step="0.01" name="capacity" id="capacity" class="form-control" value="120" required>
                    <div class="form-text">Dung tích tối đa của thùng</div>
                    <div class="invalid-feedback">Dung tích phải lớn hơn 0</div>
                </div>

                <div class="col-md-4">
                    <label class="form-label">% đầy hiện tại</label>
                    <input type="number" step="0.01" name="currentFill" id="currentFill" class="form-control" value="0">
                    <div class="form-text">Mức đầy hiện tại (%)</div>
                    <div class="invalid-feedback">% đầy không được âm</div>
                </div>

                <div class="col-md-4">
                    <label class="form-label">Trạng thái</label>
                    <select name="status" class="form-select">
                        <option value="1" selected>🟢 Hoạt động</option>
                        <option value="0">🟡 Bảo trì</option>
                        <option value="2">🔴 Đầy / Mất kết nối</option>
                    </select>
                </div>
            </div>

            <div class="mt-5 d-flex gap-3 justify-content-end">
                <a href="${pageContext.request.contextPath}/admin/bins/list" class="btn btn-outline-secondary px-4">
                    <i class="bi bi-x-circle me-1"></i>Hủy
                </a>
                <button type="submit" class="btn btn-primary px-4">
                    <i class="bi bi-check-circle me-1"></i>Lưu thùng rác
                </button>
            </div>
        </form>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Validate nhỏ phía client
    (function () {
        const form = document.getElementById('binForm');
        form.addEventListener('submit', function (e) {
            let ok = true;

            const wardID = document.getElementById('wardID');
            const latEl  = document.getElementById('latitude');
            const lngEl  = document.getElementById('longitude');
            const capEl  = document.getElementById('capacity');
            const fillEl = document.getElementById('currentFill');

            // Ward
            if (!wardID.value) {
                wardID.classList.add('is-invalid');
                ok = false;
            } else {
                wardID.classList.remove('is-invalid');
            }

            // Validate các trường
            const validations = [
                { element: latEl, min: -90, max: 90, message: 'Vĩ độ hợp lệ nằm trong [-90, 90]' },
                { element: lngEl, min: -180, max: 180, message: 'Kinh độ hợp lệ nằm trong [-180, 180]' },
                { element: capEl, min: 0.01, message: 'Dung tích phải lớn hơn 0' },
                { element: fillEl, min: 0, message: '% đầy không được âm' }
            ];

            validations.forEach(validation => {
                if (validation.element.value) {
                    const value = parseFloat(validation.element.value);
                    if (isNaN(value) ||
                        (validation.min !== undefined && value < validation.min) ||
                        (validation.max !== undefined && value > validation.max)) {
                        validation.element.classList.add('is-invalid');
                        ok = false;
                    } else {
                        validation.element.classList.remove('is-invalid');
                    }
                }
            });

            if (!ok) {
                e.preventDefault();
                e.stopPropagation();
            }
        });
    })();
</script>
</body>
</html>