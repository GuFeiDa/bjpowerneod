package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.exception.LoginException;
import com.bjpowernode.crm.utils.Conts;
import com.bjpowernode.crm.utils.MD5Util;
import com.bjpowernode.crm.workbench.domain.User;
import com.bjpowernode.crm.workbench.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/workbench/user")
public class UserController {

    @Autowired
    private UserService userService;

    @Autowired
    private JedisPool jedisPool;

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
     * @param loginPwd 传递过来的是明文的
     * @param flag 十天免登陆的标记 a
     * @return
     */
    @RequestMapping("/ajax2login.do")
    @ResponseBody
    public Map<String,Object> ajax2login(String loginAct, String loginPwd, HttpServletRequest request, HttpServletResponse response, String flag) throws LoginException{
        System.out.println("ajax2login");

        //进行MD5加密
        String md5Pwd = MD5Util.getMD5(loginPwd);
        User user = userService.login(loginAct,md5Pwd);

        Map<String,Object> map = new HashMap<>();

        if(user == null){
//            //登录失败
//            map.put("success",false);
//            return map;
            //使用异常处理器进行集中处理异常
            throw new LoginException(Conts.LOGIN_FAIL);
        }

        //处理锁定状态、过期时间、IP是否受限
        String lockState = user.getLockState();
        if("0".equals(lockState)){
            //账号锁定
            throw new LoginException(Conts.LOGIN_LOCK);
        }

        String expireTime = user.getExpireTime();
        if(expireTime.compareTo(new SimpleDateFormat("yyyy-MM-dd hh:mm:ss").format(new Date())) < 0){
            //过期时间比当前时间小，代表已过期
            throw new LoginException(Conts.LOGIN_EXPIRED);
        }

        //获取当前ip地址
        //访问前端登录页，使用http://127.0.0.1:xxx
        String ip = request.getRemoteAddr();
        System.out.println("ip : "+ip);// 0:0:0:0:0:0:0:1
        String ips = user.getAllowIps();//192.xx.xxx.xxx,192.xx.xxx.xxx。。。

        if(ips != null) {
            if (!ips.contains(ip)) {
                //ip地址受限
                throw new LoginException(Conts.LOGIN_IP_NOT_ALLOW);
            }
        }

        map.put("success",true);

        //登录成功后，将登录对象存储到session
        request.getSession().setAttribute("user",user);

        //十天免登陆操作
        if("a".equals(flag)){
            //将用户名和密码，存储到cookie中
            Cookie loginActCookie = new Cookie("loginAct",loginAct);
            Cookie loginPwdCookie = new Cookie("loginPwd",MD5Util.getMD5(loginPwd));

            loginActCookie.setPath("/");
            loginPwdCookie.setPath("/");

            loginActCookie.setMaxAge(60*60*24*10);//秒为单位
            loginPwdCookie.setMaxAge(60*60*24*10);//秒为单位

            response.addCookie(loginActCookie);
            response.addCookie(loginPwdCookie);
//            Jedis jedis = jedisPool.getResource();
//            jedis.set("loginAct",loginAct);
//            jedis.set("loginPwd",MD5Util.getMD5(loginPwd));
//            Jedis resource = jedisPool.getResource();
//            resource.set("loginAct",loginAct);
//            resource.set("loginPwd",MD5Util.getMD5(loginPwd));
//            resource.expire("loginAct",60*60*24*10);
//            resource.expire("loginPwd",60*60*24*10);

        }

        return map;
    }

    @RequestMapping("/toWorkbenchIndex.do")
    public String toWorkbenchIndex(HttpSession session){
        User user = (User) session.getAttribute("user");
        System.out.println(user);
        return "/workbench/index";
    }

    @RequestMapping("/toLogin.do")
    public String toLogin(HttpServletRequest request){
        //进行免登陆操作
        //从cookie中获取用户名和密码，进行免登陆操作
        Cookie[] cookies = request.getCookies();

        String loginAct = "";
        String loginPwd = "";
        if(cookies != null) {
            // 3个  loginAct loginPwd xxxx
            for (Cookie cookie : cookies) {

                if ("loginAct".equals(cookie.getName())) {
                    //勾选了十天免登陆操作
                    loginAct = cookie.getValue();
                    //break，跳出循环，continue跳出此次循环
                    continue;
                }

                if ("loginPwd".equals(cookie.getName())) {
                    //勾选了十天免登陆操作
                    loginPwd = cookie.getValue();
                }

            }

            //loginPwd 存储的是已经加密后的密码了
            User user = userService.login(loginAct, loginPwd);

            request.getSession().setAttribute("user",user);

            if (user != null) {
                //进行免登陆操作，跳转到工作台的首页
                return "/workbench/index";
            }
        }
        return "/login";
    }


    /**
     * 退出登录，重定向到登录页面
     */
    @RequestMapping("/logout.do")
    public String logout(HttpServletRequest request,HttpServletResponse response){
        //销毁session中的user对象
        //方式1
//        User user  = (User) request.getSession().getAttribute("user");
//        user = null;
//        request.getSession().setAttribute("user",user);
        //方式2,销毁方法
        request.getSession().invalidate();

        //销毁Cookie中的用户名和密码
        Cookie[] cookies = request.getCookies();
        //TODO 这样操作，会重新创建两个cookie，而不会把之前覆盖

        if(cookies != null) {
            for (Cookie cookie : cookies) {
                if ("loginAct".equals(cookie.getName())) {
                    //将用户名设置为空的字符串
                    cookie.setValue("");
//                    continue;
                }
                if ("loginPwd".equals(cookie.getName())) {
                    //将用户名设置为空的字符串
                    cookie.setValue("");
                }
                cookie.setPath("/");
                cookie.setMaxAge(0);
                response.addCookie(cookie);
            }
        }

        //将用户名和密码，从cookie中清除掉
//        Cookie loginActCookie = new Cookie("loginAct","");
//        Cookie loginPwdCookie = new Cookie("loginPwd","");
//
//        loginActCookie.setPath("/");
//        loginPwdCookie.setPath("/");
//
//        loginActCookie.setMaxAge(0);//秒为单位
//        loginPwdCookie.setMaxAge(0);//秒为单位
//
//        response.addCookie(loginActCookie);
//        response.addCookie(loginPwdCookie);

        //重定向到登录页面
//        return "redirect:/workbench/user/toLogin.do";
        return "/login";
    }

}
