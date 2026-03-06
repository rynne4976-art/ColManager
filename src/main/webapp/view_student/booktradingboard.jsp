<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="Vo.BookPostVo"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
request.setCharacterEncoding("UTF-8");
String contextPath = request.getContextPath();

// 페이징 처리를 위한 변수 선언
int totalRecord = 0;
int numPerPage = 5;
int pagePerBlock = 3;

int totalPage = 0;
int totalBlock = 0;
int nowPage = 0;

int nowBlock = 0;

int beginPerPage = 0;

String userId = (String) session.getAttribute("id");

List<BookPostVo> bookBoardList = (List<BookPostVo>) request.getAttribute("bookBoardList");

totalRecord = bookBoardList.size();

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
<html>
<head>
    <title>목록조회</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

    <!-- 기존 스타일시트 -->
    <link rel="stylesheet" type="text/css" href="/MVCBoard/style.css" />

    <style>
        body {
            background-color: #f0f2f5;
            font-family: 'Arial', sans-serif;
        }
        #major-container {
            max-width: 900px;
            background-color: #ffffff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0px 8px 16px rgba(0, 0, 0, 0.15);
            margin: 50px auto;
        }
        #major-title {
            font-size: 28px;
            font-weight: bold;
            color: #4a90e2;
            text-align: center;
            margin-bottom: 20px;
        }
        #major-form {
            margin-bottom: 30px;
        }
        #major-form label {
            font-weight: bold;
            margin-right: 10px;
        }
        #major-form .form-control {
            display: inline-block;
            width: auto;
            vertical-align: middle;
            margin-right: 10px;
        }
        #major-form .btn {
            vertical-align: middle;
        }
        #major-table {
            width: 100%;
            margin-top: 20px;
            border-collapse: collapse;
        }
        #major-table th, #major-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        #major-table th {
            background-color: #f7f7f7;
            font-weight: bold;
            color: #333;
        }
        #major-table tr:hover {
            background-color: #f1f1f1;
        }
        /* 추가된 CSS */
        .no-underline {
            text-decoration: none;
            color: inherit;
        }
    </style>

    <script type="text/javascript">
        window.onload = function () {
            var message = "${message}";
            console.log(message);
            if (message && message !== null) {
                alert(message);
            }
        };
        function fnSearch(){
            var word = document.getElementById("word").value;
            if(word == null || word == ""){
                alert("검색어를 입력하세요.");
                document.getElementById("word").focus();
                return false;
            } else {
                document.frmSearch.submit();
            }
        }
        function fnRead(val){
            var values = val.split(",");
            var postId = values[0];
            document.frmRead.action="<%=contextPath%>/Book/bookread.bo";
            document.frmRead.postId.value = postId;
            document.frmRead.submit();
        }
    </script>

</head>
<body>
    <div id="major-container">
        <h2 id="major-title"><i class="fas fa-book"></i> 중고책 거래</h2>
        <!-- 글제목 클릭 시 글 상세보기 요청 폼 -->
        <form name="frmRead">
            <input type="hidden" name="postId">
        </form>

        <table id="major-table" class="table table-striped">
            <thead>
                <tr align="center">
                    <th align="left">번호</th>
                    <th align="left">제목</th>
                    <th align="left">작성자</th>
                    <th align="left">학과태그</th>
                    <th align="left">날짜</th>
                </tr>
            </thead>
            <tbody>
                <%
                if (bookBoardList != null && !bookBoardList.isEmpty()) {
                    int start = beginPerPage;
                    int end = Math.min(beginPerPage + numPerPage, totalRecord);
                    for (int i = start; i < end; i++) {
                        BookPostVo listinput = bookBoardList.get(i);
                %>
                <tr>
                    <td align="left"><%=listinput.getPostId()%></td>
                    <!-- 변경된 부분: class="no-underline" 추가 -->
                    <td><a href="javascript:fnRead('<%=listinput.getPostId()%>')" class="no-underline"><%=listinput.getPostTitle()%></a></td>
                    <td align="left"><%=listinput.getUserId()%></td>
                    <td align="left"><%=listinput.getMajorTag()%></td>
                    <td align="left"><%=listinput.getCreatedAt()%></td>
                </tr>
                <%
                    }
                } else {
                %>
                <tr align="center">
                    <td colspan="5">등록된 글이 없습니다.</td>
                </tr>
                <%
                }
                %>
            </tbody>
        </table>

        <!-- 검색 폼 -->
        <form id="major-form" action="<%=contextPath%>/Book/booksearchlist.bo" method="post" name="frmSearch" onsubmit="return fnSearch();">
            <div class="form-group">
                <label for="key">검색 조건:</label>
                <select name="key" id="key" class="form-control">
                    <option value="titleContent">제목 + 내용</option>
                    <option value="name">작성자</option>
                </select>

                <label for="word">검색어:</label>
                <input type="text" name="word" id="word" class="form-control" />

                <input type="submit" value="검색" class="btn btn-primary" />
            </div>
        </form>

        <!-- 글쓰기 버튼 -->
        <form action="<%=contextPath%>/Book/bookPostUpload.bo" method="post">
            <input type="hidden" value="<%=userId%>" name="userId">
            <input type="submit" value="글 쓰기" class="btn btn-success" style="margin-top: 20px;">
        </form>

        <!-- 페이지네이션 -->
        <div style="text-align: center; margin-top: 20px;">
            <%
            if (totalRecord != 0) {
                if (nowBlock > 0) {
            %>
            <!-- 변경된 부분: class="no-underline" 추가 -->
            <a href="<%=contextPath%>/Book/bookpostboard.bo?nowBlock=<%=nowBlock - 1%>&nowPage=<%=((nowBlock - 1) * pagePerBlock)%>&center=/view_student/booktradingboard.jsp" class="no-underline">
                ◀ 이전 <%=pagePerBlock%>개
            </a>
            <%
                }
                for (int i = 0; i < pagePerBlock; i++) {
                    int pageNumber = (nowBlock * pagePerBlock) + i + 1;
                    if (pageNumber > totalPage) {
                        break;
                    }
            %>
            &nbsp;&nbsp;
            <!-- 변경된 부분: class="no-underline" 추가 -->
            <a href="<%=contextPath%>/Book/bookpostboard.bo?nowBlock=<%=nowBlock%>&nowPage=<%=(nowBlock * pagePerBlock) + i%>&center=/view_student/booktradingboard.jsp" class="no-underline">
                <%=pageNumber%>
            </a>
            &nbsp;&nbsp;
            <%
                }
                if (totalBlock > nowBlock + 1) {
            %>
            <!-- 변경된 부분: class="no-underline" 추가 -->
            <a href="<%=contextPath%>/Book/bookpostboard.bo?nowBlock=<%=nowBlock + 1%>&nowPage=<%=(nowBlock + 1) * pagePerBlock%>&center=/view_student/booktradingboard.jsp" class="no-underline">
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
