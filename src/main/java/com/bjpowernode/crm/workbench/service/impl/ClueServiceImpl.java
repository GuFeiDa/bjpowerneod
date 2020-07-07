package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.workbench.dao.ClueDao;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.Clue;
import com.bjpowernode.crm.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ClueServiceImpl implements ClueService {

    @Autowired
    private ClueDao clueDao;

    @Override
    public void saveClue(Clue clue) {
        clueDao.saveClue(clue);
    }

    @Override
    public Clue findById(String id) {
        return clueDao.findById(id);
    }

    @Override
    public void deleteRelation(String relationId) {
        clueDao.deleteRelation(relationId);
    }

    @Override
    public List<Activity> getUnRelationActivityList(String clueId) {
        return clueDao.getUnRelationActivityList(clueId);
    }

    @Override
    public void addRelation(String clueId, String[] activityIds) {
//        Map<String,Object> param = new HashMap<>();
//        param.put("id", UUIDUtil.getUUID());
//        param.put("clueId",clueId);
//        param.put("activityIds",activityIds);
        //发现了类型转换的问题
//        clueDao.addRelation(param);

        //发现了，使用动态sql的foreach标签，无法遍历多个参数，尤其是参数中包含复杂类型(集合/数组)
//        clueDao.addRelation(UUIDUtil.getUUID(),clueId,activityIds);

        //最终选择了，使用简单类型去封装
        for (String activityId : activityIds) {
            clueDao.addRelation(UUIDUtil.getUUID(),clueId,activityId);
        }
    }
}
