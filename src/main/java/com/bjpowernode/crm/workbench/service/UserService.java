package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.User;

import java.util.List;

public interface UserService {
    User login(String loginAct, String loginPwd);

    List<User> findAllUser();

}
