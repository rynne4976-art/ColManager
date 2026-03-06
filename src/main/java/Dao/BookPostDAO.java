package Dao;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import Vo.BookPostReplyVo;
import Vo.BookPostVo;
import Vo.BookPostVo.BookImage;

public class BookPostDAO {

	Connection con;
	PreparedStatement pstmt;
	ResultSet rs;
	DataSource ds;

	public BookPostDAO() {
		try {
			Context ctx = new InitialContext();
			ds = (DataSource) ctx.lookup("java:/comp/env/jdbc/edumanager"); // 데이터베이스 커넥션 풀 초기화
		} catch (Exception e) {
			System.out.println("커넥션풀 얻기 실패 : " + e.toString());
		}
	}

	// 자원 해제 메서드
	private void closeResource() {
		try {
			if (rs != null)
				rs.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		try {
			if (pstmt != null)
				pstmt.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		try {
			if (con != null)
				con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	// ===============================================================================
	// 중고책 거래=======================================================================
	// ===============================================================================

	// 학과 정보 받아오기
	public List<BookPostVo> majorInfo() {

		List<BookPostVo> majorInfo = new ArrayList<BookPostVo>();
		String sqlMajorInfo = "SELECT majorname FROM majorinformation";

		try {
			con = ds.getConnection();
			pstmt = con.prepareStatement(sqlMajorInfo);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				String major = rs.getString("majorname");
				BookPostVo majorTag = new BookPostVo(major);
				majorInfo.add(majorTag);
			}
		} catch (Exception e) {
			System.out.println("BookPostDAO의 majorInfo메소드에서 오류");
			e.printStackTrace();
		} finally {
			closeResource();
		}
		return majorInfo;
	}

	public void bookPostUpload(BookPostVo bookPostVo) {
		String sqlInsertPost = "INSERT INTO book_post (user_id, post_title, post_content, major_tag, created_at) VALUES (?, ?, ?, ?, NOW())";
		String sqlInsertImage = "INSERT INTO book_image (post_id, file_name, image_path) VALUES (?, ?, ?)";

		// 프로퍼티 파일 로드
		Properties properties = new Properties();
		try (InputStream input = getClass().getClassLoader().getResourceAsStream("config.properties")) {
			if (input == null) {
				throw new FileNotFoundException("프로퍼티 파일을 찾을 수 없습니다.");
			}
			properties.load(input);
		} catch (IOException ex) {
			ex.printStackTrace();
			return;
		}

		// 업로드 디렉토리 설정
		String uploadDir = properties.getProperty("upload.dir");
		if (uploadDir == null || uploadDir.isEmpty()) {
			throw new IllegalArgumentException("업로드 디렉토리가 설정되지 않았습니다.");
		}

		try {
			// 데이터베이스 연결 및 트랜잭션 시작
			con = ds.getConnection();
			con.setAutoCommit(false);

			// 1. book_post 테이블에 게시글 저장
			pstmt = con.prepareStatement(sqlInsertPost, PreparedStatement.RETURN_GENERATED_KEYS);
			pstmt.setString(1, bookPostVo.getUserId());
			pstmt.setString(2, bookPostVo.getPostTitle());
			pstmt.setString(3, bookPostVo.getPostContent());
			pstmt.setString(4, bookPostVo.getMajorTag());
			pstmt.executeUpdate();

			// 생성된 post_id 가져오기
			rs = pstmt.getGeneratedKeys();
			int postId = 0;
			if (rs.next()) {
				postId = rs.getInt(1);
				bookPostVo.setPostId(postId); // VO 객체에 postId 설정
			} else {
				throw new SQLException("게시글 삽입 실패, 게시글 ID를 가져올 수 없습니다.");
			}

			// 2. book_image 테이블에 이미지 정보 저장
			pstmt = con.prepareStatement(sqlInsertImage);
			for (BookPostVo.BookImage image : bookPostVo.getImages()) {
				String fileName = image.getFileName();
				String uploadTime = String.valueOf(System.currentTimeMillis());
				String uniqueFileName = uploadTime + "_" + fileName;
				String imagePath = uploadDir + "/" + postId + "/" + uniqueFileName;

				// VO의 BookImage 객체에 uniqueFileName과 imagePath 설정
				image.setFileName(uniqueFileName); // 파일명을 uniqueFileName으로 변경
				image.setImage_path(imagePath);

				pstmt.setInt(1, postId);
				pstmt.setString(2, uniqueFileName);
				pstmt.setString(3, imagePath);
				pstmt.executeUpdate();
			}

			// 트랜잭션 커밋
			con.commit();
		} catch (SQLException e) {
			e.printStackTrace();
			try {
				if (con != null) {
					con.rollback(); // 오류 발생 시 트랜잭션 롤백
				}
			} catch (SQLException rollbackEx) {
				rollbackEx.printStackTrace();
			}
		} finally {
			try {
				if (con != null && !con.getAutoCommit()) {
					con.setAutoCommit(true); // 자동 커밋 모드 복구
				}
			} catch (SQLException e) {
				e.printStackTrace();
			} finally {
				// 리소스 해제
				closeResource();
			}
		}
	}

	public void bookPostUpdate(BookPostVo bookPostVo) {
		String sqlUpdatePost = "UPDATE book_post SET user_id = ?, post_title = ?, post_content = ?, major_tag = ? WHERE post_id = ?";
		String sqlDeleteImages = "DELETE FROM book_image WHERE post_id = ?";
		String sqlInsertImage = "INSERT INTO book_image (post_id, file_name, image_path) VALUES (?, ?, ?)";

		// Load properties
		Properties properties = new Properties();
		try (InputStream input = getClass().getClassLoader().getResourceAsStream("config.properties")) {
			if (input == null) {
				throw new FileNotFoundException("Cannot find config.properties file.");
			}
			properties.load(input);
		} catch (IOException ex) {
			ex.printStackTrace();
			return;
		}

		// Get upload directory
		String uploadDir = properties.getProperty("upload.dir");
		if (uploadDir == null || uploadDir.isEmpty()) {
			throw new IllegalArgumentException("Upload directory is not set.");
		}

		try {
			// Get database connection and start transaction
			con = ds.getConnection();
			con.setAutoCommit(false);

			int postId = bookPostVo.getPostId();
			if (postId == 0) {
				throw new IllegalArgumentException("Post ID is missing. Cannot update post.");
			}

			// Update the existing post
			pstmt = con.prepareStatement(sqlUpdatePost);
			pstmt.setString(1, bookPostVo.getUserId());
			pstmt.setString(2, bookPostVo.getPostTitle());
			pstmt.setString(3, bookPostVo.getPostContent());
			pstmt.setString(4, bookPostVo.getMajorTag());
			pstmt.setInt(5, postId);
			pstmt.executeUpdate();

			// Delete existing images for the post
			pstmt = con.prepareStatement(sqlDeleteImages);
			pstmt.setInt(1, postId);
			pstmt.executeUpdate();

			// Insert new images
			pstmt = con.prepareStatement(sqlInsertImage);
			for (BookPostVo.BookImage image : bookPostVo.getImages()) {
				String fileName = image.getFileName();
				String uploadTime = String.valueOf(System.currentTimeMillis());
				String uniqueFileName = uploadTime + "_" + fileName;
				String imagePath = uploadDir + "/" + postId + "/" + uniqueFileName;

				// Update the image object with the new file name and path
				image.setFileName(uniqueFileName);
				image.setImage_path(imagePath);

				pstmt.setInt(1, postId);
				pstmt.setString(2, uniqueFileName);
				pstmt.setString(3, imagePath);
				pstmt.executeUpdate();
			}

			// Commit the transaction
			con.commit();
		} catch (SQLException e) {
			e.printStackTrace();
			try {
				if (con != null) {
					con.rollback(); // Roll back the transaction in case of error
				}
			} catch (SQLException rollbackEx) {
				rollbackEx.printStackTrace();
			}
		} finally {
			try {
				if (con != null && !con.getAutoCommit()) {
					con.setAutoCommit(true); // Restore auto-commit mode
				}
			} catch (SQLException e) {
				e.printStackTrace();
			} finally {
				// Release resources
				closeResource();
			}
		}
	}

	// 모든 게시글 조회
	public List<BookPostVo> booklistboard() {

		String sqlbooklist = "SELECT bp.post_id, bp.user_id, bp.post_title, bp.major_tag, bp.created_at FROM book_post bp ORDER BY bp.post_id DESC";
		List<BookPostVo> bookBoardList = new ArrayList<BookPostVo>();

		try {
			con = ds.getConnection();
			pstmt = con.prepareStatement(sqlbooklist);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				int postId = rs.getInt("post_id");
				String userId = rs.getString("user_id");
				String postTitle = rs.getString("post_title");
				String majorTag = rs.getString("major_tag");
				Timestamp createdAt = rs.getTimestamp("created_at");
				// 게시물 정보 생성
				BookPostVo BoardList = new BookPostVo(postId, userId, postTitle, majorTag, createdAt);
				bookBoardList.add(BoardList);
			}
		} catch (Exception e) {
			System.out.println("BookPostDAO의 booklistboard 메소드 오류");
			e.printStackTrace();
		} finally {
			closeResource(); // 리소스 정리
		}

		return bookBoardList;
	}

	// content 포함 조회
	public BookPostVo bookPost(int postId) {

		String sqlbookpost = "SELECT bp.post_id, bp.user_id, bp.post_title, bp.post_content, bp.major_tag, bp.created_at, GROUP_CONCAT(bi.file_name) AS file_names, GROUP_CONCAT(bi.image_path) AS image_paths FROM book_post bp LEFT JOIN book_image bi ON bp.post_id = bi.post_id WHERE bp.post_id = ? GROUP BY bp.post_id;";

		BookPostVo bookPost = new BookPostVo();

		try {
			con = ds.getConnection();
			pstmt = con.prepareStatement(sqlbookpost);
			pstmt.setInt(1, postId);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				postId = rs.getInt("post_id");
				String userId = rs.getString("user_id");
				String postTitle = rs.getString("post_title");
				String postContent = rs.getString("post_content");
				String majorTag = rs.getString("major_tag");
				Timestamp createdAt = rs.getTimestamp("created_at");
				String fileNameList = rs.getString("file_names");
				String image_pathList = rs.getString("image_paths");

				List<BookImage> images = new ArrayList<>();

				if (fileNameList != null && image_pathList != null) {
					String[] fileNames = fileNameList.split(",");
					String[] imagePaths = image_pathList.split(",");

					for (int i = 0; i < fileNames.length; i++) {
						String fileName = fileNames[i].trim();
						String imagePath = imagePaths[i].trim();
						BookImage image = new BookImage(fileName, imagePath);
						images.add(image);
					}
				}
				// BookPostVo 객체를 생성합니다.
				bookPost = new BookPostVo(postId, userId, postTitle, postContent, majorTag, createdAt, images);
			}
		} catch (Exception e) {
			System.out.println("BookPostDAO의 bookPost 메소드 오류");
			e.printStackTrace();
		} finally {
			closeResource(); // 리소스 정리
		}

		return bookPost;
	}

	// 검색
	public List<BookPostVo> bookserchList(String key, String word) {

		String sqlbooklist = null;
		ArrayList<BookPostVo> bookBoardList = new ArrayList<>();

		if (!word.equals("")) {
			if (key.equals("titleContent")) {
				sqlbooklist = "SELECT * FROM book_post WHERE post_title LIKE ? OR post_content LIKE ? ORDER BY post_id DESC";
			} else {
				sqlbooklist = "SELECT * FROM book_post WHERE user_id LIKE ? ORDER BY post_id DESC";
			}
		} else {
			sqlbooklist = "SELECT * FROM book_post ORDER BY post_id DESC";
		}

		try {
			con = ds.getConnection();
			pstmt = con.prepareStatement(sqlbooklist);

			if (!word.equals("")) {
				if (key.equals("titleContent")) {
					pstmt.setString(1, "%" + word + "%");
					pstmt.setString(2, "%" + word + "%");
				} else {
					pstmt.setString(1, "%" + word + "%");
				}
			}

			rs = pstmt.executeQuery();

			while (rs.next()) {
				int postId = rs.getInt("post_id");
				String userId = rs.getString("user_id");
				String postTitle = rs.getString("post_title");
				String majorTag = rs.getString("major_tag");
				Timestamp createdAt = rs.getTimestamp("created_at");
				// 게시물 정보 생성
				BookPostVo BoardList = new BookPostVo(postId, userId, postTitle, majorTag, createdAt);
				bookBoardList.add(BoardList);
			}
		} catch (Exception e) {
			System.out.println("bookpostDAO의 bookserchList메소드에서 오류");
			e.printStackTrace();
		} finally {
			closeResource();
		}
		return bookBoardList;
	}

	public int bookPostDelete(String postId) {
		int result = 0;
		String deleteImagesSQL = "DELETE FROM book_image WHERE post_id = ?";
		String deletePostSQL = "DELETE FROM book_post WHERE post_id = ?";
		String selectImagesSQL = "SELECT image_path FROM book_image WHERE post_id = ?"; // 파일 삭제를 위한 이미지 경로 조회

		List<String> imagePaths = new ArrayList<>();

		try {
			con = ds.getConnection();
			con.setAutoCommit(false); // 트랜잭션 시작

			// 1. 이미지 경로 조회 (파일 삭제를 위해)
			pstmt = con.prepareStatement(selectImagesSQL);
			pstmt.setInt(1, Integer.parseInt(postId));
			rs = pstmt.executeQuery();

			while (rs.next()) {
				imagePaths.add(rs.getString("image_path"));
			}
			rs.close();
			pstmt.close();

			// 2. book_image 테이블에서 삭제
			pstmt = con.prepareStatement(deleteImagesSQL);
			pstmt.setInt(1, Integer.parseInt(postId));
			pstmt.executeUpdate();
			pstmt.close();

			// 3. book_post 테이블에서 삭제
			pstmt = con.prepareStatement(deletePostSQL);
			pstmt.setInt(1, Integer.parseInt(postId));
			result = pstmt.executeUpdate();
			pstmt.close();

			con.commit(); // 트랜잭션 커밋

			// 4. 파일 시스템에서 이미지 파일 삭제 (선택 사항)
			for (String path : imagePaths) {
				File imageFile = new File(path);
				if (imageFile.exists()) {
					if (!imageFile.delete()) {
						System.out.println("이미지 파일 삭제 실패: " + path);
						// 필요 시, 로그를 남기거나 추가 처리를 할 수 있습니다.
					} else {
						System.out.println("이미지 파일 삭제 성공: " + path);
					}
				}
			}

		} catch (NumberFormatException e) {
			System.out.println("Invalid postId format: " + postId);
			try {
				if (con != null)
					con.rollback();
			} catch (SQLException ex) {
				ex.printStackTrace();
			}
		} catch (SQLException e) {
			System.out.println("SQL Exception occurred while deleting post: " + e.toString());
			try {
				if (con != null)
					con.rollback();
			} catch (SQLException ex) {
				ex.printStackTrace();
			}
		} finally {
			try {
				if (con != null) {
					con.setAutoCommit(true); // 원래 상태로 복구
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
			closeResource();
		}

		return result;
	}

	//댓글 입력
	public void bookReplyUpload(BookPostReplyVo replyVo) {
		String sqlInsertReply = "INSERT INTO book_reply (user_id, post_id, reply_content, replytimeAt) VALUES (?, ?, ?, NOW())";

		try {
			// 데이터베이스 연결
			con = ds.getConnection();

			// 1. book_post 테이블에 게시글 저장
			pstmt = con.prepareStatement(sqlInsertReply);
			pstmt.setString(1, replyVo.getUserId());
			pstmt.setInt(2, replyVo.getPostId());
			pstmt.setString(3, replyVo.getReplyContent());
			pstmt.executeUpdate();

		} catch (SQLException e) {
			System.out.println("BookPostDAO의 bookReplyUpload method에서 오류!" + e);
		} finally {
			closeResource();
		}
	}
	//댓글 저장
	public List<BookPostReplyVo> bookPostReplies(int postId) {
	    List<BookPostReplyVo> replies = new ArrayList<>();
	    String sqlSelectReply = "SELECT reply_id, user_id, reply_content, replytimeAt FROM book_reply WHERE post_id=? ORDER BY replytimeAt DESC;";
	    
	    try {
	        con = ds.getConnection(); // 데이터베이스 연결 초기화
	        pstmt = con.prepareStatement(sqlSelectReply);
	        pstmt.setInt(1, postId);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            int replyId = rs.getInt("reply_id");
	            String userId = rs.getString("user_id");
	            String replyContent = rs.getString("reply_content");
	            Timestamp replytimeAt = rs.getTimestamp("replytimeAt");
	            BookPostReplyVo reply = new BookPostReplyVo(replyId, userId, replyContent, replytimeAt);
	            
	            System.out.println("Reply ID: " + replyId);
	            System.out.println("User ID: " + userId);
	            System.out.println("Content: " + replyContent);
	            System.out.println("Reply Time: " + replytimeAt);
	            
	            replies.add(reply);
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    } finally {
	        closeResource(); // 자원 해제
	    }
	    return replies;
	}

	

    // 댓글 삭제
	public void bookReplyDelete(int replyId) {
	    String sql = "DELETE FROM book_reply WHERE reply_id = ?";
	    try (Connection con = ds.getConnection(); 
	         PreparedStatement pstmt = con.prepareStatement(sql)) {
	        pstmt.setInt(1, replyId);
	        pstmt.executeUpdate();
	    } catch (SQLException e) {
	        e.printStackTrace();
	    } finally {
	    	closeResource();
	    }
	}

	// 댓글 수정
	public void bookReplyUpdate(int replyId, String replyContent) {
		
		String sqlUpdateReply = "UPDATE book_reply SET reply_content = ?, replytimeAt = NOW() WHERE reply_id = ?";
		
        try {
            con = ds.getConnection();
            pstmt = con.prepareStatement(sqlUpdateReply);
            pstmt.setString(1, replyContent);
            pstmt.setInt(2, replyId);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResource();
        }
        
    }
	
	/*
	 * // 댓글 수정 public boolean bookupdateReply(int replyId, String replyContent) {
	 * String sqlUpdateReply =
	 * "UPDATE book_reply SET reply_content = ?, replytimeAt = NOW() WHERE reply_id = ?"
	 * ; boolean isUpdated = false;
	 * 
	 * try { con = ds.getConnection(); pstmt = con.prepareStatement(sqlUpdateReply);
	 * pstmt.setString(1, replyContent); // 수정된 댓글 내용 pstmt.setInt(2, replyId); //
	 * 댓글 ID int result = pstmt.executeUpdate(); // 쿼리 실행
	 * 
	 * if (result > 0) { isUpdated = true; } } catch (SQLException e) {
	 * e.printStackTrace(); } finally { closeResource(); // 자원 해제 } return
	 * isUpdated; }
	 */

}
