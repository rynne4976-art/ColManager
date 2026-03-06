<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Vo.StudentVo" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>전체 학생 목록</title>
    <!-- Bootstrap CSS -->
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body {
            background-color: #f0f2f5;
            font-family: 'Arial', sans-serif;
        }
        #student-list-container {
            max-width: 900px;
            background-color: #ffffff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0px 8px 16px rgba(0, 0, 0, 0.15);
            margin: 50px auto;
        }
        #student-list-title {
            font-size: 28px;
            font-weight: bold;
            color: #4a90e2;
            text-align: center;
            margin-bottom: 20px;
        }
        #student-list-table {
            width: 100%;
            margin: 20px 0;
            border-collapse: collapse;
        }
        #student-list-table th, #student-list-table td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: center;
            font-size: 14px;
        }
        #student-list-table th {
            background-color: #4a90e2;
            color: white;
            font-weight: bold;
        }
        #student-list-table tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        #student-list-table tr:hover {
            background-color: #f1f1f1;
        }
        .btn-link {
            color: #4a90e2;
            text-decoration: none;
        }
        .btn-link:hover {
            text-decoration: underline;
        }
        .action-link {
            font-weight: bold;
        }
    </style>
    <script>
        function confirmDelete() {
            return confirm("정말로 삭제하시겠습니까?");
        }
        window.onload = function () {
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.get('message')) {
                alert(urlParams.get('message'));
            }
        };
    </script>
</head>
<body>
    <div id="student-list-container">
        <h2 id="student-list-title"><i class="fas fa-users"></i> 전체 학생 목록</h2>
        <table id="student-list-table">
            <thead>
                <tr id="table-header">
                    <th id="header-student-id">학번</th>
                    <th id="header-user-id">사용자 ID</th>
                    <th id="header-name">이름</th>
                    <th id="header-major-code">전공 코드</th>
                    <th id="header-grade">학년</th>
                    <th id="header-admission-date">입학일</th>
                    <th id="header-status">상태</th>
                    <th id="header-view">상세보기</th>
                    <th id="header-edit">수정</th>
                    <th id="header-delete">삭제</th>
                </tr>
            </thead>
            <tbody>
            <%
                List<StudentVo> students = (List<StudentVo>) request.getAttribute("students");
                if (students != null && !students.isEmpty()) {
                    for (StudentVo student : students) {
            %>
                    <tr class="student-row">
                        <td class="student-id"><%= student.getStudent_id() %></td>
                        <td class="user-id"><%= student.getUser_id() %></td>
                        <td class="user-name"><%= student.getUser_name() %></td>
                        <td class="major-code"><%= student.getMajorcode() %></td>
                        <td class="grade"><%= student.getGrade() %></td>
                        <td class="admission-date"><%= student.getAdmission_date() %></td>
                        <td class="status"><%= student.getStatus() %></td>
                        <td class="view-action">
                            <a class="btn-link action-link" href="${pageContext.request.contextPath}/student/viewStudent.do?user_id=<%= student.getUser_id() %>">상세보기</a>
                        </td>
                        <td class="edit-action">
                            <a class="btn-link action-link" href="${pageContext.request.contextPath}/student/editStudent.do?user_id=<%= student.getUser_id() %>">수정</a>
                        </td>
                        <td class="delete-action">
                            <a class="btn-link action-link" href="${pageContext.request.contextPath}/student/deleteStudent.do?student_id=<%= student.getStudent_id() %>" onclick="return confirmDelete();">삭제</a>
                        </td>
                    </tr>
            <%
                    }
                } else {
            %>
                    <tr id="no-data-row">
                        <td colspan="10">학생 정보가 없습니다.</td>
                    </tr>
            <%
                }
            %>
            </tbody>
        </table>
    </div>
</body>
</html>