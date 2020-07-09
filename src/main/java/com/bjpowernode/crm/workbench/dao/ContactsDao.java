package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Contacts;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface ContactsDao {
    Contacts findByFullName(@Param("fullname") String fullname, @Param("customerId") String customerId);

    void saveContacts(Contacts con);

    List<Contacts> findAll();
}
