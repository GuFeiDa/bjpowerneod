package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.CustomerRemark;

import java.util.List;

public interface CustomerRemarkDao {
    void saveCustomerRemarks(List<CustomerRemark> customerRemarkList);
}
