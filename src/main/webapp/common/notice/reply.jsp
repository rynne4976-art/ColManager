<%@page import="Vo.MemberVo"%> <!-- MemberVo 클래스 임포트 -->
<%@page import="Vo.BoardVo"%> <!-- BoardVo 클래스 임포트 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> <!-- JSP 페이지 설정 -->

<%
    request.setCharacterEncoding("UTF-8"); // 요청 데이터의 인코딩을 UTF-8로 설정
    String contextPath = request.getContextPath(); // 현재 애플리케이션의 컨텍스트 경로를 가져옴
    String name = (String) session.getAttribute("name"); // 세션에서 사용자 이름을 가져옴

    // 부모 글 번호를 가져와 DB에서 부모 글 정보를 조회
    String notice_id = (String) request.getAttribute("notice_id");
    MemberVo vo = (MemberVo) request.getAttribute("vo");

    String id = (String) session.getAttribute("id"); // 세션에서 사용자 ID를 가져옴
    if (id == null) { // 로그인하지 않은 경우
%>
    <script>
        alert("로그인을 하셔야 작성하실 수 있습니다."); // 알림 창 표시
        history.back(); // 이전 페이지로 이동
    </script>
<%
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"> <!-- 문서 인코딩 설정 -->
    <title>답변글 작성 화면</title> <!-- 페이지 제목 -->

    <!-- Bootstrap CSS 라이브러리 -->
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">

    <style>
        /* 폼 컨테이너 스타일 */
        .form-container {
            max-width: 800px; /* 최대 너비 */
            margin: 50px auto; /* 가운데 정렬 */
            padding: 20px; /* 내부 여백 */
            background: #fff; /* 배경색 */
            border-radius: 8px; /* 둥근 모서리 */
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); /* 그림자 효과 */
        }

        /* 페이지 제목 스타일 */
        .page-title {
            text-align: center; /* 텍스트 가운데 정렬 */
            font-size: 24px; /* 글자 크기 */
            font-weight: bold; /* 굵게 표시 */
            color: #4a90e2;
            margin-bottom: 30px; /* 하단 여백 */
        }

        /* 버튼 그룹 스타일 */
        .btn-group {
            display: flex !important; /* 플렉스 박스 레이아웃 */
            justify-content: flex-end; /* 오른쪽 정렬 */
            gap: 10px; /* 버튼 간격 */
            margin-top: 20px; /* 상단 여백 */
        }
        

        /* 읽기 전용 필드 스타일 */
        .form-control[readonly] {
            background-color: #e9ecef; /* 배경색 */
            cursor: not-allowed; /* 커서 표시 */
        }

        /* 입력 검증 메시지 스타일 */
        #pwInput {
            color: red; /* 글자 색상 */
            font-weight: bold; /* 글자 굵게 */
            text-align: center; /* 가운데 정렬 */
            margin-top: 10px; /* 상단 여백 */
        }
    </style>
</head>
<body class="bg-light"> <!-- 배경색 설정 -->

<!-- 답변글 작성 폼 -->
<div class="container form-container">
    <h1 class="page-title">답변글 작성 화면</h1> <!-- 화면 제목 -->

    <!-- 답변글 작성 폼 -->
    <form action="<%=contextPath%>/Board/replyPro.do" method="post" onsubmit="return check();">
        <input type="hidden" name="super_notice_id" value="<%=notice_id%>"> <!-- 부모 글 ID -->
        <input type="hidden" name="id" value="<%=id%>"> <!-- 사용자 ID -->

        <!-- 작성자 필드 -->
        <div class="mb-3 row">
            <label for="writer" class="col-sm-2 col-form-label text-end"><strong>작성자</strong></label>
            <div class="col-sm-10">
                <input type="text" class="form-control" id="writer" name="writer" value="<%=name%>" readonly>
            </div>
        </div>

        <!-- 제목 필드 -->
        <div class="mb-3 row">
            <label for="title" class="col-sm-2 col-form-label text-end"><strong>제목</strong></label>
            <div class="col-sm-10">
                <input type="text" class="form-control" id="title" name="title">
            </div>
        </div>

        <!-- 내용 필드 -->
        <div class="mb-3 row">
            <label for="content" class="col-sm-2 col-form-label text-end"><strong>내용</strong></label>
            <div class="col-sm-10">
                <textarea class="form-control" id="content" name="content" rows="10"></textarea>
            </div>
        </div>

        <!-- 버튼 그룹 -->
        <div class="btn-group">
            <input type="submit" id="reply" value="답변" class="btn btn-primary"> <!-- 답변 버튼 -->
            <input type="button" id="list" value="목록" class="btn btn-secondary"
                   onclick="location.href='<%=contextPath%>/Board/list.bo?center=/view_admin/noticeManage.jsp&nowBlock=0&nowPage=0'"> <!-- 목록 버튼 -->
        </div>
    </form>
    <p id="pwInput"></p> <!-- 입력 검증 메시지 표시 -->
</div>

<!-- Bootstrap 및 JQuery -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script>
    // 입력 검증 함수
    function check() {
        var writer = $("input[name='writer']").val(); // 작성자 입력값
        var title = $("input[name='title']").val(); // 제목 입력값
        var content = $("textarea[name='content']").val(); // 내용 입력값

        if (writer === "" || title === "" || content === "") { // 비어 있는 경우
            $("#pwInput").text("모두 작성해 주세요."); // 메시지 표시
            return false; // 제출 중단
        }
        return true; // 제출 허용
    }
</script>
</body>
</html>
