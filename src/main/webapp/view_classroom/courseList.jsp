<%@page import="java.util.ArrayList"%>
<%@page import="Vo.CourseVo"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
String contextPath = request.getContextPath();

ArrayList<CourseVo> courseList = (ArrayList<CourseVo>) request.getAttribute("courseList");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>교수 강의 목록</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css"
	rel="stylesheet" crossorigin="anonymous">
<script type="text/javascript"
	src="http://code.jquery.com/jquery-latest.min.js"></script>

<style>
.btn-green {
	background-color: #4CAF50; /* 초록색 */
	color: white;
}

.btn-green:hover {
	background-color: #45a049; /* 호버 효과 */
}

#courseName{
	text-decoration: none;
	color: black;
}

</style>

<%
String message = request.getParameter("message");
if (message != null) {
%>
<script>
			alert('<%=message%>'); // 메시지를 알림으로 표시
</script>
<%
}
%>

</head>
<body class="bg-light">
	<main class="container my-5">
		<h2 class="text-center mb-4">강의 목록</h2>
		<div class="card shadow-sm">
			<div class="card-body">
				<table
					class="table table-bordered table-hover text-center align-middle">
					<thead class="table-success">
						<tr>
							<th scope="col">과목 ID</th>
							<th scope="col">과목 이름</th>
							<th scope="col">강의실(수용인원 / 장비)</th>
						</tr>
					</thead>
					<tbody>
						<%
						for (CourseVo course : courseList) {
						%>
						<tr>
							<td id="course_id"><%=course.getCourse_id()%></td>
							<td><a href="<%=contextPath%>/classroom/student_search.bo?course_id=<%=course.getCourse_id()%>&classroomCenter=/view_classroom/studentSearch.jsp" id="courseName"><%=course.getCourse_name()%></a></td>
							<td><%=course.getClassroom().getRoom_id()%>
								(<%=course.getClassroom().getCapacity()%> / <%=course.getClassroom().getEquipment()%>)
							</td>
							
						</tr>
						<%
						}
						%>
					</tbody>
				</table>
			</div>
		</div>


	</main>
</body>
</html>