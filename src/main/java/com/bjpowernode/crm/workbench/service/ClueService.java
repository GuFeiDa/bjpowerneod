package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.Clue;

import java.util.List;

public interface ClueService {
    void saveClue(Clue clue);

    Clue findById(String id);

    void deleteRelation(String relationId);

    List<Activity> getUnRelationActivityList(String clueId);

    void addRelation(String clueId, String[] activityIds);
}
