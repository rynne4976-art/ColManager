<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
	// JSP 내 서버 데이터 준비 (사용자 ID, 페이지 정보 등)
	request.setCharacterEncoding("UTF-8");
	String contextPath = request.getContextPath();
	
	String nowPage = (String)request.getAttribute("nowPage");
	String nowBlock = (String)request.getAttribute("nowBlock");
	
	String id = (String)session.getAttribute("id");
	String course_id = (String)request.getAttribute("course_id");
	String user_name = (String)session.getAttribute("name");
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>공지사항 글쓰기</title>

<style>
    /* 컨테이너 스타일 */
    .container {
        max-width: 800px;
        margin: 50px auto;
        padding: 20px;
        background: #fff;
        border-radius: 8px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    }

    /* 페이지 제목 */
    h1 {
        text-align: center;
        font-size: 24px;
        font-weight: bold;
        margin-bottom: 30px;
    }

    /* 입력 폼 테이블 스타일 */
    table {
        width: 100%;
        margin-top: 20px;
        border-collapse: collapse;
    }

    table td {
        padding: 15px;
        vertical-align: top;
        border-bottom: 1px solid #e9ecef;
    }

    table td:first-child {
        width: 20%;
        font-weight: bold;
        background-color: #f7f9fc;
        text-align: center;
    }

    table td:last-child {
        background-color: #fff;
    }

    /* 입력 필드 스타일 */
    input[type="text"],
    textarea {
        width: 100%;
        padding: 10px;
        border: 1px solid #ced4da;
        border-radius: 5px;
        font-size: 14px;
        color: #495057;
    }

    textarea {
        resize: none;
    }

    input[type="text"]:read-only {
        background-color: #e9ecef;
        cursor: not-allowed;
    }

    /* 버튼 그룹 */
    .button-group {
        text-align: center;
        margin-top: 20px;
    }

    .button-group input[type="button"] {
        font-size: 16px;
        font-weight: bold;
        padding: 12px 24px;
        margin: 10px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        transition: all 0.3s ease;
    }

    .button-group input[type="button"]#registration1 {
        background-color: #007bff;
        color: #fff;
    }

    .button-group input[type="button"]#registration1:hover {
        background-color: #0056b3;
    }

    .button-group input[type="button"]#list {
        background-color: #6c757d;
        color: #fff;
    }

    .button-group input[type="button"]#list:hover {
        background-color: #495057;
    }

    /* 결과 텍스트 */
    #resultInsert {
        text-align: center;
        font-size: 16px;
        font-weight: bold;
        margin-top: 10px;
    }

    /* 모바일 반응형 */
    @media (max-width: 768px) {
        .container {
            width: 90%;
        }

        h1 {
            font-size: 20px;
        }

        input[type="text"],
        textarea {
            font-size: 12px;
        }

        .button-group input[type="button"] {
            font-size: 14px;
            padding: 10px 20px;
        }
    }
</style>

<script src="http://code.jquery.com/jquery-latest.min.js"></script>
</head>
<body>
<div class="container">
    <h1>공지사항 글쓰기</h1>
    <!-- 입력 폼 영역 -->
    <table>
        <tr>
            <td>작성자</td>
            <td>
            	<input type="text" value="<%=user_name%>" readonly>
                <input type="hidden" name="writer" value="<%=id %>" readonly />
            </td>
        </tr>
        <tr>
            <td>제목</td>
            <td>
                <input type="text" name="title" />
            </td>
        </tr>
        <tr>
            <td>내용</td>
            <td>
                <textarea name="content" rows="10"></textarea>
            </td>
        </tr>
    </table>
    <!-- 버튼 영역 -->
    <div class="button-group">
        <input type="button" id="registration1" value="등록">
        <input type="button" id="list" value="목록">
    </div>
    <div id="resultInsert"></div>
</div>
<script type="text/javascript">
    // 목록 버튼 클릭 이벤트
    $("#list").click(function(event) {
        event.preventDefault();
        location.href = "<%=contextPath%>/classroomboard/noticeList.bo?center=/view_classroom/assignment_notice/professorNotice.jsp&courseId=<%=course_id %>&nowPage=<%=nowPage%>&nowBlock=<%=nowBlock%>";
    });

    // 등록 버튼 클릭 이벤트
    $("#registration1").click(function(event) {
        event.preventDefault();

        let writer = $("input[name=writer]").val();
        let title = $("input[name=title]").val();
        let content = $("textarea[name=content]").val();

        $.ajax({
            url: "<%=contextPath%>/classroomboard/noticeWritePro.bo",
            type: "post",
            async: true,
            data: { 
					w: writer, 
					t: title, 
					c: content ,
					course_id : '<%=course_id%>'
			},
            dataType: "text",
            success: function(responseData) {
                if (responseData === "1") {
                    $("#resultInsert").text("글 작성 완료!").css("color", "green");
                    if (window.confirm("작성한 글을 조회해서 보기 위해 목록 페이지로 이동하시겠습니까?")) {
                        location.href = "<%=contextPath%>/classroomboard/noticeList.bo?center=/view_classroom/assignment_notice/professorNotice.jsp&courseId=<%=course_id %>&nowPage=<%=nowPage%>&nowBlock=<%=nowBlock%>";
                    }
                } else {
                    $("#resultInsert").text("글 작성 실패!").css("color", "red");
                }
            }
        });
    });
</script>
</body>
</html>
