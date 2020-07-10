<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script src="jquery/echarts.min.js"></script>
</head>
<body>
    <!-- 为 ECharts 准备一个具备大小（宽高）的 DOM -->
    <div id="main" style="width: 1500px;height:1000px;"></div>
<script type="text/javascript">
    <%--创建echarts对象，初始化，加载option参数--%>
    var myChart = echarts.init(document.getElementById('main'));

    //从后台获取数据，加载图表
    $(function () {
        $.ajax({
            url: "workbench/transactionHistory/findTranHistory.do",
            data: {

            },
            type: "get",
            dataType:"json",
            success: function(data){
                //data : {success:true/false,msg:xxx,thList:[{...}...],nameList:["",""...]}
                if(data.success){
                    //请求成功
                    option = {
                        title: {
                            text: '漏斗图',
                            subtext: '纯属虚构'
                        },
                        tooltip: {
                            trigger: 'item',
                            formatter: "{a} <br/>{b} : {c}%"
                        },
                        toolbox: {
                            feature: {
                                dataView: {readOnly: false},
                                restore: {},
                                saveAsImage: {}
                            }
                        },
                        legend: {
                            data: data.nameList
                        },

                        series: [
                            {
                                name:'漏斗图',
                                type:'pie',//漏斗图，funnel
                                left: '10%',
                                top: 60,
                                //x2: 80,
                                bottom: 60,
                                width: '80%',
                                // height: {totalHeight} - y - y2,
                                min: 0,
                                max: 100,
                                minSize: '0%',
                                maxSize: '100%',
                                sort: 'descending',
                                gap: 2,
                                label: {
                                    show: true,
                                    position: 'inside'
                                },
                                labelLine: {
                                    length: 10,
                                    lineStyle: {
                                        width: 1,
                                        type: 'solid'
                                    }
                                },
                                itemStyle: {
                                    borderColor: '#fff',
                                    borderWidth: 1
                                },
                                emphasis: {
                                    label: {
                                        fontSize: 20
                                    }
                                },
                                data: data.thList
                            }
                        ]
                    };


                    // 使用刚指定的配置项和数据显示图表。
                    myChart.setOption(option);
                }
            }
        });
    })

</script>
</body>
</html>