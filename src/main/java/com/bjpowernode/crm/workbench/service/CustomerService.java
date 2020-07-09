package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.Customer;

public interface CustomerService {
    Customer findCustomerByCompany(String customerName);
}
