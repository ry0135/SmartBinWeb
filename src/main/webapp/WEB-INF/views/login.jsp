<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập - SmartBin</title>
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

        *{
            box-sizing:border-box;
        }

        html,body{
            height:100%;
            margin: 0;
            padding: 0;
        }

        body{
            font-family:'Inter', system-ui, -apple-system, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg, #f0fdf4 0%, #ecfdf5 40%, #d1fae5 100%);
            color: var(--text-dark);
            line-height: 1.6;
        }

        /* ===== Background Pattern ===== */
        .background-pattern {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: -1;
            background-image:
                    radial-gradient(circle at 25% 25%, rgba(34, 197, 94, 0.1) 0%, transparent 50%),
                    radial-gradient(circle at 75% 75%, rgba(16, 185, 129, 0.08) 0%, transparent 50%),
                    radial-gradient(circle at 50% 50%, rgba(34, 197, 94, 0.05) 0%, transparent 70%);
            background-size: 600px 600px, 800px 800px, 1000px 1000px;
            animation: float 20s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { transform: translate(0, 0) rotate(0deg); }
            33% { transform: translate(30px, -30px) rotate(1deg); }
            66% { transform: translate(-20px, 20px) rotate(-1deg); }
        }

        /* ===== Main Container ===== */
        .auth-container{
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px;
            position: relative;
        }

        /* ===== Login Card ===== */
        .login-card{
            width: 100%;
            max-width: 440px;
            background: var(--white);
            border-radius: 20px;
            border: 1px solid var(--border-gray);
            box-shadow:
                    0 20px 25px -5px rgba(0, 0, 0, 0.1),
                    0 10px 10px -5px rgba(0, 0, 0, 0.04);
            padding: 48px 40px;
            position: relative;
            overflow: hidden;
        }

        .login-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--primary-green), var(--secondary-green));
        }

        /* ===== Brand Section ===== */
        .brand-section {
            text-align: center;
            margin-bottom: 32px;
        }

        .brand-logo {
            width: 64px;
            height: 64px;
            background: var(--light-green);
            border-radius: 16px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 16px;
            border: 1px solid var(--border-green);
        }

        .brand-logo i {
            font-size: 32px;
            color: var(--primary-green);
        }

        .brand-name {
            font-size: 24px;
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 8px;
            letter-spacing: -0.025em;
        }

        .brand-tagline {
            color: var(--muted-green);
            font-size: 14px;
            margin: 0;
        }

        /* ===== Form Title ===== */
        .form-title {
            font-size: 28px;
            font-weight: 700;
            color: var(--text-dark);
            text-align: center;
            margin-bottom: 24px;
            letter-spacing: -0.025em;
        }

        /* ===== Form Styling ===== */
        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            display: block;
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 8px;
            font-size: 14px;
        }

        .input-wrapper {
            position: relative;
        }

        .input-icon {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--muted-green);
            font-size: 16px;
            z-index: 2;
        }

        .form-control {
            width: 100%;
            padding: 14px 16px 14px 48px;
            border: 1px solid var(--border-gray);
            border-radius: 10px;
            font-size: 16px;
            background: var(--white);
            color: var(--text-dark);
            transition: all 0.2s ease;
        }

        .form-control::placeholder {
            color: var(--muted-green);
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary-green);
            box-shadow: 0 0 0 3px rgba(34, 197, 94, 0.1);
        }

        .form-control:focus + .input-icon {
            color: var(--primary-green);
        }

        /* ===== Helper Row ===== */
        .helper-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 24px;
            flex-wrap: wrap;
            gap: 12px;
        }

        .form-check {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .form-check-input {
            width: 18px;
            height: 18px;
            border: 1px solid var(--border-gray);
            border-radius: 4px;
            background: var(--white);
            margin: 0;
        }

        .form-check-input:checked {
            background-color: var(--primary-green);
            border-color: var(--primary-green);
        }

        .form-check-label {
            font-size: 14px;
            color: var(--text-dark);
            cursor: pointer;
            margin: 0;
        }

        .forgot-link {
            color: var(--primary-green);
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.2s ease;
        }

        .forgot-link:hover {
            color: var(--secondary-green);
            text-decoration: underline;
        }

        /* ===== Login Button ===== */
        .btn-login {
            width: 100%;
            padding: 16px;
            background: var(--primary-green);
            border: none;
            border-radius: 10px;
            color: var(--white);
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            position: relative;
            overflow: hidden;
        }

        .btn-login:hover {
            background: var(--secondary-green);
            transform: translateY(-1px);
            box-shadow: 0 10px 20px rgba(34, 197, 94, 0.3);
        }

        .btn-login:active {
            transform: translateY(0);
        }

        .btn-login::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s;
        }

        .btn-login:hover::before {
            left: 100%;
        }

        /* ===== Divider ===== */
        .divider {
            display: flex;
            align-items: center;
            margin: 32px 0;
            color: var(--muted-green);
            font-size: 14px;
        }

        .divider::before,
        .divider::after {
            content: '';
            flex: 1;
            height: 1px;
            background: var(--border-gray);
        }

        .divider span {
            padding: 0 16px;
            background: var(--white);
        }

        /* ===== Bottom Section ===== */
        .bottom-section {
            text-align: center;
        }

        .signup-link {
            color: var(--muted-green);
            font-size: 14px;
        }

        .signup-link a {
            color: var(--primary-green);
            text-decoration: none;
            font-weight: 600;
            transition: all 0.2s ease;
        }

        .signup-link a:hover {
            color: var(--secondary-green);
            text-decoration: underline;
        }

        /* ===== Alert Styling ===== */
        .alert {
            border-radius: 10px;
            border: none;
            padding: 16px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .alert-danger {
            background: #fef2f2;
            color: #b91c1c;
            border: 1px solid #fecaca;
        }

        .alert-success {
            background: var(--light-green);
            color: var(--text-green);
            border: 1px solid var(--border-green);
        }

        .btn-close {
            background: none;
            border: none;
            font-size: 20px;
            cursor: pointer;
            padding: 0;
            margin-left: auto;
        }

        /* ===== Loading State ===== */
        .btn-login:disabled {
            opacity: 0.7;
            cursor: not-allowed;
            transform: none;
        }

        .btn-login .spinner {
            width: 20px;
            height: 20px;
            border: 2px solid rgba(255, 255, 255, 0.3);
            border-radius: 50%;
            border-top-color: white;
            animation: spin 1s linear infinite;
            display: none;
        }

        @keyframes spin {
            to {
                transform: rotate(360deg);
            }
        }

        /* ===== Responsive Design ===== */
        @media (max-width: 640px) {
            .auth-container {
                padding: 16px;
            }

            .login-card {
                padding: 32px 24px;
                max-width: none;
                border-radius: 16px;
            }

            .form-title {
                font-size: 24px;
            }

            .helper-row {
                flex-direction: column;
                align-items: stretch;
                gap: 16px;
            }

            .form-check {
                justify-content: center;
            }
        }

        /* ===== Focus Visible for Accessibility ===== */
        .btn-login:focus-visible,
        .form-control:focus-visible,
        .forgot-link:focus-visible {
            outline: 2px solid var(--primary-green);
            outline-offset: 2px;
        }
    </style>
</head>
<body>

<div class="background-pattern"></div>

<div class="auth-container">
    <div class="login-card">
        <div class="brand-section">
            <div class="brand-logo">
                <i class="bi bi-recycle"></i>
            </div>
            <h1 class="brand-name">SmartBin</h1>
            <p class="brand-tagline">Hệ thống quản lý thùng rác thông minh</p>
        </div>

        <h2 class="form-title">Đăng nhập</h2>

        <c:if test="${not empty error}">
            <div class="alert alert-danger" role="alert">
                <i class="bi bi-exclamation-triangle"></i>
                <div>
                    <strong>Đăng nhập thất bại!</strong><br>
                        ${error}
                </div>
                <button type="button" class="btn-close" onclick="this.parentElement.remove()">
                    <i class="bi bi-x"></i>
                </button>
            </div>
        </c:if>

        <c:if test="${not empty success}">
            <div class="alert alert-success" role="alert">
                <i class="bi bi-check-circle"></i>
                <div>${success}</div>
                <button type="button" class="btn-close" onclick="this.parentElement.remove()">
                    <i class="bi bi-x"></i>
                </button>
            </div>
        </c:if>

        <form id="loginForm" action="${pageContext.request.contextPath}/login" method="post" autocomplete="on">
            <c:if test="${not empty _csrf}">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            </c:if>

            <div class="form-group">
                <label for="email" class="form-label">Email hoặc tài khoản</label>
                <div class="input-wrapper">
                    <input type="text"
                           class="form-control"
                           name="email"
                           id="email"
                           placeholder="Nhập email hoặc tên tài khoản"
                           required
                           autocomplete="username">
                    <i class="bi bi-person input-icon"></i>
                </div>
            </div>

            <div class="form-group">
                <label for="password" class="form-label">Mật khẩu</label>
                <div class="input-wrapper">
                    <input type="password"
                           class="form-control"
                           name="password"
                           id="password"
                           placeholder="Nhập mật khẩu"
                           required
                           autocomplete="current-password">
                    <i class="bi bi-lock input-icon"></i>
                </div>
            </div>

            <div class="helper-row">
                <div class="form-check">
                    <input class="form-check-input"
                           type="checkbox"
                           value="true"
                           id="rememberMe"
                           name="rememberMe">
                    <label class="form-check-label" for="rememberMe">
                        Ghi nhớ đăng nhập
                    </label>
                </div>
                <a class="forgot-link" href="${pageContext.request.contextPath}/forgot-password">
                    Quên mật khẩu?
                </a>
            </div>

            <button type="submit" class="btn-login" id="loginBtn">
                <span class="btn-text">
                    <i class="bi bi-box-arrow-in-right"></i>
                    Đăng nhập
                </span>
                <div class="spinner"></div>
            </button>
        </form>

        <div class="divider">
            <span>hoặc</span>
        </div>

        <div class="bottom-section">
            <p class="signup-link">
                Chưa có tài khoản?
                <a href="${pageContext.request.contextPath}/register-manager">Đăng kí làm quản lí</a>
            </p>
        </div>
    </div>
</div>

<script>
    // Form submission with loading state
    document.getElementById('loginForm').addEventListener('submit', function(e) {
        const btn = document.getElementById('loginBtn');
        const btnText = btn.querySelector('.btn-text');
        const spinner = btn.querySelector('.spinner');

        btn.disabled = true;
        btnText.style.display = 'none';
        spinner.style.display = 'block';

        // Re-enable button after 3 seconds in case of issues
        setTimeout(() => {
            btn.disabled = false;
            btnText.style.display = 'flex';
            spinner.style.display = 'none';
        }, 3000);
    });

    // Auto-dismiss alerts after 5 seconds
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

    // Enhanced form validation
    const inputs = document.querySelectorAll('.form-control');
    inputs.forEach(input => {
        input.addEventListener('blur', function() {
            if (this.value.trim() === '') {
                this.style.borderColor = '#ef4444';
            } else {
                this.style.borderColor = '#d1fae5';
            }
        });

        input.addEventListener('focus', function() {
            this.style.borderColor = '#22c55e';
        });
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>