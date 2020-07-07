package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.ClueActivityRelation;

import java.util.List;

public interface ClueActivityRelationDao {
    List<ClueActivityRelation> findRelationListByClueId(String clueId);

    void deleteRelationByClueId(String clueId);
}
