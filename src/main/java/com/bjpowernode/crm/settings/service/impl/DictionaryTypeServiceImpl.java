package com.bjpowernode.crm.settings.service.impl;

import com.bjpowernode.crm.exception.TraditionRequestException;
import com.bjpowernode.crm.settings.dao.DictionaryTypeDao;
import com.bjpowernode.crm.settings.domain.DicType;
import com.bjpowernode.crm.settings.service.DictionaryTypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DictionaryTypeServiceImpl implements DictionaryTypeService {

    @Autowired
    private DictionaryTypeDao dictionaryTypeDao;


    @Override
    public List<DicType> findAllDicType() {
        return dictionaryTypeDao.findAllDicType();
    }

    @Override
    public boolean checkTypeCode(String code) {
        DicType dicType = dictionaryTypeDao.checkTypeCode(code);
        //如果从数据库查询出来，证明重复了，返回false
        if(dicType != null){
            return false;
        }
//        else{
        return true;
//        }

    }

    @Override
    public void saveDicType(DicType dicType) throws TraditionRequestException {
            dictionaryTypeDao.saveDicType(dicType);
//            int i = 1/0;
    }

    @Override
    public DicType findDicTypeByCode(String code) {
        return dictionaryTypeDao.findDicTypeByCode(code);
    }

    @Override
    public void updateDicType(DicType dicType) {
        dictionaryTypeDao.updateDicType(dicType);
    }

    @Override
    public void deleteByCodes(String[] codes) {
        dictionaryTypeDao.deleteByCodes(codes);
    }

    @Override
    public List<String> findAllDicCode() {
        return dictionaryTypeDao.findAllDicCode();
    }
}
