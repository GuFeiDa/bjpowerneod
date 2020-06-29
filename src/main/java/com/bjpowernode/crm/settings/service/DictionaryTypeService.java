package com.bjpowernode.crm.settings.service;

import com.bjpowernode.crm.exception.TraditionRequestException;
import com.bjpowernode.crm.settings.domain.DicType;

import java.util.List;

public interface DictionaryTypeService {
    List<DicType> findAllDicType();

    boolean checkTypeCode(String code);

    void saveDicType(DicType dicType) throws TraditionRequestException;

    DicType findDicTypeByCode(String code);

    void updateDicType(DicType dicType);
}
