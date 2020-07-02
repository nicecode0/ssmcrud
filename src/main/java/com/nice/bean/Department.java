package com.nice.bean;

public class Department {
    private Integer id;

    private String dName;

    public Department(Integer id, String dName) {
        this.id = id;
        this.dName = dName;
    }

    public Department() {
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getdName() {
        return dName;
    }

    public void setdName(String dName) {
        this.dName = dName == null ? null : dName.trim();
    }

    @Override
    public String toString() {
        return "Department{" +
                "id=" + id +
                ", dName='" + dName + '\'' +
                '}';
    }
}
