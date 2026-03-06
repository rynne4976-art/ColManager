<%@page import="java.net.URLDecoder"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Vo.CourseVo"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
String contextPath = request.getContextPath();
ArrayList<CourseVo> courseList = (ArrayList<CourseVo>) request.getAttribute("courseList");
String profName = (String) session.getAttribute("name");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>교수가 강의하는 수강 목록</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
<script type="text/javascript" src="http://code.jquery.com/jquery-latest.min.js"></script>

<style>
    .btn-green {
        background-color: #4CAF50;
        color: white;
    }
    .btn-green:hover {
        background-color: #45a049;
    }
    body {
        background-color: #f8f9fa;
    }
    h2 {
        font-weight: bold;
    }
    table {
        border-radius: 8px;
        overflow: hidden;
    }
</style>

<script>
function enableEdit(courseId) {
    const courseNameCell = $('#courseName_' + courseId);
    const originalCourseName = courseNameCell.text().trim();
    const classroomCell = $('#classroom_' + courseId);
    const originalClassroom = classroomCell.text().trim();

    // 강의명 셀을 입력 필드로 변경
    courseNameCell.html('<input type="text" id="editInput_' + courseId + '" class="form-control" value="' + originalCourseName + '">');
    // 강의실 셀을 select로 변경
    classroomCell.html('<select id="classroomSelect_' + courseId + '" class="form-select"></select>');

    // DB에서 강의실 목록을 가져와서 select 태그에 추가
    $.ajax({
        url: '<%=contextPath%>/classroom/getClassroomList.do',
        type: 'post',
        dataType: 'json',
        success: function(classrooms) {
            const classroomSelect = $('#classroomSelect_' + courseId);
            classroomSelect.empty(); // 기존 옵션 제거
            classrooms.forEach(function(room) {
                const option = $('<option></option>')
                    .val(room.room_id)
                    .text(room.room_id + ' (' + room.capacity + '명 / ' + room.equipment + ')');
                classroomSelect.append(option);
            });

            // 원래 강의실 값 선택
            const selectedOption = classrooms.find(room => room.room_id === originalClassroom.split(' ')[0]);
            if (selectedOption) {
                classroomSelect.val(selectedOption.room_id);
            }
        },
        error: function(xhr, status, error) {
            console.error("강의실 목록을 가져오는 데 실패했습니다:", error);
        }
    });

    // 버튼 상태 변경
    $('#editBtn_' + courseId).hide();
    $('#saveBtn_' + courseId).show();
    $('#cancelBtn_' + courseId).show();

    // 취소 버튼 클릭 시 원래 값으로 되돌리기
    $('#cancelBtn_' + courseId).off('click').on('click', function() {
        // 강의명 입력 필드를 텍스트로 되돌리기
        courseNameCell.html(originalCourseName);
        // 강의실 필드를 텍스트로 되돌리기
        classroomCell.html(originalClassroom);

        // 버튼 상태 복구
        $('#editBtn_' + courseId).show();
        $('#saveBtn_' + courseId).hide();
        $('#cancelBtn_' + courseId).hide();
    });
}


function saveEdit(courseId) {
    const newCourseName = $('#editInput_' + courseId).val();
    const selectedClassroom = $('#classroomSelect_' + courseId).val();
    $.ajax({
        url: '<%=contextPath%>/classroom/updateCourse.do',
        type: 'POST',
        data: {
            courseId: courseId,
            courseName: newCourseName,
            classroomId: selectedClassroom
        },
        success: function(response) {
            if (response.status === "success") {
                $('#courseName_' + courseId).text(newCourseName);
                $('#classroom_' + courseId).text($('#classroomSelect_' + courseId + ' option:selected').text());
                $('#editBtn_' + courseId).show();
                $('#saveBtn_' + courseId).hide();
                $('#cancelBtn_' + courseId).hide();
                alert("강의 수정 완료!");

                location.reload(); // 페이지 새로 고침
            } else {
                alert("강의 수정에 실패했습니다.");
            }
        },
        error: function(xhr, status, error) {
            alert("강의 수정 처리 중 오류!");
        }
    });
}

function submitDeleteForm(courseId) {
    if (confirm("삭제하시겠습니까?")) {
        document.getElementById("deleteForm_" + courseId).submit();
    }
}
</script>
</head>
<body>
    <main class="container my-5">
    <div class="text-center mt-5 mb-5">
            <h1 class="display-4"><i class="fas fa-chalkboard-teacher"></i>  교수님 강의 목록</h1>
            <p class="lead">강의 정보 수정 및 관리를 위한 목록입니다.</p>
        </div>
        <div class="card shadow-lg p-4">
            <table class="table table-bordered table-hover text-center">
                <thead class="table-success">
                    <tr>
                        <th scope="col">과목 ID</th>
                        <th scope="col">과목 이름</th>
                        <th scope="col">강의실 (수용인원 / 장비)</th>
                        <th scope="col">수정</th>
                        <th scope="col">삭제</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (CourseVo course : courseList) { %>
                    <tr id="row_<%= course.getCourse_id() %>">
                        <td><%= course.getCourse_id() %></td>
                        <td id="courseName_<%= course.getCourse_id() %>"><%= course.getCourse_name() %></td>
                        <td id="classroom_<%= course.getCourse_id() %>">
                            <%= course.getClassroom().getRoom_id() %> (<%= course.getClassroom().getCapacity() %>명 / <%= course.getClassroom().getEquipment() %>)
                        </td>
                        <td>
                            <button id="editBtn_<%= course.getCourse_id() %>" class="btn btn-green" onclick="enableEdit('<%= course.getCourse_id() %>')">수정</button>
                            <button id="saveBtn_<%= course.getCourse_id() %>" class="btn btn-green" style="display:none;" onclick="saveEdit('<%= course.getCourse_id() %>')">수정 완료</button>
                            <button id="cancelBtn_<%= course.getCourse_id() %>" class="btn btn-danger" style="display:none;">취소</button>
                        </td>
                        <td>
                            <form id="deleteForm_<%= course.getCourse_id() %>" action="<%=contextPath%>/classroom/deleteCourse.do" method="POST">
                                <input type="hidden" name="id" value="<%= course.getCourse_id() %>">
                                <button type="button" class="btn btn-danger" onclick="submitDeleteForm('<%= course.getCourse_id() %>')">삭제</button>
                            </form>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </main>
</body>
</html>
