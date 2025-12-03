<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <title>Chat – Manager</title>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
</head>
<body>

<!-- Header riêng của manager -->
<jsp:include page="/WEB-INF/views/include/sidebar.jsp"/>

<!-- Gọi lại phần thân chat dùng chung -->
<jsp:include page="/WEB-INF/views/admin/chat_room_body.jsp"/>

</body>
</html>
