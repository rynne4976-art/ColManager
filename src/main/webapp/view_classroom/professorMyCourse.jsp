<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String contextPath = (String)request.getContextPath();
    String role = (String) session.getAttribute("role");
    String profName = (String) session.getAttribute("name");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>강의실 환영 페이지</title>
    <!-- 부트스트랩 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            background-color: #f8f9fa;
        }
        .welcome-container {
        	margin-top: 100px;
            text-align: center;
            color: #333;
        }
        .welcome-icon {
            font-size: 50px;
            color: #4CAF50;
            margin-bottom: 20px;
        }
        .welcome-text {
            font-size: 1.5rem;
            font-weight: bold;
            margin-bottom: 10px;
        }
        .info-text {
            font-size: 1rem;
            color: #555;
        }
        .action-buttons {
            margin-top: 30px;
        }
        .action-buttons .btn {
            margin: 5px;
        }
    </style>
</head>
<body>
    <div class="welcome-container">
        <i class="fas fa-chalkboard-teacher welcome-icon"></i>
        <p class="display-5"> 반갑습니다. <%=profName %> <%=role %>님!</p>
        <p class="info-text">지금 강의실에서 관리할 강의와 학생 정보를 확인하거나 학생의 성적을 등록해보세요.</p>
        
        <div class="action-buttons">
            <a href="<%=contextPath%>/classroom/course_search.bo?center=/view_classroom/courseSearch.jsp" class="btn btn-primary"><i class="fas fa-book"></i> 강의 조회 바로가기 </a>
            <a href="<%=contextPath%>/classroom/course_register.bo" class="btn btn-success"><i class="fas fa-plus-circle"></i> 강의 등록 바로가기</a>
            <a href="<%=contextPath%>/classroom/course_search.bo?center=/view_classroom/courseList.jsp" class="btn btn-warning"><i class="fas fa-chart-area"></i> 성적 관리 바로가기</a>
        </div>
    </div>
     <!-- 채팅 버튼 -->
		<a href="javascript:void(0);" id="chat" onclick="chatWinOpen();" style="position: fixed; bottom: 20px; right: 20px; z-index: 9999;"> 
		    <img src="../img/chatIcon.png" alt="채팅" style="width: 50px; height: 50px;"/> 
		</a>
		 <script type="text/javascript">
	    function chatWinOpen() {
	        // 팝업 창 크기 설정
	        var width = 395;
	        var height = 445;
	
	     	// 팝업 창 위치 설정 (우측 하단)
	        var left = window.screen.availWidth - width - 120;  // 화면의 오른쪽 끝에서 20px 안쪽
	        var top = window.screen.availHeight - height - 150; // 화면의 아래쪽 끝에서 20px 안쪽
	
	        // 팝업 창 열기
	        var popup = window.open("<%=contextPath%>/common/ChatWindow.jsp", "ChatWindow", "width=" + width + ",height=" + height + ",left=" + left + ",top=" + top + ",resizable=no,scrollbars=no");
	
	        // 팝업 창이 제대로 열리지 않을 경우 알림
	        if (!popup || popup.closed || typeof popup.closed === 'undefined') {
	            alert("팝업 차단이 활성화되어 있습니다. 팝업 차단을 해제하고 다시 시도해주세요.");
	        }
	    }
    </script>
		
    <!-- 부트스트랩 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
