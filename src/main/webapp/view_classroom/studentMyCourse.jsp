<%@page import="Vo.BoardVo"%>
<%@page import="Vo.AssignmentVo"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");
    Map<String, List> allAssignNotice = (Map<String, List>) request.getAttribute("allAssignNotice");
    String contextPath = request.getContextPath();
    String studentId = (String) session.getAttribute("student_id");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>학생 강의실</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>

    <style>
        body.bg-light {
            background-color: #f8f9fb !important;
        }

        h1.display-4 {
            color: #4CAF50;
        }

        .student-classroom-wrap {
            max-width: 1500px;
        }

        .student-timetable-panel {
            background: #fff;
            border-radius: 16px;
            padding: 18px 20px;
            box-shadow: 0 6px 18px rgba(0,0,0,0.08);
            height: 100%;
        }

        .student-timetable-panel .mini-timetable-card {
            width: 100%;
            max-width: 100%;
            margin: 0;
        }

        .student-timetable-panel .mini-timetable-header h3 {
            font-size: 1.8rem;
        }

        .student-timetable-panel .mini-timetable-more {
            padding: 8px 16px;
            font-size: 0.95rem;
        }

        .student-timetable-panel .mini-timetable-table th,
        .student-timetable-panel .mini-timetable-table td {
            height: 78px;
            font-size: 16px;
        }

        .student-timetable-panel .mini-subject {
            font-size: 15px;
        }

        .student-timetable-panel .mini-period-col {
            width: 64px;
            font-size: 15px;
        }

        .summary-card {
            border: none;
            border-radius: 16px;
            box-shadow: 0 6px 18px rgba(0,0,0,0.08);
            overflow: hidden;
        }

        .summary-card .card-header {
            font-weight: 700;
            padding: 14px 18px;
        }

        .summary-card .card-body {
            padding: 16px 18px;
        }

        .assignment-summary .card-header {
            background-color: #e8f5e9;
            color: #1b5e20;
        }

        .notice-summary .card-header {
            background-color: #e3f2fd;
            color: #0d47a1;
        }

        .summary-list {
            list-style: none;
            margin: 0;
            padding: 0;
        }

        .summary-item {
            padding: 12px 0;
            border-bottom: 1px solid #edf1f5;
        }

        .summary-item:last-child {
            border-bottom: none;
        }

        .summary-title {
            font-weight: 700;
            font-size: 0.98rem;
            color: #222;
            margin-bottom: 4px;
        }

        .summary-course {
            font-size: 0.87rem;
            color: #6c757d;
            margin-bottom: 4px;
        }

        .summary-date {
            font-size: 0.82rem;
            color: #8a94a6;
        }

        .summary-empty {
            color: #888;
            text-align: center;
            padding: 16px 0;
            font-size: 0.95rem;
        }

        @media (max-width: 991px) {
            .student-timetable-panel .mini-timetable-header h3 {
                font-size: 1.5rem;
            }

            .student-timetable-panel .mini-timetable-table th,
            .student-timetable-panel .mini-timetable-table td {
                height: 68px;
                font-size: 14px;
            }

            .student-timetable-panel .mini-subject {
                font-size: 14px;
            }
        }
    </style>
</head>
<body class="bg-light">
<div class="container my-4 student-classroom-wrap">

    <header class="mb-4 text-center">
        <h1 class="display-4">
            <i class="fas fa-chalkboard-teacher"></i> 학생 강의실
        </h1>
        <p class="text-secondary">시간표, 과제, 공지사항을 한눈에 확인하세요.</p>
    </header>

<%
    if (allAssignNotice != null && !allAssignNotice.isEmpty()) {
        List assignments = allAssignNotice.get("assignments");
        List notices = allAssignNotice.get("notices");
%>

    <div class="row g-4">
        <!-- 왼쪽: 시간표 -->
        <div class="col-lg-8">
            <div class="student-timetable-panel">
                <jsp:include page="/view_student/studentTimetableMini.jsp"/>
            </div>
        </div>

        <!-- 오른쪽: 과제 + 공지 -->
        <div class="col-lg-4">
            <div class="d-flex flex-column gap-4">
            
                <!-- 과제 -->
                <div class="card summary-card assignment-summary">
                    <div class="card-header">
                        <h2 class="h5 mb-0">
                            <i class="fas fa-tasks"></i> 과제
                        </h2>
                    </div>
                    <div class="card-body">
                        <ul class="summary-list">
<%
            if (assignments != null && !assignments.isEmpty()) {
                int count = 0;
                for (Object obj : assignments) {
                    if (count == 4) break;
                    AssignmentVo assignment = (AssignmentVo) obj;
%>
                            <li class="summary-item">
                                <div class="summary-title"><%= assignment.getTitle() %></div>
                                <div class="summary-course"><%= assignment.getCourse().getCourse_name() %></div>
                                <div class="summary-date">
                                    마감일:
                                    <%= assignment.getPeriod().getEndDate().toString().substring(0, assignment.getPeriod().getEndDate().toString().lastIndexOf(".")) %>
                                </div>
                            </li>
<%
                    count++;
                }
            } else {
%>
                            <li class="summary-empty">등록된 과제가 없습니다.</li>
<%
            }
%>
                        </ul>

                    </div>
                </div>

                <!-- 공지 -->
                <div class="card summary-card notice-summary">
                    <div class="card-header">
                        <h2 class="h5 mb-0">
                            <i class="fas fa-bullhorn"></i> 공지
                        </h2>
                    </div>
                    <div class="card-body">
                        <ul class="summary-list">
<%
            if (notices != null && !notices.isEmpty()) {
                int count = 0;
                for (Object obj : notices) {
                    if (count == 4) break;
                    BoardVo notice = (BoardVo) obj;
%>
                            <li class="summary-item">
                                <div class="summary-title"><%= notice.getTitle() %></div>
                                <div class="summary-course">공지사항</div>
                                <div class="summary-date">작성일: <%= notice.getCreated_date() %></div>
                            </li>
<%
                    count++;
                }
            } else {
%>
                            <li class="summary-empty">등록된 공지사항이 없습니다.</li>
<%
            }
%>
                        </ul>

                    </div>
                </div>

            </div>
        </div>
    </div>

<%
    } else {
%>
    <div class="alert alert-info text-center">
        <i class="fas fa-info-circle"></i> 데이터가 없습니다.
    </div>
<%
    }
%>
</div>

<script type="text/javascript">
    function chatWinOpen() {
        var width = 395;
        var height = 445;

        var left = window.screen.availWidth - width - 120;
        var top = window.screen.availHeight - height - 150;

        var popup = window.open(
            "<%=contextPath%>/common/ChatWindow.jsp",
            "ChatWindow",
            "width=" + width + ",height=" + height + ",left=" + left + ",top=" + top + ",resizable=no,scrollbars=no"
        );

        if (!popup || popup.closed || typeof popup.closed === 'undefined') {
            alert("팝업 차단이 활성화되어 있습니다. 팝업 차단을 해제하고 다시 시도해주세요.");
        }
    }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>