package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.HandleFlag;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.User;
import com.bjpowernode.crm.workbench.service.ActivityService;
import com.bjpowernode.crm.workbench.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static java.lang.Integer.valueOf;

@Controller
@RequestMapping("/workbench/activity")
public class ActivityController {

    @Autowired
    private ActivityService activityService;

    @Autowired
    private UserService userService;

    @RequestMapping("/toActivityIndex.do")
    //将视图和数据封装到ModelAndView中
//    public ModelAndView toActivityIndex(){
    //将试图和数据分开，返回值String，代表返回的视图页面，参数Model，将数据存到request域中
    public String toActivityIndex(Model model){
        //从数据库中查询出市场活动列表
//        List<Activity> aList = activityService.findAllActivity();
//        model.addAttribute("aList",aList);
        return "/workbench/activity/index";
    }

    @RequestMapping("/getUserList.do")
    @ResponseBody
    public Map<String,Object> getUserList(){
        List<User> uList = userService.findAllUser();

        Map<String,Object> resultMap = new HashMap<>();
        resultMap.put("success",true);
        resultMap.put("msg", "获取用户列表成功");
        resultMap.put("uList",uList);
        return resultMap;
    }

    @RequestMapping("/saveActivity.do")
    @ResponseBody
    public Map<String,Object> saveActivity(Activity activity, HttpSession session){
        String id = UUIDUtil.getUUID();
        String createBy = ((User)session.getAttribute("user")).getName();
        String createTime = DateTimeUtil.getSysTime();
        activity.setId(id);
        activity.setCreateTime(createTime);//19位
        activity.setCreateBy(createBy);
        activityService.saveActivity(activity);
        return HandleFlag.successTrue();
    }


    /**
     * 查询列表并分页
     * @return
     */
    @RequestMapping("/getPageList.do")
    @ResponseBody
    public Map<String,Object> getPageList(@RequestParam Map<String,Object> paramMap){
        //在查询时，分页参数要转换成int或者Integer，不然会执行sql时会报错。
        //如果没有将字符串进行转换，会在执行sql拼接，''0' , '5''，错误语法。
        String p1 = (String) paramMap.get("pageNo");
        Integer pageNo = Integer.valueOf(p1);
        String p2 = (String) paramMap.get("pageSize");
        Integer pageSize = Integer.valueOf(p2);
        paramMap.put("pageNo",pageNo);
        paramMap.put("pageSize",pageSize);

        List<Activity> aList = activityService.findAllActivity(paramMap);
        //获取总记录数
        String userId = (String) paramMap.get("userId");
        Long count = activityService.findActivityCount(paramMap);
        Map<String, Object> map = new HashMap<>();
        map.put("total",count);
        map.put("aList",aList);
        map.put("msg","查询成功");

        Map<String, Object> flagMap = HandleFlag.successTrue();
        flagMap.putAll(map);
        return flagMap;
    }


    /**
     *  删除分为两种
     *      物理删除，delete from tbl_xxxx where id = ? ，真正的在数据库中(磁盘)进行了删除操作。
     *      逻辑删除，设置表中某一个字段，以该字段为是否查询的条件。
     *          不是真正意义上的删除，而是通过字段的方式我们进行查询。
     *
     * @param activityIds
     * @return
     */
    @RequestMapping("/deleteByIds.do")
    @ResponseBody
    public Map<String,Object> deleteByIds(String[] activityIds){
        activityService.deleteByIds(activityIds);
        return HandleFlag.successObj("msg","删除成功");
    }



}
