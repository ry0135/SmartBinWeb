<%--
  Created by IntelliJ IDEA.
  User: ACER
  Date: 10/23/2025
  Time: 9:31 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html>
<%@include file="../include/head.jsp"%>
<body>

<!-- Sidebar -->
<%@include file="../include/sidebar.jsp"%>

<!-- Main Content -->
<div class="flex-grow-1" style="margin-left: 250px;">
    <!-- Content -->
    <div class="content p-4">
        <div class="row justify-content-center">
            <div class="col-lg-10">
                <!-- Page Header -->
                <div class="mb-4">
                    <h2 class="h3 mb-2 text-dark">
                        <i class="fas fa-edit text-primary me-2"></i>
                        Chỉnh Sửa Batch Nhiệm Vụ
                    </h2>
                    <p class="text-muted mb-0">Batch ID: <strong>${batchId}</strong> | Tổng số task: <strong>${batchTasks.size()}</strong></p>
                </div>

                <!-- Assignment Form -->
                <form id="editBatchForm" method="post">
                    <input type="hidden" id="batchId" value="${batchId}">

                    <!-- Main Card -->
                    <div class="card border-0 shadow-sm">
                        <!-- Card Header -->
                        <div class="card-header bg-white border-bottom py-3">
                            <div class="d-flex align-items-center justify-content-between">
                                <div class="d-flex align-items-center">
                                    <div class="bg-primary text-white rounded-3 p-2 me-3">
                                        <i class="fas fa-edit"></i>
                                    </div>
                                    <h5 class="mb-0 text-dark">Thông tin Batch</h5>
                                </div>
                                <div class="d-flex gap-2">
                                    <a href="${pageContext.request.contextPath}/tasks/management" class="btn btn-secondary btn-sm">
                                        <i class="fas fa-times me-1"></i> Hủy bỏ
                                    </a>
                                    <button type="button" class="btn btn-primary btn-sm" onclick="saveBatch()">
                                        <i class="fas fa-save me-1"></i> Lưu thay đổi
                                    </button>
                                </div>
                            </div>
                        </div>

                        <div class="card-body p-4">
                            <!-- Batch Info -->
                            <div class="alert alert-info mb-4">
                                <div class="row">
                                    <div class="col-md-4">
                                        <strong>Batch ID:</strong> ${batchId}
                                    </div>
                                    <div class="col-md-4">
                                        <strong>Tổng task:</strong> ${batchTasks.size()}
                                    </div>
                                    <div class="col-md-4">
                                        <strong>Loại nhiệm vụ:</strong>
                                        <span class="badge ${firstTask.taskType == 'COLLECTION' ? 'bg-primary' : 'bg-warning'}">
                                            <c:choose>
                                                <c:when test="${firstTask.taskType == 'COLLECTION'}">Thu gom rác</c:when>
                                                <c:when test="${firstTask.taskType == 'MAINTENANCE'}">Bảo trì</c:when>
                                                <c:otherwise>${firstTask.taskType}</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                </div>
                                <div class="row mt-2">
                                    <div class="col-md-6">
                                        <strong>Nhân viên hiện tại:</strong> ${firstTask.assignedTo.fullName}
                                    </div>
                                    <div class="col-md-6">
                                        <strong>Ngày tạo:</strong> ${firstTask.createdAt}
                                    </div>
                                </div>
                            </div>




                            <!-- Form Section -->
                            <div class="row g-4 mb-4">
                                <div class="col-md-12">
                                    <label class="form-label fw-semibold" for="priority">
                                        <i class="fas fa-exclamation-circle me-1"></i>
                                        Độ ưu tiên: <span id="priority-value" class="text-warning">
                                            <c:choose>
                                                <c:when test="${firstTask.priority == 5}">5 - Rất cao</c:when>
                                                <c:when test="${firstTask.priority == 4}">4 - Cao</c:when>
                                                <c:when test="${firstTask.priority == 3}">3 - Trung bình</c:when>
                                                <c:when test="${firstTask.priority == 2}">2 - Thấp</c:when>
                                                <c:when test="${firstTask.priority == 1}">1 - Rất thấp</c:when>
                                                <c:otherwise>${firstTask.priority} - Trung bình</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </label>
                                    <div class="mt-2">
                                        <input type="range" class="form-range" id="priority" name="priority"
                                               min="1" max="5" value="${firstTask.priority}" required>
                                        <div class="d-flex justify-content-between mt-1">
                                            <small class="text-muted">Rất thấp</small>
                                            <small class="text-muted">Thấp</small>
                                            <small class="text-muted">Trung bình</small>
                                            <small class="text-muted">Cao</small>
                                            <small class="text-muted">Rất cao</small>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Workers Table -->
                            <div class="mb-4">
                                <label class="form-label fw-semibold">
                                    <i class="fas fa-users me-1"></i> Chọn nhân viên phụ trách
                                </label>
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead class="table-light">
                                        <tr>
                                            <th width="60" class="text-center">Chọn</th>
                                            <th>Nhân viên</th>
                                            <th>Phường</th>
                                            <th>Nhiệm vụ hiện tại</th>
                                            <th>Trạng thái</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <c:forEach var="worker" items="${workers}">
                                            <tr class="worker-row" style="cursor: pointer;">
                                                <td class="text-center">
                                                    <div class="form-check">
                                                        <input class="form-check-input" type="radio"
                                                               name="workerId" value="${worker.accountId}"
                                                            ${firstTask.assignedTo.accountId == worker.accountId ? 'checked' : ''}
                                                               required>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div>
                                                        <div class="fw-semibold text-dark">${worker.fullName}</div>
                                                        <small class="text-muted">${worker.email}</small>
                                                    </div>
                                                </td>
                                                <td>
                                                    <span class="badge bg-light text-dark">${worker.ward.wardName}</span>
                                                </td>
                                                <td>
                                                    <c:set var="taskCount" value="${worker.taskCount}" />
                                                    <span class="badge ${taskCount <= 2 ? 'bg-success' : taskCount <= 5 ? 'bg-warning' : 'bg-danger'}">
                                                        <i class="fas fa-tasks me-1"></i> ${taskCount} nhiệm vụ
                                                    </span>
                                                </td>
                                                <td>
                                                    <c:if test="${firstTask.assignedTo.accountId == worker.accountId}">
                                                        <span class="badge bg-info">Đang phụ trách</span>
                                                    </c:if>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                            <!-- Notes Section -->
                            <div class="mb-4">
                                <label class="form-label fw-semibold" for="notes">
                                    <i class="fas fa-sticky-note me-1"></i> Ghi chú nhiệm vụ
                                </label>
                                <textarea class="form-control" id="notes" name="notes" rows="4"
                                          placeholder="Thêm ghi chú cho nhiệm vụ này...">${firstTask.notes}</textarea>
                            </div>

                            <!-- Action Buttons -->
                            <div class="d-flex gap-3 justify-content-end border-top pt-4">
                                <a href="${pageContext.request.contextPath}/tasks/open" class="btn btn-secondary">
                                    <i class="fas fa-times me-2"></i> Hủy bỏ
                                </a>
                                <button type="button" class="btn btn-primary" onclick="saveBatch()">
                                    <i class="fas fa-save me-2"></i> Lưu thay đổi
                                </button>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    // Add selected row styling
    const style = document.createElement('style');
    style.textContent = `
    .worker-row.selected {
        background-color: #e3f2fd !important;
        border-left: 3px solid #0d6efd;
    }
    .worker-row:hover {
        background-color: #f8f9fa !important;
    }
`;
    document.head.appendChild(style);

    // Handle row selection
    document.querySelectorAll('.worker-row').forEach(row => {
        row.addEventListener('click', (e) => {
            // Only handle click if not clicking directly on radio button
            if (!e.target.closest('input[type="radio"]')) {
                const radio = row.querySelector('input[type="radio"]');
                if (radio) {
                    radio.checked = true;
                    // Update visual state
                    document.querySelectorAll('.worker-row').forEach(r => r.classList.remove('selected'));
                    row.classList.add('selected');
                }
            } else {
                // If clicking on radio, update selection
                document.querySelectorAll('.worker-row').forEach(r => r.classList.remove('selected'));
                row.classList.add('selected');
            }
        });
    });

    // Initialize worker row selection
    document.addEventListener('DOMContentLoaded', function() {
        const selectedRadio = document.querySelector('input[name="workerId"]:checked');
        if (selectedRadio) {
            const selectedRow = selectedRadio.closest('.worker-row');
            if (selectedRow) {
                selectedRow.classList.add('selected');
            }
        }
    });

    // Handle priority slider
    const prioritySlider = document.getElementById('priority');
    const priorityValue = document.getElementById('priority-value');

    // Priority data with descriptions and colors
    const priorityData = {
        1: { text: '1 - Rất thấp', color: 'text-success' },
        2: { text: '2 - Thấp', color: 'text-info' },
        3: { text: '3 - Trung bình', color: 'text-warning' },
        4: { text: '4 - Cao', color: 'text-danger' },
        5: { text: '5 - Rất cao', color: 'text-danger' }
    };

    // Update priority display
    prioritySlider.addEventListener('input', function() {
        const value = this.value;
        const data = priorityData[value];

        // Remove all color classes
        priorityValue.className = priorityValue.className.replace(/text-\w+/g, '');

        // Set new text and color
        priorityValue.textContent = data.text;
        priorityValue.classList.add(data.color);
    });

    // Initialize on page load
    document.addEventListener('DOMContentLoaded', function() {
        prioritySlider.dispatchEvent(new Event('input'));
    });

    // Save batch changes - SỬA LẠI để gửi form data
    async function saveBatch() {
        const batchId = document.getElementById('batchId').value;
        const workerId = document.querySelector('input[name="workerId"]:checked')?.value;
        const priority = parseInt(document.getElementById('priority').value);
        const notes = document.getElementById('notes').value;

        if (!workerId) {
            alert('Vui lòng chọn một nhân viên!');
            return;
        }

        // Tạo form data
        const formData = new FormData();
        formData.append('workerId', workerId);
        formData.append('priority', priority);
        formData.append('notes', notes);

        try {
            const response = await fetch('${pageContext.request.contextPath}/tasks/batch/' + batchId + '/update', {
                method: 'POST',
                body: formData
            });

            if (response.ok) {
                alert('Cập nhật batch thành công!');
                window.location.href = '${pageContext.request.contextPath}/tasks/open';
            } else {
                alert('Có lỗi xảy ra khi cập nhật batch');
            }
        } catch (error) {
            console.error('Error:', error);
            alert('Có lỗi xảy ra khi lưu thay đổi. Vui lòng thử lại!');
        }
    }
</script>
</body>
</html>