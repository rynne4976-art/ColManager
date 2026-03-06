package Dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import Vo.MemberVo;
import Vo.StudentVo;

//MVC 중에서 M을 얻기 위한 클래스 

//DB와 연결하여 비즈니스로직 처리하는 클래스
public class StudentDAO {

	Connection con;
	PreparedStatement pstmt;
	ResultSet rs;
	DataSource ds;
	
	
	// 커넥션 풀 얻는 생성자
	public StudentDAO() {
		try {
			Context ctx = new InitialContext();
			ds = (DataSource) ctx.lookup("java:/comp/env/jdbc/edumanager");
		} catch (Exception e) {
			System.out.println("커넥션풀 얻기 실패 : " + e);
		}

	}// 생성자 닫음

	// 자원해제(Connection, PreparedStatment, ResultSet) 기능의 메소드
	private void closeResource() {
		try {
			if (con != null) {
				con.close();
			}
			if (pstmt != null) {
				pstmt.close();
			}
			if (rs != null) {
				rs.close();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	// ==================================================================================================================
	// con = getConnection();때문에 새로운 메소드 추가함
	private Connection getConnection() throws SQLException {
		return ds.getConnection();
	}

	// ===================================================================================
	// 학생 등록
	public int insertStudent(StudentVo studentUser) {
		int result = 0;
		try {
			con = getConnection();
			String query = "INSERT INTO user (user_id, user_pw, user_name, birthDate, gender, address, phone, email, role) "
					+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, studentUser.getUser_id());
			pstmt.setString(2, studentUser.getUser_pw());
			pstmt.setString(3, studentUser.getUser_name());
			pstmt.setDate(4, studentUser.getBirthDate());
			pstmt.setString(5, studentUser.getGender());
			pstmt.setString(6, studentUser.getAddress());
			pstmt.setString(7, studentUser.getPhone());
			pstmt.setString(8, studentUser.getEmail());
			pstmt.setString(9, studentUser.getRole());
			result = pstmt.executeUpdate();

			query = "INSERT INTO student_info (student_id, user_id, majorcode, grade, admission_date, status) "
					+ "VALUES (?, ?, ?, ?, ?, ?)";
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, studentUser.getStudent_id());
			pstmt.setString(2, studentUser.getUser_id());
			pstmt.setString(3, studentUser.getMajorcode());
			pstmt.setInt(4, studentUser.getGrade());
			pstmt.setDate(5, studentUser.getAdmission_date());
			pstmt.setString(6, studentUser.getStatus());
			result = pstmt.executeUpdate();
		} catch (SQLException e) {
			System.err.println("학생등록오류: " + e.getMessage());
			e.printStackTrace();
		} finally {
			closeResource();
		}
		return result;
	}

	// =========================================================================================================
	// 전체 학생 조회
	public List<StudentVo> getAllStudents() {
		List<StudentVo> students = new ArrayList<>();
		String query = "SELECT s.student_id, u.user_id, u.user_name, s.majorcode, s.grade, s.admission_date, s.status "
				+ "FROM student_info s JOIN user u ON s.user_id = u.user_id";
		try {
			con = getConnection();
			pstmt = con.prepareStatement(query);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				StudentVo student = new StudentVo();
				student.setStudent_id(rs.getString("student_id"));
				student.setUser_id(rs.getString("user_id"));
				student.setUser_name(rs.getString("user_name"));
				student.setMajorcode(rs.getString("majorcode"));
				student.setGrade(rs.getInt("grade"));
				student.setAdmission_date(rs.getDate("admission_date"));
				student.setStatus(rs.getString("status"));
				students.add(student);
			}
		} catch (SQLException e) {
			System.err.println("전체 학생 목록 조회 중 예외 발생: " + e.getMessage());
			e.printStackTrace();
		} finally {
			closeResource();
		}
		return students;
	}

	// =========================================================================================================
	// 학생 상세 보기
	public StudentVo getStudentById(String userId) {
		StudentVo student = null;
		String query = "SELECT u.user_id, u.user_pw, u.user_name, u.birthDate, u.gender, u.address, u.phone, "
				+ "u.email, u.role, s.student_id, s.majorcode, s.grade, s.admission_date, s.status "
				+ "FROM user u JOIN student_info s ON u.user_id = s.user_id WHERE u.user_id = ?";
		try {
			con = getConnection();
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, userId);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				student = new StudentVo();
				student.setUser_id(rs.getString("user_id"));
				student.setUser_pw(rs.getString("user_pw"));
				student.setUser_name(rs.getString("user_name"));
				student.setBirthDate(rs.getDate("birthDate"));
				student.setGender(rs.getString("gender"));
				student.setAddress(rs.getString("address"));
				student.setPhone(rs.getString("phone"));
				student.setEmail(rs.getString("email"));
				student.setRole(rs.getString("role"));
				student.setStudent_id(rs.getString("student_id"));
				student.setMajorcode(rs.getString("majorcode"));
				student.setGrade(rs.getInt("grade"));
				student.setAdmission_date(rs.getDate("admission_date"));
				student.setStatus(rs.getString("status"));
			}
		} catch (SQLException e) {
			System.err.println("특정 학생 조회 중 예외 발생: " + e.getMessage());
			e.printStackTrace();
		} finally {
			closeResource();
		}
		return student;
	}

	// =========================================================================================================
	// 학생 정보 수정
	public boolean updateStudent(StudentVo student) {
		boolean isUpdated = false;
		String query = "UPDATE user u JOIN student_info s ON u.user_id = s.user_id SET "
				+ "u.user_pw = ?, u.user_name = ?, u.birthDate = ?, u.gender = ?, "
				+ "u.address = ?, u.phone = ?, u.email = ?, u.role = ?, "
				+ "s.grade = ?, s.admission_date = ?, s.status = ? " + "WHERE s.student_id = ?";
		try {
			con = getConnection();
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, student.getUser_pw());
			pstmt.setString(2, student.getUser_name());
			pstmt.setDate(3, student.getBirthDate());
			pstmt.setString(4, student.getGender());
			pstmt.setString(5, student.getAddress());
			pstmt.setString(6, student.getPhone());
			pstmt.setString(7, student.getEmail());
			pstmt.setString(8, student.getRole());
			pstmt.setInt(9, student.getGrade());
			pstmt.setDate(10, student.getAdmission_date());
			pstmt.setString(11, student.getStatus());
			pstmt.setString(12, student.getStudent_id());

			int rowsUpdated = pstmt.executeUpdate();

			System.out.println(rowsUpdated);
			isUpdated = rowsUpdated > 0;
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			closeResource();
		}
		return isUpdated;
	}

	// =========================================================================================================
	// 학생 정보 삭제
	public boolean deleteStudent(String studentId) {
		boolean isDeleted = false;
		String selectQuery = "SELECT user_id FROM student_info WHERE student_id = ?";
		String deleteStudentInfoQuery = "DELETE FROM student_info WHERE student_id = ?";
		String deleteUserQuery = "DELETE FROM user WHERE user_id = ?";

		try {
			con = getConnection();
			con.setAutoCommit(false);
			String userId = null;

			try (PreparedStatement pstmtSelect = con.prepareStatement(selectQuery)) {
				pstmtSelect.setString(1, studentId);
				ResultSet rs = pstmtSelect.executeQuery();
				if (rs.next()) {
					userId = rs.getString("user_id");
				}
			}

			if (userId != null) {
				try (PreparedStatement pstmtDeleteStudentInfo = con.prepareStatement(deleteStudentInfoQuery)) {
					pstmtDeleteStudentInfo.setString(1, studentId);
					pstmtDeleteStudentInfo.executeUpdate();
				}
				try (PreparedStatement pstmtDeleteUser = con.prepareStatement(deleteUserQuery)) {
					pstmtDeleteUser.setString(1, userId);
					pstmtDeleteUser.executeUpdate();
				}
				con.commit();
				isDeleted = true;
			}
		} catch (SQLException e) {
			System.err.println("학생 삭제 중 예외 발생: " + e.getMessage());
			e.printStackTrace();
			try {
				con.rollback();
			} catch (SQLException rollbackEx) {
				rollbackEx.printStackTrace();
			}
		} finally {
			closeResource();
		}
		return isDeleted;
	}

	// =====================================================================
	// 학생이 로그인한 후 마이페이지에서 자신의 정보를 수정하는 메서드
	public boolean updateStudentInfo(MemberVo student) {
		String sql = "UPDATE " + "user SET user_pw = ?, " + "address = ?, " + "phone = ?, " + "email = ? "
				+ "WHERE user_id = ?";
		try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
			pstmt.setString(1, student.getUser_pw());
			pstmt.setString(2, student.getAddress());
			pstmt.setString(3, student.getPhone());
			pstmt.setString(4, student.getEmail());
			pstmt.setString(5, student.getUser_id());

			int rows = pstmt.executeUpdate();
			return rows > 0;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}

	// =====================================================================
	// 강의 평가 등록
	public int insertEvaluation(StudentVo evaluation) {
	    int result = 0;
	    String query = "INSERT INTO course_evaluation (student_id, course_id, rating, comments) VALUES (?, ?, ?, ?)";
	    try {
	        con = getConnection();
	        pstmt = con.prepareStatement(query);
	        pstmt.setString(1, evaluation.getStudent_id());
	        pstmt.setString(2, evaluation.getCourseId());
	        pstmt.setInt(3, evaluation.getRating());
	        pstmt.setString(4, evaluation.getComments());
	        result = pstmt.executeUpdate();
	    } catch (SQLException e) {
	        System.err.println("강의 평가 등록 중 예외 발생: " + e.getMessage());
	        e.printStackTrace();
	    } finally {
	        closeResource();
	    }
	    return result;
	}



	// 특정 학생의 강의 평가 조회(특정 학생의 강의 평가 데이터를 데이터베이스에서 조회하여 반환)
	public List<StudentVo> getEvaluationsByStudentId(String studentId) {
	    List<StudentVo> evaluations = new ArrayList<>();
	    String query = "SELECT ce.evaluation_id, ce.course_id, c.course_name, ce.rating, ce.comments " +
	                   "FROM course_evaluation ce " +
	                   "JOIN course c ON ce.course_id = c.course_id " +
	                   "WHERE ce.student_id = ?";
	    try {
	        con = getConnection();
	        pstmt = con.prepareStatement(query);
	        pstmt.setString(1, studentId);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            StudentVo evaluation = new StudentVo();
	            evaluation.setEvaluationId(rs.getInt("evaluation_id"));
	            evaluation.setCourseId(rs.getString("course_id"));
	            evaluation.setCourse_name(rs.getString("course_name"));
	            evaluation.setRating(rs.getInt("rating"));
	            evaluation.setComments(rs.getString("comments"));
	            evaluations.add(evaluation);
	        }
	    } catch (SQLException e) {
	        System.err.println("강의 평가 조회 중 예외 발생: " + e.getMessage());
	        e.printStackTrace();
	    } finally {
	        closeResource();
	    }
	    return evaluations;
	}
	// evaluationId(강의 평가 ID)를 기반으로 강의 평가 정보를 조회하여 반환
	public StudentVo getEvaluationById(int evaluationId) {
	    StudentVo evaluation = null;
	    String query = "SELECT ce.evaluation_id, ce.course_id, c.course_name, ce.rating, ce.comments " +
	                   "FROM course_evaluation ce " +
	                   "JOIN course c ON ce.course_id = c.course_id " +
	                   "WHERE ce.evaluation_id = ?";
	    try {
	        con = getConnection();
	        pstmt = con.prepareStatement(query);
	        pstmt.setInt(1, evaluationId);
	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            evaluation = new StudentVo();
	            evaluation.setEvaluationId(rs.getInt("evaluation_id"));
	            evaluation.setCourseId(rs.getString("course_id"));
	            evaluation.setCourse_name(rs.getString("course_name"));
	            evaluation.setRating(rs.getInt("rating"));
	            evaluation.setComments(rs.getString("comments"));
	        }
	    } catch (SQLException e) {
	        System.err.println("강의 평가 조회 중 예외 발생: " + e.getMessage());
	        e.printStackTrace();
	    } finally {
	        closeResource();
	    }
	    return evaluation;
	}

	// 해당학생이 듣는 강의목록 조회 메소드
	public List<StudentVo> getAllCourses(String studentId) {
	    List<StudentVo> courses = new ArrayList<>();
	    String query = "SELECT c.course_id, c.course_name " +
	                   "FROM course c " +
	                   "JOIN enrollment e ON c.course_id = e.course_id " +
	                   "WHERE e.student_id = ?"; // student_id를 기반으로 강의 조회
	    try {
	        con = getConnection();
	        pstmt = con.prepareStatement(query);
	        pstmt.setString(1, studentId);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            StudentVo course = new StudentVo();
	            course.setCourseId(rs.getString("course_id"));
	            course.setCourse_name(rs.getString("course_name"));
	            courses.add(course);
	        }
	    } catch (SQLException e) {
	        System.err.println("강의 목록 조회 중 예외 발생: " + e.getMessage());
	        e.printStackTrace();
	    } finally {
	        closeResource();
	    }
	    return courses;
	}



	// 강의 평가 수정
	public int updateEvaluation(StudentVo evaluation) {
	    int result = 0;
	    String query = "UPDATE course_evaluation SET rating = ?, comments = ? WHERE evaluation_id = ?";
	    try {
	        con = getConnection();
	        pstmt = con.prepareStatement(query);
	        pstmt.setInt(1, evaluation.getRating());
	        pstmt.setString(2, evaluation.getComments());
	        pstmt.setInt(3, evaluation.getEvaluationId());
	        result = pstmt.executeUpdate();
	    } catch (SQLException e) {
	        System.err.println("강의 평가 수정 중 예외 발생: " + e.getMessage());
	        e.printStackTrace();
	    } finally {
	        closeResource();
	    }
	    return result;
	}


	// 강의 평가 삭제
	public int deleteEvaluation(int evaluationId) {
	    int result = 0;
	    String query = "DELETE FROM course_evaluation WHERE evaluation_id = ?";
	    try {
	        con = getConnection();
	        pstmt = con.prepareStatement(query);
	        pstmt.setInt(1, evaluationId);
	        result = pstmt.executeUpdate();
	    } catch (SQLException e) {
	        System.err.println("강의 평가 삭제 중 예외 발생: " + e.getMessage());
	        e.printStackTrace();
	    } finally {
	        closeResource();
	    }
	    return result;
	}

}// MemberDAO 클래스