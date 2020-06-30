package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Activity;

import java.util.List;

public interface ActivityDao {

    /**
     * 查询市场活动列表
     *
     * @return
     */
    List<Activity> findAllActivity();

    /**
     * 新增市场活动
     * @param activity
     */
    void saveActivity(Activity activity);
}
