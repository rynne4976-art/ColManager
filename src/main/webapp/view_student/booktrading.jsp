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

	String nowPage = (String) request.getAttribute("nowPage");
	String nowBlock = (String) request.getAttribute("nowBlock");

	List<BookPostVo> majorInfo = (List<BookPostVo>) request.getAttribute("majorInfo");
%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>판매 또는 구매 글 등록</title>
<style>
/* 기존 CSS 스타일을 여기에 복사합니다 */
body {
	background-color: #f0f2f5;
	font-family: 'Arial', sans-serif;
}

#container {
	max-width: 900px;
	background-color: #ffffff;
	padding: 30px;
	border-radius: 12px;
	box-sizing: border-box;
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

/* 추가적인 스타일 클래스 */
.input-row {
	display: flex;
	align-items: center;
}

.input-row label {
	margin-right: 10px;
	white-space: nowrap;
}

.input-row input[type="text"] {
	flex: 1;
	padding: 5px;
	font-size: 16px;
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
	resize: vertical;
}

.button-container {
	display: flex;
	justify-content: center;
	align-items: center;
	gap: 10px;
}
</style>
</head>


<body>
	<div id="container">
		<div id="content">
			<!-- 기존의 폼 내용을 여기에 추가합니다 -->
			<form action="<%=contextPath%>/Book/bookPostUpload.do" method="post"
				enctype="multipart/form-data">
				<input type="hidden" name="userId" value="<%=userId%>">

				<table>
					<thead>
						<tr>
							<th colspan="2">
								<div class="input-row">
									<label for="postTitle">글 제목:</label> <input type="text"
										id="postTitle" name="postTitle" required>
								</div>
							</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td colspan="2"><label for="preview-image">이미지 미리보기</label>
								<div id="preview" style="display: flex; flex-wrap: wrap;"></div>
							</td>
						</tr>

						<tr>
							<td colspan="2">
								<div class="input-column">
									<label for="postContent">내용</label>
									<textarea id="postContent" name="postContent" rows="10"
										required></textarea>
								</div>
							</td>
						</tr>

					</tbody>
					<tfoot>
						<tr>
							<td colspan="2"><label for="majorTag">학과 태그:</label> <select
								id="majorTag" name="majorTag">
									<option value="일반 중고책 거래">일반 중고책 거래</option>
									<c:forEach var="major" items="${majorInfo}">
										<option value="${major.majorTag}">${major.majorTag}</option>
									</c:forEach>
							</select></td>
						</tr>

						<tr>
							<td colspan="2"><label for="image">이미지:</label> <input
								type="file" id="imageInput" name="image" accept="image/*"
								multiple onchange="previewImages(event)"></td>
						</tr>

						<tr>
						<tr>
							<td colspan="2">
								<div class="button-container">
									<button type="submit" class="btn-custom">등록</button>
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
	<script>
    function previewImages(event) {
        const files = event.target.files;

        // 미리보기 영역을 초기화합니다.
        const preview = document.getElementById('preview');
        preview.innerHTML = "";

        // 파일이 5개를 초과하면 처리하지 않음
        if (files.length > 5) {
            alert("최대 5개의 이미지만 업로드할 수 있습니다.");
            event.target.value = "";
            return;
        }

        // 선택한 파일들을 순회하며 미리보기 생성
        for (let i = 0; i < files.length; i++) {
            if (files[i]) {
                const reader = new FileReader();

                reader.onload = function(e) {
                    // 각 이미지 미리보기를 위한 <img> 태그 생성
                    const img = document.createElement("img");
                    img.src = e.target.result;
                    img.style.width = "178px";
                    img.style.height = "178px";
                    img.style.margin = "2px";
                    preview.appendChild(img);
                };

                reader.readAsDataURL(files[i]);
            }
        }
    }
</script>

</body>

<body>
</html>
