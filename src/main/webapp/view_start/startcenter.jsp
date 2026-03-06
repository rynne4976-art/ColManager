<%@page import="java.net.URLEncoder"%>
<%@ page import="java.security.SecureRandom" %>
<%@ page import="java.math.BigInteger" %>
<%@page import="java.net.URLDecoder"%>
<%@page import="Vo.BoardVo"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
    request.setCharacterEncoding("UTF-8");
    String contextPath = request.getContextPath();
    
    String id = (String)session.getAttribute("id");
    String role = (String)session.getAttribute("role");
    String name = (String)session.getAttribute("name");
    
    int totalRecord = 0;
    int numPerPage = 5;
    int pagePerBlock = 3;
    int totalPage = 0;
    int totalBlock = 0;
    int nowPage = 0;
    int nowBlock = 0;
    int beginPerPage = 0;

    ArrayList<BoardVo> list = (ArrayList<BoardVo>) request.getAttribute("list");

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
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Bootstrap demo</title>
    <!-- Font Awesome 아이콘 추가 -->
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
    
    <!-- 달력관련 -->
    <link href="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.js"></script>

    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" >
  	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" ></script>
  	
	<link href="<%=contextPath %>/css/startpage.css" rel="stylesheet">
	
	<style>
	/* 로그인 박스*/
	.login-box{    
	 	background-color: #f8f9fa; /* 배경색 */
        border: 1px solid #dee2e6; /* 테두리 색상 */
        border-radius: 10px; /* 모서리 둥글게 */
        padding: 20px; /* 내부 여백 */
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); /* 박스 그림자 */
	    height: 357px;
    }
	
    /* 공지사항 상자 스타일 */
    .notice-box {
        background-color: #f8f9fa; /* 배경색 */
        border: 1px solid #dee2e6; /* 테두리 색상 */
        border-radius: 10px; /* 모서리 둥글게 */
        padding: 27.5px 20px; /* 내부 여백 */
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); /* 박스 그림자 */
    }

    /* 공지사항 제목 스타일 */
    .notice-box h2 {
        font-size: 40px; /* 글자 크기 */
        color: #333; /* 텍스트 색상 */
        border-bottom: 2px solid #dee2e6; /* 제목 하단 경계선 */
        padding-bottom: 10px; /* 제목 아래 여백 */
        margin-bottom: 20px; /* 제목과 내용 사이 여백 */
    }

    /* 공지사항 테이블 스타일 */
    .notice-table {
        width: 100%; /* 테이블 너비 */
        border-collapse: collapse; /* 테두리 병합 */
        background-color: #ffffff; /* 테이블 배경색 */
        font-size: 14px; /* 글꼴 크기 */
    }

    .notice-table thead tr {
        background-color: #e9ecef; /* 헤더 배경색 */
        text-align: center; /* 텍스트 중앙 정렬 */
        font-weight: bold; /* 텍스트 굵게 */
        color: #495057; /* 텍스트 색상 */
    }

    .notice-table th, .notice-table td {
        border: 1px solid #dee2e6; /* 테두리 색상 */
        padding: 10px; /* 셀 내부 여백 */
        text-align: center; /* 셀 텍스트 중앙 정렬 */
    }

    .notice-table tbody tr:nth-child{
        background-color: #ffffff;
    }

    .notice-table tbody tr:hover {
        background-color: #f1f3f5; /* 마우스 오버 시 배경색 */
        cursor: pointer; /* 마우스 포인터 모양 */
    }

    .notice-table a:hover {
        text-decoration: underline; /* 마우스 오버 시 밑줄 */
        color: #0056b3; /* 텍스트 색상 변경 */
    }

    /* 페이지네이션 스타일 */
    .pagination {
        display: flex; /* 가로 정렬 */
        justify-content: center; /* 중앙 정렬 */
        margin-top: 20px; /* 위 여백 */
        font-size: 14px; /* 글꼴 크기 */
    }

    .pagination a {
        margin: 0 5px; /* 버튼 간 간격 */
        padding: 8px 12px; /* 버튼 내부 여백 */
        text-decoration: none; /* 링크 밑줄 제거 */
        color: #007bff; /* 기본 링크 색상 */
        border: 1px solid #dee2e6; /* 테두리 색상 */
        border-radius: 4px; /* 모서리 둥글게 */
    }

    .pagination a:hover {
        background-color: #f1f1f1; /* 마우스 오버 시 배경색 */
        color: #0056b3; /* 마우스 오버 시 텍스트 색상 */
    }

    .pagination a.active {
        background-color: #007bff; /* 활성화된 버튼 배경색 */
        color: white; /* 활성화된 버튼 텍스트 색상 */
        pointer-events: none; /* 클릭 비활성화 */
    }

    /* 공지사항이 비어있을 때 스타일 */
    .notice-empty {
        text-align: center; /* 중앙 정렬 */
        color: #6c757d; /* 텍스트 색상 */
        font-size: 14px; /* 글꼴 크기 */
        padding: 20px; /* 내부 여백 */
        
    }
    
</style>
	

  </head>
  <body>
  	<%
	String message = (String) request.getAttribute("message");
	if (message != null) {
    	message = URLDecoder.decode(message, "UTF-8");
	%>
	        <script>
	            alert('<%= message %>'); // 메시지를 알림으로 표시
	        </script>
	<%
	    }
	%>
  <script>
    let slideIndex = 0;
    const images = [
        "<%= contextPath %>/img/BackGround/poster1.png",
        "<%= contextPath %>/img/BackGround/poster2.png",
        "<%= contextPath %>/img/BackGround/poster3.png"
    ];
    
    let autoSlideTimer; // 자동 슬라이드 타이머
    const autoSlideDelay = 3000; // 자동 슬라이드 시간 간격 (3초)

    function showSlide() {
        document.getElementById("sliderImage").src = images[slideIndex];
    }
    
    function nextSlide() {
        slideIndex = (slideIndex + 1) % images.length;
        showSlide();
    }

    function prevSlide() {
        slideIndex = (slideIndex - 1 + images.length) % images.length;
        showSlide();
    }

    // 자동 슬라이드를 시작하는 함수
    function startAutoSlide() {
        autoSlideTimer = setInterval(nextSlide, autoSlideDelay);
    }

    // 자동 슬라이드를 리셋하는 함수
    function resetAutoSlide() {
        clearInterval(autoSlideTimer); // 기존 타이머 초기화
        startAutoSlide(); // 자동 슬라이드 재시작
    }

    // 페이지 로드 시 자동 슬라이드 시작
    startAutoSlide();
    
    // 게시글 상세 조회 요청 함수
    function fnRead(val) {
        document.frmRead.action = "<%=contextPath%>/Board/read.bo";
        document.frmRead.notice_id.value = val;
        document.frmRead.submit();
    }
    
    </script>
</head>
<body>
	<!-- 배경 이미지 -->
    <div class="background" ></div>
    
	<div class="container" style="margin-top: 100px">
	
		<div class="row align-items-stretch">
					<!-- 슬라이드 이미지 영역 -->
			<div class="col-md-12">
			    <!-- 고정된 크기 설정 (높이를 줄여서 세로 크기 조정) -->
			    <div class="p-5 bg-body-tertiary rounded-3" >
			        <div id="imageCarousel" class="carousel slide h-100" data-bs-ride="carousel" style="height: 100%; min-height: 400px;">
				    <div class="carousel-inner h-100">
				        <!-- 첫 번째 슬라이드 -->
				        <div class="carousel-item active h-100">
				            <img src="<%= contextPath %>/img/background/poster1.png" 
				                 class="d-block w-100" 
				                 alt="Poster 1" 
				                 style="max-height: 400px; height: auto;">
				        </div>
				        <!-- 두 번째 슬라이드 -->
				        <div class="carousel-item h-100">
				            <img src="<%= contextPath %>/img/background/poster2.png" 
				                 class="d-block w-100" 
				                 alt="Poster 2" 
				                 style="max-height: 400px; height: auto;">
				        </div>
				        <!-- 세 번째 슬라이드 -->
				        <div class="carousel-item h-100">
				            <img src="<%= contextPath %>/img/background/poster3.png" 
				                 class="d-block w-100" 
				                 alt="Poster 3" 
				                 style="max-height: 400px; height: auto;">
				        </div>
				    </div>
				     <!-- 이전/다음 버튼 -->
					<button class="carousel-control-prev btn btn-dark p-2" type="button" data-bs-target="#imageCarousel" data-bs-slide="prev">
					    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
					    <span class="visually-hidden">Previous</span>
					</button>
					<button class="carousel-control-next btn btn-dark  p-2" type="button" data-bs-target="#imageCarousel" data-bs-slide="next">
					    <span class="carousel-control-next-icon" aria-hidden="true"></span>
					    <span class="visually-hidden">Next</span>
					</button>
				     
				</div>
			    </div>
			</div>
		</div>
    
		<div class="row align-items-md-stretch mt-4"> <!-- 행 전체에 하단 여백 추가 -->
		<!-- 학사 일정 영역 -->
		<div class="col-md-7" style="margin-bottom: 10px;"> <!-- 학사 일정 상자에 하단 여백 추가 -->
		    <div class="h-100 bg-body-tertiary rounded-3" style="padding: 15px;"> <!-- 안쪽 여백 통일 -->
		        <jsp:include page="/common/calendar.jsp" />
		    </div>
		</div>
		
		<div class="col-md-5"> <!-- 공지 사항 상자에 하단 여백 추가 -->
			
			<div class="login-box">
         		<!-- 로그인 박스 -->
	        	<div class="h-100 p-5 bg-light border rounded-3 d-flex flex-column justify-content-center">
			<%  if(id == null) {  %>
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
			<%  } else {  %>  
	              <h4 class="display-6"><i class="fas fa-book"  style="color: #4a90e2"></i> <b><%=name %> <%=role %>님!</b></h4> <!-- 아이콘 변경 -->
	        		<p class="lead"><b>학사 관리 시스템에 오신 것을 환영합니다.</b></p>
	        		<br><br>
	        		
				<button type="button" class="btn btn-primary"
					onclick="location.href='<%=contextPath%>/member/logout.me'">로그아웃</button>
			<%  }  %>     
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
							<tbody>
								<% if (list.isEmpty()) { %>
								<tr>
									<td colspan="5" class="notice-empty">등록된 글이 없습니다.</td>
								</tr>
								<% } else {
                        for (int i = beginPerPage; i < (beginPerPage + numPerPage); i++) {
                            if (i == totalRecord) break;
                            BoardVo vo = list.get(i);

                           	   // 들여쓰기 계산 (레벨 * 픽셀)
                               int indent = vo.getB_level() * 20; 
		                       %>
		                       <tr onclick="javascript:fnRead('<%=vo.getNotice_id()%>')" >
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
									<td><%=vo.getUserName().getUser_name()%></td>
									<td><%=vo.getCreated_date()%></td>
								</tr>
								<% } } %>
							</tbody>
						</table>
						<div class="pagination">
							<% 
                if (totalRecord != 0) {
                    if (nowBlock > 0) { %>
							<a
								href="<%=contextPath%>/Board/list.bo?center=/view_start/startcenter.jsp&nowBlock=<%=nowBlock - 1%>&nowPage=<%=((nowBlock - 1) * pagePerBlock)%>">◀
								이전</a>
							<% }
                    for (int i = 0; i < pagePerBlock; i++) {
                        int pageNum = (nowBlock * pagePerBlock) + i + 1;
                        if (pageNum > totalPage) break; %>
							<a
								href="<%=contextPath%>/Board/list.bo?center=/view_start/startcenter.jsp&nowBlock=<%=nowBlock%>&nowPage=<%=pageNum - 1%>"><%=pageNum%></a>
							<% }
                    if (totalBlock > nowBlock + 1) { %>
							<a
								href="<%=contextPath%>/Board/list.bo?center=/view_start/startcenter.jsp&nowBlock=<%=nowBlock + 1%>&nowPage=<%=(nowBlock + 1) * pagePerBlock%>">▶
								다음</a>
							<% } } %>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
  <script>
        document.addEventListener('DOMContentLoaded', function() {
            var calendarEl = document.getElementById('calendar');
            var calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: 'dayGridMonth', // 월간 달력
                headerToolbar: {
                    left: 'prev,next today',
                    center: 'title',
                    right: 'dayGridMonth,dayGridWeek'
                },
                events: [
                    { title: '학사 일정 예시', start: '2024-11-10', end: '2024-11-12' },
                    { title: '중간고사', start: '2024-11-15', end: '2024-11-16' }
                ],
                // 
                height: 'auto', // 달력 높이를 고정된 값으로 설정
                width: 'auto',
                locale: 'ko' // 한국어 설정
            });
            calendar.render();
        });
    </script> 
</body>
</html>