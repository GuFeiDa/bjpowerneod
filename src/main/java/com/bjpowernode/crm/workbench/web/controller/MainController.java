package com.bjpowernode.crm.workbench.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/workbench/main")
public class MainController {

    @RequestMapping("/toMainIndex.do")
    public String toMainIndex(){
        return "/workbench/main/index";
    }
}
