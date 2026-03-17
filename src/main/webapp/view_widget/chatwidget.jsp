<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%
String contextPath = request.getContextPath();
String myName = (String) session.getAttribute("name");
String myRole = (String) session.getAttribute("role");
String sessionId = (String) session.getAttribute("id");

boolean isLogin = (sessionId != null && !sessionId.trim().isEmpty());
boolean isEmbed = "true".equals(request.getParameter("embed"));

if (!isLogin || myName == null || myName.isEmpty()) {
	return;
}
%>

<% if (!isEmbed) { %>

<button type="button" class="btn-float-chat" id="openChatFloatBtn" title="실시간 채팅">
	<i class="fas fa-comments"></i>
</button>

<div class="chat-float-panel" id="chatFloatPanel">
	<div class="chat-float-header">
		<span><i class="fas fa-comments me-2"></i>실시간 채팅</span>
		<button type="button" class="chat-float-close" id="closeChatFloatBtn">×</button>
	</div>
	<iframe src="<%=contextPath%>/view_widget/chatwidget.jsp?embed=true"
		class="chat-float-iframe" title="채팅"></iframe>
</div>

<script>
(function () {
    var $panel = $("#chatFloatPanel");
    var $aiPanel = $("#floatingAiPanel");

    $("#openChatFloatBtn").off("click").on("click", function () {
        if ($aiPanel.length) {
            $aiPanel.removeClass("show");
        }
        $panel.toggleClass("show");
    });

    $("#closeChatFloatBtn").off("click").on("click", function () {
        $panel.removeClass("show");
    });
})();
</script>

<% } else { %>

<!DOCTYPE html>


<html lang="ko" class="chat-embed-html">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>실시간 채팅</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<link rel="stylesheet" href="<%=contextPath%>/css/widget.css">
</head>

<body class="chat-embed-body">

	<div class="chat-wrapper">
		<div class="chat-messages" id="chatMessages"></div>

		<div class="chat-input-area">
			<input type="text"
				   id="msgInput"
				   placeholder="메시지를 입력하세요..."
				   autocomplete="off"
				   disabled>
			<button class="btn-send-chat" id="sendBtn" type="button" disabled>
				<i class="fas fa-paper-plane"></i>
			</button>
		</div>
	</div>

	<script>
    var ws = null;
    var myName = '<%=myName%>';

    function connect() {
        var protocol = (window.location.protocol === 'https:') ? 'wss:' : 'ws:';
        var wsUrl = protocol + '//' + window.location.host + '<%=contextPath%>/chat';

        ws = new WebSocket(wsUrl);

        ws.onopen = function() {
            setStatus(true);
            document.getElementById('msgInput').disabled = false;
            document.getElementById('sendBtn').disabled = false;
            document.getElementById('msgInput').focus();
        };

        ws.onmessage = function(event) {
            var data = JSON.parse(event.data);
            renderMessage(data);

            var uc = document.getElementById('userCount');
            if (uc) {
                uc.textContent = data.userCount;
            }
        };

        ws.onclose = function() {
            setStatus(false);
            document.getElementById('msgInput').disabled = true;
            document.getElementById('sendBtn').disabled = true;
            appendSystemMsg('연결이 끊어졌습니다. 페이지를 새로고침 해주세요.');
        };

        ws.onerror = function() {
            setStatus(false);
            appendSystemMsg('연결 오류가 발생했습니다.');
        };
    }

    function sendMessage() {
        var input = document.getElementById('msgInput');
        var text = input.value.trim();

        if (!text || !ws || ws.readyState !== WebSocket.OPEN) {
            return;
        }

        ws.send(text);
        input.value = '';
        input.focus();
    }

    function renderMessage(data) {
        if (data.type === 'join' || data.type === 'leave') {
            appendSystemMsg(data.content);
            return;
        }

        var isMine = (data.sender === myName);
        var box = document.getElementById('chatMessages');

        var group = document.createElement('div');
        group.className = 'msg-group ' + (isMine ? 'mine' : 'other');

        if (!isMine) {
            var senderEl = document.createElement('div');
            senderEl.className = 'msg-sender';
            senderEl.innerHTML = escapeHtml(data.sender)
                + '<span class="role-badge">(' + escapeHtml(data.role) + ')</span>';
            group.appendChild(senderEl);
        }

        var bubble = document.createElement('div');
        bubble.className = 'msg-bubble';
        bubble.textContent = data.content;
        group.appendChild(bubble);

        var timeEl = document.createElement('div');
        timeEl.className = 'msg-time';
        timeEl.textContent = data.time;
        group.appendChild(timeEl);

        box.appendChild(group);
        scrollToBottom();
    }

    function appendSystemMsg(text) {
        var box = document.getElementById('chatMessages');
        var el = document.createElement('div');
        el.className = 'msg-system';
        el.textContent = text;
        box.appendChild(el);
        scrollToBottom();
    }

    function setStatus(connected) {
        console.log('[Chat] 연결 상태:', connected ? '연결됨' : '연결 끊김');
    }

    function scrollToBottom() {
        var box = document.getElementById('chatMessages');
        box.scrollTop = box.scrollHeight;
    }

    function escapeHtml(str) {
        if (!str) return '';
        return str.replace(/&/g, '&amp;')
                  .replace(/</g, '&lt;')
                  .replace(/>/g, '&gt;')
                  .replace(/"/g, '&quot;');
    }

    document.addEventListener('DOMContentLoaded', function() {
        var input = document.getElementById('msgInput');
        var sendBtn = document.getElementById('sendBtn');

        input.addEventListener('keydown', function(e) {
            if (e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault();
                sendMessage();
            }
        });

        sendBtn.addEventListener('click', sendMessage);

        connect();
    });

    window.addEventListener('beforeunload', function() {
        if (ws) {
            ws.close();
        }
    });
	</script>

	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

<% } %>