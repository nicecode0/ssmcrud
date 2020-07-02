package dao;

import com.github.pagehelper.PageInfo;
import com.nice.bean.Employee;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import java.util.Arrays;
import java.util.List;

/**
 * @Author QH
 * @Date 2020/06/24
 * 使用SpringTest虚拟请求测试分页
 **/
@WebAppConfiguration    //@Autowired只能获取ioc容器里面的  需要获取ioc容器就要加@WebAppConfiguration
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:application.xml","classpath:SpringMVC.xml"})
public class PageInfoTest {
    @Autowired   //加入SpringMvc的ioc
    WebApplicationContext webApplicationContext;
    MockMvc mockMvc;   //虚拟请求
    @Before
    public void initMockMvc(){
        mockMvc = MockMvcBuilders.webAppContextSetup(webApplicationContext).build();
    }
    @Test
    public void test() throws Exception {
        MvcResult result = mockMvc.perform(MockMvcRequestBuilders.get("/emps").param("pa", "5")).andReturn();
        PageInfo page = (PageInfo) result.getRequest().getAttribute("pageInfo");
        System.out.println("第" + page.getPageNum() + "页");
        System.out.println("共" + page.getPages() + "页");
        int[] nums = page.getNavigatepageNums();
        System.out.println(Arrays.toString(nums));
        List<Employee> pageList = page.getList();
        for (Employee employee : pageList){
            System.out.println(employee);
        }
    }

}
