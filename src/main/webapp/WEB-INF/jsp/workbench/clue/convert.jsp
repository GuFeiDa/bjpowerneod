<%@ page import="com.bjpowernode.crm.workbench.domain.User" %>
<%@ page isELIgnored="false" contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>


<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript">
	$(function(){

		//年月日
		$(".dateTime").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "top-left"
		});

		$("#isCreateTransaction").click(function(){
			if(this.checked){
				$("#create-transaction2").show(200);
			}else{
				$("#create-transaction2").hide(200);
			}
		});

		// 无处安放的线索ID

		//TODO 0.页面显示数据，公司名称，联系人名称，称呼，所有者名称
		//将线索ID赋值到隐藏域中
		$("#clueId").val("${c.id}");

		//TODO 1.是否创建交易，设置一个标识
		var flag = "";
		$("#isCreateTransaction").click(function () {
			if($("#isCreateTransaction").prop("checked")){
				flag = "a";
			}else{
				flag = "";
			}
		})

		//TODO 2.点击搜索市场活动的图标，获取已关联的市场活动列表信息
		$("#searchIconBtn").click(function () {
			getRelationActivityList();
		})

		//TODO 3.模糊搜索市场活动名称
		$("#search-activityName").keydown(function (event) {
			if(event.keyCode == 13){
				//按下了回车键
				//发送ajax请求
				$.ajax({
					url: "workbench/clue/getRelationActivityListLike.do",
					data: {
						"clueId":"${c.id}",
						"activityName":$.trim($("#search-activityName").val())
					},
					type: "post",
					dataType:"json",
					success: function(data){
						//data : {success:true/false,msg:xxx,aList:[...]}
						if(data.success){
							var html = "";

							$.each(data.aList,function (i, n) {
								html += '<tr>';
								html += '<td><input type="radio" value="'+n.id+'" name="activity"/></td>';
								html += '<td id="n_'+n.id+'">'+n.name+'</td>';
								html += '<td>'+n.startDate+'</td>';
								html += '<td>'+n.endDate+'</td>';
								html += '<td>'+n.owner+'</td>';
								html += '</tr>';
							})

							//刷新列表
							$("#search-activity").html(html);

						}
					}
				});
			}
			return false;
		})

		//TODO 4.点击模态窗口中的保存按钮，存储市场活动ID以及显示市场活动名称
		$("#saveActivityBtn").click(function () {
			//获取选中的市场活动
			var activityId = $("input[name=activity]:checked").val();
			//给隐藏域赋值
			$("#activityId").val(activityId);

			var activityName = $("#n_"+activityId).html();
			//回显到页面上
			$("#activity").val(activityName);
		})

		//TODO 5.进行线索转换，将线索转换为客户、联系人，对应的备注信息也需要转换，如果创建了交易，创建交易。
		$("#exchangeBtn").click(function () {
			$("#flag").val(flag);
			$("#exchangeClueForm").submit();
		})



	});

	function getRelationActivityList() {
		$.ajax({
			url: "workbench/clue/getRelationActivityList.do",
			data: {
				"clueId":"${c.id}"
			},
			type: "get",
			dataType:"json",
			success: function(data){

				//data : {success:true/false , msg:xxx , aList:[...]}
				//加载列表，并打开模态窗口
				if(data.success){
					//请求成功
					var html = "";

					$.each(data.aList,function (i, n) {
						html += '<tr>';
						html += '<td><input type="radio" value="'+n.id+'" name="activity"/></td>';
						html += '<td id="n_'+n.id+'">'+n.name+'</td>';
						html += '<td>'+n.startDate+'</td>';
						html += '<td>'+n.endDate+'</td>';
						html += '<td>'+n.owner+'</td>';
						html += '</tr>';
					})
					//加载列表
					$("#search-activity").html(html);

					//打开模态窗口
					$("#searchActivityModal").modal("show");
				}else{
					//提示
				}
			}
		});
	}
</script>

</head>
<body>
	
	<!-- 搜索市场活动的模态窗口 -->
	<div class="modal fade" id="searchActivityModal" role="dialog" >
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">搜索市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input id="search-activityName" type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="search-activity">
							<%--<tr>--%>
								<%--<td><input type="radio" name="activity"/></td>--%>
								<%--<td>发传单</td>--%>
								<%--<td>2020-10-10</td>--%>
								<%--<td>2020-10-20</td>--%>
								<%--<td>zhangsan</td>--%>
							<%--</tr>--%>
							<%--<tr>--%>
								<%--<td><input type="radio" name="activity"/></td>--%>
								<%--<td>发传单</td>--%>
								<%--<td>2020-10-10</td>--%>
								<%--<td>2020-10-20</td>--%>
								<%--<td>zhangsan</td>--%>
							<%--</tr>--%>
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="saveActivityBtn" type="button" class="btn btn-primary" data-dismiss="modal">保存</button>
				</div>
			</div>
		</div>
	</div>


	<div id="title" class="page-header" style="position: relative; left: 20px;">
		<%--
			线索表
			fullname 客户名称   --->   联系人表的fullname字段
			company  公司名称   --->   客户表的name字段
			owner    所有者名称 --->   用户表的name字段

		--%>
		<h4>转换线索 <small>${c.fullname} ${c.appellation}-${c.company}</small></h4>
	</div>
	<div id="create-customer" style="position: relative; left: 40px; height: 35px;">
		新建客户：${c.company}
	</div>
	<div id="create-contact" style="position: relative; left: 40px; height: 35px;">
		新建联系人：${c.fullname} ${c.appellation}
	</div>
	<div id="create-transaction1" style="position: relative; left: 40px; height: 35px; top: 25px;">
		<input type="checkbox" id="isCreateTransaction"/>
		为客户创建交易
	</div>
	<div id="create-transaction2" style="position: relative; left: 40px; top: 20px; width: 80%; background-color: #F7F7F7; display: none;" >
	
		<form id="exchangeClueForm" method="post" action="workbench/clue/exchangeClue.do">

			<%--保存activityId--%>
			<input type="hidden" name="activityId" id="activityId">
			<%--保存线索ID--%>
			<input type="hidden" name="clueId" id="clueId">
			<%--创建交易的标识--%>
			<input type="hidden" name="flag" id="flag" >

		  <div class="form-group" style="width: 400px; position: relative; left: 20px;">
		    <label for="amountOfMoney">金额</label>
		    <input type="text" class="form-control" id="money" name="money">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="tradeName">交易名称</label>
		    <input type="text" class="form-control" id="tradeName" name="name">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="expectedClosingDate">预计成交日期</label>
		    <input type="text" class="form-control dateTime" readonly autocomplete="off" name="expectedDate" id="expectedClosingDate">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="stage">阶段</label>
		    <select id="stage" name="stage"  class="form-control">
		    	<option></option>
				<c:forEach items="${stageList}" var="s">
		    		<option value="${s.value}">${s.text}</option>
				</c:forEach>
		    	<%--<option>需求分析</option>--%>
		    	<%--<option>价值建议</option>--%>
		    	<%--<option>确定决策者</option>--%>
		    	<%--<option>提案/报价</option>--%>
		    	<%--<option>谈判/复审</option>--%>
		    	<%--<option>成交</option>--%>
		    	<%--<option>丢失的线索</option>--%>
		    	<%--<option>因竞争丢失关闭</option>--%>
		    </select>
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
			  <%-- data-toggle="modal" data-target="#searchActivityModal" --%>
		    <label for="activity">市场活动源&nbsp;&nbsp;<a id="searchIconBtn" href="javascript:void(0);"style="text-decoration: none;"><span class="glyphicon glyphicon-search"></span></a></label>
		    <input type="text" class="form-control" id="activity" placeholder="点击上面搜索" readonly>
		  </div>
		</form>
		
	</div>
	
	<div id="owner" style="position: relative; left: 40px; height: 35px; top: 50px;">
		记录的所有者：<br>
		<b>${c.owner}</b>
	</div>
	<div id="operation" style="position: relative; left: 40px; height: 35px; top: 100px;">
		<input id="exchangeBtn" class="btn btn-primary" type="button" value="转换">
		&nbsp;&nbsp;&nbsp;&nbsp;
		<input class="btn btn-default" type="button" value="取消">
	</div>
</body>
</html>