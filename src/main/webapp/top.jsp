<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%
	//URL의 selectedMenu 파라미터를 통해 선택된 메뉴를 세션에 저장
	String selectedMenu = request.getParameter("selectedMenu");
	if (selectedMenu == null) {
		selectedMenu = "홈"; // 기본값을 '홈'으로 설정
	}
	if (selectedMenu != null) {
		session.setAttribute("selectedMenu", selectedMenu);
	}

	request.setCharacterEncoding("UTF-8");
	String contextPath = request.getContextPath();

	//Session내장객체 메모리 영역에 session값 얻기 (학생인지, 교수인지, 관리자인지)
	String userRole = (String) session.getAttribute("role");
	String userName = (String) session.getAttribute("name");

	String menuHtml = (String) session.getAttribute("menuHtml"); // Controller에서 전달된 menuHtml
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Top Section</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet" href="<%=contextPath%>/css/top.css">
</head>
<body>

	<!-- 네비게이션 바 -->
	<nav
		class="navbar navbar-expand-lg navbar-dark bg-dark d-flex flex-column align-items-center">
		<div
			class="container-fluid d-flex justify-content-between align-items-center w-100">
			<!-- 사이드바 버튼: 로그인된 경우에만 표시 -->
			<%
				if (userRole != null) {
			%>
			<button class="btn btn-outline-light" type="button"
				data-bs-toggle="offcanvas" data-bs-target="#sidebar"
				aria-controls="sidebar">
				<i class="fas fa-bars"></i>
			</button>
			<%
				}
			%>
			<!-- 중앙 제목 -->
			<a class="navbar-brand mx-auto text-center" href="<%=contextPath%>/member/main.bo"
				style="position: absolute; left: 50%; transform: translateX(-50%);">
				<i class="fas fa-graduation-cap"></i> 학사 지원 프로그램
			</a>
			<!-- 언어 선택 + 환영 메시지 + 로그아웃 -->
			<div class="d-flex align-items-center ms-auto gap-3">

				<!-- 언어 선택 버튼 -->
				<div class="lang-switcher">
					<button class="lang-btn" data-lang="ko" onclick="changeLanguage('ko')">KO</button>
					<button class="lang-btn" data-lang="en" onclick="changeLanguage('en')">EN</button>
					<button class="lang-btn" data-lang="zh-CN" onclick="changeLanguage('zh-CN')">中文</button>
					<button class="lang-btn" data-lang="ja" onclick="changeLanguage('ja')">日本語</button>
					<button class="lang-btn" data-lang="es" onclick="changeLanguage('es')">ES</button>
				</div>

				<!-- 환영 메시지와 로그아웃 버튼: 로그인된 경우에만 표시 -->
				<div class="navbar-text">
					<%
						if (userRole != null) {
					%>
					반갑습니다. &nbsp;&nbsp;<b><%=userName%></b>
					<%=userRole%>님!&nbsp;&nbsp;
					<button type="button" class="btn btn-primary"
						onclick="location.href='<%=contextPath%>/member/logout.me'">로그아웃</button>
					<%
						} else {
					%>
					로그인을 진행해주세요.
					<%
						}
					%>
				</div>

			</div>
		</div>

		<!-- 아래 줄 바꿈된 메뉴 항목들, 간격 조정 -->
		<div class="nav-container" style="z-index: 1">
			<div class="container-fluid d-flex justify-content-center mt-2">
				<ul class="navbar-nav d-flex flex-row justify-content-center">
					<!-- 이 부분에 justify-content-center 추가 -->
					<%=menuHtml%>
				</ul>
			</div>
		</div>

	</nav>

	<%
		if (userRole != null) {
	%>
	<div class="offcanvas offcanvas-start" tabindex="-1" id="sidebar"
		aria-labelledby="sidebarLabel">
		<div class="offcanvas-header">
			<h5 class="offcanvas-title" id="sidebarLabel">메뉴</h5>
			<button type="button" class="btn-close" data-bs-dismiss="offcanvas"
				aria-label="Close"></button>
		</div>
		<div class="offcanvas-body">
			<!-- Sidebar에서 동적으로 서브 메뉴 항목을 표시 -->
			<ul class="list-group">
				<%=menuHtml%>
			</ul>
		</div>
	</div>
	<%
		}
	%>

	<!-- Google Translate 요소 (숨김) -->
	<div id="google_translate_element" style="display:none"></div>

	<script>
	/* ── Google Translate 배너 강제 제거 ── */
	function hideBanner() {
	    var banner = document.querySelector('.goog-te-banner-frame');
	    if (banner) banner.style.setProperty('display', 'none', 'important');
	    document.body.style.setProperty('top', '0px', 'important');
	}

	/* 배너가 DOM에 추가될 때마다 즉시 제거 */
	var _bannerObserver = new MutationObserver(function() { hideBanner(); });
	_bannerObserver.observe(document.documentElement, { childList: true, subtree: true });

	/* ── Google Translate 초기화 ── */
	function googleTranslateElementInit() {
	    new google.translate.TranslateElement({
	        pageLanguage: 'ko',
	        includedLanguages: 'en,zh-CN,ja,es',
	        autoDisplay: false
	    }, 'google_translate_element');
	    hideBanner();
	}

	/* ── 언어 변경 ── */
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
	        document.querySelectorAll('.lang-btn').forEach(function(b) { b.classList.remove('active'); });
	        var activeBtn = document.querySelector('.lang-btn[data-lang="' + lang + '"]');
	        if (activeBtn) activeBtn.classList.add('active');
	    } else {
	        document.cookie = 'googtrans=/ko/' + lang + '; path=/;';
	        document.cookie = 'googtrans=/ko/' + lang + '; domain=.' + location.hostname + '; path=/;';
	        location.reload();
	    }
	}

	/* ── 페이지 로드 시 현재 언어 버튼 활성화 ── */
	(function () {
	    var match = document.cookie.match(/googtrans=\/ko\/([^;]+)/);
	    var currentLang = match ? match[1] : 'ko';
	    document.querySelectorAll('.lang-btn').forEach(function (btn) {
	        if (btn.getAttribute('data-lang') === currentLang) {
	            btn.classList.add('active');
	        }
	    });
	})();
	</script>
	<script src="//translate.google.com/translate_a/element.js?cb=googleTranslateElementInit"></script>

	<!-- Font Awesome and Bootstrap JS -->
	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/js/all.min.js"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>