package com.nice.controller;

import com.nice.bean.Department;
import com.nice.bean.Msg;
import com.nice.service.DepartmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * @Author QH
 * @Date 2020/06/28
 **/
@Controller
public class DepartmentController {
    @Autowired
    DepartmentService departmentService;
    @RequestMapping(value = "/departs")
    @ResponseBody
    public Msg getDeparts(){
        List<Department> departs = departmentService.getDeparts();
        return Msg.success().add("departs", departs);
    }
}
