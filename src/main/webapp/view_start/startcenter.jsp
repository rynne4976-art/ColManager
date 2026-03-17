<%@page import="java.net.URLEncoder"%>
<%@ page import="java.security.SecureRandom"%>
<%@ page import="java.math.BigInteger"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="Vo.BoardVo"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
request.setCharacterEncoding("UTF-8");
String contextPath = request.getContextPath();

String id = (String) session.getAttribute("id");
String role = (String) session.getAttribute("role");
String name = (String) session.getAttribute("name");

int totalRecord = 0;
int numPerPage = 5;
int pagePerBlock = 3;
int totalPage = 0;
int totalBlock = 0;
int nowPage = 0;
int nowBlock = 0;
int beginPerPage = 0;

ArrayList<BoardVo> list = (ArrayList<BoardVo>) request.getAttribute("list");
if (list == null) {
	list = new ArrayList<BoardVo>();
}

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

<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>학사 관리 시스템</title>

<!-- Font Awesome -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

<!-- FullCalendar : 부모 페이지에서만 로드 -->
<link
	href="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/locales-all.min.js"></script>

<!-- Bootstrap -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">

<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<!-- Bootstrap JS -->
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- 사용자 정의 -->
<script src="<%=contextPath%>/js/bus.js"></script>
<link href="<%=contextPath%>/css/startpage.css" rel="stylesheet">
<link href="<%=contextPath%>/css/bus.css" rel="stylesheet">

<style>
.login-box {
	background-color: #f8f9fa;
	border: 1px solid #dee2e6;
	border-radius: 10px;
	padding: 20px;
	box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
	height: 300px;
}

.notice-box {
	background-color: #f8f9fa;
	border: 1px solid #dee2e6;
	border-radius: 10px;
	padding: 27.5px 20px;
	box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.notice-box h2 {
	font-size: 28px;
	color: #333;
	border-bottom: 2px solid #dee2e6;
	padding-bottom: 10px;
	margin-bottom: 20px;
}

.notice-table {
	width: 100%;
	border-collapse: collapse;
	background-color: #ffffff;
	font-size: 14px;
}

.notice-table thead tr {
	background-color: #e9ecef;
	text-align: center;
	font-weight: bold;
	color: #495057;
}

.notice-table th, .notice-table td {
	border: 1px solid #dee2e6;
	padding: 10px;
	text-align: center;
}

.notice-table tbody tr:hover {
	background-color: #f1f3f5;
	cursor: pointer;
}

.notice-table a:hover {
	text-decoration: underline;
	color: #0056b3;
}

.pagination {
	display: flex;
	justify-content: center;
	margin-top: 20px;
	font-size: 14px;
	flex-wrap: wrap;
}

.pagination a {
	margin: 0 5px;
	padding: 8px 12px;
	text-decoration: none;
	color: #007bff;
	border: 1px solid #dee2e6;
	border-radius: 4px;
}

.pagination a:hover {
	background-color: #f1f1f1;
	color: #0056b3;
}

.pagination a.active {
	background-color: #007bff;
	color: white;
	pointer-events: none;
}

.notice-empty {
	text-align: center;
	color: #6c757d;
	font-size: 14px;
	padding: 20px;
}

.timetable-card {
	background-color: #f8f9fa;
	border: 1px solid #dee2e6;
	border-radius: 10px;
	padding: 27.5px 20px;
	box-shadow: 0 4px 6px rgba(0,0,0,0.1);
}

.timetable-card .student-timetable-wrap {
	padding: 0;
}
</style>

<script>
	window.contextPath = "<%=contextPath%>";

	function fnRead(noticeId) {
		location.href = window.contextPath + "/Board/read.bo?notice_id=" + noticeId;
	}
</script>
</head>
<body>

<%
String message = (String) request.getAttribute("message");
if (message != null) {
	message = URLDecoder.decode(message, "UTF-8");
%>
<script>
	alert('<%=message%>');
</script>
<%
}
%>

<div class="background"></div>

<div class="container startcenter-container" style="margin-top: 100px">

	<div class="row align-items-stretch">
		<div class="col-md-12">
			<div class="p-3 bg-body-tertiary rounded-3">
				<div id="imageCarousel" class="carousel slide h-100"
					data-bs-ride="carousel"
					style="height: 100%; min-height: 280px;">

					<div class="carousel-inner h-100">
						<div class="carousel-item active h-100">
							<img src="<%=contextPath%>/img/background/poster1.png"
								class="d-block w-100" alt="Poster 1"
								style="max-height: 280px; height: auto; object-fit: cover;">
						</div>
						<div class="carousel-item h-100">
							<img src="<%=contextPath%>/img/background/poster2.png"
								class="d-block w-100" alt="Poster 2"
								style="max-height: 280px; height: auto; object-fit: cover;">
						</div>
						<div class="carousel-item h-100">
							<img src="<%=contextPath%>/img/background/poster3.png"
								class="d-block w-100" alt="Poster 3"
								style="max-height: 280px; height: auto; object-fit: cover;">
						</div>
					</div>

					<button class="carousel-control-prev btn btn-dark p-2"
						type="button" data-bs-target="#imageCarousel"
						data-bs-slide="prev">
						<span class="carousel-control-prev-icon" aria-hidden="true"></span>
						<span class="visually-hidden">Previous</span>
					</button>

					<button class="carousel-control-next btn btn-dark p-2"
						type="button" data-bs-target="#imageCarousel"
						data-bs-slide="next">
						<span class="carousel-control-next-icon" aria-hidden="true"></span>
						<span class="visually-hidden">Next</span>
					</button>

				</div>
			</div>
		</div>
	</div>

		<div class="row align-items-md-stretch mt-4">
			<!-- 행 전체에 하단 여백 추가 -->
			<!-- 학사 일정 영역 -->
			<div class="col-md-7" style="margin-bottom: 10px;">
				<div class="bg-body-tertiary rounded-3" style="padding: 15px;">
					<jsp:include page="/common/calendar.jsp" />
				</div>
				
				<!-- 수정함 -->
	
			<%
			    String studentId = (String)session.getAttribute("student_id");
			%>
			
			<% if (studentId != null && !studentId.trim().equals("")) { %>
			    <div class="timetable-card mt-3">
			        <jsp:include page="/view_student/studentTimetableMini.jsp"/>
			    </div>
			<% } %>
		</div>		
				<!-- 수정함 -->

		<div class="col-md-5">
			<div class="login-box">
				<div class="h-100 p-4 bg-light border rounded-3 d-flex flex-column justify-content-center">
					<%
					if (id == null) {
					%>
						<h2>로그인</h2>
						<form action="<%=contextPath%>/member/login.do" method="post">
							<div class="mb-3 d-flex align-items-center">
								<label for="username" class="form-label me-2" style="width: 80px;">아이디</label>
								<input type="text" class="form-control" name="id" placeholder="아이디 입력">
							</div>
							<div class="mb-3 d-flex align-items-center">
								<label for="password" class="form-label me-2" style="width: 80px;">비밀번호</label>
								<input type="password" class="form-control" name="pass" placeholder="비밀번호 입력">
							</div>
							<button type="submit" class="btn btn-primary w-100">로그인</button>
						</form>
					<%
					} else {
					%>
						<h4 class="display-6">
							<i class="fas fa-book" style="color: #4a90e2"></i>
							<b><%=name%> <%=role%>님!</b>
						</h4>
						<p class="lead">
							<b>학사 관리 시스템에 오신 것을 환영합니다.</b>
						</p>
						<br><br>
						<button type="button" class="btn btn-primary"
							onclick="location.href='<%=contextPath%>/member/logout.me'">로그아웃</button>
					<%
					}
					%>
				</div>
			</div>

			<br>

			<div class="notice-box">
				<h2>공지 사항</h2>

				<form name="frmRead">
					<input type="hidden" name="notice_id">
					<input type="hidden" name="nowPage" value="<%=nowPage%>">
					<input type="hidden" name="nowBlock" value="<%=nowBlock%>">
				</form>

				<div>
					<table class="notice-table">
						<thead>
							<tr>
								<th>번호</th>
								<th>제목</th>
								<th>작성자</th>
								<th>날짜</th>
							</tr>
						</thead>
						<tbody id="noticeTbody">
							<%
							if (list.isEmpty()) {
							%>
							<tr>
								<td colspan="4" class="notice-empty">등록된 글이 없습니다.</td>
							</tr>
							<%
							} else {
								for (int i = beginPerPage; i < (beginPerPage + numPerPage); i++) {
									if (i == totalRecord) break;
									BoardVo vo = list.get(i);
									int indent = vo.getB_level() * 20;
							%>
							<tr onclick="fnRead('<%=vo.getNotice_id()%>')">
								<td><%=vo.getNotice_id()%></td>
								<td>
									<div style="margin-left: <%=indent%>px;">
										<%
										if (vo.getB_level() > 0) {
										%>
											<i class="fas fa-reply" style="color: #4a90e2; margin-right: 5px;"></i>
										<%
										}
										%>
										<%=vo.getTitle()%>
									</div>
								</td>
								<td><%=vo.getUserName().getUser_name()%></td>
								<td><%=vo.getCreated_date()%></td>
							</tr>
							<%
								}
							}
							%>
						</tbody>
					</table>

					<div class="pagination" id="noticePagination">
						<%
						if (totalRecord != 0) {
							if (nowBlock > 0) {
						%>
						<a href="<%=contextPath%>/Board/list.bo?center=/view_start/startcenter.jsp&nowBlock=<%=nowBlock - 1%>&nowPage=<%=((nowBlock - 1) * pagePerBlock)%>">◀ 이전</a>
						<%
							}
							for (int i = 0; i < pagePerBlock; i++) {
								int pageNum = (nowBlock * pagePerBlock) + i + 1;
								if (pageNum > totalPage) break;
						%>
						<a href="<%=contextPath%>/Board/list.bo?center=/view_start/startcenter.jsp&nowBlock=<%=nowBlock%>&nowPage=<%=pageNum - 1%>"><%=pageNum%></a>
						<%
							}
							if (totalBlock > nowBlock + 1) {
						%>
						<a href="<%=contextPath%>/Board/list.bo?center=/view_start/startcenter.jsp&nowBlock=<%=nowBlock + 1%>&nowPage=<%=(nowBlock + 1) * pagePerBlock%>">▶ 다음</a>
						<%
							}
						}
						%>
					</div>
				</div>
			</div>

			<div class="bus-card">
				<h3 class="bus-title">🚌 학내 버스 검색</h3>

				<div class="bus-search-box">
					<div class="bus-row">
						<div class="bus-group">
							<label>출발 건물</label>
							<select id="startBuilding" class="bus-select">
								<option value="">선택하세요</option>
							</select>
						</div>

						<div class="bus-group">
							<label>도착 건물</label>
							<select id="endBuilding" class="bus-select">
								<option value="">선택하세요</option>
							</select>
						</div>
					</div>

					<div class="bus-row">
						<div class="bus-group">
							<label>수업 종료시간</label>
							<input type="time" id="classEndTime">
						</div>
					</div>

					<button class="bus-search-btn" onclick="recommendBus()">🔍 버스 찾기</button>
				</div>

				<div class="bus-table-wrap">
					<table class="bus-table">
						<thead>
							<tr>
								<th>시간</th>
								<th>노선</th>
								<th>시간</th>
								<th>노선</th>
							</tr>
						</thead>
						<tbody id="busTableBody"></tbody>
					</table>
				</div>

				<div id="recommendArea"></div>
			</div>
		</div>
	</div>
</div>

<script>
$(function () {
	$(document).on("click", "#noticePagination a", function (e) {
		e.preventDefault();

		var url = $(this).attr("href");

		$.ajax({
			url: url,
			type: "GET",
			dataType: "html",
			success: function (response) {
				var newTbody = $(response).find("#noticeTbody").html();
				var newPagination = $(response).find("#noticePagination").html();

				if (newTbody && $.trim(newTbody) !== "") {
					$("#noticeTbody").html(newTbody);
				}

				if (newPagination && $.trim(newPagination) !== "") {
					$("#noticePagination").html(newPagination);
				}
			},
			error: function () {
				alert("공지사항 페이지 이동 중 오류가 발생했습니다.");
			}
		});
	});
});
</script>

</body>
</html>