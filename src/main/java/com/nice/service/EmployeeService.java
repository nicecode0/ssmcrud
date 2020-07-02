package com.nice.service;

import com.nice.bean.Employee;
import com.nice.bean.EmployeeExample;
import com.nice.dao.EmployeeMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class EmployeeService {
    @Autowired
    EmployeeMapper employeeMapper;

    public List<Employee> getAll(){
        return employeeMapper.selectByExampleWithDepart(null);
    }


    /**
     * 批量删除
     * @param ids
     */
    public void delEmps(List<Integer> ids){
        EmployeeExample employeeExample = new EmployeeExample();
        EmployeeExample.Criteria criteria = employeeExample.createCriteria();
        criteria.andIdIn(ids);
        employeeMapper.deleteByExample(employeeExample);
    }
    /**
     * 删除单个
     * @param id
     */
    public void delEmpById(Integer id){
        employeeMapper.deleteByPrimaryKey(id);
    }
    /**
     * 更新员工
     * @param employee
     */
    public void updateEmp(Employee employee){
        employeeMapper.updateByPrimaryKeySelective(employee);
    }

    /**
     * 根据员工id查询员工信息(不包含部门)
     * @param id
     * @return
     */
    public Employee getEmp(Integer id){
        return employeeMapper.selectByPrimaryKey(id);
    }
    /**
     * 新增员工
     * @param employee
     * @return
     */
    public int saveEmp(Employee employee){
        return employeeMapper.insertSelective(employee);
    }

    /**
     * 检查用户名
     * @param name
     * @return true:没有此用户,可以插入  false:有此用户
     */
    public boolean checkUser(String name){
        EmployeeExample employeeExample = new EmployeeExample();
        EmployeeExample.Criteria criteria = employeeExample.createCriteria();
        criteria.andNameEqualTo(name);
        long count = employeeMapper.countByExample(employeeExample);
        return count == 0;
    }
}
