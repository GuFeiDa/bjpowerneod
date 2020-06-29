<%@ page import="com.bjpowernode.crm.settings.domain.DicType" %>
<%@ page import="java.util.List" %><%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";

//	List<DicType> dtList = (List<DicType>) request.getAttribute("dtList");
%>
<%@ page isELIgnored="false" contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
			//修改操作
			//如果没有勾选复选框，弹出提示
			//获取复选框 <input name="flag" type="checkbox">的选中状态
			$("#updateBtn").click(function () {
				//JSON.stringify方法是将对象转换为字符串
				// alert(JSON.stringify($("input[name=flag]:checked").length))

				//要获取input输入中的复选框
				//input[name=flag]，获取所有的input标签name为flag的复选框
				//input[name=flag]:checked，获取所有的已选中的复选框
				// $("input[name=flag]:checked").length

				if($("input[name=flag]:checked").length == 0){
					//一个都没选中
					alert("请至少选择一条数据，进行修改操作")
				}else if($("input[name=flag]:checked").length > 1){
					//选中多个
					alert("只能选中一条数据，进行修改操作")
				}else{
					//选中一个
					//查询，根据唯一标识，选中的编码
					//alert($("input[name=flag]:checked").val())
					var code = $("input[name=flag]:checked").val();
					window.location.href="settings/dictionary/type/findDicTypeByCode.do?code="+code;
				}
			})

		})

	</script>
</head>
<body>

	<div>
		<div style="position: relative; left: 30px; top: -10px;">
			<div class="page-header">
				<h3>字典类型列表</h3>
			</div>
		</div>
	</div>
	<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;left: 30px;">
		<div class="btn-group" style="position: relative; top: 18%;">
			<%--点击创建按钮，跳转到save.jsp页面--%>
		  <button type="button" class="btn btn-primary" onclick="window.location.href='settings/dictionary/type/toDicTypeSave.do'"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				<%--onclick="window.location.href='edit.jsp'"--%>
		  <button id="updateBtn" type="button" class="btn btn-default" ><span class="glyphicon glyphicon-edit"></span> 编辑</button>
		  <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	<div style="position: relative; left: 30px; top: 20px;">
		<table class="table table-hover">
			<thead>
				<tr style="color: #B3B3B3;">
					<td><input type="checkbox" /></td>
					<td>序号</td>
					<td>编码</td>
					<td>名称</td>
					<td>描述</td>
				</tr>
			</thead>

			<%--使用<%%>和<%=%>来将java代码和html代码进行混合编程，这样的方式，繁琐，不好维护。
			<%
				for(int i=0;i<dtList.size();i++){
					DicType dt = dtList.get(i);
			%>
					<tbody>
						<tr class="active">
							<td><input type="checkbox" /></td>
							<td><%=i+1%></td>
							<td><%=dt.getCode()%></td>
							<td><%=dt.getName()%></td>
							<td><%=dt.getDescription()%></td>
						</tr>
					</tbody>
			<%
				}
			%>
			--%>

			<%--在此基础上，进行优化，使用jstl标签库，进行使用,c:foreach标签进行遍历
					要先导入jstl标签库
					isELIgnored=false ，让页面加载el表达式。
					items属性，使用el表达式，获取想要遍历的集合名称
					var属性，每次遍历的变量名称
					varStatus：变量的状态属性，count，index等，index从0开始，count从1开始计数。
			--%>
			<c:forEach items="${dtList}" var="dt" varStatus="a">
				<tbody>
					<tr class="active">
						<%--
							在复选框的input标签上，设置name和value的属性
								name属性：可以根据属性获取多个选中的复选框
								value属性：通过选中的复选框的jquery对象通过val()方法获取value属性值
						--%>
						<td><input name="flag" value="${dt.code}" type="checkbox" /></td>
						<td>${a.count}</td>
						<td>${dt.code}</td>
						<td>${dt.name}</td>
						<td>${dt.description}</td>
					</tr>
				</tbody>
			</c:forEach>
		</table>
	</div>
	
</body>
</html>