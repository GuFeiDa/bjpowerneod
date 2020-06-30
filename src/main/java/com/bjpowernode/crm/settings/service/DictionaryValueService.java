package com.bjpowernode.crm.settings.service;

import com.bjpowernode.crm.settings.domain.DicValue;

import java.util.List;
import java.util.Map;

public interface DictionaryValueService {
    List<DicValue> findValueAll();

    Map<String, Object> findByCodeOrValue(Map<String, String> dicValue);

    void saveDicValue(DicValue dicValue);
}
