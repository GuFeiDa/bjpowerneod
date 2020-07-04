package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.HandleFlag;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.workbench.domain.ActivityRemark;
import com.bjpowernode.crm.workbench.domain.User;
import com.bjpowernode.crm.workbench.service.ActivityRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/workbench/activityRemark")
public class ActivityRemarkController {

    @Autowired
    private ActivityRemarkService activityRemarkService;

    @RequestMapping("/getActivityRemarkList.do")
    @ResponseBody
    public Map<String,Object> getActivityRemarkList(String activityId){
        List<ActivityRemark> arList = activityRemarkService.getActivityRemarkList(activityId);

        return HandleFlag.successObj("arList",arList);
    }

    @RequestMapping("/saveActivityRemark.do")
    @ResponseBody
    public Map<String,Object> saveActivityRemark(ActivityRemark activityRemark, HttpSession session){
        //补充参数
        activityRemark.setId(UUIDUtil.getUUID());
        activityRemark.setEditFlag("0");//未修改过的标记，已修改过的标记是1
        activityRemark.setCreateTime(DateTimeUtil.getSysTime());//19位
        activityRemark.setCreateBy(((User)session.getAttribute("user")).getName());

        activityRemarkService.saveActivityRemark(activityRemark);

        return HandleFlag.successObj("ar",activityRemark);

    }

    @RequestMapping("/deleteActivityRemarkById.do")
    @ResponseBody
    public Map<String,Object> deleteActivityRemarkById(String id){
        activityRemarkService.deleteActivityRemarkById(id);

        return HandleFlag.successTrue();
    }

    @RequestMapping("/updateActivityRemark.do")
    @ResponseBody
    public Map<String,Object> updateActivityRemark(ActivityRemark activityRemark,HttpSession session){
        //填充属性
        activityRemark.setEditTime(DateTimeUtil.getSysTime());//19位
        activityRemark.setEditBy(((User)session.getAttribute("user")).getName());
        activityRemark.setEditFlag("1");//表示已修改标记

        activityRemarkService.updateActivityRemark(activityRemark);

        return HandleFlag.successObj("ar",activityRemark);
    }
}
