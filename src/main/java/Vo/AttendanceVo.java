package Vo;

import java.sql.Date;
import java.sql.Timestamp;

public class AttendanceVo {

    private int attendance_id;
    private String student_id;
    private String course_id;
    private String course_name;
    private Date class_date;
    private String status;
    private String remark;
    private Timestamp check_time;
    private Timestamp created_at;
    private Timestamp updated_at;

    public int getAttendance_id() {
        return attendance_id;
    }

    public void setAttendance_id(int attendance_id) {
        this.attendance_id = attendance_id;
    }

    public String getStudent_id() {
        return student_id;
    }

    public void setStudent_id(String student_id) {
        this.student_id = student_id;
    }

    public String getCourse_id() {
        return course_id;
    }

    public void setCourse_id(String course_id) {
        this.course_id = course_id;
    }

    public String getCourse_name() {
        return course_name;
    }

    public void setCourse_name(String course_name) {
        this.course_name = course_name;
    }

    public Date getClass_date() {
        return class_date;
    }

    public void setClass_date(Date class_date) {
        this.class_date = class_date;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public Timestamp getCheck_time() {
        return check_time;
    }

    public void setCheck_time(Timestamp check_time) {
        this.check_time = check_time;
    }

    public Timestamp getCreated_at() {
        return created_at;
    }

    public void setCreated_at(Timestamp created_at) {
        this.created_at = created_at;
    }

    public Timestamp getUpdated_at() {
        return updated_at;
    }

    public void setUpdated_at(Timestamp updated_at) {
        this.updated_at = updated_at;
    }
}