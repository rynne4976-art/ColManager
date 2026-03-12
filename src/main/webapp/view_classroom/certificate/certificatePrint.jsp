<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Vo.StudentVo, Vo.CourseVo, java.util.ArrayList, java.text.SimpleDateFormat" %>
<%--
    certificatePrint.jsp — 성적증명서 · 졸업(재학)증명서 통합 인쇄 페이지
    request attribute "certType" : "grade" | "graduation"
--%>
<%
    request.setCharacterEncoding("UTF-8");

    /* ── 공통 세션 데이터 ── */
    String studentName = (String) session.getAttribute("name");
    String studentId   = (String) session.getAttribute("student_id");

    /* ── 컨트롤러에서 넘어온 데이터 ── */
    String certType = (String) request.getAttribute("certType"); // "grade" | "graduation"
    boolean isGrade = "grade".equals(certType);

    StudentVo info = (StudentVo) request.getAttribute("studentInfo");
    @SuppressWarnings("unchecked")
    ArrayList<StudentVo> gradeList = isGrade
            ? (ArrayList<StudentVo>) request.getAttribute("gradeList")
            : null;

    /* ── 학생 개인 정보 파싱 ── */
    String majorName     = "-";
    String gradeYear     = "-";
    String status        = "-";
    String admissionDate = "-";
    boolean isGraduated  = false;

    if (info != null) {
        if (info.getCourse() != null && info.getCourse().getMajorname() != null)
            majorName = info.getCourse().getMajorname();
        gradeYear    = info.getGrade() + "학년";
        status       = info.getStatus() != null ? info.getStatus() : "-";
        isGraduated  = "졸업".equals(status);
        if (info.getAdmission_date() != null)
            admissionDate = new SimpleDateFormat("yyyy. MM. dd.").format(info.getAdmission_date());
    }

    String issuedDate = new SimpleDateFormat("yyyy년 MM월 dd일").format(new java.util.Date());

    /* ── 타입별 표시 문자열 ── */
    String titleKo, titleEn, accentColor;
    if (isGrade) {
        titleKo     = "성 적 증 명 서";
        titleEn     = "OFFICIAL ACADEMIC TRANSCRIPT";
        accentColor = "#343a40";
    } else {
        titleKo     = isGraduated ? "졸 업 증 명 서" : "재 학 증 명 서";
        titleEn     = isGraduated ? "CERTIFICATE OF GRADUATION" : "CERTIFICATE OF ENROLLMENT";
        accentColor = "#0d47a1";
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title><%= isGrade ? "성적증명서" : (isGraduated ? "졸업증명서" : "재학증명서") %></title>
<style>
    /* ── 공통 ── */
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: '맑은 고딕', 'Malgun Gothic', sans-serif;
           background: #fff; color: #212529; font-size: 13px; }
    .page-wrap { width: 740px; margin: 30px auto; padding: 50px 60px; }

    /* ── 헤더 ── */
    .cert-header { text-align: center; margin-bottom: 36px;
                   border-bottom: 3px double <%= accentColor %>; padding-bottom: 18px; }
    .cert-header h1 { font-size: 26px; font-weight: 800; letter-spacing: 6px;
                      color: <%= accentColor %>; margin-bottom: 6px; }
    .cert-header p  { font-size: 12px; color: #6c757d; letter-spacing: 2px; }

    /* ── 학생 정보 테이블 ── */
    .info-table { width: 100%; border-collapse: collapse; margin-bottom: 28px; }
    .info-table td { padding: 8px 12px; border: 1px solid #dee2e6; font-size: 12.5px; }
    .info-table td.label { width: 120px; background: #f8f9fa; font-weight: 700;
                           text-align: center; color: #495057; }

    /* ── 성적 테이블 (grade only) ── */
    .grade-table { width: 100%; border-collapse: collapse; margin-bottom: 32px; }
    .grade-table th, .grade-table td { border: 1px solid #dee2e6; padding: 8px 10px;
                                       text-align: center; font-size: 12.5px; }
    .grade-table thead th { background: #343a40; color: #fff; font-weight: 600; }
    .grade-table tbody tr:nth-child(even) { background: #f8f9fa; }
    .grade-table tfoot td { background: #e9ecef; font-weight: 700; }
    .g-A { color: #0d6efd; font-weight: 700; }
    .g-B { color: #198754; font-weight: 700; }
    .g-C { color: #fd7e14; font-weight: 700; }
    .g-D { color: #dc3545; font-weight: 700; }
    .g-F { color: #6c757d; font-weight: 700; }

    /* ── 졸업·재학 증명 본문 ── */
    .cert-body { text-align: center; margin: 40px 0; line-height: 2.4; }
    .cert-body .highlight { font-size: 16px; font-weight: 800; color: <%= accentColor %>;
                             border-bottom: 2px solid <%= accentColor %>; padding-bottom: 2px;
                             margin: 0 4px; }
    .cert-body .body-text { font-size: 14px; color: #343a40; margin-top: 20px; line-height: 2; }

    /* ── 발급 푸터 ── */
    .cert-footer { text-align: center; margin-top: 48px;
                   border-top: 1px solid #dee2e6; padding-top: 28px; }
    .cert-footer .issue-text  { font-size: 13px; margin-bottom: 8px; }
    .cert-footer .school-name { font-size: 18px; font-weight: 800; letter-spacing: 4px; margin-bottom: 6px; }
    .cert-footer .seal { display: inline-block; width: 70px; height: 70px;
                         border: 3px solid <%= isGrade ? "#343a40" : "#b22222" %>;
                         border-radius: 50%; line-height: 64px; font-size: 13px; font-weight: 700;
                         color: <%= isGrade ? "#343a40" : "#b22222" %>; margin-top: 10px; }

    /* ── 인쇄 버튼 ── */
    .print-bar { text-align: right; margin-bottom: 20px; }
    .btn-print  { background: <%= accentColor %>; color: #fff; border: none; border-radius: 6px;
                  padding: 8px 20px; font-size: 13px; cursor: pointer; }
    .btn-print:hover { opacity: .85; }

    @media print {
        .print-bar { display: none; }
        .page-wrap  { margin: 0; padding: 30px 40px; width: 100%; }
    }
</style>
</head>
<body>
<div class="page-wrap">

    <!-- 인쇄 버튼 -->
    <div class="print-bar">
        <button class="btn-print" onclick="window.print()">🖨 인쇄 / PDF 저장</button>
    </div>

    <!-- 헤더 -->
    <div class="cert-header">
        <h1><%= titleKo %></h1>
        <p><%= titleEn %></p>
    </div>

    <!-- 학생 정보 -->
    <table class="info-table">
    <% if (isGrade) { %>
        <tr>
            <td class="label">성&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명</td>
            <td><%= studentName != null ? studentName : "-" %></td>
            <td class="label">학&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;번</td>
            <td><%= studentId != null ? studentId : "-" %></td>
        </tr>
        <tr>
            <td class="label">전&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;공</td>
            <td><%= majorName %></td>
            <td class="label">학&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;년</td>
            <td><%= gradeYear %></td>
        </tr>
        <tr>
            <td class="label">재 학 상 태</td>
            <td><%= status %></td>
            <td class="label">입 학 일 자</td>
            <td><%= admissionDate %></td>
        </tr>
    <% } else { %>
        <tr>
            <td class="label">성&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명</td>
            <td><strong><%= studentName != null ? studentName : "-" %></strong></td>
        </tr>
        <tr>
            <td class="label">학&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;번</td>
            <td><%= studentId != null ? studentId : "-" %></td>
        </tr>
        <tr>
            <td class="label">전&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;공</td>
            <td><%= majorName %></td>
        </tr>
        <tr>
            <td class="label">학&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;년</td>
            <td><%= gradeYear %></td>
        </tr>
        <tr>
            <td class="label">입 학 일 자</td>
            <td><%= admissionDate %></td>
        </tr>
        <tr>
            <td class="label">학&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;적</td>
            <td>
                <%= status %>
                <span style="display:inline-block; padding:2px 10px; border-radius:12px;
                      font-size:11.5px; font-weight:700; margin-left:6px; color:#fff;
                      background:<%= isGraduated ? "#0d6efd" : "#198754" %>;">
                    <%= isGraduated ? "졸업" : "재학" %>
                </span>
            </td>
        </tr>
    <% } %>
    </table>

    <!-- ── 성적증명서 전용: 성적 목록 ── -->
    <% if (isGrade) { %>
    <table class="grade-table">
        <thead>
            <tr>
                <th>NO</th><th>과목번호</th><th>과목명</th>
                <th>중간</th><th>기말</th><th>과제</th><th>총점</th><th>등급</th>
            </tr>
        </thead>
        <tbody>
        <%
            int rowNo = 1; float totalSum = 0;
            if (gradeList != null && !gradeList.isEmpty()) {
                for (StudentVo s : gradeList) {
                    float score = s.getScore() != null ? s.getScore() : 0f;
                    score = Math.round(score * 10) / 10.0f;
                    totalSum += score;
                    String g = score>=90?"A": score>=80?"B": score>=70?"C": score>=60?"D":"F";
                    String cn = s.getCourse()!=null ? s.getCourse().getCourse_name() : "-";
                    String ci = s.getCourse()!=null ? s.getCourse().getCourse_id()   : "-";
        %>
            <tr>
                <td><%= rowNo++ %></td>
                <td><%= ci %></td>
                <td style="text-align:left;padding-left:14px;"><%= cn %></td>
                <td><%= s.getMidtest_score() %></td>
                <td><%= s.getFinaltest_score() %></td>
                <td><%= s.getAssignment_score() %></td>
                <td><%= String.format("%.1f", score) %></td>
                <td class="g-<%= g %>"><%= g %></td>
            </tr>
        <%  } } else { %>
            <tr><td colspan="8" style="color:#868e96;">성적 데이터가 없습니다.</td></tr>
        <% } %>
        </tbody>
        <% if (gradeList != null && !gradeList.isEmpty()) {
               float avg = totalSum / gradeList.size(); %>
        <tfoot>
            <tr>
                <td colspan="6" style="text-align:right;">평균 총점</td>
                <td><%= String.format("%.1f", avg) %></td>
                <td>-</td>
            </tr>
        </tfoot>
        <% } %>
    </table>
    <% } %>

    <!-- ── 졸업·재학증명서 전용: 본문 문구 ── -->
    <% if (!isGrade) {
        String bodyText = isGraduated
            ? "위 학생은 본 학사 지원 프로그램에서 정해진 과정을 모두 이수하고<br>졸업하였음을 증명합니다."
            : "위 학생은 현재 본 학사 지원 프로그램에 재학 중임을 증명합니다.";
    %>
    <div class="cert-body">
        <span class="highlight"><%= studentName %></span> 학생
        (학번: <strong><%= studentId %></strong>)은<br>
        <span class="highlight"><%= majorName %></span> 소속 <%= gradeYear %> 학생으로,<br>
        <div class="body-text"><%= bodyText %></div>
    </div>
    <% } %>

    <!-- 공통 발급 푸터 -->
    <div class="cert-footer">
        <div class="issue-text"><strong>발급일:</strong> <%= issuedDate %></div>
        <div class="issue-text" style="color:#6c757d;font-size:11.5px;">
            본 증명서는 정보시스템에 의해 발급된 공식 문서입니다.
        </div>
        <div class="school-name">학사 지원 프로그램</div>
        <div class="seal">직&nbsp;인</div>
    </div>

</div><!-- /page-wrap -->
</body>
</html>
