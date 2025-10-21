<%--
  Created by IntelliJ IDEA.
  User: ACER
  Date: 10/8/2025
  Time: 1:09 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>
    .stats-card-clickable {
        transition: all 0.3s ease;
        cursor: pointer;
    }

    .stats-card-clickable:hover {
        transform: translateY(-5px);
        box-shadow: 0 4px 8px rgba(0,0,0,0.2) !important;
    }

    .stats-card-clickable.active {
        transform: scale(0.98);
        box-shadow: 0 2px 4px rgba(0,0,0,0.2) !important;
        border-width: 2px !important;
    }

    /* Hiệu ứng ripple */
    .stats-card-clickable {
        position: relative;
        overflow: hidden;
    }

    .stats-card-clickable::after {
        content: '';
        position: absolute;
        top: 50%;
        left: 50%;
        width: 0;
        height: 0;
        border-radius: 50%;
        background: rgba(255, 255, 255, 0.3);
        transform: translate(-50%, -50%);
        transition: width 0.3s ease, height 0.3s ease;
    }

    .stats-card-clickable:active::after {
        width: 300px;
        height: 300px;
    }
</style>

<div class="row mb-4">
    <div class="col-xl-3 col-md-6 mb-4">
        <a href="${pageContext.request.contextPath}/tasks/management" class="text-decoration-none">
            <div class="card border-left-primary shadow h-100 py-2 stats-card-clickable"
                 id="allTasksCard"
                 title="Click để xem tất cả task">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">
                                Tổng số Task
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">${totalTasks}</div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-tasks fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </a>
    </div>

    <div class="col-xl-3 col-md-6 mb-4">
        <a href="${pageContext.request.contextPath}/tasks/open" class="text-decoration-none">
            <div class="card border-left-warning shadow h-100 py-2 stats-card-clickable"
                 id="openTasksCard"
                 title="Click để xem task đang mở">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">
                                Task đang mở
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">${openTasks}</div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-folder-open fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </a>
    </div>

    <div class="col-xl-3 col-md-6 mb-4">
        <a href="${pageContext.request.contextPath}/tasks/doing" class="text-decoration-none">
            <div class="card border-left-info shadow h-100 py-2 stats-card-clickable"
                 id="doingTasksCard"
                 title="Click để xem task đang thực hiện">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-info text-uppercase mb-1">
                                Đang thực hiện
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">${doingTasks}</div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-spinner fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </a>
    </div>

    <div class="col-xl-3 col-md-6 mb-4">
        <a href="${pageContext.request.contextPath}/tasks/completed" class="text-decoration-none">
            <div class="card border-left-success shadow h-100 py-2 stats-card-clickable"
                 id="completedTasksCard"
                 title="Click để xem task đã hoàn thành">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-success text-uppercase mb-1">
                                Đã hoàn thành
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">${completedTasks}</div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-check-circle fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </a>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Lấy tất cả các card
        const cards = document.querySelectorAll('.stats-card-clickable');

        // Thêm sự kiện click cho mỗi card
        cards.forEach(card => {
            card.addEventListener('click', function(e) {
                // Xóa class active từ tất cả các card
                cards.forEach(c => c.classList.remove('active'));

                // Thêm class active cho card được click
                this.classList.add('active');

                // Tự động remove class active sau 500ms để có thể click lại
                setTimeout(() => {
                    this.classList.remove('active');
                }, 500);
            });
        });

        // Thêm sự kiện cho phím tắt (tùy chọn)
        document.addEventListener('keydown', function(e) {
            // 1-4 để chọn các card tương ứng
            if (e.key >= '1' && e.key <= '4') {
                const index = parseInt(e.key) - 1;
                if (cards[index]) {
                    cards[index].click();
                }
            }
        });
    });
</script>