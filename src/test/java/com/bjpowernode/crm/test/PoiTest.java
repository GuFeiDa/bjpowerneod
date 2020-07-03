package com.bjpowernode.crm.test;

import com.bjpowernode.crm.workbench.domain.User;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.CellType;
import org.junit.Test;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.List;

public class PoiTest {

    /**
     * 从Excel文件中读取数据
     */
    @Test
    public void test2() throws Exception {
        //从目标文件读取输入流对象
        InputStream in = new FileInputStream("C:\\Users\\003\\Desktop\\abc.xls");
        //创建工作簿对象，传入输入流对象
        HSSFWorkbook workbook = new HSSFWorkbook(in);
        //读取第一个页码
        HSSFSheet sheet = workbook.getSheetAt(0);
        //方式1，逐行获取
        //读取第一行，表头
//        HSSFRow r1 = sheet.getRow(0);
//        HSSFCell c1 = r1.getCell(0);
//        String idTable = c1.getStringCellValue();
//        HSSFCell c2 = r1.getCell(1);
//        String nameTable = c2.getStringCellValue();
//        HSSFCell c3 = r1.getCell(2);
//        String deptNoTable = c3.getStringCellValue();
//        System.out.println(idTable + "  "+nameTable+"  "+deptNoTable);
        //读取第二行
//        HSSFRow r2 = sheet.getRow(1);
        //读取第三行
//        HSSFRow r3 = sheet.getRow(2);
        //读取第四行
//        HSSFRow r4 = sheet.getRow(3);

        //方式2，遍历获取
        //从0开始，到行号-1就是最后的索引
        int firstRowNum = sheet.getFirstRowNum();
        int lastRowNum = sheet.getLastRowNum();

        System.out.println("firstRowNum  " + firstRowNum);
        System.out.println("lastRowNum  " + lastRowNum);

        //获取行对象
        for(int i=firstRowNum;i<=lastRowNum;i++) {
            HSSFRow row = sheet.getRow(i);

            short firstCellNum = row.getFirstCellNum();
            short lastCellNum = row.getLastCellNum();

//            System.out.println("firstCellNum  " + firstCellNum);
            //注意lastCellNum，它是最后的索引+1
//            System.out.println("lastCellNum  " + lastCellNum);

            for(int j=firstCellNum; j < lastCellNum; j++){
                String value = row.getCell(j).getStringCellValue();
                System.out.println(value);
            }
        }
    }

    /**
     * 模拟从数据库查出数据，将数据输出到Excel文件中
     *      细节：
     *          注意文件的后缀名称
     * @throws Exception
     */
    @Test
    public void test1() throws Exception{
        //将数据输出到excel文件中
        //准备数据
        List<User> sList = new ArrayList<>();
        User s1 = new User();
        s1.setId("A0001");
        s1.setName("zs");
        s1.setDeptno("20");

        User s2 = new User();
        s2.setId("A0002");
        s2.setName("ls");
        s2.setDeptno("20");

        User s3 = new User();
        s3.setId("A0003");
        s3.setName("ww");
        s3.setDeptno("20");

        sList.add(s1);
        sList.add(s2);
        sList.add(s3);

        //将集合中的内容输出到Excel文件中
        //创建工作簿对象
        HSSFWorkbook workbook = new HSSFWorkbook();
        //创建工作簿的页码对象
        HSSFSheet sheet = workbook.createSheet();
        //页码上，行和单元格
        HSSFRow row = sheet.createRow(0);//索引号为0，代表第一行，表头数据
        //根据行对象，创建某一行的单元格对象
        HSSFCell c1 = row.createCell(0, CellType.STRING);
        c1.setCellValue("编码");

        HSSFCell c2 = row.createCell(1);
        c2.setCellValue("姓名");

        HSSFCell c3 = row.createCell(2);
        c3.setCellValue("部门编号");

        for(int i=0;i<sList.size();i++){
            //基于页码对象创建，第二行的行对象
            HSSFRow r2 = sheet.createRow(i + 1);
            r2.createCell(0).setCellValue(sList.get(i).getId());
            r2.createCell(1).setCellValue(sList.get(i).getName());
            r2.createCell(2).setCellValue(sList.get(i).getDeptno());
        }

        //写入操作
        OutputStream out = new FileOutputStream("C:\\Users\\003\\Desktop\\abc.xls");
        workbook.write(out);

        //关闭资源
        out.close();
        workbook.close();

    }
}
