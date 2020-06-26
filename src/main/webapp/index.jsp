<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">
</head>
<body>
	<script type="text/javascript">
		<!--window.location.href=login.jsp-->
		document.location.href = "login.jsp";
	</script>
</body>
</html>