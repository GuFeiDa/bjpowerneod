package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityService {
    List<Activity> findAllActivity(Map<String,Object> paramMap);

    void saveActivity(Activity activity);

    Long findActivityCount(Map<String,Object> paramMap);

    void deleteByIds(String[] activityIds);
}
