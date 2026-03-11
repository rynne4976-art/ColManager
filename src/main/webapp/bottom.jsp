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
<style>
/* ── Footer 공통 텍스트 ── */
.site-footer-wrap,
.site-footer-wrap h5,
.site-footer-wrap p,
.site-footer-wrap small,
.site-footer-wrap a,
.site-footer-wrap li {
    color: #343a40 !important;
}
.site-footer-wrap a:hover {
    color: #000 !important;
    text-decoration: underline !important;
}

/* ── 언어 선택 버튼 (footer) ── */
.footer-lang-area {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 6px;
    margin-top: 12px;
    flex-wrap: wrap;
}
.footer-lang-label {
    font-size: 0.78rem;
    color: #495057 !important;
    margin-right: 4px;
}
.footer-lang-btn {
    background: transparent;
    border: 1px solid #868e96;
    color: #343a40 !important;
    border-radius: 4px;
    padding: 3px 10px;
    font-size: 0.78rem;
    cursor: pointer;
    transition: background 0.15s, border-color 0.15s, color 0.15s;
    white-space: nowrap;
}
.footer-lang-btn:hover {
    background: rgba(0, 0, 0, 0.08);
    border-color: #343a40;
    color: #000 !important;
}
.footer-lang-btn.active {
    background: rgba(0, 0, 0, 0.1);
    border-color: #343a40;
    color: #000 !important;
    font-weight: 700;
}
</style>
</head>
<body>
<!-- Footer 영역 -->
<footer class="py-4 mt-3" style="background-color: #e9ecef !important;">
<div class="site-footer-wrap">
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
						class="text-decoration-none">홈</a></li>

					<li><a href="${pageContext.request.contextPath}/Board/boardCalendar.bo"
						class="text-decoration-none">학사일정</a></li>
					<li><a href="${pageContext.request.contextPath}/common/welcomRoad.jsp"
						class="text-decoration-none"
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

		<!-- 언어 선택 -->
		<div class="footer-lang-area">
			<span class="footer-lang-label"><i class="fas fa-globe me-1"></i>번역</span>
			<button class="footer-lang-btn" data-lang="ko"    onclick="changeLanguage('ko')">KO</button>
			<button class="footer-lang-btn" data-lang="en"    onclick="changeLanguage('en')">EN</button>
			<button class="footer-lang-btn" data-lang="zh-CN" onclick="changeLanguage('zh-CN')">中文</button>
			<button class="footer-lang-btn" data-lang="ja"    onclick="changeLanguage('ja')">日本語</button>
			<button class="footer-lang-btn" data-lang="es"    onclick="changeLanguage('es')">ES</button>
		</div>
	</div>
</div><!-- /site-footer-wrap -->
</footer>

<script>
/* 현재 선택된 언어 버튼 활성화 */
(function () {
    var match = document.cookie.match(/googtrans=\/ko\/([^;]+)/);
    var cur   = match ? match[1] : 'ko';
    document.querySelectorAll('.footer-lang-btn').forEach(function (btn) {
        if (btn.getAttribute('data-lang') === cur) btn.classList.add('active');
    });
})();
</script>

</body>
