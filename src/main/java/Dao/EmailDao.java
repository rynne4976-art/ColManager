package Dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

// DB와 연결하여 이메일 관련 데이터를 조회하는 클래스
public class EmailDao {

	Connection con;
	PreparedStatement pstmt;
	ResultSet rs;
	DataSource ds;

	// 커넥션 풀 얻는 생성자
	public EmailDao() {
		try {
			Context ctx = new InitialContext();
			ds = (DataSource) ctx.lookup("java:/comp/env/jdbc/edumanager");
		} catch (Exception e) {
			System.out.println("EmailDao 커넥션풀 얻기 실패 : " + e);
		}
	}

	// 자원 해제
	private void closeResource() {
		try {
			if (rs    != null) rs.close();
			if (pstmt != null) pstmt.close();
			if (con   != null) con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// =====================================================================
	// user_id로 해당 사용자의 이메일 주소 조회
	// → user 테이블의 email 컬럼 값을 반환
	public String getEmailByUserId(String userId) {

		String email = null;
		String query = "SELECT email FROM user WHERE user_id = ?";

		try {
			con   = ds.getConnection();
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, userId);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				email = rs.getString("email");
			}

		} catch (SQLException e) {
			System.err.println("EmailDao.getEmailByUserId() 오류: " + e.getMessage());
			e.printStackTrace();
		} finally {
			closeResource();
		}

		return email; // 조회 실패 시 null 반환
	}

} // EmailDao 클래스
