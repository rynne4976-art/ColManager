<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%
	String contextPath = request.getContextPath();
	String sessionRole = (String) session.getAttribute("role");
	String sessionName = (String) session.getAttribute("name");
%>

<!doctype html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>EveryOne</title>

<!-- Font Awesome (플로팅 버튼 아이콘) -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<!-- Bootstrap (이메일 모달) -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<!-- 이메일 버튼 전용 CSS -->
<link href="<%=contextPath%>/css/email.css" rel="stylesheet">

<style>
html, body {
	margin: 0;
	padding: 0;
	height: 100%;
	display: flex;
	flex-direction: column;
}

.wrapper {
	display: flex;
	flex-direction: column;
	height: 100%;
}

.top {
	flex: 0 0 auto;
	height: 10%;
}

.center {
	flex: 1 0 auto;
	overflow-y: auto;
	align-content: center;
}

.bottom {
	flex: 0 0 auto;
	height: 20%;
}
</style>
</head>
<body>
	<c:set var="center" value="${requestScope.center}" />
	<c:if test="${center == null}">
		<c:set var="center" value="/view_start/startcenter.jsp" />
	</c:if>

	<div class="wrapper">
		<div class="top">
			<jsp:include page="top.jsp" />
		</div>
		<div class="center">
			<jsp:include page="${center}" />
		</div>
		<div class="bottom">
			<jsp:include page="bottom.jsp" />
		</div>
	</div>

	<%-- ── 학생 로그인 시 플로팅 이메일 버튼 + 모달 ──
	     .wrapper 바깥에 배치 → overflow-y:auto 컨테이너의 영향 없이
	     position:fixed 가 viewport 기준으로 정확히 동작함 --%>
	<% if ("학생".equals(sessionRole)) { %>

	<!-- 플로팅 버튼 -->
	<button class="btn-float-email"
	        data-bs-toggle="modal"
	        data-bs-target="#emailModal"
	        title="이메일 보내기">
		<i class="fas fa-envelope"></i>
	</button>

	<!-- 이메일 모달 -->
	<div class="modal fade" id="emailModal" tabindex="-1"
	     aria-labelledby="emailModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-lg modal-dialog-centered">
			<div class="modal-content">

				<div class="modal-header email-modal-header">
					<h5 class="modal-title" id="emailModalLabel">
						<i class="fas fa-envelope me-2"></i>이메일 보내기
					</h5>
					<button type="button" class="btn-close"
					        data-bs-dismiss="modal" aria-label="Close"></button>
				</div>

				<div class="modal-body px-4 pt-4 pb-2">

					<!-- 발신자 정보 -->
					<div class="sender-badge">
						<i class="fas fa-user me-1"></i>
						발신자: <strong><%= sessionName != null ? sessionName : "" %></strong>
					</div>

					<!-- 수신자 -->
					<div class="mb-3">
						<label for="emailTo" class="form-label fw-semibold">
							<i class="fas fa-at me-1 text-secondary"></i>받는 사람
						</label>
						<input type="email" class="form-control" id="emailTo"
						       value="info@yourschool.edu"
						       placeholder="수신자 이메일 주소">
					</div>

					<!-- 제목 -->
					<div class="mb-3">
						<label for="emailSubject" class="form-label fw-semibold">
							<i class="fas fa-heading me-1 text-secondary"></i>제목
						</label>
						<input type="text" class="form-control" id="emailSubject"
						       placeholder="제목을 입력하세요" maxlength="200">
					</div>

					<!-- 본문 -->
					<div class="mb-3">
						<label for="emailBody" class="form-label fw-semibold">
							<i class="fas fa-align-left me-1 text-secondary"></i>내용
						</label>
						<textarea class="form-control" id="emailBody"
						          rows="7" placeholder="내용을 입력하세요"></textarea>
					</div>

					<!-- 결과 메시지 -->
					<div id="emailResult"></div>

				</div>

				<div class="modal-footer px-4">
					<button type="button" class="btn btn-outline-secondary"
					        data-bs-dismiss="modal">
						<i class="fas fa-times me-1"></i>취소
					</button>
					<button type="button" class="btn btn-dark" onclick="submitEmail()">
						<i class="fas fa-paper-plane me-1"></i>전송
					</button>
				</div>

			</div>
		</div>
	</div>

	<script>
	function submitEmail() {
	    var to      = document.getElementById('emailTo').value.trim();
	    var subject = document.getElementById('emailSubject').value.trim();
	    var body    = document.getElementById('emailBody').value.trim();
	    var result  = document.getElementById('emailResult');

	    result.innerHTML = '';

	    if (!to)      { showEmailResult('danger', '수신자 이메일 주소를 입력해주세요.'); return; }
	    if (!subject) { showEmailResult('danger', '제목을 입력해주세요.');               return; }
	    if (!body)    { showEmailResult('danger', '내용을 입력해주세요.');               return; }

	    var sendBtn = document.querySelector('#emailModal .btn-dark');
	    sendBtn.disabled = true;
	    sendBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i>전송 중...';

	    var formData = new FormData();
	    formData.append('emailTo',      to);
	    formData.append('emailSubject', subject);
	    formData.append('emailBody',    body);

	    fetch('<%=contextPath%>/email/sendEmail.do', {
	        method: 'POST',
	        body: formData
	    })
	    .then(function(res) { return res.text(); })
	    .then(function(text) {
	        if (text.trim() === 'success') {
	            showEmailResult('success', '이메일이 성공적으로 전송되었습니다.');
	            document.getElementById('emailSubject').value = '';
	            document.getElementById('emailBody').value    = '';
	        } else {
	            showEmailResult('danger', '이메일 전송에 실패했습니다. 관리자에게 문의해주세요.');
	        }
	    })
	    .catch(function() {
	        showEmailResult('danger', '오류가 발생했습니다. 다시 시도해주세요.');
	    })
	    .finally(function() {
	        sendBtn.disabled = false;
	        sendBtn.innerHTML = '<i class="fas fa-paper-plane me-1"></i>전송';
	    });
	}

	function showEmailResult(type, msg) {
	    document.getElementById('emailResult').innerHTML =
	        '<div class="alert alert-' + type + '">' + msg + '</div>';
	}

	document.getElementById('emailModal').addEventListener('hidden.bs.modal', function () {
	    document.getElementById('emailResult').innerHTML = '';
	});
	</script>

	<% } %>

</body>
</html>
