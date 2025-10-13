<%--
  Created by IntelliJ IDEA.
  User: ACER
  Date: 10/8/2025
  Time: 1:09 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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