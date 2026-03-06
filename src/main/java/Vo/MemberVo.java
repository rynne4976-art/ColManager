package Vo;

import java.sql.Date;

//회원 한 사람의 정보를 DB로 부터 조회해서 저장할 변수가 있는 VO클래스
//또는
//입력한 새 회원정보를 DB에 INSERT 추가하기 전 임시로 저장할 변수가 있는 VO클래스

/*
 	user_id VARCHAR(50) NOT NULL PRIMARY KEY, -- 사용자 ID (학생, 교수, 관리자 구분)
    user_pw VARCHAR(50) NOT NULL, -- 비밀번호
    user_name VARCHAR(50) NOT NULL, -- 이름
    birthDate DATE NOT NULL, -- 생년월일
    gender VARCHAR(20) NOT NULL, -- 성별
    address VARCHAR(100) NOT NULL, -- 주소
    phone VARCHAR(50) NOT NULL, -- 전화번호
    email VARCHAR(100) NOT NULL, -- 이메일
    role ENUM('학생', '교수', '관리자') NOT NULL -- 역할 (학생, 교수, 관리자)
    
 */


public class MemberVo {
	private String user_id, user_pw, user_name;
	private Date birthDate;
	private String gender, address, phone, email, role;
	
	
	public MemberVo() {}


	public MemberVo(String user_id, String user_pw, String user_name, String gender, String address, String phone,
			String email, String role) {
		super();
		this.user_id = user_id;
		this.user_pw = user_pw;
		this.user_name = user_name;
		this.gender = gender;
		this.address = address;
		this.phone = phone;
		this.email = email;
		this.role = role;
	}


	public MemberVo(String user_id, String user_pw, String user_name, Date birthDate, String gender, String address,
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

	
}
