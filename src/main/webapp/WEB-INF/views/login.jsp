<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Đăng nhập - SmartBin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .login-container {
            max-width: 400px;
            margin: 100px auto;
            padding: 30px;
            border: 1px solid #ddd;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
            background: white;
        }
        .logo {
            text-align: center;
            margin-bottom: 30px;
            color: #8cc63f;
            font-weight: bold;
            font-size: 28px;
        }
        .form-label {
            font-weight: 500;
        }
    </style>
</head>
<body style="background-color: #f8f9fa;">
<div class="container">
    <div class="login-container">
        <div class="logo">
            <i class="bi bi-trash-fill"></i> SMARTBIN
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show">
                    ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post">
            <div class="mb-3">
                <label for="email" class="form-label">Email</label>
                <input type="email" class="form-control" id="email" name="email"
                       required placeholder="Nhập email của bạn">
            </div>

            <div class="mb-3">
                <label for="password" class="form-label">Mật khẩu</label>
                <input type="password" class="form-control" id="password" name="password"
                       required placeholder="Nhập mật khẩu">
            </div>

            <button type="submit" class="btn btn-success w-100 py-2">
                <i class="bi bi-box-arrow-in-right"></i> Đăng nhập
            </button>
        </form>

        <hr>

        <div class="text-center mt-3">
            <small class="text-muted">
                <strong>Tài khoản demo:</strong><br>
                Admin: admin@example.com / 123456<br>
                Manager: manager@example.com / 123456
            </small>
        </div>
    </div>
</div>

<!-- Bootstrap Icons -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>