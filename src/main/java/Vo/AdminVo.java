package Vo;

import java.sql.Date;

//회원 한사람의 저보를 DB로 부터 조회해서 저장할 변수가 있는 VO클래스
//또는
//입력한 새 회원정보를 DB에 INSERT추가 하기 전 임시로 저장할 변수가 있는 VO클래스 
public class AdminVo {

	//user테이블
		private String user_id;  //교수아이디(사번)
		private String user_pw;   //교수비밀번호(전화번호)
		private String user_name;   //교수이름
		private Date birthDate;  //생년월일
		private String gender;  //성별
		private String address ;  //주소
		private String phone;    //전화번호
		private String email;  //이메일
		private String role; // "학생","교수","관리자" 중 하나

		//admin_info
		private String admin_id;   // 관리자번호
		private String department;  // 부서
		private int access_level;  // 관리자권한
		
		
		
		//기본생성자
		public AdminVo() {}
		
		
		//생성자
		public AdminVo(String user_id, String user_pw, String user_name, Date birthDate, String gender, String address,
				String phone, String email, String role, String admin_id, String department, int access_level) {
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
			this.admin_id = admin_id;
			this.department = department;
			this.access_level = access_level;
		}


		
		public AdminVo(String user_id, String user_pw, String user_name, Date birthDate, String gender, String address,
				String phone, String email, String admin_id, String department, int access_level) {
			super();
			this.user_id = user_id;
			this.user_pw = user_pw;
			this.user_name = user_name;
			this.birthDate = birthDate;
			this.gender = gender;
			this.address = address;
			this.phone = phone;
			this.email = email;
			this.admin_id = admin_id;
			this.department = department;
			this.access_level = access_level;
		}





		// getter, setter 메소드
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




		public String getAdmin_id() {
			return admin_id;
		}




		public void setAdmin_id(String admin_id) {
			this.admin_id = admin_id;
		}




		public String getDepartment() {
			return department;
		}




		public void setDepartment(String department) {
			this.department = department;
		}




		public int getAccess_level() {
			return access_level;
		}




		public void setAccess_level(int access_level) {
			this.access_level = access_level;
		}
		
		
		
	
		
		
	
}










