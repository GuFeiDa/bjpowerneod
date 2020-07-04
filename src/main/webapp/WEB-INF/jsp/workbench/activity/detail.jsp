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


		//TODO 1.发送ajax请求，异步获取市场活动详情/备注信息列表
		//根据市场活动id查询
		getActivityRemarkList();

		//TODO 2.解决异步刷新市场详情列表的图标不显示问题
		//通过父id，添加实践鼠标捕获/鼠标移除的时间
		$("#remarkBody").on("mouseover",".remarkDiv",function(){
			$(this).children("div").children("div").show();
		})
		$("#remarkBody").on("mouseout",".remarkDiv",function(){
			$(this).children("div").children("div").hide();
		})

		//TODO 4.新增市场活动详情（备注）
		$("#saveBtn").click(function () {
			//发送ajax请求，进行新增操作
			$.ajax({
				url: "workbench/activityRemark/saveActivityRemark.do",
				data: {
					"noteContent": $.trim( $("#remark").val() ),
					"activityId": "${a.id}"
				},
				type: "post",
				dataType:"json",
				success: function(data){
					//data : { success:true/false , msg: xxx, ar:{...}}

					if(data.success){
						//清空市场活动列表
						//TODO 页面加载了重复的数据
						// getActivityRemarkList()

						//
						var html = "";
						html += '<div id="'+data.ar.id+'" class="remarkDiv" style="height: 60px;">';
						html += '<img title="${a.owner}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
						html += '<div style="position: relative; top: -40px; left: 40px;" >';
						// 给noteContent添加一个id，在方法中获取标签中的值
						html += '<h5 id="n_'+data.ar.id+'" >'+data.ar.noteContent+'</h5>';
						html += '<font color="gray">市场活动</font> <font color="gray">-</font> <b>${a.name}</b> <small style="color: gray;"> '+ (data.ar.editFlag == "0" ? data.ar.createTime : data.ar.editTime) +'  由  '+ (data.ar.editFlag == "0" ? data.ar.createBy : data.ar.editBy) +'</small>';
						html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
						// href="javascript:void(0);"属性：不让它发送href请求操作，但是保持小手
						html += '<a onclick="openUpdateModal(\''+data.ar.id+'\')" class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>';
						html += '&nbsp;&nbsp;&nbsp;&nbsp;';
						html += '<a onclick="deleteActivityRemarkById(\''+data.ar.id+'\')" class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
						html += '</div>';
						html += '</div>';
						html += '</div>';

						//将插入的市场活动备注信息，插入到最上方
						$("#rDiv").after(html);
						// $("#remarkDiv").before(html);
					}
				}
			});
		})

		//TODO 7.点击修改模态窗口中的更新按钮，更新市场活动备注数据
		$("#updateRemarkBtn").click(function () {
			//校验
			if("" == $("#noteContent").val()){
				alert("请填写要修改的市场活动的备注信息")
				return false;
			}
			//发送ajax请求，更新数据
			var arId = $("#activityRemarkId").val();
			$.ajax({
				url: "workbench/activityRemark/updateActivityRemark.do",
				data: {
					"id": arId,
					"noteContent":$("#noteContent").val()
				},
				type: "post",
				dataType:"json",
				success: function(data){
					//方式1：通过更新后的数据，将ar返回。更新页面
					//data : {success:true/false,msg:xxx,ar:{...}}

					if(data.success){
						//修改成功
						//局部更新

						//获取的是noteContent的h5标签对象
						$("#n_"+ arId ).html(data.ar.noteContent);

						//获取的是创建人/更新人，创建时间/更新时间的small标签对象
						$("#s_"+ arId ).html( data.ar.editTime + "  由  " +  data.ar.editBy);

						//清除隐藏域中的id值
						$("#activityRemarkId").val("");

						//关闭模态窗口
						$("#editRemarkModal").modal("hide")

					}else{
						//提示
					}


				}
			});
		})
	});


	function getActivityRemarkList() {
		$.ajax({
			url: "workbench/activityRemark/getActivityRemarkList.do",
			data: {
				"activityId":"${a.id}"
			},
			type: "get",
			dataType:"json",
			success: function(data){

				//data : {success : true/false, msg:xxx, arList:[...]}
				//异步刷新
				//以前写法：在父标签调用.html(html)，注意，当前父标签中没有其他标签的。在父标签中填充子标签

				if(data.success){
					//请求成功
					//现在写法：在兄弟之间添加标签。

					var html = "";

					$.each(data.arList,function (i, n) {

						html += '<div id="'+n.id+'" class="remarkDiv" style="height: 60px;">';
						html += '<img title="${a.owner}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
						html += '<div style="position: relative; top: -40px; left: 40px;" >';
						// 给noteContent添加一个id，在方法中获取标签中的值
						html += '<h5 id="n_'+n.id+'">'+n.noteContent+'</h5>';
						html += '<font color="gray">市场活动</font> <font color="gray">-</font> <b>${a.name}</b> <small style="color: gray;" id="s_'+n.id+'"> '+ (n.editFlag == "0" ? n.createTime : n.editTime) +'  由  '+ (n.editFlag == "0" ? n.createBy : n.editBy) +'</small>';
						html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
						// href="javascript:void(0);"属性：不让它发送href请求操作，但是保持小手
						html += '<a onclick="openUpdateModal(\''+n.id+'\')" class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>';
						html += '&nbsp;&nbsp;&nbsp;&nbsp;';
						html += '<a onclick="deleteActivityRemarkById(\''+n.id+'\')" class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
						html += '</div>';
						html += '</div>';
						html += '</div>';

					})

					//1种是兄弟在下面，我要添加到兄弟的上面
					// $("#remarkDiv").before(html);//before方法是在下面的兄弟插入它的上面

					//2种是兄弟在上面，我要添加到兄弟下面
					$("#rDiv").after(html);
				}else{
					alert(data.msg);
				}
			}
		});
	}

	//TODO 5.根据市场活动备注id删除该备注
	function deleteActivityRemarkById(id) {
		// alert(id)
		//将id传递到后台，进行删除操作
		if(confirm("你确定要删除这条市场活动备注信息吗？")){

			$.ajax({
				url: "workbench/activityRemark/deleteActivityRemarkById.do",
				data: {
					"id":id
				},
				type: "get",
				dataType:"json",
				success: function(data){
					//data : { success: true/false,msg:xxx }

					if(data.success){
						//删除成功
						//删除页面上的，标签信息
						$("#"+id).remove();
					}
				}
			});
		}
	}

	//TODO 6.更新市场活动备注信息
	function openUpdateModal(id) {
		// alert(id+"   "+$("#n_"+id).val())
		// $("#editRemarkModal").modal("show")

		//赋值操作
		//val方法获取的是value属性值
		//html方法获取的是标签中的文本信息
		$("#noteContent").val( $("#n_"+id).html());

		//向隐藏域中存入市场活动备注的id
		$("#activityRemarkId").val(id);

		// if($("#noteContent"))
		$("#editRemarkModal").modal("show");

	}


	
</script>

</head>
<body>
	
	<!-- 修改市场活动备注的模态窗口 -->
	<div class="modal fade" id="editRemarkModal" role="dialog">
		<%-- 备注的id --%>
		<input type="hidden" id="remarkId">
        <div class="modal-dialog" role="document" style="width: 40%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">修改备注</h4>
                </div>
				<%--隐藏域，保存当前修改的市场活动备注id--%>
				<input type="hidden" id="activityRemarkId">
                <div class="modal-body">
                    <form class="form-horizontal" role="form">
                        <div class="form-group">
                            <label for="edit-describe" class="col-sm-2 control-label">内容</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="noteContent"></textarea>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
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
			<h3>市场活动-发传单 <small>2020-10-10 ~ 2020-10-20</small></h3>
		</div>
		
	</div>
	
	<br/>
	<br/>
	<br/>

	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${a.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${a.name}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>

		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">开始日期</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${a.startDate}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${a.endDate}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">成本</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${a.cost}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${a.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${a.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${a.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${a.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${a.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div id="remarkBody" style="position: relative; top: 30px; left: 40px;">
		<div id="rDiv" class="page-header">
			<h4>备注</h4>
		</div>
		
		<!-- 备注1 -->
		<%--<div class="remarkDiv" style="height: 60px;">--%>
			<%--<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">--%>
			<%--<div style="position: relative; top: -40px; left: 40px;" >--%>
				<%--<h5>哎呦！</h5>--%>
				<%--<font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>--%>
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
				<%--<font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>--%>
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
					<button id="saveBtn" type="button" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>
	<div style="height: 200px;"></div>
</body>
</html>