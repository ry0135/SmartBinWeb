

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../include/head.jsp"%>
<%@include file="../include/sidebar.jsp"%>

<html>
<head>
    <title>Update</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

    <style>
        body {
            background-color: #f6f8fa;
            font-family: "Segoe UI", sans-serif;
        }

        .main-content {
            margin-left: 260px;
            padding: 50px 20px;
            min-height: 100vh;
        }

        .fade-in {
            opacity: 0;
            transform: translateY(20px);
            animation: fadeIn 0.6s ease-out forwards;
        }

        @keyframes fadeIn {
            to { opacity: 1; transform: translateY(0); }
        }

        .edit-container {
            max-width: 700px;
            margin: 0 auto;
            background: #fff;
            border-radius: 20px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            padding: 40px 50px;
            transition: all 0.3s ease;
        }

        .edit-container:hover {
            box-shadow: 0 10px 35px rgba(0,0,0,0.15);
        }

        h3 {
            text-align: center;
            margin-bottom: 40px;
            font-weight: 700;
            color: #333;
        }

        h3 span {
            color: #ff7b00;
        }

        label {
            font-weight: 600;
            color: #555;
            margin-bottom: 6px;
        }

        .input-group {
            position: relative;
            display: flex;
            align-items: center;
        }

        .input-group i {
            position: absolute;
            left: 15px;
            color: #888;
            font-size: 16px;
        }

        /* --- FIX CĂN CHỮ & HIỂN THỊ --- */
        .form-control {
            border-radius: 12px;
            padding: 10px 40px 10px 42px !important;
            font-size: 15.5px;
            line-height: 1.5 !important;
            border: 1px solid #d0d7de;
            background-color: #f9fafb;
            color: #333;
            height: auto !important;
            box-sizing: border-box;
            transition: all 0.2s ease;
        }

        .form-control:focus {
            border-color: #20c997;
            box-shadow: 0 0 0 0.2rem rgba(32,201,151,0.25);
            background-color: #fff;
            outline: none;
        }

        textarea.form-control {
            resize: vertical;
            padding-left: 42px !important;
            padding-top: 12px;
            line-height: 1.6 !important;
        }

        /* input readonly hoặc select */
        input[readonly],
        select:disabled {
            background-color: #eef1f4 !important;
            color: #444 !important;
            cursor: not-allowed;
        }

        /* Nút */
        .btn {
            border-radius: 10px;
            font-weight: 600;
            padding: 10px 22px;
            transition: 0.3s;
        }

        .btn-success {
            background: linear-gradient(135deg, #28a745, #20c997);
            border: none;
        }

        .btn-success:hover {
            background: linear-gradient(135deg, #20c997, #28a745);
            transform: translateY(-2px);
        }

        .btn-secondary {
            background: #6c757d;
            border: none;
        }

        .btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }

        .action-buttons {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-top: 25px;
        }

        @media (max-width: 768px) {
            .main-content { margin-left: 0; padding: 20px; }
            .edit-container { padding: 25px; }
        }
    </style>
</head>
<body>
<div class="main-content fade-in">
    <div class="edit-container">
        <h3> <span>Update</span></h3>

        <form action="${pageContext.request.contextPath}/update" method="post">
            <input type="hidden" name="reportID" value="${report.reportId}" />
            <input type="hidden" name="binID" value="${report.binId}" />
            <input type="hidden" name="accountID" value="${report.accountId}" />

            <div class="form-group">
                <label>Loại báo cáo:</label>
                <div class="input-group">
                    <i class="fa-solid fa-file-lines"></i>
                    <input type="text" name="reportType" class="form-control" value="${report.reportType}" readonly>
                </div>
            </div>

            <div class="form-group">
                <label>Mô tả:</label>
                <div class="input-group">
                    <i class="fa-solid fa-pen"></i>
                    <textarea name="description" class="form-control" rows="3">${report.description}</textarea>
                </div>
            </div>

            <div class="form-group">
                <label>Trạng thái:</label>
                <div class="input-group">
                    <i class="fa-solid fa-flag"></i>
                    <select name="status" class="form-control">
                        <option value="RECEIVED" ${report.status == 'RECEIVED' ? 'selected' : ''}>RECEIVED</option>
                        <option value="IN_PROGRESS" ${report.status == 'IN_PROGRESS' ? 'selected' : ''}>IN PROGRESS</option>
                        <option value="RESOLVED" ${report.status == 'RESOLVED' ? 'selected' : ''}>RESOLVED</option>
                    </select>
                </div>
            </div>

            <div class="form-group">
                <label>Người xử lý:</label>
                <div class="input-group">
                    <i class="fa-solid fa-user-check"></i>
                    <input type="text" name="assignedTo" class="form-control" value="${report.assignedTo}">
                </div>
            </div>

            <div class="action-buttons">
                <a href="${pageContext.request.contextPath}/detail/${report.reportId}" class="btn btn-secondary">
                    <i class="fa-solid fa-arrow-left"></i> Quay lại
                </a>
                <button type="submit" class="btn btn-success">
                    <i class="fa-solid fa-floppy-disk"></i> Lưu thay đổi
                </button>
            </div>
        </form>
    </div>
</div>
</body>
</html>


