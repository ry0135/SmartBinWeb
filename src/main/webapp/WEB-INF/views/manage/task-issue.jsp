<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Chi tiết Batch - Xử lý sự cố</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        .status-issue {
            background: #dc3545;
            color: white;
            padding: 5px 10px;
            border-radius: 5px;
            font-weight: bold;
        }
        .status-completed {
            background: #28a745;
            color: white;
            padding: 5px 10px;
            border-radius: 5px;
            font-weight: bold;
        }

        /* Highlight rows */
        .issue-row {
            background-color: #f8d7da !important;
            border-left: 4px solid #dc3545;
        }
        .completed-row {
            background-color: #d4edda !important;
            border-left: 4px solid #28a745;
        }

        .note-box {
            background: #fff3cd;
            padding: 8px;
            border-radius: 4px;
            font-size: 0.9em;
        }

        /* Summary cards */
        .summary-card {
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 15px;
            color: white;
        }
        .issue-card { background: linear-gradient(135deg, #dc3545, #c82333); }
        .completed-card { background: linear-gradient(135deg, #28a745, #1e7e34); }
    </style>
</head>

<body class="bg-light">
<div class="container-fluid">
    <div class="row">
        <%@include file="../include/sidebar.jsp"%>

        <main class="col-md-9 ms-sm-auto col-lg-10 px-4">
            <!-- Header -->
            <div class="pt-3 pb-2 mb-3 border-bottom">
                <h2>
                    <span class="text-danger">⚠️</span> Batch Xử lý Sự cố:
                    <span class="text-danger">${batchId}</span>
                </h2>
            </div>

            <!-- Summary Cards -->
            <div class="row mb-4">
                <div class="col-md-6">
                    <div class="summary-card issue-card">
                        <h5><i class="bi bi-exclamation-triangle"></i> Task Lỗi (Cần xử lý)</h5>
                        <h2 class="display-4">${issueCount}</h2>
                        <p class="mb-0">Sẽ được giao lại khi bấm nút bên dưới</p>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="summary-card completed-card">
                        <h5><i class="bi bi-check-circle"></i> Task Đã Hoàn thành</h5>
                        <h2 class="display-4">${completedCount}</h2>
                        <p class="mb-0">Sẽ được giữ nguyên trạng thái</p>
                    </div>
                </div>
            </div>

            <!-- Action Button -->
            <div class="card mb-4">
                <div class="card-body">
                    <h5 class="card-title">📋 Hành động xử lý batch</h5>
                    <p class="card-text">
                        Batch này có <strong>${issueCount} task lỗi</strong> và <strong>${completedCount} task đã hoàn thành</strong>.
                        Chức năng "Giao lại" sẽ chỉ xử lý các task lỗi.
                    </p>

                    <c:choose>
                        <c:when test="${issueCount > 0}">
                            <a href="${pageContext.request.contextPath}/tasks/assign/retry-batch?batchId=${batchId}"
                               class="btn btn-danger btn-lg">
                                <i class="bi bi-arrow-clockwise"></i> Giao lại ${issueCount} task lỗi
                            </a>
                            <small class="text-muted ms-2">
                                (Chỉ giao lại task có biểu tượng ⛔ LỖI)
                            </small>
                        </c:when>
                        <c:otherwise>
                            <button class="btn btn-success btn-lg" disabled>
                                <i class="bi bi-check-circle"></i> Không có task lỗi cần xử lý
                            </button>
                            <p class="text-muted mt-2">Tất cả task trong batch này đã hoàn thành.</p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Task List -->
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">
                        <i class="bi bi-list-task"></i> Danh sách Task trong Batch
                        <span class="badge bg-secondary ms-2">${totalTasks} task</span>
                    </h5>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead class="table-light">
                            <tr>
                                <th width="5%">#</th>
                                <th width="10%">Mã Task</th>
                                <th width="15%">Thùng rác</th>
                                <th width="10%">Loại</th>
                                <th width="10%">Ưu tiên</th>
                                <th width="15%">Trạng thái</th>
                                <th width="25%">Ghi chú</th>
                                <th width="10%">Nhân viên</th>
                            </tr>
                            </thead>

                            <tbody>
                            <c:forEach var="task" items="${batchTasks}" varStatus="loop">
                                <tr class="${task.status eq 'ISSUE' ? 'issue-row' : 'completed-row'}">
                                    <td>${loop.index + 1}</td>
                                    <td>
                                        <strong>#${task.taskID}</strong>
                                        <c:if test="${task.status eq 'ISSUE'}">
                                            <br><small class="text-danger">Cần giao lại</small>
                                        </c:if>
                                    </td>
                                    <td>
                                        Bin #${task.bin.binID}
                                        <c:if test="${task.bin.ward != null}">
                                            <br><small class="text-muted">${task.bin.ward.wardName}</small>
                                        </c:if>
                                    </td>
                                    <td>${task.taskType}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${task.priority == 1}">
                                                <span class="badge bg-danger">Cao</span>
                                            </c:when>
                                            <c:when test="${task.priority == 2}">
                                                <span class="badge bg-warning">Trung</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">Thấp</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${task.status eq 'ISSUE'}">
                                                <span class="status-issue">
                                                    <i class="bi bi-exclamation-triangle"></i> LỖI
                                                </span>
                                            </c:when>
                                            <c:when test="${task.status eq 'COMPLETED'}">
                                                <span class="status-completed">
                                                    <i class="bi bi-check-circle"></i> HOÀN THÀNH
                                                </span>
                                            </c:when>
                                        </c:choose>
                                    </td>

                                    <td>
                                        <div class="note-box">
                                            <c:choose>
                                                <c:when test="${empty task.issueReason}">
                                                    <i class="text-muted">Không có ghi chú</i>
                                                </c:when>
                                                <c:otherwise>
                                                    ${task.issueReason}
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </td>

                                    <td>
                                        <c:if test="${task.assignedTo != null}">
                                            ${task.assignedTo.fullName}
                                            <c:if test="${task.status eq 'ISSUE'}">
                                                <br><small class="text-danger">(Cần thay thế)</small>
                                            </c:if>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="card-footer text-muted">
                    <div class="row">
                        <div class="col">
                            <i class="bi bi-info-circle"></i>
                            Task màu <span class="text-danger">hồng nhạt</span> là task lỗi cần xử lý.
                            Task màu <span class="text-success">xanh nhạt</span> đã hoàn thành.
                        </div>
                    </div>
                </div>
            </div>

            <!-- Legend -->
            <div class="mt-3">
                <div class="alert alert-light">
                    <h6><i class="bi bi-key"></i> Chú thích:</h6>
                    <p>
                        <span class="badge bg-danger">LỖI</span> = Task gặp sự cố, cần được giao lại cho nhân viên khác<br>
                        <span class="badge bg-success">HOÀN THÀNH</span> = Task đã hoàn thành, không cần xử lý thêm
                    </p>
                </div>
            </div>

        </main>
    </div>
</div>

<!-- Add Bootstrap Icons -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
</body>
</html>