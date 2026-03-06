package Service;

import java.sql.Date;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import Dao.StudentDAO;
import Vo.MemberVo;
import Vo.StudentVo;

// 부장
// - 단위 기능 별로 메소드를 만들어서 그 기능을 처리하는 클래스
public class StudentService {

	// StudentDAO 객체의 주소를 저장할 참조변수
	StudentDAO studentDao;

	// 기본 생성자 - 위 studentDao변수에 new StudentDAO() 객체를 만들어서 저장하는 역할
	public StudentService() {
		studentDao = new StudentDAO();
	}

	
	// ===================================================================================
	// 전체 학생 목록 조회 메서드
	public List<StudentVo> getAllStudents() {
		return studentDao.getAllStudents();
	}

	// ===================================================================================
	// 특정 학생 정보 조회 메서드
	public StudentVo getStudentById(String userId) {
		return studentDao.getStudentById(userId);
	}

	// ===================================================================================
	// 학생 등록 메서드
	public int registerStudent(HttpServletRequest request) {
		// user 테이블 관련 필드
		String user_id = request.getParameter("user_id");
		String user_pw = request.getParameter("user_pw");
		String user_name = request.getParameter("user_name");
		Date birthDate = Date.valueOf(request.getParameter("birthDate"));
		String gender = request.getParameter("gender");
		String address = request.getParameter("address");
		String phone = request.getParameter("phone");
		String email = request.getParameter("email");
		String role = request.getParameter("role");

		// student_info 테이블 관련 필드
		String student_id = request.getParameter("student_id");
		String majorcode = request.getParameter("majorcode");
		int grade = Integer.parseInt(request.getParameter("grade"));
		Date admission_date = Date.valueOf(request.getParameter("admission_date"));
		String status = request.getParameter("status");

		// VO 객체 생성 및 설정
		StudentVo student = new StudentVo(user_id, user_pw, user_name, birthDate, gender, address, phone, email, role,
				student_id, majorcode, grade, admission_date, status);

		// DAO 메서드 호출하여 데이터 삽입
		return studentDao.insertStudent(student);
	}

	// ===================================================================================
	// 학생 정보 수정 메서드
	public boolean updateStudent(HttpServletRequest request) {
		// request에서 수정할 필드 값들을 가져옴
		String userId = request.getParameter("user_id");
		String userPw = request.getParameter("user_pw");
		String userName = request.getParameter("user_name");
		Date birthDate = Date.valueOf(request.getParameter("birthDate"));
		String gender = request.getParameter("gender");
		String address = request.getParameter("address");
		String phone = request.getParameter("phone");
		String email = request.getParameter("email");
		String role = request.getParameter("role");
		String studentId = request.getParameter("student_id");
		String majorcode = request.getParameter("majorcode");
		int grade = Integer.parseInt(request.getParameter("grade"));
		Date admissionDate = Date.valueOf(request.getParameter("admission_date"));
		String status = request.getParameter("status");

		// VO 객체에 값 설정
		StudentVo student = new StudentVo(userId, userPw, userName, birthDate, gender, address, phone, email, role,
				studentId, majorcode, grade, admissionDate, status);

		// DAO 메서드 호출하여 업데이트 수행
		return studentDao.updateStudent(student);
	}

	// ===================================================================================
	// 학생 정보 삭제 메서드
	public boolean deleteStudent(String studentId) {
		return studentDao.deleteStudent(studentId);
	}
	
	
	//============================================================================
		// 학생이 본인 정보를 업데이트를 하는 메서드
		
		public boolean updateMyInfo(HttpServletRequest request) {
		    HttpSession session = request.getSession();
		    String sessionUserId = (String) session.getAttribute("id"); // 세션에서 사용자 ID 가져오기
		    String role = (String) session.getAttribute("role"); // 세션에서 사용자 역할 가져오기

		    // 로그인된 학생 본인만 수정할 수 있도록 제한
		    String userId = request.getParameter("user_id");
		    if (!"학생".equals(role) || !sessionUserId.equals(userId)) {
		        // 권한이 없거나 다른 학생의 정보를 수정하려고 할 때 false 반환
		        return false;
		    }

		    // 수정할 필드 값 가져오기
		    String userPw = request.getParameter("user_pw");
		    //==
		    if (userPw == null || userPw.trim().isEmpty()) {
		        // 비밀번호가 비어 있는 경우 false 반환
		        return false;
		    }
		    //==
		    String phone = request.getParameter("phone");
		    String email = request.getParameter("email");
		    String address = request.getParameter("address");

		    // VO 객체에 필요한 값 설정
		    MemberVo student = new MemberVo();
		    student.setUser_id(userId);
		    student.setUser_pw(userPw);
		    student.setPhone(phone);
		    student.setEmail(email);
		    student.setAddress(address);

		    // DAO 메서드를 호출하여 본인 정보 업데이트
		    return studentDao.updateStudentInfo(student);
		}
		
		  // ============================================================================
		// ===================================================================================
		// 강의 평가 등록 메서드
		public boolean insertEvaluation(HttpServletRequest request) {
		    HttpSession session = request.getSession();
		    String studentId = (String) session.getAttribute("student_id"); // 세션에서 로그인한 학생 ID 가져오기

		    try {
		        // request에서 평가 데이터 가져오기
		        String courseId = request.getParameter("course_id");
		        int rating = Integer.parseInt(request.getParameter("rating"));
		        String comments = request.getParameter("comments");

		        // VO 객체 생성 및 값 설정
		        StudentVo evaluation = new StudentVo();
		        evaluation.setStudent_id(studentId);
		        evaluation.setCourseId(courseId);
		        evaluation.setRating(rating);
		        evaluation.setComments(comments);

		        // DAO 메서드 호출하여 평가 등록
		        int result = studentDao.insertEvaluation(evaluation);
		        return result > 0; // 실행 결과가 1 이상일 경우 true 반환
		    } catch (Exception e) {
		        e.printStackTrace();
		        return false; // 오류 발생 시 false 반환
		    }
		}

		// ===================================================================================
		// 강의 평가 조회 메서드
		public List<StudentVo> getEvaluationsByStudent(String studentId) {
		    return studentDao.getEvaluationsByStudentId(studentId); // DAO에서 학생 ID를 통해 평가 조회
		}
		
		// StudentService에 추가
		public List<StudentVo> getAllCourses(String studentId) {
		    return studentDao.getAllCourses(studentId);
		}
		// StudentService에 추가
		public StudentVo getEvaluationById(int evaluationId) {
		    return studentDao.getEvaluationById(evaluationId);
		}



		// ===================================================================================
		// 강의 평가 수정 메서드
		public boolean updateEvaluation(HttpServletRequest request) {
		    try {
		        // 수정할 평가 데이터 가져오기
		        int evaluationId = Integer.parseInt(request.getParameter("evaluation_id"));
		        int rating = Integer.parseInt(request.getParameter("rating"));
		        String comments = request.getParameter("comments");

		        // VO 객체 생성 및 값 설정
		        StudentVo evaluation = new StudentVo();
		        evaluation.setEvaluationId(evaluationId);
		        evaluation.setRating(rating);
		        evaluation.setComments(comments);

		        // DAO 메서드 호출하여 평가 수정
		        return studentDao.updateEvaluation(evaluation) > 0;
		    } catch (Exception e) {
		        e.printStackTrace();
		        return false;
		    }
		}

		// ===================================================================================
		// 강의 평가 삭제 메서드
		public boolean deleteEvaluation(int evaluationId) {
		    return studentDao.deleteEvaluation(evaluationId) > 0; // DAO에서 평가 ID를 통해 삭제
		}


		


	    
	  
}