<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    String contextPath = request.getContextPath();
    String sessionRole = (String) session.getAttribute("role");
%>

<button type="button" class="btn-float-ai" id="openAiFloatBtn" title="AI 챗">
    <i class="fas fa-robot"></i>
</button>

<div class="floating-ai-panel" id="floatingAiPanel">
    <div class="floating-ai-header">
        <span>AI 학사 도우미</span>
        <button type="button" class="floating-close" id="closeAiFloatBtn">×</button>
    </div>

    <div class="float-ai-body">
        <div class="float-ai-msgs" id="floatAiMsgs">
            <div class="float-row bot">
                <div class="float-bubble">
안녕하세요! 학사 지원 프로그램 AI 도우미입니다. 학사와 관련된 궁금한 내용을 질문해주세요.
                </div>
            </div>
        </div>

        <div class="float-ai-quick">
            <button type="button" data-q="수강신청은 어떻게 하나요?">수강신청</button>
            <button type="button" data-q="성적조회는 어디에서 하나요?">성적조회</button>
            <button type="button" data-q="공지사항은 어디에서 확인하나요?">공지사항</button>
            <button type="button" data-q="출결상황 확인해주세요">출결확인</button>
        </div>

        <form class="float-ai-input" id="floatAiForm">
            <input type="text" id="floatAiInput" placeholder="질문을 입력하세요">
            <button type="submit">전송</button>
        </form>
    </div>
</div>

<script>
(function(){
    var $panel = $("#floatingAiPanel");
    var $chatPanel = $("#chatFloatPanel");
    var $msgs = $("#floatAiMsgs");
    var $input = $("#floatAiInput");
    var sending = false;
    var isLogin = <%= sessionRole != null ? "true" : "false" %>;

    function esc(text){
        return $("<div>").text(text || "").html();
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

    $("#openAiFloatBtn").off("click").on("click", function(){
        if(isLogin && $chatPanel.length){
            $chatPanel.removeClass("show");
        }
        $panel.toggleClass("show");
    });

    $("#closeAiFloatBtn").off("click").on("click", function(){
        $panel.removeClass("show");
    });

    $("#floatAiForm").off("submit").on("submit", function(e){
        e.preventDefault();
        sendAi($input.val());
    });

    $(".float-ai-quick button").off("click").on("click", function(){
        if(!$panel.hasClass("show")){
            if(isLogin && $chatPanel.length){
                $chatPanel.removeClass("show");
            }
            $panel.addClass("show");
        }
        sendAi($(this).data("q"));
    });
})();
</script>