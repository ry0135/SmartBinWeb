<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Xác minh mã & Đổi mật khẩu</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5" style="max-width:520px;">
    <h3 class="mb-3">Xác minh mã & Đặt lại mật khẩu</h3>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>
    <c:if test="${not empty message}">
        <div class="alert alert-info">${message}</div>
    </c:if>
    <c:if test="${not empty success}">
        <div class="alert alert-success">${success}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/verify-code" method="post">
        <!-- Cho phép nhập lại email nếu session không còn -->
        <div class="mb-3">
            <label for="email" class="form-label">Email</label>
            <input type="email" class="form-control" id="email" name="email"
                   value="${sessionScope.fp_email != null ? sessionScope.fp_email : ''}"
                   placeholder="you@example.com">
            <div class="form-text">Nếu đã lưu trong phiên, có thể để trống.</div>
        </div>

        <div class="mb-3">
            <label for="code" class="form-label">Mã xác minh</label>
            <input type="text" class="form-control" id="code" name="code" required>
        </div>

        <div class="mb-3">
            <label for="newPassword" class="form-label">Mật khẩu mới</label>
            <input type="password" class="form-control" id="newPassword" name="newPassword" required minlength="6">
        </div>

        <div class="mb-3">
            <label for="confirmPassword" class="form-label">Xác nhận mật khẩu</label>
            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required minlength="6">
        </div>

        <c:if test="${_csrf != null}">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        </c:if>

        <button type="submit" class="btn btn-success w-100">Đặt lại mật khẩu</button>
    </form>
</div>
</body>
</html>
