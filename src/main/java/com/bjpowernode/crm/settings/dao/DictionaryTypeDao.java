package com.bjpowernode.crm.settings.dao;

import com.bjpowernode.crm.settings.domain.DicType;

import java.util.List;

public interface DictionaryTypeDao {

    /**
     * 查询字典类型列表
     * @return List<DicType>
     */
    List<DicType> findAllDicType();

    /**
     * 查询字典类型编码是否重复
     * @param code
     * @return
     */
    DicType checkTypeCode(String code);

    /**
     * 新增字典类型数据
     * @param dicType
     */
    void saveDicType(DicType dicType);

    /**
     * 根据编码查询字典类型数据
     * @param code
     * @return
     */
    DicType findDicTypeByCode(String code);

    /**
     * 根据code修改字典类型数据
     * @param dicType
     */
    void updateDicType(DicType dicType);
}
