<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>

<%-- Lấy Page<Account> theo tên đối tượng truyền từ file cha --%>
<c:set var="accPage" value="${requestScope[param.pageObj]}"/>

<style>
  .table thead th{font-weight:700;color:#166534}
  .badge-active{background:#22c55e}.badge-banned{background:#9ca3af}
  .btn-ban{background:#ef4444;color:#fff;border:none}.btn-ban:hover{background:#dc2626}
  .btn-unban{background:#22c55e;color:#fff;border:none}.btn-unban:hover{background:#16a34a}
</style>

<div class="table-responsive">
  <table class="table table-hover align-middle mb-0">
    <thead class="table-light">
    <tr>
      <th style="width:90px;">ID</th>
      <th>Họ tên</th>
      <th>Email</th>
      <th style="width:120px;">Trạng thái</th>
      <th style="width:170px;">Tạo lúc</th>
      <th style="width:170px;">Thao tác</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="a" items="${accPage.content}">
      <tr>
        <td><span class="fw-bold">${a.accountId}</span></td>
        <td>${a.fullName}</td>
        <td>${a.email}</td>
        <td>
          <c:choose>
            <c:when test="${a.status == 1}">
              <span class="badge badge-active">Active</span>
            </c:when>
            <c:otherwise>
              <span class="badge badge-banned">Banned</span>
            </c:otherwise>
          </c:choose>
        </td>
        <td><fmt:formatDate value="${a.createdAt}" pattern="yyyy-MM-dd HH:mm"/></td>
        <td>
          <c:choose>
            <c:when test="${a.status == 1}">
              <!-- NÚT BAN: chỉ mở modal dùng chung; truyền data-* đầy đủ -->
              <button type="button"
                      class="btn btn-sm btn-ban"
                      data-bs-toggle="modal"
                      data-bs-target="#banModal"
                      data-id="${a.accountId}"
                      data-name="${fn:escapeXml(a.fullName)}"
                      data-base="${param.baseUrl}"
                      data-role="${param.pageObj}"
                      data-page="${accPage.number}">
                <i class="fa-solid fa-ban me-1"></i>Ban
              </button>
            </c:when>
            <c:otherwise>
              <!-- Unban submit trực tiếp -->
              <form method="post" action="${param.baseUrl}/${a.accountId}/unban" style="display:inline;">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <c:if test="${status != null}"><input type="hidden" name="status" value="${status}"/></c:if>
                <c:if test="${not empty q}"><input type="hidden" name="q" value="${fn:escapeXml(q)}"/></c:if>
                <c:choose>
                  <c:when test="${param.pageObj=='managers'}"><input type="hidden" name="pageM" value="${accPage.number}"/></c:when>
                  <c:when test="${param.pageObj=='workers'}"><input type="hidden" name="pageW" value="${accPage.number}"/></c:when>
                  <c:when test="${param.pageObj=='users'}"><input type="hidden" name="pageU" value="${accPage.number}"/></c:when>
                </c:choose>
                <button type="submit" class="btn btn-sm btn-unban">
                  <i class="fa-solid fa-check me-1"></i>Unban
                </button>
              </form>
            </c:otherwise>
          </c:choose>
        </td>
      </tr>
    </c:forEach>

    <c:if test="${empty accPage.content}">
      <tr>
        <td colspan="6" class="text-center text-muted py-4">Không có dữ liệu</td>
      </tr>
    </c:if>
    </tbody>
  </table>
</div>

<c:if test="${accPage.totalPages > 1}">
  <nav class="p-3">
    <ul class="pagination mb-0 justify-content-center">
      <c:set var="base" value='${pageContext.request.contextPath}/admin/accounts' />
      <li class="page-item ${accPage.first ? 'disabled' : ''}">
        <a class="page-link"
           href="${base}
                 ?pageM=${param.pageObj=='managers'? accPage.number-1 : param.pageM!=null?param.pageM:0}
                 &pageW=${param.pageObj=='workers' ? accPage.number-1 : param.pageW!=null?param.pageW:0}
                 &pageU=${param.pageObj=='users'   ? accPage.number-1 : param.pageU!=null?param.pageU:0}
                 <c:if test='${status != null}'>&status=${status}</c:if>
                 <c:if test='${not empty q}'>&q=${fn:escapeXml(q)}</c:if>#${param.anchor}">
          «
        </a>
      </li>
      <c:forEach var="i" begin="0" end="${accPage.totalPages - 1}">
        <li class="page-item ${i == accPage.number ? 'active' : ''}">
          <a class="page-link"
             href="${base}
                   ?pageM=${param.pageObj=='managers'? i : param.pageM!=null?param.pageM:0}
                   &pageW=${param.pageObj=='workers' ? i : param.pageW!=null?param.pageW:0}
                   &pageU=${param.pageObj=='users'   ? i : param.pageU!=null?param.pageU:0}
                   <c:if test='${status != null}'>&status=${status}</c:if>
                   <c:if test='${not empty q}'>&q=${fn:escapeXml(q)}</c:if>#${param.anchor}">
              ${i + 1}
          </a>
        </li>
      </c:forEach>
      <li class="page-item ${accPage.last ? 'disabled' : ''}">
        <a class="page-link"
           href="${base}
                 ?pageM=${param.pageObj=='managers'? accPage.number+1 : param.pageM!=null?param.pageM:0}
                 &pageW=${param.pageObj=='workers' ? accPage.number+1 : param.pageW!=null?param.pageW:0}
                 &pageU=${param.pageObj=='users'   ? accPage.number+1 : param.pageU!=null?param.pageU:0}
                 <c:if test='${status != null}'>&status=${status}</c:if>
                 <c:if test='${not empty q}'>&q=${fn:escapeXml(q)}</c:if>#${param.anchor}">
          »
        </a>
      </li>
    </ul>
  </nav>
</c:if>
