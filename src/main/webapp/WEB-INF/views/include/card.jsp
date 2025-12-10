<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>
    .stats-card-clickable {
        transition: all 0.3s ease;
        cursor: pointer;
        border-radius: 10px;
        border: 2px solid transparent;
        position: relative;
        overflow: hidden;
    }

    .stats-card-clickable:hover {
        transform: translateY(-5px);
        box-shadow: 0 8px 16px rgba(0,0,0,0.15) !important;
    }

    .stats-card-clickable.active {
        transform: scale(0.98);
        box-shadow: 0 2px 4px rgba(0,0,0,0.2) !important;
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

    /* Card Border Colors */
    .border-left-warning { border-left: 4px solid #f6c23e !important; }
    .border-left-info { border-left: 4px solid #36b9cc !important; }
    .border-left-success { border-left: 4px solid #1cc88a !important; }
    .border-left-danger { border-left: 4px solid #e74a3b !important; }
    .border-left-issue { border-left: 4px solid #6f42c1 !important; } /* Purple */

    /* Text Colors */
    .text-purple { color: #6f42c1 !important; }

    .text-xs { font-size: 0.75rem; letter-spacing: 0.5px; }
    .font-weight-bold { font-weight: 700; }
    .text-gray-800 { color: #5a5c69 !important; }
    .text-gray-300 { color: #dddfeb !important; }
</style>

<div class="row g-4 mb-4">

    <!-- Task mở -->
    <div class="col-xl-2 col-md-6">
        <a href="${pageContext.request.contextPath}/tasks/open" class="text-decoration-none">
            <div class="card border-left-warning shadow h-100 stats-card-clickable">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">
                                Nhiệm vụ mở
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                ${openBatches != null ? openBatches : 0}
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
    <div class="col-xl-2 col-md-6">
        <a href="${pageContext.request.contextPath}/tasks/doing" class="text-decoration-none">
            <div class="card border-left-info shadow h-100 stats-card-clickable">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-info text-uppercase mb-1">
                                Đang thực hiện
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                ${doingBatches != null ? doingBatches : 0}
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

    <!-- Batch gặp sự cố (MỚI) -->
    <div class="col-xl-2 col-md-6">
        <a href="${pageContext.request.contextPath}/tasks/issue" class="text-decoration-none">
            <div class="card border-left-issue shadow h-100 stats-card-clickable">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-purple text-uppercase mb-1">
                                Gặp sự cố
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                ${issueBatches != null ? issueBatches : 0}
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-exclamation-triangle fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </a>
    </div>

    <!-- Đã hoàn thành -->
    <div class="col-xl-2 col-md-6">
        <a href="${pageContext.request.contextPath}/tasks/completed" class="text-decoration-none">
            <div class="card border-left-success shadow h-100 stats-card-clickable">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-success text-uppercase mb-1">
                                Hoàn thành
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                ${completedBatches != null ? completedBatches : 0}
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

    <!-- Bị hủy -->
    <div class="col-xl-2 col-md-6">
        <a href="${pageContext.request.contextPath}/tasks/cancel" class="text-decoration-none">
            <div class="card border-left-danger shadow h-100 stats-card-clickable">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-danger text-uppercase mb-1">
                                Bị hủy
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                ${cancelBatches != null ? cancelBatches : 0}
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
        const cards = document.querySelectorAll('.stats-card-clickable');

        cards.forEach(card => {
            card.addEventListener('click', function() {
                cards.forEach(c => c.classList.remove('active'));
                this.classList.add('active');
                setTimeout(() => this.classList.remove('active'), 300);
            });
        });

        // Highlight theo URL
        const currentPath = window.location.pathname;

        cards.forEach(card => {
            const link = card.closest('a');
            if (link && currentPath.includes(link.getAttribute('href'))) {

                if (card.classList.contains('border-left-warning')) card.style.borderColor = '#f6c23e';
                if (card.classList.contains('border-left-info')) card.style.borderColor = '#36b9cc';
                if (card.classList.contains('border-left-success')) card.style.borderColor = '#1cc88a';
                if (card.classList.contains('border-left-danger')) card.style.borderColor = '#e74a3b';
                if (card.classList.contains('border-left-issue')) card.style.borderColor = '#6f42c1';

                card.style.borderWidth = '3px';
            }
        });
    });
</script>
