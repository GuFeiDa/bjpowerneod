package com.bjpowernode.crm.test;

import org.junit.Test;

import java.util.HashMap;
import java.util.Map;

public class MapTest {

    @Test
    public void test(){
        //HandleFlag
        Map map1 = new HashMap();
        map1.put("success",true);

        Map map2 = new HashMap();
        map2.put("total",20);
        map2.put("msg","恭喜你，中奖了~");

        map1.putAll(map2);

        System.out.println(map1);

    }

}
