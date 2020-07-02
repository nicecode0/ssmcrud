package com.nice.bean;

import javax.validation.constraints.Pattern;

public class Employee {
    private Integer id;

    @Pattern(regexp = "^([a-zA-Z0-9_-]{3,16})|([\\u2E80-\\u9FFF]{1,4})$"
            ,message = "用户名请使用3-16个字母,数字,下划线组成或者1-4个字符中文")
    private String name;

    private String gender;

    @Pattern(regexp = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
            ,message = "邮箱格式错误")
    private String email;

    private Integer dId;

    private Department department;

    public Employee() {
    }

    public Employee(Integer id, String name, String gender, String email, Integer dId) {
        this.id = id;
        this.name = name;
        this.gender = gender;
        this.email = email;
        this.dId = dId;
    }

    public Department getDepartment() {
        return department;
    }

    public void setDepartment(Department department) {
        this.department = department;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name == null ? null : name.trim();
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender == null ? null : gender.trim();
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email == null ? null : email.trim();
    }

    public Integer getdId() {
        return dId;
    }

    public void setdId(Integer dId) {
        this.dId = dId;
    }

    @Override
    public String toString() {
        return "Employee{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", gender='" + gender + '\'' +
                ", email='" + email + '\'' +
                ", dId=" + dId +
                ", department=" + department +
                '}';
    }
}
