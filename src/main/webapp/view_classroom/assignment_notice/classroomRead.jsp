<%@page import="Vo.ClassroomBoardVo"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
 
<%
    request.setCharacterEncoding("UTF-8");
    String contextPath = request.getContextPath();
    
    // 조회한 글 정보
    ClassroomBoardVo vo = (ClassroomBoardVo)request.getAttribute("vo");
    String author_id = vo.getAuthor_id(); // 작성자
    String title = vo.getTitle(); // 글 제목
    String content = vo.getContent().replace("/r/n", "<br>"); // 글 내용
    
    String course_id = (String)request.getAttribute("course_id");
    String notice_id = (String)request.getAttribute("notice_id");
    String nowPage = (String)request.getAttribute("nowPage");
    String nowBlock = (String)request.getAttribute("nowBlock");
    String id = (String)session.getAttribute("id");
    String name = (String)session.getAttribute("name");
    String role_ = (String)session.getAttribute("role");
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>글 화면</title>
<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
    /* 컨테이너 스타일 */
    .form-container {
        max-width: 1000px;
        height: 525px;
        margin: 50px auto;
        padding: 20px;
        background: #fff;
        border-radius: 8px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    }

    /* 페이지 제목 */
    .page-title {
        text-align: center;
        font-size: 24px;
        font-weight: bold;
        margin-bottom: 30px;
    }

    /* 버튼 그룹 정렬 */
    .btn-group {
        display: flex;
        justify-content: flex-end;
        gap: 10px;
        margin-top: 20px;
    }
</style>
</head>
<body class="bg-light">
<div class="container form-container">
    <h1 class="page-title">글 화면</h1>
    <form id="formModify">
        <div class="mb-3 row">
            <label for="writer" class="col-sm-2 col-form-label text-end"><strong>작성자</strong></label>
            <div class="col-sm-10">
                <input type="text" class="form-control" id="writer" value="<%=vo.getUserName().getUser_name()%>" disabled>
            </div>
        </div>
        <div class="mb-3 row">
            <label for="title" class="col-sm-2 col-form-label text-end"><strong>제목</strong></label>
            <div class="col-sm-10">
                <input type="text" class="form-control" id="title" value="<%=title%>">
            </div>
        </div>
        <div class="mb-3 row">
            <label for="content" class="col-sm-2 col-form-label text-end"><strong>내용</strong></label>
            <div class="col-sm-10">
                <textarea class="form-control" id="content" rows="10"><%=content%></textarea>
            </div>
        </div>
        <div class="btn-group">
            <input type="button" id="update" value="수정" class="btn btn-primary">
            <input type="button" id="delete" onclick="javascript:deletePro('<%=notice_id%>');" value="삭제" class="btn btn-danger">
            <input type="button" id="list" value="목록" class="btn btn-secondary">
        </div>
    </form>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"></script>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script>


    // 삭제 버튼 클릭 이벤트
    function deletePro(notice_id) {
        let result = window.confirm("정말로 글을 삭제하시겠습니까?");
        if (result) {
            $.ajax({
                url: "<%=contextPath%>/classroomboard/deleteList.do",
                type: "post",
                data: { notice_id: notice_id },
                dataType: "text",
                success: function(data) {
                    if (data === "삭제성공") {
                        alert("삭제 성공");
                        $("#list").trigger("click");
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

    // 수정 버튼 클릭 이벤트
    $("#update").click(function() {
        let title = $("#title").val();
        let content = $("#content").val();

        $.ajax({
            url: "<%=contextPath%>/classroomboard/updateList.do",
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

    // 사용자 권한에 따라 버튼 활성화/비활성화
    $(document).ready(function() {
        const role = "<%=role_ %>";
        if (role === "교수") {
            $("#update").css("visibility", "visible");
            $("#delete").css("visibility", "visible");
        } else {
            $("#update").css("visibility", "hidden");
            $("#delete").css("visibility", "hidden");

            // 제목과 내용 입력창 비활성화
            $("#title").prop("disabled", true);
            $("#content").prop("disabled", true);
        }
    });

    // 목록 버튼 클릭 이벤트
    $("#list").click(function() {
        let url = "<%=contextPath%>/classroomboard/noticeList.bo?center=/view_classroom/assignment_notice/professorNotice.jsp&nowBlock=<%=nowBlock%>&nowPage=<%=nowPage%>&courseId=<%=course_id%>";
        window.location.href = url;
    });
</script>
</body>
</html>
