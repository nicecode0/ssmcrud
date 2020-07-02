package com.nice.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.nice.bean.Employee;
import com.nice.bean.Msg;
import com.nice.service.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class EmployeeController {
    @Autowired
    EmployeeService employeeService;

    /**
     * 删除员工:
     * 单个删除,
     * 批量删除
     * @param ids
     * @return
     */
    @RequestMapping(value = "/emp/{ids}",method = RequestMethod.DELETE)
    @ResponseBody
    public Msg delEmpById(@PathVariable("ids") String ids){
        if (ids.contains("-")){//批量删除
            List<Integer> idsInt = new ArrayList<>();
            String[] strings = ids.split("-");
            for (String idItem:strings){
                idsInt.add(Integer.parseInt(idItem));
            }
            employeeService.delEmps(idsInt);
        }else{//单个删除
            int id = Integer.parseInt(ids);
            employeeService.delEmpById(id);
        }
        return Msg.success();
    }
    /**
     * 更新员工
     * @param employee
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/emp/{id}",method = RequestMethod.PUT)
    public Msg updateEmp(Employee employee){
        employeeService.updateEmp(employee);
        return Msg.success();
    }

    /**
     * 根据id查询员工(不包含部门名)
     * @param id
     * @return
     */
    @RequestMapping(value = "/emp/{id}",method = RequestMethod.GET)
    @ResponseBody
    public Msg getEmp(@PathVariable("id") Integer id){
        Employee emp = employeeService.getEmp(id);
        return Msg.success().add("emp",emp);
    }

    @RequestMapping(value = "/checkUser",method = RequestMethod.POST)
    @ResponseBody
    public Msg checkUser(@RequestParam("name")String name){
        boolean b = employeeService.checkUser(name);
        if (b){//可以添加员工
            return Msg.success();
        }else{
            return Msg.fail();
        }
    }
    //新增员工
    @RequestMapping(value = "/emp",method = RequestMethod.POST)
    @ResponseBody
    public Msg saveEmp(@Valid Employee employee, BindingResult result){
        Map<String,Object> checkEmp = new HashMap<>();
        if (result.hasErrors()){//校验失败
            List<FieldError> fieldErrors = result.getFieldErrors();
            for (FieldError fieldError:fieldErrors){
                checkEmp.put(fieldError.getField(),fieldError.getDefaultMessage());
            }
            return Msg.fail().add("checkMsg",checkEmp);
        }else{//校验成功
            try {
                employeeService.saveEmp(employee);
            } catch (org.springframework.dao.DuplicateKeyException e) {
                checkEmp.put("name","此用户已存在");
                return Msg.fail().add("checkMsg",checkEmp);
            }
            return Msg.success();
        }
    }

    //分页显示所有员工
    @ResponseBody
    @RequestMapping("/emps")
    public Msg getAllWithJson(@RequestParam(value = "pa",defaultValue = "1")Integer pageNum){
        PageHelper.startPage(pageNum,6);
        List<Employee> employeeList = employeeService.getAll();
        //一次显示5页
        PageInfo<Employee> pageInfo = new PageInfo<>(employeeList,5);
        return Msg.success().add("pageInfo",pageInfo);
    }
}
