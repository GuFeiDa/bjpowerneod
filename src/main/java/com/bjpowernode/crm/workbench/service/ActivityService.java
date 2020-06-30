package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.Activity;

import java.util.List;

public interface ActivityService {
    List<Activity> findAllActivity();

    void saveActivity(Activity activity);
}
