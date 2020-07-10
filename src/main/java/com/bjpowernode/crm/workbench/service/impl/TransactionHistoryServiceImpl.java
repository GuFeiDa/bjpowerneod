package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.workbench.dao.TranHistoryDao;
import com.bjpowernode.crm.workbench.domain.TranHistory;
import com.bjpowernode.crm.workbench.service.TransactionHistoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class TransactionHistoryServiceImpl implements TransactionHistoryService {

    @Autowired
    private TranHistoryDao tranHistoryDao;

    @Override
    public List<TranHistory> getTranHistoryListByTranId(String tranId) {
        return tranHistoryDao.getTranHistoryListByTranId(tranId);
    }

    @Override
    public List<Map<String, String>> findTranHistory() {
        return tranHistoryDao.findTranHistory();
    }
}
