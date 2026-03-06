<%@page import="Vo.BookPostReplyVo"%>
<%@page import="java.io.IOException"%>
<%@page import="java.io.FileNotFoundException"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.util.Properties"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Vo.BookPostVo.BookImage"%>
<%@page import="java.sql.Timestamp"%>
<%@ page import="Vo.BookPostVo"%>
<%@ page import="Vo.MemberVo"%>
<%@ page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%
	request.setCharacterEncoding("utf-8");
	String contextPath = request.getContextPath();

	MemberVo memberVo = new MemberVo();
	String userId = (String) session.getAttribute("id");

	// vo객체 반환
	BookPostVo bookPost = (BookPostVo) request.getAttribute("bookPost");
	List<BookPostVo> majorInfo = (List<BookPostVo>) request.getAttribute("majorInfo");
	List<BookPostReplyVo> replies = (List<BookPostReplyVo>) request.getAttribute("replies");

	if (bookPost == null) {
		// 객체가 없을 경우 처리
		out.println("게시글 정보를 불러올 수 없습니다.");
		return;
	}

	// vo 해제
	int postId = bookPost.getPostId();
	String postUserId = bookPost.getUserId();
	String postTitle = bookPost.getPostTitle();
	String postContent = bookPost.getPostContent();
	String majorTag = bookPost.getMajorTag();
	Timestamp createdAt = bookPost.getCreatedAt();
	List<BookImage> images = bookPost.getImages();

	// 이미지 리스트 생성
	List<BookImage> displayImages = new ArrayList<>();
	if (images != null) {
		for (int i = 0; i < images.size() && i < 5; i++) {
			displayImages.add(images.get(i));
		}
	}

	// 프로퍼티 파일 로드
	Properties properties = new Properties();
	try (InputStream input = application.getResourceAsStream("/WEB-INF/classes/config.properties")) {
		if (input == null) {
			throw new FileNotFoundException("프로퍼티 파일을 찾을 수 없습니다.");
		}
		properties.load(input);
	} catch (IOException ex) {
		ex.printStackTrace();
	}

	String uploadDir = properties.getProperty("upload.dir");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상세확인</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<style>
/* 신규 CSS 코드 */
body {
	background-color: #f0f2f5;
	font-family: 'Arial', sans-serif;
}

#container {
	max-width: 900px;
	background-color: #ffffff;
	padding: 30px;
	border-radius: 12px;
	box-sizing: border-box; /* 추가 */
	box-shadow: 0px 8px 16px rgba(0, 0, 0, 0.15);
	margin: 50px auto;
}

#content {
	margin-bottom: 40px;
}

#content h2 {
	font-size: 28px;
	font-weight: bold;
	color: #4a90e2;
	text-align: center;
	margin-bottom: 20px;
}

#content table {
	width: 100%;
	border-collapse: collapse;
}

#content th, #content td {
	padding: 15px;
	border-bottom: 1px solid #ddd;
}

#content th {
	background-color: #f7f7f7;
	font-weight: bold;
	color: #333;
}

.btn-custom {
	background-color: #4a90e2;
	color: white;
	border: none;
	padding: 5px 10px;
}

.btn-custom:hover {
	background-color: #3a78c2;
}

#btn-custom-update {
	background-color: #4a90e2;
	color: white;
	border: none;
	padding: 5px 10px;
}

#btn-custom-update:hover {
	background-color: #3a78c2;
}

.align-left {
	text-align: left;
}

.align-right {
	text-align: right;
}

#comments {
	margin-top: 40px;
}

#comment-input {
	margin-top: 20px;
}

#comment-input textarea {
	width: calc(100% - 110px);
	display: inline-block;
	vertical-align: middle;
}

#comment-input input[type="submit"] {
	width: 100px;
	display: inline-block;
	vertical-align: middle;
}
/* 댓글 내용과 버튼이 겹치지 않도록 */
.reply-content {
	width: 80%;
	display: inline-block;
	vertical-align: top;
}

.reply-buttons {
	width: 20%;
	display: inline-block;
	text-align: right;
	vertical-align: top;
}

#replyList table {
	width: 100%;
	table-layout: fixed; /* 추가 */
	border-collapse: collapse;
	margin-bottom: 20px;
}

#replyList td {
	width: 50%; /* 기본 셀 너비 */
	word-wrap: break-word; /* 내용 줄바꿈 */
}
/* 댓글 내용과 버튼 셀의 너비 조정 */
#replyList td.reply-content {
	width: 80%;
}

#replyList td.reply-buttons {
	width: 20%;
}

.reply-container {
	display: flex;
	justify-content: space-between; /* 양 끝으로 정렬 */
	align-items: center; /* 세로 정렬 */
	width: 100%; /* 부모 요소의 너비를 모두 사용 */
}

.reply-content {
	/* 기존 스타일 삭제 또는 수정 */
	width: auto; /* 너비 자동 */
	margin-right: 10px; /* 버튼과의 간격 조절 */
}

.reply-buttons {
	/* 기존 스타일 삭제 또는 수정 */
	
}

.button-container {
	display: flex;
	justify-content: space-between;
	align-items: center;
}

.button-left {
	/* 왼쪽 정렬 (기본값) */
	
}

.button-right {
	display: flex;
	gap: 10px; /* 버튼 사이 간격 조절 */
}
</style>
<script type="text/javascript">
    var contextPath = '<%=contextPath%>';

	function getFormValues(clickedButton) {
		var replyId = $(clickedButton).attr('data-reply-id');
		var postId = $(clickedButton).attr('data-post-id');
		var replyContentElement = $(clickedButton).closest('tr').find(
				'.reply-content');
		var replyContent = replyContentElement.text();

		return {
			replyId : replyId,
			postId : postId,
			replyContent : replyContent
		};
	}

	$(document)
			.on(
					'click',
					'.reply-update',
					function(event) {
						event.preventDefault();
						var formValues = getFormValues(this);
						var newFormHtml = "<form action='" + contextPath + "/Book/bookpostreplyUpdate.do' method='get' class='reply-update-form' style='display: flex; justify-content: space-between; align-items: center;'>"
								+ "<input type='hidden' value='" + formValues.replyId + "' name='replyId'>"
								+ "<input type='hidden' value='" + formValues.postId + "' name='postId'>"
								+ "<div class='reply-content' style='flex: 1; margin-right: 10px;'><textarea name='replyContent' style='width: 100%;'>"
								+ formValues.replyContent
								+ "</textarea></div>"
								+ "<div class='reply-buttons'><input type='submit' value='수정하기' class='btn-custom'></div>"
								+ "</form>";

						var currentRow = $(this).closest('div.reply-container');

						currentRow.after(newFormHtml);
						currentRow.remove();
					});
</script>
</head>
<body>
	<div id="container">
		<!-- 본문 div -->
		<div id="content">
			<input type="hidden" name="userId" value="<%=userId%>">
			<table>
				<thead>
					<tr>
						<th colspan="2"><label for="postTitle">글 제목:</label> <%=postTitle%></th>
					</tr>
					<tr>
						<td class="align-left"><label for="postUserId">작성자:</label> <%=postUserId%></td>
						<td class="align-right"><label for="createdAt">작성일:</label> <%=createdAt%></td>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td colspan="2"><label for="preview-image">이미지 미리보기</label>
							<div id="preview" style="display: flex; flex-wrap: wrap;">
								<%
									if (images != null && !images.isEmpty()) {
										for (BookImage image : images) {
								%>
								<img src="<%=request.getContextPath() + image.getImage_path()%>"
									style="width: 178px; height: 178px; margin: 2px;" />
								<%
									}
									} else {
								%>
								<p>이미지가 없습니다.</p>
								<%
									}
								%>
							</div></td>
					</tr>
					<tr>
						<td colspan="2"><label for="postContent">내용:</label> <%=postContent%></td>
					</tr>
				</tbody>
				<tfoot>
					<tr>
						<td colspan="2"><label for="majorTag">학과 태그:</label> <%=majorTag%></td>
					</tr>
					<tr>
						<td colspan="2">
							<div class="button-container">
								<div class="button-left">
									<form action="<%=contextPath%>/Book/bookpostboard.bo"
										style="display: inline;">
										<input type="hidden"
											value="/view_student/booktradingboard.jsp" name="center">
										<input type="submit" value="목록" class="btn-custom">
									</form>
								</div>
								<%
									if (userId != null && userId.equals(postUserId)) {
								%>
								<div class="right-align">
									<form action="<%=contextPath%>/Book/bookpostupdate.bo"
										method="get" style="display: inline;">
										<input type="hidden" value="<%=postId%>" name="postId">
										<input type="submit" value="수정하기" class="btn-custom">
									</form>
									<form action="<%=contextPath%>/Book/bookpostdelete.do"
										style="display: inline;">
										<input type="hidden" value="<%=postId%>" name="postId">
										<input type="submit" value="삭제하기" class="btn-custom">
									</form>
								</div>
								<%
									}
								%>
							</div>
						</td>
					</tr>
				</tfoot>
			</table>
		</div>

		<!-- 댓글 div -->
		<div id="comments">
			<h4 class="align-left">댓글</h4>
			<div id="replyList">
				<c:if test="${not empty replies}">
					<c:forEach var="reply" items="${replies}" varStatus="status">
						<table>
							<tr>
								<td class="align-left"><strong>${reply.userId}</strong></td>
								<td class="align-right">${reply.replytimeAt}</td>
							</tr>
							<tr id="insertHere">
								<td colspan="2">
									<div class="reply-container">
										<div class="reply-content">${reply.replyContent}</div>
										<div class="reply-buttons">
											<c:choose>
												<c:when test="${sessionScope.id == reply.userId}">
													<form id="reply-form-${status.index}"
														action="<%=contextPath%>/Book/bookpostreplyDelete.do"
														method="get" class="reply-update-form"
														style="display: inline;">
														<input id="reply-id-${status.index}" type="hidden"
															value="${reply.replyId}" name="replyId"> <input
															id="post-id-${status.index}" type="hidden"
															value="<%=postId%>" name="postId">
														<button class="reply-update"
															data-reply-id="${reply.replyId}"
															data-post-id="<%=postId%>" id="btn-custom-update">수정</button>
														<input type="submit" value="삭제" class="btn-custom">
													</form>
												</c:when>
												<c:otherwise>
													<div class="reply-update-form" style="display: inline;"></div>
												</c:otherwise>
											</c:choose>
										</div>
									</div>
								</td>
							</tr>
						</table>
					</c:forEach>
				</c:if>
			</div>
		</div>

		<!-- 댓글 입력 div -->
		<div id="comment-input">
			<form action="<%=contextPath%>/Book/bookpostreply.do" method="post">
				<input type="hidden" name="postId" value="<%=postId%>">
				<div>
					<input type="hidden" name="userId" value="<%=userId%>">
				</div>
				<div>
					<textarea name="replyContent" placeholder="댓글 입력" required></textarea>
					<input type="submit" value="댓글 등록" class="btn-custom">
				</div>
			</form>
		</div>
	</div>
</body>
</html>
