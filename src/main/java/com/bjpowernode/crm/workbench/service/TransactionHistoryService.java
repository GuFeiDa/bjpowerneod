package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.TranHistory;

import java.util.List;
import java.util.Map;

public interface TransactionHistoryService {
    List<TranHistory> getTranHistoryListByTranId(String tranId);

    List<Map<String, String>> findTranHistory();

}
