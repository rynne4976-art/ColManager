<%@page import="java.net.URLDecoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
	request.setCharacterEncoding("UTF-8");

    String contextPath = request.getContextPath();
	String assignment_title = (String)request.getAttribute("assignment_title");
	String assignmentId = (String)request.getAttribute("assignmentId");
	String courseId = (String)request.getAttribute("courseId");
	System.out.println(courseId);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>과제 제출</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<%
	String message = (String) request.getAttribute("message");
	if (message != null) {
    	message = URLDecoder.decode(message, "UTF-8");
%>
        <script>
            alert('<%= message %>'); // 메시지를 알림으로 표시
        </script>
<%
    }
%>
	<style>
        .btn-disabled {
            background-color: #d6d6d6;
            color: #6c757d;
            cursor: not-allowed;
        }
        .back-icon {
            position: absolute;
            top: 20px;
            left: 20px;
            font-size: 1.5rem;
            color: #007bff;
            cursor: pointer;
        }
        .back-icon:hover {
            color: #0056b3;
        }
    </style>
<script>
    $(document).ready(function() {
        const submitButton = $('#assignmentUploadForm button[type="submit"]'); // 제출 버튼

        $.ajax({
            url: '<%=contextPath%>/submit/getSubmittedAssignments.do',
            method: 'GET',
            data: {
                assignmentId: '<%=assignmentId%>'
            },
            dataType: 'json',
            success: function(response) {
                if (response) { // 응답 객체가 존재할 경우
                    // 제출 버튼 비활성화 및 색상/텍스트 변경
                    submitButton.prop('disabled', true).removeClass('btn-primary').addClass('btn-secondary').text('이미 제출됨');

                    // 다운로드 버튼 URL 생성
                    const downloadUrl = '<%=contextPath%>/submit/downloadAssignment.do?fileId=' + response.fileId;

                    // 제출 시간에서 .0 제거
                    const submittedDate = response.submittedDate.split(".")[0];

                    $('#submittedAssignments').append(
                        '<tr>' +
                            '<td>' + '<%=assignment_title%>' + '</td>' +
                            '<td>' + response.originalName + '</td>' +
                            '<td>' + submittedDate + '</td>' +
                            '<td><a href="' + downloadUrl + '" class="btn btn-outline-primary btn-sm"><i class="fas fa-download"></i> 다운로드</a></td>' +
                            '<td><button class="btn btn-outline-danger btn-sm delete-file-btn" data-file-id="' + response.fileId + '"><i class="fas fa-trash-alt"></i> 삭제</button></td>' +
                        '</tr>'
                    );
                } else {
                    submitButton.prop('disabled', false).text('제출'); // 제출 버튼 활성화
                    $('#submittedAssignments').append('<tr><td colspan="5">제출된 과제가 없습니다.</td></tr>');
                }
            },
            error: function() {
                alert('제출된 과제를 불러오는 중 오류가 발생했습니다.');
            }
        });
    });

    $(document).on('click', '.delete-file-btn', function() {
        const submitButton = $('#assignmentUploadForm button[type="submit"]'); // 제출 버튼
        const fileId = $(this).data('file-id');
        const row = $(this).closest('tr');

        $.ajax({
            url: '<%=contextPath%>/submit/deleteFile.do',
            method: 'POST',
            data: { fileId: fileId },
            success: function(response) {
                submitButton.prop('disabled', false).removeClass('btn-secondary').addClass('btn-primary').text('제출'); // 제출 버튼 활성화 및 원상 복구
                alert(response);
                row.remove(); // 삭제된 행을 테이블에서 제거

                if ($('#submittedAssignments tr').length === 0) {
                    $('#submittedAssignments').append('<tr><td colspan="5">제출된 과제가 없습니다.</td></tr>');
                }
            },
            error: function(xhr) {
                if (xhr.status === 403) {
                    alert("파일 삭제 권한이 없습니다.");
                } else {
                    alert("파일 삭제에 실패했습니다.");
                }
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
    
</script>


</head>
<body>
    <div class="container mt-5">
	    <!-- 뒤로 가기 아이콘 -->
	    <div class="mb-3">
		    <button class="btn btn-secondary btn-sm" onclick="submitAssignmentForm('<%=courseId%>')" title="뒤로가기">
		        <i class="fas fa-arrow-left"></i>
		    </button>
	    </div>
    
        <div class="text-center">
            <h1 class="display-4"><i class="fas fa-file-alt"></i> 과제 제출</h1>
            <p class="lead">과제를 제출하고 관리할 수 있습니다.</p>
        </div>

        <div class="card shadow-lg p-4 my-4">
            <form id="assignmentUploadForm" method="post" action="<%=contextPath%>/submit/uploadAssignment.do" enctype="multipart/form-data">
                <div class="mb-4">
                    <label for="assignmentTitle" class="form-label"><i class="fas fa-book"></i> 과제명</label>
                    <input type="text" id="assignmentTitle" name="assignmentTitle" class="form-control" value="<%= assignment_title != null ? assignment_title : "과제명이 없습니다." %>" readonly>
                </div>
                <div class="mb-4">
                    <label for="assignmentFile" class="form-label"><i class="fas fa-upload"></i> 파일 선택</label>
                    <input type="file" id="assignmentFile" name="assignmentFile" class="form-control" required>
                </div>
                <input type="hidden" name="assignmentId" value="<%= assignmentId %>">
                <input type="hidden" name="assignmentTitle" value="<%= assignment_title %>">
                <input type="hidden" name="courseId" value="<%= courseId %>">
                <div class="d-grid">
                    <button type="submit" class="btn btn-primary btn-lg"><i class="fas fa-upload"></i> 제출</button>
                </div>
            </form>
        </div>

        <div class="card shadow-lg p-4 my-4">
            <h2 class="text-center mb-4"><i class="fas fa-folder-open"></i> 제출된 과제</h2>
            <div id="uploadedAssignments">
                <table class="table table-bordered text-center">
                    <thead class="table-light">
                        <tr>
                            <th>과제명</th>
                            <th>파일명</th>
                            <th>제출일</th>
                            <th>다운로드</th>
                            <th>관리</th>
                        </tr>
                    </thead>
                    <tbody id="submittedAssignments">
                        <!-- Ajax 결과가 여기 추가됩니다. -->
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
