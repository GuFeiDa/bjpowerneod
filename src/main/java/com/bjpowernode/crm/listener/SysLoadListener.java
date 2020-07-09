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
import java.util.*;

public class SysLoadListener implements ServletContextListener {



    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("...................load dic data start..................");

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

        System.out.println("...................load dic data end   ..................");

        System.out.println("...................load stage possibility start   ..................");
//        https://www.ip138.com/ascii/

        //加载属性文件，指定属性文件的名称，要去掉后缀名称
        Map<String,String> sMap = new HashMap<>();

        ResourceBundle bundle = ResourceBundle.getBundle("properties/stagePossibility");
        //set集合无序，唯一的。
//        Set<String> keys = bundle.keySet();
//        for (String key : keys) {
//            String value = (String) bundle.getObject(key);
//            sMap.put(key,value);
//        }

        Enumeration<String> keys = bundle.getKeys();
        while (keys.hasMoreElements()){
            String key = keys.nextElement();
            String value = (String) bundle.getObject(key);
            sMap.put(key,value);
        }

        System.out.println("...................sMap : "+sMap);

        //将阶段和对应的可能性集合存入到服务器缓存中
        sce.getServletContext().setAttribute("sMap",sMap);

        System.out.println("...................load stage possibility end   ..................");
    }
}
