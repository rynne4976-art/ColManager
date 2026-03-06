package Vo;

import java.time.LocalDate;

public class EnrollmentVo {
	
	private int enrollmentId; // enrollment_id (기본 키)
	private StudentVo student; // student_id (외래 키)
	private CourseVo course; // course_id (외래 키)
	private LocalDate enrollmentDate; // enrollment_date (등록 날짜)
	
	// 기본 생성자
	public EnrollmentVo() { }

	// 매개변수 생성자
	public EnrollmentVo(int enrollmentId, StudentVo student, CourseVo course, LocalDate enrollmentDate) {
		super();
		this.enrollmentId = enrollmentId;
		this.student = student;
		this.course = course;
		this.enrollmentDate = enrollmentDate;
	}

	// getter, setter
	public int getEnrollmentId() {
		return enrollmentId;
	}

	public void setEnrollmentId(int enrollmentId) {
		this.enrollmentId = enrollmentId;
	}

	public StudentVo getStudent() {
		return student;
	}

	public void setStudent(StudentVo student) {
		this.student = student;
	}

	public CourseVo getCourse() {
		return course;
	}

	public void setCourse(CourseVo course) {
		this.course = course;
	}

	public LocalDate getEnrollmentDate() {
		return enrollmentDate;
	}

	public void setEnrollmentDate(LocalDate enrollmentDate) {
		this.enrollmentDate = enrollmentDate;
	}
	
	
	

}
