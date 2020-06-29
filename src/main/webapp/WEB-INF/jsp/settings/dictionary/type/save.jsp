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
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

	<script>
		$(function () {
			//捕获光标在code输入框中
			$("#code").focus();



			// var codeContent = $.trim($("#code").val());

			//当点击保存按钮
			$("#saveBtn").click(function () {
				//进行校验
				var codeContent = $("#code").val();
				if(codeContent == ""){
					alert("编码不能为空，请重新输入");

				}
				//发送ajax请求,查询code编码是否重复
				$.ajax({
					url: "settings/dictionary/type/checkTypeCode.do",
					data: {
						"code": $.trim(codeContent)
					},
					type: "get",
					dataType:"json",
					success: function(data){
						// data参数，是服务器响应回来的数据
						// 它是和公司约定的一些参数
						// data : { success : true/false , msg : xxxx }
						// data : { code/status : 20000/20001 , msg : xxxx }
						// 以后在公司，基本上返回值都是使用通用的返回值类
						if(data.success){
							// 不重复，可以新增，提交表单
							$("#saveForm").submit();
						}else{
							// 重复，提示消息
							// 方式1，使用alert()进行弹出提示
							// alert(data.msg);
							// 方式2，往span标签中添加文本内容
							$("#msg").html(data.msg);
						}
					}
				});
				//如果重复了，弹出提示信息

				//如果没有重复，提交表单数据，进行新增

			})




		})
	</script>
</head>
<body>

	<div style="position:  relative; left: 30px;">
		<h3>新增字典类型</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button id="saveBtn" type="button" class="btn btn-primary">保存</button>
			<button type="button" class="btn btn-default" onclick="window.history.back();">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form id="saveForm" method="post" action="settings/dictionary/type/saveDicType.do" class="form-horizontal" role="form">
					
		<div class="form-group">
			<label for="create-code" class="col-sm-2 control-label">编码<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<%--

					通常情况下实体类的属性名称和数据库的字段名称是一致的。
					如果不一致，前端的name属性应该以实体类属性名称为准

				--%>
				<input type="text" name="code" class="form-control" id="code" style="width: 200%;">
				<span id="msg"></span>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-name" class="col-sm-2 control-label">名称</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" name="name" class="form-control" id="name" style="width: 200%;">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-describe" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 300px;">
				<textarea class="form-control" name="description" rows="3" id="describe" style="width: 200%;"></textarea>
			</div>
		</div>
	</form>
	
	<div style="height: 200px;"></div>
</body>
</html>