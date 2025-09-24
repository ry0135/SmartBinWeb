<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html>
<%@include file="../include/head.jsp"%>
<body class="bg-light">

<div class="d-flex">
  <!-- Sidebar -->
  <%@include file="../include/sidebar.jsp"%>

  <!-- Main Content -->
  <div class="flex-grow-1" style="margin-left: 250px;">
    <!-- Header -->
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