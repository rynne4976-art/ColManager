<%@page import="java.net.URLEncoder"%>
<%@page import="Vo.ClassroomBoardVo"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
    request.setCharacterEncoding("UTF-8");
    String contextPath = request.getContextPath();
    String course_id = (String)request.getAttribute("course_id");
    String role_ = (String)session.getAttribute("role");
    String key = (String)request.getAttribute("key");
    String word = (String)request.getAttribute("word");
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>공지사항</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script type="text/javascript">
    function fnSearch() {
        var word = document.getElementById("word").value;

        if (word == null || word == "") {
            alert("검색어를 입력하세요.");
            document.getElementById("word").focus();
            return false;
        } else {
            document.frmSearch.submit();
        }
    }

    function fnRead(val) {
        document.frmRead.action = "<%=contextPath%>/classroomboard/noticeRead.bo";
        document.frmRead.notice_id.value = val;
        document.frmRead.submit();
    }

    window.onload = function () {
        var role = "<%=role_ %>";
        if (role === "교수") {
            document.getElementById("newContent").style.visibility = "visible";
        } else {
            document.getElementById("newContent").style.visibility = "hidden";
        }
    };
</script>
</head>
<body>

<div class="container my-5" >
<%
    int totalRecord = 0;
    int numPerPage = 5;
    int pagePerBlock = 3;
    int totalPage = 0;
    int totalBlock = 0;
    int nowPage = 0;
    int nowBlock = 0;
    int beginPerPage = 0;

    ArrayList<ClassroomBoardVo> list = (ArrayList<ClassroomBoardVo>)request.getAttribute("list");
    totalRecord = list.size();

    if (request.getAttribute("nowPage") != null) {
        nowPage = Integer.parseInt(request.getAttribute("nowPage").toString());
    }

    beginPerPage = nowPage * numPerPage;
    totalPage = (int) Math.ceil((double) totalRecord / numPerPage);
    totalBlock = (int) Math.ceil((double) totalPage / pagePerBlock);

    if (request.getAttribute("nowBlock") != null) {
        nowBlock = Integer.parseInt(request.getAttribute("nowBlock").toString());
    }
%>

<form name="frmRead">
    <input type="hidden" name="center" value="/view_classroom/assignment_notice/classroomRead.jsp">
    <input type="hidden" name="notice_id">
    <input type="hidden" name="nowPage" value="<%=nowPage%>">
    <input type="hidden" name="nowBlock" value="<%=nowBlock%>">
    <input type="hidden" name="course_id" value="<%=course_id%>">
</form>

    <h2 class="text-center mb-4">교수 공지사항</h2>

    <!-- 검색 영역 -->
    <div class="container">
        <div class="row justify-content-center my-3">
            <div class="col-md-8">
                <form class="d-flex" action="<%=contextPath%>/classroomboard/searchlist.bo" method="post"  name="frmSearch">
                    <!-- 검색 필드 -->
                    <select class="form-select me-2" name="key" style="flex: 2;">
                        <option value="titleContent" selected>제목 + 내용</option>
                        <option value="name">작성자</option>
                    </select>
                    <input type="text" class="form-control me-2" name="word" id="word" placeholder="검색어를 입력하세요" style="flex: 4;">
                    <input type="hidden" name="course_id" value="<%=course_id%>">
                    <button class="btn btn-primary me-2" type="button" onclick="fnSearch()">검색</button>
                    <% if (role_.equals("교수")) { %>
                    <button class="btn btn-success" type="button" id="newContent" onclick="location.href='<%=contextPath%>/classroomboard/noticeWrite.bo?center=/view_classroom/assignment_notice/classroomWrite.jsp&nowPage=<%=nowPage%>&nowBlock=<%=nowBlock%>&course_id=<%=course_id%>'">새 글쓰기</button>
                    <% } %>
                </form>
            </div>
        </div>
    </div>

    <!-- 공지사항 테이블 -->
    <div class="card shadow-sm">
        <div class="card-body">
            <table class="table table-bordered table-hover text-center align-middle">
                <thead class="table-success">
                    <tr>
                        <th>번호</th>
                        <th>제목</th>
                        <th>내용</th>
                        <th>작성자</th>
                        <th>날짜</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        if (list.isEmpty()) {
                    %>
                    <tr>
                        <td colspan="5">등록된 글이 없습니다.</td>
                    </tr>
                    <%
                        } else {
                            for (int i = beginPerPage; i < (beginPerPage + numPerPage) && i < totalRecord; i++) {
                                ClassroomBoardVo vo = list.get(i);
                                
                    %>
                    <tr onclick="javascript:fnRead('<%=vo.getNotice_id()%>')">
                        <td><%=vo.getNotice_id()%></td>
                        <td><%=vo.getTitle()%></td>
                        <td><%=vo.getContent()%></td>
                        <td><%=vo.getUserName().getUser_name()%></td>
                        <td><%=vo.getCreated_date()%></td>
                    </tr>
                    <%
                            }
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- 페이지네이션 -->
    <div class="pagination justify-content-center mt-4">
        <%
            String searchParams = "";
            if (key != null && word != null) {
                searchParams = "&key=" + key + "&word=" + URLEncoder.encode(word, "UTF-8");
            }

            if (totalRecord != 0) { // 조회된 글이 있을 경우만 페이징 처리
                if (nowBlock > 0) { // 이전 블록 링크
        %>
        <a class="btn btn-outline-primary me-2" href="<%=contextPath%>/classroomboard/noticeList.bo?center=/view_classroom/assignment_notice/professorNotice.jsp&nowBlock=<%=nowBlock - 1%>&nowPage=<%=((nowBlock - 1) * pagePerBlock)%>&courseId=<%=course_id%><%=searchParams%>">
            ◀ 이전 <%=pagePerBlock%>개
        </a>
        <%
                }

                for (int i = 0; i < pagePerBlock; i++) {
                    int pageNum = (nowBlock * pagePerBlock) + i + 1;
                    if (pageNum > totalPage) break; // 페이지 번호 초과 시 중단
        %>
        <a class="btn btn-outline-primary me-2" href="<%=contextPath%>/classroomboard/noticeList.bo?center=/view_classroom/assignment_notice/professorNotice.jsp&nowBlock=<%=nowBlock%>&nowPage=<%=pageNum - 1%>&courseId=<%=course_id%><%=searchParams%>">
            <%=pageNum%>
        </a>
        <%
                }

                if (totalBlock > nowBlock + 1) { // 다음 블록 링크
        %>
        <a class="btn btn-outline-primary" href="<%=contextPath%>/classroomboard/noticeList.bo?center=/view_classroom/assignment_notice/professorNotice.jsp&nowBlock=<%=nowBlock + 1%>&nowPage=<%=(nowBlock + 1) * pagePerBlock%>&courseId=<%=course_id%>">
            ▶ 다음 <%=pagePerBlock%>개
        </a>
        <%
                }
            }
        %>
    </div>
</div>
</body>
</html>