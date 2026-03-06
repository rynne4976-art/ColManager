<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Vo.StudentVo" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>학생 상세 정보</title>
    <!-- Bootstrap CSS -->
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body {
            background-color: #f0f2f5;
            font-family: 'Arial', sans-serif;
        }
        #student-detail-container {
            max-width: 800px;
            background-color: #ffffff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0px 8px 16px rgba(0, 0, 0, 0.15);
            margin: 50px auto;
        }
        #student-detail-title {
            font-size: 28px;
            font-weight: bold;
            color: #4a90e2;
            text-align: center;
            margin-bottom: 20px;
        }
        #student-detail-table {
            width: 100%;
            border-collapse: collapse;
        }
        #student-detail-table th, #student-detail-table td {
            border: none;
            padding: 12px 15px;
            font-size: 16px;
        }
        #student-detail-table th {
            width: 30%;
            text-align: left;
            color: #555;
            font-weight: bold;
            background-color: #f9f9f9;
        }
        #student-detail-table td {
            width: 70%;
            color: #333;
        }
        #back-link {
            display: block;
            text-align: center;
            margin-top: 30px;
        }
        #back-link a {
            color: #4a90e2;
            text-decoration: none;
            font-size: 16px;
            font-weight: bold;
        }
        #back-link a:hover {
            text-decoration: underline;
        }
        .error-message {
            color: red;
            text-align: center;
            font-size: 18px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div id="student-detail-container">
        <h2 id="student-detail-title"><i class="fas fa-user"></i> 학생 상세 정보</h2>

        <%
        StudentVo student = (StudentVo)request.getAttribute("student");
            if (student == null) {
        %>
            <p class="error-message">학생 정보를 불러오는 데 문제가 발생했습니다.</p>
            <div id="back-link">
                <a href="${pageContext.request.contextPath}/student/viewStudentList.do"><i class="fas fa-arrow-left"></i> 목록으로 돌아가기</a>
            </div>
        <%
            } else {
        %>
            <table id="student-detail-table">
                <tr><th>학번</th><td><%= student.getStudent_id() %></td></tr>
                <tr><th>사용자 ID</th><td><%= student.getUser_id() %></td></tr>
                <tr><th>이름</th><td><%= student.getUser_name() %></td></tr>
                <tr><th>생년월일</th><td><%= student.getBirthDate() %></td></tr>
                <tr><th>성별</th><td><%= student.getGender() %></td></tr>
                <tr><th>주소</th><td><%= student.getAddress() %></td></tr>
                <tr><th>전화번호</th><td><%= student.getPhone() %></td></tr>
                <tr><th>이메일</th><td><%= student.getEmail() %></td></tr>
                <tr><th>역할</th><td><%= student.getRole() %></td></tr>
                <tr><th>전공 코드</th><td><%= student.getMajorcode() %></td></tr>
                <tr><th>학년</th><td><%= student.getGrade() %></td></tr>
                <tr><th>입학일</th><td><%= student.getAdmission_date() %></td></tr>
                <tr><th>상태</th><td><%= student.getStatus() %></td></tr>
            </table>
            <div id="back-link">
                <a href="${pageContext.request.contextPath}/student/viewStudentList.do"><i class="fas fa-arrow-left"></i> 목록으로 돌아가기</a>
            </div>
        <%
            }
        %>
    </div>
</body>
</html>