

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ include file="../include/head.jsp" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Danh sách phản hồi</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

    <style>
        body {
            font-family: "Segoe UI", sans-serif;
            background-color: #f4f6f9;
            overflow-x: hidden;
        }

        .sidebar {
            position: fixed;
            top: 0;
            left: 0;
            width: 250px;
            height: 100vh;
            background: #343a40;
            color: white;
            padding-top: 20px;
        }

        .sidebar a {
            color: #adb5bd;
            text-decoration: none;
            display: block;
            padding: 12px 20px;
            transition: 0.3s;
        }

        .sidebar a:hover {
            background-color: #495057;
            color: #fff;
        }

        .main-content {
            margin-left: 250px;
            padding: 30px;
        }

        .table {
            background-color: #fff;
            border-collapse: separate;
            border-spacing: 0;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
        }

        .table thead th {
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: white;
            font-weight: 600;
            text-align: center;
            border: none;
            padding: 14px 12px;
        }

        .table tbody td {
            vertical-align: middle;
            text-align: center;
            padding: 12px;
            border-color: #dee2e6;
        }

        .table-hover tbody tr:hover {
            background-color: #f1f7ff;
            transition: 0.25s;
        }

        .table-container {
            background: #fff;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }

        .navbar {
            background: #ffffff;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            padding: 15px 30px;
        }

        .navbar h4 {
            margin: 0;
            color: #007bff;
            font-weight: 600;
        }

        .filter-bar {
            background: #fff;
            border-radius: 10px;
            padding: 12px 15px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.08);
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            gap: 10px;
            margin-bottom: 20px;
        }

        .filter-bar label {
            font-weight: 500;
            margin-right: 5px;
        }

        .filter-bar input[type="date"],
        .filter-bar select {
            border-radius: 6px;
            border: 1px solid #ced4da;
            padding: 4px 8px;
            font-size: 14px;
        }

        .filter-bar button {
            border-radius: 6px;
            padding: 4px 10px;
            font-size: 13px;
        }

        .low-rating {
            background-color: #ffe6e6 !important;
        }

        .low-rating td {
            color: #b30000;
            font-weight: 600;
        }

        .warning-icon {
            color: #ff0000;
            margin-left: 5px;
            cursor: pointer;
        }

        .action-btn {
            border-radius: 6px;
            padding: 5px 10px;
            font-size: 13px;
        }

        @media (max-width: 992px) {
            .sidebar {
                width: 100%;
                height: auto;
                position: relative;
            }
            .main-content {
                margin-left: 0;
            }
        }
    </style>
</head>

<body>
<div class="d-flex">

    <%@ include file="../include/sidebar.jsp" %>

    <div class="main-content">
        <nav class="navbar">
            <h4>📋 Quản lý phản hồi</h4>
        </nav>

        <div class="container-fluid mt-4">
            <div class="table-container">
                <h3 class="mb-4">Danh sách phản hồi</h3>

                <div class="filter-bar">
                    <label for="startDate"><i class="fa fa-calendar"></i> Từ:</label>
                    <input type="date" id="startDate">

                    <label for="endDate"><i class="fa fa-calendar-check"></i> Đến:</label>
                    <input type="date" id="endDate">

                    <label for="ratingFilter"><i class="fa fa-star text-warning"></i> Đánh giá:</label>
                    <select id="ratingFilter">
                        <option value="">Tất cả</option>
                        <option value="1">1 sao</option>
                        <option value="2">2 sao</option>
                        <option value="3">3 sao</option>
                        <option value="4">4 sao</option>
                        <option value="5">5 sao</option>
                    </select>

                    <button id="clearFilter" class="btn btn-secondary btn-sm ml-auto">
                        <i class="fa fa-rotate-right"></i> Xóa lọc
                    </button>
                </div>

                <div class="table-responsive">
                    <table class="table table-bordered table-hover" id="feedbackTable">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>Account ID</th>
                            <th>Ward ID</th>
                            <th>Rating</th>
                            <th>Comment</th>
                            <th>Report ID</th>
                            <th>Created At</th>
                            <th>Hành động</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="f" items="${feedbacks}">
                            <tr class="<c:if test='${f.rating <= 3}'>low-rating</c:if>">
                                <td>${f.feedbackID}</td>
                                <td>${f.accountID}</td>
                                 <td>${f.ward.wardName}</td> <!-- ✅ Hiển thị tên phường -->
                                <td>
                                    ${f.rating} ⭐
                                    <c:if test="${f.rating <= 2}">
                                        <i class="fa-solid fa-triangle-exclamation warning-icon" title="Phản hồi tiêu cực!"></i>
                                    </c:if>
                                </td>
                                <td style="text-align: left;">${f.comment}</td>
                                <td>${f.reportID}</td>
                                <td>${f.createdAt}</td>
                                <td>
                                    <button type="button" class="btn btn-sm btn-info action-btn view-btn"
                                            data-id="${f.feedbackID}"
                                            data-account="${f.accountID}"
                                            data-ward="${f.ward.wardName}"
                                            data-rating="${f.rating}"
                                            data-comment="${f.comment}"
                                            data-report="${f.reportID}"
                                            data-created="${f.createdAt}">
                                        <i class="fa-solid fa-eye"></i> Xem
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 🧾 Modal chi tiết phản hồi -->
<div class="modal fade" id="feedbackModal" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title"><i class="fa-solid fa-comment-dots"></i> Chi tiết phản hồi</h5>
                <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <table class="table table-bordered">
                    <tr><th>ID</th><td id="detail-id"></td></tr>
                    <tr><th>Account ID</th><td id="detail-account"></td></tr>
                    <tr><th>Ward ID</th><td id="detail-ward"></td></tr>
                    <tr><th>Rating</th><td id="detail-rating"></td></tr>
                    <tr><th>Comment</th><td id="detail-comment"></td></tr>
                    <tr><th>Report ID</th><td id="detail-report"></td></tr>
                    <tr><th>Created At</th><td id="detail-created"></td></tr>
                </table>

                <hr>
                <h6><i class="fa-solid fa-reply"></i> Trả lời phản hồi</h6>
                <textarea id="replyContent" class="form-control" rows="3" placeholder="Nhập nội dung phản hồi..."></textarea>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Đóng</button>
                <button type="button" class="btn btn-success" id="sendReplyBtn">
                    <i class="fa-solid fa-paper-plane"></i> Gửi phản hồi
                </button>
            </div>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // ⚡ Lọc realtime
    const startInput = document.getElementById("startDate");
    const endInput = document.getElementById("endDate");
    const ratingSelect = document.getElementById("ratingFilter");
    const clearBtn = document.getElementById("clearFilter");
    const table = document.getElementById("feedbackTable");
    const rows = table.getElementsByTagName("tr");

    function filterTable() {
        const startDate = startInput.value ? new Date(startInput.value) : null;
        const endDate = endInput.value ? new Date(endInput.value) : null;
        const ratingValue = ratingSelect.value ? parseInt(ratingSelect.value) : null;

        for (let i = 1; i < rows.length; i++) {
            const cells = rows[i].getElementsByTagName("td");
            if (!cells || cells.length < 7) continue;

            const createdAtStr = cells[6].textContent.trim().split(" ")[0];
            const feedbackDate = new Date(createdAtStr);
            const ratingText = cells[3].textContent.trim().split(" ")[0];
            const rating = parseInt(ratingText);

            let show = true;
            if (startDate && feedbackDate < startDate) show = false;
            if (endDate && feedbackDate > endDate) show = false;
            if (ratingValue && rating !== ratingValue) show = false;

            rows[i].style.display = show ? "" : "none";
        }
    }

    startInput.addEventListener("change", filterTable);
    endInput.addEventListener("change", filterTable);
    ratingSelect.addEventListener("change", filterTable);

    clearBtn.addEventListener("click", () => {
        startInput.value = "";
        endInput.value = "";
        ratingSelect.value = "";
        for (let i = 1; i < rows.length; i++) rows[i].style.display = "";
    });

    $(function () { $('[title]').tooltip(); });

    // ⚙️ Xem chi tiết
    $(document).on("click", ".view-btn", function () {
        $("#detail-id").text($(this).data("id"));
        $("#detail-account").text($(this).data("account"));
        $("#detail-ward").text($(this).data("ward"));
        $("#detail-rating").html($(this).data("rating") + " ⭐");
        $("#detail-comment").text($(this).data("comment"));
        $("#detail-report").text($(this).data("report"));
        $("#detail-created").text($(this).data("created"));
        $("#feedbackModal").modal("show");
    });

    // 📩 Gửi phản hồi
    $("#sendReplyBtn").click(function () {
        const feedbackId = $("#detail-id").text();
        const replyText = $("#replyContent").val().trim();

        if (replyText === "") {
            alert("Vui lòng nhập nội dung phản hồi!");
            return;
        }

        $.ajax({
            url: "${pageContext.request.contextPath}/feedback/reply",
            method: "POST",
            data: { feedbackID: feedbackId, reply: replyText },
            success: function () {
                alert("✅ Đã gửi phản hồi thành công!");
                $("#feedbackModal").modal("hide");
                $("#replyContent").val("");
            },
            error: function () {
                alert("❌ Gửi phản hồi thất bại!");
            }
        });
    });
</script>
</body>
</html>



