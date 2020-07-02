package com.nice.service;

import com.nice.bean.Department;
import com.nice.dao.DepartmentMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @Author QH
 * @Date 2020/06/28
 **/
@Service
public class DepartmentService {
    @Autowired
    DepartmentMapper departmentMapper;

    public List<Department> getDeparts(){
        return departmentMapper.selectByExample(null);
    }
}
