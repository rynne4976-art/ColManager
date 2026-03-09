<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
    String contextPath = request.getContextPath();
    String userName    = (String) session.getAttribute("name");
    String userId      = (String) session.getAttribute("id");
    if (userName == null) userName = "";
    if (userId  == null) userId   = "";
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>이메일 보내기</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<style>
    body {
        background-color: #f8f9fa;
    }
    .email-card {
        max-width: 700px;
        margin: 40px auto;
        border-radius: 12px;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
    }
    .email-card .card-header {
        background-color: #343a40;
        color: #fff;
        border-radius: 12px 12px 0 0;
        padding: 18px 24px;
    }
    .email-card .card-header h4 {
        margin: 0;
        font-size: 1.2rem;
    }
    .form-label {
        font-weight: 600;
    }
    .btn-send {
        background-color: #343a40;
        color: #fff;
        padding: 10px 30px;
        border-radius: 8px;
        font-size: 1rem;
    }
    .btn-send:hover {
        background-color: #495057;
        color: #fff;
    }
    .sender-info {
        background-color: #e9ecef;
        border-radius: 8px;
        padding: 10px 15px;
        font-size: 0.9rem;
        color: #495057;
    }
</style>
</head>
<body>
<div class="container py-4">
    <div class="card email-card">
        <!-- 헤더 -->
        <div class="card-header d-flex align-items-center gap-2">
            <i class="fas fa-envelope"></i>
            <h4>이메일 보내기</h4>
        </div>

        <!-- 발신자 정보 -->
        <div class="card-body pb-0">
            <div class="sender-info mb-3">
                <i class="fas fa-user me-1"></i>
                발신자: <strong><%= userName %></strong> (<%= userId %>)
            </div>
        </div>

        <!-- 이메일 폼 -->
        <div class="card-body">
            <form action="<%= contextPath %>/student/sendEmail.do" method="post" onsubmit="return validateForm()">

                <!-- 수신자 -->
                <div class="mb-3">
                    <label for="emailTo" class="form-label">
                        <i class="fas fa-at me-1"></i>받는 사람
                    </label>
                    <input type="email"
                           class="form-control"
                           id="emailTo"
                           name="emailTo"
                           value="info@yourschool.edu"
                           placeholder="수신자 이메일 주소">
                    <div class="form-text">기본 수신 주소: info@yourschool.edu</div>
                </div>

                <!-- 제목 -->
                <div class="mb-3">
                    <label for="emailSubject" class="form-label">
                        <i class="fas fa-heading me-1"></i>제목
                    </label>
                    <input type="text"
                           class="form-control"
                           id="emailSubject"
                           name="emailSubject"
                           placeholder="이메일 제목을 입력하세요"
                           maxlength="200">
                </div>

                <!-- 본문 -->
                <div class="mb-4">
                    <label for="emailBody" class="form-label">
                        <i class="fas fa-align-left me-1"></i>내용
                    </label>
                    <textarea class="form-control"
                              id="emailBody"
                              name="emailBody"
                              rows="10"
                              placeholder="내용을 입력하세요"></textarea>
                </div>

                <!-- 버튼 -->
                <div class="d-flex justify-content-end gap-2">
                    <button type="button"
                            class="btn btn-outline-secondary"
                            onclick="history.go(-1)">
                        <i class="fas fa-times me-1"></i>취소
                    </button>
                    <button type="submit" class="btn btn-send">
                        <i class="fas fa-paper-plane me-1"></i>전송
                    </button>
                </div>

            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
function validateForm() {
    var to      = document.getElementById('emailTo').value.trim();
    var subject = document.getElementById('emailSubject').value.trim();
    var body    = document.getElementById('emailBody').value.trim();

    if (!to) {
        alert('수신자 이메일 주소를 입력해주세요.');
        document.getElementById('emailTo').focus();
        return false;
    }
    if (!subject) {
        alert('제목을 입력해주세요.');
        document.getElementById('emailSubject').focus();
        return false;
    }
    if (!body) {
        alert('내용을 입력해주세요.');
        document.getElementById('emailBody').focus();
        return false;
    }
    return true;
}
</script>
</body>
</html>
