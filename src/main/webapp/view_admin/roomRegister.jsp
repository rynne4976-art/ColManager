<!DOCTYPE html>
<%@page import="java.net.URLDecoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");
    String contextPath = request.getContextPath();
%>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>강의실 등록</title>
    <!-- Bootstrap CSS -->
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body {
            background-color: #f7f9fc;
        }
        .form-container {
            max-width: 600px;
            background: #ffffff;
            padding: 30px;
            margin: 50px auto;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        .form-title {
            font-size: 24px;
            font-weight: bold;
            text-align: center;
            color: #007bff;
            margin-bottom: 20px;
        }
        .form-group label {
            font-weight: 600;
        }
        .btn-primary {
            background-color: #007bff;
            border: none;
        }
        .btn-primary:hover {
            background-color: #0056b3;
        }
        .form-check-label {
            margin-left: 8px;
        }
    </style>
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
</head>
<body>
    <div class="container">
    	<!-- 페이지 헤더 -->
	    <div class="text-center mb-4 mt-5">
	        <h1 class="display-6"><i class="fas fa-book"  style="color: #4a90e2"></i> 강의실 등록</h1> <!-- 아이콘 변경 -->
	        <p class="lead">강의실을 등록할 수 있습니다.</p>
	    </div>
        <div class="form-container">
            <form action="<%=contextPath %>/classroom/roomRegister.do" method="post">
                <div class="form-group">
                    <label for="roomId"><i class="fas fa-door-open"></i> 강의실 ID</label>
                    <input type="text" class="form-control" id="roomId" name="room_id" required placeholder="예: R101">
                </div>
                <div class="form-group">
                    <label for="capacity"><i class="fas fa-users"></i> 수용 인원</label>
                    <input type="number" class="form-control" id="capacity" name="capacity" required placeholder="최대 수용 인원">
                </div>
                <div class="form-group">
                    <label><i class="fas fa-tools"></i> 장비</label>
                    <div class="d-flex flex-wrap">
                        <div class="form-check mr-3">
                            <input class="form-check-input" type="checkbox" id="equipment1" name="equipment[]" value="프로젝터">
                            <label class="form-check-label" for="equipment1">프로젝터</label>
                        </div>
                        <div class="form-check mr-3">
                            <input class="form-check-input" type="checkbox" id="equipment2" name="equipment[]" value="화이트보드">
                            <label class="form-check-label" for="equipment2">화이트보드</label>
                        </div>
                        <div class="form-check mr-3">
                            <input class="form-check-input" type="checkbox" id="equipment3" name="equipment[]" value="컴퓨터실">
                            <label class="form-check-label" for="equipment3">컴퓨터실</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="equipment4" name="equipment[]" value="실험 장비">
                            <label class="form-check-label" for="equipment4">실험 장비</label>
                        </div>
                    </div>
                </div>
                <button type="submit" class="btn btn-primary btn-block"><i class="fas fa-save"></i> 등록</button>
            </form>
        </div>
    </div>
    <!-- Bootstrap JS, Popper.js, and jQuery -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.10.2/dist/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
