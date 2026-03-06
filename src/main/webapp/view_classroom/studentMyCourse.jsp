<%@page import="Vo.BoardVo"%>
<%@page import="Vo.AssignmentVo"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");
    Map<String, List> allAssignNotice = (Map<String, List>) request.getAttribute("allAssignNotice");
    String contextPath = request.getContextPath();
    String studentId = (String) session.getAttribute("student_id"); // 세션에서 student_id 가져오기
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>학생 강의실</title>
    <!-- 부트스트랩 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome 아이콘 -->
    <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
    <style>
        /* 과제 관리 헤더 */
        h1.display-4 {
            color: #4CAF50; /* 초록색 텍스트 */
        }
        /* 과제 목록 카드 */
        #assignments .card-header {
            background-color: #e8f5e9; /* 연한 초록색 */
        }
        #assignments .table thead {
            background-color: #c8e6c9; /* 중간 초록색 */
            color: #1b5e20; /* 진한 초록색 */
        }
        /* 공지사항 카드 */
        #notices .card-header {
            background-color: #e3f2fd; /* 연한 파란색 */
        }
        #notices .table thead {
            background-color: #bbdefb; /* 중간 파란색 */
            color: #0d47a1; /* 진한 파란색 */
        }
    </style>
</head>
<body class="bg-light">
    <div class="container my-5">
        <!-- 페이지 헤더 -->
        <header class="mb-4 text-center">
            <h1 class="display-4">
                <i class="fas fa-chalkboard-teacher"></i> 학생 강의실
            </h1>
            <p class="lead text-secondary">과제와 공지사항을 확인하세요.</p>
        </header>

<%
    if (allAssignNotice != null && !allAssignNotice.isEmpty()) {
%>
        <!-- 과제 목록 -->
        <section id="assignments" class="mb-5">
            <div class="card shadow border-0">
                <div class="card-header">
                    <h2 class="h4 mb-0">
                        <i class="fas fa-tasks"></i> 과제 목록
                    </h2>
                </div>
                <div class="card-body">
                    <table class="table table-striped table-bordered">
                        <thead>
                            <tr>
                                <th>강의명</th>
                                <th>제목</th>
                                <th>설명</th>
                                <th>시작일</th>
                                <th>마감일</th>
                            </tr>
                        </thead>
                        <tbody>
<%
            List assignments = allAssignNotice.get("assignments");
            if (assignments != null && !assignments.isEmpty()) {
                for (Object obj : assignments) {
                    AssignmentVo assignment = (AssignmentVo) obj;
                    
%>
                            <tr>
                                <td><%= assignment.getCourse().getCourse_name() %></td>
                                <td><%= assignment.getTitle() %></td>
                                <td><%= assignment.getDescription() %></td>
                                <td><%= assignment.getPeriod().getStartDate().toString().substring(0, assignment.getPeriod().getStartDate().toString().lastIndexOf("."))%></td>
                                <td><%= assignment.getPeriod().getEndDate().toString().substring(0, assignment.getPeriod().getStartDate().toString().lastIndexOf(".")) %></td>
                            </tr>
<%
                }
            } else {
%>
                            <tr>
                                <td colspan="6" class="text-center text-secondary">등록된 과제가 없습니다.</td>
                            </tr>
<%
            }
%>
                        </tbody>
                    </table>
                </div>
            </div>
        </section>

        <!-- 공지사항 목록 -->
        <section id="notices">
            <div class="card shadow border-0">
                <div class="card-header">
                    <h2 class="h4 mb-0">
                        <i class="fas fa-bullhorn"></i> 공지사항
                    </h2>
                </div>
                <div class="card-body">
                    <table class="table table-striped table-bordered">
                        <thead>
                            <tr>
                                <th>제목</th>
                                <th>내용</th>
                                <th>작성일</th>
                            </tr>
                        </thead>
                        <tbody>
<%
            List notices = allAssignNotice.get("notices");
            if (notices != null && !notices.isEmpty()) {
                for (Object obj : notices) {
                    BoardVo notice = (BoardVo) obj;
%>
                            <tr>
                                <td><%= notice.getTitle() %></td>
                                <td><%= notice.getContent() %></td>
                                <td><%= notice.getCreated_date() %></td>
                            </tr>
<%
                }
            } else {
%>
                            <tr>
                                <td colspan="4" class="text-center text-secondary">등록된 공지사항이 없습니다.</td>
                            </tr>
<%
            }
%>
                        </tbody>
                    </table>
                </div>
            </div>
        </section>
<%
    } else {
%>
        <div class="alert alert-info text-center">
            <i class="fas fa-info-circle"></i> 데이터가 없습니다.
        </div>
<%
    }
%>
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