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

import javax.sql.DataSource;

import Vo.AdminVo;

//MVC중에서 M을 얻기 위한 클래스 

//DB와 연결하여 비즈니스로직 처리하는 클래스 
public class AdminDAO {

	// 변수
	// 데이터베이스 작업관련 객체들을 저장할 변수들
	DataSource ds; // 커넥션풀 역할을 하는 DataSource객체의 주소를 저장할 변수
	Connection con; // 커넥션풀에 미리 만들어 놓고 DB와의 접속이 필요하면 빌려와 사용할 DB접속정보를 지니고 있는 Connection 객체주소를 저장할 변수
	PreparedStatement pstmt; // 생성한 SQL문을 DB의 테이블에 전송해서 실행하는 역할을 하는 객체의 주소를 저장할 변수
	ResultSet rs; // DB의 테이블에 저장된 행들을 조회한 천체 데이터들을 임시로 얻어 저장할 객체의 변수

	// 컨넥션풀 얻는 생성자
	public AdminDAO() {
		try {
			Context ctx = new InitialContext();
			ds = (DataSource) ctx.lookup("java:/comp/env/jdbc/edumanager");

		} catch (Exception e) {
			System.out.println("커넥션풀 얻기 실패 : " + e.toString());
		}
	}

	// 자원해제(Connection, PreparedStatment, ResultSet)기능의 메소드
	private void closeResource() {
		try {
			if (rs != null) {
				rs.close();
			}
			if (pstmt != null) {
				pstmt.close();
			}
			if (con != null) {
				con.close();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// 새 회원 추가
	public int insertMember(AdminVo vo) {

		int result = 0;

		try {
			con = ds.getConnection(); // DB 연결

			con.setAutoCommit(false);

			// 첫 번째 INSERT문 실행
			pstmt = con.prepareStatement("INSERT INTO user (user_id, user_pw, user_name, birthDate, gender, "
					+ "address, phone, email, role) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)");

			pstmt.setString(1, vo.getUser_id());
			pstmt.setString(2, vo.getUser_pw());
			pstmt.setString(3, vo.getUser_name());
			pstmt.setDate(4, vo.getBirthDate());
			pstmt.setString(5, vo.getGender());
			pstmt.setString(6, vo.getAddress());
			pstmt.setString(7, vo.getPhone());
			pstmt.setString(8, vo.getEmail());
			pstmt.setString(9, "관리자");

			result = pstmt.executeUpdate();

			// 두 번째 INSERT문 실행
			pstmt = con.prepareStatement(
					"INSERT INTO admin_info (admin_id, user_id, department, access_level) VALUES (?, ?, ?, ?)");

			pstmt.setString(1, vo.getAdmin_id());
			pstmt.setString(2, vo.getUser_id());
			pstmt.setString(3, vo.getDepartment());
			pstmt.setInt(4, vo.getAccess_level());

			result += pstmt.executeUpdate();

			// 트랜잭션 커밋
			con.commit();

		} catch (Exception e) {
			System.out.println("MembeDAO의 insertMember메소드 에서 오류");
			e.printStackTrace();
			try {
				if (con != null) {
					con.rollback();
				}
			} catch (SQLException rollbackEx) {
				rollbackEx.printStackTrace();
			}
		} finally {
			closeResource();
		}
		return result;

	}

	// id 중복체크요청
	public boolean overlappedId(String user_id) {

		boolean result_ = false;

		try {
			con = ds.getConnection(); // DB연결

			String sql = "SELECT user_id FROM user WHERE user_id = ?";

			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, user_id);

			// select전체 문장을 DB에 전송하여 실행한 조회된 결과데이터를 ResultSet임시객체에 담아 반환
			rs = pstmt.executeQuery();

			if (rs.next()) {// 조회된 제목 행의 커서(화살표)가 조회된 행 줄로 내려왔을때 있으면?
				result_ = true; // "true"-> true변환해서 저장
			}

		} catch (Exception e) {
			System.out.println("MembeDAO의 overlappedId메소드 내부에서 오류:" + e);
			e.printStackTrace();
		} finally {
			closeResource();// 자원해제
		}

		return result_;// "true" 또는 "false" 부장(MemberService)에게 반환
	}

//관리자 특정 조회   수정중
	public List<AdminVo> getMemberList(String searchWord) {

		String query =  "SELECT " +
			            "u.user_id, u.user_name, u.birthDate, u.gender, u.address, " +
			            "u.phone, u.email, u.role, a.admin_id, a.department, a.access_level " +
			            "FROM user u " +
			            "LEFT JOIN admin_info a ON u.user_id = a.user_id " +
			            "WHERE (CAST(u.user_id AS CHAR) LIKE ? OR CAST(a.admin_id AS CHAR) LIKE ? OR CAST(u.user_name AS CHAR) LIKE ?)" +
			            "AND u.user_id IS NOT NULL " +
			            "AND a.admin_id IS NOT NULL";

		List<AdminVo> memberList = new ArrayList<>();

		try {
			con = ds.getConnection();
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, "%" + searchWord + "%");
			pstmt.setString(2, "%" + searchWord + "%");
			pstmt.setString(3, "%" + searchWord + "%");

			try (ResultSet rs = pstmt.executeQuery()) {
				while (rs.next()) {
					AdminVo member = new AdminVo();

					// ResultSet에서 데이터 가져와 MemberVo에 설정
					member.setUser_id(rs.getString("user_id"));
					member.setUser_name(rs.getString("user_name"));
					member.setBirthDate(rs.getDate("birthDate"));
					member.setGender(rs.getString("gender"));
					member.setAddress(rs.getString("address"));
					member.setPhone(rs.getString("phone"));
					member.setEmail(rs.getString("email"));
					member.setRole(rs.getString("role"));
					member.setAdmin_id(rs.getString("admin_id"));
					member.setDepartment(rs.getString("department"));
					member.setAccess_level(rs.getInt("access_level"));

					// List에 추가
					memberList.add(member);
				}
			}
		} catch (SQLException e) {
			System.out.println("memberDAO의 getMemberList메서드 오류입니다. " + e);
		} finally {
			closeResource();// 자원해제
		}

		return memberList;
	}
	//관리자 전체조회
	public List<AdminVo> getAllMemberList() {
	    String query = "SELECT "
	        + "u.user_id, u.user_name, u.birthDate, u.gender, u.address, "
	        + "u.phone, u.email, u.role, a.admin_id, a.department, a.access_level "
	        + "FROM user u "
	        + "LEFT JOIN admin_info a ON u.user_id = a.user_id "
	        + "WHERE u.role = '관리자' ORDER BY a.admin_id DESC";

	    List<AdminVo> memberList = new ArrayList<>();

	    try {
	        con = ds.getConnection();
	        pstmt = con.prepareStatement(query);

	        try (ResultSet rs = pstmt.executeQuery()) {
	            while (rs.next()) {
	                AdminVo member = new AdminVo();

	                // ResultSet에서 데이터 가져와 AdminVo에 설정
	                member.setUser_id(rs.getString("user_id"));
	                member.setUser_name(rs.getString("user_name"));
	                member.setBirthDate(rs.getDate("birthDate"));
	                member.setGender(rs.getString("gender"));
	                member.setAddress(rs.getString("address"));
	                member.setPhone(rs.getString("phone"));
	                member.setEmail(rs.getString("email"));
	                member.setRole(rs.getString("role"));
	                member.setAdmin_id(rs.getString("admin_id"));
	                member.setDepartment(rs.getString("department"));
	                member.setAccess_level(rs.getInt("access_level"));

	                // List에 추가
	                memberList.add(member);
	            }
	        }
	    } catch (SQLException e) {
	        System.out.println("AdminDAO의 getAllMemberList 메서드 오류: " + e);
	    } finally {
	        closeResource();
	    }

	    return memberList;
	}

	// 관리자 삭제
	public boolean managerDelete(String admin_id) {
		
		boolean isDeleted = false;
        
		 String usersql = "DELETE FROM user WHERE user_id = (SELECT user_id FROM admin_info WHERE admin_id = ?)";
		 
        try {
 
        con = ds.getConnection();
        pstmt = con.prepareStatement(usersql);
        
     // 트랜잭션 시작
        con.setAutoCommit(false); // 수동 커밋 모드 설정
        
            pstmt.setString(1, admin_id);
            int userResult = pstmt.executeUpdate();
            
      //      isDeleted = userResult > 0;
            
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
        	e.printStackTrace();
            try {
                if (con != null) con.rollback(); // 예외 발생 시 롤백
            } catch (SQLException ex) {
            	System.out.println("memberDAO의 managerDelete메서드 오류입니다. ");
                ex.printStackTrace();
            }   
        }finally {
        	closeResource();// 자원해제
        }
        return isDeleted;
    }

	
	//관리자 수정
	public boolean updateMember(AdminVo mvo) {
	    boolean isUpdated = false;

	    String sql = "UPDATE user u "
	               + "JOIN admin_info a ON u.user_id = a.user_id "
	               + "SET "
	               + "    u.user_name = ?, "
	               + "    u.birthDate = ?, "
	               + "    u.gender = ?, "
	               + "    u.address = ?, "
	               + "    u.phone = ?, "
	               + "    u.email = ?, "
	               + "    a.admin_id = ?, "
	               + "    a.department = ?, "
	               + "    a.access_level = ? "
	               + "WHERE a.admin_id = ?";
		/* + "WHERE u.user_id = ?"; */
	    
	    Connection con = null;
	    PreparedStatement pstmt = null;

	    try {
	        con = ds.getConnection();
	        pstmt = con.prepareStatement(sql);

	        // 파라미터 설정
	        pstmt.setString(1, mvo.getUser_name());
	        pstmt.setDate(2, mvo.getBirthDate());
	        pstmt.setString(3, mvo.getGender());
	        pstmt.setString(4, mvo.getAddress());
	        pstmt.setString(5, mvo.getPhone());
	        pstmt.setString(6, mvo.getEmail());
	        pstmt.setString(7, mvo.getAdmin_id());
	        pstmt.setString(8, mvo.getDepartment());
	        pstmt.setInt(9, mvo.getAccess_level());
	        pstmt.setString(10, mvo.getAdmin_id());

	        // 업데이트 실행
	        int rowsUpdated = pstmt.executeUpdate();
	        isUpdated = rowsUpdated > 0; // 업데이트 성공 여부 확인

	    } catch (SQLException e) {
	        System.out.println("MemberDAO의 updateMember 메소드 오류");
	        e.printStackTrace();
	    } finally {
	        try {
	            if (pstmt != null) pstmt.close();
	            if (con != null) con.close();
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	    }

	    return isUpdated;
	}


	
}// MemberDAO클래스