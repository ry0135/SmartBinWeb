<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@include file="../include/head.jsp"%>

<html>
<head>
  <title>Chi tiết báo cáo</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css"/>
  <style>
    body {
      background-color: #f4f6f9;
      font-family: "Segoe UI", Roboto, sans-serif;
      margin: 0;
      padding: 0;
      overflow-x: hidden;
    }

    .sidebar {
      position: fixed;
      top: 0;
      left: 0;
      height: 100vh;
      width: 250px;
      background-color: #1e293b;
      overflow-y: auto;
      z-index: 100;
    }

    .content-wrapper {
      margin-left: 250px;
      padding: 40px;
    }

    .detail-card {
      max-width: 900px;
      margin: auto;
      border: none;
      border-radius: 15px;
      overflow: hidden;
      background: #fff;
      box-shadow: 0 5px 15px rgba(0,0,0,0.1);
    }

    .detail-card .card-header {
      background: linear-gradient(135deg, #007bff, #0056b3);
      font-weight: 600;
      font-size: 18px;
      padding: 20px;
    }

    .detail-table th {
      width: 220px;
      background-color: #f8f9fa;
      font-weight: 600;
      color: #495057;
    }

    .detail-table td {
      background-color: #ffffff;
      vertical-align: middle;
    }

    .btn-modern {
      border-radius: 25px;
      padding: 8px 20px;
      font-weight: 500;
      transition: all 0.3s ease;
    }

    .btn-modern:hover {
      transform: translateY(-1px);
      box-shadow: 0 3px 6px rgba(0,0,0,0.2);
    }

    .badge-status {
      padding: 8px 12px;
      font-size: 13px;
      border-radius: 20px;
    }

    .badge-success { background-color: #28a745 !important; }
    .badge-warning { background-color: #ffc107 !important; color: #212529; }
    .badge-secondary { background-color: #6c757d !important; }
  </style>
</head>
<body>

<!-- Sidebar -->
<div class="sidebar">
  <%@include file="../include/sidebar.jsp"%>
</div>

<!-- Nội dung chính -->
<div class="content-wrapper">
  <div class="card shadow detail-card">
    <div class="card-header text-white d-flex justify-content-between align-items-center">
      <span>📋 Chi tiết báo cáo #${report.reportId}</span>
      <a href="${pageContext.request.contextPath}/edit/${report.reportId}" class="btn btn-warning btn-modern text-white">
        Update
      </a>
    </div>

    <div class="card-body">
      <table class="table table-bordered detail-table">
        <tr><th>ID</th><td>${report.reportId}</td></tr>
        <tr><th>BinID</th><td>${report.binId}</td></tr>
        <tr><th>AccountID</th><td>${report.accountId}</td></tr>
        <tr><th>Loại báo cáo</th><td>${report.reportType}</td></tr>
        <tr><th>Mô tả</th><td>${report.description}</td></tr>

        <tr>
          <th>Trạng thái</th>
          <td>
            <span class="badge badge-status
              <c:choose>
                <c:when test="${report.status == 'RESOLVED'}">badge-success</c:when>
                <c:when test="${report.status == 'IN_PROGRESS'}">badge-warning</c:when>
                <c:otherwise>badge-secondary</c:otherwise>
              </c:choose>">
              ${report.status}
            </span>
          </td>
        </tr>

        <tr><th>Người xử lý</th><td>${report.assignedTo}</td></tr>
        <tr><th>Ngày tạo</th><td>${report.createdAt}</td></tr>
        <tr><th>Ngày cập nhật</th><td>${report.updatedAt}</td></tr>
        <tr><th>Ngày hoàn thành</th><td>${report.resolvedAt}</td></tr>
      </table>
    </div>

    <div class="card-footer text-center">
      <a href="${pageContext.request.contextPath}/reports" class="btn btn-secondary btn-modern">⬅ Quay lại</a>
      <button type="button" class="btn btn-primary btn-modern ml-2" data-toggle="modal" data-target="#downloadModal">
        📊 Tải báo cáo
      </button>
      <button type="button" class="btn btn-info btn-modern ml-2" data-toggle="modal" data-target="#shareChoiceModal">
        📤 Chia sẻ
      </button>
    </div>
  </div>
</div>

<!-- Modal tải báo cáo -->
<div class="modal fade" id="downloadModal" tabindex="-1" role="dialog" aria-labelledby="downloadModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header bg-primary text-white">
        <h5 class="modal-title" id="downloadModalLabel">Chọn định dạng tải báo cáo</h5>
        <button type="button" class="close text-white" data-dismiss="modal" aria-label="Đóng">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body text-center">
        <a href="${pageContext.request.contextPath}/export/excel/${report.reportId}" class="btn btn-success btn-modern m-2">⬇ Tải Excel</a>
        <a href="${pageContext.request.contextPath}/export/pdf/${report.reportId}" class="btn btn-danger btn-modern m-2">⬇ Tải PDF</a>
      </div>
    </div>
  </div>
</div>

<!-- Modal chọn hình thức chia sẻ -->
<div class="modal fade" id="shareChoiceModal" tabindex="-1" role="dialog" aria-labelledby="shareChoiceModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header bg-info text-white">
        <h5 class="modal-title" id="shareChoiceModalLabel">📤 Chọn cách chia sẻ</h5>
        <button type="button" class="close text-white" data-dismiss="modal" aria-label="Đóng">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body text-center">
        <!-- Chia sẻ qua Gmail -->
        <button class="btn btn-danger btn-modern m-2" data-toggle="modal" data-target="#shareEmailModal" data-dismiss="modal">
          📧 Gmail
        </button>

        <!-- ✅ Chia sẻ qua Zalo -->
        <a href="https://zalo.me/share?url=${pageContext.request.contextPath}/report/${report.reportId}"
           target="_blank"
           class="btn btn-success btn-modern m-2">
          💬 Zalo
        </a>
      </div>
    </div>
  </div>
</div>

<!-- Modal chia sẻ qua Gmail -->
<div class="modal fade" id="shareEmailModal" tabindex="-1" role="dialog" aria-labelledby="shareEmailModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <form action="${pageContext.request.contextPath}/sendEmail" method="post">
      <div class="modal-content">
        <div class="modal-header bg-info text-white">
          <h5 class="modal-title" id="shareEmailModalLabel">📧 Chia sẻ báo cáo qua Gmail</h5>
          <button type="button" class="close text-white" data-dismiss="modal" aria-label="Đóng">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
          <input type="hidden" name="reportId" value="${report.reportId}">

          <div class="form-group">
            <label>Nhập Email người nhận:</label>
            <input type="email" name="email" class="form-control" placeholder="ví dụ: example@gmail.com" required>
          </div>

          <div class="form-group">
            <label>Nội dung tin nhắn (tuỳ chọn):</label>
            <textarea name="message" class="form-control" rows="3" placeholder="Gửi kèm lời nhắn..."></textarea>
          </div>
        </div>

        <div class="modal-footer">
          <button type="submit" class="btn btn-info btn-modern">Gửi ngay</button>
          <button type="button" class="btn btn-secondary btn-modern" data-dismiss="modal">Hủy</button>
        </div>
      </div>
    </form>
  </div>
</div>

<!-- Bootstrap JS -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
