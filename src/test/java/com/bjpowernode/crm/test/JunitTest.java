package com.bjpowernode.crm.test;

import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.service.ActivityService;
import com.bjpowernode.crm.workbench.web.controller.ActivityController;
import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.List;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "classpath:spring/applicationContext.xml","classpath:spring/dispatcherServlet.xml" })
public class JunitTest {

    public static void main(String[] args) {
        //可以将代码和业务逻辑写在main方法里，可以去运行
        //比如，要是获取spring容器中的一些对象
        ApplicationContext app = new ClassPathXmlApplicationContext("spring/applicationContext.xml");
        //先要去创建容器，然后才能在容器中获取对象
        ActivityService activityService = app.getBean(ActivityService.class);
        for (Activity activity : activityService.findAll()) {
            System.out.println(activity);
        }
    }

    @Test
    public void test1(){
        //测试方法，只要在方法上添加@Test注解，即为测试方法，可以被运行
        //一个类中可以有多个测试方法

        //缺点：不能加载spring容器，需要代码初始化
    }


    //这样就不需要创建容器了，直接使用注解就可以获取到容器中的对象。
    @Autowired
    private ActivityService activityService;

    @Test
    public void test2(){
        System.out.println(activityService);
        List<Activity> all = activityService.findAll();
        for (Activity activity : all) {
            System.out.println(activity);
        }
    }


    @Autowired
    private ActivityController activityController;
    //Junit断言机制，用于判断两个内容是否相同或不同
    @Test
    public void test3(){
        //期望是参数1，实际上却是参数2
//        Assert.assertEquals(1l,2l);
//        Assert.assertEquals(1l,1l);

        //判断两个对象是否一样
//        Assert.assertEquals(activityController,activityService);
        Assert.assertEquals(activityController,activityController);
    }


}
