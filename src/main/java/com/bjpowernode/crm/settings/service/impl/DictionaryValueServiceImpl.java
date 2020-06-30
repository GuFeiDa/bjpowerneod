package com.bjpowernode.crm.settings.service.impl;

import com.bjpowernode.crm.settings.dao.DictionaryValueDao;
import com.bjpowernode.crm.settings.domain.DicValue;
import com.bjpowernode.crm.settings.service.DictionaryValueService;
import com.bjpowernode.crm.utils.UUIDUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class DictionaryValueServiceImpl implements DictionaryValueService {

    @Autowired
    private DictionaryValueDao dictionaryValueDao;

    @Override
    public List<DicValue> findValueAll() {
        return dictionaryValueDao.findValueAll();
    }

    @Override
    public Map<String, Object> findByCodeOrValue(Map<String, String> dicValue) {
        DicValue dv = dictionaryValueDao.findByCodeOrValue(dicValue);

        //封装Map结果集
        Map<String,Object> result = new HashMap<>();

        if(dv != null){
            //不可以添加
            result.put("success",false);
            result.put("msg","字典值重复，请重新输入");
        }else{
            //可以添加
            result.put("success",true);
//            result.put("msg","字典值重复，请重新输入");
        }
        return result;
    }

    @Override
    public void saveDicValue(DicValue dicValue) {
        //给id赋值
        //UUID，是36位长度，其中有4个-，代表的是一条无意义的字符串，能够起到唯一标识的作用。
        //如果去掉-，是32位长度
        dicValue.setId(UUIDUtil.getUUID());
        dictionaryValueDao.saveDicValue(dicValue);
    }
}
