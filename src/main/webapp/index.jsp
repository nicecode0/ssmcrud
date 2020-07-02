<%--
  Created by IntelliJ IDEA.
  User: 豪
  Date: 2020/06/23
  Time: 14:58
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>员工列表</title>
    <script type="text/javascript" src="${pageContext.request.contextPath}/statics/scripts/jquery-3.4.1.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/statics/bootstrap-3.3.7-dist/css/bootstrap.css">
    <script type="text/javascript" src="${pageContext.request.contextPath}/statics/bootstrap-3.3.7-dist/js/bootstrap.js"></script>
    <script type="text/javascript">
        var totalRecord,empPageNum,pageSize;
        $(function () {
            //默认第一页
            emp_ajax(1);
            //打开新增员工的模态框
            open_emp_modal();
            //新增员工
            saveEmp();
            //更新员工
            updateEmp();
        });
        //ajax请求员工
        function emp_ajax(pa) {
            $.ajax({
                type:"POST",
                url:"emps",
                data:"pa=" + pa,
                success:function (result) {
                    //构建员工列表
                    build_emps_table(result);
                    //构建分页记录
                    build_page_info(result);
                    //构建分页
                    build_page_num(result);
                }
            });
        }
        //构建员工列表
        function build_emps_table(result) {
            $("#emps_table tbody").empty();
            pageSize = result.map.pageInfo.size;
            var emps = result.map.pageInfo.list;
            $.each(emps,function (index,emp) {
                //员工的信息
                var checkEmpItemTd = $("<td></td>").append($("<input type='checkbox' class='checkEmpItem'>"));
                var empIdTd = $("<td></td>").append(emp.id);
                var empNameTd = $("<td></td>").append(emp.name);
                var empGenderTd = $("<td></td>").append(emp.gender);
                var empEmailTd = $("<td></td>").append(emp.email);
                var empDepartmentNameTd = $("<td></td>").append(emp.department.dName);
                /**
                 * 编辑按钮
                 <button class="btn btn-info btn-sm">
                 <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
                 编辑
                 </button>
                 */
                var ediBtn = $("<button></button>").addClass("btn btn-info btn-sm update_emp_btn").append($("<span></span>").addClass("glyphicon glyphicon-pencil")).append("编辑");
                ediBtn.attr("emp-id",emp.id);
                /**
                 删除按钮
                 <button class="btn btn-warning btn-sm">
                 <span class="glyphicon glyphicon-trash" aria-hidden="true"></span>
                 删除
                 </button>
                 */
                var delBtn = $("<button></button>").addClass("btn btn-warning btn-sm delete_emp_btn").append($("<span></span>").addClass("glyphicon glyphicon-trash")).append("删除");
                delBtn.attr("del-id",emp.id);
                //将编辑和删除按钮加入td中
                var twoBtnTd = $("<td></td>").append(ediBtn).append(" ").append(delBtn);
                //将以上td加入tr中
                var empTr = $("<tr></tr>").append(checkEmpItemTd)
                    .append(empIdTd)
                    .append(empNameTd)
                    .append(empGenderTd)
                    .append(empEmailTd)
                    .append(empDepartmentNameTd)
                    .append(twoBtnTd)
                //将tr加入到tbody中
                $("#emps_table tbody").append(empTr);
            })
        }
        //构建分页记录
        function build_page_info(result) {
            $("#page_info").empty();
            $("#page_info").append("当前第"+result.map.pageInfo.pageNum+"页,共"+result.map.pageInfo.pages+"页,共"+result.map.pageInfo.total+"条记录")
            totalRecord = result.map.pageInfo.total;
            empPageNum = result.map.pageInfo.pageNum;
        }
        //构建分页
        function build_page_num(result) {
            $("#page_nav").empty();
            var navDoc = $("<nav></nav>").attr("aria-label","Page navigation");
            var ulDoc = $("<ul></ul>").addClass("pagination");
            //首页
            var firstPageLi = $("<li></li>").append($("<a></a>").attr("href","#").append("首页"));
            //上一页
            var prePageLi = $("<li></li>").append($("<a></a>").attr("href","#").attr("aria-label","Previous").append($("<span></span>").attr("aria-hidden","true").append("&laquo;")));

            if (result.map.pageInfo.hasPreviousPage == false){
                firstPageLi.addClass("disabled");
                prePageLi.addClass("disabled");
            } else{
                firstPageLi.click(function () {
                    emp_ajax(1);
                });
                prePageLi.click(function () {
                    emp_ajax(result.map.pageInfo.pageNum - 1);
                });
            }
            ulDoc.append(firstPageLi).append(prePageLi);
            //每一页
            $.each(result.map.pageInfo.navigatepageNums,function (index,item) {
                var numLi = $("<li></li>").append($("<a></a>").attr("href","#").append(item));
                if (item == result.map.pageInfo.pageNum) {
                    numLi.addClass("active");
                }
                numLi.click(function () {
                    emp_ajax(item);
                });
                ulDoc.append(numLi);
            });
            //下一页
            var nextPageLi = $("<li></li>").append($("<a></a>").attr("href","#").attr("aria-label","Next").append($("<span></span>").attr("aria-hidden","true").append("&raquo;")));
            //末页
            var finalPageLi = $("<li></li>").append($("<a></a>").attr("href","#").append("末页"));
            if (result.map.pageInfo.hasNextPage == false){
                nextPageLi.addClass("disabled");
                finalPageLi.addClass("disabled");
            } else{
                finalPageLi.click(function () {
                    emp_ajax(result.map.pageInfo.pages);
                });
                nextPageLi.click(function () {
                    emp_ajax(result.map.pageInfo.pageNum + 1);
                });
            }

            ulDoc.append(nextPageLi).append(finalPageLi);
            navDoc.append(ulDoc);
            navDoc.appendTo($("#page_nav"));
        }
        //打开新增员工的模态框
        function open_emp_modal() {
            $("#emp_add_btn").click(function () {
                //重置表单
                $("#emp_form")[0].reset();
                //重置样式
                $("#emp_form").find("*").removeClass("has-error has-success");
                $("#emp_form").find(".help-block").text("");
                //获取部门信息
                getDeparts($("#emp_add_modal_departs"));
                //打开新增员工的模态框
                $("#emp_add_modal").modal({
                    backdrop:"static"
                })
            });
        }
        //获取部门信息
        getDeparts=function (ele) {
            ele.empty();
            $.ajax({
                url:"departs",
                type:"POST",
                success:function (result) {
                    $.each(result.map.departs,function (index,depart) {
                       var optionEle = $("<option></option>").append(depart.dName).attr("value",depart.id);
                       optionEle.appendTo(ele);
                    });
                }
            });
        };
        //校验用户名数据
        function checkAddEmpName(){
            //校验用户名
            var nameValue = $("#inputName").val();
            var regName = /^([a-zA-Z0-9_-]{3,16})|([\u2E80-\u9FFF]{1,4})$/g;
            if (!regName.test(nameValue)){//不正确
                emp_span_has("#inputName","error","用户名请使用3-16个字母,数字,下划线组成或者1-4个字符中文");
                return false;
            } //正确
                emp_span_has("#inputName","success","");
            return true;
        }
        //校验邮箱数据
        function checkAddEmpEmail(){
            //校验邮箱
            var emailValue = $("#inputEmail").val();
            var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/g;
            if (!regEmail.test(emailValue)){//不正确
                emp_span_has("#inputEmail","error","邮箱格式错误");
                return false;
            }//正确
                emp_span_has("#inputEmail","success","");
            return true;
        }
        //校验数据时的样式
        function emp_span_has(Ele,status,msg){
            $(Ele).parent().removeClass("has-error has-success");
            $(Ele).next("span").text("");
            if ("success"==status){
                $(Ele).parent().addClass("has-success");
                $(Ele).next("span").text(msg);
            }
            if ("error"==status){
                $(Ele).parent().addClass("has-error");
                $(Ele).next("span").text(msg);
            }
        }
        //检查员工
        function checkUser(){
            $.ajax({
                url:"checkUser",
                type:"POST",
                data:"name="+$("#inputName").val(),
                success:function (result) {
                    if ("100"==result.code){
                        emp_span_has($("#inputName"),"error","此用户已存在");
                        $("#save_emp_btn").attr("emp_btn_flag","error");
                    }
                    if ("200"==result.code) {
                        emp_span_has($("#inputName"),"success","");
                        $("#save_emp_btn").attr("emp_btn_flag","success");
                    }
                }
            });
        }
        //新增员工
        saveEmp = function() {
            //实时校验数据
            $("#inputName").keyup(function () {
                if (!checkAddEmpName()){
                    return false;
                }
            });
            $("#inputEmail").keyup(function () {
                if (!checkAddEmpEmail()){
                    return false;
                }
            });
            //检查此用户是否可用
            $("#inputName").change(function () {
                if (checkAddEmpName()){
                    checkUser();
                }
            });

            $("#save_emp_btn").click(function () {
                //校验数据
                if (checkAddEmpName()!=true||checkAddEmpEmail()!=true) {
                    return false;
                }
                //自定义属性,判断是否有此用户
                if ("error"==$("#save_emp_btn").attr("emp_btn_flag")){
                    emp_span_has($("#inputName"),"error","此用户已存在");
                    return false;
                }
                $.ajax({
                    url: "emp",
                    type: "POST",
                    data: $("#emp_add_modal form").serialize(),
                    success: function (result) {
                        //1.判断是否添加成功
                        if (result.code == 200) {
                            // alert("添加成功!");
                            //2.关闭模态框
                            $("#emp_add_modal").modal('hide');
                            //3.再次发送ajax请求到最后一页显示新员工
                            emp_ajax(totalRecord);
                        } else {
                            if (undefined != result.map.checkMsg.name){
                                emp_span_has($("#inputName"),"error",result.map.checkMsg.name);
                            }
                            if (undefined != result.map.checkMsg.email){
                                emp_span_has("#inputEmail","error",result.map.checkMsg.email);
                            }
                        }
                    }
                });
            });
        };
        //修改员工
        //打开修改员工的模态框
        $(document).on("click",".update_emp_btn",function () {
            //1.获取部门
            getDeparts($("#emp_update_modal_departs"));
            //2.打开模态框
            $("#emp_update_modal").modal({
                backdrop:"static"
            });
            //3.获取当前员工信息
            getEmp($(this).attr("emp-id"));
            //将员工id传给"更新"按钮
            $("#update_emp_btn").attr("emp-id",$(this).attr("emp-id"));
        });

        /**
         * 查询员工
         * @param id
         */
        function getEmp(id) {
            $.ajax({
                url:"emp/"+id,
                type:"GET",
                success:function (result) {
                    //员工对象
                    var empObj = result.map.emp;
                    //姓名
                    $("#update_emp_name").text(empObj.name);
                    //性别
                    $("#emp_update_modal input[name='gender']").val([empObj.gender]);
                    //邮箱
                    $("#updateinputEmail").val(empObj.email);
                    //部门
                    $("#emp_update_modal_departs").val([empObj.dId]);
                }
            });
        }
        //点击"更新"按钮,提交数据
        function updateEmp() {
            $("#update_emp_btn").click(function () {
                //1.校验数据
                //校验邮箱
                var emailValue = $("#updateinputEmail").val();
                var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/g;
                if (!regEmail.test(emailValue)){//不正确
                    emp_span_has("#updateinputEmail","error","邮箱格式错误");
                    return false;
                }//正确
                emp_span_has("#updateinputEmail","success","");
                //2.发送ajax请求
                // $.ajax({//第一种方式
                //     url:"emp/"+$(this).attr("emp-id"),
                //     type:"POST",
                //     data:$("#emp_update_modal form").serialize()+"&_method=PUT",
                //     success:function (result) {
                //         if (result.code==200){//更新成功
                //             //1.关闭模态框
                //             $("#emp_update_modal").modal('hide');
                //             //2.发送ajax到当前员工页
                //             emp_ajax(empPageNum);
                //         }
                //     }
                // });
                $.ajax({//第二种方式
                        url:"emp/"+$(this).attr("emp-id"),
                        type:"PUT",
                        data:$("#emp_update_modal form").serialize(),
                        success:function (result) {
                            if (result.code==200){//更新成功
                                //1.关闭模态框
                                $("#emp_update_modal").modal('hide');
                                //2.发送ajax到当前员工页
                                emp_ajax(empPageNum);
                            }
                        }
                    });
            });
        }
        //单个删除
        $(document).on("click",".delete_emp_btn",function () {
            var empName = $(this).parent().parent().find("td:eq(2)").text();
            if (confirm("确定删除["+empName+"]吗?")){
                //发送ajax请求,删除员工
                $.ajax({
                    url:"emp/"+$(this).attr("del-id"),
                    type:"POST",
                    data:"_method=DELETE",
                    success:function (result) {
                        if (result.code==200){
                            emp_ajax(empPageNum);
                        }
                    }
                });
            }
        });
        //全选/全不选
        $(document).on("click","#checkEmpsAll",function () {
            $(".checkEmpItem").prop("checked",$(this).prop("checked"));
        });
        //全选/全不选细节处理
        $(document).on("click",".checkEmpItem",function () {
            var flag = $(".checkEmpItem:checked").length==pageSize;
            $("#checkEmpsAll").prop("checked",flag);

        });
        //批量删除
        $(document).on("click","#del_emp_all",function () {
            var ids="";
            var empNames = "";
            $.each($(".checkEmpItem:checked"),function () {
                ids += $(this).parent().parent().find("td:eq(1)").text()+"-";
                empNames += $(this).parent().parent().find("td:eq(2)").text()+",";
            });
            ids = ids.substring(0,ids.length-1);
            empNames = empNames.substring(0,empNames.length-1);
            if (confirm("确定要删除["+empNames+"]吗?")) {
                $.ajax({
                    url: "emp/" + ids,
                    type: "POST",
                    data: "_method=DELETE",
                    success: function (result) {
                        if (result.code == 200) {
                            emp_ajax(empPageNum);
                            if ($("#checkEmpsAll").prop("checked")) {
                                $("#checkEmpsAll").prop("checked", false);
                            }
                        }
                    }
                });
            }
        });
    </script>
</head>
<body>
<%--修改员工的模态框--%>
<!-- Modal -->
<div class="modal fade" id="emp_update_modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">修改员工</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" id="emp_update_form">
                    <div class="form-group">
                        <label for="inputName" class="col-sm-2 control-label">姓名</label>
                        <div class="col-sm-10">
                            <p class="form-control-static" id="update_emp_name"></p>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">性别</label>
                        <div class="col-sm-4">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="updateinlineRadio1" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="updateinlineRadio2" value="F"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="inputEmail" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10">
                            <input type="email" class="form-control" name="email" id="updateinputEmail" placeholder="email">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">部门</label>
                        <div class="col-sm-4">
                            <select class="form-control" id="emp_update_modal_departs" name="dId"></select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="update_emp_btn">更新</button>
            </div>
        </div>
    </div>
</div>

<div class="container-fluid">
    <%--    标题--%>
    <div class="row">
        <div class="col-md-4">
            <h2 class="text-center">SSM-CRUD练习</h2>
        </div>
    </div>
    <%--    新增,删除--%>
    <div class="row">
        <div class="col-md-4 col-md-offset-8">
            <button type="button" class="btn btn-primary" id="emp_add_btn">
                <span class="glyphicon glyphicon-menu-hamburger" aria-hidden="true"></span>
                新增
            </button>
            <button class="btn btn-danger" id="del_emp_all">
                <span class="glyphicon glyphicon-trash" aria-hidden="true"></span>
                删除
            </button>
        </div>
    </div>
    <%--    员工表格--%>
    <div class="row">
        <div class="col-md-12">
            <table class="table table-hover text-center" id="emps_table">
                <thead>
                    <tr>
                        <th class="text-center">
                            <input type="checkbox" id="checkEmpsAll">
                        </th>
                        <th class="text-center">ID</th>
                        <th class="text-center">姓名</th>
                        <th class="text-center">性别</th>
                        <th class="text-center">邮箱</th>
                        <th class="text-center">部门</th>
                        <th class="text-center">操作</th>
                    </tr>
                </thead>
                <tbody></tbody>
            </table>
        </div>
    </div>
    <%--    分页--%>
    <div class="row">
        <%--        记录数--%>
        <div class="col-md-6" id="page_info"></div>
        <%--    页码条目--%>
        <div class="col-md-6" id="page_nav"></div>
    </div>
</div>
<%--新增员工的模态框--%>
<!-- Modal -->
<div class="modal fade" id="emp_add_modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">新增员工</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" id="emp_form">
                    <div class="form-group">
                        <label for="inputName" class="col-sm-2 control-label">姓名</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" name="name" id="inputName" placeholder="name">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">性别</label>
                        <div class="col-sm-4">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="inlineRadio1" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="inlineRadio2" value="F"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="inputEmail" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10">
                            <input type="email" class="form-control" name="email" id="inputEmail" placeholder="email">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">部门</label>
                        <div class="col-sm-4">
                            <select class="form-control" id="emp_add_modal_departs" name="dId"></select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="save_emp_btn">保存</button>
            </div>
        </div>
    </div>
</div>
</body>
</html>
