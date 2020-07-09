package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.HandleFlag;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.Contacts;
import com.bjpowernode.crm.workbench.domain.User;
import com.bjpowernode.crm.workbench.service.ActivityService;
import com.bjpowernode.crm.workbench.service.ContactsService;
import com.bjpowernode.crm.workbench.service.TransactionService;
import com.bjpowernode.crm.workbench.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/workbench/transaction")
public class TransactionController {

    @Autowired
    private UserService userService;

    @Autowired
    private TransactionService trnsactionService;

    @Autowired
    private ActivityService activityService;

    @Autowired
    private ContactsService contactsService;

    @RequestMapping("/toTranIndex.do")
    public ModelAndView toTranIndex(){
        ModelAndView mv = new ModelAndView();

        mv.setViewName("/workbench/transaction/index");
        //查询交易列表

        return mv;
    }

    @RequestMapping("/toTranSave.do")
    public ModelAndView toTranSave(){
        ModelAndView mv = new ModelAndView();
        mv.setViewName("/workbench/transaction/save");
        //封装所有者下拉列表数据
        List<User> uList = userService.findAllUser();
        mv.addObject("uList",uList);
        return mv;
    }


    /**
     * 自动补全接收的请求
     *      要求参数必须是name
     *      返回值必须是List<String>
     * @param name
     * @return
     */
    @RequestMapping("/getCustomerName.do")
    @ResponseBody
    public List<String> getCustomerName(String name){
        List<String> cNameList = trnsactionService.getCustomerName(name);
        return cNameList;
    }

    /**
     * 加载市场活动源列表
     * @return
     */
    @RequestMapping("/getActivityList.do")
    @ResponseBody
    public Map<String,Object> getActivityList(){
        List<Activity> aList = activityService.findAll();
        return HandleFlag.successObj("aList",aList);
    }

    @RequestMapping("/getContacttsList.do")
    @ResponseBody
    public Map<String,Object> getContacttsList(){
        List<Contacts> cList = contactsService.findAll();
        return HandleFlag.successObj("cList",cList);
    }

    @RequestMapping("/saveTran.do")
//    public String saveTran(Tran tran,String customerName,String contactsName){
    public String saveTran(@RequestParam Map<String,String> paramMap, HttpSession session){
        paramMap.put("id", UUIDUtil.getUUID());
        paramMap.put("createBy",((User)session.getAttribute("user")).getName());
        paramMap.put("createTime",DateTimeUtil.getSysTime());
        //新增交易、交易历史记录
        trnsactionService.saveTran(paramMap);
        //跳转到交易首页
        return "redirect:/workbench/transaction/toTranIndex.do";
    }

}
