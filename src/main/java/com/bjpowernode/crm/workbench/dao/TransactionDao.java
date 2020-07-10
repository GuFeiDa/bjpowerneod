package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Tran;

import java.util.List;

public interface TransactionDao {
    /**
     * 自动补全返回的结果
     * @param name
     * @return
     */
    List<String> getCustomerName(String name);

    Tran findById(String id);

    void updateTransaction(Tran tran);
}
