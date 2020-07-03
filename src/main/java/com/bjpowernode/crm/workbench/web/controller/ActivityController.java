package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.HandleFlag;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.User;
import com.bjpowernode.crm.workbench.service.ActivityService;
import com.bjpowernode.crm.workbench.service.UserService;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.DateUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static java.lang.Integer.valueOf;

@Controller
@RequestMapping("/workbench/activity")
public class ActivityController {

    @Autowired
    private ActivityService activityService;

    @Autowired
    private UserService userService;

    @RequestMapping("/toActivityIndex.do")
    //将视图和数据封装到ModelAndView中
//    public ModelAndView toActivityIndex(){
    //将试图和数据分开，返回值String，代表返回的视图页面，参数Model，将数据存到request域中
    public String toActivityIndex(Model model){
        //从数据库中查询出市场活动列表
//        List<Activity> aList = activityService.findAllActivity();
//        model.addAttribute("aList",aList);
        return "/workbench/activity/index";
    }

    @RequestMapping("/getUserList.do")
    @ResponseBody
    public Map<String,Object> getUserList(){
        List<User> uList = userService.findAllUser();

        Map<String,Object> resultMap = new HashMap<>();
        resultMap.put("success",true);
        resultMap.put("msg", "获取用户列表成功");
        resultMap.put("uList",uList);
        return resultMap;
    }

    @RequestMapping("/saveActivity.do")
    @ResponseBody
    public Map<String,Object> saveActivity(Activity activity, HttpSession session){
        String id = UUIDUtil.getUUID();
        String createBy = ((User)session.getAttribute("user")).getName();
        String createTime = DateTimeUtil.getSysTime();
        activity.setId(id);
        activity.setCreateTime(createTime);//19位
        activity.setCreateBy(createBy);
        activityService.saveActivity(activity);
        return HandleFlag.successTrue();
    }


    /**
     * 查询列表并分页
     * @return
     */
    @RequestMapping("/getPageList.do")
    @ResponseBody
    public Map<String,Object> getPageList(@RequestParam Map<String,Object> paramMap){
        //在查询时，分页参数要转换成int或者Integer，不然会执行sql时会报错。
        //如果没有将字符串进行转换，会在执行sql拼接，''0' , '5''，错误语法。
        String p1 = (String) paramMap.get("pageNo");
        Integer pageNo = Integer.valueOf(p1);
        String p2 = (String) paramMap.get("pageSize");
        Integer pageSize = Integer.valueOf(p2);
        paramMap.put("pageNo",pageNo);
        paramMap.put("pageSize",pageSize);

        List<Activity> aList = activityService.findAllActivity(paramMap);
        //获取总记录数
        String userId = (String) paramMap.get("userId");
        Long count = activityService.findActivityCount(paramMap);
        Map<String, Object> map = new HashMap<>();
        map.put("total",count);
        map.put("aList",aList);
        map.put("msg","查询成功");

        Map<String, Object> flagMap = HandleFlag.successTrue();
        flagMap.putAll(map);
        return flagMap;
    }


    /**
     *  删除分为两种
     *      物理删除，delete from tbl_xxxx where id = ? ，真正的在数据库中(磁盘)进行了删除操作。
     *      逻辑删除，设置表中某一个字段，以该字段为是否查询的条件。
     *          不是真正意义上的删除，而是通过字段的方式我们进行查询。
     *
     * @param activityIds
     * @return
     */
    @RequestMapping("/deleteByIds.do")
    @ResponseBody
    public Map<String,Object> deleteByIds(String[] activityIds){
        activityService.deleteByIds(activityIds);
        return HandleFlag.successObj("msg","删除成功");
    }


    @RequestMapping("/findById.do")
    @ResponseBody
    public Map<String,Object> findById(String id ){
        Activity activity = activityService.findById(id);
        return HandleFlag.successObj("a",activity);
    }

    @RequestMapping("/updateById.do")
    @ResponseBody
//    public Map<String,Object> updateById(Activity activity,String id)
    public Map<String,Object> updateById(Activity activity,HttpSession session){
        //给修改人和修改时间赋值
        activity.setEditTime(DateTimeUtil.getSysTime());
        activity.setEditBy(((User)session.getAttribute("user")).getName());
        activityService.updateById(activity);
        return HandleFlag.successTrue();
    }


    /**
     * 根据传递的市场活动id选中导出市场活动数据到Excel中
     * @param activityIds
     */
    @RequestMapping("/exportActivitySelected.do")
    public void exportActivitySelected(String[] activityIds,HttpServletResponse response) throws Exception{
        List<Activity> aList = activityService.findByIds(activityIds);
        downLoadExcel(aList,response);
    }


    /**
     * 导出全部市场活动数据到Excel中
     * @param response
     * @throws Exception
     */
    @RequestMapping("/exportActivityAll.do")
    public void exportActivityAll (HttpServletResponse response) throws Exception{
        //将tbl_activity表中的数据查询出来
        List<Activity> aList = activityService.findAll();

        //封装批量导出/选择导出的下载方法
        downLoadExcel(aList,response);
    }

    /**
     * 封装批量导出/选择导出的下载方法
     * @param aList 要导出的数据
     * @param response 打开下载框，设置下载文件的名称
     * @throws Exception
     */
    private void downLoadExcel(List<Activity> aList,HttpServletResponse response) throws Exception {
        //接下来要创建POI对象，封装，写入Excel文件
        //创建工作簿对象
        HSSFWorkbook workbook = new HSSFWorkbook();
        //创建页码对象
        HSSFSheet sheet = workbook.createSheet();
        //创建行对象，写入表头数据
        HSSFRow r1 = sheet.createRow(0);

        r1.createCell(0).setCellValue("id");
        r1.createCell(1).setCellValue("owner");
        r1.createCell(2).setCellValue("name");
        r1.createCell(3).setCellValue("startDate");
        r1.createCell(4).setCellValue("endDate");
        r1.createCell(5).setCellValue("cost");
        r1.createCell(6).setCellValue("description");
        r1.createCell(7).setCellValue("createTime");
        r1.createCell(8).setCellValue("createBy");
        r1.createCell(9).setCellValue("editTime");
        r1.createCell(10).setCellValue("editBy");

        //循环遍历，填充数据
        //遍历填充，行数据
        for(int i=1;i<=aList.size();i++){
            HSSFRow row = sheet.createRow(i);
            Activity activity = aList.get(i - 1);

            //遍历填充单元格数据
            for (int j=0;j<11;j++){
                if (j==0){
                    row.createCell(0).setCellValue(activity.getId());
                }else if (j==1){
                    row.createCell(1).setCellValue(activity.getOwner());
                }else if (j==2){
                    row.createCell(2).setCellValue(activity.getName());
                }else if (j==3){
                    row.createCell(3).setCellValue(activity.getStartDate());
                }else if (j==4){
                    row.createCell(4).setCellValue(activity.getEndDate());
                }else if (j==5){
                    row.createCell(5).setCellValue(activity.getCost());
                }else if (j==6){
                    row.createCell(6).setCellValue(activity.getDescription());
                }else if (j==7){
                    row.createCell(7).setCellValue(activity.getCreateTime());
                }else if (j==8){
                    row.createCell(8).setCellValue(activity.getCreateBy());
                }else if (j==9){
                    row.createCell(9).setCellValue(activity.getEditTime());
                }else if (j==10){
                    row.createCell(10).setCellValue(activity.getEditBy());
                }
            }
        }

        //输出
        //为客户浏览器提供下载框
        response.setContentType("octets/stream");
        response.setHeader("Content-Disposition","attachment;filename=Activity-"+DateTimeUtil.getSysTime()+".xls");

        OutputStream out = response.getOutputStream();

        workbook.write(out);
    }

    @RequestMapping("/importActivity.do")
    @ResponseBody
    public Map<String,Object> importActivity(HttpSession session,@RequestParam("myFile") MultipartFile multipartFile, HttpServletRequest request) throws Exception{

        //获取原来的名称进行替换，替换成唯一的名称
        //原始文件名称
        String fileOriginalFilename = multipartFile.getOriginalFilename();

        //新的，不重复的文件名称
        String suffix = fileOriginalFilename.substring(fileOriginalFilename.lastIndexOf(".") + 1); //xls

        //使用UUID可以，还可以使用DateTimeUtil.getSysTimeForUpload()方法，根据当前时间为名称
        String fileName = DateTimeUtil.getSysTimeForUpload() + "." + suffix;
        System.out.println("fileName : "+fileName);
        //获取上传的路径
        String realPath = request.getRealPath("/upload");
        System.out.println("realPath : "+realPath);

        //执行上传操作
        //在测试上传文件时，需要注意，先创建一个文件夹，在该文件夹创建一个文件，clean一下，再启动tomcat
        //再去target目录下去查看
        multipartFile.transferTo(new File(realPath + "/" + fileName));

        //创建工作簿对象
        InputStream in = new FileInputStream(realPath + "/" + fileName);
        HSSFWorkbook workbook = new HSSFWorkbook(in);

        //创建页码对象
        HSSFSheet sheet = workbook.getSheetAt(0);

        int firstRowNum = sheet.getFirstRowNum();
        int lastRowNum = sheet.getLastRowNum();

        //把市场活动对象封装集合中
        List<Activity> aList = new ArrayList<>();

        //遍历表行，跳过表头
        for(int i=firstRowNum+1 ; i<= lastRowNum ; i++){

            //获取到表行中的每个单元格数据
            HSSFRow row = sheet.getRow(i);
            //name、startDate、endDate、cost、description
            //创建市场活动对象封装从Excel获取到的属性值
            String name = row.getCell(0).getStringCellValue();
            String startDate = row.getCell(1).getStringCellValue();
            String endDate = row.getCell(2).getStringCellValue();
            String cost = row.getCell(3).getStringCellValue();
            String description = row.getCell(4).getStringCellValue();

            Activity a = new Activity();
            a.setId(UUIDUtil.getUUID());
            a.setOwner(((User)session.getAttribute("user")).getId());
            a.setCreateBy(((User)session.getAttribute("user")).getName());
            a.setCreateTime(DateTimeUtil.getSysTime());
            a.setCost(cost);
            a.setDescription(description);
            a.setStartDate(startDate);
            a.setEndDate(endDate);
            a.setName(name);

            //将activity封装到集合容器中
            aList.add(a);
        }
        System.out.println(aList);

        //批量插入数据库
        activityService.saveActivityList(aList);

        return HandleFlag.successTrue();
    }


}
