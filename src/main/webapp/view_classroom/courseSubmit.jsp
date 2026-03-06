<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="Vo.StudentVo"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Vo.CourseVo"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String contextPath = request.getContextPath();
    ArrayList<CourseVo> courseList = (ArrayList<CourseVo>)request.getAttribute("courseList");
    ArrayList<CourseVo> courseList2 = (ArrayList<CourseVo>) request.getAttribute("courseList2");
    Boolean isEnrollmentPeriod = (Boolean) request.getAttribute("isEnrollmentPeriod");
    // Controller에서 전달된 시작 날짜와 종료 날짜 가져오기
    LocalDateTime startDate = (LocalDateTime) request.getAttribute("startDate");
    LocalDateTime endDate = (LocalDateTime) request.getAttribute("endDate");
    
    // 한글 날짜 형식 포맷터
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy년 MM월 dd일 HH시 mm분 ss초");

    String formattedStartDate = startDate != null ? startDate.format(formatter) : null;
    String formattedEndDate = endDate != null ? endDate.format(formatter) : null;
    
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
            background-color: #4CAF50;
            color: white;
        }

        .btn-green:hover {
            background-color: #45a049;
        }

        .btn-danger:hover {
            background-color: #d9534f;
        }
    </style>
    
</head>
<body class="bg-light">
    <main class="container my-5">
        <!-- 수강신청 기간 알림 -->
        <c:if test="${!isEnrollmentPeriod}">
            <div class="alert alert-danger text-center" role="alert">
		        현재는 수강신청 기간이 아닙니다. 수강신청 가능 기간: 
		        <%= formattedStartDate %> ~ <%= formattedEndDate %>
		    </div>
        </c:if>

        <div class="card shadow-sm">
            <h2 class="text-center mb-4 mt-4">수강 목록</h2>
            <div class="card-body">
                <table class="table table-bordered table-hover text-center align-middle">
                    <thead class="table-success">
                        <tr>
                            <th scope="col">과목 코드</th>
                            <th scope="col">과목 이름</th>
                            <th scope="col">교수명</th>
                            <th scope="col">강의실</th>
                            <th scope="col">수 강</th>
                        </tr>
                    </thead>
                    <tbody id="courseTableBody">
                        <% for (CourseVo course : courseList) { %>
                        <tr>
                            <td><%=course.getCourse_id()%></td>
                            <td><%=course.getCourse_name()%></td>
                            <td><%=course.getProfessor_name().getUser_name()%></td>
                            <td><%=course.getRoom_id()%></td>
                            <td>
                                <% if (isEnrollmentPeriod) { %>
                                    <button class="btn btn-green register-btn" onclick="moveToApply(this)">수강</button>
                                <% } else { %>
                                    <button class="btn btn-green register-btn" disabled>기간 외</button>
                                <% } %>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
        <br>
        <hr>
        <br>
        <div class="card shadow-sm">
            <h2 class="text-center mb-4 mt-4">신청 목록</h2>
            <div class="card-body">
                <table class="table table-bordered table-hover text-center align-middle">
                    <thead class="table-success">
                        <tr>
                            <th scope="col">과목 코드</th>
                            <th scope="col">과목 이름</th>
                            <th scope="col">교수명</th>
                            <th scope="col">강의실</th>
                            <th scope="col">취 소</th>
                        </tr>
                    </thead>
                    <tbody id="applyTableBody">
                        <% for (CourseVo course1 : courseList2) { %>
                        <tr>
                            <td><%=course1.getCourse_id()%></td>
                            <td><%=course1.getCourse_name()%></td>
                            <td><%=course1.getProfessor_name().getUser_name()%></td>
                            <td><%=course1.getRoom_id()%></td>
                            <td>
                                <% if (isEnrollmentPeriod) { %>
                                    <button class="btn btn-danger cancel-btn" onclick="moveToCourse(this)">취소</button>
                                <% } else { %>
                                    <button class="btn btn-danger cancel-btn" disabled>기간 외</button>
                                <% } %>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- 수강신청 종료 -->
        <div class="text-center mt-5">
            <p class="text-danger">수강신청을 종료하면 나의 강의실에 강의가 보입니다!</p>
            <button class="btn btn-primary btn-lg" onclick="finishEnrollment()">수강신청 종료하기</button>
        </div>
    </main>
    <script type="text/javascript">
        function moveToApply(button) {
            const row = button.closest("tr");
            const courseId = row.cells[0].innerText;
            document.getElementById("applyTableBody").appendChild(row);
            button.textContent = "취소";
            button.className = "btn btn-danger cancel-btn";
            button.setAttribute("onclick", "moveToCourse(this)");
            sendDataToController(courseId, "courseInsert.do");
        }

        function moveToCourse(button) {
            const row = button.closest("tr");
            const courseId = row.cells[0].innerText;
            document.getElementById("courseTableBody").appendChild(row);
            button.textContent = "수강";
            button.className = "btn btn-green register-btn";
            button.setAttribute("onclick", "moveToApply(this)");
            sendDataToController(courseId, "courseDelete.do");
        }

        function sendDataToController(courseId, action) {
            var url = "<%=contextPath%>/classroom/" + action + "?classroomCenter=/view_classroom/courseSubmit.jsp";
            $.ajax({
                url: url,
                type: "POST",
                data: {
                    courseId: courseId
                },
                success: function (response) {
                    if (response === "Success") {
                        alert("성공!");
                    } else {
                        alert("실패!");
                    }
                },
            });
        }

        function finishEnrollment() {
            alert("수강신청이 종료되었습니다!");
            window.location.href = "<%=contextPath%>/classroom/allAssignNotice.do";
        }
    </script>
</body>
</html>