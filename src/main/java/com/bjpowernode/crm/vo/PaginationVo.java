package com.bjpowernode.crm.vo;

import org.apache.poi.ss.formula.functions.T;

import java.io.Serializable;
import java.util.List;

public class PaginationVo<T> implements Serializable {

    private boolean success;
    private String msg;
    private List<T> list;
    private Long total;

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public List<T> getList() {
        return list;
    }

    public void setList(List<T> list) {
        this.list = list;
    }

    public Long getTotal() {
        return total;
    }

    public void setTotal(Long total) {
        this.total = total;
    }

    @Override
    public String toString() {
        return "PaginationVo{" +
                "success=" + success +
                ", msg='" + msg + '\'' +
                ", list=" + list +
                ", total=" + total +
                '}';
    }
}
