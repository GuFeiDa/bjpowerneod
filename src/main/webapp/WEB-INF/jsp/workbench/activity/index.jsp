<%@ page import="com.bjpowernode.crm.workbench.domain.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
//User user = (User) session.getAttribute("user");
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
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>

<script type="text/javascript">

	$(function(){

		//TODO 0.引入时间控件
		//年月日时分秒
		// $(".time").datetimepicker({
		// 	language:  "zh-CN",
		// 	format: "yyyy-mm-dd hh:ii:ss",//显示格式
		// 	minView: "hour",//设置只显示到月份
		// 	initialDate: new Date(),//初始化当前日期
		// 	autoclose: true,//选中自动关闭
		// 	todayBtn: true, //显示今日按钮
		// 	clearBtn : true,
		// 	pickerPosition: "bottom-left"
		// });

		//年月日
		$(".dateTime").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "bottom-left"
		});



		//TODO 1.点击创建按钮，打开新增市场活动的模态窗口
		//
		$("#saveBtn").click(function () {
			// $("#createActivityModal").modal("show");
			//使用ajax局部更新html代码
			//获取用户列表

			//   workbench/user/findAll.do 获取用户列表的url
			//   workbench/activity/getUserList.do 获取用户列表的url，在本模块下（推荐）
			$.ajax({
				url: "workbench/activity/getUserList.do",
				data: {

				},
				type: "get",
				dataType:"json",
				success: function(data){

					//data : [ {id:xxx,name:xxx....} ...]
					//data : { success:true/false , msg:xxx , uList : [ {id:xxx,name:xxx....} ... ] }
					if(data.success){

						//使用ajax发送异步请求，局部刷新页面数据
						//通过字符串拼接html代码加载
						var html = "<option></option>";

						$.each(data.uList,function (i, n) {
							html += "<option value="+n.id+">"+n.name+"</option>"
						})

						//将拼接后的html字符串，插入到select标签中
						$("#create-owner").html(html);

						//默认选中当前登录的用户
						//在js代码中获取session中的属性直接使用el表达式即可，必须用字符串套起来。
						$("#create-owner").val("${user.id}");

						//打开模态窗口
						$("#createActivityModal").modal("show");
					}else{
						//查询失败
						alert(data.msg)
					}
				}
			});


		})


		//TODO 2.提交市场活动表单数据
		$("#saveActivityBtn").click(function () {
			//校验，所有者和名称

			//发送ajax请求
			$.ajax({
				url: "workbench/activity/saveActivity.do",
				data: {
					"owner":$.trim( $("#create-owner").val() ),
					"name":$.trim( $("#create-name").val() ),
					"startDate":$.trim( $("#create-startDate").val() ),
					"endDate":$.trim( $("#create-endDate").val() ),
					"cost":$.trim( $("#create-cost").val() ),
					"description":$.trim( $("#create-description").val() )
				},
				type: "post",
				dataType:"json",
				success: function(data){

					//data : { success:true/false , msg : xxx }
					if(data.success){

						//清空表单数据
						// $("#saveForm").reset();

						//跳转到市场活动的首页
						// window.location.href = "workbench/activity/toActivityIndex.do";
						getPageList(1,5);
					}else{
						alert(data.msg)
					}
				}
			});

		})


		//TODO 3.封装加载页面的列表方法
		getPageList(1,5);

		//TODO 4.全选/反选
		//完成页面的全选/反选
		$("#selectAll").click(function () {
			//将所有的复选框，进行选中/取消操作
			$("input[name=flag]").prop("checked", $("#selectAll").prop("checked") )
		})

		//获取tbody对象，操作的是它里面的子标签，给它的子标签绑定事件
		//参数1，事件的名称
		//参数2，绑定的对象，一个或多个
		//执行事件的回调方法
		$("#activityTbody").on("click",$("input[name=flag]"),function () {
			// alert("hello world")
			//反选操作，当复选框全部选中，将全选按钮，自动勾选。
			$("#selectAll").prop(
					"checked",
					$("input[name=flag]").length == $("input[name=flag]:checked").length
			)

		})


		//TODO 5.删除，一个/多个
		//点击删除按钮时，执行的业务逻辑
		$("#deleteBtn").click(function () {
		if(confirm("确定要删除吗？")){
			//校验
			var flags = $("input[name=flag]:checked");
			if( flags.length == 0 ){
				//没有选中要删除的数据，提示
				alert("亲，请至少选择一条要删除的数据")
			}else{
				//已选中数据了
				//参数拼接，删除提交的参数是一个或多个市场活动的ID
				var activityIds = "";

				//获取所有选中的复选框对象，通过该对象获取value属性
				$.each(flags,function (i, n) {
					//通过dom对象获取value属性
					// activityIds += "activityIds=" + n.value;

					//通过jquery对象获取value属性
					activityIds += "activityIds=" + $(n).val();

					//拼接参数符号
					if(i<flags.length -1){
						activityIds+="&"
					}
				})
				// alert(activityIds)
				$.ajax({
					url: "workbench/activity/deleteByIds.do?"+activityIds,
					data: {

					},
					type: "post",
					dataType:"json",
					success: function(data){

						//data : { success:true/false , msg: xxx }
						if(data.success){
							//删除成功，跳转到当前页
							getPageList(
									$("#activityPage").bs_pagination('getOption', 'currentPage'),
									$("#activityPage").bs_pagination('getOption', 'rowsPerPage')
							)
						}else{
							//删除失败
							alert(data.msg);
						}
					}
				});
			}
		}
		})



	});


	function getPageList(pageNo,pageSize) {
		//发送ajax请求，然后刷新列表
		//注意：正常查询少量条件使用get请求，多个参数使用post请求
		//js里面可以不包过双引号的，但是，后面学习使用的一些工具，就必须严格区分json格式。

		//将当前页，进行计算，算出查询页码的索引值
		var pageNoInx = ((pageNo-1) * pageSize);

		var name = $.trim( $("#search-name").val() );
		var startDate = $.trim( $("#search-startDate").val() );
		var endDate = $.trim( $("#search-endDate").val() );

		$.ajax({
			url: "workbench/activity/getPageList.do",
			data: {
				"pageNo":pageNoInx,
				"pageSize":pageSize,
				"userId":"${user.id}",
				"name":name,
				"startDate":startDate,
				"endDate":endDate
			},
			type: "post",
			dataType:"json",
			success: function(data){

				//data : {success:true/false,msg:xxx,aList:[{activity1},{activity2}...],total:xxx}
				if(data.success){
					//请求成功，加载列表
					//定义一个html变量，用于拼接html标签
					var html = "";

					//每个n，就代表着每个activity对象
					$.each(data.aList , function (i, n) {
						//拼接html变量
						html += '<tr class="active">';
						//复选框的属性设置name，批量操作
						html += '<td><input name="flag" value='+n.id+' type="checkbox" /></td>';
						html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/activity/toDetail.do?id='+n.id+'\';">'+n.name+'</a></td>';
						// html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/activity/detail.do?id='+n.id+'\';">'+n.name+'</a></td>';
						html += '<td>'+n.owner+'</td>';
						html += '<td>'+n.startDate+'</td>';
						html += '<td>'+n.endDate+'</td>';
						html += '</tr>';
					})

					//加载html
					$("#activityTbody").html(html);

					//计算总页数,总页数=总记录数/每页条数
					//20 / 5 = 4页， 21 / 5 = 5页
					var totalPages = data.total % pageSize == 0 ? data.total / pageSize : parseInt(data.total / pageSize) + 1;
					//加载分页插件
					$("#activityPage").bs_pagination({
						currentPage: pageNo, // 页码
						rowsPerPage: pageSize, // 每页显示的记录条数
						maxRowsPerPage: 20, // 每页最多显示的记录条数
						totalPages: totalPages, // 总页数
						totalRows: data.total, // 总记录条数

						visiblePageLinks: 3, // 显示几个卡片

						showGoToPage: true,
						showRowsPerPage: true,
						showRowsInfo: true,
						showRowsDefaultInfo: true,

						onChangePage : function(event, data){
							getPageList(data.currentPage , data.rowsPerPage);
						}
					});


				}else{
					//请求失败
					alert(data.msg);
				}
			}
		});
	}

	
</script>
</head>
<body>

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form id="saveForm" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">
									<%--使用ajax发送异步请求，是无法通过el表达式进行页面取值的--%>
									<%--c:foreach使用，通过springmvc跳转，然后将数据存入到request域中，通过el表达式可以获取--%>
									<%--<c:forEach items="${uList}" var="u">--%>
									  <%--<option>张三</option>--%>
									  <%--<option>李四</option>--%>
									  <%--<option>wangwu</option>--%>
									<%--</c:forEach>--%>
								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-name">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<%--关闭自动提示，只读，并且引入时间控件的样式--%>
								<input type="text" readonly autocomplete="off" class="form-control dateTime" id="create-startDate">
							</div>
							<label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" readonly autocomplete="off" class="form-control dateTime" id="create-endDate">
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="saveActivityBtn" type="button" class="btn btn-primary" data-dismiss="modal">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-marketActivityOwner">
								  <option>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>
								</select>
							</div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-marketActivityName" value="发传单">
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-startTime" value="2020-10-10">
							</div>
							<label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-endTime" value="2020-10-20">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost" value="5,000">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 导入市场活动的模态窗口 -->
    <div class="modal fade" id="importActivityModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">导入市场活动</h4>
                </div>
                <div class="modal-body" style="height: 350px;">
                    <div style="position: relative;top: 20px; left: 50px;">
                        请选择要上传的文件：<small style="color: gray;">[仅支持.xls或.xlsx格式]</small>
                    </div>
                    <div style="position: relative;top: 40px; left: 50px;">
                        <input type="file" id="activityFile">
                    </div>
                    <div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;" >
                        <h3>重要提示</h3>
                        <ul>
                            <li>操作仅针对Excel，仅支持后缀名为XLS/XLSX的文件。</li>
                            <li>给定文件的第一行将视为字段名。</li>
                            <li>请确认您的文件大小不超过5MB。</li>
                            <li>日期值以文本形式保存，必须符合yyyy-MM-dd格式。</li>
                            <li>日期时间以文本形式保存，必须符合yyyy-MM-dd HH:mm:ss的格式。</li>
                            <li>默认情况下，字符编码是UTF-8 (统一码)，请确保您导入的文件使用的是正确的字符编码方式。</li>
                            <li>建议您在导入真实数据之前用测试文件测试文件导入功能。</li>
                        </ul>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button id="importActivityBtn" type="button" class="btn btn-primary">导入</button>
                </div>
            </div>
        </div>
    </div>
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input id="search-name" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <%--<div class="form-group">--%>
				    <%--<div class="input-group">--%>
				      <%--<div class="input-group-addon">所有者</div>--%>
				      <%--<input id="search-owner" class="form-control" type="text">--%>
				    <%--</div>--%>
				  <%--</div>--%>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input id="search-startDate" class="form-control dateTime" autocomplete="off" readonly type="text" id="startTime" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input id="search-endDate" class="form-control dateTime" autocomplete="off" readonly type="text" id="endTime">
				    </div>
				  </div>
				  
				  <button onclick="getPageList(1,5)" type="button" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
					<%--
						BootStrap提供的模态窗口：
							通过点击事件控制，打开模态窗口/关闭模态窗口。
							相对比JSP，风格比较好看，无需更多的JSP页面。

						通过点击事件来控制模态窗口时，非常简单的。

						在打开或关闭模态窗口时，可以通过标签中的属性进行控制，也可以通过js代码进行控制。
							data-toggle="modal" 设置当前为打开的模态窗口
							data-target="#createActivityModal" 打开目标的模态窗口，模态窗口的ID

							$("#createActivityModal").modal("show/hide");打开或关闭模态窗口
					--%>
				  <button id="saveBtn" type="button" class="btn btn-primary"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" data-toggle="modal" data-target="#editActivityModal"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button id="deleteBtn" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				<div class="btn-group" style="position: relative; top: 18%;">
                    <button type="button" class="btn btn-default" data-toggle="modal" data-target="#importActivityModal" ><span class="glyphicon glyphicon-import"></span> 上传列表数据（导入）</button>
                    <button id="exportActivityAllBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（批量导出）</button>
                    <button id="exportActivityXzBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（选择导出）</button>
                </div>
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input id="selectAll" type="checkbox" /></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="activityTbody">
					<%--
						列表加载的时机：
							1.进入市场活动页面，需要加载列表
							2.通过点击页面上的分页按钮，加载列表
							3.点击页面的创建、修改、删除按钮，操作完毕后，需要加载列表
							4.在页面的搜索条件中，添加条件，需要加载列表
					--%>
						<%--<c:forEach items="${aList}" var="a">--%>
							<%--<tr class="active">--%>
								<%--<td><input type="checkbox" /></td>--%>
								<%--<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">${a.name}</a></td>--%>
								<%--<td>${a.owner}</td>--%>
								<%--<td>${a.startDate}</td>--%>
								<%--<td>${a.endDate}</td>--%>
							<%--</tr>--%>
						<%--</c:forEach>--%>
                        <%--<tr class="active">--%>
                            <%--<td><input type="checkbox" /></td>--%>
                            <%--<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">发传单</a></td>--%>
                            <%--<td>zhangsan</td>--%>
                            <%--<td>2020-10-10</td>--%>
                            <%--<td>2020-10-20</td>--%>
                        <%--</tr>--%>
					</tbody>
				</table>
			</div>

			<%--创建的div标签，用于动态的填充分页插件--%>
			<div id="activityPage"></div>

			<%--<div style="height: 50px; position: relative;top: 30px;">--%>
				<%--<div>--%>
					<%--<button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>--%>
				<%--</div>--%>
				<%--<div class="btn-group" style="position: relative;top: -34px; left: 110px;">--%>
					<%--<button type="button" class="btn btn-default" style="cursor: default;">显示</button>--%>
					<%--<div class="btn-group">--%>
						<%--<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">--%>
							<%--10--%>
							<%--<span class="caret"></span>--%>
						<%--</button>--%>
						<%--<ul class="dropdown-menu" role="menu">--%>
							<%--<li><a href="#">20</a></li>--%>
							<%--<li><a href="#">30</a></li>--%>
						<%--</ul>--%>
					<%--</div>--%>
					<%--<button type="button" class="btn btn-default" style="cursor: default;">条/页</button>--%>
				<%--</div>--%>
				<%--<div style="position: relative;top: -88px; left: 285px;">--%>
					<%--<nav>--%>
						<%--<ul class="pagination">--%>
							<%--<li class="disabled"><a href="#">首页</a></li>--%>
							<%--<li class="disabled"><a href="#">上一页</a></li>--%>
							<%--<li class="active"><a href="#">1</a></li>--%>
							<%--<li><a href="#">2</a></li>--%>
							<%--<li><a href="#">3</a></li>--%>
							<%--<li><a href="#">4</a></li>--%>
							<%--<li><a href="#">5</a></li>--%>
							<%--<li><a href="#">下一页</a></li>--%>
							<%--<li class="disabled"><a href="#">末页</a></li>--%>
						<%--</ul>--%>
					<%--</nav>--%>
				<%--</div>--%>
			<%--</div>--%>
			
		</div>
		
	</div>
</body>
</html>