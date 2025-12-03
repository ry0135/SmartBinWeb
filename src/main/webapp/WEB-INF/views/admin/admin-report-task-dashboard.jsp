<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>SmartBin Admin - Thống kê Reports & Tasks</title>

    <!-- Bootstrap + Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        body {
            background-color: #f3f4f6;
            font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
        }

        /* vùng nội dung tránh bị sidebar che */
        .sb-main {
            margin-left: 260px; /* khớp width sidebar trong header_admin.jsp */
            padding: 24px 24px 40px;
        }

        .sb-page-title {
            font-size: 22px;
            font-weight: 700;
            color: #111827;
        }

        .sb-page-subtitle {
            font-size: 13px;
            color: #6b7280;
        }

        .kpi-card {
            background: #ffffff;
            border-radius: 14px;
            padding: 16px 18px;
            box-shadow: 0 2px 10px rgba(15, 23, 42, 0.06);
            border: 1px solid #e5e7eb;
            margin-bottom: 16px;
        }

        .kpi-icon {
            width: 38px;
            height: 38px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #ffffff;
            font-size: 18px;
            margin-bottom: 8px;
        }

        .kpi-title {
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: .06em;
            color: #6b7280;
            font-weight: 600;
        }

        .kpi-value {
            font-size: 22px;
            font-weight: 700;
            color: #111827;
            margin-top: 4px;
            margin-bottom: 0;
        }

        .kpi-sub {
            font-size: 11px;
            color: #9ca3af;
        }

        .card-section {
            background: #ffffff;
            border-radius: 16px;
            padding: 18px 20px;
            margin-bottom: 24px;
            box-shadow: 0 2px 10px rgba(15, 23, 42, 0.05);
            border: 1px solid #e5e7eb;
        }

        .card-section h6 {
            font-size: 15px;
            font-weight: 600;
            margin-bottom: 4px;
            color: #111827;
        }

        .card-section small {
            color: #6b7280;
        }

        .chart-wrapper {
            position: relative;
            width: 100%;
            height: 260px;
        }

        @media (max-width: 992px) {
            .sb-main {
                margin-left: 0;
                padding: 16px;
            }
        }
    </style>
</head>
<body>

<!-- Sidebar / Header admin -->
<jsp:include page="/WEB-INF/views/admin/header_admin.jsp"/>
<jsp:include page="ai_chat_box.jsp" />

<div class="sb-main">

    <!-- Tiêu đề trang -->
    <div class="mb-3">
        <div class="sb-page-title">📊 Thống kê Reports & Tasks</div>
        <div class="sb-page-subtitle">
            Tổng quan tình hình báo cáo sự cố và nhiệm vụ xử lý trong hệ thống SmartBin.
        </div>
    </div>

    <!-- HÀNG KPI -->
    <div class="row g-3 mb-2">
        <div class="col-6 col-sm-4 col-lg-3 col-xl-2">
            <div class="kpi-card">
                <div class="kpi-icon" style="background: linear-gradient(135deg,#0ea5e9,#2563eb);">
                    <i class="bi bi-trash-fill"></i>
                </div>
                <div class="kpi-title">% thùng hoạt động tốt</div>
                <p class="kpi-value"><c:out value="${activeBinPercent}"/>%</p>
                <div class="kpi-sub">Dựa trên trạng thái thùng.</div>
            </div>
        </div>

        <div class="col-6 col-sm-4 col-lg-3 col-xl-2">
            <div class="kpi-card">
                <div class="kpi-icon" style="background: linear-gradient(135deg,#22c55e,#16a34a);">
                    <i class="bi bi-file-check-fill"></i>
                </div>
                <div class="kpi-title">% báo cáo xử lý (tháng này)</div>
                <p class="kpi-value"><c:out value="${resolvedReportPercent}"/>%</p>
                <div class="kpi-sub">Tỷ lệ report RESOLVED.</div>
            </div>
        </div>

        <div class="col-6 col-sm-4 col-lg-3 col-xl-2">
            <div class="kpi-card">
                <div class="kpi-icon" style="background: linear-gradient(135deg,#f97316,#f59e0b);">
                    <i class="bi bi-star-fill"></i>
                </div>
                <div class="kpi-title">Điểm hài lòng TB</div>
                <p class="kpi-value"><c:out value="${avgRating}"/>/5</p>
                <div class="kpi-sub">Từ bảng Feedbacks.</div>
            </div>
        </div>

        <div class="col-6 col-sm-4 col-lg-3 col-xl-2">
            <div class="kpi-card">
                <div class="kpi-icon" style="background: linear-gradient(135deg,#ef4444,#f97316);">
                    <i class="bi bi-exclamation-triangle-fill"></i>
                </div>
                <div class="kpi-title">Nhiệm vụ đang mở</div>
                <p class="kpi-value"><c:out value="${openTasksCount}"/></p>
                <div class="kpi-sub">Task OPEN + IN_PROGRESS.</div>
            </div>
        </div>

        <div class="col-6 col-sm-4 col-lg-3 col-xl-2">
            <div class="kpi-card">
                <div class="kpi-icon" style="background: linear-gradient(135deg,#6366f1,#8b5cf6);">
                    <i class="bi bi-calendar-day-fill"></i>
                </div>
                <div class="kpi-title">Báo cáo mới hôm nay</div>
                <p class="kpi-value"><c:out value="${newReportsToday}"/></p>
                <div class="kpi-sub">Trong 24 giờ gần nhất.</div>
            </div>
        </div>

        <div class="col-6 col-sm-4 col-lg-3 col-xl-2">
            <div class="kpi-card">
                <div class="kpi-icon" style="background: linear-gradient(135deg,#22c55e,#059669);">
                    <i class="bi bi-alarm-fill"></i>
                </div>
                <div class="kpi-title">% task đúng hạn</div>
                <p class="kpi-value"><c:out value="${onTimeTaskPercent}"/>%</p>
                <div class="kpi-sub">Dựa trên dueAt &amp; CompletedAt.</div>
            </div>
        </div>
    </div>

    <!-- HÀNG KPI PHỤ (avg time, overdue, tổng báo cáo) -->
    <div class="row g-3 mb-3">
        <div class="col-md-4">
            <div class="kpi-card">
                <div class="kpi-title">Thời gian xử lý báo cáo TB</div>
                <p class="kpi-value"><c:out value="${avgResolveHours}"/> giờ</p>
                <div class="kpi-sub">Từ CreatedAt → ResolvedAt.</div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="kpi-card">
                <div class="kpi-title">Số nhiệm vụ trễ hạn</div>
                <p class="kpi-value"><c:out value="${overdueTasksCount}"/></p>
                <div class="kpi-sub">CompletedAt &gt; dueAt.</div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="kpi-card">
                <div class="kpi-title">Tổng số báo cáo</div>
                <p class="kpi-value"><c:out value="${totalReports}"/></p>
                <div class="kpi-sub">Tất cả trạng thái.</div>
            </div>
        </div>
    </div>

    <!-- HÀNG 1: REPORT STATUS + REPORT TIME -->
    <div class="row g-3 mb-3">
        <div class="col-lg-4">
            <div class="card-section">
                <h6>Báo cáo theo trạng thái</h6>
                <small>Tổng số báo cáo: <strong><c:out value="${totalReports}"/></strong></small>
                <div class="chart-wrapper mt-3">
                    <canvas id="reportStatusChart"></canvas>
                </div>
            </div>
        </div>
        <div class="col-lg-8">
            <div class="card-section">
                <h6>Báo cáo theo thời gian (7 ngày gần nhất)</h6>
                <small>Trục X: ngày, Trục Y: số report.</small>
                <div class="chart-wrapper mt-3">
                    <canvas id="reportTimeChart"></canvas>
                </div>
            </div>
        </div>
    </div>

    <!-- HÀNG 2: REPORT TYPE + SLA -->
    <div class="row g-3 mb-3">
        <div class="col-lg-6">
            <div class="card-section">
                <h6>Báo cáo theo loại sự cố</h6>
                <small>Thùng đầy, thùng hỏng, mùi hôi, mất trộm,...</small>
                <div class="chart-wrapper mt-3">
                    <canvas id="reportTypeChart"></canvas>
                </div>
            </div>
        </div>
        <div class="col-lg-6">
            <div class="card-section">
                <h6>SLA xử lý báo cáo</h6>
                <small>Tỷ lệ xử lý đúng hạn / trễ hạn.</small>
                <div class="chart-wrapper mt-3">
                    <canvas id="reportSlaChart"></canvas>
                </div>
            </div>
        </div>
    </div>

    <!-- HÀNG 3: TOP BINS + TASK STATUS -->
    <div class="row g-3 mb-3">
        <div class="col-lg-6">
            <div class="card-section">
                <h6>Top 5 thùng bị báo cáo nhiều nhất</h6>
                <small>Giúp phát hiện thùng / vị trí có vấn đề.</small>
                <div class="chart-wrapper mt-3">
                    <canvas id="topBinsChart"></canvas>
                </div>
            </div>
        </div>
        <div class="col-lg-6">
            <div class="card-section">
                <h6>Trạng thái nhiệm vụ</h6>
                <small>OPEN / IN_PROGRESS / COMPLETED / CANCELED.</small>
                <div class="chart-wrapper mt-3">
                    <canvas id="taskStatusChart"></canvas>
                </div>
            </div>
        </div>
    </div>

    <!-- HÀNG 4: TASK PRIORITY + TASK TIME -->
    <div class="row g-3 mb-3">
        <div class="col-lg-4">
            <div class="card-section">
                <h6>Nhiệm vụ theo mức ưu tiên</h6>
                <small>Priority 1, 2, 3,...</small>
                <div class="chart-wrapper mt-3">
                    <canvas id="taskPriorityChart"></canvas>
                </div>
            </div>
        </div>
        <div class="col-lg-8">
            <div class="card-section">
                <h6>Nhiệm vụ theo thời gian</h6>
                <small>So sánh số task tạo mới và hoàn thành theo ngày.</small>
                <div class="chart-wrapper mt-3">
                    <canvas id="taskTimeChart"></canvas>
                </div>
            </div>
        </div>
    </div>

    <!-- HÀNG 5: TASK PERFORMANCE + LATE USER -->
    <div class="row g-3">
        <div class="col-lg-6">
            <div class="card-section">
                <h6>Hiệu suất xử lý theo nhân viên</h6>
                <small>Số task COMPLETED mỗi người.</small>
                <div class="chart-wrapper mt-3">
                    <canvas id="taskPerfChart"></canvas>
                </div>
            </div>
        </div>
        <div class="col-lg-6">
            <div class="card-section">
                <h6>Nhân viên có nhiều task trễ hạn</h6>
                <small>Dựa trên so sánh CompletedAt &amp; dueAt.</small>
                <div class="chart-wrapper mt-3">
                    <canvas id="taskLateUserChart"></canvas>
                </div>
            </div>
        </div>
    </div>

</div> <!-- /.sb-main -->

<!-- ==================== SCRIPT CHART ==================== -->
<script>
    // Dữ liệu JSON đã được DashboardService build sẵn
    const reportStatusLabels = ${reportStatusLabels};
    const reportStatusData   = ${reportStatusData};

    const reportTimeLabels = ${reportTimeLabels};
    const reportTimeData   = ${reportTimeData};

    const reportTypeLabels = ${reportTypeLabels};
    const reportTypeData   = ${reportTypeData};

    const reportSlaLabels = ${reportSlaLabels};
    const reportSlaData   = ${reportSlaData};

    const topBinsLabels = ${topBinsLabels};
    const topBinsData   = ${topBinsData};

    const taskStatusLabels = ${taskStatusLabels};
    const taskStatusData   = ${taskStatusData};

    const taskPriorityLabels = ${taskPriorityLabels};
    const taskPriorityData   = ${taskPriorityData};

    const taskTimeLabels    = ${taskTimeLabels};
    const taskCreatedData   = ${taskCreatedData};
    const taskCompletedData = ${taskCompletedData};

    const taskPerfLabels = ${taskPerfLabels};
    const taskPerfData   = ${taskPerfData};

    const taskLateUserLabels = ${taskLateUserLabels};
    const taskLateUserData   = ${taskLateUserData};

    document.addEventListener('DOMContentLoaded', () => {
        const colors = [
            '#3b82f6','#10b981','#f59e0b','#ef4444','#8b5cf6',
            '#6366f1','#14b8a6','#f97316','#ec4899','#22c55e'
        ];

        // 1. Donut trạng thái báo cáo
        new Chart(document.getElementById('reportStatusChart'), {
            type: 'doughnut',
            data: {
                labels: reportStatusLabels,
                datasets: [{
                    data: reportStatusData,
                    backgroundColor: colors,
                    borderWidth: 2
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { position: 'bottom' } },
                cutout: '60%'
            }
        });

        // 2. Line chart báo cáo theo thời gian
        new Chart(document.getElementById('reportTimeChart'), {
            type: 'line',
            data: {
                labels: reportTimeLabels,
                datasets: [{
                    label: 'Số báo cáo',
                    data: reportTimeData,
                    fill: true,
                    tension: 0.3
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: { y: { beginAtZero: true } },
                plugins: { legend: { display: false } }
            }
        });

        // 3. Báo cáo theo loại sự cố
        new Chart(document.getElementById('reportTypeChart'), {
            type: 'bar',
            data: {
                labels: reportTypeLabels,
                datasets: [{
                    data: reportTypeData,
                    backgroundColor: colors.slice(0, reportTypeLabels.length)
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: { y: { beginAtZero: true } },
                plugins: { legend: { display: false } }
            }
        });

        // 4. SLA đúng hạn / trễ hạn
        new Chart(document.getElementById('reportSlaChart'), {
            type: 'doughnut',
            data: {
                labels: reportSlaLabels,
                datasets: [{
                    data: reportSlaData,
                    backgroundColor: [colors[1], colors[3]]
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { position: 'bottom' } },
                cutout: '55%'
            }
        });

        // 5. Top thùng bị report (horizontal bar)
        new Chart(document.getElementById('topBinsChart'), {
            type: 'bar',
            data: {
                labels: topBinsLabels,
                datasets: [{
                    data: topBinsData,
                    backgroundColor: colors[0]
                }]
            },
            options: {
                indexAxis: 'y',
                responsive: true,
                maintainAspectRatio: false,
                scales: { x: { beginAtZero: true } },
                plugins: { legend: { display: false } }
            }
        });

        // 6. Task status
        new Chart(document.getElementById('taskStatusChart'), {
            type: 'doughnut',
            data: {
                labels: taskStatusLabels,
                datasets: [{
                    data: taskStatusData,
                    backgroundColor: colors.slice(0, taskStatusLabels.length)
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { position: 'bottom' } },
                cutout: '60%'
            }
        });

        // 7. Task priority
        new Chart(document.getElementById('taskPriorityChart'), {
            type: 'bar',
            data: {
                labels: taskPriorityLabels,
                datasets: [{
                    data: taskPriorityData,
                    backgroundColor: colors.slice(0, taskPriorityLabels.length)
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: { y: { beginAtZero: true } },
                plugins: { legend: { display: false } }
            }
        });

        // 8. Task created vs completed theo thời gian
        new Chart(document.getElementById('taskTimeChart'), {
            type: 'line',
            data: {
                labels: taskTimeLabels,
                datasets: [
                    {
                        label: 'Tạo mới',
                        data: taskCreatedData,
                        fill: false,
                        tension: 0.3
                    },
                    {
                        label: 'Hoàn thành',
                        data: taskCompletedData,
                        fill: false,
                        tension: 0.3
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: { y: { beginAtZero: true } }
            }
        });

        // 9. Hiệu suất xử lý theo nhân viên
        new Chart(document.getElementById('taskPerfChart'), {
            type: 'bar',
            data: {
                labels: taskPerfLabels,
                datasets: [{
                    data: taskPerfData,
                    backgroundColor: colors[0]
                }]
            },
            options: {
                indexAxis: 'y',
                responsive: true,
                maintainAspectRatio: false,
                scales: { x: { beginAtZero: true } },
                plugins: { legend: { display: false } }
            }
        });

        // 10. Nhân viên có nhiều task trễ
        new Chart(document.getElementById('taskLateUserChart'), {
            type: 'bar',
            data: {
                labels: taskLateUserLabels,
                datasets: [{
                    data: taskLateUserData,
                    backgroundColor: colors[3]
                }]
            },
            options: {
                indexAxis: 'y',
                responsive: true,
                maintainAspectRatio: false,
                scales: { x: { beginAtZero: true } },
                plugins: { legend: { display: false } }
            }
        });
    });
</script>

</body>
</html>
