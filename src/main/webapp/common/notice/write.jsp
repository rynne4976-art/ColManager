<%@page import="Vo.BoardVo"%> <!-- BoardVo 클래스 임포트 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> <!-- JSP 페이지 설정 -->

<%
    request.setCharacterEncoding("UTF-8"); // 요청 데이터의 인코딩을 UTF-8로 설정
    String contextPath = request.getContextPath(); // 애플리케이션의 컨텍스트 경로
    String nowPage = (String) request.getAttribute("nowPage"); // 현재 페이지 정보
    String nowBlock = (String) request.getAttribute("nowBlock"); // 현재 블록 정보
    String id = (String) session.getAttribute("id"); // 세션에서 사용자 ID 가져오기
    String name = (String) session.getAttribute("name"); // 세션에서 사용자 이름 가져오기
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"> <!-- 문서 인코딩 설정 -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0"> <!-- 반응형 웹 설정 -->
    <title>글 작성 화면</title> <!-- 페이지 제목 -->

    <!-- Bootstrap CSS -->
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            background-color: #f0f2f5; /* 배경색 */
            font-family: 'Arial', sans-serif; /* 글꼴 */
        }

        .form-container {
            max-width: 800px; /* 최대 너비 */
            margin: 50px auto; /* 가운데 정렬 */
            padding: 20px; /* 내부 여백 */
            background: #fff; /* 배경색 */
            border-radius: 8px; /* 둥근 모서리 */
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); /* 그림자 효과 */
        }

        .page-title {
            text-align: center; /* 텍스트 가운데 정렬 */
            font-size: 28px; /* 제목 글자 크기 */
            font-weight: bold; /* 굵게 표시 */
            margin-bottom: 30px; /* 하단 여백 */
            color: #4a90e2; /* 텍스트 색상 */
        }

        .btn-group {
		    display: flex !important; /* 우선순위 높이기 */
		    justify-content: center !important; /* 가운데 정렬 */
		    gap: 10px;
		    margin-top: 20px;
		}

        .form-control[readonly] {
            background-color: #e9ecef; /* 읽기 전용 배경색 */
            cursor: not-allowed; /* 커서 설정 */
        }

        #pwInput {
            color: red; /* 에러 메시지 색상 */
            font-weight: bold; /* 굵은 글씨 */
            text-align: center; /* 가운데 정렬 */
            margin-top: 10px; /* 상단 여백 */
        }
    </style>
</head>
<body class="bg-light"> <!-- 부드러운 배경색 설정 -->

<div class="container form-container">
    <h1 class="page-title">글 작성 화면</h1> <!-- 화면 제목 -->

    <form>
        <!-- 작성자 입력 필드 -->
        <div class="mb-3 row">
            <label for="writer" class="col-sm-2 col-form-label text-end"><strong>작성자</strong></label> <!-- 작성자 라벨 -->
            <div class="col-sm-10">
                <input type="text" class="form-control" id="writer" value="<%=name %>" readonly> <!-- 읽기 전용 필드 -->
                <input type="hidden" name="writer" value="<%=id %>" /> <!-- 작성자 ID 숨김 필드 -->
            </div>
        </div>

        <!-- 제목 입력 필드 -->
        <div class="mb-3 row">
            <label for="title" class="col-sm-2 col-form-label text-end"><strong>제목</strong></label> <!-- 제목 라벨 -->
            <div class="col-sm-10">
                <input type="text" class="form-control" id="title" name="title"> <!-- 제목 입력 필드 -->
            </div>
        </div>

        <!-- 내용 입력 필드 -->
        <div class="mb-3 row">
            <label for="content" class="col-sm-2 col-form-label text-end"><strong>내용</strong></label> <!-- 내용 라벨 -->
            <div class="col-sm-10">
                <textarea class="form-control" id="content" name="content" rows="10"></textarea> <!-- 내용 입력 필드 -->
            </div>
        </div>

        <!-- 버튼 그룹 -->
        <div class="btn-group">
            <input type="button" id="registration1" value="등록" class="btn btn-primary"> <!-- 등록 버튼 -->
            <input type="button" id="list" value="목록" class="btn btn-secondary"> <!-- 목록 버튼 -->
        </div>
        <p id="pwInput"></p> <!-- 에러 메시지 표시 영역 -->
    </form>
</div>

<!-- Bootstrap 및 JQuery -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>

<script>
    // 목록 버튼 클릭 이벤트
    $("#list").click(function(event) {
        event.preventDefault(); // 기본 동작 차단
        location.href = "<%=contextPath%>/Board/list.bo?center=/view_admin/noticeManage.jsp&nowPage=<%=nowPage%>&nowBlock=<%=nowBlock%>";
    });

    // 등록 버튼 클릭 이벤트
    $("#registration1").click(function(event) {
        event.preventDefault(); // 기본 동작 차단

        let writer = $("input[name=writer]").val(); // 작성자 값 가져오기
        let title = $("input[name=title]").val(); // 제목 값 가져오기
        let content = $("textarea[name=content]").val(); // 내용 값 가져오기

        // 입력값 확인
        if (!title || !content) {
            $("#pwInput").text("제목과 내용을 모두 입력해주세요."); // 에러 메시지 표시
            return;
        }

        // Ajax를 통해 서버에 데이터 전송
        $.ajax({
            url: "<%=contextPath%>/Board/writePro.bo", // 서버 URL
            type: "post", // 요청 방식
            async: true, // 비동기 처리
            data: { w: writer, t: title, c: content }, // 요청 데이터
            dataType: "text", // 데이터 형식
            success: function(responseData) {
                if (responseData === "1") { // 성공 시
                    $("#pwInput").text("글 작성 완료!").css("color", "green");
                    let result = window.confirm("작성한 글을 조회하시겠습니까?");
                    if (result) {
                        location.href = "<%=contextPath%>/Board/list.bo?center=/view_admin/noticeManage.jsp";
                    }
                } else { // 실패 시
                    $("#pwInput").text("글 작성 실패!").css("color", "red");
                }
            }
        });
    });
</script>
</body>
</html>
