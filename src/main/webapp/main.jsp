<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%
	String contextPath = request.getContextPath();
%>

<!doctype html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>EveryOne</title>

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

<style>
.floating-ai-stack{
    position: fixed;
    right: 26px;
    bottom: 28px;
    z-index: 99999;
    display: flex;
    flex-direction: column;
    align-items: center;
}
.floating-ai-btn{
    width: 96px;
    height: 96px;
    border: none;
    border-radius: 50%;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #fff;
    background: linear-gradient(135deg,#2563eb,#5b8cff);
    font-size: 2.6rem;
    box-shadow: 0 12px 24px rgba(0,0,0,.22);
    transition: transform .18s ease, box-shadow .18s ease;
}
.floating-ai-btn:hover{
    transform: translateY(-2px) scale(1.03);
    box-shadow: 0 16px 28px rgba(0,0,0,.28);
}
.floating-ai-tag{
    margin-top: 6px;
    background: rgba(33,37,41,.9);
    color: #fff;
    border-radius: 999px;
    font-size: .8rem;
    padding: 4px 10px;
    line-height: 1;
    white-space: nowrap;
}
.floating-ai-panel{
    position: fixed;
    right: 140px;
    bottom: 36px;
    width: 420px;
    height: 620px;
    z-index: 99998;
    display: none;
    flex-direction: column;
    background: #fff;
    border-radius: 18px;
    overflow: hidden;
    border: 1px solid #dfe5ec;
    box-shadow: 0 18px 40px rgba(0,0,0,.22);
}
.floating-ai-panel.show{ display:flex; }
.floating-ai-header{
    display:flex;
    align-items:center;
    justify-content:space-between;
    padding:14px 16px;
    color:#fff;
    font-weight:800;
    background: linear-gradient(135deg,#2563eb,#5b8cff);
}
.floating-close{
    border:none;
    background:rgba(255,255,255,.18);
    color:#fff;
    width:34px;
    height:34px;
    border-radius:50%;
    font-size:1.15rem;
    cursor:pointer;
}
.float-ai-body{ display:flex; flex-direction:column; height:calc(100% - 62px); background:#f8fafc; }
.float-ai-msgs{ flex:1; overflow-y:auto; padding:16px; }
.float-row{ display:flex; margin-bottom:12px; }
.float-row.user{ justify-content:flex-end; }
.float-bubble{
    max-width:82%;
    border-radius:16px;
    padding:11px 13px;
    line-height:1.55;
    font-size:.95rem;
    word-break:break-word;
    white-space:pre-wrap;
    box-shadow:0 3px 10px rgba(0,0,0,.05);
}
.float-row.bot .float-bubble{
    background:#fff; color:#212529; border:1px solid #e5e7eb; border-top-left-radius:6px;
}
.float-row.user .float-bubble{
    background:#2563eb; color:#fff; border-top-right-radius:6px;
}
.float-ai-quick{ display:flex; flex-wrap:wrap; gap:8px; padding:0 16px 12px; }
.float-ai-quick button{
    border:1px solid #dbeafe;
    background:#eff6ff;
    color:#2563eb;
    border-radius:999px;
    padding:7px 11px;
    font-size:.82rem;
    font-weight:700;
    cursor:pointer;
}
.float-ai-input{ border-top:1px solid #e5e7eb; background:#fff; padding:12px; display:flex; gap:8px; }
.float-ai-input input{
    flex:1; border:1px solid #d1d5db; border-radius:12px; padding:11px 12px; outline:none;
}
.float-ai-input input:focus{
    border-color:#2563eb; box-shadow:0 0 0 4px rgba(37,99,235,.12);
}
.float-ai-input button{
    border:none; background:#2563eb; color:#fff; font-weight:700; border-radius:12px; padding:0 16px;
}
@media (max-width:768px){
    .floating-ai-stack{ right:14px; bottom:16px; }
    .floating-ai-btn{ width:82px; height:82px; font-size:2.2rem; }
    .floating-ai-panel{ right:12px; left:12px; width:auto; height:68vh; bottom:108px; }
}
</style>

<div class="floating-ai-stack">
    <button type="button" class="floating-ai-btn" id="openAiFloatBtn" title="AI 챗">🤖</button>
    <div class="floating-ai-tag">AI 챗</div>
</div>

<div class="floating-ai-panel" id="floatingAiPanel">
    <div class="floating-ai-header">
        <span>AI 학사 도우미</span>
        <button type="button" class="floating-close" id="closeAiFloatBtn">×</button>
    </div>
    <div class="float-ai-body">
        <div class="float-ai-msgs" id="floatAiMsgs">
            <div class="float-row bot"><div class="float-bubble">안녕하세요! 학사 지원 프로그램 AI 도우미입니다.
수강신청, 성적조회, 공지사항, 메뉴 이용 방법 등을 질문해보세요.</div></div>
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

<script src="https://code.jquery.com/jquery-latest.min.js"></script>
<script>
(function(){
    var $panel = $("#floatingAiPanel");
    var $msgs = $("#floatAiMsgs");
    var $input = $("#floatAiInput");
    var sending = false;

    function esc(text){ return $("<div>").text(text).html(); }
    function togglePanel(){ $panel.toggleClass("show"); }
    function addMsg(role, text){
        var html = '<div class="float-row ' + role + '"><div class="float-bubble">' + esc(text).replace(/\n/g, "<br>") + '</div></div>';
        $msgs.append(html);
        $msgs.scrollTop($msgs[0].scrollHeight);
    }
    function sendAi(message){
        if(!message || $.trim(message)==="" || sending) return;
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
                }else{
                    addMsg("bot", (res && res.reply) ? res.reply : "AI 응답에 실패했습니다.");
                }
            },
            error: function(){
                $msgs.find(".float-row:last").remove();
                addMsg("bot", "서버와 통신 중 오류가 발생했습니다.");
            },
            complete: function(){ sending = false; }
        });
    }

    $("#openAiFloatBtn").on("click", togglePanel);
    $("#closeAiFloatBtn").on("click", function(){ $panel.removeClass("show"); });
    $("#floatAiForm").on("submit", function(e){ e.preventDefault(); sendAi($input.val()); });
    $(".float-ai-quick button").on("click", function(){ if(!$panel.hasClass("show")) $panel.addClass("show"); sendAi($(this).data("q")); });
})();
</script>

</body>
</html>
