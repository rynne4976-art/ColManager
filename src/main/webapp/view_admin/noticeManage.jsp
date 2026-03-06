<%@page import="java.net.URLEncoder"%>
<%@page import="Vo.BoardVo"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
    request.setCharacterEncoding("UTF-8");
    String contextPath = request.getContextPath();
    String key = (String)request.getAttribute("key");
    String word = (String)request.getAttribute("word");

    int totalRecord = 0; // 전체 게시글 수
    int numPerPage = 5; // 한 페이지에 표시할 게시글 수
    int pagePerBlock = 3; // 한 블록에 표시할 페이지 수
    int totalPage = 0; // 총 페이지 수
    int totalBlock = 0; // 총 블록 수
    int nowPage = 0; // 현재 페이지
    int nowBlock = 0; // 현재 블록
    int beginPerPage = 0; // 페이지 내 게시글 시작 번호

    // 게시글 리스트
    ArrayList<BoardVo> list = (ArrayList<BoardVo>) request.getAttribute("list");
    totalRecord = list.size();

    // 현재 페이지와 블록 정보
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
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>공지사항</title>

    <!-- Bootstrap CSS -->
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
	<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">

    <style>
        body {
            background-color: #f0f2f5;
            font-family: 'Arial', sans-serif;
        }

        #board-container {
            max-width: 100%;
            background-color: #ffffff;
            padding: 30px;
            border-radius: 12px;
           /*  box-shadow: 0px 8px 16px rgba(0, 0, 0, 0.15); */
            margin: 0px auto;
        }

        #board-title {
            font-size: 40px;
            font-weight: bold;
            color: #4a90e2;
            text-align: center;
            margin-bottom: 20px;
        }

        #board-table {
            width: 100%;
            margin: 20px 0;
            border-collapse: collapse;
        }

        #board-table th, #board-table td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: left;
            font-size: 14px;
        }

        #board-table th {
            background-color: #4a90e2;
            color: white;
            font-weight: bold;
            text-align: center;
        }

        #board-table tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        #board-table tr:hover {
            background-color: #f1f1f1;
        }

        .btn-link {
            color: #4a90e2;
            text-decoration: none;
        }

        .btn-link:hover {
            text-decoration: underline;
        }

        .pagination a {
            color: #4a90e2;
            text-decoration: none;
        }

        .pagination a:hover {
            background-color: #4a90e2;
            color: white;
        }

        .search-bar {
            display: flex;
            justify-content: center;
            align-items: center;
            margin-bottom: 20px;
        }

        .search-bar select, .search-bar input, .search-bar .btn {
            height: 40px;
            font-size: 14px;
            border-radius: 5px;
        }

        .search-bar select {
            width: 170px;
            padding: 5px 10px;
        }

        .search-bar input {
            flex-grow: 1;
            margin: 0 10px;
            padding: 5px 10px;
        }

        .search-bar .btn {
            background-color: #4a90e2;
            color: white;
            border: none;
            padding: 0 15px;
            display: inline-flex;
            white-space: nowrap; /* 텍스트 줄바꿈 방지 */
            justify-content: center;
            align-items: center;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .search-bar .btn:hover {
            background-color: #357abd;
        }
    </style>

    <script>
        function fnSearch() {
            var word = document.getElementById("word").value;
            if (!word) {
                alert("검색어를 입력하세요.");
                document.getElementById("word").focus();
                return false;
            }
            return true;
        }

        function fnRead(val) {
            document.frmRead.action = "<%=contextPath%>/Board/read.bo";
            document.frmRead.notice_id.value = val;
            document.frmRead.submit();
        }
    </script>
</head>
<body>

    <!-- 글 상세 조회용 폼 -->
    <form name="frmRead">
        <input type="hidden" name="notice_id">
        <input type="hidden" name="nowPage" value="<%=nowPage%>">
        <input type="hidden" name="nowBlock" value="<%=nowBlock%>">
    </form>

    <div id="board-container">
        <h1 id="board-title"><i class="fas fa-bullhorn"></i> 공지사항</h1>

        <!-- 검색 영역 -->
        <div class="search-bar">
            <form action="<%=contextPath%>/Board/searchlist.bo" method="post" name="frmSearch" class="d-flex" onsubmit="return fnSearch();">
                <select name="key" class="form-select">
                    <option value="titleContent">제목 + 내용</option>
                    <option value="name">작성자</option>
                </select>
                <input type="text" name="word" id="word" class="form-control" placeholder="검색어를 입력하세요">
                <button type="submit" class="btn">검 색</button>
            </form>
             <button id="newContent" onclick="location.href='<%=contextPath%>/Board/write.bo?nowPage=<%=nowPage%>&nowBlock=<%=nowBlock%>'"
                class="btn btn-success ms-3">새 글쓰기</button>
        </div>

        <!-- 게시판 테이블 -->
        <table id="board-table">
            <thead>
                <tr>
                    <th>번호</th>
                    <th>제목</th>
                    <th>내용</th>
                    <th>작성자</th>
                    <th>날짜</th>
                </tr>
            </thead>
           <%--  <tbody>
                <% if (list.isEmpty()) { %>
                <tr>
                    <td colspan="5" class="text-center text-muted">등록된 글이 없습니다.</td>
                </tr>
                <% } else {
                    for (int i = beginPerPage; i < (beginPerPage + numPerPage); i++) {
                        if (i == totalRecord) break;
                        BoardVo vo = list.get(i);

                        // b_level에 따라 들여쓰기 동적 계산
                        int indent = vo.getB_level() * 20; 
                %>
                <tr onclick="javascript:fnRead('<%=vo.getNotice_id()%>')">
                    <td><%=vo.getNotice_id()%></td>
                    <td>
                        <div style="margin-left: <%=indent%>px;">
                            <% if (vo.getB_level() > 0) { %>
                                <img src="<%=contextPath%>/common/notice/images/re.gif" alt="reply">
                            <% } %>
                            <%=vo.getTitle()%>
                        </div>
                    </td>
                    <td><%=vo.getContent()%></td>
                    <td><%=vo.getUserName().getUser_name()%></td>
                    <td><%=vo.getCreated_date()%></td>
                </tr>
                <% } } %>
            </tbody> --%>
            <tbody>
    <% if (list.isEmpty()) { %>
    <tr>
        <td colspan="5" class="text-center text-muted">등록된 글이 없습니다.</td>
    </tr>
    <% } else {
        for (int i = beginPerPage; i < (beginPerPage + numPerPage); i++) {
            if (i == totalRecord) break;
            BoardVo vo = list.get(i);

            // 들여쓰기 계산 (레벨 * 픽셀)
            int indent = vo.getB_level() * 20; 
    %>
    <tr onclick="javascript:fnRead('<%=vo.getNotice_id()%>')" style="cursor: pointer;">
        <td><%=vo.getNotice_id()%></td>
        <td>
            <div style="margin-left: <%=indent%>px;">
                <% if (vo.getB_level() > 0) { %>
                    <!-- 답변글 아이콘 -->
                    <i class="fas fa-reply" style="color: #4a90e2; margin-right: 5px;"></i>
                <% } %>
                <%=vo.getTitle()%>
            </div>
        </td>
        <td><%=vo.getContent()%></td>
        <td><%=vo.getUserName().getUser_name()%></td>
        <td><%=vo.getCreated_date()%></td>
    </tr>
    <% } } %>
</tbody>
        </table>

        <!-- 페이지네이션 -->
        <nav class="d-flex justify-content-center">
            <ul class="pagination">
                <% 
                    String searchParams = "";
                    if (key != null && word != null) {
                        searchParams = "&key=" + key + "&word=" + URLEncoder.encode(word, "UTF-8");
                    }
                    if (totalRecord != 0) {
                        if (nowBlock > 0) { 
                %>
                <li class="page-item">
                    <a class="page-link" href="<%=contextPath%>/Board/list.bo?center=/view_admin/noticeManage.jsp&nowBlock=<%=nowBlock - 1%>&nowPage=<%=((nowBlock - 1) * pagePerBlock)%><%=searchParams%>">◀ 이전</a>
                </li>
                <% } 
                    for (int i = 0; i < pagePerBlock; i++) {
                        int pageNum = (nowBlock * pagePerBlock) + i + 1;
                        if (pageNum > totalPage) break; 
                %>
                <li class="page-item"><a class="page-link" href="<%=contextPath%>/Board/list.bo?center=/view_admin/noticeManage.jsp&nowBlock=<%=nowBlock%>&nowPage=<%=pageNum - 1%><%=searchParams%>"><%=pageNum%></a></li>
                <% } 
                    if (totalBlock > nowBlock + 1) { 
                %>
                <li class="page-item">
                    <a class="page-link" href="<%=contextPath%>/Board/list.bo?center=/view_admin/noticeManage.jsp&nowBlock=<%=nowBlock + 1%>&nowPage=<%=(nowBlock + 1) * pagePerBlock%><%=searchParams%>">▶ 다음</a>
                </li>
                <% } } %>
            </ul>
        </nav>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

</body>
</html>
