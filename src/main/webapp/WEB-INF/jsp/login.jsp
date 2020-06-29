<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

	<script>
		$(function () {

            if(window.top!=window){
                window.top.location=window.location;
            }



			//点击登录按钮，发送请求
			$("#loginBtn").click(function () {
				// alert("loginAct : " + $("#loginAct").val() +"   loginPwd : "+$("#loginPwd").val())

				//十天免登陆操作
				//获取十天免登陆的复选框状态
				var flag = "";
				if($("#flag").prop("checked")){
					flag = "a";
				}
				//发送ajax请求，进行登录操作。
				$.ajax({
					type: "POST",
					dataType:"json",
					url: "workbench/user/ajax2login.do",
					data: {
						"loginAct":$("#loginAct").val(),
						"loginPwd":$("#loginPwd").val(),
						"flag":flag
					},
					success: function(data){
						//alert( "Data Saved: " + msg );
						//data : { "success" : true/false , "msg" : xxx } //后台返回
						if(data.success){
							//登录成功
							//跳转到工作台的欢迎页面
							window.location.href = "workbench/user/toWorkbenchIndex.do";
						}else{
							//登录失败
							alert(data.msg);
						}
					}
				});


			})

			// $("#loginBtn").click(function () {
			// 	$("#loginForm").submit();
			// });


			//让登录用户名输入框获取焦点事件
			$("#loginAct").focus();


		})
	</script>
</head>
<body>
	<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
		<img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
	</div>
	<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
		<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 12px;">&copy;2019&nbsp;动力节点</span></div>
	</div>
	
	<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
		<div style="position: absolute; top: 0px; right: 60px;">
			<div class="page-header">
				<h1>登录</h1>
			</div>
			<%--
				当输入用户名和密码时，点击登录按钮，如果登录成功会跳转到jsp页面
					现在是不能够直接跳转的，因为jsp页面都在WEB-INF下面，受保护的资源目录
				如果想要跳转到对应的jsp页面，需要发送请求到达controller控制器，由视图解析器进行页面的跳转
			--%>

			<%--
				写url的时候：
					jsp页面的url，写的相对路径
						action="/workbench/user/login.do"
							http://localhost:8080/workbench/user/login.do?loginAct=zs&loginPwd=123
							缺少项目名称
						action="workbench/user/login.do"
							http://localhost:8080/crm/workbench/user/login.do?loginAct=zs&loginPwd=123

					后台控制器的url，写的是绝对路径，以/开头。

				什么时候使用get请求，什么时候使用post呢？
					增删改的时候，使用post
					查询使用get

				表单提交的方式：
					1.通过action属性method属性，进行提交表单的请求
						<form action="workbench/user/login.do" method="post" class="form-horizontal" role="form">

					2.通过ajax发送请求
						$.ajax({
						   type: "POST",
						   dataType:"json",
						   url: "workbench/user/login.do",
						   data: {
						   		"loginAct":$("#loginAct").val(),
						   		"loginPwd":$("#loginPwd").val()
						   },
						   success: function(msg){
							 alert( "Data Saved: " + msg );
						   }
						});

					3.通过事件发送请求，submit();
						$("#loginForm").submit();
			--%>
			<form id="loginForm" class="form-horizontal" role="form">
				<div class="form-group form-group-lg">
					<div style="width: 350px;">
						<%--添加input标签的name属性key，输入的内容就是value
								autocomplete="off" 属性，关闭自动提示。
						--%>
						<input id="loginAct" name="loginAct" autocomplete="off" class="form-control" type="text" placeholder="用户名">
					</div>
					<div style="width: 350px; position: relative;top: 20px;">
						<input id="loginPwd" name="loginPwd" class="form-control" type="password" placeholder="密码">
					</div>
					<div class="checkbox"  style="position: relative;top: 30px; left: 10px;">
						<label>
							<input id="flag" type="checkbox"> 十天内免登录
						</label>
						&nbsp;&nbsp;
						<span id="msg"></span>
					</div>
					<%--<button type="submit" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;">登录</button>--%>
					<button id="loginBtn" type="button" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;">登录</button>
				</div>
			</form>
		</div>
	</div>
</body>
</html>