package Dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import Vo.SubmissionVo;

public class SubmissionDAO {

	Connection con;
	PreparedStatement pstmt;
	ResultSet rs;
	DataSource ds;
		
	//컨넥션풀 얻는 생성자
	public SubmissionDAO() {
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

	//----------
	// 학생이 제출한 과제를 DB에 등록하기 위한 함수
	public int saveSubmission(String assignmentId, String studentId) {

		 int submissionId = 0;

		    try {
		        con = ds.getConnection();

		        // SQL 쿼리 실행
		        String sql = "INSERT INTO submission (assignment_id, student_id) VALUES (?, ?)";
		        pstmt = con.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);

		        pstmt.setInt(1, Integer.parseInt(assignmentId)); 
		        pstmt.setString(2, studentId); 

		        pstmt.executeUpdate();

		        // 자동 생성된 키(submission_id) 가져오기
		        rs = pstmt.getGeneratedKeys();
		        if (rs.next()) {
		            submissionId = rs.getInt(1);
		        }
		    } catch (Exception e) {
		        System.out.println("SubmissionDAO의 saveSubmission 메소드에서 오류");
		        e.printStackTrace();
		    } finally {
		        closeResource();
		    }

		    return submissionId;
	}

	//----------
	// 학생이 제출한 파일을 관리하기 위해 DB 연결
	public int saveFile(int submissionId, String filePath, String originalName) {
		
		int result = 0;
		
		String query = "INSERT INTO submission_file (submission_id, file_name, original_name) VALUES (?, ?, ?)";

	    try {

	        con = ds.getConnection();
	    	
	        pstmt = con.prepareStatement(query);
	        pstmt.setInt(1, submissionId);   // 제출 ID (submission 테이블의 FK)
	        pstmt.setString(2, filePath);    // 파일 저장 경로
	        pstmt.setString(3, originalName); // 원본 파일 이름
	        
	        result = pstmt.executeUpdate();
	        
	        return result;
	        
	    } catch (Exception e) {
	        System.out.println("SubmissionDAO의 saveFile 메소드에서 오류");
	        e.printStackTrace();
	    } finally {
	        closeResource();
	    }
	    
	    return result;
		
	}

	//----------
	// 학생이 제출한 과제(파일)을 조회하기 위해 DB 연결
	public SubmissionVo getSubmissions(String studentId, String assignmentId) {
		SubmissionVo submissions = null;
		
	    String sql = "SELECT s.submission_id, s.assignment_id, s.student_id, s.submitted_date, sf.file_id, sf.file_name, sf.original_name " +
	                 "FROM submission s " +
	                 "LEFT JOIN submission_file sf ON s.submission_id = sf.submission_id " +
	                 "WHERE s.student_id = ? AND s.assignment_id=?";

	    try {
	        con = ds.getConnection();
	        pstmt = con.prepareStatement(sql);
	        pstmt.setString(1, studentId);
	        pstmt.setInt(2, Integer.parseInt(assignmentId));
	        rs = pstmt.executeQuery();
	        
	        while (rs.next()) {
	            submissions = new SubmissionVo();
	            submissions.setFileId(rs.getInt("file_id"));
	            submissions.setSubmissionId(rs.getInt("submission_id"));
	            submissions.setSubmittedDate(rs.getTimestamp("submitted_date"));
	            submissions.setFileName(rs.getString("file_name"));
	            submissions.setOriginalName(rs.getString("original_name"));
	        }
	    } catch (Exception e) {
	    	System.out.println("SubmissionDAO의 getSubmissions 메소드에서 오류");
	        e.printStackTrace();
	    } finally {
	        closeResource();
	    }
	    return submissions;
	}

	//----------
	// 학생이 제출한 파일의 정보를 조회하기 위해 DB 연결
	public SubmissionVo getFileById(String fileId) {
		SubmissionVo fileData = null;
	    String sql = "SELECT * FROM submission_file WHERE file_id = ?";
	
	    try {
	        con = ds.getConnection();
	        pstmt = con.prepareStatement(sql);
	        pstmt.setString(1, fileId);
	        rs = pstmt.executeQuery();
	
	        if (rs.next()) {
	            fileData = new SubmissionVo();
	            fileData.setFileId(rs.getInt("file_id"));
	            fileData.setSubmissionId(rs.getInt("submission_id"));
	            fileData.setFileName(rs.getString("file_name"));
	            fileData.setOriginalName(rs.getString("original_name"));
	        }
	    } catch (Exception e) {
	    	System.out.println("SubmissionDAO의 getFileById 메소드에서 오류");
	        e.printStackTrace();
	    } finally {
	        closeResource();
	    }
	
	    return fileData;
	}

	//----------
	// 학생이 제출한 과제(파일)을 삭제하기 위해 DB 연결
	public int deleteFile(String fileId, int submission_id) {
		
		String sql = "DELETE FROM submission_file WHERE file_id = ?";
		String sumission_sql = "DELETE FROM submission WHERE submission_id = ?";
		int result = 0;
		
	    try {
	        con = ds.getConnection();
	        
	        // 1. submission_file 테이블에서 삭제
	        pstmt = con.prepareStatement(sql);
	        pstmt.setString(1, fileId);
	        result = pstmt.executeUpdate();
	        
	        // 2. submission 테이블에서 삭제
	        pstmt = con.prepareStatement(sumission_sql);
	        pstmt.setInt(1, submission_id);
	        result += pstmt.executeUpdate();
	
	        return result;
	        
	    } catch (Exception e) {
	    	System.out.println("SubmissionDAO의 deleteFile 메소드에서 오류");
	        e.printStackTrace();
	    } finally {
	        closeResource();
	    }

        return result;
	}
	
}
