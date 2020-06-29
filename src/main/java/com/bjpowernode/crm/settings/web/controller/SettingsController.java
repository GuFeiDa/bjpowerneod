package com.bjpowernode.crm.settings.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/settings")
public class SettingsController {

    @RequestMapping("/toSettingsIndex.do")
    public String toSettingsIndex(){
        return "/settings/index";
    }
}
