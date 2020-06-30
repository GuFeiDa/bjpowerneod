package com.bjpowernode.crm.test;

import com.bjpowernode.crm.utils.UUIDUtil;
import org.junit.Test;

import java.util.UUID;

public class UUIDTest {

    @Test
    public void test(){
        for(int i=0;i<5;i++){
            System.out.println(UUID.randomUUID());
            System.out.println(UUIDUtil.getUUID());
        }
    }
}
