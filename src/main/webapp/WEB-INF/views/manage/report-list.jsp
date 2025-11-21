<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@include file="../include/head.jsp"%>

<html>
<head>
    <title>Danh sách báo cáo</title>
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

    <style>
        body { background-color: #f7f9fc; }
        .content-wrapper { padding: 20px 40px; margin-left: 220px; }
        h2 { font-weight: 600; color: #333; }

        .report-table {
            max-width: 1100px;
            margin: auto;
            font-size: 14px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
            overflow: hidden;
        }

        .table thead { background-color: #e9f1ff; }
        .table th, .table td { text-align: center; vertical-align: middle; }

        .filter-bar {
            max-width: 1100px;
            margin: 15px auto 25px auto;
            padding: 8px 15px;
            background: #ffffff;
            border-radius: 10px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.08);
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            gap: 8px;
            font-size: 14px;
        }
        .filter-bar label { margin: 0 5px 0 0; font-weight: 500; }

        .filter-bar input[type="date"],
        .filter-bar select {
            height: 32px;
            border-radius: 6px;
            border: 1px solid #ced4da;
            padding: 0 8px;
            font-size: 13px;
            transition: 0.3s;
        }
        .filter-bar input[type="date"]:focus,
        .filter-bar select:focus {
            border-color: #007bff;
            box-shadow: 0 0 4px rgba(0,123,255,0.3);
            outline: none;
        }
        #clearFilter {
            border-radius: 6px;
            padding: 4px 10px;
            font-size: 13px;
            transition: 0.3s;
        }
        #clearFilter i { margin-right: 4px; }
        #clearFilter:hover { background-color: #6c757d; color: #fff; }

        .btn-info {
            background-color: #17a2b8;
            border: none;
            border-radius: 6px;
        }
        .btn-info:hover { background-color: #138496; }
        .col-md-2 { position: fixed; height: 100vh; }

        .download-bar {
            max-width: 1100px;
            margin: 0 auto 15px auto;
            text-align: right;
        }
        .btn-download {
            background-color: #007bff;
            border: none;
            border-radius: 6px;
            transition: 0.3s;
        }
        .btn-download:hover { background-color: #0056b3; }
        .dropdown-menu a i {
            width: 18px;
            text-align: center;
            margin-right: 6px;
        }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-2 p-0">
            <%@include file="../include/sidebar.jsp"%>
        </div>

        <div class="col-md-10 content-wrapper">
            <h2>📑 Danh sách báo cáo</h2>

            <div class="download-bar">
                <div class="dropdown d-inline-block">
                    <button class="btn btn-download btn-sm dropdown-toggle" type="button" id="downloadDropdown"
                            data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        <i class="fa-solid fa-download"></i> Tải báo cáo
                    </button>
                    <div class="dropdown-menu dropdown-menu-right" aria-labelledby="downloadDropdown">
                        <a id="downloadExcel" class="dropdown-item" href="#">
                            <i class="fa-solid fa-file-excel text-success"></i> Tải Excel
                        </a>
                        <a id="downloadPdf" class="dropdown-item" href="#">
                            <i class="fa-solid fa-file-pdf text-danger"></i> Tải PDF
                        </a>
                    </div>
                </div>
            </div>

            <div class="filter-bar">
                <label for="startDate"><i class="fa-solid fa-calendar-day"></i> Từ:</label>
                <input type="date" id="startDate">

                <label for="endDate"><i class="fa-solid fa-calendar-check"></i> Đến:</label>
                <input type="date" id="endDate">

                <label for="statusFilter"><i class="fa-solid fa-filter"></i> Trạng thái:</label>
                <select id="statusFilter">
                    <option value="">Tất cả</option>
                    <option value="RECEIVED">ĐÃ TIẾP NHẬN</option>
                    <option value="IN_PROGRESS">ĐANG XỬ LÝ</option>
                    <option value="RESOLVED">ĐÃ HOÀN THÀNH</option>
                </select>

                <button id="clearFilter" class="btn btn-secondary btn-sm ml-auto">
                    <i class="fa-solid fa-rotate-right"></i> Xóa lọc
                </button>
            </div>

            <div class="table-responsive">
                <table class="table table-bordered table-hover report-table" id="reportTable">
                    <thead class="thead-light">
                    <tr>
                        <th>ID</th>
                        <th>BinID</th>
                        <th>Tên người báo cáo</th> <!-- ✅ Đổi tiêu đề -->
                        <th>Loại báo cáo</th>
                        <th>Mô tả</th>
                        <th>Trạng thái</th>
                        <th>Người xử lý</th>
                        <th>Ngày tạo</th>
                        <th>Ngày cập nhật</th>
                        <th>Ngày hoàn thành</th>
                        <th>Hành động</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="report" items="${reports}">
                        <tr>
                            <td>${report.reportId}</td>
                            <td>${report.bin.binCode}</td>
                            <!-- ✅ Hiển thị FullName từ liên kết Account -->
                            <td>
                                <c:choose>
                                    <c:when test="${not empty report.account}">
                                        ${report.account.fullName}
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">Không rõ</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>${report.reportType}</td>
                            <td>${report.description}</td>
                            <td>
                                 <span class="badge
                                    <c:choose>
                                        <c:when test='${report.status == "RECEIVED"}'>badge-info</c:when>
                                        <c:when test='${report.status == "IN_PROGRESS"}'>badge-warning</c:when>
                                        <c:when test='${report.status == "RESOLVED"}'>badge-success</c:when>
                                        <c:otherwise>badge-secondary</c:otherwise>
                                    </c:choose>">
                                    <c:choose>
                                        <c:when test='${report.status == "RECEIVED"}'>ĐÃ TIẾP NHẬN</c:when>
                                        <c:when test='${report.status == "IN_PROGRESS"}'>ĐANG XỬ LÝ</c:when>
                                        <c:when test='${report.status == "RESOLVED"}'>ĐÃ HOÀN THÀNH</c:when>
                                        <c:otherwise>Không xác định</c:otherwise>
                                    </c:choose>
                                </span>
                            </td>
                            <td>${report.assignedTo}</td>
                            <td>${report.createdAt}</td>
                            <td>${report.updatedAt}</td>
                            <td>${report.resolvedAt}</td>
                            <td class="text-center">
                                <a href="${pageContext.request.contextPath}/detail/${report.reportId}"
                                   class="btn btn-sm btn-info">
                                    <i class="fa-solid fa-eye"></i> Xem
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
    const startInput = document.getElementById("startDate");
    const endInput = document.getElementById("endDate");
    const statusSelect = document.getElementById("statusFilter");
    const clearBtn = document.getElementById("clearFilter");
    const table = document.getElementById("reportTable");
    const rows = table.getElementsByTagName("tr");

    // ✅ Ánh xạ trạng thái tiếng Việt sang mã code
    function mapStatusToCode(vnStatus) {
        switch (vnStatus) {
            case "ĐÃ TIẾP NHẬN": return "RECEIVED";
            case "ĐANG XỬ LÝ": return "IN_PROGRESS";
            case "ĐÃ HOÀN THÀNH": return "RESOLVED";
            default: return "";
        }
    }

    // ✅ Lọc theo ngày và trạng thái (có hỗ trợ tiếng Việt)
    function filterTable() {
        const startDate = startInput.value ? new Date(startInput.value) : null;
        const endDate = endInput.value ? new Date(endInput.value) : null;
        const selectedStatus = statusSelect.value.trim().toUpperCase();

        for (let i = 1; i < rows.length; i++) {
            const cells = rows[i].getElementsByTagName("td");
            if (!cells || cells.length < 8) continue;

            const createdAtStr = cells[7].textContent.trim().split(" ")[0];
            const reportDate = new Date(createdAtStr);
            const vnStatus = cells[5].textContent.trim().toUpperCase();
            const statusText = mapStatusToCode(vnStatus);

            let show = true;
            if (startDate && reportDate < startDate) show = false;
            if (endDate && reportDate > endDate) show = false;
            if (selectedStatus && statusText !== selectedStatus) show = false;

            rows[i].style.display = show ? "" : "none";
        }
    }

    startInput.addEventListener("change", filterTable);
    endInput.addEventListener("change", filterTable);
    statusSelect.addEventListener("change", filterTable);

    clearBtn.addEventListener("click", () => {
        startInput.value = "";
        endInput.value = "";
        statusSelect.value = "";
        for (let i = 1; i < rows.length; i++) rows[i].style.display = "";
    });

    // ✅ Giữ nguyên phần export
    function buildQueryParams() {
        const start = startInput.value;
        const end = endInput.value;
        const status = statusSelect.value;
        let query = "?";
        if (start) query += "startDate=" + start + "&";
        if (end) query += "endDate=" + end + "&";
        if (status) query += "status=" + status + "&";
        return query.slice(0, -1);
    }

    document.getElementById("downloadExcel").addEventListener("click", () => {
        const params = buildQueryParams();
        window.location.href = "${pageContext.request.contextPath}/export/excel" + params;
    });

    document.getElementById("downloadPdf").addEventListener("click", () => {
        const params = buildQueryParams();
        window.location.href = "${pageContext.request.contextPath}/export/pdf" + params;
    });
</script>

</body>
</html>


