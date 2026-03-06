<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="Vo.StudentVo"%>
<%
	String contextPath = request.getContextPath();
	StudentVo evaluation = (StudentVo) request.getAttribute("evaluation"); // 컨트롤러에서 전달된 평가 데이터
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>강의 평가 수정</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<div class="container mt-5">
		<h2 class="mb-4">강의 평가 수정</h2>

		<form action="<%=contextPath%>/student/evaluationUpdate.do"
			method="post">
			<!-- 평가 ID (숨김 필드) -->
			<input type="hidden" name="evaluation_id"
				value="<%=evaluation.getEvaluationId()%>">

			<!-- 강의 정보 -->
			<div class="mb-3">
				<label for="courseId" class="form-label">강의 ID</label> <input
					type="text" class="form-control" id="courseId" name="course_id"
					value="<%=evaluation.getCourseId()%>" readonly>
			</div>
			<div class="mb-3">
				<label for="courseName" class="form-label">강의 이름</label> <input
					type="text" class="form-control" id="courseName" name="course_name"
					value="<%=evaluation.getCourse_name()%>" readonly>
			</div>

			<!-- 평점 -->
			<div class="mb-3">
				<label for="rating" class="form-label">평점</label> <select
					class="form-select" id="rating" name="rating" required>
					<option value="1"
						<%=(evaluation.getRating() == 1) ? "selected" : ""%>>1 -
						매우 나쁨</option>
					<option value="2"
						<%=(evaluation.getRating() == 2) ? "selected" : ""%>>2 -
						나쁨</option>
					<option value="3"
						<%=(evaluation.getRating() == 3) ? "selected" : ""%>>3 -
						보통</option>
					<option value="4"
						<%=(evaluation.getRating() == 4) ? "selected" : ""%>>4 -
						좋음</option>
					<option value="5"
						<%=(evaluation.getRating() == 5) ? "selected" : ""%>>5 -
						매우 좋음</option>
				</select>
			</div>

			<!-- 평가 내용 -->
			<div class="mb-3">
				<label for="comments" class="form-label">평가 내용</label>
				<textarea class="form-control" id="comments" name="comments"
					rows="4" required><%=evaluation.getComments()%></textarea>
			</div>

			<!-- 수정 및 취소 버튼 -->
			<div class="d-flex flex-column align-items-center"
				style="gap: 10px; margin-top: 20px;">
				<button type="submit" class="btn"
					style="background-color: #D5E6DE; color: #333; width: 120px; height: 40px; font-size: 14px; border-radius: 5px; border: none; display: flex; align-items: center; justify-content: center;">수정하기</button>
				<a href="<%=contextPath%>/student/evaluationList.do" class="btn"
					style="background-color: #D5E6DE; color: #333; width: 120px; height: 40px; font-size: 14px; border-radius: 5px; border: none; text-decoration: none; text-align: center; display: flex; align-items: center; justify-content: center;">취소</a>
			</div>
		</form>
	</div>
</body>
</html>