package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.workbench.dao.UserDao;
import com.bjpowernode.crm.workbench.domain.User;
import com.bjpowernode.crm.workbench.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserDao userDao;

    @Override
    public User login(String loginAct, String loginPwd) {
        return userDao.login(loginAct,loginPwd);

    }

    @Override
    public List<User> findAllUser() {
        return userDao.findAllUser();
    }
}
