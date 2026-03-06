<%@ page import="Vo.ProfessorVo"%>
<%@ page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>교수 조회</title>

<%
request.setCharacterEncoding("UTF-8");
String contextPath = request.getContextPath();
List<ProfessorVo> professorList = (List<ProfessorVo>) request.getAttribute("professor");
%>

<!-- Bootstrap CSS -->
<link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
<!-- Font Awesome -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

<style>
    body {
        background-color: #f0f2f5;
        font-family: 'Arial', sans-serif;
    }
    #professor-query-container {
        max-width: 100%;
        background-color: #ffffff;
        padding: 30px;
        border-radius: 12px;
        box-shadow: 0px 8px 16px rgba(0, 0, 0, 0.15);
        margin: 50px auto;
    }
    #professor-query-title {
        font-size: 28px;
        font-weight: bold;
        color: #4a90e2;
        text-align: center;
        margin-bottom: 20px;
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
        padding: 10px;
        margin: 5px;
        border: 1px solid #ccc;
        border-radius: 8px;
        box-sizing: border-box;
    }
    .form-container input[type="text"] {
        width: 250px;
    }
    .form-container input[type="submit"] {
        background: linear-gradient(45deg, #4a90e2, #567bdb);
        color: white;
        cursor: pointer;
        border: none;
    }
    .form-container input[type="submit"]:hover {
        background: linear-gradient(45deg, #3a78c2, #466abd);
    }
    .table-container {
        width: 100%;
        margin-top: 20px;
        overflow-x: auto; /* 가로 스크롤 추가 */
    }
    #professor-table {
        width: 100%;
        border-collapse: collapse;
        min-width: 1000px; /* 테이블의 최소 너비 설정 */
    }
    #professor-table th, #professor-table td {
        padding: 12px;
        text-align: center;
        border: 1px solid #ddd;
        white-space: nowrap; /* 텍스트 줄바꿈 방지 */
    }
    #professor-table th {
        background-color: #4a90e2;
        color: white;
        font-weight: bold;
    }
    #professor-table tr:nth-child(even) {
        background-color: #f9f9f9;
    }
    #professor-table tr:hover {
        background-color: #f1f1f1;
    }
    .action-btn {
        color: #4a90e2;
        text-decoration: none;
        font-weight: bold;
    }
    .action-btn:hover {
        text-decoration: underline;
    }
    input[disabled] {
        background-color: #e9ecef;
    }
     .input-smalll {
        width: 60px;  
        padding: 1px;  
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
</style>
</head>
<body>

<div id="professor-query-container">
    <h2 id="professor-query-title"><i class="fas fa-chalkboard-teacher"></i> 교수 조회</h2>

    <div class="form-container">
        <form action="<%=contextPath%>/professor/professorquiry.do" method="get">
            <div>
                <label for="professor_id">사번</label>
                <input type="text" id="professor_id" name="professor_id" maxlength="50" required>
            </div>
            <div>
                <label for="majorcode">학과번호</label>
                <input type="text" id="majorcode" name="majorcode" maxlength="50" required>
            </div>
            <div>
                <input type="submit" value="조회">
            </div>
        </form>

        <form action="<%=contextPath%>/professor/professorquiry.do" method="get">
            <div>
                <input type="submit" value="전체조회">
            </div>
        </form>
    </div>

    <div class="table-container">
        <table id="professor-table">
            <thead>
                <tr>
                    <th>사번</th>
                    <th>이름</th>
                    <th>학과번호</th>
                    <th>생년월일</th>
                    <th>성별</th>
                    <th>주소</th>
                    <th>전화번호</th>
                    <th>이메일</th>
                    <th>고용일</th>
                    <th>정보수정</th>
                    <th>삭제</th>
                </tr>
            </thead>
            <tbody>

<% if (professorList != null && !professorList.isEmpty()) { %>
    <% for (ProfessorVo vo : professorList) { %>
            <tr id="professor-row-<%= vo.getProfessor_id() %>">
                <td><input type="text" name="professor_id" class="professor-id input-smalll" value="<%= vo.getProfessor_id() %>" readonly /></td>
                <td><input type="text" name="user_name" class="input-mid" value="<%= vo.getUser_name() %>" disabled /></td>
                <td><input type="text" name="majorcode" class="input-small" value="<%= vo.getMajorcode() %>" disabled /></td>
                <td><input type="date" name="birthDate" class="input-midd" value="<%= vo.getBirthDate() %>" disabled /></td>
                <td>
                    <select name="gender" disabled>
                        <option value="M" <%= vo.getGender().equals("M") ? "selected" : "" %>>남성</option>
                        <option value="F" <%= vo.getGender().equals("F") ? "selected" : "" %>>여성</option>
                    </select>
                </td>
                <td><input type="text" name="address" value="<%= vo.getAddress() %>" disabled /></td>
                <td><input type="text" name="phone" class="input-midd" value="<%= vo.getPhone() %>" disabled /></td>
                <td><input type="email" name="email" value="<%= vo.getEmail() %>" disabled /></td>
                <td><input type="date" name="employDate" class="input-midd" value="<%= vo.getEmployDate() %>" disabled /></td>
                <td><a href="#" class="action-btn edit-btn">정보수정</a></td>
                <td><a href="#" class="action-btn delete-btn" onclick="deleteProfessor('<%= vo.getProfessor_id() %>'); return false;">삭제</a></td>
            </tr>

    <% } %>
<% } else { %>
    <tr>
        <td colspan="11">조회된 교수가 없습니다.</td>
    </tr>
<% } %>
</tbody>
        </table>
    </div>
</div>

<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>

// 교수 수정
    $(document).ready(function() {
        // "정보수정" 버튼을 클릭했을 때 해당 행의 입력 필드를 활성화
        $(".edit-btn").on("click", function(event) {
            event.preventDefault();
            
            var row = $(this).closest('tr'); // 해당 행을 찾기
            var button = $(this);
            var isEditMode = button.text() === "저장";

            if(isEditMode) {
                var professorId = row.find('input[name="professor_id"]').val();
                var userName = row.find('input[name="user_name"]').val();
                var majorCode = row.find('input[name="majorcode"]').val();
                var birthDate = row.find('input[name="birthDate"]').val();
                var gender = row.find('select[name="gender"]').val();
                var address = row.find('input[name="address"]').val();
                var phone = row.find('input[name="phone"]').val();
                var email = row.find('input[name="email"]').val();
                var employDate = row.find('input[name="employDate"]').val();

                // AJAX 요청을 보냄
                $.ajax({
                    url: '<%=contextPath%>/professor/updateProfessor.do', // 서블릿의 URL 매핑
                    type: 'POST',
                    data: {
                        professor_id: professorId,
                        user_name: userName,
                        majorcode: majorCode,
                        birthDate: birthDate,
                        gender: gender,
                        address: address,
                        phone: phone,
                        email: email,
                        employDate: employDate
                    },
                    success: function(response) {

                        if (response === "수정 완료") {
                            alert("수정이 완료되었습니다.");
                            // 수정이 완료되면 버튼을 다시 "정보수정"으로 바꿈
                            button.text("정보수정");
                            row.find('input, select').prop('disabled', true); // 입력 필드를 다시 비활성화
                        } else {
                            alert("수정 실패");
                        }
                    },
                    error: function(xhr, status, error) {
                        alert("수정 실패: " + error);
                    }
                });
            } else {
            	row.find('input, select').prop('disabled', false);
            	button.text("저장");
            }
        });
    });

    // 교수 삭제
    function deleteProfessor(professorId) {
        if (confirm("정말로 삭제하시겠습니까?")) { // 사용자에게 삭제 확인

            $.ajax({
                url: '<%=contextPath%>/professor/deleteProfessor.do', // 요청 URL
                method: 'POST',                   // 요청 방식 (삭제 시 POST 요청)
                data: { professor_id: professorId },         // 서버에 보낼 데이터
                success: function(response) {

                    if (response.success) {
                        alert("삭제되었습니다.");
                        location.reload(); // 페이지 새로고침
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