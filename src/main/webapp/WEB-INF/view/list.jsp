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
</head>
<body>
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
            <button class="btn btn-primary">
                <span class="glyphicon glyphicon-menu-hamburger" aria-hidden="true"></span>
                新增
            </button>
            <button class="btn btn-danger">
                <span class="glyphicon glyphicon-trash" aria-hidden="true"></span>
                删除
            </button>
        </div>
    </div>
<%--    员工表格--%>
    <div class="row">
        <div class="col-md-12">
            <table class="table table-hover text-center">
                <tr>
                    <th class="text-center">ID</th>
                    <th class="text-center">姓名</th>
                    <th class="text-center">性别</th>
                    <th class="text-center">邮箱</th>
                    <th class="text-center">部门</th>
                    <th class="text-center">操作</th>
                </tr>
                <c:forEach items="${pageInfo.list}" var="emp">
                    <tr>
                        <td>${emp.id}</td>
                        <td>${emp.name}</td>
                        <td>${emp.gender=="M"?"男":"女"}</td>
                        <td>${emp.email}</td>
                        <td>${emp.department.dName}</td>
                        <td>
                            <button class="btn btn-info btn-sm">
                                <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
                                编辑
                            </button>
                            <button class="btn btn-warning btn-sm">
                                <span class="glyphicon glyphicon-trash" aria-hidden="true"></span>
                                删除
                            </button>
                        </td>
                    </tr>
                </c:forEach>
            </table>
        </div>
    </div>
<%--    分页--%>
    <div class="row">
<%--        记录数--%>
        <div class="col-md-6">
            当前第${pageInfo.pageNum}页,共${pageInfo.pages}页,共${pageInfo.total}条记录
        </div>
<%--    页码条目--%>
        <div class="col-md-6">
            <nav aria-label="Page navigation">
                <ul class="pagination">

                    <li><a href="emps?pa=1">首页</a></li>

                    <c:choose>
                        <c:when test="${pageInfo.pageNum==1}">
                        </c:when>
                        <c:otherwise>
                            <li>
                                <a href="emps?pa=${pageInfo.pageNum-1}" aria-label="Previous">
                                    <span aria-hidden="true">&laquo;</span>
                                </a>
                            </li>
                        </c:otherwise>
                    </c:choose>

                    <c:forEach items="${pageInfo.navigatepageNums}" var="pn">
                        <c:choose>
                            <c:when test="${pageInfo.pageNum==pn}">
                                <li class="active"><a href="emps?pa=${pn}">${pn}</a></li>
                            </c:when>
                            <c:otherwise>
                                <li><a href="emps?pa=${pn}">${pn}</a></li>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>

                    <c:choose>
                        <c:when test="${pageInfo.pageNum==pageInfo.pages}">
                        </c:when>
                        <c:otherwise>
                            <li>
                                <a href="emps?pa=${pageInfo.pageNum+1}" aria-label="Next">
                                    <span aria-hidden="true">&raquo;</span>
                                </a>
                            </li>
                        </c:otherwise>
                    </c:choose>

                    <li><a href="emps?pa=${pageInfo.pages}">末尾</a></li>
                </ul>
            </nav>
        </div>
    </div>
</div>
</body>
</html>
