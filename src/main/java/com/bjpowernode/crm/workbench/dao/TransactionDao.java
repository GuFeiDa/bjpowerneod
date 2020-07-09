package com.bjpowernode.crm.workbench.dao;

import java.util.List;

public interface TransactionDao {
    /**
     * 自动补全返回的结果
     * @param name
     * @return
     */
    List<String> getCustomerName(String name);
}
