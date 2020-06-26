package com.bjpowernode.crm.utils;

import java.text.SimpleDateFormat;
import java.util.Date;

public class DateTimeUtil {
	
	public static String getSysTime(){
		//2020-06-26 09:40:40   19位的时间格式
		//2020-06-26  			10位的时间格式
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		
		Date date = new Date();
		String dateStr = sdf.format(date);
		
		return dateStr;
		
	}
	public static String getSysTimeForUpload(){

		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");

		Date date = new Date();
		String dateStr = sdf.format(date);

		return dateStr;

	}
}
