<%@page import="Vo.BoardVo"%> <!-- BoardVo 클래스 임포트 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> <!-- JSP 페이지 설정 -->

<%
    request.setCharacterEncoding("UTF-8"); // 요청 데이터의 인코딩을 UTF-8로 설정
    String contextPath = request.getContextPath(); // 현재 애플리케이션의 컨텍스트 경로를 가져옴

    // 요청에서 조회된 글 정보를 가져옴
    BoardVo vo = (BoardVo) request.getAttribute("vo"); 
    String author_id = vo.getAuthor_id(); // 글 작성자 ID
    String title = vo.getTitle(); // 글 제목
    String content = vo.getContent().replace("\r\n", "<br>"); // 글 내용을 줄바꿈 처리

    // 현재 글과 페이지 관련 데이터
    String notice_id = (String) request.getAttribute("notice_id");
    String nowPage = (String) request.getAttribute("nowPage");
    String nowBlock = (String) request.getAttribute("nowBlock");

    // 세션에서 사용자 정보 가져오기
    String id = (String) session.getAttribute("id"); // 로그인된 사용자 ID
    String name = (String) session.getAttribute("name"); // 로그인된 사용자 이름
    String role_ = (String) session.getAttribute("role"); // 사용자 역할 (예: 관리자)
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"> <!-- 문서 인코딩 설정 -->
    <title>공지</title> <!-- 페이지 제목 -->

    <!-- Bootstrap CSS 라이브러리 -->
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">

    <style>
        /* 전체 배경 색상 및 폰트 설정 */
        body {
            background-color: #f0f2f5;
            font-family: 'Arial', sans-serif;
        }

        /* 폼 컨테이너 스타일 */
        .form-container {
            max-width: 800px;
            margin: 50px auto;
            padding: 30px;
            background-color: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        /* 페이지 제목 스타일 */
        .page-title {
            text-align: center;
            font-size: 24px;
            font-weight: bold;
            color: #4a90e2;
            margin-bottom: 30px;
        }

        /* 버튼 그룹 스타일 */
		.btn-group {
		    display: flex !important; /* 우선순위 높이기 */
		    justify-content: center !important; /* 가운데 정렬 */
		    gap: 10px;
		    margin-top: 20px;
		}


        /* 공통 버튼 스타일 */
        .btn {
            border-radius: 5px;
            padding: 10px 20px;
            font-size: 14px;
        }

        /* 버튼 별 색상 및 상태 */
        .btn-primary {
            background-color: #4a90e2;
            border: none;
        }
        .btn-primary:hover {
            background-color: #357abd;
        }

        .btn-danger {
            background-color: #d9534f;
            border: none;
        }
        .btn-danger:hover {
            background-color: #c9302c;
        }

        .btn-secondary {
            background-color: #5bc0de;
            border: none;
        }
        .btn-secondary:hover {
            background-color: #31b0d5;
        }

        .btn-light {
            background-color: #f7f7f7;
            border: 1px solid #ddd;
        }
        .btn-light:hover {
            background-color: #e7e7e7;
        }
    </style>
</head>
<body>

<!-- 수정 화면 폼 -->
<div class="container form-container">
    <h1 class="page-title">공지</h1> <!-- 화면 제목 -->

    <!-- 글 수정 폼 -->
    <form id="formModify">
        <div class="mb-3 row">
            <label for="writer" class="col-sm-2 col-form-label text-end"><strong>작성자</strong></label>
            <div class="col-sm-10">
                <!-- 작성자 이름을 표시하는 필드 -->
                <input type="text" class="form-control" id="writer" value="<%=vo.getUserName().getUser_name()%>" disabled>
            </div>
        </div>
        <div class="mb-3 row">
            <label for="title" class="col-sm-2 col-form-label text-end"><strong>제목</strong></label>
            <div class="col-sm-10">
                <!-- 제목 입력 필드 -->
                <input type="text" class="form-control" id="title" value="<%=title%>">
            </div>
        </div>
        <div class="mb-3 row">
            <label for="content" class="col-sm-2 col-form-label text-end"><strong>내용</strong></label>
            <div class="col-sm-10">
                <!-- 내용 입력 필드 -->
                <textarea class="form-control" id="content" rows="10"><%=content%></textarea>
            </div>
        </div>
        <!-- 버튼 그룹 -->
        <div class="btn-group">
            <input type="button" id="update" value="수정" class="btn btn-primary" style="visibility: hidden;" > <!-- 수정 버튼 -->
            <input type="button" id="delete" onclick="javascript:deletePro('<%=notice_id%>');" value="삭제" class="btn btn-danger" style="visibility: hidden;"> <!-- 삭제 버튼 -->
            <input type="button" id="reply" value="답변" class="btn btn-secondary" style="visibility: hidden;"> <!-- 답변 버튼 -->
            <input type="button" id="list" value="목록" class="btn btn-light"> <!-- 목록 버튼 -->
        </div>
    </form>
</div>

<!-- 답변 작성 폼 -->
<form id="replyForm" action="<%=contextPath%>/Board/reply.do">
    <input type="hidden" name="notice_id" value="<%=notice_id%>" id="notice_id"> <!-- 글 ID -->
    <input type="hidden" name="id" value="<%=id%>"> <!-- 사용자 ID -->
</form>

<!-- Bootstrap 및 JQuery -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script>
    // 답변 버튼 클릭 이벤트
    $("#reply").on("click", function() {
        $("#replyForm").submit(); // 답변 폼 제출
    });

    // 삭제 요청 함수
    function deletePro(notice_id) {
        let result = window.confirm("정말로 글을 삭제하시겠습니까?");
        if (result) {
            $.ajax({
                url: "<%=contextPath%>/Board/deleteBoard.do",
                type: "post",
                data: { notice_id: notice_id },
                dataType: "text",
                success: function(data) {
                    if (data === "삭제성공") {
                        alert("삭제 성공");
                        $("#list").trigger("click"); // 목록 버튼 트리거
                    } else {
                        alert("삭제 실패");
                    }
                },
                error: function() {
                    alert("삭제 요청 실패");
                }
            });
        }
    }

    // 수정 요청 함수
    $("#update").click(function() {
        let title = $("#title").val();
        let content = $("#content").val();

        $.ajax({
            url: "<%=contextPath%>/Board/updateBoard.do",
            type: "post",
            data: {
                title: title,
                content: content,
                notice_id: "<%=notice_id%>"
            },
            dataType: "text",
            success: function(data) {
                if (data === "수정성공") {
                    alert("수정 성공");
                } else {
                    alert("수정 실패");
                }
            },
            error: function() {
                alert("수정 요청 실패");
            }
        });
    });

    // 사용자 권한에 따른 버튼 활성화/비활성화
    $(document).ready(function() {
        const role = "<%=role_%>";
        if (role === "관리자") {
            $("#update, #delete, #reply").css("visibility", "visible");
        } else {
            $("#update, #delete, #reply").css("visibility", "hidden");
            $("#title, #content").prop("disabled", true); // 일반 사용자 입력 비활성화
        }
    });

    // 목록 버튼 클릭 이벤트
    $("#list").click(function() {
        const role = "<%=role_%>";
        let url = role === "관리자" 
            ? "<%=contextPath%>/Board/list.bo?center=/view_admin/noticeManage.jsp&nowBlock=<%=nowBlock%>&nowPage=<%=nowPage%>"
            : "<%=contextPath%>/Board/list.bo?center=/common/notice/list.jsp&nowBlock=<%=nowBlock%>&nowPage=<%=nowPage%>";
        window.location.href = url;
    });
</script>
</body>
</html>
