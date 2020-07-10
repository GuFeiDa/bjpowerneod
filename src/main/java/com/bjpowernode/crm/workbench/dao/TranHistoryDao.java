package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.TranHistory;

import java.util.List;
import java.util.Map;

public interface TranHistoryDao {
    void saveTranHistory(TranHistory th);

    /**
     * 根据交易id，查询交易历史记录
     * @param tranId
     * @return
     */
    List<TranHistory> getTranHistoryListByTranId(String tranId);

    /**
     * 根据阶段名称进行分组查询，查询每个阶段对应的交易数量
     * @return
     */
    List<Map<String, String>> findTranHistory();

}
