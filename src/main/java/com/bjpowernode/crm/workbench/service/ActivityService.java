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

    /**
     * 根据id查询市场活动信息，为详情页面提供
     * @param id
     * @return
     */
    Activity findActivity(String id);

    /**
     * 根据线索id查询已关联的市场活动列表
     * @param clueId
     * @return
     */
    List<Activity> findActivityListByClueId(String clueId);

    /**
     * 根据市场活动名称进行模糊查询列表
     * @param activityName
     * @return
     */
    List<Activity> findActivityListLike(String activityName);

    /**
     * 根据线索Id和市场活动名称模糊查询已关联的市场活动列表
     * @param clueId
     * @param activityName
     * @return
     */
    List<Activity> findRelationActivityListLike(String clueId, String activityName);
}
