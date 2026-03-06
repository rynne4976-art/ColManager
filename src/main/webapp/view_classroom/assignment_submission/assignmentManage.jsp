<%@page import="java.net.URLDecoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
    request.setCharacterEncoding("UTF-8");
    String contextPath = request.getContextPath();
    String course_id = (String) request.getParameter("courseId");
    String role = (String)session.getAttribute("role");
    
	String message = (String) request.getAttribute("message");
	if (message != null) {
		message = URLDecoder.decode(message, "UTF-8");
	}
    	
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="0">
<title>과제 관리</title>

<script>
    $(document).ready(function() {
    	
    	var role = "<%= role %>";
    	const message = '<%= message != null ? message : "" %>';
        if (message) {
            alert(message);
            // 메시지를 출력한 후 히스토리 상태를 초기화
            history.replaceState(null, null, location.href);
        }

        //-------------
        // 과제 조회 탭에서 AJAX로 데이터 불러오기
        $.ajax({
            url: '<%= contextPath %>/assign/assignmentSearch.do',
            method: 'GET',
            data: { courseId: '<%= course_id %>' },
            dataType: 'json',
            success: function(assignmentList) {
                var tbody = $('#assignmentTable tbody');
                tbody.empty(); // 테이블 본문 초기화

                if (assignmentList && assignmentList.length > 0) {
                	
	                assignmentList.forEach(function(assignment) {

	                    var now = new Date(); // 현재 날짜
	                    var startDate = new Date(assignment.startDate); // 시작 날짜
	                    var endDate = new Date(assignment.endDate); // 종료 날짜
	                	
		                var row = '<tr data-id="' + assignment.assignmentId + '">' +
						                '<td class="editable editable-title">' + assignment.title + '</td>' +
						                '<td class="editable editable-date">' + 
						                	assignment.startDate.substring(0, assignment.startDate.lastIndexOf(".")) + ' ~ ' + assignment.endDate.substring(0, assignment.startDate.lastIndexOf(".")) +
						                '</td>' +
						                '<td class="editable editable-description">' + assignment.description + '</td>';
					if(role === "교수") {
						    	row += '<td>' +
									    	'<div class="d-flex gap-2 justify-content-center">' +
										        '<button class="btn btn-outline-primary btn-sm edit-btn">수정</button>' +
										        '<button class="btn btn-outline-success btn-sm complete-btn" style="display:none;">완료</button>' +
										        '<button class="btn btn-outline-secondary btn-sm cancel-btn" style="display:none;">취소</button>' +
										        '<button class="btn btn-outline-danger btn-sm delete-btn">삭제</button>' +
										        '<button class="btn btn-outline-success btn-sm view-btn">제출물 보기</button>' +
										    '</div>' +
						           	   '</td>' +
						           '</tr>';
                	} else {
                		
                		// 학생 역할에 따라 제출 버튼 처리
                        if (now >= startDate && now <= endDate) {
	                            row += '<td>' +
			                                '<button class="btn btn-sm btn-success submission-btn" data-id="' + assignment.assignmentId + 
			                                '" data-title="' + encodeURIComponent(assignment.title) + '">과제 제출</button>' +
			                            '</td>';
                        } else {
	                            row += '<td>' +
			                                '<button class="btn btn-sm btn-secondary disabled-btn" disabled>제출 기간 아님</button>' +
			                            '</td>';
                        }
                	}
	                        tbody.append(row);
	                    });
                } else {
                    var emptyRow = '<tr><td colspan="4">등록된 과제가 없습니다.</td></tr>';
                    tbody.append(emptyRow);
                }
            },
            error: function(error) {
                console.error('Error fetching course list:', error);
            }
        });
    });
    
    //-------------
    // 과제 제출 클릭 시
    // 이벤트 리스너 추가
	$(document).on('click', '.submission-btn', function() {
	    var assignmentId = $(this).data('id'); // 과제 ID 가져오기
	    var assignmentTitle = $(this).data('title'); // 과제 제목 가져오기
	    var courseId = '<%= course_id %>';
	
	    // 동적으로 폼 생성
	    let form = $('<form></form>'); // jQuery를 이용한 폼 생성
	    form.attr('action', '<%= contextPath %>/submit/submitAssignmentPage.bo'); // 요청 URL 설정
	    form.attr('method', 'POST'); // POST 방식 설정

	    // assignmentId 숨겨진 필드 추가
	    form.append('<input type="hidden" name="assignmentId" value="' + assignmentId + '">');
	    // assignmentTitle 숨겨진 필드 추가
	    form.append('<input type="hidden" name="assignmentTitle" value="' + assignmentTitle + '">');
	    // courseId 숨겨진 필드 추가
	    form.append('<input type="hidden" name="courseId" value="' + courseId + '">');
	    // 폼을 body에 추가
	    $('body').append(form);

	    // 폼 제출
	    form.submit();
	});
    
    //-------------
 	// 수정 버튼 클릭 시
	$(document).on('click', '.edit-btn', function () {
	    var row = $(this).closest('tr'); // 현재 행 가져오기
	
	    // 기존 값 저장 (data 속성에 저장)
	    row.find('.editable').each(function () {
	        var cell = $(this);
	        cell.data('original-value', cell.text()); // 기존 값을 저장
	        var value = cell.text();
	
	        // 시작 날짜와 마감 날짜는 date picker 두 개로 변환
	        if (cell.hasClass('editable-date')) {
	            cell.html(
	            	'<div style="display: flex; align-items: center; gap: 10px; justify-content: center;">' +
	                    '<input type="date" name="startDate" class="form-control start-date" style="width: 150px;">' +
	                    '<span>~</span>' +
	                    '<input type="date" name="endDate" class="form-control end-date" style="width: 150px;">' +
	                '</div>'
	            );
	        } else {
	            cell.html('<input type="text" class="form-control" value="' + value + '">');
	        }
	    });
	
	    // 모든 버튼 숨기기
	    row.find('.edit-btn, .delete-btn, .view-btn').hide();
	
	    // 완료/취소 버튼 표시
	    row.find('.complete-btn, .cancel-btn').show();
	});


    //-------------
    // 완료 버튼 클릭 시
	$(document).on('click', '.complete-btn', function () {
	    var row = $(this).closest('tr'); // 현재 행 가져오기
	    var assignmentId = row.data('id'); // 데이터 ID
	    var title = row.find('.editable-title input').val();
	    var description = row.find('.editable-description input').val();
	    var startDate = row.find('.start-date').val(); // 시작 날짜
	    var endDate = row.find('.end-date').val();     // 마감 날짜

	    // AJAX로 수정 요청 보내기
	    $.ajax({
	        url: '<%= contextPath %>/assign/updateAssignment.do',
	        method: 'POST',
	        data: {
	            courseId: '<%= course_id %>',
	            assignmentId: assignmentId,
	            title: title,
	            description: description,
	            startDate: startDate,
	            endDate: endDate
	        },
	        success: function (response) {
	            if (response === 'success') {
	                alert('수정이 완료되었습니다.');
	
	                // 입력 필드를 다시 텍스트로 변경
	                row.find('.editable-title').html(title);
	                row.find('.editable-description').html(description);
	                row.find('.editable-date').html(
	                        startDate + ' 00:00:00' + ' ~ ' + endDate + ' 23:59:59'
	                    );
	                // 완료/취소 버튼 숨기기
	                row.find('.complete-btn, .cancel-btn').hide();
	
	                // 수정, 삭제, 제출물확인 버튼 다시 표시
	                row.find('.edit-btn, .delete-btn, .view-btn').show();
	            } else {
	                alert('수정에 실패했습니다. 다시 시도해주세요.');
	            }
	        },
	        error: function (error) {
	            alert('수정 요청 중 오류가 발생했습니다.');
	            console.error(error);
	        }
	    });
	});

    //-------------
    // 취소 버튼 클릭 시
	$(document).on('click', '.cancel-btn', function () {
	    var row = $(this).closest('tr'); // 현재 행 가져오기
	
	    // 저장된 기존 값으로 복원
	    row.find('.editable').each(function () {
	        var cell = $(this);
	        var originalValue = cell.data('original-value'); // 저장된 기존 값
	        cell.html(originalValue); // 기존 값으로 복원
	    });
	
	    // 완료/취소 버튼 숨기기
	    row.find('.complete-btn, .cancel-btn').hide();
	
	    // 기본 버튼 다시 표시
	    row.find('.edit-btn, .delete-btn, .view-btn').show();
	});

 
    //-----------
 	// 제출물 보기 버튼 클릭 시
    $(document).on('click', '.view-btn', function () {
	    console.log('제출물 보기 버튼 클릭됨');
	    var assignmentId = $(this).closest('tr').data('id'); // 과제 ID 가져오기
	    var courseId = '<%= course_id %>';
	    var assignmentTitle = $(this).closest('tr').find('.editable-title').text(); // 제목 가져오기
	
	    // 동적으로 폼 생성
	    let form = $('<form></form>'); // jQuery를 이용한 폼 생성
	    form.attr('action', '<%=contextPath%>/assign/confirmSubmit.bo'); // 요청 URL 설정
	    form.attr('method', 'POST'); // POST 방식 설정

	    // assignmentId 숨겨진 필드 추가
	    form.append('<input type="hidden" name="assignmentId" value="' + assignmentId + '">');
	    // assignmentTitle 숨겨진 필드 추가
	    form.append('<input type="hidden" name="courseId" value="' + encodeURIComponent(assignmentTitle) + '">');
	    // courseId 숨겨진 필드 추가
	    form.append('<input type="hidden" name="courseId" value="' + courseId + '">');
	    // 폼을 body에 추가
	    $('body').append(form);

	    // 폼 제출
	    form.submit();
	    
	 });

    //-------------
 	// 과제 삭제 POST 요청
    $(document).on('click', '.delete-btn', function () {
    	if (confirm("삭제하시겠습니까?")) {
    	    var assignmentId = $(this).closest('tr').data('id'); // 과제 ID 가져오기
    	    var courseId = '<%= course_id %>';
    	    // 동적으로 폼 생성
    	    let form = $('<form></form>'); // jQuery를 이용한 폼 생성
    	    form.attr('action', '<%= contextPath %>/assign/deleteAssignment.do'); // 요청 URL 설정
    	    form.attr('method', 'POST'); // POST 방식 설정

    	    // assignmentId 숨겨진 필드 추가
    	    form.append('<input type="hidden" name="assignmentId" value="' + assignmentId + '">');
    	    // courseId 숨겨진 필드 추가
    	    form.append('<input type="hidden" name="courseId" value="' + courseId + '">');
    	    // 폼을 body에 추가
    	    $('body').append(form);

    	    // 폼 제출
    	    form.submit();
    	}

    });
    
    
</script>
</head>
<body>
<div class="container mt-5">
    <!-- 페이지 헤더 -->
    <div class="text-center mb-4">
        <h1 class="display-4"><i class="fas fa-tasks"></i> 과제 관리</h1>
        <p class="lead">과제를 조회하거나 새로 등록할 수 있습니다.</p>
    </div>
    
    <!-- 탭 -->
    <ul class="nav nav-tabs" id="assignmentTabs" role="tablist">
        <li class="nav-item">
            <button class="nav-link active" id="assignment-list-tab" data-bs-toggle="tab" data-bs-target="#assignment-list" type="button" role="tab" aria-controls="assignment-list" aria-selected="true">과제 조회</button>
        </li>
        <% if ("교수".equals(role)) { %>
        <li class="nav-item">
            <button class="nav-link" id="assignment-create-tab" data-bs-toggle="tab" data-bs-target="#assignment-create" type="button" role="tab" aria-controls="assignment-create" aria-selected="false">과제 등록</button>
        </li>
        <% } %>
    </ul>

    <!-- 탭 내용 -->
    <div class="tab-content mt-4" id="assignmentTabsContent">
        <!-- 과제 조회 -->
        <div class="tab-pane fade show active" id="assignment-list" role="tabpanel" aria-labelledby="assignment-list-tab">
            <div class="card shadow-lg p-4">
                <table id="assignmentTable" class="table table-bordered text-center">
                    <thead class="table-success">
                        <tr>
                            <th>과제 제목</th>
                            <th>제출 가능 기간</th>
                            <th>설명</th>
                            <th>관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- AJAX로 데이터가 동적으로 추가됨 -->
                    </tbody>
                </table>
            </div>
        </div>

        <!-- 과제 등록 -->
        <% if ("교수".equals(role)) { %>
        <div class="tab-pane fade" id="assignment-create" role="tabpanel" aria-labelledby="assignment-create-tab">
            <div class="card shadow-lg p-4">
                <form method="post" action="<%= contextPath %>/assign/createAssignment.do">
                    <div class="mb-3">
                        <label for="title" class="form-label"><i class="fas fa-heading"></i> 제목</label>
                        <input type="text" name="title" id="title" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label for="description" class="form-label"><i class="fas fa-align-left"></i> 설명</label>
                        <textarea name="description" id="description" class="form-control" rows="3" required></textarea>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="startDate" class="form-label"><i class="fas fa-calendar-alt"></i> 시작 날짜</label>
                            <input type="date" name="startDate" id="startDate" class="form-control" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="endDate" class="form-label"><i class="fas fa-calendar-check"></i> 마감 날짜</label>
                            <input type="date" name="endDate" id="endDate" class="form-control" required>
                        </div>
                    </div>
                    <input type="hidden" name="courseId" value="<%= course_id %>">
                    <div class="d-grid">
                        <button type="submit" class="btn btn-primary btn-lg"><i class="fas fa-save"></i> 등록</button>
                    </div>
                </form>
            </div>
        </div>
        <% } %>
    </div>
</div>


</body>
</html>
