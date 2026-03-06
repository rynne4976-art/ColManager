package Vo;

import java.sql.Date;

public class StudentVo {
   
	// user 테이블 관련 필드
    private String user_id, user_pw, user_name, gender, address, phone, email, role;
    private Date birthDate;

   
    // student_info 테이블 관련 필드
    private String student_id, majorcode, status;
    private int grade;
    private Date admission_date;

   
    // course_evaluation 테이블 관련 필드
    private int evaluationId;    
    private String courseId;
    private int rating;          
    private String comments;   
    
    // course 테이블 관련 필드
    private String course_name;   // 강의 이름
    private String professor_id;  // 담당 교수 ID
    private String room_id;       // 강의실 ID
    
    private int midtest_score, finaltest_score, assignment_score; // 중간고사, 기말고사, 과제
    private Float score; // 성적 총점 
    
    private CourseVo Course; // CourseVo 객체 포함


	public StudentVo(String user_id, String user_pw, String user_name, Date birthDate, String gender, String address,
			String phone, String email, String role) {
		super();
		this.user_id = user_id;
		this.user_pw = user_pw;
		this.user_name = user_name;
		this.birthDate = birthDate;
		this.gender = gender;
		this.address = address;
		this.phone = phone;
		this.email = email;
		this.role = role;
	}
	
	public StudentVo(CourseVo course) {
		this.Course = course;
	}

    // 기본 생성자
    public StudentVo() {}

    // 생성자: user 테이블 필드
    public StudentVo(String user_id, String user_pw, String user_name, String gender, String address, String phone,
                     String email, String role) {
        this.user_id = user_id;
        this.user_pw = user_pw;
        this.user_name = user_name;
        this.gender = gender;
        this.address = address;
        this.phone = phone;
        this.email = email;
        this.role = role;
    }

    // 생성자: user + student_info 테이블 필드
    public StudentVo(String user_id, String user_pw, String user_name, Date birthDate, String gender, String address,
                     String phone, String email, String role, String student_id, String majorcode, int grade,
                     Date admission_date, String status) {
        this(user_id, user_pw, user_name, gender, address, phone, email, role);
        this.birthDate = birthDate;
        this.student_id = student_id;
        this.majorcode = majorcode;
        this.grade = grade;
        this.admission_date = admission_date;
        this.status = status;
    }

    // 생성자: 강의 평가 필드
    public StudentVo(int evaluationId, String student_id, String courseId, int rating, String comments) {
        this.evaluationId = evaluationId;
        this.student_id = student_id;
        this.courseId = courseId;
        this.rating = rating;
        this.comments = comments;
    }
    
    // 생성자: course 테이블 필드 포함
    public StudentVo(String courseId, String course_name, String professor_id, String majorcode, String room_id) {
        this.courseId = courseId;
        this.course_name = course_name;
        this.professor_id = professor_id;
        this.majorcode = majorcode;
        this.room_id = room_id;
    }

    // Getter & Setter
    public String getUser_id() {
        return user_id;
    }

    public void setUser_id(String user_id) {
        this.user_id = user_id;
    }

    public String getUser_pw() {
        return user_pw;
    }

    public void setUser_pw(String user_pw) {
        this.user_pw = user_pw;
    }

    public String getUser_name() {
        return user_name;
    }

    public void setUser_name(String user_name) {
        this.user_name = user_name;
    }

    public Date getBirthDate() {
        return birthDate;
    }

    public void setBirthDate(Date birthDate) {
        this.birthDate = birthDate;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getStudent_id() {
        return student_id;
    }

    public void setStudent_id(String student_id) {
        this.student_id = student_id;
    }

    public String getMajorcode() {
        return majorcode;
    }

    public void setMajorcode(String majorcode) {
        this.majorcode = majorcode;
    }

    public int getGrade() {
        return grade;
    }

    public void setGrade(int grade) {
        this.grade = grade;
    }

    public Date getAdmission_date() {
        return admission_date;
    }

    public void setAdmission_date(Date admission_date) {
        this.admission_date = admission_date;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getEvaluationId() {
        return evaluationId;
    }

    public void setEvaluationId(int evaluationId) {
        this.evaluationId = evaluationId;
    }

    public String getCourseId() {
        return courseId;
    }

    public void setCourseId(String courseId) {
        this.courseId = courseId;
    }

    
    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getComments() {
        return comments;
    }

    public void setComments(String comments) {
        this.comments = comments;
    }
    
    public String getCourse_name() {
        return course_name;
    }

    public void setCourse_name(String course_name) {
        this.course_name = course_name;
    }

    public String getProfessor_id() {
        return professor_id;
    }

    public void setProfessor_id(String professor_id) {
        this.professor_id = professor_id;
    }

    public String getRoom_id() {
        return room_id;
    }

    public void setRoom_id(String room_id) {
        this.room_id = room_id;
    }

	public CourseVo getCourse() {
		return Course;
	}


	public void setCourse(CourseVo course) {
		Course = course;
	}


	public Float getScore() {
		return score;
	}


	public void setScore(Float score) {
		this.score = score;
	}


	public int getMidtest_score() {
		return midtest_score;
	}


	public void setMidtest_score(int midtest_score) {
		this.midtest_score = midtest_score;
	}


	public int getFinaltest_score() {
		return finaltest_score;
	}


	public void setFinaltest_score(int finaltest_score) {
		this.finaltest_score = finaltest_score;
	}


	public int getAssignment_score() {
		return assignment_score;
	}


	public void setAssignment_score(int assignment_score) {
		this.assignment_score = assignment_score;
	}

	
	 // toString 메서드
    @Override
    public String toString() {
        return "StudentVo{" +
                "user_id='" + user_id + '\'' +
                ", user_pw='" + user_pw + '\'' +
                ", user_name='" + user_name + '\'' +
                ", birthDate=" + birthDate +
                ", gender='" + gender + '\'' +
                ", address='" + address + '\'' +
                ", phone='" + phone + '\'' +
                ", email='" + email + '\'' +
                ", role='" + role + '\'' +
                ", student_id='" + student_id + '\'' +
                ", majorcode='" + majorcode + '\'' +
                ", grade=" + grade +
                ", admission_date=" + admission_date +
                ", status='" + status + '\'' +
                ", evaluationId=" + evaluationId +
                ", courseId='" + courseId + '\'' +
                ", rating=" + rating +
                ", comments='" + comments + '\'' +
                ", course_name='" + course_name + '\'' +
                ", professor_id='" + professor_id + '\'' +
                ", room_id='" + room_id + '\'' +
                '}';
    }

    // 이메일 유효성 검사 메서드
    public boolean isEmailValid() {
        return email != null && email.matches("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    }

    // 전화번호 유효성 검사 메서드
    public boolean isPhoneValid() {
        return phone != null && phone.matches("^\\+?[0-9\\-\\s]{7,15}$");
    }

    // 객체 유효성 검사 메서드
    public boolean isValid() {
        return user_id != null && !user_id.isEmpty() &&
               user_pw != null && !user_pw.isEmpty() &&
               user_name != null && !user_name.isEmpty() &&
               birthDate != null &&
               email != null && isEmailValid() &&
               phone != null && isPhoneValid() &&
               role != null && !role.isEmpty();
    }
}
