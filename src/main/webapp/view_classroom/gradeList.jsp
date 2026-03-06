<%@page import="Vo.StudentVo"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Vo.CourseVo"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    String contextPath = request.getContextPath();
    ArrayList<StudentVo> studentList_ = (ArrayList<StudentVo>)session.getAttribute("studentList");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>성적 조회</title>
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

    </style>
</head>
<body class="bg-light">
    <main class="container my-5">
        <h2 class="text-center mb-4">성적 목록</h2>
        <div class="card shadow-sm">
            <div class="card-body">
                <table class="table table-bordered table-hover text-center align-middle">
                    <thead class="table-success">
                        <tr>
                            <th scope="col">학 과</th>
                            <th scope="col">학 번</th>
                            <th scope="col">과 목</th>
                            <th scope="col">과목 번호</th>
                            <th scope="col">중간 고사</th>
                            <th scope="col">기말 고사</th>
                            <th scope="col">과 제</th>
                            <th scope="col">총 점</th>
                            <th scope="col">등 급</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        for (StudentVo student : studentList_) {
                        %>
                        <tr>
                            <td><%=student.getCourse().getMajorname()%></td>
                            <td class="student_id"><%=student.getStudent_id()%></td>
                            <td><%=student.getCourse().getCourse_name()%></td>
                            <td><%=student.getCourse().getCourse_id()%></td>
                            <td><%=student.getMidtest_score()%></td>
                            <td><%=student.getFinaltest_score()%></td>
                            <td><%=student.getAssignment_score()%></td>
                            <td class="total"><%=student.getScore()%></td>
                            <td class="grade"></td>
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
	// 페이지 로드 시 실행되는 함수
    window.onload = function() {
        calculateGrades(); // 등급 계산 함수 호출
    };

    function calculateGrades() {
        // 모든 테이블 행 가져오기
        const rows = document.querySelectorAll("tbody tr");
        
        // 각 행을 반복 처리
        rows.forEach(row => {
            // 해당 행의 총점 (total)과 등급 (grade) 가져오기
            const totalElement = row.querySelector(".total");
            const gradeElement = row.querySelector(".grade");
            
            // 총점 값을 가져오고 숫자로 변환
            const totalValue = parseFloat(totalElement.textContent);
            
            // 등급 계산
            let grade = "";
            if (totalValue >= 90) {
                grade = "A";
            } else if (totalValue >= 80) {
                grade = "B";
            } else if (totalValue >= 70) {
                grade = "C";
            } else if (totalValue >= 60) {
                grade = "D";
            } else {
                grade = "F";
            }
            
            // 계산된 등급을 grade 태그에 설정
            gradeElement.textContent = grade;
        });
    }
	</script>
</body>
</html>