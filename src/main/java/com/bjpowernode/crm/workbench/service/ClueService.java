package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.Clue;

import java.util.List;
import java.util.Map;

public interface ClueService {
    void saveClue(Clue clue);

    Clue findById(String id);

    void deleteRelation(String relationId);

    List<Activity> getUnRelationActivityList(String clueId);

    List<Activity> getRelationActivityList(String clueId);

    void addRelation(String clueId, String[] activityIds);

    /**
     * 线索转换
     * @param parapMap
     */
    void exchangeClue(Map<String, String> parapMap);
}
