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
	        background-color: #f4f6f9 !important;
	    }
	
		.student-classroom-wrap {
		    max-width: 1300px;
		    margin: 0 auto;
		    padding: 0 16px;
		}
		
		.student-classroom-wrap .row {
		    --bs-gutter-x: 1.75rem;
		}
		
	
	    /* 상단 제목은 유지하고 아래 카드들만 다듬기 */
	    header.mb-4.text-center {
	        margin-bottom: 28px !important;
	    }
	
	    header.mb-4.text-center h1 {
	        font-weight: 800;
	        color: #222;
	    }
	
	    header.mb-4.text-center p {
	        font-size: 1rem;
	        color: #6c757d !important;
	    }
	
	    /* 시간표 영역 */
	    .student-timetable-panel,
	    .summary-card {
	        background: rgba(255,255,255,0.92);
	        border: 1px solid rgba(148, 163, 184, 0.18);
	        border-radius: 18px;
	        box-shadow: 0 10px 24px rgba(15, 23, 42, 0.07);
	        overflow: hidden;
	    }
	
	    .student-timetable-panel {
	        padding: 22px 22px 18px;
	        height: 100%;
	    }
	
	    .student-timetable-panel .mini-timetable-card {
	        width: 100%;
	        max-width: 100%;
	        margin: 0;
	        background: transparent !important;
	        box-shadow: none !important;
	        border: none !important;
	    }
	
	    .student-timetable-panel .mini-timetable-header {
	        margin-bottom: 16px;
	    }
	
	    .student-timetable-panel .mini-timetable-header h3 {
	        font-size: 2rem;
	        font-weight: 800;
	        color: #1f2937;
	        margin-bottom: 0;
	    }
	
	    .student-timetable-panel .mini-timetable-more {
	        padding: 9px 16px;
	        font-size: 0.95rem;
	        border-radius: 10px;
	        border: none;
	        background: linear-gradient(135deg, #3b82f6, #1e40af);
	        color: #fff;
	        font-weight: 700;
	    }
	
	    /* 시간표 테이블 */
	    .student-timetable-panel .mini-timetable-table {
	        overflow: hidden;
	        border-radius: 14px;
	        margin-bottom: 0;
	    }
	
	    .student-timetable-panel .mini-timetable-table th {
	        background-color: #edf3ff !important;
	        color: #2446b6 !important;
	        font-weight: 700;
	        text-align: center;
	        border: 1px solid #d8e3f3 !important;
	    }
	
	    .student-timetable-panel .mini-timetable-table td {
	        background: #fff;
	        border: 1px solid #dee2e6 !important;
	        text-align: center;
	        vertical-align: middle;
	        height: 78px;
	        font-size: 16px;
	        color: #222;
	    }
	
	    .student-timetable-panel .mini-subject {
	        font-size: 15px;
	        font-weight: 600;
	        color: #1f2937;
	    }
	
	    .student-timetable-panel .mini-period-col {
	        width: 64px;
	        font-size: 15px;
	        font-weight: 700;
	        background: #f8fafc;
	    }
	
	    /* 오른쪽 카드 */
	    .summary-card .card-header {
	        padding: 16px 20px;
	        border-bottom: 1px solid #e5e7eb;
	        background: transparent;
	    }
	
	    .summary-card .card-header h2 {
	        font-weight: 800;
	        font-size: 1.5rem;
	        margin: 0;
	        color: #1f2937;
	    }
	
	    .summary-card .card-body {
	        padding: 18px 20px;
	    }
	
	    .summary-list {
	        list-style: none;
	        margin: 0;
	        padding: 0;
	    }
	
	    .summary-item {
	        padding: 14px 0;
	        border-bottom: 1px solid #edf1f5;
	    }
	
	    .summary-item:last-child {
	        border-bottom: none;
	    }
	
	    .summary-title {
	        font-weight: 700;
	        font-size: 1rem;
	        color: #222;
	        margin-bottom: 4px;
	    }
	
	    .summary-course {
	        font-size: 0.9rem;
	        color: #6b7280;
	        margin-bottom: 4px;
	    }
	
	    .summary-date {
	        font-size: 0.84rem;
	        color: #94a3b8;
	    }
	
	    .summary-empty {
	        color: #888;
	        text-align: center;
	        padding: 20px 0;
	        font-size: 0.95rem;
	    }
	
	    @media (max-width: 991px) {
	        .student-timetable-panel .mini-timetable-header h3 {
	            font-size: 1.6rem;
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
	    
	    .student-timetable-panel {
		    padding: 28px 28px 20px 36px;
		}
	    
	    /* 중앙 영역 좌측 여백 추가 */
		#layoutSidenav_content {
		    padding: 28px 32px !important;
		}
		
		/* ========================= */
		/* 버튼 통일 */
		/* ========================= */
		.btn {
		    border-radius: 10px !important;
		    font-weight: 600;
		    padding: 8px 16px;
		}
		
		/* primary */
		.btn-primary {
		    background: linear-gradient(135deg, #3b82f6, #1e40af) !important;
		    border: none !important;
		    color: #fff !important;
		}
		
		.btn-primary:hover {
		    filter: brightness(0.95);
		}
		
		/* secondary */
		.btn-secondary {
		    background: #e9ecef !important;
		    border: none !important;
		    color: #333 !important;
		}
		
		.btn-secondary:hover {
		    background: #dee2e6 !important;
		}
		
		/* outline */
		.btn-outline-primary {
		    border: 1px solid #3b82f6 !important;
		    color: #3b82f6 !important;
		}
		
		.btn-outline-primary:hover {
		    background: #3b82f6 !important;
		    color: #fff !important;
		}
		
		.card,
		.student-timetable-panel,
		.summary-card {
		    box-shadow: 0 10px 25px rgba(0,0,0,0.08) !important;
		}
		
		.card-header,
		.summary-card .card-header {
		    font-size: 1.3rem;
		    font-weight: 800;
		    color: #1f2937;
		}
		.summary-card .card-header h2 {
		    border-left: 4px solid #3b82f6;
		    padding-left: 10px;
		}
		.student-timetable-panel .mini-timetable-header h3 {
		    border-left: 4px solid #3b82f6;
		    padding-left: 10px;
		}
		.mini-timetable-table tbody tr:hover {
		    background-color: #f1f5f9;
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