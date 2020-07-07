package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.Clue;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface ClueDao {
    void saveClue(Clue clue);

    Clue findById(String id);

    void deleteRelation(String relationId);

    List<Activity> getUnRelationActivityList(String clueId);

    void addRelation(@Param("id") String id,@Param("clueId") String clueId ,@Param("activityId") String activityIds);
}
