package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.workbench.dao.ActivityRemarkDao;
import com.bjpowernode.crm.workbench.domain.ActivityRemark;
import com.bjpowernode.crm.workbench.service.ActivityRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ActivityRemarkServiceImpl implements ActivityRemarkService {

    @Autowired
    private ActivityRemarkDao activityRemarkDao;

    @Override
    public List<ActivityRemark> getActivityRemarkList(String activityId) {
        return activityRemarkDao.getActivityRemarkList(activityId);
    }

    @Override
    public void saveActivityRemark(ActivityRemark activityRemark) {
        activityRemarkDao.saveActivityRemark(activityRemark);
    }

    @Override
    public void deleteActivityRemarkById(String id) {
        activityRemarkDao.deleteActivityRemarkById(id);
    }

    @Override
    public void updateActivityRemark(ActivityRemark activityRemark) {
        activityRemarkDao.updateActivityRemark(activityRemark);
    }
}
