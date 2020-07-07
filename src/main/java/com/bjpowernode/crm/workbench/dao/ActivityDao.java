package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityDao {

    /**
     * 查询市场活动列表
     *
     * @return
     */
    List<Activity> findAllActivity(Map<String,Object> paramMap);

    /**
     * 新增市场活动
     * @param activity
     */
    void saveActivity(Activity activity);

    /**
     * 查询市场活动总记录数
     * @return
     */
    Long findActivityCount(Map<String,Object> paramMap);

    /**
     * 删除市场活动数据，1条/多条
     * @param activityIds
     */
    void deleteByIds(String[] activityIds);

    /**
     * 根据id查询市场活动
     * @param id
     * @return
     */
    Activity findById(String id);

    /**
     * 根据ID更新市场活动
     * @param activity
     */
    void updateById(Activity activity);

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
     * 根据市场活动名称进行模糊查询
     * @param activityName
     * @return
     */
    List<Activity> findActivityListLike(String activityName);

    /**
     * 根据线索ID查询已关联的市场活动名称进行模糊查询
     * @param param
     * @return
     */
    List<Activity> findRelationActivityListLike(Map<String,String> param);
}
