package Dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.servlet.http.HttpServletRequest;
import javax.sql.DataSource;

import Vo.ProfessorVo;



public class ProfessorDAO {

	//변수
		//데이터베이스 작업관련 객체들을 저장할 변수들
		DataSource ds;  // 커넥션풀 역할을 하는 DataSource객체의 주소를 저장할 변수
		Connection con; // 커넥션풀에 미리 만들어 놓고 DB와의 접속이 필요하면 빌려와 사용할 DB접속정보를 지니고 있는 Connection 객체주소를 저장할 변수
		PreparedStatement pstmt; // 생성한 SQL문을 DB의 테이블에 전송해서 실행하는 역할을 하는 객체의 주소를 저장할 변수
		ResultSet rs; // DB의 테이블에 저장된 행들을 조회한 천체 데이터들을 임시로 얻어 저장할 객체의 변수

		
	//컨넥션풀 얻는 생성자
		public ProfessorDAO() {
			try {
				Context ctx = new InitialContext();
				ds = (DataSource)ctx.lookup("java:/comp/env/jdbc/edumanager");
				
			}catch(Exception e) {
				System.out.println("커넥션풀 얻기 실패 : " + e.toString());
			}
		}
		
	// 자원해제(Connection, PreparedStatment, ResultSet)기능의 메소드
	private void closeResource() {
		try {
			if (rs != null) {rs.close();}
			if (pstmt != null) {pstmt.close();}
			if (con != null) {con.close();}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	
	// 새 회원 추가
		 public int insertProfessor(ProfessorVo vo) {
		        
			 int result = 0;  // 기본값은 실패(false)
			 
		      
		        try {
		        	
		        con = ds.getConnection();
		        	
		        con.setAutoCommit(false); 
		        	
		        pstmt = con.prepareStatement( "INSERT INTO user (user_id, user_pw, user_name, birthDate, gender, "
		        								+ "address, phone, email, role) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)");    	        	
		        	
	             pstmt.setString(1, vo.getUser_id());
	             pstmt.setString(2, vo.getUser_pw());
	             pstmt.setString(3, vo.getUser_name());
	             pstmt.setDate(4, vo.getBirthDate());
	             pstmt.setString(5, vo.getGender());
	             pstmt.setString(6, vo.getAddress());
	             pstmt.setString(7, vo.getPhone());
	             pstmt.setString(8, vo.getEmail());
	             pstmt.setString(9, "교수");

	             result = pstmt.executeUpdate();
	             
	             
		         pstmt = con.prepareStatement( "INSERT INTO professor_info (professor_id, user_id, majorcode, "
									+ "employment_date) VALUES (?, ?, ?, ?)");
		           
	         // 두 번째 INSERT 문 (professor_info 테이블)
	             pstmt.setString(1, vo.getProfessor_id());
	             pstmt.setString(2, vo.getUser_id());
	             pstmt.setString(3, vo.getMajorcode());
	             pstmt.setDate(4, vo.getEmployDate());

	             result += pstmt.executeUpdate();
		                 
	             // 모든 SQL문이 성공하면 커밋
	              con.commit();
	                      
		        } catch (SQLException e) {
		            System.out.println("ProsessDao의 insertProfessor 메소드에서 오류 발생");
		            e.printStackTrace();
		            try {
		                if (con != null) {
		                    con.rollback();  // Rollback transaction on error
		                }
		            } catch (SQLException rollbackEx) {
		                rollbackEx.printStackTrace();
		            }
		        } finally {
		        	closeResource();
		        }
				return result;

		    }

		
			
		 // 교수 목록 조회 메서드
		    public List<ProfessorVo> getProfessorList(String prof_id, String majorCode) {

		        List<ProfessorVo> professorList = new ArrayList<>();
		        
		        try {
		            con = ds.getConnection();
		            
		            String query = "SELECT p.professor_id, u.user_name, u.birthDate, u.gender, u.address, "
		                         + "u.phone, p.majorcode, u.email, p.employment_date "
		                         + "FROM user u "
		                         + "JOIN professor_info p ON u.user_id = p.user_id ";
		            
		            // 조건문이 하나 이상 있을 때만 WHERE 절 추가
		            boolean hasCondition = false;
		            if (prof_id != null && !prof_id.isEmpty()) {
		                query += " WHERE p.professor_id = ? ";
		                hasCondition = true;
		            }
		            if (majorCode != null && !majorCode.isEmpty()) {
		                query += hasCondition ? " AND p.majorcode = ? " : " WHERE p.majorcode = ?";
		            }
		            
		            query += " ORDER BY p.professor_id DESC";

		            System.out.println(query);
		            
		            
		            pstmt = con.prepareStatement(query);
		            
		            int index = 1;
		            
		            if (prof_id != null && !prof_id.isEmpty()) {
		                pstmt.setString(index++, prof_id);
		            }
		            if (majorCode != null && !majorCode.isEmpty()) {
		                pstmt.setString(index, majorCode);
		            }

		            rs = pstmt.executeQuery();

		            while (rs.next()) {
		                ProfessorVo professor = new ProfessorVo();
		                
		                professor.setProfessor_id(rs.getString("professor_id"));
		                professor.setUser_name(rs.getString("user_name"));
		                professor.setBirthDate(rs.getDate("birthDate"));
		                professor.setGender(rs.getString("gender"));
		                professor.setAddress(rs.getString("address"));
		                professor.setPhone(rs.getString("phone"));
		                professor.setMajorcode(rs.getString("majorcode"));
		                professor.setEmail(rs.getString("email"));
		                professor.setEmployDate(rs.getDate("employment_date"));
		                
		                professorList.add(professor);
		            }
		        } catch (SQLException e) {
		            System.out.println("ProfessorDao의 getProfessorList 메소드 오류");
		            e.printStackTrace();
		        } finally {
		            closeResource(); // 자원 해제
		        }

		        return professorList;
		    }


		    
		 // 교수 정보 수정 메소드
		    public boolean updateProfessor(ProfessorVo professor) {
		        boolean isUpdated = false;
		        
		        String sql = "UPDATE user u "
		                + "JOIN professor_info p ON u.user_id = p.user_id "
		                + "SET "
		                + "    u.user_name = ?, "
		                + "    p.majorcode = ?, "
		                + "    u.birthDate = ?, "
		                + "    u.gender = ?, "
		                + "    u.address = ?, "
		                + "    u.phone = ?, "
		                + "    u.email = ?, "
		                + "    p.employment_date = ? "
		                + "WHERE "
		                + "    p.professor_id = ?;";
		        
		        try {
		            con = ds.getConnection();
		            // preparedStatement 생성
		            PreparedStatement stmt = con.prepareStatement(sql);
		            
		            // 파라미터 설정
		            stmt.setString(1, professor.getUser_name());  // 교수 이름
		            stmt.setString(2, professor.getMajorcode());  // 전공 코드
		            stmt.setDate(3, professor.getBirthDate());    // 생년월일
		            stmt.setString(4, professor.getGender());     // 성별
		            stmt.setString(5, professor.getAddress());    // 주소
		            stmt.setString(6, professor.getPhone());      // 전화번호
		            stmt.setString(7, professor.getEmail());      // 이메일
		            stmt.setDate(8, professor.getEmployDate());   // 고용 날짜
		            stmt.setString(9, professor.getProfessor_id()); // 교수 ID
		            
		            // SQL 실행
		            int rowsUpdated = stmt.executeUpdate();
		            
		            // 업데이트가 성공하면 true
		            isUpdated = rowsUpdated > 0;
		            
		        } catch (SQLException e) {
		            System.out.println("ProfessorDao의 updateProfessor 메소드 오류");
		            e.printStackTrace();
		        } finally {
		            closeResource(); // 자원 해제
		        }
		        
		        return isUpdated; // 업데이트 결과 반환
		    }


		   //삭제 
		    public boolean deleteProfessor(String professorId) {
		        boolean isDeleted = false;
		        
		        
		        try {
		        
		        String usersql = "DELETE FROM user WHERE user_id = (SELECT user_id FROM professor_info WHERE professor_id = ?)";
		        
		        con = ds.getConnection();
		        
		     // 트랜잭션 시작
		        con.setAutoCommit(false); // 수동 커밋 모드 설정
		        

		            
		            pstmt = con.prepareStatement(usersql);
		            pstmt.setString(1, professorId);
		            int userResult = pstmt.executeUpdate();
		            isDeleted = userResult > 0;
		            
		         // 성공적으로 삭제된 경우
		            if ( userResult > 0) {
		                // 트랜잭션 커밋
		                con.commit();
		                isDeleted = true;
		            } else {
		                // 삭제가 실패한 경우 롤백
		                con.rollback();
		            }
		            
		        } catch (SQLException e) {
		            try {
		                if (con != null) con.rollback(); // 예외 발생 시 롤백
		            } catch (SQLException ex) {
		                ex.printStackTrace();
		            }
		            e.printStackTrace();
		        } finally {
		            try {
		                if (pstmt != null) pstmt.close();
		                if (con != null) con.setAutoCommit(true); // 자동 커밋 모드로 복원
		                if (con != null) con.close(); // 연결 닫기
		            } catch (SQLException e) {
		                e.printStackTrace();
		            }
		        }
		        return isDeleted;
		    }
		    
		    //===========================================================================
		    //교수가 담당한 과목의 학생이 적은 강의평가를 조회하는 메서드
		    public List<ProfessorVo> getEvaluationsByProfessorId(String professorId) {
		        List<ProfessorVo> evaluationList = new ArrayList<>();
		        String sql = "SELECT e.course_id, e.student_id, e.rating, e.comments, c.course_name " +
		                     "FROM course_evaluation e " +
		                     "JOIN course c ON e.course_id = c.course_id " +
		                     "WHERE c.professor_id = ?";

		        try {
		            con = ds.getConnection(); 
		            pstmt = con.prepareStatement(sql); 
		            pstmt.setString(1, professorId); 
		            rs = pstmt.executeQuery(); 

		            // 결과 처리
		            while (rs.next()) {
		                ProfessorVo evaluation = new ProfessorVo();
		                evaluation.setCourseId(rs.getString("course_id"));       // 강의 ID		                
		                evaluation.setCourseName(rs.getString("course_name"));   // 강의 이름
		                //evaluation.setUser_id(rs.getString("student_id"));       // 학생 ID
		                evaluation.setRating(rs.getInt("rating")); // 평점 저장
		                evaluation.setComments(rs.getString("comments")); // 평가 내용 저장         // 평가 내용 저장 (필요에 따라 필드 이름 변경 가능)
		                evaluationList.add(evaluation);
		            }
		        } catch (SQLException e) {
		            System.out.println("ProfessorDAO의 getEvaluationsByProfessorId 메소드 오류");
		            e.printStackTrace();
		        } finally {
		            closeResource(); // 자원 해제
		        }

		        return evaluationList;
		    }
		    
		    
		    
		    
		    
		    
		    //========================================================================
		 // 교수가 담당한 강의 목록 조회
		    public List<ProfessorVo> getCoursesByProfessorId(String searchProfessorId) {
		        List<ProfessorVo> courseList = new ArrayList<>();
		        String sql = "SELECT course_id, course_name FROM course WHERE professor_id = ?";

		        try {
		            con = ds.getConnection();
		            pstmt = con.prepareStatement(sql);
		            pstmt.setString(1, searchProfessorId);
		            rs = pstmt.executeQuery();

		            while (rs.next()) {
		                ProfessorVo course = new ProfessorVo();
		                course.setCourseId(rs.getString("course_id"));
		                course.setCourseName(rs.getString("course_name"));
		                courseList.add(course);
		            }
		        } catch (SQLException e) {
		            System.out.println("getCoursesByProfessorId 오류: " + e.getMessage());
		        } finally {
		            closeResource();
		        }

		        return courseList;
		    }
		    
		 // 특정 강의의 평가 목록 조회
		    public List<ProfessorVo> getEvaluationsByCourseId(String courseId) {
		        List<ProfessorVo> evaluationList = new ArrayList<>();
		        String sql = "SELECT e.course_id, e.student_id, e.rating, e.comments, c.course_name " +
		                     "FROM course_evaluation e " +
		                     "JOIN course c ON e.course_id = c.course_id " +
		                     "WHERE e.course_id = ?";

		        try {
		            con = ds.getConnection();
		            pstmt = con.prepareStatement(sql);
		            pstmt.setString(1, courseId);
		            rs = pstmt.executeQuery();

		            while (rs.next()) {
		                ProfessorVo evaluation = new ProfessorVo();
		                evaluation.setCourseId(rs.getString("course_id"));
		                evaluation.setCourseName(rs.getString("course_name"));
		                //evaluation.setUser_id(rs.getString("student_id"));
		                evaluation.setRating(rs.getInt("rating"));
		                evaluation.setComments(rs.getString("comments"));
		                evaluationList.add(evaluation);
		            }
		            System.out.println("DAO: Evaluation List Size = " + evaluationList.size());
		        } catch (SQLException e) {
		            System.out.println("getEvaluationsByCourseId 오류: " + e.getMessage());
		        } finally {
		            closeResource();
		        }

		        return evaluationList;
		    }



}
		    
	