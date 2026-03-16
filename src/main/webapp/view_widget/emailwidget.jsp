<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    String contextPath = request.getContextPath();
    String sessionName = (String) session.getAttribute("name");
    String sessionId = (String) session.getAttribute("id");
    boolean isLogin = (sessionId != null && !sessionId.trim().isEmpty());
%>

<% if (isLogin) { %>
<button class="btn-float-email"
        data-bs-toggle="modal"
        data-bs-target="#emailModal"
        title="이메일 보내기">
    <i class="fas fa-envelope"></i>
</button>

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
                    <label class="form-label fw-semibold">
                        <i class="fas fa-at me-1 text-secondary"></i>받는 사람
                    </label>
                    <div class="form-control bg-light text-muted" style="cursor:default;">
                        <i class="fas fa-user-shield me-1"></i>관리자
                    </div>
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
                <button type="button" class="btn btn-dark" id="emailSendBtn">
                    <i class="fas fa-paper-plane me-1"></i>전송
                </button>
            </div>

        </div>
    </div>
</div>

<script>
(function() {
    function showEmailResult(type, msg) {
        var result = document.getElementById('emailResult');
        if (!result) return;

        result.innerHTML = '<div class="alert alert-' + type + '">' + msg + '</div>';
    }

    function submitEmail() {
        var emailModal = document.getElementById('emailModal');
        if (!emailModal) return;

        var subject = document.getElementById('emailSubject').value.trim();
        var body = document.getElementById('emailBody').value.trim();
        var result = document.getElementById('emailResult');

        result.innerHTML = '';

        if (!subject) {
            showEmailResult('danger', '제목을 입력해주세요.');
            return;
        }
        if (!body) {
            showEmailResult('danger', '내용을 입력해주세요.');
            return;
        }

        var sendBtn = document.getElementById('emailSendBtn');
        sendBtn.disabled = true;
        sendBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i>전송 중...';

        var formData = new FormData();
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

    document.addEventListener('DOMContentLoaded', function () {
        var emailSendBtn = document.getElementById('emailSendBtn');
        if (emailSendBtn) {
            emailSendBtn.addEventListener('click', submitEmail);
        }

        var emailModal = document.getElementById('emailModal');
        if (emailModal) {
            emailModal.addEventListener('hidden.bs.modal', function () {
                document.getElementById('emailResult').innerHTML = '';
            });
        }
    });
})();
</script>
<% } %>