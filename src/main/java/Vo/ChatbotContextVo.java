package Vo;

import java.util.ArrayList;

public class ChatbotContextVo {

    private String loginId;
    private String role;
    private String studentId;
    private String professorId;
    private String userQuestion;
    private String intent;

    private StudentVo student;
    private ArrayList<EnrollmentVo> enrollmentList;
    private ArrayList<StudentVo> gradeList;
    private ArrayList<BoardVo> noticeList;
    private ArrayList<AttendanceVo> attendanceList;
    private ArrayList<CourseVo> professorCourseList;

    private String attendanceSummary;

    public String getLoginId() {
        return loginId;
    }

    public void setLoginId(String loginId) {
        this.loginId = loginId;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getStudentId() {
        return studentId;
    }

    public void setStudentId(String studentId) {
        this.studentId = studentId;
    }

    public String getProfessorId() {
        return professorId;
    }

    public void setProfessorId(String professorId) {
        this.professorId = professorId;
    }

    public String getUserQuestion() {
        return userQuestion;
    }

    public void setUserQuestion(String userQuestion) {
        this.userQuestion = userQuestion;
    }

    public String getIntent() {
        return intent;
    }

    public void setIntent(String intent) {
        this.intent = intent;
    }

    public StudentVo getStudent() {
        return student;
    }

    public void setStudent(StudentVo student) {
        this.student = student;
    }

    public ArrayList<EnrollmentVo> getEnrollmentList() {
        return enrollmentList;
    }

    public void setEnrollmentList(ArrayList<EnrollmentVo> enrollmentList) {
        this.enrollmentList = enrollmentList;
    }

    public ArrayList<StudentVo> getGradeList() {
        return gradeList;
    }

    public void setGradeList(ArrayList<StudentVo> gradeList) {
        this.gradeList = gradeList;
    }

    public ArrayList<BoardVo> getNoticeList() {
        return noticeList;
    }

    public void setNoticeList(ArrayList<BoardVo> noticeList) {
        this.noticeList = noticeList;
    }

    public ArrayList<AttendanceVo> getAttendanceList() {
        return attendanceList;
    }

    public void setAttendanceList(ArrayList<AttendanceVo> attendanceList) {
        this.attendanceList = attendanceList;
    }

    public ArrayList<CourseVo> getProfessorCourseList() {
        return professorCourseList;
    }

    public void setProfessorCourseList(ArrayList<CourseVo> professorCourseList) {
        this.professorCourseList = professorCourseList;
    }

    public String getAttendanceSummary() {
        return attendanceSummary;
    }

    public void setAttendanceSummary(String attendanceSummary) {
        this.attendanceSummary = attendanceSummary;
    }
}