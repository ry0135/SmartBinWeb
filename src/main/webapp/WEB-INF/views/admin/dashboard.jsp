<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        body {
            background-color: #f4f6f9;
            font-family: 'Inter', sans-serif;
        }

        .dashboard-card {
            border-radius: 20px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
            color: white;
            padding: 25px;
            transition: transform 0.2s ease-in-out;
        }

        .dashboard-card:hover {
            transform: scale(1.02);
        }

        .card-icon {
            font-size: 45px;
            opacity: 0.85;
        }

        .bg-gradient-blue {
            background: linear-gradient(135deg, #007bff, #00bfff);
        }

        .bg-gradient-green {
            background: linear-gradient(135deg, #28a745, #6fda44);
        }

        .bg-gradient-orange {
            background: linear-gradient(135deg, #ff8c00, #ffb347);
        }

        .bg-gradient-purple {
            background: linear-gradient(135deg, #6f42c1, #b19cd9);
        }

        canvas {
            min-height: 300px;
        }
    </style>
</head>

<body>
<jsp:include page="ai_chat_box.jsp" />

<%@ include file="/WEB-INF/views/admin/header_admin.jsp" %>
<div class="container py-5">
    <h2 class="mb-4 fw-bold text-center text-secondary">📊 Admin Dashboard Overview</h2>

    <!-- Bộ lọc phường -->
    <div class="text-center mb-4">
        <form id="wardFilterForm" method="get" action="${pageContext.request.contextPath}/admin/dashboard">
            <select name="wardId" class="form-select w-auto d-inline-block shadow-sm" onchange="this.form.submit()">
                <option value="">Tất cả phường</option>
                <c:forEach var="ward" items="${wards}">
                    <option value="${ward.wardId}"
                            <c:if test="${selectedWard != null && selectedWard eq ward.wardId}">selected</c:if>>
                            ${ward.wardName}
                    </option>
                </c:forEach>
            </select>
        </form>
    </div>

    <!-- Thống kê tổng quan -->
    <div class="row g-4 justify-content-center">
        <!-- Tổng số thùng -->
        <div class="col-md-3 col-sm-6">
            <div class="dashboard-card bg-gradient-blue text-center">
                <div class="card-icon mb-2"><i class="bi bi-trash3-fill"></i></div>
                <h5 class="fw-bold">Tổng số thùng rác</h5>
                <h2 class="fw-bolder"><c:out value="${totalBins}" default="0" /></h2>
            </div>
        </div>

        <!-- Thùng đang hoạt động -->
        <div class="col-md-3 col-sm-6">
            <div class="dashboard-card bg-gradient-green text-center">
                <div class="card-icon mb-2"><i class="bi bi-check-circle-fill"></i></div>
                <h5 class="fw-bold">Thùng đang hoạt động</h5>
                <h2 class="fw-bolder"><c:out value="${activeBins}" default="0" /></h2>
            </div>
        </div>

        <!-- Thùng đầy -->
        <div class="col-md-3 col-sm-6">
            <div class="dashboard-card bg-gradient-orange text-center">
                <div class="card-icon mb-2"><i class="bi bi-exclamation-triangle-fill"></i></div>
                <h5 class="fw-bold">Thùng đầy (≥90%)</h5>
                <h2 class="fw-bolder"><c:out value="${fullBins}" default="0" /></h2>
            </div>
        </div>


    </div>
</div>

<hr class="my-5">

<!-- Biểu đồ -->
<div class="container mb-5">
    <div class="row">
        <!-- Biểu đồ cột -->
        <div class="col-md-7">
            <div class="card shadow-sm p-3">
                <h5 class="fw-bold text-center mb-3">📅 Thống kê thùng rác theo tháng</h5>
                <canvas id="barChart"></canvas>
                <div id="noBarData" class="text-center text-muted mt-3 d-none">⚠️ Không có dữ liệu thùng rác cho phường này</div>
            </div>
        </div>

        <!-- Biểu đồ tròn -->
        <div class="col-md-5">
            <div class="card shadow-sm p-3">
                <h5 class="fw-bold text-center mb-3">🗑️ Tình trạng thùng rác</h5>
                <canvas id="pieChart"></canvas>
                <div id="noPieData" class="text-center text-muted mt-3 d-none">⚠️ Không có dữ liệu trạng thái cho phường này</div>
            </div>
        </div>
    </div>
</div>

<!-- Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
    // === Biểu đồ cột (số thùng rác theo tháng) ===
    const binsPerMonth = [
        <c:forEach var="row" items="${binsPerMonth}" varStatus="loop">
        {"month": ${row[0]}, "count": ${row[1]}}<c:if test="${!loop.last}">,</c:if>
        </c:forEach>
    ];

    const barCtx = document.getElementById('barChart');
    if (binsPerMonth.length > 0 && binsPerMonth.some(item => item.count > 0)) {
        new Chart(barCtx, {
            type: 'bar',
            data: {
                labels: binsPerMonth.map(item => 'Tháng ' + item.month),
                datasets: [{
                    label: 'Số thùng rác',
                    data: binsPerMonth.map(item => item.count),
                    backgroundColor: '#007bff'
                }]
            },
            options: {
                responsive: true,
                animation: { duration: 1000, easing: 'easeOutBounce' },
                scales: { y: { beginAtZero: true } }
            }
        });
    } else {
        document.getElementById('noBarData').classList.remove('d-none');
    }

    // === Biểu đồ tròn (tình trạng thùng rác) ===
    const statusSummary = [${binStatusSummary[0] != null ? binStatusSummary[0] : 0},
        ${binStatusSummary[1] != null ? binStatusSummary[1] : 0},
        ${binStatusSummary[2] != null ? binStatusSummary[2] : 0}];

    const pieCtx = document.getElementById('pieChart');
    if (statusSummary.some(v => v > 0)) {
        new Chart(pieCtx, {
            type: 'pie',
            data: {
                labels: ['Hoạt động', 'Đầy', 'Bảo trì'],
                datasets: [{
                    data: statusSummary,
                    backgroundColor: ['#28a745', '#ff8c00', '#6c757d']
                }]
            },
            options: {
                responsive: true,
                animation: { duration: 1200, easing: 'easeInOutQuart' }
            }
        });
    } else {
        document.getElementById('noPieData').classList.remove('d-none');
    }
</script>

</body>
</html>
