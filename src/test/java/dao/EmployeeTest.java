package dao;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.nice.bean.Employee;
import com.nice.dao.DepartmentMapper;
import com.nice.dao.EmployeeMapper;
import com.nice.service.EmployeeService;
import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.Arrays;
import java.util.List;

@RunWith(SpringJUnit4ClassRunner.class)   //指定Spring的单元测试
@ContextConfiguration(locations = {"classpath:application.xml"})  //指定Spring的配置文件位置
public class EmployeeTest {
    @Autowired
    EmployeeService employeeService;
    @Autowired
    DepartmentMapper departmentMapper;
    @Autowired
    EmployeeMapper employeeMapper;
    //批量操作
    @Autowired
    SqlSession sqlSession;

    @Test
    public void test3(){//org.springframework.dao.DuplicateKeyException
        int i = employeeService.saveEmp(new Employee(null, "bbb", "M", "qq@qq.com", 1));
        System.out.println(i);

    }
    @Test
    public void test1(){
//        int i = departmentMapper.insertSelective(new Department(null, "人事部"));
//        System.out.println(i);
//        employeeMapper.insertSelective(new Employee(null,"jack", "F","jack@163.com",1));

        //批量操作
//        EmployeeMapper employee = sqlSession.getMapper(EmployeeMapper.class);
//        for (int i = 0; i < 1000; i++) {
//            String random = UUID.randomUUID().toString().substring(0,6) + i;
//            employee.insertSelective(new Employee(null,random,"M",random + "@163.com",1));
//        }
//        System.out.println("批量完成");

//        List<Employee> employees = employeeMapper.selectByExampleWithDepart(new EmployeeExample());
//        System.out.println(employees);
    }
    //分页查询   只是测试PageInfo的功能
    @Test
    public void test2(){
        PageHelper.startPage(1,5);
        List<Employee> employeeList = employeeService.getAll();
        PageInfo<Employee> pageInfo = new PageInfo<>(employeeList,6);
        System.out.println(pageInfo.getList());
        //Page {count=true, pageNum=1, pageSize=5, startRow=0, endRow=5, total=1002, pages=201, reasonable=false, pageSizeZero=false}
        System.out.println("==========================================================");
        System.out.println(pageInfo.getNavigateFirstPage()); //1
        System.out.println(pageInfo.getNavigateLastPage()); //6
        System.out.println(Arrays.toString(pageInfo.getNavigatepageNums())); //[1, 2, 3, 4, 5, 6]
        System.out.println(pageInfo.getNavigatePages()); //6
        System.out.println("==========================================================");
        System.out.println(pageInfo.getPageNum());//1  当前页码
        System.out.println(pageInfo.getPages());//201  一共有201页
        System.out.println(pageInfo.getPageSize());//5  一页有5条记录
        System.out.println(pageInfo.getPrePage());//0   上一页
        System.out.println(pageInfo.getNextPage());//2   下一页
        System.out.println(pageInfo.getSize());//5       一页有5条记录
        System.out.println(pageInfo.getTotal());//1002   一共有1002条记录
    }
}
