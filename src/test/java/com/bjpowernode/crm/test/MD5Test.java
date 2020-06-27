package com.bjpowernode.crm.test;

import com.bjpowernode.crm.utils.MD5Util;
import org.junit.Test;

public class MD5Test {

    @Test
    public void test1(){
        //使用MD5加密后，得到的是固定长度的密文
        //32位长度，该算法是不可逆的，一旦经过加密无法进行解密。
        //现在设置某些应用的密码有具体要求的：必须是大小写字母加上数字，还可以加上特殊符号

        String pwd = MD5Util.getMD5("bjpowernode");
        String pwd1 = MD5Util.getMD5(pwd);
        System.out.println(pwd);
        System.out.println(pwd1);
        System.out.println(pwd.length());
    }
}
