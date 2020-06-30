<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<%@ page isELIgnored="false" contentType="text/html;charset=UTF-8" language="java" %>
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

			//TODO 1.字典值列表加载


			//TODO 2.新增字典值
			//点击保存按钮，首先去查询数据，相同字典类型编码的字典值是否已存在
			$("#saveBtn").click(function () {
				// alert($("#create-typeCode").val())
				// alert($("#create-value").val())
				if($("#create-typeCode").val() == "" || $("#create-value").val() == ""){
					//提示
					$("#msg").html("请输入编码或属性值");
					return;
				}

				//发送ajax请求去查询
				$.ajax({
					url: "settings/dictionary/value/findByCodeOrValue.do",
					data: {
						"typeCode" : $.trim($("#create-typeCode").val()),
						"value" : $.trim($("#create-value").val())
					},
					type: "get",
					dataType:"json",
					success: function(data){

						//data : {success : true/false , msg : xxxx }
						if(data.success){
							//不重复，提交表单
							$("#saveForm").submit();
						}else{
							//提示信息
							$("#msg").html(data.msg);
						}
					}
				});
			})



		})

	</script>

</head>
<body>

	<div style="position:  relative; left: 30px;">
		<h3>新增字典值</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button id="saveBtn" type="button" class="btn btn-primary">保存</button>
			<button type="button" class="btn btn-default" onclick="window.history.back();">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form id="saveForm" action="settings/dictionary/value/saveDicValue.do" method="post" class="form-horizontal" role="form">
					
		<div class="form-group">
			<label for="create-dicTypeCode" class="col-sm-2 control-label">字典类型编码<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select name="typeCode" class="form-control" id="create-typeCode" style="width: 200%;">
				  <option></option>
					<c:forEach items="${cList}" var="code">
				  		<option value="${code}">${code}</option>
				  		<%--<option>机构类型</option>--%>
					</c:forEach>
				</select>
				<span id="msg"></span>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-dicValue" class="col-sm-2 control-label">字典值<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input name="value" type="text" class="form-control" id="create-value" style="width: 200%;">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-text" class="col-sm-2 control-label">文本</label>
			<div class="col-sm-10" style="width: 300px;">
				<input name="text" type="text" class="form-control" id="create-text" style="width: 200%;">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-orderNo" class="col-sm-2 control-label">排序号</label>
			<div class="col-sm-10" style="width: 300px;">
				<input name="orderNo" type="text" class="form-control" id="create-orderNo" style="width: 200%;">
			</div>
		</div>
	</form>
	
	<div style="height: 200px;"></div>
</body>
</html>