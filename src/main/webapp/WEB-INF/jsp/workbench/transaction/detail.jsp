<%@ page import="java.util.Map" %>
<%@ page import="com.bjpowernode.crm.workbench.domain.Tran" %>
<%@ page import="org.omg.CORBA.TRANSACTION_MODE" %>
<%@ page import="com.bjpowernode.crm.settings.domain.DicValue" %>
<%@ page import="java.util.List" %>
<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";

	//获取阶段和可能性对应的集合
	Map<String,String> sMap = (Map<String, String>) application.getAttribute("sMap");

	//方式2
	//前面正常阶段和后面丢失阶段的分界点下标
	List<DicValue> dvList = (List<DicValue>) application.getAttribute("stageList");
	int point = 0;// 7
	for(int i=0;i<dvList.size();i++){
		//获取每个阶段和可能性
		DicValue dv = dvList.get(i);
		String stage = dv.getValue();
		String possibility = sMap.get(stage);

		if("0".equals(possibility)){
			//获取到分界点坐标
			point = i;
			break;
		}
	}

%>
<%@ page isELIgnored="false" contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />

<style type="text/css">
.mystage{
	font-size: 20px;
	vertical-align: middle;
	cursor: pointer;
}
.closingDate{
	font-size : 15px;
	cursor: pointer;
	vertical-align: middle;
}
</style>
	
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
		
		
		//阶段提示框
		$(".mystage").popover({
            trigger:'manual',
            placement : 'bottom',
            html: 'true',
            animation: false
        }).on("mouseenter", function () {
                    var _this = this;
                    $(this).popover("show");
                    $(this).siblings(".popover").on("mouseleave", function () {
                        $(_this).popover('hide');
                    });
                }).on("mouseleave", function () {
                    var _this = this;
                    setTimeout(function () {
                        if (!$(".popover:hover").length) {
                            $(_this).popover("hide")
                        }
                    }, 100);
                });

		//TODO 1.发送ajax请求，获取交易历史数据
		getTranHistoryList();
	});

	function updateStagePossibility(stage,index) {
		// alert(stage);
		//通过分析，要传递4个参数
		//tranId，stage 更新交易阶段的信息
		//expectedDate，money，tranId，stage，创建新的交易历史记录
		$.ajax({
			url: "workbench/transaction/updateTranAndHistory.do",
			data: {
				"id":"${t.id}",
				"expectedDate":"${t.expectedDate}",
				"stage":stage,
				"money":"${t.money}"
			},
			type: "post",
			dataType:"json",
			success: function(data){
				//data : {success:true/false,msg:xxx,t:{...}} 更新后的t
				if(data.success){
					//更新成功
					//更新对应阶段和可能性
					$("#b_stage").html(data.t.stage);
					$("#b_possibility").html(data.t.possibility);
					//更新修改人和修改时间
					$("#b_editBy_time").html('<b>'+data.t.editBy+'&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">'+data.t.editTime+'</small>');
					//更新交易历史记录
					getTranHistoryList();
					//改变图标
					changeIcon(stage,index);
				}
			}
		});
	}

	function changeIcon(stage,index) {
		//获取一些参数
		//获取当前的图标jquery对象
		//  alert($("#"+index) + index);
		var stage = stage;
		<%--var possibility = "${t.possibility}";--%>
		var possibility = $("#b_possibility").html()
		var index = index;
		//获取分界点索引
		var point = "<%=point%>";

		// alert(possibility == 0);
		// alert(possibility == "0");
		if(possibility == 0){
			//显示状态1,和状态2的图标，前七个黑点，后两个一个红叉一个黑叉
			//遍历前七个 黑点
			for(var i=0;i< point ; i++){
				//获取jquery对象，对样式进行操作
				$("#"+i).removeClass();//清除样式
				$("#"+i).addClass("glyphicon glyphicon-record mystage");
				$("#"+i).css("color","#000000")
			}

			for(var i=point; i < <%=dvList.size()%>; i++){

				if(index == i){
					$("#"+i).removeClass();//清除样式
					$("#"+i).addClass("glyphicon glyphicon-remove mystage");
					$("#"+i).css("color","#FF0000")
				}else{
					//黑叉
					$("#"+i).removeClass();//清除样式
					$("#"+i).addClass("glyphicon glyphicon-remove mystage");
					$("#"+i).css("color","#000000")
				}

				//一个红叉，一个黑叉
				// if(stage == "08丢的线索"){
				// 	$("#"+i).removeClass();//清除样式
				// 	$("#"+i).addClass("glyphicon glyphicon-remove mystage");
				// 	$("#"+i).css("color","#FF0000")
				// }else if(stage == "09因竞争丢失关闭"){
				// 	$("#"+i).removeClass();//清除样式
				// 	$("#"+i).addClass("glyphicon glyphicon-remove mystage");
				// 	$("#"+i).css("color","#FF0000")
				// }else{
					//黑叉
				// 	$("#"+i).removeClass();//清除样式
				// 	$("#"+i).addClass("glyphicon glyphicon-remove mystage");
				// 	$("#"+i).css("color","#000000")
				// }

			}
		}else{
			//显示交易中的图标，后两个是黑叉，前七个，绿色对勾，绿色坐标，黑点

			for(var i=0 ;i< point ; i++){
				if(i < index){
					//已完成
					$("#"+i).removeClass();//清除样式
					$("#"+i).addClass("glyphicon glyphicon-ok-circle mystage");
					$("#"+i).css("color","#00FF00")
				}else if(i > index){
					//未完成
					$("#"+i).removeClass();//清除样式
					$("#"+i).addClass("glyphicon glyphicon-record mystage");
					$("#"+i).css("color","#000000")
				}else if(i == index){
					//当前阶段
					$("#"+i).removeClass();//清除样式
					$("#"+i).addClass("glyphicon glyphicon-map-marker mystage");
					$("#"+i).css("color","#00FF00")
				}
			}

			for(var i=point; i<<%=dvList.size()%>;i++){
				//黑叉
				$("#"+i).removeClass();//清除样式
				$("#"+i).addClass("glyphicon glyphicon-remove mystage");
				$("#"+i).css("color","#000000")
			}

		}
		//如果当前阶段是0，显示状态1和状态2，前七个是黑点图标，后两个是一个是红叉一个是黑叉

		//遍历图标，9次，小于分界点显示，前七个图标为黑点

		//后两个根据阶段名称比对

		//如果当前阶段不是0，交易中的状态，最后两个一定是黑叉，前七个不一定，绿色对勾，绿色坐标，黑点图标
		//大于分界点的坐标是黑叉
		//其他的根据当前索引去进行判断然后显示

	}

	function getTranHistoryList() {
		$.ajax({
			url: "workbench/transactionHistory/getTranHistoryListByTranId.do",
			data: {
				"tranId":"${t.id}"
			},
			type: "get",
			dataType:"json",
			success: function(data){
				//data : { success:true/false,msg:xxx,thList:[...] }
				if(data.success){
					//请求成功
					var html = "";

					$.each(data.thList,function (i, n) {
						html += '<tr>';
						html += '<td>'+n.stage+'</td>';
						html += '<td>￥ '+n.money+'</td>';
						html += '<td>'+n.possibility+'</td>';
						html += '<td>'+n.expectedDate+'</td>';
						html += '<td>'+n.createTime+'</td>';
						html += '<td>'+n.createBy+'</td>';
						html += '</tr>';
					})

					$("#thBody").html(html);


				}
			}
		});
	}
	
	
</script>

</head>
<body>
	
	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${t.customerId}-${t.name} <small>￥${t.money}</small></h3>
		</div>
		
	</div>

	<br/>
	<br/>
	<br/>

	<!-- 阶段状态 图标 -->
	<div style="position: relative; left: 40px; top: -50px;">
		阶段&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

		<%--方式1，加载阶段图标，使用Java+JS混合模式开发，不推荐这种方式的。--%>
		<%
			// 编写java代码+js代码
			//获取当前阶段和当前的可能性(此交易中的阶段和可能性)
			Tran tran = (Tran) request.getAttribute("t");
			String currentStage = tran.getStage();//绿色的坐标
			String currentPossibility = sMap.get(currentStage);

			//获取字典值得集合
//			List<DicValue> dvList = (List<DicValue>) application.getAttribute("stageList");

			//需要去遍历显示图标了
//			for(int i=0;i<dvList.size();i++){
				//当前显示的样式，后两种
				if(currentPossibility.equals("0")){

					for(int i=0;i<dvList.size();i++) {
						//丢失状态1的样式，前七个是黑色的点，后两个是红叉或黑叉
						//丢失状态2的样式，前七个是黑色的点，后两个是红叉或黑叉
						//获取遍历的阶段和可能性
						DicValue dv = dvList.get(i);
						String stage = dv.getValue();//text和value属性是一样的
						String possibility = sMap.get(stage); // 10 25 40 55 70 85 100 0 0

						if("0".equals(possibility)){
							if(stage.equals(currentStage)){
								//红叉图标
		%>
		<span class="glyphicon glyphicon glyphicon-remove mystage" id="<%=i%>" onclick="updateStagePossibility('<%=stage%>','<%=i%>')" data-toggle="popover" data-placement="bottom" data-content="<%=stage%>" style="color: #FF0000;"></span>
		-----------
		<%
							}else{
								//黑叉图标
		%>
		<span class="glyphicon glyphicon glyphicon-remove mystage" id="<%=i%>" onclick="updateStagePossibility('<%=stage%>','<%=i%>')" data-toggle="popover" data-placement="bottom" data-content="<%=stage%>" style="color: #000000;"></span>
		-----------
		<%
							}
						}else{
							//七个黑点图标
		%>
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" id="<%=i%>" onclick="updateStagePossibility('<%=stage%>','<%=i%>')" data-placement="bottom" data-content="<%=stage%>" style="color: #000000;"></span>
		-----------
		<%
						}


					}
				}else{
					//获取当前的阶段坐标
					int index = 0;
					for(int i=0;i<dvList.size();i++){
						DicValue dv = dvList.get(i);
						String stage = dv.getValue();
						if(currentStage.equals(stage)){
							index = i;
						}
					}

					//遍历生成图标
					for(int i=0;i<dvList.size();i++){
						//交易中的样式
						DicValue dv = dvList.get(i);
						String stage = dv.getValue();
						String possibility = sMap.get(stage);

						if("0".equals(possibility)){
							//黑叉
		%>
		<span class="glyphicon glyphicon glyphicon-remove mystage" id="<%=i%>" onclick="updateStagePossibility('<%=stage%>','<%=i%>')" data-toggle="popover" data-placement="bottom" data-content="<%=stage%>" style="color: #000000;"></span>
		-----------
		<%
						}else{
							if(i == index){
								//当前阶段坐标，就是绿色坐标图标
		%>
		<span class="glyphicon glyphicon-map-marker mystage" id="<%=i%>" onclick="updateStagePossibility('<%=stage%>','<%=i%>')" data-toggle="popover" data-placement="bottom" data-content="<%=stage%>" style="color: #90F790;"></span>
		-----------
		<%
							}else if(i < index) {
								//小于当前阶段坐标，代表已完成，显示绿色对勾的图标
		%>
		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" id="<%=i%>" onclick="updateStagePossibility('<%=stage%>','<%=i%>')" data-placement="bottom" data-content="<%=stage%>" style="color: #00FF00;"></span>
		-----------
		<%
							}else{
								//大于当前阶段的坐标，代表未完成，显示黑点图标
		%>
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" id="<%=i%>" onclick="updateStagePossibility('<%=stage%>','<%=i%>')" data-placement="bottom" data-content="<%=stage%>" style="color: #000000;"></span>
		-----------
		<%
							}
						}

					}

				}



//			}

		%>

		<%--<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="资质审查" style="color: #90F790;"></span>--%>
		<%---------------%>
		<%--<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="需求分析" style="color: #90F790;"></span>--%>
		<%---------------%>
		<%--<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="价值建议" style="color: #90F790;"></span>--%>
		<%---------------%>
		<%--<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="确定决策者" style="color: #90F790;"></span>--%>
		<%---------------%>
		<%--<span class="glyphicon glyphicon-map-marker mystage" data-toggle="popover" data-placement="bottom" data-content="提案/报价" style="color: #90F790;"></span>--%>
		<%---------------%>
		<%--<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="谈判/复审"></span>--%>
		<%---------------%>
		<%--<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="成交"></span>--%>
		<%---------------%>
		<%--<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="丢失的线索"></span>--%>
		<%---------------%>
		<%--<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="因竞争丢失关闭"></span>--%>
		<%---------------%>
		<span class="closingDate">${t.expectedDate}</span>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: 0px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${t.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">金额</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>￥${t.money}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${t.customerId}-${t.name}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">预计成交日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${t.expectedDate}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">客户名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${t.customerId}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">阶段</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="b_stage">${t.stage}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">类型</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${t.type}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">可能性</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="b_possibility">${t.possibility}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">来源</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${t.source}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">市场活动源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${t.activityId}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">联系人名称</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${t.contactsId}</b></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${t.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${t.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;" id="b_editBy_time"><b>${t.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${t.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${t.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${t.contactSummary}&nbsp;
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 100px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${t.nextContactTime}&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div style="position: relative; top: 100px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		
		<!-- 备注1 -->
		<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>哎呦！</h5>
				<font color="gray">交易</font> <font color="gray">-</font> <b>动力节点-交易01</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>
		
		<!-- 备注2 -->
		<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>呵呵！</h5>
				<font color="gray">交易</font> <font color="gray">-</font> <b>动力节点-交易01</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>
		
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
	
	<!-- 阶段历史 -->
	<div>
		<div style="position: relative; top: 100px; left: 40px;">
			<div class="page-header">
				<h4>阶段历史</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>阶段</td>
							<td>金额</td>
							<td>可能性</td>
							<td>预计成交日期</td>
							<td>创建时间</td>
							<td>创建人</td>
						</tr>
					</thead>
					<tbody id="thBody">
						<%--<tr>--%>
							<%--<td>资质审查</td>--%>
							<%--<td>5,000</td>--%>
							<%--<td>10</td>--%>
							<%--<td>2017-02-07</td>--%>
							<%--<td>2016-10-10 10:10:10</td>--%>
							<%--<td>zhangsan</td>--%>
						<%--</tr>--%>
						<%--<tr>--%>
							<%--<td>需求分析</td>--%>
							<%--<td>5,000</td>--%>
							<%--<td>20</td>--%>
							<%--<td>2017-02-07</td>--%>
							<%--<td>2016-10-20 10:10:10</td>--%>
							<%--<td>zhangsan</td>--%>
						<%--</tr>--%>
						<%--<tr>--%>
							<%--<td>谈判/复审</td>--%>
							<%--<td>5,000</td>--%>
							<%--<td>90</td>--%>
							<%--<td>2017-02-07</td>--%>
							<%--<td>2017-02-09 10:10:10</td>--%>
							<%--<td>zhangsan</td>--%>
						<%--</tr>--%>
					</tbody>
				</table>
			</div>
			
		</div>
	</div>
	
	<div style="height: 200px;"></div>
	
</body>
</html>