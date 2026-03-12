<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Vo.StudentVo" %>
<%
    String contextPath = request.getContextPath();
    StudentVo info = (StudentVo) request.getAttribute("studentInfo");
    String studentName = (String) session.getAttribute("name");
    String studentId   = (String) session.getAttribute("student_id");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>증명서 조회</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<style>
    body { background-color: #f8f9fa; }
    .cert-card {
        border: none;
        border-radius: 16px;
        box-shadow: 0 4px 18px rgba(0,0,0,0.08);
        transition: transform 0.15s;
    }
    .cert-card:hover { transform: translateY(-3px); }
    .cert-icon { font-size: 2.6rem; margin-bottom: 12px; }
    .cert-title { font-size: 1.2rem; font-weight: 700; color: #343a40; }
    .cert-desc  { font-size: 0.88rem; color: #6c757d; margin-bottom: 16px; }
    .btn-cert-xls  { background-color: #1d6f42; color: #fff; border: none; }
    .btn-cert-xls:hover  { background-color: #155734; color: #fff; }
    .btn-cert-print { background-color: #343a40; color: #fff; border: none; }
    .btn-cert-print:hover { background-color: #212529; color: #fff; }
    .student-info-bar {
        background: #fff;
        border-radius: 12px;
        padding: 14px 24px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.06);
        margin-bottom: 28px;
        font-size: 0.92rem;
        color: #495057;
    }
    .student-info-bar span { margin-right: 24px; }
    .student-info-bar strong { color: #212529; }
</style>
</head>
<body>
<div class="container py-4">

    <!-- 페이지 헤더 -->
    <div class="mb-4">
        <h4 class="fw-bold mb-1"><i class="fas fa-file-alt me-2 text-secondary"></i>증명서 조회</h4>
        <p class="text-muted small mb-0">성적증명서와 졸업증명서를 조회하거나 다운로드할 수 있습니다.</p>
    </div>

    <!-- 학생 기본 정보 -->
    <div class="student-info-bar">
        <span><i class="fas fa-user me-1"></i><strong><%= studentName != null ? studentName : "-" %></strong></span>
        <span><i class="fas fa-id-card me-1"></i>학번: <strong><%= studentId != null ? studentId : "-" %></strong></span>
        <% if (info != null) { %>
        <span><i class="fas fa-graduation-cap me-1"></i>전공: <strong><%= info.getCourse() != null ? info.getCourse().getMajorname() : "-" %></strong></span>
        <span><i class="fas fa-layer-group me-1"></i>학년: <strong><%= info.getGrade() %>학년</strong></span>
        <span><i class="fas fa-circle me-1 <%= "재학".equals(info.getStatus()) ? "text-success" : "text-secondary" %>"></i>
              상태: <strong><%= info.getStatus() != null ? info.getStatus() : "-" %></strong></span>
        <% } %>
    </div>

    <!-- 증명서 카드 2종 -->
    <div class="row g-4">

        <!-- ① 성적증명서 -->
        <div class="col-md-6">
            <div class="card cert-card h-100 p-4 text-center">
                <div class="cert-icon text-success"><i class="fas fa-chart-bar"></i></div>
                <div class="cert-title">성적증명서</div>
                <div class="cert-desc">수강한 모든 과목의 중간·기말·과제 점수와<br>등급이 포함된 공식 성적 문서입니다.</div>
                <div class="d-flex justify-content-center gap-2 flex-wrap">
                    <!-- 미리보기 / 인쇄 (새 탭) -->
                    <button class="btn btn-cert-print px-3 py-2"
                            onclick="window.open('<%= contextPath %>/classroom/certPrint.bo?type=grade','_blank','width=900,height=700')">
                        <i class="fas fa-print me-1"></i>미리보기 / 인쇄
                    </button>
                </div>
            </div>
        </div>

        <!-- ② 졸업증명서 -->
        <div class="col-md-6">
            <div class="card cert-card h-100 p-4 text-center">
                <div class="cert-icon text-primary"><i class="fas fa-scroll"></i></div>
                <div class="cert-title">졸업증명서</div>
                <div class="cert-desc">재학 또는 졸업 여부를 공식적으로 확인하는<br>학적 증명 문서입니다.</div>
                <div class="d-flex justify-content-center gap-2 flex-wrap">
                    <button class="btn btn-cert-print px-3 py-2"
                            onclick="window.open('<%= contextPath %>/classroom/certPrint.bo?type=graduation','_blank','width=900,height=700')">
                        <i class="fas fa-print me-1"></i>미리보기 / 인쇄
                    </button>
                </div>
            </div>
        </div>

    </div><!-- /row -->
</div><!-- /container -->

<!-- XLS 다운로드용 숨김 iframe + 쿠키 폴링 -->
<iframe name="dlFrame" style="display:none;"></iframe>
<script>
function getCookie(name) {
    return (document.cookie.match('(^|; )' + name + '=([^;]*)') || [])[2] || '';
}
function startPolling() {
    var t = setInterval(function () {
        var s = getCookie('fileDownloadStatus');
        if (s === 'success') {
            clearInterval(t);
            document.cookie = 'fileDownloadStatus=; path=/; max-age=0';
            alert('엑셀 다운로드가 완료되었습니다.');
        } else if (s === 'fail') {
            clearInterval(t);
            document.cookie = 'fileDownloadStatus=; path=/; max-age=0';
            alert('다운로드에 실패했습니다. 성적 데이터가 없을 수 있습니다.');
        }
    }, 500);
}
</script>
</body>
</html>
