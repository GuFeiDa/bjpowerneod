package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.workbench.dao.ActivityDao;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class ActivityServiceImpl implements ActivityService {

    @Autowired
    private ActivityDao activityDao;


    @Override
    public List<Activity> findAllActivity(Map<String,Object> paramMap) {
        return activityDao.findAllActivity(paramMap);
    }

    @Override
    public void saveActivity(Activity activity) {
        activityDao.saveActivity(activity);
    }

    @Override
    public Long findActivityCount(Map<String,Object> paramMap) {
        return activityDao.findActivityCount(paramMap);
    }

    @Override
    public void deleteByIds(String[] activityIds) {
        //方式1，通过for循环遍历，一个一个删除

        //方式2，通过动态sql的方式，进行循环删除
        activityDao.deleteByIds(activityIds);
    }

    @Override
    public Activity findById(String id) {
        return activityDao.findById(id);
    }

    @Override
    public void updateById(Activity activity) {
        activityDao.updateById(activity);
    }

    @Override
    public List<Activity> findAll() {
        return activityDao.findAll();
    }

    @Override
    public List<Activity> findByIds(String[] activityIds) {
        return activityDao.findByIds(activityIds);
    }

    @Override
    public void saveActivityList(List<Activity> aList) {
        activityDao.saveActivityList(aList);
    }
}
