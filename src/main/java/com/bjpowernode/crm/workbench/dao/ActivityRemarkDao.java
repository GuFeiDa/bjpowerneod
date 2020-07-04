package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActivityRemarkDao {

    /**
     * 根据市场活动的id，查询市场活动详情列表
     * @param activityId
     * @return
     */
    List<ActivityRemark> getActivityRemarkList(String activityId);

    /**
     * 保存市场活动备注信息
     * @param activityRemark
     */
    void saveActivityRemark(ActivityRemark activityRemark);

    /**
     * 删除一条市场活动备注信息
     * @param id
     */
    void deleteActivityRemarkById(String id);

    /**
     * 修改市场活动备注信息
     * @param activityRemark
     */
    void updateActivityRemark(ActivityRemark activityRemark);
}
