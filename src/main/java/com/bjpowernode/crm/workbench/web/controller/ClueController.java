package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.HandleFlag;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.Clue;
import com.bjpowernode.crm.workbench.domain.User;
import com.bjpowernode.crm.workbench.service.ActivityService;
import com.bjpowernode.crm.workbench.service.ClueService;
import com.bjpowernode.crm.workbench.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/workbench/clue")
public class ClueController {

    @Autowired
    private UserService userService;

    @Autowired
    private ClueService clueService;

    @Autowired
    private ActivityService activityService;

    @RequestMapping("/toClueIndex.do")
    public ModelAndView toClueIndex(){

        ModelAndView mv = new ModelAndView();

        mv.setViewName("/workbench/clue/index");
        return mv;
    }

    @RequestMapping("/getUserList.do")
    @ResponseBody
    public Map<String,Object> getUserList(){
        List<User> uList = userService.findAllUser();
        return HandleFlag.successObj("uList",uList);
    }

    @RequestMapping("/saveClue.do")
    @ResponseBody
    public Map<String,Object> saveClue(Clue clue, HttpSession session){
        clue.setId(UUIDUtil.getUUID());
        clue.setCreateTime(DateTimeUtil.getSysTime());//19位
        clue.setCreateBy(((User)session.getAttribute("user")).getName());
        clueService.saveClue(clue);
        return HandleFlag.successTrue();
    }

    @RequestMapping("/toClueDetail.do")
    public ModelAndView toClueDetail(String id){
        ModelAndView mv = new ModelAndView();

        Clue clue = clueService.findById(id);

        mv.addObject("c",clue);

        mv.setViewName("/workbench/clue/detail");

        return mv;
    }

    /**
     * 展示线索详情内容信息
     *      根据线索Id查询，线索备注列表和已关联的市场活动信息
     * @param clueId
     * @return
     */
    @RequestMapping("/getActivityListAndClueRemarkList.do")
    @ResponseBody
    public Map<String,Object> getActivityListAndClueRemarkList(String clueId){
        //定义返回结果集
        Map<String,Object> resultMap = new HashMap<>();
        //TODO 查询线索备注列表
        //select * from tbl_clue_remark where clueId = #{clueId}

        //将线索备注列表存入到结果集中

        //查询已关联的市场活动列表
        List<Activity> aList = activityService.findActivityListByClueId(clueId);

        //将已关联的市场活动列表存入到结果集中
        resultMap.put("success",true);
        resultMap.put("aList",aList);

        return resultMap;
    }

    @RequestMapping("/removeRelation.do")
    @ResponseBody
    public Map<String,Object> removeRelation(String relationId){
        clueService.deleteRelation(relationId);

        return HandleFlag.successTrue();
    }

    @RequestMapping("/getUnRelationActivityList.do")
    @ResponseBody
    public Map<String,Object> getUnRelationActivityList(String clueId){
        List<Activity> aList = clueService.getUnRelationActivityList(clueId);
        return HandleFlag.successObj("aList",aList);
    }

    @RequestMapping("/getRelationActivityList.do")
    @ResponseBody
    public Map<String,Object> getRelationActivityList(String clueId){
        List<Activity> aList = clueService.getRelationActivityList(clueId);
        return HandleFlag.successObj("aList",aList);
    }

    @RequestMapping("/findActivityListLike.do")
    @ResponseBody
    public Map<String,Object> findActivityListLike(String activityName){
        List<Activity> aList = activityService.findActivityListLike(activityName);
        return HandleFlag.successObj("aList",aList);
    }

    @RequestMapping("/addRelation.do")
    @ResponseBody
    public Map<String,Object> addRelation(String clueId, @RequestParam String[] activityIds){
        clueService.addRelation(clueId,activityIds);
        return HandleFlag.successTrue();
    }

    @RequestMapping("/toClueConvert.do")
    public ModelAndView toClueConvert(Clue clue){
        ModelAndView mv = new ModelAndView();

        mv.addObject("c",clue);
        mv.setViewName("/workbench/clue/convert");

        return mv;
    }

    /**
     * 根据线索Id和市场活动名称模糊查询已关联的市场活动列表
     * @param clueId
     * @param activityName
     * @return
     */
    @RequestMapping("/getRelationActivityListLike.do")
    @ResponseBody
    public Map<String,Object> getRelationActivityList(String clueId,String activityName) {
        List<Activity> aList = activityService.findRelationActivityListLike(clueId,activityName);
        return HandleFlag.successObj("aList",aList);
    }

    @RequestMapping("/exchangeClue.do")
    public String exchangeClue(@RequestParam Map<String,String> parapMap,HttpSession session ){
        parapMap.put("createTime",DateTimeUtil.getSysTime());//19位
        parapMap.put("createBy",(((User)session.getAttribute("user")).getName()));
        clueService.exchangeClue(parapMap);

        //线索转换完成后，重定向到线索首页，加载页面
        return "redirect:/workbench/clue/toClueIndex.do";
    }

}
