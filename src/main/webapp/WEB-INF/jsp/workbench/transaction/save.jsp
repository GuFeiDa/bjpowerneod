<%@ page import="java.util.Map" %>
<%@ page import="com.fasterxml.jackson.databind.util.JSONWrappedObject" %>
<%@ page import="java.util.Set" %>
<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";

	//从服务器缓存中，获取阶段和可能性集合
	Map<String,String> sMap = (Map<String, String>) application.getAttribute("sMap");

	//将它转换为前台的容器，json对象，json数组

%>
<%@ page isELIgnored="false" contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>

	<script>

		$(function () {
			//TODO 0.加载时间样式
			loadDateTimePicker();

			//TODO 1.加载阶段、类型、来源的数据，从域对象中

			//TODO 2.自动补全
			// $("#create-customerName").change(function () {
			// autoCompletion();
			// })
			autoCompletion();

			//TODO 3.加载阶段和可能性的json数据
			var json = loadStagePossibilityJsonData();
			// alert(json);

			//TODO 4.监听阶段的下拉框，加载对应的可能性数值
			loadPossibilityByStage(json);

			//TODO 5.加载市场活动源信息，将市场活动id存入隐藏域中，模糊搜索自己完成。
			loadActivitySource();

			//TODO 6.加载联系人信息，将联系人id存入到隐藏域中，模糊搜索自己完成。
			//search-contacts-icon
			//加载数据，打开模态窗口
			loadContactsSourceOpen();

			//点击保存按钮，回显数据，将id保存到隐藏域中
			loadContactsSource();

			//TODO 7.点击保存按钮，新增交易记录/交易历史记录
			saveTranAndHistory();
		})

		function saveTranAndHistory() {
			$("#saveTranBtn").click(function () {
				//必填字段的校验

				//获取form表单对象，提交
				$("#tranForm").submit();
			})
		}

		function loadContactsSource() {
			//点击联系人模态窗口中的保存按钮，回显数据，和保存id到隐藏域中
			$("#saveContactsBtn").click(function () {
				var contactsId = $("input[name=contacts]:checked").val();
				var contactsName = $("#c_"+contactsId).html();

				//保存隐藏域
				$("#contactsId").val(contactsId);

				//回显数据
				$("#create-contactsName").val(contactsName);
			})
		}

		function loadContactsSourceOpen() {
			$("#search-contacts-icon").on("click",function () {
				//发送请求，显示列表，打开模态窗口
				$.ajax({
					url: "workbench/transaction/getContacttsList.do",
					data: {

					},
					type: "get",
					dataType:"json",
					success: function(data){
						//data : {success:true/false,msg:xxx,cList:[...]}

						if(data.success){
							//请求成功
							//加载列表
							var html = "";

							$.each(data.cList,function (i, n) {
								html += '<tr>';
								html += '<td><input type="radio" value="'+n.id+'" name="contacts"/></td>';
								html += '<td id="c_'+n.id+'">'+n.fullname+'</td>';
								html += '<td>'+n.email+'</td>';
								html += '<td>'+n.mphone+'</td>';
								html += '</tr>';
							})

							//加载
							$("#contactsBody").html(html);

							//打开模态窗口
							$("#findMarketContacts").modal("show")
						}
					}
				});
			})

		}

		function loadActivitySource() {
			$("#saveActivityBtn").on("click",function () {
				// alert("123")
				var activityId = $("input[name=activity]:checked").val();
				var activityName = $("#n_"+activityId).html();
				alert(activityName)
				//将市场活动名称回显
				$("#create-activitySrc").val(activityName);
				//将市场活动id存入到隐藏域中
				$("#activityId").val(activityId);
				//关闭模态窗口
				$("#findMarketActivity").modal("hide");
			})
		}

		//加载数据，打开模态窗口
		function loadActivitySourceOpen() {
			//点击市场活动源的搜索图标，打开模态窗口
			//加载数据，然后再打开模态窗口 findMarketActivity
			$.ajax({
				url: "workbench/transaction/getActivityList.do",
				data: {

				},
				type: "get",
				dataType:"json",
				success: function(data){
					//data : {success:true/false,msg:xxx,aList:[...]}

					if(data.success){
						//请求成功
						//加载列表
						var html = "";

						$.each(data.aList,function (i, n) {
							html += '<tr>';
							html += '<td><input type="radio" name="activity" value="'+n.id+'"/></td>';
							html += '<td id="n_'+n.id+'">'+n.name+'</td>';
							html += '<td>'+n.startDate+'</td>';
							html += '<td>'+n.endDate+'</td>';
							html += '<td>'+n.owner+'</td>';
							html += '</tr>';
						})

						//加载
						$("#activityBody").html(html);

						//打开模态窗口
						$("#findMarketActivity").modal("show")
					}
				}
			});
		}

		function loadPossibilityByStage(json) {
			$("#create-transactionStage").change(function () {
				//获取当前阶段的属性值
				var stage = $("#create-transactionStage").val();
				// alert(stage);

				//加载阶段对应的可能性数值
				// alert(json[stage])
				$("#create-possibility").val(json[stage]);
			})
		}

		function loadStagePossibilityJsonData() {
			//将java中的集合转换为json数据
			var j = {
				<%
					//编写java代码
					Set<String> keys = sMap.keySet();
					for(String key : keys){
						String value = sMap.get(key);

				%>
						//编写js代码，组合json数据
						"<%=key%>" : "<%=value%>" ,

				<%

					}
				%>
			}
			return j;
		}

		function autoCompletion() {
			$("#create-customerName").typeahead({
				//source，自动补全所指定的方法
				//query参数，输入的关键字
				//process参数，是js传递过来的方法，用它来将返回的数据显示在自动补全的地方。要求返回的结果是List<String>  --> [张三,李四....]
				//delay参数，查询执行毫秒数，每1.5秒执行一次请求，去查询结果
				source: function (query, process) {
					$.post(
							"workbench/transaction/getCustomerName.do",
							{ "name" : query },
							function (data) {
								//alert(data);
								process(data);
							},
							"json"
					);
				},
				delay: 500
			});


		}

		function loadDateTimePicker() {
			//年月日
			$(".dateTimeBottom").datetimepicker({
				minView: "month",
				language:  'zh-CN',
				format: 'yyyy-mm-dd',
				autoclose: true,
				todayBtn: true,
				pickerPosition: "bottom-left"
			});

			//年月日
			$(".dateTimeTop").datetimepicker({
				minView: "month",
				language:  'zh-CN',
				format: 'yyyy-mm-dd',
				autoclose: true,
				todayBtn: true,
				pickerPosition: "top-left"
			});
		}

	</script>
</head>
<body>

	<!-- 查找市场活动 -->	
	<div class="modal fade" id="findMarketActivity" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable3" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
							</tr>
						</thead>
						<tbody id="activityBody">
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

	<!-- 查找联系人 -->	
	<div class="modal fade" id="findMarketContacts" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找联系人</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>邮箱</td>
								<td>手机</td>
							</tr>
						</thead>
						<tbody id="contactsBody">
							<%--<tr>--%>
								<%--<td><input type="radio" name="activity"/></td>--%>
								<%--<td>李四</td>--%>
								<%--<td>lisi@bjpowernode.com</td>--%>
								<%--<td>12345678901</td>--%>
							<%--</tr>--%>
							<%--<tr>--%>
								<%--<td><input type="radio" name="activity"/></td>--%>
								<%--<td>李四</td>--%>
								<%--<td>lisi@bjpowernode.com</td>--%>
								<%--<td>12345678901</td>--%>
							<%--</tr>--%>
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="saveContactsBtn" type="button" class="btn btn-primary" data-dismiss="modal">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	
	<div style="position:  relative; left: 30px;">
		<h3>创建交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button id="saveTranBtn" type="button" class="btn btn-primary">保存</button>
			<button type="button" class="btn btn-default">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form id="tranForm" action="workbench/transaction/saveTran.do" method="post" class="form-horizontal" role="form" style="position: relative; top: -30px;">

		<%--创建隐藏域，activityId--%>
		<input type="hidden" id="activityId" name="activityId">

		<%--创建隐藏域，contactsId--%>
		<input type="hidden" id="contactsId" name="contactsId">

		<div class="form-group">
			<label for="create-transactionOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select name="owner" class="form-control" id="create-transactionOwner"  >
					<c:forEach items="${uList}" var="u">
						<%--
							eq 代表 等于
							le 代表 小于等于
							ge 代表 大于等于
						--%>
						<option value="${u.id}" ${u.id eq user.id ? "selected" : ""}>${u.name}</option>
					</c:forEach>
				  <%--<option>lisi</option>--%>
				  <%--<option>wangwu</option>--%>
				</select>
			</div>
			<label for="create-amountOfMoney" class="col-sm-2 control-label">金额</label>
			<div class="col-sm-10" style="width: 300px;">
				<input name="money" type="text" class="form-control" id="create-amountOfMoney">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-transactionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input name="name" type="text" class="form-control" id="create-transactionName">
			</div>
			<label for="create-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<%--引入时间样式，关闭自动提示，只读--%>
				<input name="expectedDate" type="text" class="form-control dateTimeBottom" readonly autocomplete="off" id="create-expectedClosingDate">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-accountName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<%--如果不点击搜索按钮，直接编写客户姓名，是可以在后台先查询如果没有，再新增客户--%>
				<input name="customerName" type="text" class="form-control" autocomplete="off" id="create-customerName" placeholder="支持自动补全，输入客户不存在则新建">
			</div>
			<label for="create-transactionStage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select name="stage" class="form-control" id="create-transactionStage">
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
		</div>
		
		<div class="form-group">
			<label for="create-transactionType" class="col-sm-2 control-label">类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select name="type" class="form-control" id="create-transactionType">
				  <option></option>
					<c:forEach items="${transactionTypeList}" var="tt">
				  		<option value="${tt.value}">${tt.text}</option>
					</c:forEach>
				  <%--<option>新业务</option>--%>
				</select>
			</div>
			<label for="create-possibility" class="col-sm-2 control-label">可能性</label>
			<div class="col-sm-10" style="width: 300px;">
				<%--根据选中的阶段名称，动态的加载可能性的值--%>
				<input type="text" class="form-control" readonly id="create-possibility">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-clueSource" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select name="source" class="form-control" id="create-clueSource">
				  <option></option>
					<c:forEach items="${sourceList}" var="so">
				  		<option value="${so.value}">${so.text}</option>
					</c:forEach>
				  <%--<option>推销电话</option>--%>
				  <%--<option>员工介绍</option>--%>
				  <%--<option>外部介绍</option>--%>
				  <%--<option>在线商场</option>--%>
				  <%--<option>合作伙伴</option>--%>
				  <%--<option>公开媒介</option>--%>
				  <%--<option>销售邮件</option>--%>
				  <%--<option>合作伙伴研讨会</option>--%>
				  <%--<option>内部研讨会</option>--%>
				  <%--<option>交易会</option>--%>
				  <%--<option>web下载</option>--%>
				  <%--<option>web调研</option>--%>
				  <%--<option>聊天</option>--%>
				</select>
			</div>
			<%-- data-toggle="modal" data-target="#findMarketActivity"--%>
			<label for="create-activitySrc" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" onclick="loadActivitySourceOpen()"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<%--当前交易关联的市场活动源为只读，活动是在之前就已经创建好了的--%>
				<input type="text" class="form-control" readonly id="create-activitySrc">
			</div>
		</div>
		
		<div class="form-group">
			<%-- data-toggle="modal" data-target="#findContacts" --%>
			<label for="create-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a id="search-contacts-icon" href="javascript:void(0);"><span class="glyphicon glyphicon-search"></span></a></label>
			<%--联系人名称，很有可能是，新开发的客户，此时当前的输入框是可以输入的--%>
			<div class="col-sm-10" style="width: 300px;">
				<input name="contactsName" type="text" class="form-control" id="create-contactsName">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-describe" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea name="description" class="form-control" rows="3" id="create-describe"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea name="contactSummary" class="form-control" rows="3" id="create-contactSummary"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
			<div class="col-sm-10" style="width: 300px;">
				<input name="nextContactTime" type="text" class="form-control dateTimeTop" autocomplete="off" readonly id="create-nextContactTime">
			</div>
		</div>
		
	</form>
</body>
</html>