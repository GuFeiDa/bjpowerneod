package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.workbench.domain.User;
import com.bjpowernode.crm.workbench.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/workbench/user")
public class UserController {

    @Autowired
    private UserService userService;

    /**
     * 传统的表单提交
     * @param loginAct
     * @param loginPwd
     * @return
     */
    @RequestMapping("/login.do")
    public String login(String loginAct,String loginPwd){
        //使用loginAct和loginPwd查询数据库
        User user = userService.login(loginAct,loginPwd);

        //如果查询出来对应User用户，证明登录成功
        if(user == null){
            //登录失败，跳转到登录页面
            return "redirect:/login.jsp";
        }

        //登录成功，跳转到工作台的index.jsp页面
        //视图解析器会拼接 /WEB-INF/jsp + 返回值 + .jsp
        return "/workbench/index";
    }

    /**
     * 使用Ajax进行表单提交
     * @param loginAct
     * @param loginPwd
     * @return
     */
    @RequestMapping("/ajax2login.do")
    @ResponseBody
    public Map<String,Object> ajax2login(String loginAct, String loginPwd){
        System.out.println("ajax2login");

        User user = userService.login(loginAct,loginPwd);

        Map<String,Object> map = new HashMap<>();

        if(user == null){
            //登录失败
            map.put("success",false);
            return map;
        }


        map.put("success",true);

        return map;
    }

    @RequestMapping("/toWorkbenchIndex.do")
    public String toWorkbenchIndex(){
        return "/workbench/index";
    }

}
