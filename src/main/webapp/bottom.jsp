<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%
	request.setCharacterEncoding("UTF-8");
	String role = (String)session.getAttribute("role");
%>
<head>
<!-- 스타일 및 Bootstrap, Font Awesome 연결 -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/js/all.min.js"></script>

</head>
<body>
<!-- Footer 영역 -->
<footer class="bg-dark text-light py-4 mt-3">
	<div class="container">
		<div class="row">
			<!-- 저작권 및 학교 이름 -->
			<div class="col-md-4 text-center text-md-start mb-3 mb-md-0">
				<h5>학사 관리 프로그램</h5>
				<p class="mb-0">© 2024 Your School Name. All rights reserved.</p>
			</div>

			<!-- 빠른 링크 -->
			<div class="col-md-4 text-center mb-3 mb-md-0">
				<h5>빠른 링크</h5>
				<ul class="list-unstyled">
					<li><a href="${pageContext.request.contextPath}/member/main.bo"
						class="text-light text-decoration-none">홈</a></li>
					
					<li><a href="${pageContext.request.contextPath}/Board/boardCalendar.bo"
						class="text-light text-decoration-none">학사일정</a></li>
					<li><a href="${pageContext.request.contextPath}/common/welcomRoad.jsp"
						class="text-light text-decoration-none"
						onclick="window.open(this.href, 'popupWindow', 'width=441,height=781,toolbar=no,menubar=no,scrollbars=no,resizable=no,location=yes,status=no'); return false;">
						찾아오시는 길 </a>
					</li>
				</ul>
			</div>

			<!-- 연락처 정보 -->
			<div class="col-md-4 text-center text-md-end">
				<h5>연락처</h5>
				<p class="mb-1">
					<i class="fas fa-phone-alt"></i> 전화: 123-456-7890
				</p>
				<p class="mb-1">
					<i class="fas fa-envelope"></i> 이메일: info@yourschool.edu
				</p>
				<p>
					<i class="fas fa-map-marker-alt"></i> 주소: 부산광역시 부산진구 신천대로50번길 79
				</p>
				
			</div>
		</div>
		<div class="row mt-3">
			<div class="col text-center">
				<small>본 사이트는 학사 지원을 목적으로 제공되는 프로그램입니다.</small>
			</div>
		</div>
	</div>
</footer>

</body>