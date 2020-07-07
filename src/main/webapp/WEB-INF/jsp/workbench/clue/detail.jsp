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

<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){
		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});
		
		$(".remarkDiv").mouseover(function(){
			$(this).children("div").children("div").show();
		});
		
		$(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		});
		
		$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});
		
		$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});

		//TODO 0.发送ajax请求，展示线索备注列表和市场活动列表数据
		getActivityListAndClueRemarkList();

		//TODO 2.打开关联市场活动的模态窗口
		$("#getActivityListAndAddRelationBtn").click(function () {
			//查询未关联的市场活动列表，未关联的线索和市场活动的关系
			$.ajax({
				url: "workbench/clue/getUnRelationActivityList.do",
				data: {
					"clueId":"${c.id}"
				},
				type: "get",
				dataType:"json",
				success: function(data){
					//data :{ success:true/false, msg:xxx,aList }
					if(data.success){
						//请求成功
						//异步更新模态窗口中的列表
						var html="";

						$.each(data.aList,function (i, n) {
							html += '<tr >';
							// html += '<td><input name="flag" onclick="reSelect()" value="'+n.id+'" type="checkbox"/></td>';
							html += '<td><input name="flag" value="'+n.id+'" type="checkbox"/></td>';
							html += '<td>'+n.name+'</td>';
							html += '<td>'+n.startDate+'</td>';
							html += '<td>'+n.endDate+'</td>';
							html += '<td>'+n.owner+'</td>';
							html += '</tr>';
						})

						$("#unRelationActivityBody").html(html);

						//打开模态窗口
						$("#bundModal").modal("show");
					}
				}
			});
		})

		//TODO 3.模态窗口中的全选/反选
		//全选
		$("#selectAll").on("click",function () {
			// alert("123")
			$("input[name=flag]").prop("checked",$("#selectAll").prop("checked"))
		})

		//反选
		// $("input[name=flag]").on("click",function () {
		// 	//操作全选框
		// 	$("#selectAll").prop(
		// 			"checked",
		// 			$("input[name=flag]:checked").length == $("input[name=flag]").length
		// 	)
		// })


		//TODO 4.在模态窗口中搜索市场活动名称， 模糊查询列表
		$("#searchActivity").keydown(function (event) {
			// alert(event.keyCode)
			//当按下回车时，码值是13
			if(13 == event.keyCode){
				//按下了回车键
				//发送请求，模糊查询市场活动列表
				$.ajax({
					url: "workbench/clue/findActivityListLike.do",
					data: {
						"activityName":$.trim($("#searchActivity").val())
					},
					type: "post",
					dataType:"json",
					success: function(data){
						//data : {success:true/false,msg:xxxx,aList:[{}...]}

						if(data.success){
							var html="";

							$.each(data.aList,function (i, n) {
								html += '<tr >';
								// html += '<td><input name="flag" onclick="reSelect()" value="'+n.id+'" type="checkbox"/></td>';
								html += '<td><input name="flag" value="'+n.id+'" type="checkbox"/></td>';
								html += '<td>'+n.name+'</td>';
								html += '<td>'+n.startDate+'</td>';
								html += '<td>'+n.endDate+'</td>';
								html += '<td>'+n.owner+'</td>';
								html += '</tr>';
							})

							$("#unRelationActivityBody").html(html);


						}
					}
				});
				return false;
			}
		})

		//TODO 5.点击模态窗口中的关联按钮，添加线索和市场活动的关联关系
		$("#addRelationBtn").click(function () {
			//校验
			//获取复选框的jquery对象，获取长度
			var size = $("input[name=flag]:checked").length;

			if(size == 0){
				alert("请选择需要关联的市场活动信息")

			}else{
				//拼接参数，发送请求进行关联，关闭模态窗口，刷新页面
				var param = "";
				$.each($("input[name=flag]:checked"),function (i, n) {
					param += "activityIds=" + $(n).val();
					if(i < size-1){
						param += "&";
					}
				})
				// alert(param);
				//关联线索和市场活动的关系
				$.ajax({
					url: "workbench/clue/addRelation.do?"+param,
					data: {
						"clueId":"${c.id}"
					},
					type: "post",
					dataType:"json",
					success: function(data){
						//data : { success:true/false , msg:xxx }
						//关掉模态窗口，刷新页面
						$("#bundModal").modal("hide");

						getActivityListAndClueRemarkList();
					}
				});
			}
		})


	});

	//TODO 6.点击转换按钮，进行线索转换
	function toClueConvert() {
		window.location.href = "workbench/clue/toClueConvert.do?id=${c.id}&appellation=${c.appellation}&company=${c.company}&fullname=${c.fullname}&owner=${c.owner}"
	}

	function reSelect() {
		//操作全选框
		$("#selectAll").prop(
				"checked",
				$("input[name=flag]:checked").length == $("input[name=flag]").length
		)
	}

	//TODO 1.点击接触关联按钮，解除市场和线索的关联关系
	function removeRelation(relationId) {
		// alert(relationId)
		//如果说我点错了，给出确认提示框
		if(confirm("您确定要解除市场活动这条消息吗？")){
			//发送ajax请求，如果请求成功，刷新列表
			$.ajax({
				url: "workbench/clue/removeRelation.do",
				data: {
					"relationId":relationId
				},
				type: "post",
				dataType:"json",
				success: function(data){
					//data : { success: true/false, msg:xxx }
					if(data.success){
						//请求成功
						//刷新市场活动列表
						getActivityListAndClueRemarkList();
					}
				}
			});
		}
	}

	function getActivityListAndClueRemarkList() {
		//获取线索备注，根据线索id获取，一(线索)对多(线索备注)
		//市场活动列表，根据线索id获取，多对多
		$.ajax({
			url: "workbench/clue/getActivityListAndClueRemarkList.do",
			data: {
				"clueId":"${c.id}"
			},
			type: "get",
			dataType:"json",
			success: function(data){
				//data : { success:true/false , msg : xxx , aList : [] , crList : [] }
				//异步刷新
				if(data.success){
					//请求成功
					var activityHtml = "";
					//显示当前线索所关联的市场活动
					$.each(data.aList,function (i, n) {
						activityHtml += '<tr>';
						activityHtml += '<td>'+n.name+'</td>';
						activityHtml += '<td>'+n.startDate+'</td>';
						activityHtml += '<td>'+n.endDate+'</td>';
						activityHtml += '<td>'+n.owner+'</td>';
						activityHtml += '<td><a href="javascript:void(0);" onclick="removeRelation(\''+n.relationId+'\')"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>';
						activityHtml += '</tr>';
					})
					//异步加载(已关联)市场活动列表
					$("#activityBody").html(activityHtml);

					// var clueRemarkHtml = "";

					// $.each(data.crList,function (i, n) {
						// clueRemarkHtml += '<div class="remarkDiv" style="height: 60px;">';
						// clueRemarkHtml += '<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
						// clueRemarkHtml += '<div style="position: relative; top: -40px; left: 40px;" >';
						// clueRemarkHtml += '<h5>呵呵！</h5>';
						// clueRemarkHtml += '<font color="gray">线索</font> <font color="gray">-</font> <b>李四先生-动力节点</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>';
						// clueRemarkHtml += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
						// clueRemarkHtml += '<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>';
						// clueRemarkHtml += '&nbsp;&nbsp;&nbsp;&nbsp;';
						// clueRemarkHtml += '<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>';
						// clueRemarkHtml += '</div>';
						// clueRemarkHtml += '</div>';
						// clueRemarkHtml += '</div>';
					// })

					//异步加载，线索备注列表

				}
			}
		});
	}
	
</script>

</head>
<body>

	<!-- 关联市场活动的模态窗口 -->
	<div class="modal fade" id="bundModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">关联市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input id="searchActivity" type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td><input id="selectAll" type="checkbox"/></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="unRelationActivityBody">
							<%--<tr>--%>
								<%--<td><input type="checkbox"/></td>--%>
								<%--<td>发传单</td>--%>
								<%--<td>2020-10-10</td>--%>
								<%--<td>2020-10-20</td>--%>
								<%--<td>zhangsan</td>--%>
							<%--</tr>--%>
							<%--<tr>--%>
								<%--<td><input type="checkbox"/></td>--%>
								<%--<td>发传单</td>--%>
								<%--<td>2020-10-10</td>--%>
								<%--<td>2020-10-20</td>--%>
								<%--<td>zhangsan</td>--%>
							<%--</tr>--%>
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button id="addRelationBtn" type="button" class="btn btn-primary" data-dismiss="modal">关联</button>
				</div>
			</div>
		</div>
	</div>


	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${c.fullname} ${c.appellation} <small>${c.company}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" onclick="toClueConvert();"><span class="glyphicon glyphicon-retweet"></span> 转换</button>
			
		</div>
	</div>
	
	<br/>
	<br/>
	<br/>

	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${c.fullname} ${c.appellation}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${c.owner}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">公司</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${c.company}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">职位</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${c.job}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">邮箱</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${c.email}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${c.phone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">公司网站</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${c.website}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${c.mphone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">线索状态</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${c.state}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">线索来源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${c.source}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${c.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${c.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${c.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${c.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${c.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${c.contactSummary}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${c.nextContactTime}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 100px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
                    ${c.address}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	
	<!-- 备注 -->
	<div style="position: relative; top: 40px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		
		<!-- 备注1 -->
		<%--<div class="remarkDiv" style="height: 60px;">--%>
			<%--<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">--%>
			<%--<div style="position: relative; top: -40px; left: 40px;" >--%>
				<%--<h5>哎呦！</h5>--%>
				<%--<font color="gray">线索</font> <font color="gray">-</font> <b>李四先生-动力节点</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>--%>
				<%--<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">--%>
					<%--<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
					<%--&nbsp;&nbsp;&nbsp;&nbsp;--%>
					<%--<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
				<%--</div>--%>
			<%--</div>--%>
		<%--</div>--%>
		
		<!-- 备注2 -->
		<%--<div class="remarkDiv" style="height: 60px;">--%>
			<%--<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">--%>
			<%--<div style="position: relative; top: -40px; left: 40px;" >--%>
				<%--<h5>呵呵！</h5>--%>
				<%--<font color="gray">线索</font> <font color="gray">-</font> <b>李四先生-动力节点</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>--%>
				<%--<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">--%>
					<%--<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
					<%--&nbsp;&nbsp;&nbsp;&nbsp;--%>
					<%--<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
				<%--</div>--%>
			<%--</div>--%>
		<%--</div>--%>
		
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button type="button" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>
	
	<!-- 市场活动 -->
	<div>
		<div style="position: relative; top: 60px; left: 40px;">
			<div class="page-header">
				<h4>市场活动</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>开始日期</td>
							<td>结束日期</td>
							<td>所有者</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="activityBody">
						<%--<tr>--%>
							<%--<td>发传单</td>--%>
							<%--<td>2020-10-10</td>--%>
							<%--<td>2020-10-20</td>--%>
							<%--<td>zhangsan</td>--%>
							<%--<td><a href="javascript:void(0);"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>--%>
						<%--</tr>--%>
						<%--<tr>--%>
							<%--<td>发传单</td>--%>
							<%--<td>2020-10-10</td>--%>
							<%--<td>2020-10-20</td>--%>
							<%--<td>zhangsan</td>--%>
							<%--<td><a href="javascript:void(0);"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>--%>
						<%--</tr>--%>
					</tbody>
				</table>
			</div>
			
			<div>
				<%--data-toggle="modal" data-target="#bundModal"--%>
				<a id="getActivityListAndAddRelationBtn" href="javascript:void(0);"  style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
			</div>
		</div>
	</div>
	
	
	<div style="height: 200px;"></div>
</body>
</html>