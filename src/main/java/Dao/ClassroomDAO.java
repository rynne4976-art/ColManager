package Dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import Vo.AssignmentVo;
import Vo.BoardVo;
import Vo.ClassroomVo;
import Vo.CourseVo;
import Vo.EnrollmentVo;
import Vo.PeriodVo;
import Vo.ProfessorVo;
import Vo.StudentVo;


public class ClassroomDAO {


	Connection con;
	PreparedStatement pstmt;
	ResultSet rs;
	DataSource ds;

	
	//컨넥션풀 얻는 생성자
	public ClassroomDAO() {
		try {
			Context ctx = new InitialContext();
			ds = (DataSource)ctx.lookup("java:/comp/env/jdbc/edumanager");
			
		}catch(Exception e) {
			System.out.println("커넥션풀 얻기 실패 : " + e.toString());
		}
	}
	
	//자원해제(Connection, PreparedStatment, ResultSet)기능의 메소드 
	private void closeResource() {
		try {
				if(con != null) { con.close(); }
				if(pstmt != null) { pstmt.close(); }
				if(rs != null) { rs.close(); }
		}catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	// 현재 DB의 majorInformation테이블에 저장된 값들 중 majorCode와 일치하는 열 조회
	public String getMajorNameInfo(String majorCode) {
		
		String result = null;
		
		try {
			
			con = ds.getConnection();
			
			String sql = "select * from majorinformation where majorcode=?";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, majorCode);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				result = rs.getString("majorname");
			}
			
		} catch (Exception e) {
			System.out.println("ClassroomDAO의 getMajorInfo메소드에서 오류 ");
			e.printStackTrace();
		} finally {
			closeResource();
		}
		
		return result;
	}

	//------------
	// DB의 classroom 테이블에 저장된 모든 열 조회
	public ArrayList<ClassroomVo> getClassroomAllInfo() {
		
		ArrayList<ClassroomVo> list = new ArrayList<ClassroomVo>();
		ClassroomVo vo;
		
		try {
			
			con = ds.getConnection();
			
			String sql = "select * from classroom";
			
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				vo = new ClassroomVo(rs.getString("room_id"),
						 rs.getInt("capacity"),
						 rs.getString("equipment"));
				
				list.add(vo);
			}
			
		} catch (Exception e) {
			System.out.println("ClassroomDAO의 getClassroomAllInfo메소드에서 오류 ");
			e.printStackTrace();
		} finally {
			closeResource(); // 자원 해제
		}
		
		return list;
	}

	
	//------------
	// DB의 classroom 테이블에 교수가 등록한 강의를 저장
	public int registerInsertCourse(String course_name, String majorcode, String room_id, String professor_id) {

		int result = 0;
		String sql = null;
		
		try {
			
			con = ds.getConnection();
			
			sql = "INSERT INTO course (course_name, professor_id, majorcode, room_id) VALUES (?, ?, ?, ?)";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, course_name);
            pstmt.setString(2, professor_id);
            pstmt.setString(3, majorcode);
            pstmt.setString(4, room_id);
            
			result = pstmt.executeUpdate();
			
			return result;
			
		} catch (Exception e) {
			System.out.println("ClassroomDAO의 registerInsertCourse메소드에서 오류 ");
			e.printStackTrace();
		} finally {
			closeResource(); // 자원 해제
		}
		
		return result;
	}

	//------------
	// 해당 교수의 강의를 DB에서 찾아 반환하는 함수
	public ArrayList<CourseVo> courseSearch(String professor_id) {
		
		ArrayList<CourseVo> courseList = new ArrayList<CourseVo>();
		CourseVo course;
		
		try {
			
			con = ds.getConnection();
			
			String sql = "select c.course_id, c.course_name, r.room_id, r.capacity, r.equipment from course c "
					   + "inner join classroom r on c.room_id = r.room_id "
					   + "where professor_id=?";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, professor_id);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				course = new CourseVo();
				course.setCourse_id(rs.getString("course_id"));
				course.setCourse_name(rs.getString("course_name"));
				
				// ClassroomVo 객체 생성 후 강의실 정보를 설정
				ClassroomVo classroom = new ClassroomVo();
				classroom.setRoom_id(rs.getString("room_id"));
				classroom.setCapacity(rs.getInt("capacity"));
				classroom.setEquipment(rs.getString("equipment"));
				
				// CourseVo에 ClassroomVo 객체를 설정
				course.setClassroom(classroom);

				courseList.add(course);
			}
			
		} catch (Exception e) {
			System.out.println("ClassroomDAO의 courseSearch메소드에서 오류 ");
			e.printStackTrace();
		} finally {
			closeResource(); // 자원 해제
		}
		
		return courseList;
	}

	//-----------
	// DB에서 강의를 삭제하는 함수
	public int courseDelete(String course_id) {
		
		int result = 0;
		
		String sql = null;
		
		try {
			
			con = ds.getConnection();
			
			sql = "DELETE FROM course WHERE course_id=?";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, course_id);
            
			result = pstmt.executeUpdate();
			
			return result;
			
		} catch (Exception e) {
			System.out.println("ClassroomDAO의 courseDelete메소드에서 오류 ");
			e.printStackTrace();
		} finally {
			closeResource(); // 자원 해제
		}
		
		return result;
		
	}

	//-----------
	// 교수가 강의를 수정하기 위한 함수
	public int updateCourse(String course_id, String course_name, String room_id) {
		
		int result = 0;
		
		String sql = null;
		
		try {
			
			con = ds.getConnection();
			
			sql = "UPDATE course SET "
					+ "course_name=?, room_id=? "
					+ "WHERE course_id=?";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, course_name);
			pstmt.setString(2, room_id);
			pstmt.setString(3, course_id);
            
			result = pstmt.executeUpdate();
			
			return result;
			
		} catch (Exception e) {
			System.out.println("ClassroomDAO의 updateCourse메소드에서 오류 ");
			e.printStackTrace();
		} finally {
			closeResource(); // 자원 해제
		}
		
		return result;
		
	}

	//----------
	// classroom 테이블에 강의실을 등록하기 위한 함수
	public int roomRegister(String room_id, String capacity, String[] equipment) {

		int result = 0;
		String sql = null;
		
		try {
			
			con = ds.getConnection();
			
			// equipment 배열을 문자열로 변환
	        String equipmentStr = String.join(",", equipment);
			
			sql = "INSERT INTO classroom (room_id, capacity, equipment)VALUES (?, ?, ?)";
			
			pstmt = con.prepareStatement(sql);
	        pstmt.setString(1, room_id);
	        pstmt.setString(2, capacity);
	        pstmt.setString(3, equipmentStr);
            
			result = pstmt.executeUpdate();
			
			return result;
			
		} catch (Exception e) {
			System.out.println("ClassroomDAO의 roomRegister메소드에서 오류 ");
			e.printStackTrace();
		} finally {
			closeResource(); // 자원 해제
		}
		
		return result;
		
	}
			
	//-----------
	// 관리자가 강의실 조회하기 위한 함수 
	public ArrayList<ClassroomVo> roomShearch() {
		
		ArrayList<ClassroomVo> courseList = new ArrayList<ClassroomVo>();
		
		try {
			
			con = ds.getConnection();
			
			String sql = "select * from classroom";
			
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				
				// ClassroomVo 객체 생성 후 강의실 정보를 설정
				ClassroomVo classroom = new ClassroomVo();
				classroom.setRoom_id(rs.getString("room_id"));
				classroom.setCapacity(rs.getInt("capacity"));
				classroom.setEquipment(rs.getString("equipment"));

				courseList.add(classroom);
			}
			
		} catch (Exception e) {
			System.out.println("ClassroomDAO의 roomSearch메소드에서 오류 ");
			e.printStackTrace();
		} finally {
			closeResource(); // 자원 해제
		}
		
		return courseList;
	}

	//-----------
	// 관리자가 강의실의 정보를 수정하기 위해 호출하는 함수
	public int updateRoom(String room_id, String capacity, String room_equipment) {
		
		int result = 0;
		
		String sql = null;
		
		try {
			
			con = ds.getConnection();
			sql = "UPDATE classroom SET "
					+ "capacity=?, equipment=? "
					+ "WHERE room_id=?";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, Integer.parseInt(capacity));
			pstmt.setString(2, room_equipment);
			pstmt.setString(3, room_id);
            
			result = pstmt.executeUpdate();
			
			return result;
			
		} catch (Exception e) {
			System.out.println("ClassroomDAO의 updateCourse메소드에서 오류 ");
			e.printStackTrace();
		} finally {
			closeResource(); // 자원 해제
		}
		return result;
		
		}
	
		//-----------
		// 관리자가 강의실의 정보를 DB에서 삭제하기 위해 호출하는 함수
		public int deleteRoom(String room_id) {
			
			int result = 0;
			
			String sql = null;
			
			try {
				
				con = ds.getConnection();
				
				sql = "DELETE FROM classroom WHERE room_id=?";
				
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, room_id);
	            
				result = pstmt.executeUpdate();
				
				return result;
				
			} catch (Exception e) {
				System.out.println("ClassroomDAO의 deleteRoom메소드에서 오류 ");
				e.printStackTrace();
			} finally {
				closeResource(); // 자원 해제
			}
			
			return result;
		}
		
		//-------------
		// 로그인한 학생의 수강 중인 강의를 조회하는 함수
		public ArrayList<EnrollmentVo> studentCourseSearch(String student_id) {
			ArrayList<EnrollmentVo> studentCourseList = new ArrayList<EnrollmentVo>();
			
			try {
				
				con = ds.getConnection();
				
				// SQL 쿼리 실행
	            String query = "SELECT c.course_name, c.course_id "
	            			 + "FROM enrollment e "
	            			 + "JOIN course c ON e.course_id = c.course_id "
	            			 + "WHERE e.student_id = ?";
	            
	            pstmt = con.prepareStatement(query);
	            pstmt.setString(1, student_id);
	            rs = pstmt.executeQuery();
	            
	            // 강의 이름을 리스트에 추가
	            while (rs.next()) {
	            	 // CourseVo 객체 생성 및 값 설정
	                CourseVo course = new CourseVo();
	                course.setCourse_id(rs.getString("course_id"));
	                course.setCourse_name(rs.getString("course_name"));
					
	                // EnrollmentVo 객체 생성 및 CourseVo 설정
	                EnrollmentVo enrollment = new EnrollmentVo();
	                enrollment.setCourse(course); // courseId 대신 CourseVo 객체 설정
	            	
	                // EnrollmentVo 리스트에 추가
	                studentCourseList.add(enrollment);
	            }

	    		return studentCourseList;
	    		
			} catch (Exception e) {
				System.out.println("ClassroomDAO의 courseSearch메소드에서 오류 ");
				e.printStackTrace();
			} finally {
				closeResource(); // 자원 해제
			}
			
			return studentCourseList;
		}

		//----------
		// 학생 강의실에서 수강하는 모든 강의의 과제를 조회하기 위해 DB 연결
		public List getAssignments(String studentId) {

			System.out.println(studentId);
		    List assignments = new ArrayList();
		    
		    String query = "SELECT c.course_name, a.title, a.description, p.start_date, p.end_date "
		                 + "FROM enrollment e "
		                 + "JOIN course c ON e.course_id = c.course_id "
		                 + "LEFT JOIN assignment a ON c.course_id = a.course_id "
		                 + "LEFT JOIN period_management p ON a.assignment_id = p.reference_id AND p.type = '과제' "
		                 + "WHERE e.student_id = ? AND a.title IS NOT NULL "
		                 + "limit 5";
		    try {
		    	con = ds.getConnection();
		        pstmt = con.prepareStatement(query);
		        pstmt.setString(1, studentId);
		        rs = pstmt.executeQuery();
		        
		        while (rs.next()) {
		        	CourseVo course = new CourseVo();
		        	course.setCourse_name(rs.getString("course_name"));
		        	
		        	PeriodVo period = new PeriodVo();
		        	period.setStartDate(rs.getTimestamp("start_date"));
		        	period.setEndDate(rs.getTimestamp("end_date"));
		        	
		        	AssignmentVo assignment = new AssignmentVo();
		        	assignment.setCourse(course);
		        	assignment.setPeriod(period);
		        	assignment.setTitle(rs.getString("title"));
		        	assignment.setDescription(rs.getString("description"));
		        	
		        	assignments.add(assignment);
		        	
		        }
		    } catch (Exception e) {
		        e.printStackTrace();
		    } finally {
		        closeResource();
		    }
		    return assignments;
		}

		//----------
		// 학생 강의실에서 수강하는 모든 강의의 공지사항을 조회하기 위해 DB 연결
		public List getNotices(String studentId) {

			List notice = new ArrayList();
			
		    String query = "SELECT c.course_name, n.title, n.content, n.created_date "
		                 + "FROM enrollment e "
		                 + "JOIN course c ON e.course_id = c.course_id "
		                 + "LEFT JOIN classroom_notice n ON c.course_id = n.course_id "
		                 + "WHERE e.student_id = ? AND n.title IS NOT NULL "
		                 + "limit 5";
		    try {
		    	con = ds.getConnection();
		        pstmt = con.prepareStatement(query);
		        pstmt.setString(1, studentId);
		        rs = pstmt.executeQuery();
		        
		        while (rs.next()) {
		        	
		        	CourseVo course = new CourseVo();
		        	course.setCourse_name(rs.getString("course_name"));
		        	
		        	BoardVo board = new BoardVo();
		        	board.setTitle(rs.getString("title"));
		        	board.setContent(rs.getString("content"));
		        	board.setCreated_date(rs.getDate("created_date"));
		        	board.setCourse(course);
		        	
		        	notice.add(board);
		        	
		        }
		    } catch (Exception e) {
		        e.printStackTrace();
		    } finally {
		        closeResource();
		    }
		    return notice;
		}

	
	// 학생 조회 
		 public ArrayList<StudentVo> studentSearch(String course_id_) {
			
				ArrayList<StudentVo> studentList = new ArrayList<StudentVo>();
				
				StudentVo student;
				
				CourseVo course;
				
				try {
					
					con = ds.getConnection();

					String sql = "SELECT m.majorname, s.student_id, u.user_name, "
								+ "g.midtest_score, g.finaltest_score, g.assignment_score, g.score "
								+ "FROM enrollment e "
								+ "JOIN student_info s ON e.student_id = s.student_id "
								+ "JOIN  user u ON s.user_id = u.user_id "
								+ "LEFT JOIN majorinformation m ON s.majorcode = m.majorcode "
								+ "LEFT JOIN grade g ON g.student_id = s.student_id AND g.course_id = e.course_id "
								+ "WHERE e.course_id = ?";
				
					pstmt = con.prepareStatement(sql);
					pstmt.setString(1, course_id_);
					rs = pstmt.executeQuery();
				
					while(rs.next()) {
						student = new StudentVo();
						student.setStudent_id(rs.getString("student_id"));
						student.setUser_name(rs.getString("user_name"));
						student.setMidtest_score(rs.getInt("midtest_score"));
						student.setFinaltest_score(rs.getInt("finaltest_score"));
						student.setAssignment_score(rs.getInt("assignment_score"));
						student.setScore(rs.getFloat("score"));
						
						course = new CourseVo();
						course.setMajorname(rs.getString("majorname"));
						
						student.setCourse(course);

						studentList.add(student);
					}
				
				} catch (Exception e) {
					System.out.println("ClassroomDAO의 studentSearch메소드에서 오류 ");
					e.printStackTrace();
				}finally {
					closeResource();
				}
			
				return studentList;
			}

			//성적 등록
			public void gradeInsert(String course_id_, String student_id, String total, String midtest_score, String finaltest_score, String assignment_score) {

				String sql = null;
				
				try {
					con = ds.getConnection();
					
					
					sql = "INSERT INTO grade (student_id, course_id, score, midtest_score, finaltest_score, assignment_score) VALUES (?, ?, ?, ?, ?, ?)";
				
					pstmt = con.prepareStatement(sql);
					pstmt.setString(1, student_id);
					pstmt.setString(2, course_id_);
					pstmt.setFloat(3, Float.parseFloat(total));
					pstmt.setInt(4, Integer.parseInt(midtest_score));
					pstmt.setInt(5, Integer.parseInt(finaltest_score));
					pstmt.setInt(6, Integer.parseInt(assignment_score));
	            
					pstmt.executeUpdate();
				
			} catch (Exception e) {
				System.out.println("ClassroomDAO의 registerInsertCourse메소드에서 오류 ");
				e.printStackTrace();
			}finally {
				closeResource();
			}

		
		}
		
		// 성적 수정
		public void gradeUpdate(String course_id_, String student_id, String total, String midtest_score, String finaltest_score,
				String assignment_score) {
		
			String sql = null;
			
			try {
				con = ds.getConnection();
			
				sql = "UPDATE grade SET midtest_score = ?, finaltest_score = ?, assignment_score = ?, score = ? " +
						"WHERE student_id = ? AND course_id = ?";
					
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, midtest_score);
				pstmt.setString(2, finaltest_score);
				pstmt.setString(3, assignment_score);
				pstmt.setString(4, total);
				pstmt.setString(5, student_id);
				pstmt.setString(6, course_id_);
	        
				pstmt.executeUpdate();
			
			} catch (Exception e) {
				System.out.println("ClassroomDAO의 gradeUpdate메소드에서 오류 ");
				e.printStackTrace();
			} finally {
				closeResource(); // 자원 해제
			}
		}
		

		
		 
	// 성적 조회
	public ArrayList<StudentVo> gradeSearch(String student_id_1) {
		
		ArrayList<StudentVo> studentList = new ArrayList<StudentVo>();
		
		StudentVo student;
		
		CourseVo course;
		
		try {
			
			con = ds.getConnection();
			
			String sql = "SELECT g.student_id, c.course_id, c.course_name, g.score, m.majorname, g.midtest_score, g.finaltest_score, assignment_score "
						+ "FROM grade g "
						+ "JOIN course c ON g.course_id = c.course_id "
						+ "JOIN student_info s ON g.student_id = s.student_id "
						+ "JOIN majorinformation m ON s.majorcode = m.majorcode "
						+ "WHERE g.student_id = ?";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, student_id_1);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				student = new StudentVo();
				student.setStudent_id(rs.getString("student_id"));
				student.setScore(rs.getFloat("score"));
				student.setMidtest_score(rs.getInt("midtest_score"));
				student.setFinaltest_score(rs.getInt("finaltest_score"));
				student.setAssignment_score(rs.getInt("assignment_score"));
				
				course = new CourseVo();
				course.setCourse_id(rs.getString("course_id"));
				course.setCourse_name(rs.getString("course_name"));
				course.setMajorname(rs.getString("majorname"));
				
				student.setCourse(course);

				studentList.add(student);
			}
			
		} catch (Exception e) {
			System.out.println("ClassroomDAO의 gradeSearch메소드에서 오류 ");
			e.printStackTrace();
		} finally {
			closeResource(); // 자원 해제
		}
		
		return studentList;
	}

	// 이미 성적이 있는지 조회
	public boolean gradeExists(String course_id_, String student_id) {
		
		try {
			
			con = ds.getConnection();
			
			String sql = "SELECT COUNT(*) FROM grade WHERE student_id = ? AND course_id = ?";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, student_id);
			pstmt.setString(2, course_id_);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				return rs.getInt(1) > 0;
			}
			
		} catch (Exception e) {
			System.out.println("ClassroomDAO의 gradeExists메소드에서 오류 ");
			e.printStackTrace();
		} finally {
			closeResource(); // 자원 해제
		}
		
		return false;
	}

	//성적 삭제
	public void gradeDelete(String course_id_, String student_id) {
		String sql = null;
		
		try {
			
			con = ds.getConnection();
			
			sql = "DELETE FROM grade WHERE student_id = ? AND course_id = ?";
					
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, student_id);
			pstmt.setString(2, course_id_);
            
			pstmt.executeUpdate();
			
			
		} catch (Exception e) {
			System.out.println("ClassroomDAO의 gradeUpdate메소드에서 오류 ");
			e.printStackTrace();
		}finally {
			closeResource();
		}
	}

	// 강의 리스트 조회 (수강신청)
	public ArrayList<CourseVo> courseList(String studentId) {
		
		ArrayList<CourseVo> courseList = new ArrayList<CourseVo>();
		
		String sql = null;
		CourseVo courseVo;
		ProfessorVo professorVo;
		try {
			con = ds.getConnection();
			
			sql = "select c.course_id, c.course_name, u.user_name, c.room_id "
				+ "from course c "
				+ "join professor_info p on c.professor_id = p.professor_id "
				+ "join user u on p.user_id = u.user_id "
				+ "where role = '교수'AND c.course_id "
				+ "NOT IN "
				+ "(SELECT course_id "
				+ " FROM enrollment "
				+ " WHERE student_id = ? )";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, studentId);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				
				courseVo = new CourseVo();
				courseVo.setCourse_id(rs.getString("course_id"));
				courseVo.setCourse_name(rs.getString("course_name"));
				courseVo.setRoom_id(rs.getString("room_id"));
				
				professorVo = new ProfessorVo();
				professorVo.setUser_name(rs.getString("user_name"));
				
				courseVo.setProfessor_name(professorVo);
				
				courseList.add(courseVo);
			
			}
			
		}catch (Exception e) {
			System.out.println("ClassroomDAO의 courseList 메소드 오류");
			e.printStackTrace();
		}finally {
			closeResource();
		}
		
		return courseList;
	}

	
	// 수강 신청
	public int courseInsert(String courseId, String studentId) {
		int result = 0;
		String sql = null;
		
		try {
			con = ds.getConnection();
			sql = "insert into enrollment (student_id, course_id, enrollment_date) values(?, ? ,NOW())";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, studentId);
			pstmt.setString(2, courseId);
			
			result = pstmt.executeUpdate();
			
		} catch (Exception e) {
			System.out.println("ClassroomDAO의 courseInsert메소드 오류");
			e.printStackTrace();
		}finally {
			closeResource();
		}
		
		return result;
	}
	
	//수강 취소
	public int courseDelete_(String courseId, String studentId) {
		int result = 0;
		String sql = null;
		
		try {
			con = ds.getConnection();
			sql = "delete from enrollment where student_id = ? and course_id = ? ";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, studentId);
			pstmt.setString(2, courseId);
			
			result = pstmt.executeUpdate();
			
		} catch (Exception e) {
			System.out.println("ClassroomDAO의 courseInsert메소드 오류");
			e.printStackTrace();
		}finally {
			closeResource();
		}
		
		return result;
	}

	// 수강 신청 목록 조회
	public ArrayList<CourseVo> courseSelect(String studentId) {
		
		ArrayList<CourseVo> courseList = new ArrayList<CourseVo>();
		
		String sql = null;
		CourseVo courseVo;
		ProfessorVo professorVo;
		try {
			con = ds.getConnection();
			
			sql = "select c.course_id, c.course_name, u.user_name, c.room_id "
				+ "from course c "
				+ "join professor_info p on c.professor_id = p.professor_id "
				+ "join user u on p.user_id = u.user_id "
				+ "join enrollment e on e.course_id = c.course_id "
				+ "where student_id = ? ";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, studentId);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				
				courseVo = new CourseVo();
				courseVo.setCourse_id(rs.getString("course_id"));
				courseVo.setCourse_name(rs.getString("course_name"));
				courseVo.setRoom_id(rs.getString("room_id"));
				
				professorVo = new ProfessorVo();
				professorVo.setUser_name(rs.getString("user_name"));
				
				courseVo.setProfessor_name(professorVo);
				
				courseList.add(courseVo);
			
			}
			
		}catch (Exception e) {
			System.out.println("ClassroomDAO의 courseList 메소드 오류");
			e.printStackTrace();
		}finally {
			closeResource();
		}
		
		return courseList;
	}

	// 수강신청 기간 입력
	public boolean insertEnrollmentPeriod(Timestamp startTimestamp, Timestamp endTimestamp, String description) {
	    String checkQuery = "SELECT COUNT(*) FROM period_management WHERE type = '수강신청' AND start_date = ? AND end_date = ?";
	    String insertQuery = "INSERT INTO period_management (type, start_date, end_date, description) VALUES ('수강신청', ?, ?, ?)";
	    try {
	        con = ds.getConnection();

	        // 중복 데이터 확인
	        pstmt = con.prepareStatement(checkQuery);
	        pstmt.setTimestamp(1, startTimestamp); // LocalDateTime -> Timestamp 변환
	        pstmt.setTimestamp(2, endTimestamp);   // LocalDateTime -> Timestamp 변환
	        rs = pstmt.executeQuery();
	        if (rs.next() && rs.getInt(1) > 0) {
	            return false; // 중복 데이터가 있으면 삽입하지 않음
	        }

	        // 데이터 삽입
	        pstmt = con.prepareStatement(insertQuery);
	        System.out.println("Input time: " + startTimestamp);
	        System.out.println("Input time: " + endTimestamp);
	        pstmt.setTimestamp(1, startTimestamp); // LocalDateTime -> Timestamp 변환
	        pstmt.setTimestamp(2, endTimestamp);   // LocalDateTime -> Timestamp 변환
	        pstmt.setString(3, description);
	        int result = pstmt.executeUpdate();
	        return result > 0;
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        closeResource();
	    }
	    return false;
	}



	//수강신청 기간 조회
	public LocalDateTime[] getEnrollmentPeriod() {

        LocalDateTime startDate = null;
        LocalDateTime endDate = null;
        
		String query = "SELECT start_date, end_date FROM period_management WHERE type = '수강신청' ORDER BY created_at DESC LIMIT 1";

//	    String query = "SELECT start_date, end_date FROM period_management WHERE type = '수강신청' ORDER BY start_date DESC LIMIT 1";
	    try {
	        con = ds.getConnection();
	        pstmt = con.prepareStatement(query);
	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            startDate = rs.getTimestamp("start_date").toLocalDateTime();
	            endDate = rs.getTimestamp("end_date").toLocalDateTime();
	            return new LocalDateTime[]{startDate, endDate};
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        closeResource();
	    }
	    return null;
	}


}
