package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.User;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface UserDao {
    User login(@Param("loginAct") String loginAct,@Param("loginPwd") String loginPwd);

    List<User> findAllUser();
//    User login(User user);
}
