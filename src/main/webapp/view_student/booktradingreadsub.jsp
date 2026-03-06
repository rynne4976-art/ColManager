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

//replies 리스트 내용 출력
if (replies != null && !replies.isEmpty()) {
	System.out.println("Replies List Contents:");
	for (BookPostReplyVo reply : replies) {
		System.out.println(reply); // toString() 메소드가 구현되어 있어야 합니다.

		// 또는 개별 필드를 출력하고 싶다면
		/*
		System.out.println("Reply ID: " + reply.getReplyId());
		System.out.println("User ID: " + reply.getUserId());
		System.out.println("Content: " + reply.getReplyContent());
		System.out.println("Reply Time: " + reply.getReplyTimeAt());
		System.out.println("---------------------------");
		*/
	}
} else {
	System.out.println("Replies list is null or empty.");
}

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
<script>
	// 페이지가 완전히 로드된 후에 실행되는 코드
	$(document).ready(
			function() {
				// .btn-fetch 클래스를 가진 모든 버튼에 클릭 이벤트를 추가합니다.
				// 이 코드는 버튼을 클릭할 때마다 호출됩니다.
				$(".btn-fetch").on(
						"click",
						function() {
							// 클릭된 버튼과 같은 <td> 요소 내에서 .hidden-value 클래스를 가진 <input> 요소를 찾습니다.
							// closest("td")는 버튼의 부모 요소인 <td>를 찾고, 그 안에서 .hidden-value를 찾습니다.
							const hiddenValue = $(this).closest("td").find(
									".hidden-value").val();

							// hiddenValue에 저장된 값을 확인하기 위해 alert 창으로 표시합니다.
							// 버튼을 클릭했을 때 해당하는 숨겨진 값이 alert로 출력됩니다.
							alert("Hidden Value: " + hiddenValue);
						});
			});
</script>
</head>
<body>
	<div>
		<input type="hidden" name="userId" value="<%=userId%>">
		<table>
			<thead>
				<tr>
					<td><label for="postTitle">글 제목:</label><%=postTitle%></td>
				</tr>
				<tr>
					<td><label for="postUserId">작성자:</label><%=postUserId%></td>
					<td><label for="createdAt">작성일:</label><%=createdAt%></td>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td colspan="4"><label for="preview-image">이미지 미리보기</label>
						<div id="preview" style="display: flex; flex-wrap: wrap;">
							<%
							if (images != null && !images.isEmpty()) {
							%>
							<%
							for (BookImage image : images) {
							%>
							<img src="<%=request.getContextPath() + image.getImage_path()%>"
								style="width: 178px; height: 178px; margin: 2px;" />
							<%
							}
							%>
							<%
							} else {
							%>
							<p>이미지가 없습니다.</p>
							<%
							}
							%>
						</div></td>
				</tr>
				<tr>
					<td colspan="4"><label for="postContent">내용:</label><%=postContent%></td>
				</tr>
				<tr>
					<td colspan="4" bgcolor="#f5f5f5" style="text-align: left">
						<p id="textInput"></p>
					</td>
				</tr>
			</tbody>
			<tfoot>
				<tr>
					<td><label for="majorTag">학과 태그:</label><%=majorTag%></td>
					<%
					if (userId != null && userId.equals(postUserId)) {
					%>
					<!-- 작성자가 동일할 경우에만 수정/삭제 버튼 표시 -->
					<td>
						<form action="<%=contextPath%>/Book/bookpostupdate.bo"
							method="get">
							<input type="hidden" value="<%=postId%>" name="postId"> <input
								type="submit" value="수정하기">
						</form>
					</td>
					<td>
						<form action="<%=contextPath%>/Book/bookpostdelete.do">
							<input type="hidden" value="<%=postId%>" name="postId"> <input
								type="submit" value="삭제하기">
						</form>
					</td>
					<%
					}
					%>
					<td>
						<!-- 목록 -->
						<form action="<%=contextPath%>/Book/bookpostboard.bo">
							<input type="hidden" value="/view_student/booktradingboard.jsp"
								name="center"> <input type="submit" value="목록">
						</form>
					</td>
				</tr>
			</tfoot>
		</table>
	</div>
	<!-- 댓글 섹션 -->
	<div id="replySection">
		<h4>댓글</h4>
		<div id="replyList">
			<c:if test="${not empty replies}">
				<div class="replies-section">
					<h4>댓글 목록</h4>

					<table>
						<tr>
							<td>${reply.userId}</td>
							<td>${reply.replytimeAt}</td>
						</tr>
						<!-- dataList 객체를 순회하며 테이블 행을 반복 출력 -->
						<%-- JSP의 JSTL 태그 <c:forEach>를 사용해 dataList에 있는 항목을 반복합니다. --%>
						<c:forEach var="reply" items="${replies}">
							<tr>
								<td>
									<form action="<%=contextPath%>/Book/bookpostreplyDelete.do"
										method="get">
										<!-- 각 항목에 대한 숨겨진 값을 저장하는 <input> 태그 -->
										<!-- 숨겨진 값을 표시하지 않으면서 서버로 전송할 수 있도록 <input type="hidden"> 사용 -->
										<input type="hidden" value="${reply.replyId}" name="replyId">
										<input type="hidden" value="<%=postId%>" name="postId">
										<!-- 각 항목마다 "Click Me" 버튼을 추가 -->
										<button class="reply-update">수정</button>
										<input type="submit" value="삭제">
									</form>
								</td>
							</tr>
						</c:forEach>
					</table>
				</div>
			</c:if>
		</div>
		<!-- 댓글 입력 폼 -->
		<form action="<%=contextPath%>/Book/bookpostreply.do" method="post">
			<input type="hidden" name="postId" value="<%=postId%>"> <input
				type="text" name="userId" value="<%=userId%>" readonly>
			<textarea name="replyContent" placeholder="댓글 입력" required></textarea>
			<input type="submit" value="댓글 등록">
		</form>
	</div>
</body>
</html>
