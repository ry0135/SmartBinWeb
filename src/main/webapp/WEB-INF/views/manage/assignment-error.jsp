<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <title>Lỗi</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
<div class="container mt-4">
  <div class="card">
    <div class="card-header bg-danger text-white">
      <h4 class="mb-0"><i class="fas fa-exclamation-triangle"></i> Lỗi</h4>
    </div>
    <div class="card-body">
      <div class="alert alert-danger">
        <h5>${error}</h5>
      </div>

      <div class="mt-3">
        <a href="${pageContext.request.contextPath}/manage" class="btn btn-primary">
          <i class="fas fa-arrow-left"></i> Quay lại quản lý
        </a>
        <a href="javascript:history.back()" class="btn btn-secondary">
          <i class="fas fa-undo"></i> Thử lại
        </a>
      </div>
    </div>
  </div>
</div>
</body>
</html>