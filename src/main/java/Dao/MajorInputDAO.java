package Dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.servlet.http.HttpServletRequest;
import javax.sql.DataSource;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import Vo.MajorVo;

public class MajorInputDAO {
	Connection con;
	PreparedStatement pstmt;
	ResultSet rs;
	DataSource ds;
	// sql 占쌔븝옙
	String sql = null;
	// 유효성 검사 결과
	private static final int SUCCESS = 1;
	private static final int FAILURE = 0;
	private static final int NONE = -1;
	private static final int EXISTS = -2;
	// 1 = 성공, 0 =실패, -1 = 없음, -2 = 있음
	int validationResult = NONE;
	// db 연결
	public MajorInputDAO() {
		try {
			Context ctx = new InitialContext();
			ds = (DataSource) ctx.lookup("java:/comp/env/jdbc/edumanager");
		} catch (Exception e) {
			System.out.println("커넥션 풀을 얻는 데 실패했습니다: " + e.toString());
		}
	}

	// 자원해제 메소드 (Connection 포함)
	private void closeDatabaseResources(Connection con, PreparedStatement pstmt, ResultSet rs) {
		try {
			if (rs != null) {
				rs.close();
			}
		} catch (Exception e) {
			System.out.println("ResultSet 자원 해제 중 오류 발생: " + e.toString());
		}

		try {
			if (pstmt != null) {
				pstmt.close();
			}
		} catch (Exception e) {
			System.out.println("PreparedStatement 자원 해제 중 오류 발생: " + e.toString());
		}

		try {
			if (con != null) {
				con.close();
			}
		} catch (Exception e) {
			System.out.println("Connection 자원 해제 중 오류 발생: " + e.toString());
		}
	}

	public int majorInputValidation(String newMajorName) {
		// db 연동
		validationResult = NONE;
		try {
			con = ds.getConnection();
			sql = "SELECT majorname FROM majorinformation WHERE majorname = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, newMajorName);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				validationResult = EXISTS;
			}
		} catch (SQLException e) {
			System.out.println("SQL 오류 발생: " + e.getMessage());
			e.printStackTrace();
		} finally {
			closeDatabaseResources(con, pstmt, rs);
		}
		// 값 반환
		return validationResult;
	}

	public int majorSearchValidationCode(String editMajorCode) {
		System.out.println("majorSearchValidationCode" + editMajorCode);
		validationResult = NONE;
		try {
			con = ds.getConnection();
			sql = "SELECT majorcode FROM majorinformation WHERE majorcode = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, String.format("%02d", Integer.parseInt(editMajorCode)));
			rs = pstmt.executeQuery();
			// 중복된 이름이 존재할 경우
			if (rs.next()) {
				validationResult = EXISTS;
				System.out.println("존재하는 학과 코드입니다.");
			}
		} catch (SQLException e) {
			System.out.println("SQL 오류 발생: " + e.getMessage());
			e.printStackTrace();
		} finally {
			closeDatabaseResources(con, pstmt, rs);
		}
		// 값 반환
		return validationResult;
	}

	public int majorSearchValidationName(String editMajorName) {
		System.out.println("majorSearchValidationName" + editMajorName);
		validationResult = NONE;
		try {
			con = ds.getConnection();
			sql = "SELECT majorname FROM majorinformation WHERE majorname = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, editMajorName);
			rs = pstmt.executeQuery();
			// 중복된 이름이 존재할 경우
			if (rs.next()) {
				validationResult = EXISTS;
				System.out.println("동일한 학과 이름이 존재합니다.");
			}
		} catch (SQLException e) {
			System.out.println("SQL 오류 발생: " + e.getMessage());
			e.printStackTrace();
		} finally {
			closeDatabaseResources(con, pstmt, rs);
		}
		// 값 반환
		return validationResult;
	}

	public int majorSearchValidationTel(String editMajorTel) {
		System.out.println("majorSearchValidationTel" + editMajorTel);
		
		validationResult = NONE;
		
		try {
			con = ds.getConnection();
			sql = "SELECT majortel FROM majorinformation WHERE majortel = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, editMajorTel);
			rs = pstmt.executeQuery();
			// 중복된 전화번호가 존재할 경우
			if (rs.next()) {
				validationResult = EXISTS;
				System.out.println("존재하는 전화번호입니다.");
			}
		} catch (SQLException e) {
			System.out.println("SQL 오류 발생: " + e.getMessage());
			e.printStackTrace();
		} finally {
			closeDatabaseResources(con, pstmt, rs);
		}
		// 값 반환
		return validationResult;
	}

	public int majorInput(String newMajorName, String newMajorTel) {
		int addResult = FAILURE;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			con = ds.getConnection();
			String sql = "insert into majorinformation (majorname, majortel) values (?, ?)";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, newMajorName);
			pstmt.setString(2, newMajorTel);
			addResult = pstmt.executeUpdate();
		} catch (SQLException e) {
			System.out.println("SQL 오류 발생: " + e.getMessage());
			e.printStackTrace();
		} finally {
			closeDatabaseResources(con, pstmt, null);
		}

		return addResult;
	}

	public ArrayList<MajorVo> searchMajor(HttpServletRequest request) {
		ArrayList<MajorVo> searchList = new ArrayList<>();
		String searchKeyWord = request.getParameter("searchMajor");

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			con = ds.getConnection();

			// 키워드가 숫자인지 확인
			boolean isNumeric = false;
			try {
				Integer.parseInt(searchKeyWord);
				isNumeric = true;
			} catch (NumberFormatException e) {
				isNumeric = false;
			}

			// 숫자일 때와 문자일 때의 쿼리 작성
			if (isNumeric) {
				// 숫자라면 majorcode로 검색
				String sql = "SELECT * FROM majorinformation WHERE majorcode = ?";
				pstmt = con.prepareStatement(sql);
				pstmt.setInt(1, Integer.parseInt(searchKeyWord));
			} else {
				// 문자라면 majorname으로 LIKE 검색
				String sql = "SELECT * FROM majorinformation WHERE majorname LIKE ?";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, "%" + searchKeyWord + "%");
			}

			rs = pstmt.executeQuery();

			while (rs.next()) {
				MajorVo vo = new MajorVo();
				vo.setMajorCode(rs.getInt("majorcode"));
				vo.setMajorName(rs.getString("majorname"));
				vo.setMajorTel(rs.getString("majortel"));
				searchList.add(vo);
			}
		} catch (SQLException e) {
			System.out.println("SQL 오류 발생: " + e.getMessage());
			e.printStackTrace();
		} finally {
			closeDatabaseResources(con, pstmt, rs);
		}

		return searchList;
	}

	public int editMajor(String editMajorCode, String editMajorName, String editMajorTel) {

		int editResult = FAILURE;

		Connection con = null;
		PreparedStatement pstmt = null;
		try {
			con = ds.getConnection();
			String sql = "UPDATE majorinformation SET majorname=?, majortel=? WHERE majorcode=?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, editMajorName);
			pstmt.setString(2, editMajorTel);
			pstmt.setString(3, String.format("%02d", Integer.parseInt(editMajorCode)));
			editResult = pstmt.executeUpdate();
		} catch (SQLException e) {
			System.out.println("SQL 오류 발생: " + e.getMessage());
			e.printStackTrace();
		} finally {
			closeDatabaseResources(con, pstmt, null);
		}
		return editResult;
	}
	
	public int editMajorTel(String editMajorCode, String editMajorTel) {

		int editResult = FAILURE;
		String sql = "UPDATE majorinformation SET majortel=? WHERE majorcode=?";
		
		Connection con = null;
		PreparedStatement pstmt = null;
		
		try {
			con = ds.getConnection();
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, editMajorTel);
			pstmt.setString(2, String.format("%02d", Integer.parseInt(editMajorCode)));
			editResult = pstmt.executeUpdate();
		} catch (SQLException e) {
			System.out.println("SQL 오류 발생: " + e.getMessage());
			e.printStackTrace();
		} finally {
			closeDatabaseResources(con, pstmt, null);
		}
		return editResult;
	}


	public int deleteMajor(String editMajorCode) {
		
		int deleteResult = FAILURE;
		Connection con = null;
		PreparedStatement pstmt = null;
		try {
			con = ds.getConnection();
			String sql = "DELETE FROM majorinformation WHERE majorcode = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, String.format("%02d", Integer.parseInt(editMajorCode)));
			deleteResult = pstmt.executeUpdate();
		} catch (SQLException e) {
			System.out.println("SQL 오류 발생: " + e.getMessage());
			e.printStackTrace();
		} finally {
			closeDatabaseResources(con, pstmt, null);
		}
		return deleteResult;
	}

	public JSONArray fetchMajor() {
		String sql = "SELECT majorcode, majorname, majortel FROM majorinformation";
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsonArray = new JSONArray();

		try {
			con = ds.getConnection();
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				JSONObject jsonObject = new JSONObject();
				jsonObject.put("majorcode", rs.getString("majorcode"));
				jsonObject.put("majorname", rs.getString("majorname"));
				jsonObject.put("majortel", rs.getString("majortel"));
				jsonArray.add(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			closeDatabaseResources(con, pstmt, null);
		}
		return jsonArray;
	}
}
