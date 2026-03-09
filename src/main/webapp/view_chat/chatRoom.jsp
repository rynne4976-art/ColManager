<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%
    String contextPath = request.getContextPath();
    String myName = (String) session.getAttribute("name");
    String myRole = (String) session.getAttribute("role");

    // 로그인 확인
    if (myName == null || myName.isEmpty()) {
        response.sendRedirect(contextPath + "/member/main.bo");
        return;
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>실시간 채팅</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

<style>
    * { box-sizing: border-box; }

    body {
        background-color: #f0f2f5;
    }

    .chat-wrapper {
        max-width: 800px;
        margin: 30px auto;
        display: flex;
        flex-direction: column;
        height: calc(100vh - 120px);
    }

    /* 상단 헤더 */
    .chat-header {
        background-color: #343a40;
        color: #fff;
        padding: 14px 20px;
        border-radius: 12px 12px 0 0;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .chat-header .title {
        font-size: 1.1rem;
        font-weight: 700;
    }

    .chat-header .meta {
        display: flex;
        align-items: center;
        gap: 14px;
        font-size: 0.85rem;
        color: #ced4da;
    }

    /* 접속 상태 표시 */
    .status-dot {
        width: 10px;
        height: 10px;
        border-radius: 50%;
        display: inline-block;
        background-color: #6c757d;
        margin-right: 5px;
        transition: background-color 0.3s;
    }
    .status-dot.connected    { background-color: #28a745; }
    .status-dot.disconnected { background-color: #dc3545; }

    /* 메시지 영역 */
    .chat-messages {
        flex: 1;
        overflow-y: auto;
        padding: 20px;
        background-color: #fff;
        display: flex;
        flex-direction: column;
        gap: 10px;
        border-left: 1px solid #dee2e6;
        border-right: 1px solid #dee2e6;
    }

    /* 시스템 메시지 (입장/퇴장) */
    .msg-system {
        text-align: center;
        font-size: 0.78rem;
        color: #868e96;
        padding: 4px 12px;
        background-color: #f8f9fa;
        border-radius: 20px;
        align-self: center;
    }

    /* 메시지 묶음 */
    .msg-group {
        display: flex;
        flex-direction: column;
        max-width: 70%;
    }
    .msg-group.mine  { align-self: flex-end;  align-items: flex-end; }
    .msg-group.other { align-self: flex-start; align-items: flex-start; }

    /* 발신자 이름 + 역할 */
    .msg-sender {
        font-size: 0.78rem;
        color: #495057;
        margin-bottom: 3px;
        font-weight: 600;
    }
    .msg-sender .role-badge {
        font-size: 0.7rem;
        font-weight: 400;
        color: #868e96;
        margin-left: 4px;
    }

    /* 말풍선 */
    .msg-bubble {
        padding: 9px 14px;
        border-radius: 18px;
        font-size: 0.92rem;
        line-height: 1.5;
        word-break: break-word;
        max-width: 100%;
    }
    .msg-group.mine  .msg-bubble {
        background-color: #343a40;
        color: #fff;
        border-bottom-right-radius: 4px;
    }
    .msg-group.other .msg-bubble {
        background-color: #e9ecef;
        color: #212529;
        border-bottom-left-radius: 4px;
    }

    /* 시간 */
    .msg-time {
        font-size: 0.7rem;
        color: #adb5bd;
        margin-top: 3px;
    }

    /* 입력 영역 */
    .chat-input-area {
        display: flex;
        gap: 8px;
        padding: 14px 16px;
        background-color: #f8f9fa;
        border: 1px solid #dee2e6;
        border-top: none;
        border-radius: 0 0 12px 12px;
    }

    .chat-input-area input {
        flex: 1;
        border-radius: 20px;
        border: 1px solid #ced4da;
        padding: 9px 16px;
        font-size: 0.95rem;
        outline: none;
    }
    .chat-input-area input:focus {
        border-color: #343a40;
        box-shadow: 0 0 0 2px rgba(52,58,64,0.15);
    }

    .btn-send-chat {
        background-color: #343a40;
        color: #fff;
        border: none;
        border-radius: 20px;
        padding: 9px 20px;
        font-size: 0.95rem;
        cursor: pointer;
        transition: background-color 0.2s;
    }
    .btn-send-chat:hover { background-color: #495057; }
    .btn-send-chat:disabled {
        background-color: #adb5bd;
        cursor: not-allowed;
    }
</style>
</head>
<body>

<div class="chat-wrapper">

    <!-- 헤더 -->
    <div class="chat-header">
        <span class="title">
            <i class="fas fa-comments me-2"></i>실시간 채팅
        </span>
        <div class="meta">
            <span>
                <span class="status-dot" id="statusDot"></span>
                <span id="statusText">연결 중...</span>
            </span>
            <span>
                <i class="fas fa-users me-1"></i>
                <span id="userCount">0</span>명 접속 중
            </span>
            <span><%= myName %> (<%= myRole %>)</span>
        </div>
    </div>

    <!-- 메시지 목록 -->
    <div class="chat-messages" id="chatMessages"></div>

    <!-- 입력창 -->
    <div class="chat-input-area">
        <input type="text"
               id="msgInput"
               placeholder="메시지를 입력하세요..."
               autocomplete="off"
               disabled>
        <button class="btn-send-chat" id="sendBtn" onclick="sendMessage()" disabled>
            <i class="fas fa-paper-plane"></i>
        </button>
    </div>

</div>

<script>
    var ws;
    var myName = '<%= myName %>';

    // ── WebSocket 연결 ──────────────────────────────
    function connect() {
        var protocol = (window.location.protocol === 'https:') ? 'wss:' : 'ws:';
        var wsUrl = protocol + '//' + window.location.host + '<%= contextPath %>/chat';

        ws = new WebSocket(wsUrl);

        ws.onopen = function () {
            setStatus(true);
            document.getElementById('msgInput').disabled = false;
            document.getElementById('sendBtn').disabled = false;
            document.getElementById('msgInput').focus();
        };

        ws.onmessage = function (event) {
            var data = JSON.parse(event.data);
            renderMessage(data);
            document.getElementById('userCount').textContent = data.userCount;
        };

        ws.onclose = function () {
            setStatus(false);
            document.getElementById('msgInput').disabled = true;
            document.getElementById('sendBtn').disabled = true;
            appendSystemMsg('연결이 끊어졌습니다. 페이지를 새로고침 해주세요.');
        };

        ws.onerror = function () {
            setStatus(false);
            appendSystemMsg('연결 오류가 발생했습니다.');
        };
    }

    // ── 메시지 전송 ─────────────────────────────────
    function sendMessage() {
        var input = document.getElementById('msgInput');
        var text  = input.value.trim();
        if (!text || !ws || ws.readyState !== WebSocket.OPEN) return;

        ws.send(text);
        input.value = '';
        input.focus();
    }

    // ── 메시지 렌더링 ────────────────────────────────
    function renderMessage(data) {
        if (data.type === 'join' || data.type === 'leave') {
            appendSystemMsg(data.content);
            return;
        }

        var isMine = (data.sender === myName);
        var box    = document.getElementById('chatMessages');

        var group = document.createElement('div');
        group.className = 'msg-group ' + (isMine ? 'mine' : 'other');

        // 상대방 메시지일 때만 이름 표시
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

    // ── 시스템 메시지 추가 ───────────────────────────
    function appendSystemMsg(text) {
        var box = document.getElementById('chatMessages');
        var el  = document.createElement('div');
        el.className   = 'msg-system';
        el.textContent = text;
        box.appendChild(el);
        scrollToBottom();
    }

    // ── 접속 상태 업데이트 ───────────────────────────
    function setStatus(connected) {
        var dot  = document.getElementById('statusDot');
        var text = document.getElementById('statusText');
        if (connected) {
            dot.className  = 'status-dot connected';
            text.textContent = '연결됨';
        } else {
            dot.className  = 'status-dot disconnected';
            text.textContent = '연결 끊김';
        }
    }

    // ── 스크롤 하단 이동 ─────────────────────────────
    function scrollToBottom() {
        var box = document.getElementById('chatMessages');
        box.scrollTop = box.scrollHeight;
    }

    // ── XSS 방지 ────────────────────────────────────
    function escapeHtml(str) {
        return str.replace(/&/g,'&amp;')
                  .replace(/</g,'&lt;')
                  .replace(/>/g,'&gt;')
                  .replace(/"/g,'&quot;');
    }

    // ── Enter 전송 ───────────────────────────────────
    document.addEventListener('DOMContentLoaded', function () {
        document.getElementById('msgInput').addEventListener('keydown', function (e) {
            if (e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault();
                sendMessage();
            }
        });
        connect();
    });

    // 페이지 이탈 시 연결 종료
    window.addEventListener('beforeunload', function () {
        if (ws) ws.close();
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
