<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%> 

<%
	request.setCharacterEncoding("UTF-8");
	String contextPath = request.getContextPath();
	String role = (String) session.getAttribute("role");
	String name = (String) session.getAttribute("name");

%>    

    
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <meta name="description" content="" />
        <meta name="author" content="" />
        <title>강의실 메인 페이지</title>
        <link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet" />
        <link href="<%=contextPath %>/css/classroom_styles.css" rel="stylesheet" />
        <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js"></script>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script> <!-- jQuery 추가 -->
        <script>
        $(document).ready(function() {
        	// JSP에서 JavaScript 변수로 role 전달
            var role = "<%= role != null ? role : "" %>";

            // AJAX 요청
            var ajaxUrl = role === "교수" 
                ? "<%=contextPath%>/classroom/courseNameSearch.do"
                : "<%=contextPath%>/classroom/studentCourseSearch.do";
            $.ajax({
                url: ajaxUrl,
                method: 'GET',
                dataType: 'json',
                success: function(courseList) {
                	
                    if (courseList && courseList.length > 0) {
                        let courseIndex = 1;
                        courseList.forEach(course => {

                        	// 강의 ID를 포함한 링크로 수정
                            let courseHtml = 
                            	'<a class="nav-link collapsed" href="#" data-bs-toggle="collapse" data-bs-target="#collapseCourse' + courseIndex + '" aria-expanded="false" aria-controls="collapseCourse' + courseIndex + '" >' +
	                                '<div class="sb-nav-link-icon"><i class="fas fa-columns"></i></div>' +
	                                course.courseName + ' <!-- 강의 이름 표시 -->' +
	                                '<div class="sb-sidenav-collapse-arrow"><i class="fas fa-angle-down"></i></div>' +

	                            '</a>' +
	                            '<div class="collapse" id="collapseCourse' + courseIndex + '" aria-labelledby="headingCourse' + courseIndex + '" data-bs-parent="#sidenavAccordion">' +
	                                '<nav class="sb-sidenav-menu-nested nav">' +
	                                    '<a class="nav-link" href="#" onclick="submitAssignmentForm(\'' + course.courseId + '\')">과제</a>' +
	                                    '<a class="nav-link" href="#" onclick="submitMaterialForm(\'' + course.courseId + '\')">공지사항</a>' +
	                                '</nav>' +
	                             '</div>';

							$('#courseTargetElement').append(courseHtml);

                            courseIndex++;
                        });
                    }
                },
                error: function(error) {
                    console.error('Error fetching course list:', error);
                }
            });
        });
        
        // 과제 페이지에 대한 GET 요청
        function submitAssignmentForm(courseId) {
            let form = $('<form></form>');
            form.attr('action', '<%=contextPath%>/assign/assignmentManage.bo');
            form.attr('method', 'POST');
            form.append('<input type="hidden" name="center" value="/view_classroom/assignment_submission/assignmentManage.jsp">');
            form.append('<input type="hidden" name="courseId" value="' + courseId + '">');
            $('body').append(form);
            form.submit();
        }

        // 공지사항 페이지에 대한 GET 요청
        function submitMaterialForm(courseId) {
            let form = $('<form></form>');
            form.attr('action', '<%=contextPath%>/classroomboard/noticeList.bo');
            form.attr('method', 'GET');
            form.append('<input type="hidden" name="center" value="/view_classroom/assignment_notice/professorNotice.jsp">');
            form.append('<input type="hidden" name="courseId" value="' + courseId + '">');
            $('body').append(form);
            form.submit();
        }
        
        </script>
    </head>
    <body class="sb-nav-fixed">
        <!-- 상단 네비게이션 -->
    <nav class="sb-topnav navbar navbar-expand navbar-dark bg-dark">
         <button class="btn btn-link btn-sm order-1 order-lg-0 me-4 me-lg-0" id="sidebarToggle" href="#!">
            <i class="fas fa-bars"></i>
        </button>
        
        <% if(role.equals("교수")){ %>
        	<a class="navbar-brand ps-3" href="<%=contextPath %>/classroom/classroom.bo?classroomCenter=professorMyCourse.jsp">강의실</a>
        <% }else{ %>
    		<a class="navbar-brand ps-3" href="<%=contextPath %>/classroom/allAssignNotice.do">강의실</a>
        <% } %>
        
        <ul class="navbar-nav ms-auto d-flex align-items-center">
            <li class="nav-item">
                <p class="text-white mb-0 me-3">반갑습니다. <%=name %> <%=role %>님!</p>
            </li>
            <li class="nav-item">
			    <!-- 강의실 나가기 버튼 -->
			     <button class="btn btn-light me-2" onclick="location.href='<%=contextPath%>/member/main.bo'">
			        <i class="fas fa-door-open"></i> 강의실 나가기
			    </button>
			</li>
			<li class="nav-item">
			    <!-- 로그아웃 버튼 -->
			    <%-- 
			    <button class="btn btn-danger" onclick="location.href='<%=contextPath%>/member/logout.me'">
			        <i class="fas fa-sign-out-alt"></i> 로그아웃
			    </button>
			     --%>
			</li>

        </ul>
    </nav>
        <div id="layoutSidenav">
            <div id="layoutSidenav_nav">
                <nav class="sb-sidenav accordion sb-sidenav-dark" id="sidenavAccordion">
                    <div class="sb-sidenav-menu">
                        <div class="nav">
 

					<%	if(role.equals("교수")) { %>
							
                        	<!-- 사이드바 수강관리 영역 -->
                            <div class="sb-sidenav-menu-heading">Course Manage</div>
                            <a class="nav-link collapsed" href="#" data-bs-toggle="collapse" data-bs-target="#collapseLayouts" aria-expanded="false" aria-controls="collapseLayouts">
                                <div class="sb-nav-link-icon"><i class="fas fa-columns"></i></div>
                                수강 관리
                                <div class="sb-sidenav-collapse-arrow"><i class="fas fa-angle-down"></i></div>
                            </a>
                            <div class="collapse" id="collapseLayouts" aria-labelledby="headingOne" data-bs-parent="#sidenavAccordion">
                                <nav class="sb-sidenav-menu-nested nav">
                                    <a class="nav-link" href="<%=contextPath%>/classroom/course_register.bo">수강 등록</a>
                                    <a class="nav-link" href="<%=contextPath%>/classroom/course_search.bo?center=/view_classroom/courseSearch.jsp">수강 조회(수정/삭제)</a>
                                </nav>
                            </div>
							
							<!-- 사이드바 나의 수업 영역 -->
							<div class="sb-sidenav-menu-heading">My Courses</div>
							<!-- AJAX로 동적 생성되는 강의 목록 -->
                            <div id="courseTargetElement"></div>
                            
                            <!-- 사이드바 성적 조회 영역 -->
                            <div class="sb-sidenav-menu-heading">SCORE</div>
                            <a class="nav-link" href="<%=contextPath%>/classroom/course_search.bo?center=/view_classroom/courseList.jsp">
                                <div class="sb-nav-link-icon"><i class="fas fa-chart-area"></i></div>
                                성적 관리
                            </a>
                            
                            <!-- 사이드바 강의 평가 영역 -->
                            <a class="nav-link" href="<%=contextPath%>/professor/evaluationList.bo">
    							<div class="sb-nav-link-icon"><i class="fas fa-star"></i></div>
   			 					강의 평가
							</a>
                            
                            
					<%	} else { %>
                            <!-- 사이드바 수강신청 영역 -->
                            <div class="sb-sidenav-menu-heading">Course Registration</div>
                            <a class="nav-link" href="<%=contextPath%>/classroom/course_submit.bo?classroomCenter=/view_classroom/courseSubmit.jsp">
                                <div class="sb-nav-link-icon"><i class="fas fa-tachometer-alt"></i></div>
                                수강신청
                            </a>
                            
                            <!-- 사이드바 나의 수업 영역 -->
                            <div class="sb-sidenav-menu-heading">My Course</div>
                            <div id="courseTargetElement"></div>
                            
                            <!-- 사이드바 성적 조회 영역 -->
                            <div class="sb-sidenav-menu-heading">SCORE</div>
                            <a class="nav-link" href="<%=contextPath%>/classroom/grade_search.bo?classroomCenter=/view_classroom/gradeList.jsp">
                                <div class="sb-nav-link-icon"><i class="fas fa-chart-area"></i></div>
                                성적 조회
                            </a>
                            
                            <!-- 강의 평가 항목 추가 -->
                            <a class="nav-link" href="<%=contextPath%>/student/evaluationRegister.do">
                                <div class="sb-nav-link-icon"><i class="fas fa-star"></i></div>
                                강의 평가
                            </a>
                    <%	} %> 
                        </div>
                    </div>
                </nav>
            </div>
            
<%
		String classroomCenter = (String)request.getAttribute("classroomCenter");
%>
            <!-- 중앙 콘텐츠 영역 -->
            <div id="layoutSidenav_content">
                <jsp:include page="<%= classroomCenter %>"/>  
            </div>
            
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
        <script src="../js/scripts.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.8.0/Chart.min.js" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/umd/simple-datatables.min.js" crossorigin="anonymous"></script>
        <script src="../js/datatables-simple-demo.js"></script>
    </body>
</html>