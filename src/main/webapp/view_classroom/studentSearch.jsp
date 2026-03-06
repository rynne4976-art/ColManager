<%@page import="Vo.StudentVo"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Vo.CourseVo"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	String contextPath = request.getContextPath();
	ArrayList<StudentVo> studentList = (ArrayList<StudentVo>) session.getAttribute("studentList");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>교수 강의 목록</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css"
        rel="stylesheet" crossorigin="anonymous">
    <script type="text/javascript" src="http://code.jquery.com/jquery-latest.min.js"></script>
    <style>
        .btn-green {
            background-color: #4CAF50;
            color: white;
        }

        .btn-green:hover {
            background-color: #45a049;
        }
        
        
	    .input{
	        width: 70px; 
	    }
        
    </style>
</head>
<body class="bg-light">
	<main class="container my-5">
		<h2 class="text-center mb-4">학생 목록</h2>
		<div class="card shadow-sm">
            <div class="card-body">
                <table class="table table-bordered table-hover text-center align-middle">
                    <thead class="table-success">
                        <tr>
                            <th scope="col">학과</th>
                            <th scope="col">학 번</th>
                            <th scope="col">이름</th>
                            <th scope="col">중간 고사</th>
                            <th scope="col">기말 고사</th>
                            <th scope="col">과 제</th>
                            <th scope="col">총 점</th>
                            <th scope="col">등 록</th>
                            <th scope="col">수 정</th>
                            <th scope="col">삭 제</th>
                            
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        for (StudentVo student : studentList) {
                        	System.out.println(student);
                        %>
                        <tr>
							<td><%=student.getCourse().getMajorname()%></td>
                            <td id="student_id"><%=student.getStudent_id()%></td>
                            <td><%=student.getUser_name()%></td>
                            <td><input type="text" id="midtest" name="midtest" class="input" value="<%=student.getMidtest_score()%>"></td>
                            <td><input type="text" id="finaltest" name="finaltest" class="input" value="<%=student.getFinaltest_score()%>"></td>
                            <td><input type="text" id="assignment" name="assignment" class="input" value="<%=student.getAssignment_score()%>"></td>
                            <td><input type="text" id="total" name="total" value="" class="input" value="<%=student.getScore()%>"></td>
                            <td>
                                <button id="registerBtn-<%= student.getStudent_id() %>" 
                                        class="btn btn-green register-btn" 
                                        onclick="registerGrade('<%= student.getStudent_id() %>')">등록</button>
                            </td>
                             <td>
                                <button id="registerBtn-<%= student.getStudent_id() %>" 
                                        class="btn btn-green register-btn" 
                                        onclick="updateGrade('<%= student.getStudent_id() %>')">수정</button>
                            </td>
                             <td>
                                <button id="registerBtn-<%= student.getStudent_id() %>" 
                                        class="btn btn-green register-btn" 
                                        onclick="deleteGrade('<%= student.getStudent_id() %>')">삭제</button>
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
    <script type="text/javascript">
        // 총점 계산 함수
        function totalScore(row) {
            const midtest = parseFloat($(row).find('input[name="midtest"]').val()) || 0;
            const finaltest = parseFloat($(row).find('input[name="finaltest"]').val()) || 0;
            const assignment = parseFloat($(row).find('input[name="assignment"]').val()) || 0;
            const total = (midtest * 0.4) + (finaltest * 0.4) + (assignment * 0.2);
            $(row).find('input[name="total"]').val(total.toFixed(2));
        }

        // 입력값 변경 시 총점 자동 계산
        $(document).ready(function () {
            $('table').on('input', 'input[name="midtest"], input[name="finaltest"], input[name="assignment"]', function () {
                const row = $(this).closest('tr');
                totalScore(row);
            });
        });

        // 등록 버튼 클릭 이벤트 처리
        function registerGrade(studentId) {
            const row = $('#registerBtn-' + studentId).closest('tr');
            const midtest = $(row).find('input[name="midtest"]').val();
            const finaltest = $(row).find('input[name="finaltest"]').val();
            const assignment = $(row).find('input[name="assignment"]').val();
            const total = $(row).find('input[name="total"]').val();

            $.ajax({
                url: '<%=contextPath%>/classroom/grade_register.do?classroomCenter=/view_classroom/studentSearch.jsp',
                type: 'POST',
                data: { 
                    student_id: studentId, 
                    midtest: midtest, 
                    finaltest: finaltest, 
                    assignment: assignment, 
                    total: total 
                },
                success: function (response) {
                    alert(response);
                },
                error: function () {
                    alert('등록 중 오류가 발생했습니다.');
                }
            });
        }
        
     // 수정 버튼 클릭 이벤트 처리
        function updateGrade(studentId) {
            const row = $('#registerBtn-' + studentId).closest('tr');
            const midtest = $(row).find('input[name="midtest"]').val();
            const finaltest = $(row).find('input[name="finaltest"]').val();
            const assignment = $(row).find('input[name="assignment"]').val();
            const total = $(row).find('input[name="total"]').val();

            $.ajax({
                url: '<%=contextPath%>/classroom/grade_update.do?classroomCenter=/view_classroom/studentSearch.jsp',
                type: 'POST',
                data: { 
                    student_id: studentId, 
                    midtest: midtest, 
                    finaltest: finaltest, 
                    assignment: assignment, 
                    total: total 
                },
                success: function (response) {
                    alert(response);
                },
                error: function () {
                    alert('수정 중 오류가 발생했습니다.');
                }
            });
        }
        
        // 삭제 버튼 클릭 이벤트 처리
        function deleteGrade(studentId) {
            const row = $('#registerBtn-' + studentId).closest('tr');
            
            if (confirm("정말 삭제하시겠습니까?")) { // 삭제 확인 메시지
	            $.ajax({
	                url: '<%=contextPath%>/classroom/grade_delete.do?classroomCenter=/view_classroom/studentSearch.jsp',
	                type: 'POST',
	                data: { 
	                    student_id: studentId
	                },
	                success: function (response) {
	                    alert(response);
	                    location.reload(); // 페이지 새로고침하여 변경사항 반영
	                },
	                error: function () {
	                    alert('삭제 중 오류가 발생했습니다.');
	                }
	            });
            }
        }
        

    </script>
</body>
</html>