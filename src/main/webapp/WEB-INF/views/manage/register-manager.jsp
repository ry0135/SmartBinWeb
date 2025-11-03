<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng ký Manager - SmartBin</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- Bootstrap & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

    <style>
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
            --danger:#ef4444;
            --success:#10b981;
        }

        *{ box-sizing:border-box; }
        html,body{ height:100%; margin:0; padding:0; }
        body{
            font-family:'Inter', system-ui, -apple-system, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg, #f0fdf4 0%, #ecfdf5 40%, #d1fae5 100%);
            color: var(--text-dark);
            line-height: 1.6;
        }

        /* Background Pattern */
        .background-pattern{
            position:fixed; inset:0; z-index:-1;
            background-image:
                    radial-gradient(circle at 25% 25%, rgba(34,197,94,.10) 0%, transparent 50%),
                    radial-gradient(circle at 75% 75%, rgba(16,185,129,.08) 0%, transparent 50%),
                    radial-gradient(circle at 50% 50%, rgba(34,197,94,.05) 0%, transparent 70%);
            background-size:600px 600px, 800px 800px, 1000px 1000px;
            animation: float 20s ease-in-out infinite;
        }
        @keyframes float{
            0%,100%{ transform:translate(0,0) rotate(0deg); }
            33%{ transform:translate(30px,-30px) rotate(1deg); }
            66%{ transform:translate(-20px,20px) rotate(-1deg); }
        }

        /* Container */
        .auth-container{
            min-height:100vh; display:flex; align-items:center; justify-content:center; padding:24px;
        }

        /* Card (tái dùng style login-card) */
        .form-card{
            width:100%; max-width:720px; background:var(--white);
            border:1px solid var(--border-gray); border-radius:20px; overflow:hidden; position:relative;
            box-shadow:0 20px 25px -5px rgba(0,0,0,.1), 0 10px 10px -5px rgba(0,0,0,.04);
            padding:40px 36px;
        }
        .form-card::before{
            content:''; position:absolute; top:0; left:0; right:0; height:4px;
            background:linear-gradient(90deg, var(--primary-green), var(--secondary-green));
        }

        /* Brand */
        .brand-section{ text-align:center; margin-bottom:24px; }
        .brand-logo{
            width:64px; height:64px; margin:0 auto 12px; border-radius:16px;
            display:flex; align-items:center; justify-content:center;
            background:var(--light-green); border:1px solid var(--border-green);
        }
        .brand-logo i{ font-size:32px; color:var(--primary-green); }
        .brand-name{ font-size:24px; font-weight:700; letter-spacing:-.025em; margin:0; }
        .brand-tagline{ color:var(--muted-green); font-size:14px; margin:4px 0 0; }

        /* Title */
        .form-title{ font-size:28px; font-weight:700; text-align:center; margin:16px 0 8px; letter-spacing:-.025em; }
        .form-sub{ text-align:center; color:var(--muted-green); margin-bottom:24px; }

        /* Form */
        .form-label{ font-weight:600; color:var(--text-dark); margin-bottom:8px; font-size:14px; }
        .form-control, .form-select{
            padding:14px 14px; border:1px solid var(--border-gray); border-radius:10px; font-size:16px; background:var(--white);
            transition:all .2s ease;
        }
        .form-control::placeholder{ color:var(--muted-green); }
        .form-control:focus, .form-select:focus{
            outline:none; border-color:var(--primary-green); box-shadow:0 0 0 3px rgba(34,197,94,.1);
        }

        /* Alert */
        .alert{ border-radius:10px; border:none; padding:16px; display:flex; align-items:flex-start; gap:12px; }
        .alert-danger{ background:#fef2f2; color:#b91c1c; border:1px solid #fecaca; }
        .alert-success{ background:var(--light-green); color:var(--text-green); border:1px solid var(--border-green); }
        .btn-close{
            background:none; border:none; font-size:20px; margin-left:auto; cursor:pointer;
        }

        /* Buttons */
        .btn-primary{
            --bs-btn-bg: var(--primary-green);
            --bs-btn-border-color: var(--primary-green);
            --bs-btn-hover-bg: var(--secondary-green);
            --bs-btn-hover-border-color: var(--secondary-green);
            --bs-btn-active-bg: var(--secondary-green);
            --bs-btn-active-border-color: var(--secondary-green);
            border-radius:10px; padding:14px 16px; font-weight:600;
            display:inline-flex; align-items:center; gap:8px;
            box-shadow:none; transition:transform .15s ease, box-shadow .2s ease;
        }
        .btn-primary:hover{ transform:translateY(-1px); box-shadow:0 10px 20px rgba(34,197,94,.25); }
        .btn-outline-success{
            border-color:var(--border-green); color:var(--text-green); background:var(--light-green);
        }
        .btn-outline-success:hover{ background:#dcfce7; border-color:#86efac; color:var(--text-green); }

        /* Divider */
        .divider{ display:flex; align-items:center; color:var(--muted-green); font-size:14px; margin:16px 0 8px; }
        .divider::before, .divider::after{ content:''; flex:1; height:1px; background:var(--border-gray); }
        .divider span{ padding:0 12px; background:var(--white); }

        /* Grid */
        .g-16{ gap:16px; }

        /* Loading */
        .btn-primary .spinner{
            width:20px; height:20px; border:2px solid rgba(255,255,255,.3); border-radius:50%;
            border-top-color:#fff; animation:spin 1s linear infinite; display:none;
        }
        @keyframes spin{ to{ transform:rotate(360deg); } }
        .btn-primary:disabled{ opacity:.7; cursor:not-allowed; }

        /* Responsive */
        @media (max-width: 640px){
            .form-card{ padding:28px 22px; border-radius:16px; }
            .form-title{ font-size:24px; }
        }

        /* Focus visible */
        .btn-primary:focus-visible, .form-control:focus-visible, .form-select:focus-visible, a:focus-visible{
            outline:2px solid var(--primary-green);
            outline-offset:2px;
        }
    </style>
</head>
<body>
<div class="background-pattern"></div>

<div class="auth-container">
    <div class="form-card">
        <!-- Brand -->
        <div class="brand-section">
            <div class="brand-logo">
                <i class="bi bi-recycle"></i>
            </div>
            <h1 class="brand-name">SmartBin</h1>
            <p class="brand-tagline">Hệ thống quản lý thùng rác thông minh</p>
        </div>

        <!-- Title -->
        <h2 class="form-title">Đăng ký trở thành Manager</h2>
        <p class="form-sub">Điền thông tin bên dưới và tải lên hồ sơ theo yêu cầu.</p>

        <!-- Alerts -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger" role="alert">
                <i class="bi bi-exclamation-triangle mt-1"></i>
                <div>
                    <strong>Gửi đơn thất bại!</strong><br/>
                        ${error}
                </div>
                <button type="button" class="btn-close" onclick="this.parentElement.remove()">
                    <i class="bi bi-x"></i>
                </button>
            </div>
        </c:if>
        <c:if test="${not empty message}">
            <div class="alert alert-success" role="alert">
                <i class="bi bi-check-circle mt-1"></i>
                <div>${message}</div>
                <button type="button" class="btn-close" onclick="this.parentElement.remove()">
                    <i class="bi bi-x"></i>
                </button>
            </div>
        </c:if>

        <!-- Form -->
        <form id="registerForm" action="${pageContext.request.contextPath}/register-manager" method="post" enctype="multipart/form-data" autocomplete="on">
            <c:if test="${_csrf != null}">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            </c:if>

            <div class="row g-3 g-16">
                <div class="col-12">
                    <label class="form-label" for="fullName">Họ và tên</label>
                    <input type="text" id="fullName" name="fullName" class="form-control" placeholder="Nguyễn Văn A" required autocomplete="name">
                </div>

                <div class="col-12 col-md-6">
                    <label class="form-label" for="email">Email cá nhân</label>
                    <input type="email" id="email" name="email" class="form-control" placeholder="email@domain.com" required autocomplete="email">
                </div>

                <div class="col-12 col-md-6">
                    <label class="form-label" for="phone">Số điện thoại</label>
                    <input type="text" id="phone" name="phone" class="form-control" placeholder="09xx xxx xxx" autocomplete="tel">
                </div>

                <div class="col-12">
                    <label class="form-label" for="address">Địa chỉ</label>
                    <input type="text" id="address" name="address" class="form-control" placeholder="Số nhà, đường, phường/xã, quận/huyện, tỉnh/thành">
                </div>

                <div class="col-12 col-md-6">
                    <label class="form-label" for="wardID">Phường muốn quản lý</label>
                    <select id="wardID" name="wardID" class="form-select" required>
                        <option value="">-- Chọn phường --</option>
                        <c:forEach var="w" items="${wards}">
                            <option value="${w.wardId}">${w.wardName}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="col-12 col-md-6">
                    <label class="form-label">Mẫu hợp đồng</label>
                    <div class="d-flex gap-2">
                        <a class="btn btn-outline-success"
                           href="<c:url value='/assets/contracts/HopDong_SmartBin.docx'/>" download>
                            <i class="bi bi-download"></i> Tải file mẫu
                        </a>

                    </div>
                </div>

                <div class="col-12 col-md-6">
                    <label class="form-label" for="contractFile">Upload hợp đồng đã ký (PDF/JPG/PNG)</label>
                    <input type="file" id="contractFile" name="contractFile" class="form-control" accept=".pdf,.jpg,.jpeg,.png" required>
                    <small class="text-muted">Tối đa 10MB mỗi tệp.</small>
                </div>

                <div class="col-12 col-md-6">
                    <label class="form-label" for="cmndFile">Upload CMND/CCCD (PDF/JPG/PNG)</label>
                    <input type="file" id="cmndFile" name="cmndFile" class="form-control" accept=".pdf,.jpg,.jpeg,.png" required>
                    <small class="text-muted">Che mờ số nếu cần để bảo mật.</small>
                </div>
            </div>

            <div class="divider mt-4 mb-3">
                <span>Lưu ý</span>
            </div>
            <ul class="mb-4" style="color:var(--muted-green);">
                <li>Thông tin phải chính xác để xác minh.</li>
                <li>Định dạng tệp: PDF/JPG/PNG. Không hỗ trợ HEIC.</li>
            </ul>

            <button type="submit" class="btn btn-primary w-100" id="submitBtn">
                <span class="btn-text"><i class="bi bi-send"></i> Gửi đơn đăng ký</span>
                <div class="spinner"></div>
            </button>

            <div class="text-center mt-3">
                <a href="${pageContext.request.contextPath}/login" class="link-success" style="text-decoration:none; font-weight:600;">
                    <i class="bi bi-box-arrow-in-right"></i> Quay lại đăng nhập
                </a>
            </div>
        </form>
    </div>
</div>

<script>
    // Loading state
    document.getElementById('registerForm').addEventListener('submit', function() {
        const btn = document.getElementById('submitBtn');
        const text = btn.querySelector('.btn-text');
        const spinner = btn.querySelector('.spinner');
        btn.disabled = true;
        text.style.display = 'none';
        spinner.style.display = 'block';

        // Phòng trường hợp treo
        setTimeout(() => {
            btn.disabled = false;
            text.style.display = 'inline-flex';
            spinner.style.display = 'none';
        }, 4000);
    });

    // Auto-dismiss alerts
    document.addEventListener('DOMContentLoaded', function() {
        const alerts = document.querySelectorAll('.alert');
        alerts.forEach(alert => {
            setTimeout(() => {
                if (alert.parentElement) {
                    alert.style.opacity = '0';
                    alert.style.transform = 'translateY(-10px)';
                    setTimeout(() => alert.remove(), 300);
                }
            }, 5000);
        });
    });

    // Nhấn chọn file → hiển thị tên file đẹp hơn
    ['contractFile','cmndFile'].forEach(id=>{
        const el = document.getElementById(id);
        el.addEventListener('change', function(){
            if(this.files && this.files.length>0){
                this.title = Array.from(this.files).map(f=>f.name).join(', ');
            }
        });
    });

    // Viền đỏ khi trống (UX giống login)
    const inputs = document.querySelectorAll('.form-control, .form-select');
    inputs.forEach(input=>{
        input.addEventListener('blur', function(){
            if ((this.type === 'file' && this.files.length === 0) || (this.value || '').trim() === '') {
                this.style.borderColor = '#ef4444';
            } else {
                this.style.borderColor = '#d1fae5';
            }
        });
        input.addEventListener('focus', function(){
            this.style.borderColor = '#22c55e';
        });
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
