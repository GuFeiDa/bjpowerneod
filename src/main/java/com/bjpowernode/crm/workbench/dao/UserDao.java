package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.User;
import org.apache.ibatis.annotations.Param;

public interface UserDao {
    User login(@Param("loginAct") String loginAct,@Param("loginPwd") String loginPwd);
//    User login(User user);
}
