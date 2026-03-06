<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    request.setCharacterEncoding("UTF-8");
    String contextPath = request.getContextPath();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>학 생 등 록</title>
<!-- Bootstrap CSS -->
<link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
<!-- Font Awesome -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<style>
    body {
        background-color: #f0f2f5;
        font-family: 'Arial', sans-serif;
    }
    #student-register-container {
        max-width: 900px;
        background-color: #ffffff;
        padding: 30px;
        border-radius: 12px;
        box-shadow: 0px 8px 16px rgba(0, 0, 0, 0.15);
        margin: 50px auto;
    }
    #student-register-title {
        font-size: 28px;
        font-weight: bold;
        color: #4a90e2;
        text-align: center;
        margin-bottom: 20px;
    }
    #student-register-table {
        width: 100%;
        margin: 20px 0;
        border-collapse: collapse;
    }
    #student-register-table th, #student-register-table td {
        border: none;
        padding: 12px;
        font-size: 14px;
    }
    #student-register-table th {
        text-align: left;
        width: 30%;
        font-weight: bold;
        color: #333;
    }
    #student-register-table td {
        width: 70%;
    }
    input[type="text"], input[type="email"], input[type="password"], 
    input[type="date"], input[type="number"], select {
        width: 100%;
        padding: 10px;
        border: 1px solid #ccc;
        border-radius: 8px;
        box-sizing: border-box;
        margin-top: 8px;
    }
    input[type="button"] {
        background-color: #4a90e2;
        color: white;
        border: none;
        padding: 10px 15px;
        border-radius: 8px;
        cursor: pointer;
    }
    input[type="button"]:hover {
        background-color: #3a78c2;
    }
    input[type="submit"] {
        background: linear-gradient(45deg, #4a90e2, #567bdb);
        border: none;
        padding: 12px 20px;
        font-size: 16px;
        font-weight: bold;
        color: white;
        border-radius: 8px;
        cursor: pointer;
        margin-top: 20px;
    }
    input[type="submit"]:hover {
        background: linear-gradient(45deg, #3a78c2, #466abd);
    }
    .btn-container {
        text-align: center;
        margin-top: 10px;
    }
</style>
<script>
window.onload = function() {
    result();
};
function result(){
    var result = parseInt("${result}", 10);
    if (isNaN(result)) {
        return; // addResult가 없을 때는 함수를 종료함
    }
    if (result === 0) {
        alert("데이터베이스에 추가하는 데 실패했습니다. 다시 시도해 주세요.");
    } else if (result === 1) {
        alert("학생 정보가 성공적으로 추가되었습니다.");
    }
}
</script>
<!-- 다음 주소 API 스크립트 추가 -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
    function sample4_execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                var roadAddr = data.roadAddress; // 도로명 주소
                var extraRoadAddr = ''; // 참고 항목
                if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) {
                    extraRoadAddr += data.bname;
                }
                if (data.buildingName !== '' && data.apartment === 'Y') {
                    extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                if (extraRoadAddr !== '') {
                    extraRoadAddr = ' (' + extraRoadAddr + ')';
                }
                document.getElementById('address').value = roadAddr + extraRoadAddr;
            }
        }).open();
    }
</script>
</head>
<body>
    <div id="student-register-container">
        <h2 id="student-register-title"><i class="fas fa-user-plus"></i> 학 생 등 록</h2>

        <form action="<%=contextPath %>/student/studentRegister.do" method="post">
            <table id="student-register-table">
                <tr>
                    <th><label for="student_id">학 생  I D:</label></th>
                    <td><input type="text" id="student_id" name="student_id" required placeholder="정해진 양식의 학생ID 입력 필요"></td>
                </tr>
                <tr>
                    <th><label for="user_id">사 용 자 I D:</label></th>
                    <td><input type="text" id="user_id" name="user_id" required placeholder="정해진 양식의 사용자ID 입력 필요"></td>
                </tr>
                <tr>
                    <th><label for="user_pw">비 밀 번 호:</label></th>
                    <td><input type="password" id="user_pw" name="user_pw" required placeholder="비밀번호"></td>
                </tr>
                <tr>
                    <th><label for="user_name">이 름:</label></th>
                    <td><input type="text" id="user_name" name="user_name" required placeholder="이름"></td>
                </tr>
                <tr>
                    <th><label for="birthDate">생 년 월 일:</label></th>
                    <td><input type="date" id="birthDate" name="birthDate" required></td>
                </tr>
                <tr>
                    <th><label for="gender">성 별:</label></th>
                    <td>
                        <select id="gender" name="gender" required>
                            <option value="남">남</option>
                            <option value="여">여</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th><label for="address">주 소:</label></th>
                    <td>
                        <div style="display: flex; align-items: center;">
                            <input type="text" id="address" name="address" placeholder="우편번호로 검색 후 상세주소까지 입력할 것" required style="flex: 1;">
                            <input type="button" onclick="sample4_execDaumPostcode()" value="우편번호 찾기" style="margin-left: 5px;">
                        </div>
                    </td>
                </tr>
                <tr>
                    <th><label for="phone">전 화 번 호:</label></th>
                    <td><input type="text" id="phone" name="phone" required placeholder="-없이 숫자만 입력"></td>
                </tr>
                <tr>
                    <th><label for="email">이 메 일:</label></th>
                    <td><input type="email" id="email" name="email" required placeholder="example@naver.com"></td>
                </tr>
                <tr>
                    <th></th>
                    <td><input type="hidden" id="role" name="role" value="학생"></td>
                </tr>
                <tr>
                    <th><label for="majorcode">학 과 번 호:</label></th>
                    <td><input type="text" id="majorcode" name="majorcode" required></td>
                </tr>
                <tr>
                    <th><label for="grade">학 년:</label></th>
                    <td><input type="number" id="grade" name="grade" min="1" max="4" required></td>
                </tr>
                <tr>
                    <th><label for="admission_date">입 학 일:</label></th>
                    <td><input type="date" id="admission_date" name="admission_date" required></td>
                </tr>
                <tr>
                    <th><label for="status">상 태:</label></th>
                    <td>
                        <select id="status" name="status" required>
                            <option value="재학" selected>재학</option>
                            <option value="휴학">휴학</option>
                            <option value="졸업">졸업</option>
                            <option value="자퇴">자퇴</option>
                        </select>
                    </td>
                </tr>
            </table>
            <div class="btn-container">
                <input type="submit" value="등록">
            </div>
        </form>
    </div>
</body>
</html>