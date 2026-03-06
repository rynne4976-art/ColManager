<%@page import="Vo.AdminVo"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 조회</title>

<!-- Bootstrap CSS -->
<link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
<!-- Font Awesome -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>

<style>
    body {
        background-color: #f0f2f5;
        font-family: 'Arial', sans-serif;
    }
    #admin-list-container {
        max-width: 100%;
        background-color: #ffffff;
        padding: 30px;
        border-radius: 12px;
        box-shadow: 0px 8px 16px rgba(0, 0, 0, 0.15);
        margin: 50px auto;
    }
    #admin-list-title {
        font-size: 28px;
        font-weight: bold;
        color: #4a90e2;
        text-align: center;
        margin-bottom: 20px;
    }
    .table-responsive {
        width: 100%;
        overflow-x: auto;
    }
    #admin-list-table {
        width: 100%;
        margin: 20px 0;
        border-collapse: collapse;
    }
    #admin-list-table th, #admin-list-table td {
        border: 1px solid #ddd;
        padding: 10px;
        text-align: center;
        font-size: 14px;
        white-space: nowrap;
    }
    #admin-list-table th {
        background-color: #4a90e2;
        color: white;
        font-weight: bold;
    }
    #admin-list-table tr:nth-child(even) {
        background-color: #f9f9f9;
    }
    #admin-list-table tr:hover {
        background-color: #f1f1f1;
    }
    .btn-link {
        color: #4a90e2;
        text-decoration: none;
        cursor: pointer;
    }
    .btn-link:hover {
        text-decoration: underline;
    }
    .action-link {
        font-weight: bold;
    }
    .form-container {
        margin-top: 20px;
        width: 100%;
    }
    .form-container form {
        display: flex;
        justify-content: center;
        gap: 15px;
        margin-bottom: 20px;
        flex-wrap: wrap;
    }
    .form-container input[type="text"], .form-container input[type="submit"] {
        padding: 6px;
        margin: 5px;
        border: 1px solid #bbb;
        border-radius: 4px;
        font-size: 0.9em;
    }
    .form-container input[type="text"] {
        width: 220px;
    }
    .form-container input[type="submit"] {
        background-color: #6c757d;
        color: white;
        cursor: pointer;
    }
    .form-container input[type="submit"]:hover {
        background-color: #5a6268;
    }
    .message {
        text-align: center;
        color: red;
        margin-top: 10px;
    }
    .input-small {
        width: 80px;  
        padding: 1px;  
    }
    .input-mid {
        width: 100px; 
        padding: 1px;  
    }
    .input-midd {
        width: 120px; 
        padding: 1px;  
    }
    input[type="text"], input[type="email"], input[type="date"], select {
        max-width: 150px;
    }
</style>

<%
  request.setCharacterEncoding("UTF-8");
  String contextPath = request.getContextPath();
  List<AdminVo> memberList = (List<AdminVo>) request.getAttribute("member");
%>

</head>
<body>

<div id="admin-list-container">
    <h2 id="admin-list-title"><i class="fas fa-user-shield"></i> 관리자 조회</h2>

    <div class="form-container">
        <form action="<%=contextPath%>/admin/managerquiry.do" class="form" method="get">
            <div>
                <h4>아이디 또는 관리자 번호를 입력해주세요.</h4>
                <input type="text" id="searchWord" name="searchWord" maxlength="50" required="required">
                <input type="hidden" name="center" value="/view_admin/adminManager/adminquiry.jsp">
                <input type="submit" value="조회">
                
            </div>
        </form>	

        <form action="<%=contextPath%>/admin/managerview.do?" class="form1" method="get">
            <div>
                <input type="hidden" name="center" value="/view_admin/adminManager/adminquiry.jsp">
                <input type="submit" value="전체조회">
            </div>
        </form>
    </div>

    <div class="table-responsive">
        <table id="admin-list-table">
            <thead>
                <tr>
                    <th>아이디</th>
                    <th>이름</th>
                    <th>생년월일</th>
                    <th>성별</th>
                    <th>주소</th>
                    <th>전화번호</th>
                    <th>이메일</th>
                    <th>관리자번호</th>
                    <th>부서</th>
                    <th>관리권한</th>
                    <th>수정</th>
                    <th>삭제</th>
                </tr>
            </thead>
            <tbody>
<%     
      if (memberList != null && !memberList.isEmpty()) { 
          for (AdminVo vo : memberList) {
%>
                <tr id="manager-row-<%=vo.getAdmin_id()%>" class="admin-row">
                    <td><input type="text" name="user_id" class="user_id input-small" value="<%= vo.getUser_id() %>" readonly disabled /></td>
                    <td><input type="text" name="user_name" class="user_name input-small" value="<%= vo.getUser_name() %>" disabled /></td>
                    <td><input type="date" name="birthDate" value="<%= vo.getBirthDate() %>" disabled /></td>
                    <td>
                        <select name="gender" disabled>
                            <option value="남" <%= vo.getGender().equals("남") ? "selected" : "" %>>남</option>
                            <option value="여" <%= vo.getGender().equals("여") ? "selected" : "" %>>여</option>
                        </select>
                    </td>
                    <td><input type="text" name="address" value="<%= vo.getAddress() %>" disabled /></td>
                    <td><input type="text" name="phone" class="phone input-midd" value="<%= vo.getPhone() %>" disabled /></td>
                    <td><input type="email" name="email" value="<%= vo.getEmail() %>" disabled /></td>
                    <td><input type="text" name="admin_id" class="admin_id input-mid" value="<%= vo.getAdmin_id() %>" readonly disabled /></td>
                    <td>
                        <select name="department" disabled>
                            <option value="IT지원팀" <%= vo.getDepartment() != null && vo.getDepartment().equals("IT지원팀") ? "selected" : "" %>>IT지원팀</option>
                            <option value="입학처" <%= vo.getDepartment() != null && vo.getDepartment().equals("입학처") ? "selected" : "" %>>입학처</option>
                            <option value="재무부" <%= vo.getDepartment() != null && vo.getDepartment().equals("재무부") ? "selected" : "" %>>재무부</option>
                            <option value="학생처" <%= vo.getDepartment() != null && vo.getDepartment().equals("학생처") ? "selected" : "" %>>학생처</option>
                            <option value="학사관리팀" <%= vo.getDepartment() != null && vo.getDepartment().equals("학사관리팀") ? "selected" : "" %>>학사관리팀</option>
                        </select>
                    </td>
                    <td><input type="text" name="access_level" class="access input-midd" value="<%=vo.getAccess_level()%>" disabled /></td>
                    <td class="edit-action">
                        <a href="javascript:void(0);" class="btn-link action-link edit-button" data-admin-id="<%=vo.getAdmin_id()%>">수정</a>
                    </td>
                    <td class="delete-action">
                        <a href="javascript:void(0);" class="btn-link action-link" onclick="managerDelete('<%=vo.getAdmin_id()%>'); return false;">삭제</a>
                    </td>
                </tr>
                
<%
          }
      } else {
%>
                <tr id="no-data-row">
                    <td colspan="12">조회된 관리자가 없습니다.</td>
                </tr>
<%
      }
%>
            </tbody>
        </table>
    </div>
</div>

<script>
$(document).ready(function() {
    // 수정 버튼 클릭 시
    $(document).on('click', '.edit-button', function(event) {
        event.preventDefault();
        let adminId = $(this).data('admin-id');
        enableEdit(adminId, this);
    });

    // 저장 버튼 클릭 시
    $(document).on('click', '.save-button', function(event) {
        event.preventDefault();
        let adminId = $(this).data('admin-id');
        saveManager(adminId, $(this));
    });

    function enableEdit(adminId, button) {
        let row = $('#manager-row-' + adminId);
        row.find('input, select').prop('disabled', false); // 입력 필드 활성화
        button = $(button);
        button.text("저장"); // 버튼 텍스트를 "저장"으로 변경
        button.removeClass('edit-button').addClass('save-button'); // 클래스 변경으로 이벤트 핸들러 변경
    }

    function saveManager(adminId, button) {
        let row = $('#manager-row-' + adminId);
        // 수정된 모든 값들을 가져오기
        let formData = {};
        row.find('input, select, textarea').each(function() {
            let input = $(this);
            formData[input.attr('name')] = input.val();
        });

        formData['admin_id'] = adminId;

        $.ajax({
            url: '<%=contextPath%>/admin/managerEdit.do',
            method: 'POST',
            data: formData,
            success: function(response) {
                if (response === "수정 완료") {
                    alert("수정이 완료되었습니다.");
                    // 수정이 완료되면 버튼을 다시 "수정"으로 변경
                    button.text("수정");
                    row.find('input, select, textarea').prop('disabled', true);  // 입력 필드 비활성화
                    button.removeClass('save-button').addClass('edit-button'); // 클래스 변경으로 이벤트 핸들러 변경
                } else {
                    alert("수정 실패");
                }
            },
            error: function(xhr, status, error) {
                console.error("AJAX Error:", status, error);
                alert("수정 실패: " + error);
            }
        });
    }
});

    // 관리자 삭제
    function managerDelete(admin_id) {
        if (confirm("정말로 삭제하시겠습니까?")) { // 사용자에게 삭제 확인
            $.ajax({
                url: '<%=contextPath%>/admin/managerDelete.do', // 요청 URL
                method: 'POST',                   // 요청 방식 (삭제 시 POST 요청)
                data: { admin_id: admin_id },         // 서버에 보낼 데이터
                success: function(response) {
                    if (response.success) {
                        alert("삭제되었습니다.");
                        $("#manager-row-" + admin_id).remove();
                    } else {
                        alert("삭제에 실패했습니다.");
                    }
                },
                error: function() {
                    alert("오류가 발생했습니다. 다시 시도해 주세요.");
                }
            });
        }
    }
</script>

</body>
</html>
