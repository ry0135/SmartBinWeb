<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Thêm báo cáo</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css"/>
</head>
<body>
<div class="container mt-4">
    <h2>📝 Thêm báo cáo mới</h2>

    <form:form method="post" modelAttribute="report" class="form">
        <div class="form-group">
            <label for="binID">BinID</label>
            <form:input path="binID" cssClass="form-control"/>
        </div>
        <div class="form-group">
            <label for="accountID">AccountID</label>
            <form:input path="accountID" cssClass="form-control"/>
        </div>
        <div class="form-group">
            <label for="reportType">Loại báo cáo</label>
            <form:input path="reportType" cssClass="form-control"/>
        </div>
        <div class="form-group">
            <label for="description">Mô tả</label>
            <form:textarea path="description" cssClass="form-control"/>
        </div>
        <div class="form-group">
            <label for="assignedTo">Người xử lý</label>
            <form:input path="assignedTo" cssClass="form-control"/>
        </div>

        <button type="submit" class="btn btn-success">Lưu</button>
        <a href="/reports" class="btn btn-secondary">Quay lại</a>
    </form:form>
</div>
</body>
</html>
