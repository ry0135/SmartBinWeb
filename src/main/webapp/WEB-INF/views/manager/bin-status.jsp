<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Real-time Bin Status</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css">
    <style>
        .bin-card {
            border-left: 5px solid;
            margin-bottom: 15px;
        }
        .status-0 { border-color: #ffc107; } /* Bảo trì - Vàng */
        .status-1 { border-color: #28a745; } /* Hoạt động - Xanh */
        .status-2 { border-color: #dc3545; } /* Đầy - Đỏ */
        .progress { height: 25px; }
    </style>
</head>
<body>
<jsp:include page="header_manager.jsp"/>

<div class="container mt-4">
    <h2 class="mb-4">Real-time Bin Status</h2>

    <!-- Filter Section -->
    <div class="card mb-4">
        <div class="card-body">
            <form class="row g-3">
                <div class="col-md-4">
                    <label class="form-label">Filter by Status:</label>
                    <select name="status" class="form-select">
                        <option value="">All Status</option>
                        <option value="0" ${param.status == '0' ? 'selected' : ''}>Maintenance</option>
                        <option value="1" ${param.status == '1' ? 'selected' : ''}>Active</option>
                        <option value="2" ${param.status == '2' ? 'selected' : ''}>Full</option>
                    </select>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Fill Threshold (≥ ${threshold*100}%):</label>
                    <input type="range" name="threshold" class="form-range" min="0.5" max="1" step="0.1" value="${threshold}">
                </div>
                <div class="col-md-4 d-flex align-items-end">
                    <button type="submit" class="btn btn-primary">Filter</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Critical Bins Alert -->
    <c:if test="${not empty criticalBins}">
        <div class="alert alert-warning">
            <strong>Warning!</strong> ${criticalBins.size()} bins are over ${threshold*100}% full
        </div>
    </c:if>

    <!-- Bin List -->
    <div class="row">
        <c:forEach items="${bins}" var="bin">
            <div class="col-md-6">
                <div class="card bin-card status-${bin.status}">
                    <div class="card-body">
                        <h5 class="card-title">${bin.binCode}</h5>
                        <h6 class="card-subtitle mb-2 text-muted">
                                ${bin.street}, ${bin.ward}
                        </h6>
                        <div class="mt-3">
                            <p>Capacity: ${bin.capacity}L (${bin.currentFill}L filled)</p>
                            <div class="progress">
                                <div class="progress-bar
                                         ${bin.currentFill/bin.capacity >= 0.9 ? 'bg-danger' :
                                           bin.currentFill/bin.capacity >= 0.7 ? 'bg-warning' : 'bg-success'}"
                                     style="width: ${(bin.currentFill/bin.capacity)*100}%">
                                        ${Math.round((bin.currentFill/bin.capacity)*100)}%
                                </div>
                            </div>
                        </div>
                        <p class="card-text mt-2">
                            <small class="text-muted">
                                Last updated: ${bin.lastUpdated}
                            </small>
                        </p>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>