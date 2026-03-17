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
<link href="<%=contextPath%>/css/slide.css" rel="stylesheet">

<style>
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
	alert('<%=message%>
		');
	</script>
	<%
}
%>



	<div style="padding: 50px 150px 50px 150px">

		<!-- 자동 캐러셀 -->
		<section class="carousel" id="carousel">
			<div class="carousel-track" id="track">
				<div class="slide">
					<div class="title">슬라이드 1</div>
					<div class="desc">추천 논문 / 인기 키워드를 확인해보세요</div>
				</div>
				<div class="slide">
					<div class="title">슬라이드 2</div>
					<div class="desc">논문 검색을 더 빠르고 쉽게</div>
				</div>
				<div class="slide">
					<div class="title">슬라이드 3</div>
					<div class="desc">자료실과 커뮤니티까지 한 번에</div>
				</div>
			</div>

			<button class="carousel-btn prev" type="button" aria-label="이전 슬라이드">‹</button>
			<button class="carousel-btn next" type="button" aria-label="다음 슬라이드">›</button>

			<div class="dots" id="dots" aria-label="슬라이드 선택"></div>
		</section>

		<div class="row align-items-md-stretch mt-4">
			<!-- 행 전체에 하단 여백 추가 -->
			<!-- 학사 일정 영역 -->
			<div class="col-md-7" style="margin-bottom: 10px;">
				<div class="bg-body-tertiary rounded-3" style="padding: 15px;">
					<jsp:include page="/common/calendar.jsp" />
				</div>

				<!-- 수정함 -->

				<%
				String studentId = (String) session.getAttribute("student_id");
				%>

				<%
				if (studentId != null && !studentId.trim().equals("")) {
				%>
				<div class="timetable-card mt-3">
					<jsp:include page="/view_student/studentTimetableMini.jsp" />
				</div>
				<%
				}
				%>
			</div>
			<!-- 수정함 -->

			<div class="col-md-5">
				<div class="login-box">
					<div
						class="h-100 p-4 bg-light border rounded-3 d-flex flex-column justify-content-center">
						<%
						if (id == null) {
						%>
						<h2>로그인</h2>
						<form action="<%=contextPath%>/member/login.do" method="post">
							<div class="mb-3 d-flex align-items-center">
								<label for="username" class="form-label me-2"
									style="width: 80px;">아이디</label> <input type="text"
									class="form-control" name="id" placeholder="아이디 입력">
							</div>
							<div class="mb-3 d-flex align-items-center">
								<label for="password" class="form-label me-2"
									style="width: 80px;">비밀번호</label> <input type="password"
									class="form-control" name="pass" placeholder="비밀번호 입력">
							</div>
							<button type="submit" class="btn btn-primary w-100">로그인</button>
						</form>
						<%
						} else {
						%>
						<h4 class="display-6">
							<i class="fas fa-book" style="color: #4a90e2"></i> <b><%=name%>
								<%=role%>님!</b>
						</h4>
						<p class="lead">
							<b>학사 관리 시스템에 오신 것을 환영합니다.</b>
						</p>
						<br> <br>
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
						<input type="hidden" name="notice_id"> <input
							type="hidden" name="nowPage" value="<%=nowPage%>"> <input
							type="hidden" name="nowBlock" value="<%=nowBlock%>">
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
									if (i == totalRecord)
										break;
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
											<i class="fas fa-reply"
												style="color: #4a90e2; margin-right: 5px;"></i>
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
							<a
								href="<%=contextPath%>/Board/list.bo?center=/view_start/startcenter.jsp&nowBlock=<%=nowBlock - 1%>&nowPage=<%=((nowBlock - 1) * pagePerBlock)%>">◀
								이전</a>
							<%
							}
							for (int i = 0; i < pagePerBlock; i++) {
							int pageNum = (nowBlock * pagePerBlock) + i + 1;
							if (pageNum > totalPage)
								break;
							%>
							<a
								href="<%=contextPath%>/Board/list.bo?center=/view_start/startcenter.jsp&nowBlock=<%=nowBlock%>&nowPage=<%=pageNum - 1%>"><%=pageNum%></a>
							<%
							}
							if (totalBlock > nowBlock + 1) {
							%>
							<a
								href="<%=contextPath%>/Board/list.bo?center=/view_start/startcenter.jsp&nowBlock=<%=nowBlock + 1%>&nowPage=<%=(nowBlock + 1) * pagePerBlock%>">▶
								다음</a>
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
								<label>출발 건물</label> <select id="startBuilding"
									class="bus-select">
									<option value="">선택하세요</option>
								</select>
							</div>

							<div class="bus-group">
								<label>도착 건물</label> <select id="endBuilding" class="bus-select">
									<option value="">선택하세요</option>
								</select>
							</div>
						</div>

						<div class="bus-row">
							<div class="bus-group">
								<label>수업 종료시간</label> <input type="time" id="classEndTime">
							</div>
						</div>

						<button class="bus-search-btn" onclick="recommendBus()">🔍
							버스 찾기</button>
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
	(function(){
		  var carousel = document.getElementById("carousel");
		  if(!carousel) return;

		  var track = document.getElementById("track");
		  if(!track) return;

		  var slides = Array.prototype.slice.call(track.children);
		  var prevBtn = carousel.querySelector(".prev");
		  var nextBtn = carousel.querySelector(".next");
		  var dotsWrap = document.getElementById("dots");

		  var index = 0;
		  var intervalMs = 3500;
		  var timer = null;

		  // dots 생성
		  if(dotsWrap){
		    for(var i=0;i<slides.length;i++){
		      (function(i){
		        var b = document.createElement("button");
		        b.type = "button";
		        b.className = "dot" + (i === 0 ? " active" : "");
		        b.setAttribute("aria-label", (i + 1) + "번 슬라이드");
		        b.onclick = function(){ goTo(i, true); };
		        dotsWrap.appendChild(b);
		      })(i);
		    }
		  }

		  function getDots(){
		    if(!dotsWrap) return [];
		    return Array.prototype.slice.call(dotsWrap.children);
		  }

		  function update(){
		    track.style.transform = "translateX(-" + (index * 100) + "%)";
		    var dots = getDots();
		    for(var i=0;i<dots.length;i++){
		      if(i === index) dots[i].classList.add("active");
		      else dots[i].classList.remove("active");
		    }
		  }

		  function goTo(i, userAction){
		    if(typeof userAction === "undefined") userAction = false;
		    index = (i + slides.length) % slides.length;
		    update();
		    if(userAction) restart();
		  }

		  function next(userAction){
		    if(typeof userAction === "undefined") userAction = false;
		    goTo(index + 1, userAction);
		  }

		  function prev(userAction){
		    if(typeof userAction === "undefined") userAction = false;
		    goTo(index - 1, userAction);
		  }

		  function start(){
		    stop();
		    timer = setInterval(function(){ next(false); }, intervalMs);
		  }

		  function stop(){
		    if(timer) clearInterval(timer);
		    timer = null;
		  }

		  function restart(){
		    start();
		  }

		  if(nextBtn) nextBtn.onclick = function(){ next(true); };
		  if(prevBtn) prevBtn.onclick = function(){ prev(true); };

		  carousel.onmouseenter = stop;
		  carousel.onmouseleave = start;

		  carousel.onkeydown = function(e){
		    e = e || window.event;
		    var key = e.key || e.keyCode;
		    if(key === "ArrowRight" || key === 39) next(true);
		    if(key === "ArrowLeft"  || key === 37) prev(true);
		  };
		  carousel.tabIndex = 0;

		  update();
		  start();
		})();
		$(function() {
			$(document).on(
					"click",
					"#noticePagination a",
					function(e) {
						e.preventDefault();

						var url = $(this).attr("href");

						$.ajax({
							url : url,
							type : "GET",
							dataType : "html",
							success : function(response) {
								var newTbody = $(response).find("#noticeTbody")
										.html();
								var newPagination = $(response).find(
										"#noticePagination").html();

								if (newTbody && $.trim(newTbody) !== "") {
									$("#noticeTbody").html(newTbody);
								}

								if (newPagination
										&& $.trim(newPagination) !== "") {
									$("#noticePagination").html(newPagination);
								}
							},
							error : function() {
								alert("공지사항 페이지 이동 중 오류가 발생했습니다.");
							}
						});
					});
		});
	</script>

</body>
</html>