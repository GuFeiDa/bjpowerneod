package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityService {
    List<Activity> findAllActivity(Map<String,Object> paramMap);

    void saveActivity(Activity activity);

    Long findActivityCount(Map<String,Object> paramMap);

    void deleteByIds(String[] activityIds);

    Activity findById(String id);

    void updateById(Activity activity);

    /**
     * 批量导出，查询所有市场活动列表
     * @return
     */
    List<Activity> findAll();

    /**
     * 根据ids查询市场活动列表
     * @param activityIds
     * @return
     */
    List<Activity> findByIds(String[] activityIds);

    /**
     * 批量插入数据到数据库中
     * @param aList
     */
    void saveActivityList(List<Activity> aList);
}
