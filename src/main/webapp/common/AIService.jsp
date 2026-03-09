<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>AI 학사 도우미</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
.ai-wrap{max-width:1100px;margin:28px auto;padding:0 16px 32px;}
.ai-hero{background:linear-gradient(135deg,#0d6efd 0%,#2a7fff 100%);color:#fff;border-radius:18px;padding:28px 24px;box-shadow:0 12px 28px rgba(13,110,253,.18);}
.ai-hero h2{margin:0 0 10px;font-weight:800;}
.ai-grid{display:grid;grid-template-columns:320px 1fr;gap:20px;margin-top:22px;}
.ai-card{background:#fff;border-radius:18px;border:1px solid #e9ecef;box-shadow:0 8px 24px rgba(0,0,0,.06);}
.ai-side{padding:18px;}
.quick-list{display:grid;gap:10px;}
.quick-btn{width:100%;border:1px solid #dbe7ff;background:#f8fbff;color:#0d6efd;border-radius:12px;padding:11px 12px;text-align:left;font-weight:600;}
.ai-chat{display:flex;flex-direction:column;min-height:620px;}
.ai-chat-header{padding:18px 20px;border-bottom:1px solid #edf0f2;font-weight:800;font-size:1.05rem;}
.ai-messages{flex:1;padding:18px;overflow-y:auto;background:#f8fafc;}
.msg-row{display:flex;margin-bottom:14px;}
.msg-row.user{justify-content:flex-end;}
.msg-bubble{max-width:78%;padding:12px 14px;border-radius:16px;line-height:1.6;white-space:pre-wrap;word-break:break-word;box-shadow:0 3px 10px rgba(0,0,0,.05);}
.msg-row.bot .msg-bubble{background:#fff;color:#212529;border:1px solid #e9ecef;border-top-left-radius:6px;}
.msg-row.user .msg-bubble{background:#0d6efd;color:#fff;border-top-right-radius:6px;}
.ai-input-wrap{border-top:1px solid #edf0f2;padding:16px;background:#fff;}
.ai-form{display:flex;gap:10px;}
.ai-form input{flex:1;border-radius:12px;border:1px solid #d7dbe0;padding:12px 14px;outline:none;}
.ai-form input:focus{border-color:#0d6efd;box-shadow:0 0 0 4px rgba(13,110,253,.1);}
.ai-send-btn{border:none;border-radius:12px;background:#0d6efd;color:#fff;font-weight:700;padding:0 18px;}
.ai-helper{margin-top:12px;color:#6c757d;font-size:.92rem;}
@media (max-width:900px){.ai-grid{grid-template-columns:1fr;}.ai-chat{min-height:540px;}}
</style>
</head>
<body>
<div class="ai-wrap">
    <div class="ai-hero">
        <h2>AI 학사 도우미</h2>
        <p>수강신청, 성적조회, 공지사항, 강의실, 학사 이용 방법 등을 자연어로 질문해보세요.</p>
    </div>
    <div class="ai-grid">
        <div class="ai-card ai-side">
            <div class="fw-bold mb-3">빠른 질문</div>
            <div class="quick-list">
                <button class="quick-btn" type="button" data-question="수강신청은 어떻게 하나요?">수강신청 방법</button>
                <button class="quick-btn" type="button" data-question="성적조회는 어디에서 하나요?">성적조회 위치</button>
                <button class="quick-btn" type="button" data-question="공지사항은 어디에서 확인하나요?">공지사항 확인</button>
                <button class="quick-btn" type="button" data-question="학생과 교수 메뉴의 차이를 알려주세요.">학생/교수 메뉴 차이</button>
            </div>
            <div class="ai-helper">답변이 정확하지 않으면 실제 공지사항이나 담당 부서 확인이 필요할 수 있어요.</div>
        </div>
        <div class="ai-card ai-chat">
            <div class="ai-chat-header">ColManager AI 상담창</div>
            <div class="ai-messages" id="aiMessages">
                <div class="msg-row bot"><div class="msg-bubble">안녕하세요! 학사 지원 프로그램 AI 도우미입니다.
궁금한 내용을 질문해주시면 최대한 쉽게 안내해드릴게요.</div></div>
            </div>
            <div class="ai-input-wrap">
                <form id="aiChatForm" class="ai-form">
                    <input type="text" id="aiMessageInput" placeholder="예) 성적조회는 어디에서 하나요?" autocomplete="off">
                    <button type="submit" class="ai-send-btn">전송</button>
                </form>
                <div class="ai-helper">Enter 키로도 질문할 수 있습니다.</div>
            </div>
        </div>
    </div>
</div>
<script src="https://code.jquery.com/jquery-latest.min.js"></script>
<script>
(function(){
    var $messages = $("#aiMessages");
    var $input = $("#aiMessageInput");
    var sending = false;

    function escapeHtml(text){ return $("<div>").text(text).html(); }
    function addMessage(role, text){
        var cls = role === "user" ? "user" : "bot";
        var html = '<div class="msg-row ' + cls + '"><div class="msg-bubble">' + escapeHtml(text).replace(/\n/g, "<br>") + '</div></div>';
        $messages.append(html);
        $messages.scrollTop($messages[0].scrollHeight);
    }
    function sendQuestion(message){
        if(!message || $.trim(message)==="" || sending) return;
        sending = true;
        addMessage("user", message);
        addMessage("bot", "답변을 생성하는 중입니다...");
        $input.val("").focus();

        $.ajax({
            url: "<%=contextPath%>/chatbot/send.do",
            type: "POST",
            dataType: "json",
            data: { message: message },
            success: function(res){
                $messages.find(".msg-row:last").remove();
                if(res && res.status === "success"){
                    addMessage("bot", res.reply || "응답이 비어 있습니다.");
                }else{
                    addMessage("bot", (res && res.reply) ? res.reply : "AI 응답에 실패했습니다.");
                }
            },
            error: function(){
                $messages.find(".msg-row:last").remove();
                addMessage("bot", "서버와 통신 중 오류가 발생했습니다.");
            },
            complete: function(){ sending = false; }
        });
    }

    $("#aiChatForm").on("submit", function(e){ e.preventDefault(); sendQuestion($input.val()); });
    $(".quick-btn").on("click", function(){ sendQuestion($(this).data("question")); });
})();
</script>
</body>
</html>
