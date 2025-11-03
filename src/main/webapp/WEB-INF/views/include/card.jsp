<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>
    .stats-card-clickable {
        transition: all 0.3s ease;
        cursor: pointer;
        border-radius: 10px;
        border: 2px solid transparent;
    }

    .stats-card-clickable:hover {
        transform: translateY(-5px);
        box-shadow: 0 8px 16px rgba(0,0,0,0.15) !important;
    }

    .stats-card-clickable.active {
        transform: scale(0.98);
        box-shadow: 0 2px 4px rgba(0,0,0,0.2) !important;
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

    /* Border màu cho các card */
    .border-left-warning {
        border-left: 4px solid #f6c23e !important;
    }

    .border-left-info {
        border-left: 4px solid #36b9cc !important;
    }

    .border-left-success {
        border-left: 4px solid #1cc88a !important;
    }

    .border-left-danger {
        border-left: 4px solid #e74a3b !important;
    }

    /* Icon hover effect */
    .stats-card-clickable:hover .fa-2x {
        transform: scale(1.1);
        transition: transform 0.3s ease;
    }

    /* Text styling */
    .text-xs {
        font-size: 0.75rem;
        letter-spacing: 0.5px;
    }

    .font-weight-bold {
        font-weight: 700;
    }

    .text-gray-800 {
        color: #5a5c69 !important;
    }

    .text-gray-300 {
        color: #dddfeb !important;
    }

    /* Card body padding */
    .stats-card-clickable .card-body {
        padding: 1.25rem;
    }

    /* Link styling */
    .text-decoration-none:hover {
        text-decoration: none !important;
    }
</style>

<div class="row g-4 mb-4">
    <!-- Task đang mở -->
    <div class="col-xl-3 col-md-6">
        <a href="${pageContext.request.contextPath}/tasks/open" class="text-decoration-none">
            <div class="card border-left-warning shadow h-100 stats-card-clickable"
                 id="openTasksCard"
                 title="Click để xem task đang mở">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">
                                Task đang mở
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                ${openTasks != null ? openTasks : 0}
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-folder-open fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </a>
    </div>

    <!-- Đang thực hiện -->
    <div class="col-xl-3 col-md-6">
        <a href="${pageContext.request.contextPath}/tasks/doing" class="text-decoration-none">
            <div class="card border-left-info shadow h-100 stats-card-clickable"
                 id="doingTasksCard"
                 title="Click để xem task đang thực hiện">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-info text-uppercase mb-1">
                                Đang thực hiện
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                ${doingTasks != null ? doingTasks : 0}
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-spinner fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </a>
    </div>

    <!-- Đã hoàn thành -->
    <div class="col-xl-3 col-md-6">
        <a href="${pageContext.request.contextPath}/tasks/completed" class="text-decoration-none">
            <div class="card border-left-success shadow h-100 stats-card-clickable"
                 id="completedTasksCard"
                 title="Click để xem task đã hoàn thành">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-success text-uppercase mb-1">
                                Đã hoàn thành
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                ${completedTasks != null ? completedTasks : 0}
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-check-circle fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </a>
    </div>

    <!-- Task Cancel -->
    <div class="col-xl-3 col-md-6">
        <a href="${pageContext.request.contextPath}/tasks/cancel" class="text-decoration-none">
            <div class="card border-left-danger shadow h-100 stats-card-clickable"
                 id="cancelTasksCard"
                 title="Click để xem task đã hủy">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-danger text-uppercase mb-1">
                                Task đã hủy
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                ${cancelTasks != null ? cancelTasks : 0}
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-times-circle fa-2x text-gray-300"></i>
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

                // Tự động remove class active sau 300ms
                setTimeout(() => {
                    this.classList.remove('active');
                }, 300);
            });

            // Thêm hiệu ứng hover cho icon
            card.addEventListener('mouseenter', function() {
                const icon = this.querySelector('.fa-2x');
                if (icon) {
                    icon.style.transform = 'scale(1.1) rotate(5deg)';
                }
            });

            card.addEventListener('mouseleave', function() {
                const icon = this.querySelector('.fa-2x');
                if (icon) {
                    icon.style.transform = 'scale(1) rotate(0deg)';
                }
            });
        });

        // Thêm sự kiện cho phím tắt (1-4)
        document.addEventListener('keydown', function(e) {
            if (e.key >= '1' && e.key <= '4') {
                const index = parseInt(e.key) - 1;
                if (cards[index]) {
                    const link = cards[index].closest('a');
                    if (link) {
                        link.click();
                    }
                }
            }
        });

        // Highlight card active dựa trên URL hiện tại
        const currentPath = window.location.pathname;
        cards.forEach(card => {
            const link = card.closest('a');
            if (link && currentPath.includes(link.getAttribute('href'))) {
                card.style.borderColor = card.classList.contains('border-left-warning') ? '#f6c23e' :
                    card.classList.contains('border-left-info') ? '#36b9cc' :
                        card.classList.contains('border-left-success') ? '#1cc88a' : '#e74a3b';
                card.style.borderWidth = '3px';
            }
        });
    });
</script>