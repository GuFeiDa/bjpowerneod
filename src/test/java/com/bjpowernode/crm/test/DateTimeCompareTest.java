package com.bjpowernode.crm.test;

import org.junit.Test;

import java.text.SimpleDateFormat;
import java.util.Date;

public class DateTimeCompareTest {

    @Test
    public void test(){
        //比较日期
        //比较麻烦，繁琐
//        String time = "2020-06-27 10:00:10";

//        SimpleDateFormat sdf = new SimpleDateFormat(time);

//        Date date = new Date();
//        long dateTime = date.getTime();

        //
        String time = "2020-07-27 10:00:00";
        Date date = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
        String format = sdf.format(date);
        // time时间比当前时间要晚 -6
        System.out.println(time.compareTo(format));

    }
}
