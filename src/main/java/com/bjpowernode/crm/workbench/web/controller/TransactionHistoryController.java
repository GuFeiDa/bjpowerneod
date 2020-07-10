package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.utils.HandleFlag;
import com.bjpowernode.crm.workbench.domain.TranHistory;
import com.bjpowernode.crm.workbench.service.TransactionHistoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.*;

@Controller
@RequestMapping("/workbench/transactionHistory")
public class TransactionHistoryController {

    @Autowired
    private TransactionHistoryService transactionHistoryService;

    @RequestMapping("/getTranHistoryListByTranId.do")
    @ResponseBody
    public Map<String,Object> getTranHistoryListByTranId(String tranId, HttpServletRequest request){
        List<TranHistory> tranHistoryList = transactionHistoryService.getTranHistoryListByTranId(tranId);

        Map<String,String> sMap = (Map<String, String>) request.getServletContext().getAttribute("sMap");

        //封装阶段的可能性
        for (TranHistory tranHistory : tranHistoryList) {
            String stage = tranHistory.getStage();
            tranHistory.setPossibility(sMap.get(stage));
        }

        return HandleFlag.successObj("thList",tranHistoryList);
    }

    @RequestMapping("/findTranHistory.do")
    @ResponseBody
    public Map<String,Object> findTranHistory(){
        //查询每个阶段的交易数量
        //key是阶段名称
        //value是数量
        // [ { name:xxx,value:xxx } .... ]
        List<Map<String,String>> thList = transactionHistoryService.findTranHistory();

        List<String> nameList = new ArrayList<>();

        for (Map<String, String> th : thList) {
            for (String key : th.keySet()) {
                if("name".equals(key)){
                    nameList.add(th.get(key));
                }
            }
        }
        Map<String,Object> resultMap = new HashMap<>();
        resultMap.put("nameList",nameList);
        resultMap.put("thList",thList);

        return HandleFlag.successMap(resultMap);
    }

    @RequestMapping("/toChartTran.do")
    public String toChartTran(){
        return "/workbench/chart/transaction/index";
    }

}
