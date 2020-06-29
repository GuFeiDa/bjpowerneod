package com.bjpowernode.crm.settings.web.controller;

import com.bjpowernode.crm.exception.TraditionRequestException;
import com.bjpowernode.crm.settings.domain.DicType;
import com.bjpowernode.crm.settings.service.DictionaryTypeService;
import com.bjpowernode.crm.utils.HandleFlag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/settings/dictionary")
public class DictionaryController {

    @Autowired
    private DictionaryTypeService dictionaryTypeService;

    /**
     * 跳转到字典首页
     * @return
     */
    @RequestMapping("/toDicIndex.do")
    public String toDicIndex(){
        //  /WEB-INF/jsp
        return "/settings/dictionary/index";
    }

    /**
     *
     * @return ModelAndView 可以封装视图和数据
     */
    @RequestMapping("/type/toDicTypeIndex.do")
    public ModelAndView toDicTypeIndex(){
        ModelAndView mv = new ModelAndView();
        mv.setViewName("/settings/dictionary/type/index");
        //从数据库查询，字典类型列表
        //selectXxx , queryXxxx , findXxxx
        List<DicType> dicTypeList = dictionaryTypeService.findAllDicType();
        mv.addObject("dtList",dicTypeList);
        return mv;
    }

    /**
     * 跳转到字典类型新增页面
     * @return
     */
    @RequestMapping("/type/toDicTypeSave.do")
    public String toDicTypeSave(){
        return "/settings/dictionary/type/save";
    }


    /**
     * 新增字典类型，检查编码是否重复
     * @param code
     * @return
     */
    @RequestMapping("/type/checkTypeCode.do")
    @ResponseBody
    public Map<String,Object> checkTypeCode(String code){
        Map<String,Object> map = new HashMap();
        boolean flag = dictionaryTypeService.checkTypeCode(code);

        if(flag){
            //不重复，可以新增
//            map.put("success",true);
//            map.put("msg","可以新增");
            return HandleFlag.successTrue(); // {"success":true}
        }else{
            //重复
            map.put("success",false);
            map.put("msg","编码重复，请重新输入");
//            return HandleFlag.successObj("msg","编码重复，请重新输入");// { "success": true, msg : "编码重复，请重新输入"}
        }

//        map.put("success",flag);
//        map.put("msg",flag==true ? "可以新增":"编码重复，请重新输入");


        return map;
    }

    /**
     * 新增字典类型数据，新增成功后，跳转到字典类型列表页
     */
    @RequestMapping("/type/saveDicType.do")
    public String saveDicType(DicType dicType) throws TraditionRequestException {
        dictionaryTypeService.saveDicType(dicType);

        // 此处，如果直接跳转到列表页，缺少列表的数据，dicTypeList
//        return "/settings/dictionary/type/index";
        // 可以自己查询，然后将返回值改为ModelAndView。
        // 还可以直接通过url的形式访问该控制器。
        return "redirect:/settings/dictionary/type/toDicTypeIndex.do";
    }

    /**
     * 根据编码查询，字典类型数据，并跳转到修改页面
     * @param code
     * @return
     */
    @RequestMapping("/type/findDicTypeByCode.do")
    public ModelAndView findDicTypeByCode(String code){
        DicType dicType = dictionaryTypeService.findDicTypeByCode(code);

        ModelAndView mv = new ModelAndView();
        mv.setViewName("/settings/dictionary/type/edit");
        mv.addObject("dt",dicType);
        return mv;
    }



    @RequestMapping("/type/updateDicType.do")
//    public String updateDicType(DicType dicType , String code){
    public String updateDicType(DicType dicType) throws TraditionRequestException{

        dictionaryTypeService.updateDicType(dicType);

        return "redirect:/settings/dictionary/type/toDicTypeIndex.do";
    }


}
