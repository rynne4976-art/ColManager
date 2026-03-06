<%@page import="java.net.URLDecoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="Vo.ClassroomVo"%>

<%
request.setCharacterEncoding("UTF-8");
String contextPath = request.getContextPath();

String majorName = (String) request.getAttribute("majorname");
ArrayList<ClassroomVo> rooms = (ArrayList<ClassroomVo>) request.getAttribute("rooms");
if (rooms == null) {
    rooms = new ArrayList<>(); // rooms가 null일 경우 빈 ArrayList로 초기화
}
String userId = (String) session.getAttribute("professor_id");
%>

<%
    String message = (String) request.getAttribute("message");
    if (message != null) {
        message = URLDecoder.decode(message, "UTF-8");
%>
        <script>
            alert('<%= message %>'); // 메시지를 알림으로 표시
        </script>
<%
    }
%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>강의 등록</title>
</head>
<body>
    <div class="container mt-5">
    
        <div class="text-center mt-5">
            <h1 class="display-4"><i class="fas fa-chalkboard-teacher"></i>  수강 등록</h1>
            <p class="lead">교수님의 강의를 등록해 주세요!</p>
        </div>
        <div class="card shadow-lg p-4">
            <form action="<%=contextPath%>/classroom/course_register.do" method="post">
                <div class="mb-4">
                    <label for="course_name" class="form-label"><i class="fas fa-book"></i> 강의명</label>
                    <input type="text" class="form-control" name="course_name" id="course_name" required>
                </div>
                <div class="mb-4">
                    <label for="majorname" class="form-label"><i class="fas fa-university"></i> 학과</label>
                    <input type="text" class="form-control" name="majorname" id="majorname" value="<%=majorName%>" readonly>
                </div>
                <div class="mb-4">
                    <label for="room_id" class="form-label"><i class="fas fa-door-open"></i> 강의실</label>
                    <select class="form-select" name="room_id" id="room_id" required>
                        <option value="">강의실을 선택하세요</option>
                        <%
                        for (ClassroomVo room : rooms) {
                            String roomId = room.getRoom_id();
                            int capacity = room.getCapacity();
                            String equipment = room.getEquipment();
                        %>
                        <option value="<%=roomId%>"><%=roomId%> (<%=capacity%>명, <%=equipment%>)</option>
                        <%
                        }
                        %>
                    </select>
                </div>
                <div class="mb-4">
                    <label for="professor_id" class="form-label"><i class="fas fa-id-badge"></i> 교수 ID</label>
                    <input type="text" class="form-control" name="professor_id" id="professor_id" value="<%=userId%>" readonly>
                </div>
                <div class="d-grid">
                    <button type="submit" class="btn btn-primary btn-lg"><i class="fas fa-save"></i> 강의 등록</button>
                </div>
            </form>
        </div>
    </div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
