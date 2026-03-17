<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%
	String selectedMenu = request.getParameter("selectedMenu");
	if (selectedMenu == null) {
		selectedMenu = "홈";
	}
	if (selectedMenu != null) {
		session.setAttribute("selectedMenu", selectedMenu);
	}

	request.setCharacterEncoding("UTF-8");
	String contextPath = request.getContextPath();
	String userRole = (String) session.getAttribute("role");
	String userName = (String) session.getAttribute("name");
	String menuHtml = (String) session.getAttribute("menuHtml");
	if (menuHtml == null) menuHtml = "";
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Top Section</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<link rel="stylesheet" href="<%=contextPath%>/css/top.css">
</head>
<body>
	<header class="site-header">
		<div class="logo-area">
			<% if (userRole != null) { %>
			<button class="menu-toggle-btn" type="button" data-bs-toggle="offcanvas" data-bs-target="#sidebar" aria-controls="sidebar" aria-label="메뉴 열기">
				<i class="fas fa-bars"></i>
			</button>
			<% } %>
			<a class="logo" href="<%=contextPath%>/member/main.bo">학사 지원 프로그램</a>
		</div>

		<div class="top-bar">
			<div class="welcome-text">
				<% if (userRole != null) { %>
				<span>반갑습니다.&nbsp;&nbsp;<strong><%=userName%></strong>&nbsp;<%=userRole%>님!</span>
				<% } else { %>
				<span>로그인을 진행해주세요.</span>
				<% } %>
			</div>

			<nav class="main-nav" aria-label="주 메뉴">
				<%=menuHtml%>
			</nav>

			<div class="auth">
				<% if (userRole != null) { %>
				<a href="<%=contextPath%>/member/logout.me">로그아웃</a>
				<% } %>
			</div>
		</div>
	</header>

	<% if (userRole != null) { %>
	<div class="offcanvas offcanvas-start menu-offcanvas" tabindex="-1" id="sidebar" aria-labelledby="sidebarLabel">
		<div class="offcanvas-header">
			<h5 class="offcanvas-title" id="sidebarLabel">메뉴</h5>
			<button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>
		</div>
		<div class="offcanvas-body">
			<div class="sidebar-menu-wrap">
				<%=menuHtml%>
			</div>
		</div>
	</div>
	<% } %>

	<div id="google_translate_element" style="display:none"></div>

	<script>
	function hideBanner() {
	    var banner = document.querySelector('.goog-te-banner-frame');
	    if (banner) banner.style.setProperty('display', 'none', 'important');
	    document.body.style.setProperty('top', '0px', 'important');
	}
	var _bannerObserver = new MutationObserver(function() { hideBanner(); });
	_bannerObserver.observe(document.documentElement, { childList: true, subtree: true });

	function googleTranslateElementInit() {
	    new google.translate.TranslateElement({
	        pageLanguage: 'ko',
	        includedLanguages: 'en,zh-CN,ja,es',
	        autoDisplay: false
	    }, 'google_translate_element');
	    hideBanner();
	}

	function changeLanguage(lang) {
	    if (lang === 'ko') {
	        document.cookie = 'googtrans=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;';
	        document.cookie = 'googtrans=; expires=Thu, 01 Jan 1970 00:00:00 UTC; domain=.' + location.hostname + '; path=/;';
	        location.reload();
	        return;
	    }
	    var select = document.querySelector('.goog-te-combo');
	    if (select) {
	        select.value = lang;
	        select.dispatchEvent(new Event('change'));
	    } else {
	        document.cookie = 'googtrans=/ko/' + lang + '; path=/;';
	        document.cookie = 'googtrans=/ko/' + lang + '; domain=.' + location.hostname + '; path=/;';
	        location.reload();
	    }
	}
	</script>
	<script src="//translate.google.com/translate_a/element.js?cb=googleTranslateElementInit"></script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
