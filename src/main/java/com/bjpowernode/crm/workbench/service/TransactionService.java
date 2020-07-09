package com.bjpowernode.crm.workbench.service;

import java.util.List;
import java.util.Map;

public interface TransactionService {
    List<String> getCustomerName(String name);

    void saveTran(Map<String, String> parapMap);
}
