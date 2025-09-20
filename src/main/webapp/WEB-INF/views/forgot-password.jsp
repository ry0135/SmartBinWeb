<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Quên mật khẩu</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5" style="max-width:520px;">
  <h3 class="mb-3">Quên mật khẩu</h3>

  <c:if test="${not empty error}">
    <div class="alert alert-danger">${error}</div>
  </c:if>
  <c:if test="${not empty message}">
    <div class="alert alert-info">${message}</div>
  </c:if>

  <form action="${pageContext.request.contextPath}/forgot-password" method="post">
    <div class="mb-3">
      <label for="email" class="form-label">Email</label>
      <input type="email" class="form-control" id="email" name="email" required>
    </div>

    <!-- CSRF (nếu Spring Security bật) -->
    <c:if test="${_csrf != null}">
      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
    </c:if>

    <button type="submit" class="btn btn-primary w-100">Gửi mã xác minh</button>
  </form>
</div>
</body>
</html>
