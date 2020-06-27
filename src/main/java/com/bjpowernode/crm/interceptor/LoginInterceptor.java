package com.bjpowernode.crm.interceptor;

import com.bjpowernode.crm.exception.InterceptorException;
import com.bjpowernode.crm.workbench.domain.User;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 登录的拦截器
 *      验证当前操作者是否有权限操作
 */
public class LoginInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        //拦截当前请求
        //return false;
        //放行
        //1.判断当前用户是否有权限操作

        //2.登录了，就可以操作，未登录，不可以操作（返回到登录页面）
        User user = (User) request.getSession().getAttribute("user");

        //在拦截器执行时，需要设置放行的url，登录页的请求是需要放行的
        if(user == null){
            //代表没有权限操作，跳转到登录页面
            throw new InterceptorException();
        }
        return true;
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {

    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {

    }
}
