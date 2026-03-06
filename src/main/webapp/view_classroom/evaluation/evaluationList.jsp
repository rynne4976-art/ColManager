<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="Vo.StudentVo"%>
<%
	String contextPath = request.getContextPath();
	String studentId = (String) session.getAttribute("id"); // 세션에서 로그인한 학생 ID 가져오기
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>강의 평가 조회</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<style>
/* 버튼 스타일 */
.btn-e {
    background-color: #D5E6DE;
    color: black;
    padding: 8px 15px;
    font-size: 14px;
    border-radius: 5px;
    border: none;
    cursor: pointer;
    transition: background-color 0.3s;
}

.btn-e:hover {
    background-color: #C4D9D0;
}

/* 테이블 스타일 */
.table {
    border-collapse: collapse;
    width: 100%;
    margin-top: 20px;
}

.table th, .table td {
    border: 1px solid #e9ecef; /* 연한 회색 테두리 */
    padding: 10px;
    text-align: center;
    vertical-align: middle;
}

.table th {
    background-color: #D5E6DE; /* 연한 초록 배경 */
    color: black; /* 검정 글씨 */
    font-weight: bold;
}

.table td {
    background-color: #ffffff; /* 흰색 배경 */
}

/* 테두리 제거 및 부드러운 효과 */
.table-bordered th, .table-bordered td {
    border-color: #e9ecef; /* 연한 회색 테두리 */
}

.table-hover tbody tr:hover {
    background-color: #f8f9fa; /* 연한 회색 호버 효과 */
}
</style>

</head>
<body>
	<div class="container mt-5">
		<h2 class="mb-4 test-center">내 강의 평가 조회</h2>

		<!-- 강의 평가 리스트 -->
		<table class="table table-bordered">
			<thead class="table-dark">
				<tr>
					<th>강의 ID</th>
					<th>강의 이름</th>
					<th>평점</th>
					<th>내용</th>
					<th>수정</th>
					<th>삭제</th>
				</tr>
			</thead>
			<tbody>
				<%-- 서버에서 강의 평가 데이터를 가져와 반복 출력 --%>
				<%
					List<StudentVo> evaluationList = (List<StudentVo>) request.getAttribute("evaluations"); // 컨트롤러에서 설정한 "evaluations" 속성 가져오기
					if (evaluationList != null && !evaluationList.isEmpty()) { // 리스트가 null이 아니고 비어있지 않을 때
						for (StudentVo evaluation : evaluationList) {
				%>
				<tr>
					<td><%=evaluation.getCourseId()%></td>
					<td><%=evaluation.getCourse_name()%></td>
					<td><%=evaluation.getRating()%></td>
					<td><%=evaluation.getComments()%></td>
					<td>
						<form action="<%=contextPath%>/student/evaluationEdit.do"
							method="get" style="display: inline;">
							<input type="hidden" name="evaluation_id"
								value="<%=evaluation.getEvaluationId()%>">
							<button type="submit" class="btn-e"
								style="background-color: #D5E6DE; color: black; border: none; border-radius: 5px; padding: 8px 15px;">수정</button>
						</form>
					</td>
					<td>
						<form action="<%=contextPath%>/student/evaluationDelete.do"
							method="post" style="display: inline;">
							<input type="hidden" name="evaluation_id"
								value="<%=evaluation.getEvaluationId()%>">
							<button type="submit" class="btn-e"
								style="background-color: #D5E6DE; color: black; border: none; border-radius: 5px; padding: 8px 15px;">삭제</button>
						</form>
					</td>
				</tr>
				<%
					}
					} else {
				%>
				<tr>
					<td colspan="6" class="text-center">작성된 강의 평가가 없습니다.</td>
				</tr>
				<%
					}
				%>
			</tbody>
		</table>

		<!-- 돌아가기 버튼 -->
		<div class="text-center mt-4">
			<button type="button" onclick="location.href='<%=contextPath%>/student/evaluationRegister.do'" class="btn-e">
			    강의 평가 등록하기
			</button>

		</div>
	</div>
</body>
</html>