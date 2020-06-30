package com.bjpowernode.crm.settings.dao;

import com.bjpowernode.crm.settings.domain.DicValue;

import java.util.List;
import java.util.Map;

public interface DictionaryValueDao {

    /**
     * 查询字典值列表
     * @return
     */
    List<DicValue> findValueAll();

    /**
     * 根据字典类型编码和字典值查询
     * @param dicValue
     * @return
     */
    DicValue findByCodeOrValue(Map<String, String> dicValue);

    /**
     * 保存字典值数据
     * @param dicValue
     */
    void saveDicValue(DicValue dicValue);
}
