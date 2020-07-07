package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.workbench.dao.*;
import com.bjpowernode.crm.workbench.domain.*;
import com.bjpowernode.crm.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
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
    public List<Activity> getRelationActivityList(String clueId) {
        return clueDao.getRelationActivityList(clueId);
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

    @Autowired
    private CustomerDao customerDao;

    @Autowired
    private ContactsDao contactsDao;

    @Autowired
    private ClueRemarkDao clueRemarkDao;

    @Autowired
    private ContactsRemarkDao contactsRemarkDao;

    @Autowired
    private CustomerRemarkDao customerRemarkDao;

    @Autowired
    private ClueActivityRelationDao clueActivityRelationDao;

    @Autowired
    private ContactsActivityRelationDao contactsActivityRelationDao;

    @Autowired
    private TranDao tranDao;

    @Autowired
    private TranHistoryDao tranHistoryDao;

    /**
     * 线索转换业务逻辑： ( 将 线索 转换为 客户、联系人、客户备注、联系人备注 ，如果创建交易，6-10步骤 )
     *
     *      1.根据线索ID，查询线索信息
     *      2.根据线索中的company，查询对应的客户信息，如果没有，进行新增Customer
     *      3.根据线索中的fullname，查询对应联系人的信息，如果没有，进行新增Contacts
     *      4.根据线索备注信息，将它转换为联系人备注、客户备注信息
     *      5.将线索和市场活动的关联关系，转换为联系人和市场活动的关联关系
     *
     *      6.是否创建交易，根据flag参数进行判断
     *      7.新增交易及交易历史记录
     *      8.删除线索和市场活动的关联关系
     *      9.删除线索的备注信息
     *      10.删除线索
     *
     *
     * @param parapMap
     *       将线索转换为客户、联系人、备注信息需要的内容
     *          clueId
     *          activityId
     *          flag
     *          createTime  controller封装
     *          createBy    controller封装
     *
     *       交易实体类的属性
     *          money
     *          name
     *          expectedDate
     *          stage
     */
    @Override
    public void exchangeClue(Map<String, String> parapMap) {
        //0.将参数进行提取
        String clueId = parapMap.get("clueId");
        String activityId = parapMap.get("activityId");
        String createTime = parapMap.get("createTime");
        String createBy = parapMap.get("createBy");
        String flag = parapMap.get("flag");
        String money = "";
        String name = "";
        String expectedDate = "";
        String stage = "";
        if("a".equals(flag)){
            money = parapMap.get("money");
            name = parapMap.get("name");
            expectedDate  = parapMap.get("expectedDate");
            stage  = parapMap.get("stage");
        }

        //1.根据线索ID，查询线索信息
        Clue clue = clueDao.findById(clueId);
        if(clue != null){

            //2.根据线索中的company，查询对应的客户信息，如果没有，进行新增Customer
            String company = clue.getCompany();

                Customer cust = customerDao.findByCompany(company);
                if (cust == null) {
                    //新增一个客户对象
                    cust = new Customer();
                    //赋值操作
                    cust.setId(UUIDUtil.getUUID());
                    cust.setAddress(clue.getAddress());
                    cust.setContactSummary(clue.getContactSummary());
                    cust.setCreateBy(createBy);
                    cust.setCreateTime(createTime);
                    cust.setDescription(clue.getDescription());
                    cust.setName(company);
                    cust.setNextContactTime(clue.getNextContactTime());
                    cust.setOwner(clue.getOwner());
                    cust.setPhone(clue.getPhone());
                    cust.setWebsite(clue.getWebsite());

                    //新增客户记录
                    customerDao.saveCustomer(cust);
                }

            //3.根据线索中的fullname，查询对应联系人的信息，如果没有，进行新增Contacts
            Contacts con = contactsDao.findByFullName(clue.getFullname(),cust.getId());//如果根据联系人名称查询，存在重名问题，再加上一个条件，customerId

            if(con == null){
                //新增联系人记录
                con = new Contacts();
                con.setId(UUIDUtil.getUUID());
                con.setAddress(clue.getAddress());
                con.setAppellation(clue.getAppellation());
                con.setContactSummary(clue.getContactSummary());
                con.setCreateBy(createBy);
                con.setCreateTime(createTime);
                con.setDescription(clue.getDescription());
                con.setCustomerId(cust.getId());
                con.setEmail(clue.getEmail());
                con.setFullname(clue.getFullname());
                con.setJob(clue.getJob());
                con.setMphone(clue.getMphone());
                con.setNextContactTime(clue.getNextContactTime());
                con.setOwner(clue.getOwner());
                con.setSource(clue.getSource());

                //新增联系人记录
                contactsDao.saveContacts(con);
            }


            //4.根据线索备注信息，将它转换为联系人备注、客户备注信息
            //根据线索ID，查询所属的线索备注列表
            List<ClueRemark> crList = clueRemarkDao.findListByClueId(clueId);

            //容器
            List<ContactsRemark> contactsRemarkList = new ArrayList<>();
            List<CustomerRemark> customerRemarkList = new ArrayList<>();


            if(crList != null && crList.size() > 0 ){

                //换为联系人备注、客户备注信息
                for (ClueRemark clueRemark : crList) {

                    //创建联系人备注对象，封装到容器中，批量插入
                    ContactsRemark contactsRemark = new ContactsRemark();
                    contactsRemark.setId(UUIDUtil.getUUID());
                    contactsRemark.setContactsId(con.getId());
                    contactsRemark.setCreateBy(createBy);
                    contactsRemark.setCreateTime(createTime);
                    contactsRemark.setEditFlag("0");//未修改
                    contactsRemark.setNoteContent(clueRemark.getNoteContent());

                    //将联系人备注对象存入到容器中
                    contactsRemarkList.add(contactsRemark);

                    //创建客户备注对象，封装到容器中，批量插入
                    CustomerRemark customerRemark = new CustomerRemark();
                    customerRemark.setId(UUIDUtil.getUUID());
                    customerRemark.setCreateBy(createBy);
                    customerRemark.setCreateTime(createTime);
                    customerRemark.setCustomerId(cust.getId());
                    customerRemark.setEditFlag("0");//未修改
                    customerRemark.setNoteContent(clueRemark.getNoteContent());

                    //将客户备注对象存入到容器中
                    customerRemarkList.add(customerRemark);
                }

                //批量插入联系人备注和客户备注信息
                contactsRemarkDao.saveContactsRemarks(contactsRemarkList);
                customerRemarkDao.saveCustomerRemarks(customerRemarkList);

            }

            //5.将线索和市场活动的关联关系，转换为联系人和市场活动的关联关系
            List<ClueActivityRelation> carList = clueActivityRelationDao.findRelationListByClueId(clueId);

            //容器
            List<ContactsActivityRelation> contactsActivityRelationList = new ArrayList<>();

            if( carList.size() > 0 && carList != null){
                //遍历carList
                for (ClueActivityRelation car : carList) {
                    //将car转换为联系人和市场活动的对象
                    ContactsActivityRelation contactsActivityRelation = new ContactsActivityRelation();
                    contactsActivityRelation.setId(UUIDUtil.getUUID());
                    contactsActivityRelation.setActivityId(activityId);
                    contactsActivityRelation.setContactsId(con.getId());

                    //封装到容器中
                    contactsActivityRelationList.add(contactsActivityRelation);
                }

                //批量插入
                contactsActivityRelationDao.saveContactsActivityRelations(contactsActivityRelationList);
            }


            //6.是否创建交易，根据flag参数进行判断
            if("a".equals(flag)) {
                //勾选了创建交易

                //7.新增交易
                Tran t = new Tran();
                t.setId(UUIDUtil.getUUID());
                t.setActivityId(activityId);
                t.setContactsId(con.getId());
                t.setContactSummary(clue.getContactSummary());
                t.setCreateBy(createBy);
                t.setCreateTime(createTime);
                t.setCustomerId(cust.getId());
                t.setDescription(clue.getDescription());
                t.setExpectedDate(expectedDate);
                t.setMoney(money);
                t.setName(name);
                t.setNextContactTime(clue.getNextContactTime());
                t.setOwner(clue.getOwner());
                t.setSource(clue.getSource());
                t.setStage(stage);

                //新增交易记录
                tranDao.saveTran(t);

                //交易历史记录
                TranHistory th = new TranHistory();
                th.setId(UUIDUtil.getUUID());
                th.setCreateBy(createBy);
                th.setCreateTime(createTime);
                th.setExpectedDate(expectedDate);
                th.setMoney(money);
                th.setStage(stage);
                th.setTranId(t.getId());

                //新增交易历史记录
                tranHistoryDao.saveTranHistory(th);

                //因为有外键关联
                //线索和线索备注是一对多的关系，先删除外键数据
                //线索和市场活动是多对多的关联关系，先删除中间表
                //8.删除线索和市场活动的关联关系
                clueActivityRelationDao.deleteRelationByClueId(clueId);
                //9.删除线索的备注信息
                clueRemarkDao.deleteClueRemarksByClueId(clueId);
                //10.删除线索
                clueDao.deleteById(clueId);

            }
        }
    }
}
