package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkDao {
    List<ClueRemark> findListByClueId(String clueId);

    void deleteClueRemarksByClueId(String clueId);
}
