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

	//이미지 리스트 생성
	List<BookImage> displayImages = new ArrayList<>();
	if (images != null) {
		for (int i = 0; i < images.size() && i < 5; i++) {
			displayImages.add(images.get(i));
		}
	}
	//프로퍼티 파일 로드
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
<title>게시글 수정</title>
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
	vertical-align: top;
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
	cursor: pointer;
}

.btn-custom:hover {
	background-color: #3a78c2;
}

.align-left {
	text-align: left;
}

.align-right {
	text-align: right;
}

#preview img {
	width: 178px;
	height: 178px;
	margin: 2px;
}
/* 버튼 컨테이너 스타일 */
.button-container {
	display: flex;
	justify-content: center;
	align-items: center;
	gap: 10px;
}

.input-row {
	display: flex;
	align-items: center;
}

.input-row label {
	margin-right: 10px;
	white-space: nowrap; /* 라벨이 줄바꿈되지 않도록 설정 */
}

.input-row input[type="text"] {
	flex: 1;
	padding: 5px; /* 입력 필드 내부 여백 조절 */
	font-size: 16px; /* 폰트 크기 조절 */
}

.input-column {
    display: flex;
    flex-direction: column;
    width: 100%;
}

.input-column label {
    margin-bottom: 5px;
}

.input-column textarea {
    width: 100%;
    padding: 5px;
    font-size: 16px;
    resize: vertical; /* 사용자가 세로 크기 조절 가능 */
}

</style>
</head>
<body>
	<div id="container">
		<div id="content">
			<form action="<%=contextPath%>/Book/bookpostupdate.do" method="post"
				enctype="multipart/form-data">
				<input type="hidden" name="postId" value="<%=postId%>"> <input
					type="hidden" name="userId" value="<%=userId%>">
				<table>
					<thead>
						<tr>
							<th colspan="2">
								<div class="input-row">
									<label for="postTitle">글 제목: </label> <input type="text"
										id="postTitle" name="postTitle" value="<%=postTitle%>"
										required>
								</div>
							</th>

						</tr>
						<tr>
							<td class="align-left"><label for="postUserId">작성자:
							</label> <%=postUserId%></td>
							<td class="align-right"><label for="createdAt">작성일:</label>
								<%=createdAt%></td>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td colspan="2"><label for="preview-image">이미지 미리보기</label>
								<div id="preview" style="display: flex; flex-wrap: wrap;">
									<%
										if (images != null && !images.isEmpty()) {
											for (BookImage image : images) {
												String imagePath = image.getImage_path();
									%>
									<img src="<%=request.getContextPath() + imagePath%>" />
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
							<td colspan="2">
								<div class="input-column">
									<label for="postContent">내용</label>
									<textarea id="postContent" name="postContent" rows="10"
										required><%=postContent%></textarea>
								</div>
							</td>
						</tr>
						<tr>
							<td colspan="2"><label for="image">이미지:</label> <input
								type="file" id="imageInput" name="image" accept="image/*"
								multiple></td>
						</tr>
					</tbody>
					<tfoot>
						<tr>
							<td colspan="2"><label for="majorTag">학과 태그:</label> <select
								id="majorTag" name="majorTag">
									<option value="<%=majorTag%>" selected><%=majorTag%></option>
									<option value="일반 중고책 거래">일반 중고책 거래</option>
									<c:forEach var="major" items="${majorInfo}">
										<option value="${major.majorTag}">${major.majorTag}</option>
									</c:forEach>
							</select></td>
						</tr>
						<tr>
							<td colspan="2">
								<div class="button-container">
									<button type="submit" class="btn-custom">수정하기</button>
									<button type="button" onclick="history.back();"
										class="btn-custom">취소</button>
								</div>
							</td>
						</tr>
					</tfoot>
				</table>
			</form>
		</div>
	</div>
	<script type="text/javascript">
		document.addEventListener('DOMContentLoaded', function() {
			const imageInput = document.getElementById('imageInput');
			const previewContainer = document.getElementById('preview');

			imageInput.addEventListener('change', function() {
				// 기존 미리보기 제거
				previewContainer.innerHTML = '';

				const files = imageInput.files;

				if (files.length === 0) {
					const noImageText = document.createElement('p');
					noImageText.textContent = '이미지가 없습니다.';
					previewContainer.appendChild(noImageText);
					return;
				}

				// 선택된 파일들을 순회하며 미리보기 생성
				for (let i = 0; i < files.length; i++) {
					const file = files[i];

					// 이미지 파일인지 확인
					if (!file.type.startsWith('image/')) {
						continue;
					}

					const reader = new FileReader();

					reader.onload = function(e) {
						const img = document.createElement('img');
						img.src = e.target.result;
						img.style.width = '178px';
						img.style.height = '178px';
						img.style.margin = '2px';
						previewContainer.appendChild(img);
					};

					reader.readAsDataURL(file);
				}
			});
		});
	</script>
</body>
</html>
