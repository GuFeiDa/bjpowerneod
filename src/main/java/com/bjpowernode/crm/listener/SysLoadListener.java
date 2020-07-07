package com.bjpowernode.crm.listener;

import com.bjpowernode.crm.settings.domain.DicType;
import com.bjpowernode.crm.settings.domain.DicValue;
import com.bjpowernode.crm.settings.service.DictionaryTypeService;
import com.bjpowernode.crm.settings.service.DictionaryValueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class SysLoadListener implements ServletContextListener {



    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("...................load data start..................");

        //创建Spring容器
        ApplicationContext app = new ClassPathXmlApplicationContext("classpath:spring/applicationContext.xml");
        //获取容器中对象，DicTypeService
        DictionaryTypeService dicTypeService = app.getBean(DictionaryTypeService.class);
        //获取容器中对象，DicValueService
        DictionaryValueService dicValueService = app.getBean(DictionaryValueService.class);
        //查询数据库
        List<DicType> dicTypeList = dicTypeService.findAllDicType();

        for (DicType dicType : dicTypeList) {
        //获取数据字典类型和对应的数据字典值的集合
            List<DicValue> dicValueList = dicValueService.findListByTypeCode(dicType.getCode());

            System.out.println("...................key : " + dicType.getCode()+"List");
            System.out.println("...................value : " + dicValueList);

            //将它保存到最大的域对象中
            //${xxxxList} 获取到集合
            sce.getServletContext().setAttribute(dicType.getCode()+"List",dicValueList);
        }

        System.out.println("...................load data end   ..................");
    }
}
