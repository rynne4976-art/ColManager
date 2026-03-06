package Dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import Vo.BoardVo;
import Vo.ClassroomBoardVo;
import Vo.MemberVo;

public class ClassroomBoardDAO {

	Connection con;
	PreparedStatement pstmt;
	ResultSet rs;
	DataSource ds;
	
	//컨넥션풀 얻는 생성자
	public ClassroomBoardDAO() {
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
	
	//전체 공지사항 목록 조회
	public ArrayList<ClassroomBoardVo> noticeList(String course_id, String user_name) {
		String sql = null;
		
		ArrayList<ClassroomBoardVo> list = new ArrayList<ClassroomBoardVo>();
		
		try {
			con = ds.getConnection();//DB연결
			sql = "select cn.notice_id, cn.b_group, cn.b_level, cn.author_id, u.user_name, cn.title, cn.content, cn.created_date "
					+ "from classroom_notice cn "
					+ "join user u on cn.author_id = u.user_id "
					+ "where cn.course_id = ? "
					+ "order by cn.b_group asc, cn.notice_id desc ";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, course_id);
			
			rs = pstmt.executeQuery();
			
			//조회된 ResultSet의 정보를 레코드 단위로 얻어서 
			//BoardVo객체에 레코드 정보를 반복해서 저장하고 
			//BoardVo객체들을 ArrayList배열에 반복해서  추가
			while(rs.next()) {
				ClassroomBoardVo vo = new ClassroomBoardVo();
						
				vo.setNotice_id(rs.getInt("notice_id"));
				vo.setB_group( rs.getInt("b_group"));
				vo.setB_level( rs.getInt("b_level"));
				vo.setAuthor_id( rs.getString("author_id"));
				vo.setTitle( rs.getString("title"));
				vo.setContent( rs.getString("content"));
				vo.setCreated_date(rs.getDate("created_date"));
				
				MemberVo memvo = new MemberVo();
				
				memvo.setUser_name(rs.getString("user_name"));
				vo.setUserName(memvo);
				
				list.add(vo);			
			}						
		} catch (Exception e) {
			System.out.println("ClassroomBoardDAO의 noticeList메소드에서 오류 ");
			e.printStackTrace();
		} finally {
			closeResource();
		}	
		return list;
	}

	public ClassroomBoardVo noticeRead(String notice_id) {
		
		ClassroomBoardVo vo = null;
		String sql = null;
		
		try {
			con = ds.getConnection();
			sql = "select cn.notice_id, cn.b_group, cn.b_level, cn.author_id, u.user_name, cn.title, cn.content, cn.created_date "
					+ "from classroom_notice cn "
					+ "join user u on cn.author_id = u.user_id "
					+ "where notice_id=?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1,  Integer.parseInt(notice_id));
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				//ResultSet에서 조회된 레코드의 모든 열값을 얻어
				//BoardVo객체 생성후 각변수에 저장
				vo = new ClassroomBoardVo(rs.getInt("notice_id"),
						 rs.getInt("b_group"),
						 rs.getInt("b_level"),
						 rs.getString("author_id"),
						 rs.getString("title"), 
						 rs.getString("content"), 
						 rs.getDate("created_date"));
				MemberVo memvo = new MemberVo();
				memvo.setUser_name(rs.getString("user_name"));
				
				vo.setUserName(memvo);
				
			}
		} catch (Exception e) {
			System.out.println("ClassroomBoardDAO의 noticeRead메소드");
			e.printStackTrace();
		} finally {
			closeResource();
		}
		
		return vo;
	}

	public int insertBoard(ClassroomBoardVo vo) {
		
		int result = 0;
		String sql = null;
		
		try {
			  con = ds.getConnection(); //DB연결
			  
			  //주글 insert 규칙2. 두번째 글부터 추가되는 글들의 pos(b_group)를 1증가 시킨다.
			  sql = "update classroom_notice set b_group = b_group + 1";
			  pstmt = con.prepareStatement(sql);
			  pstmt.executeUpdate();
			  
			  sql = "INSERT INTO classroom_notice (title, content, created_date, author_id, course_id, b_group, b_level)"
			           + " VALUES (?, ?, NOW(), ?, ?, 0, 0)";
			  
			  pstmt = con.prepareStatement(sql);
			  pstmt.setString(1, vo.getTitle());
			  pstmt.setString(2, vo.getContent());
			  pstmt.setString(3, vo.getAuthor_id());
			  pstmt.setString(4, vo.getCourse_id());
			  
			  result = pstmt.executeUpdate();//insert 성공하면 1 반환 실패하면 0반환
			  
		}catch(Exception e) {
			System.out.println("ClassroomBoardDAO의 insertBoard메소드");
			e.printStackTrace();
		}finally {
			closeResource();
		}
		
		return result; // 1  또는 0을 반환(리턴) BoardService에게 

	}

	public ArrayList boardKeyWord(String key, String word, String course_id) {
		
		String sql = null;
		
		ArrayList list = new ArrayList();
		
		//검색어를 입력했다면?
		if(!word.equals("")) {
			
			//검색기준열의 값  제목+내용 선택했다면?
			if(key.equals("titleContent")) {
				
				sql = "select cn.notice_id, cn.b_group, cn.b_level, cn.author_id, cn.title, cn.content, cn.created_date, u.user_name "
					+ "from classroom_notice cn "
					+ "join user u on cn.author_id = u.user_id "
					+ "where (cn.title like  '%"+word+"%' "
					+ "OR cn.content like '%"+word+"%') "
					+ "and cn.course_id = ? "
					+ "order by cn.b_group asc";
				
			}else {//검색기준열의 값 작성자 선택했다면?
				
				sql = "select cn.notice_id, cn.b_group, cn.b_level, cn.author_id, cn.title, cn.content, cn.created_date, u.user_name "
					+ "from classroom_notice cn "
					+ "join user u on cn.author_id = u.user_id "
				    + " where u.user_name like '%"+word+"%' "
				    + " and cn.course_id = ? "
				    + "order by cn.b_group asc";
			} 
					
		}else {//검색어를 입력하지 않았다면?
			//모든 글의 열목록 조회
			sql = "select cn.notice_id, cn.b_group, cn.b_level, cn.author_id, cn.title, cn.content, cn.created_date, u.user_name "
					+ "from classroom_notice cn "
					+ "join user u on cn.author_id = u.user_id "
					+ "where cn.course_id = ? "
					+ "order by cn.b_group asc";
			
		}
		
		try {
			con = ds.getConnection();//DB연결
			
			pstmt = con.prepareStatement(sql);
			
	        pstmt.setString(1, course_id); // course_id

			rs = pstmt.executeQuery();
			
			//조회된 ResultSet의 정보를 레코드 단위로 얻어서 
			//BoardVo객체에 레코드 정보를 반복해서 저장하고 
			//BoardVo객체들을 ArrayList배열에 반복해서  추가
			while(rs.next()) {
				ClassroomBoardVo vo = new ClassroomBoardVo();
						
				vo.setNotice_id(rs.getInt("notice_id"));
				vo.setB_group( rs.getInt("b_group"));
				vo.setB_level( rs.getInt("b_level"));
				vo.setAuthor_id( rs.getString("author_id"));
				vo.setTitle( rs.getString("title"));
				vo.setContent( rs.getString("content"));
				vo.setCreated_date(rs.getDate("created_date"));
				
				MemberVo memvo = new MemberVo();
				
				memvo.setUser_name(rs.getString("user_name"));
				vo.setUserName(memvo);
				
				list.add(vo);			
			}			
			
			
		} catch (Exception e) {
			System.out.println("ClassroomBoardDAO의 boardKeyWord메소드 ");
			e.printStackTrace();
		} finally {
			closeResource();
		}
		
		return list; //ClassroomBoardService부장에게 리턴(보고)	
	}

	public int updateBoard(String notice_id_2, String title_, String content_) {
		
		int result = 0;
		
		try {
			con = ds.getConnection();
			
			String sql = "update classroom_notice set title=?, content=? where notice_id=? ";
			
			pstmt = con.prepareStatement(sql);
			
			pstmt.setString(1, title_);
			pstmt.setString(2, content_);
			pstmt.setInt(3, Integer.parseInt(notice_id_2));
			
			result = pstmt.executeUpdate();
			
		} catch (Exception e) {
			System.out.println("ClassroomBoardDAO의 updateBoard 메소드 오류 ");
			e.printStackTrace();
		}finally {
			closeResource();
		}
		
		return result;
	}

	public String deleteBoard(String delete_notice_id) {
		//"삭제성공" 또는 "삭제실패" 메세지 저장할 변수
		String result = null;
		
		try {
			con = ds.getConnection();
			//Board테이블의 b_idx열(글번호가 저장되는 열)의 값이 매개변수로 전달받은 글번호와 같으면?
			//글번호가 저장된 행(글 하나의 정보 레코드)삭제 
			String sql = "DELETE FROM classroom_notice";
				   sql += " WHERE notice_id=?";
							/*
							DELETE FROM 테이블 명
							WHERE 조건
							*/
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, Integer.parseInt(delete_notice_id));
			
			int val = pstmt.executeUpdate();
			
			if(val == 1)  result = "삭제성공";
			else result = "삭제실패";
			
		} catch (Exception e) {
			System.out.println("ClassroomBoardDAO의 deleteBoard메소드");
			e.printStackTrace();
		} finally {
			closeResource();
		}
		return result;
	}

	public void replyInsertBoard(String super_notice_id, String reply_writer, String reply_title, String reply_content,
			String reply_id, String course_id) {
		String sql = null;
		try {
		    con = ds.getConnection();

		    // 부모 글 정보 조회
		    sql = "SELECT b_group, b_level FROM classroom_notice WHERE notice_id=?";
		    pstmt = con.prepareStatement(sql);
		    pstmt.setInt(1, Integer.parseInt(super_notice_id));
		    rs = pstmt.executeQuery();
		    rs.next();
		    int b_group = rs.getInt("b_group");
		    int b_level = rs.getInt("b_level");

		    // b_group 업데이트
		    sql = "UPDATE classroom_notice SET b_group = b_group + 1 WHERE b_group > ?";
		    pstmt = con.prepareStatement(sql);
		    pstmt.setInt(1, b_group);
		    pstmt.executeUpdate();

		    
		    // 답변글 삽입
		    sql = "insert into classroom_notice(title, content, created_date, author_id, course_id, b_group, b_level)"
		          + " values(?,?,NOW(),?,?,?,?)";
		    pstmt = con.prepareStatement(sql);
		    pstmt.setString(1, reply_title);
		    pstmt.setString(2, reply_content);
		    pstmt.setString(3, reply_id);
		    pstmt.setString(4, course_id);
		    pstmt.setInt(5, b_group + 1);
		    pstmt.setInt(6, b_level + 1);
		    pstmt.executeUpdate();

		    

			} catch (Exception e) {
				System.out.println("ClassroomBoardDAO의 replyInsertBoard메소드");
				e.printStackTrace();
			} finally {
			    closeResource();
			}
	}

}
