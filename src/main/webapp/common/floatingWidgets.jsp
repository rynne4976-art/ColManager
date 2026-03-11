<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
	String contextPath = request.getContextPath();
	String sessionRole = (String) session.getAttribute("role");
	String sessionName = (String) session.getAttribute("name");
	String sessionId = (String) session.getAttribute("id");   // 로그인 여부 판단용
	
%>

<script src="https://code.jquery.com/jquery-latest.min.js"></script>

<!-- AI + 채팅 + 이메일 버튼 묶음 -->
<div class="floating-widget-stack">

	<!-- 이메일 버튼: 로그인한 사용자만 노출 -->
	<% if (sessionRole!=null) { %>
	<button class="btn-float-email"
	        data-bs-toggle="modal"
	        data-bs-target="#emailModal"
	        title="이메일 보내기">
		<i class="fas fa-envelope"></i>
	</button>
	<% } %>

	<!-- 실시간 채팅 버튼: 로그인한 사용자만 노출 -->
	<% if (sessionRole!=null) { %>
	<button type="button" class="btn-float-chat" id="openChatFloatBtn" title="실시간 채팅">
		<i class="fas fa-comments"></i>
	</button>
	<% } %>

	<!-- AI 버튼: 비로그인도 항상 노출 -->
	<button type="button" class="btn-float-ai" id="openAiFloatBtn" title="AI 챗">
		<i class="fas fa-robot"></i>
	</button>
</div>

<!-- 실시간 채팅 패널: 로그인한 사용자만 렌더링 -->
<% if (sessionRole!=null) { %>
<div class="chat-float-panel" id="chatFloatPanel">
	<div class="chat-float-header">
		<span><i class="fas fa-comments me-2"></i>실시간 채팅</span>
		<button type="button" class="chat-float-close" id="closeChatFloatBtn">×</button>
	</div>
	<iframe src="<%=contextPath%>/view_chat/chatRoom.jsp?embed=true"
	        class="chat-float-iframe"
	        title="채팅"></iframe>
</div>
<% } %>

<!-- AI 패널 -->
<div class="floating-ai-panel" id="floatingAiPanel">
    <div class="floating-ai-header">
        <span>AI 학사 도우미</span>
        <button type="button" class="floating-close" id="closeAiFloatBtn">×</button>
    </div>

    <div class="float-ai-body">
        <div class="float-ai-msgs" id="floatAiMsgs">
            <div class="float-row bot">
            	<div class="float-bubble">
안녕하세요! 학사 지원 프로그램 AI 도우미입니다.
수강신청, 성적조회, 공지사항, 메뉴 이용 방법 등을 질문해보세요.
            	</div>
            </div>
        </div>

        <div class="float-ai-quick">
            <button type="button" data-q="수강신청은 어떻게 하나요?">수강신청</button>
            <button type="button" data-q="성적조회는 어디에서 하나요?">성적조회</button>
            <button type="button" data-q="공지사항은 어디에서 확인하나요?">공지사항</button>
        </div>

        <form class="float-ai-input" id="floatAiForm">
            <input type="text" id="floatAiInput" placeholder="질문을 입력하세요">
            <button type="submit">전송</button>
        </form>
    </div>
</div>

<!-- 이메일 모달: 로그인한 사용자만 렌더링 -->
<% if (sessionRole!=null) { %>
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

				<div class="sender-badge">
					<i class="fas fa-user me-1"></i>
					발신자: <strong><%= sessionName != null ? sessionName : "" %></strong>
				</div>

				<div class="mb-3">
					<label for="emailTo" class="form-label fw-semibold">
						<i class="fas fa-at me-1 text-secondary"></i>받는 사람
					</label>
					<input type="email" class="form-control" id="emailTo"
					       placeholder="수신자 이메일 주소">
				</div>

				<div class="mb-3">
					<label for="emailSubject" class="form-label fw-semibold">
						<i class="fas fa-heading me-1 text-secondary"></i>제목
					</label>
					<input type="text" class="form-control" id="emailSubject"
					       placeholder="제목을 입력하세요" maxlength="200">
				</div>

				<div class="mb-3">
					<label for="emailBody" class="form-label fw-semibold">
						<i class="fas fa-align-left me-1 text-secondary"></i>내용
					</label>
					<textarea class="form-control" id="emailBody"
					          rows="7" placeholder="내용을 입력하세요"></textarea>
				</div>

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
<% } %>

<script>
(function(){
    var $panel = $("#floatingAiPanel");
    var $chatPanel = $("#chatFloatPanel");
    var $msgs = $("#floatAiMsgs");
    var $input = $("#floatAiInput");
    var sending = false;
    var isLogin = <%= sessionRole!=null ? "true" : "false" %>;

    function esc(text){
        return $("<div>").text(text).html();
    }

    function addMsg(role, text){
        var html = '<div class="float-row ' + role + '"><div class="float-bubble">'
                 + esc(text).replace(/\n/g, "<br>")
                 + '</div></div>';

        $msgs.append(html);
        $msgs.scrollTop($msgs[0].scrollHeight);
    }

    function sendAi(message){
        if(!message || $.trim(message) === "" || sending) return;

        sending = true;
        addMsg("user", message);
        addMsg("bot", "답변을 생성하는 중입니다...");
        $input.val("").focus();

        $.ajax({
            url: "<%=contextPath%>/chatbot/send.do",
            type: "POST",
            dataType: "json",
            data: { message: message },
            success: function(res){
                $msgs.find(".float-row:last").remove();

                if(res && res.status === "success"){
                    addMsg("bot", res.reply || "응답이 비어 있습니다.");
                } else {
                    addMsg("bot", (res && res.reply) ? res.reply : "AI 응답에 실패했습니다.");
                }
            },
            error: function(){
                $msgs.find(".float-row:last").remove();
                addMsg("bot", "서버와 통신 중 오류가 발생했습니다.");
            },
            complete: function(){
                sending = false;
            }
        });
    }

    $("#openAiFloatBtn").on("click", function(){
        if(isLogin && $chatPanel.length){
            $chatPanel.removeClass("show");
        }
        $panel.toggleClass("show");
    });

    $("#closeAiFloatBtn").on("click", function(){
        $panel.removeClass("show");
    });

    if(isLogin){
        $("#openChatFloatBtn").on("click", function(){
            $panel.removeClass("show");
            $chatPanel.toggleClass("show");
        });

        $("#closeChatFloatBtn").on("click", function(){
            $chatPanel.removeClass("show");
        });
    }

    $("#floatAiForm").on("submit", function(e){
        e.preventDefault();
        sendAi($input.val());
    });

    $(".float-ai-quick button").on("click", function(){
        if(!$panel.hasClass("show")){
            if(isLogin && $chatPanel.length){
                $chatPanel.removeClass("show");
            }
            $panel.addClass("show");
        }
        sendAi($(this).data("q"));
    });
})();

function submitEmail() {
    var emailModal = document.getElementById('emailModal');
    if (!emailModal) return;

    var to      = document.getElementById('emailTo').value.trim();
    var subject = document.getElementById('emailSubject').value.trim();
    var body    = document.getElementById('emailBody').value.trim();
    var result  = document.getElementById('emailResult');

    result.innerHTML = '';

    if (!to) {
        showEmailResult('danger', '수신자 이메일 주소를 입력해주세요.');
        return;
    }
    if (!subject) {
        showEmailResult('danger', '제목을 입력해주세요.');
        return;
    }
    if (!body) {
        showEmailResult('danger', '내용을 입력해주세요.');
        return;
    }

    var sendBtn = document.querySelector('#emailModal .btn-dark');
    sendBtn.disabled = true;
    sendBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i>전송 중...';

    var formData = new FormData();
    formData.append('emailTo', to);
    formData.append('emailSubject', subject);
    formData.append('emailBody', body);

    fetch('<%=contextPath%>/email/sendEmail.do', {
        method: 'POST',
        body: formData
    })
    .then(function(res) {
        return res.text();
    })
    .then(function(text) {
        if (text.trim() === 'success') {
            showEmailResult('success', '이메일이 성공적으로 전송되었습니다.');
            document.getElementById('emailSubject').value = '';
            document.getElementById('emailBody').value = '';
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
    var result = document.getElementById('emailResult');
    if (!result) return;

    result.innerHTML =
        '<div class="alert alert-' + type + '">' + msg + '</div>';
}

document.addEventListener('DOMContentLoaded', function () {
    var emailModal = document.getElementById('emailModal');
    if (emailModal) {
        emailModal.addEventListener('hidden.bs.modal', function () {
            document.getElementById('emailResult').innerHTML = '';
        });
    }
});
</script>