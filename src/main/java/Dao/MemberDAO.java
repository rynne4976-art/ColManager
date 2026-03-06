package Dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import Vo.MemberVo;
import utils.SessionUtil;

//MVC 중에서 M을 얻기 위한 클래스 

//DB와 연결하여 비즈니스로직 처리하는 클래스
public class MemberDAO {

	Connection con;
	PreparedStatement pstmt;
	ResultSet rs;
	DataSource ds;
	String query = null;

	// 커넥션 풀 얻는 생성자
	public MemberDAO() {
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
	// ====================================================================================================================

	// 로그인 요청시 입력한 아이디, 비밀번호가 DB의 member테이블에 있는지 확인
	public Map<String, String> userCheck(String login_id, String login_pass) {

		Map<String, String> userInfo = new HashMap<String, String>();

		try {
			con = ds.getConnection();
			
			String sql = "select * from user u "
					+ "left join professor_info p on u.user_id = p.user_id "
					+ "left join student_info s on u.user_id = s.user_id "
					+ "where u.user_id = ?";
			
			
			pstmt = con.prepareStatement(sql);
			
			pstmt.setString(1, login_id);
			
			rs = pstmt.executeQuery();
			
			if (rs.next()) { // 입력한 아이디로 조회된 결과가 있을 경우
	            // 입력된 비밀번호와 DB 비밀번호 비교
	            if (login_pass.equals(rs.getString("user_pw"))) {
	                userInfo.put("role", rs.getString("role"));
	                userInfo.put("name", rs.getString("user_name"));
	                userInfo.put("check", "1"); // 아이디와 비밀번호 일치 시 "1" 반환
	                userInfo.put("majorcode", rs.getString("majorcode"));
	                
	                // role에 따라 추가 정보를 저장
	                if ("교수".equals(rs.getString("role"))) {
	                    userInfo.put("professor_id", rs.getString("professor_id"));
	                    userInfo.put("employment_date", rs.getString("employment_date"));
	                    // 필요한 교수의 고유 정보를 추가로 저장
	                } else if ("학생".equals(rs.getString("role"))) {
	                    userInfo.put("student_id", rs.getString("student_id"));
	                    userInfo.put("grade", rs.getString("grade"));
	                    userInfo.put("admission_date", rs.getString("admission_date"));
	                    userInfo.put("status", rs.getString("status"));
	                    // 필요한 학생의 고유 정보를 추가로 저장
	                }
	                
					SessionUtil.name = rs.getString("user_name");
					
	            } else {
	                userInfo.put("check", "0"); // 비밀번호 불일치 시 "0" 반환
	            }
	        } else {
	            userInfo.put("check", "-1"); // 아이디가 DB에 없는 경우 "-1" 반환
	        }

		} catch (Exception e) {
			System.out.println("MemberDAO의 userCheck메소드 오류 :  " + e);
			e.printStackTrace();
		} finally {
			closeResource();
		}

		return userInfo; // MemberService(부장)에게 결과 반환

	}
	
	//===============================================================================================
	//로그인한 회원 아이디를 이용해 회원정보 조회
		//이유 : 글작성 화면에 조회한 회원정보를 보여주기 위해 
		public MemberVo memberOne(String reply_id_) {
		
			MemberVo vo = null;
			
			try {
				 con = ds.getConnection();//DB연결
				 
				 String sql = "select user_name, user_id from user where user_id=?";
				 pstmt = con.prepareStatement(sql);
				 pstmt.setString(1, reply_id_);
				 rs = pstmt.executeQuery();
				 if(rs.next()) {//로그인한 아이디로 조회한 행이 있으면?
					 vo = new MemberVo();
					 vo.setUser_name(rs.getString("user_name"));
					 vo.setUser_id(rs.getString("user_id"));
				 }	
			} catch (Exception e) {
				System.out.println("MemberDAO의 memberOne메소드");
				e.printStackTrace();
			} finally {
				closeResource();
			}
			return vo;//BoardService로 리턴(보고)
		}
	
}// MemberDAO 클래스
