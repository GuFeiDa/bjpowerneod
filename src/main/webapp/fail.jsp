<%
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <base href="<%=basePath%>">
    <title>Title</title>

</head>
<body>
    <h5>哎呀，页面找不到啦~</h5>
    <img src="image/fail.jpg">
</body>
</html>
