package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.User;

public interface UserService {
    User login(String loginAct, String loginPwd);
}
