<%@page import="Vo.StudentVo"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("utf-8");
    String contextPath = request.getContextPath();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지</title>

<!-- Bootstrap CSS -->
<link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet"> 
<!-- Font Awesome -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

<style>
    body {
        background-color: #f0f2f5;
        font-family: 'Arial', sans-serif;
    }
    #myPage-container {
        max-width: 900px;
        background-color: #ffffff;
        padding: 30px;
        border-radius: 12px;
        box-shadow: 0px 8px 16px rgba(0, 0, 0, 0.15);
        margin: 50px auto; 
    }
    #myPage-title {
        font-size: 28px;
        font-weight: bold;
        color: #4a90e2;
        text-align: center;
        margin-bottom: 20px;
    }
    table {
        width: 100%;
        margin: 0;
        border-collapse: collapse;
    }
    table th, table td {
        border: 1px solid #ddd;
        padding: 0px;
        text-align: left;
        font-size: 16px;
    }
    table th {
        background-color: #4a90e2;
        color: white;
        font-weight: bold;
        text-align: center;
    }
    table tr:nth-child(even) {
        background-color: #f9f9f9;
    }
    table tr:hover {
        background-color: #f1f1f1;
    }
    input[type="text"], input[type="password"], input[type="email"] {
        width: 100%;
        padding: 10px;
        margin: 5px 0;
        border: 1px solid #ccc;
        border-radius: 5px;
        font-size: 14px;
    }
    input[type="text"]:focus, input[type="password"]:focus, input[type="email"]:focus {
        outline: none;
        border-color: #4a90e2;
        box-shadow: 0px 0px 5px rgba(74, 144, 226, 0.5);
    }
    input[readonly] {
        background-color: #f8f9fa;
        border: 1px solid #ddd;
        cursor: not-allowed;
        color: #6c757d;
    }
    input[readonly]:focus {
        outline: none;
        border-color: #ddd;
        box-shadow: none;
    }
    button {
        padding: 10px 20px;
        font-size: 14px;
        color: white;
        background-color: #4a90e2;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        transition: background-color 0.3s;
    }
    button:hover {
        background-color: #357abd;
    }
    .button-container {
        text-align: center;
        margin-top: 20px;
    }
    
   
</style>


<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script>
    function validateForm() {
        var form = document.forms["myForm"];
        var currentPassword = form["current_pw"].value;
        var newPassword = form["user_pw"].value;
        var confirmPassword = form["confirm_pw"].value;
        var email = form["email"].value;

        if (newPassword == null || newPassword === "") {
            alert("비밀번호를 입력해주세요.");
            return false;
        }

        if (newPassword === currentPassword) {
            alert("현재 비밀번호와 새 비밀번호는 같을 수 없습니다.");
            return false;
        }

        if (newPassword !== confirmPassword) {
            alert("새 비밀번호와 확인 비밀번호가 일치하지 않습니다.");
            return false;
        }

        var emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (email == null || email === "" || !emailPattern.test(email)) {
            alert("올바른 이메일 형식을 입력해주세요.");
            return false;
        }
        return true;
    }
    
  	//전화번호에 제한되는 함수 추가
    // 숫자만 입력 가능하도록 제한
    //ASCII 코드 48~57은 숫자('0'~'9')에 해당
    //ASCII 코드 32 이하의 값은 제어 문자(예: Enter, Backspace, Tab 등)
  	//숫자가 아니거나, 일반 입력 문자가 아닌 경우 false를 반환하여 입력을 차단해 알림창이 뜨도록 설정
    // 입력 값 실시간 검사 (oninput 사용)
function isNumber(event) {
        const charCode = event.which ? event.which : event.keyCode;
        if (charCode > 31 && (charCode < 48 || charCode > 57)) {
            return false;
        }
        return true;
    }

 // 최대 11자리까지 입력하도록 제한 (숫자만 유지)
    function checkPhoneLength(input) {
        // 숫자가 아닌 모든 문자 제거 (한글 포함)
        input.value = input.value.replace(/[^0-9]/g, '');

        // 11자리 이상 입력 시 알림창 표시
        if (input.value.length > 11) {
            alert("전화번호는 최대 11자리까지만 입력 가능합니다.");
            input.value = input.value.slice(0, 11); // 11자리까지만 남기기
        }
    }
 
 // 숫자만 입력 가능, 한글과 영어 입력 시 알림창 표시
   function isNumber(event) {
    const charCode = event.which ? event.which : event.keyCode;

    // 숫자가 아닌 값 입력 시 알림창 표시
    if (charCode < 48 || charCode > 57) {
        alert("숫자인지 확인하세요.");
        return false; // 숫자가 아니면 입력 차단
    }

    return true; // 숫자 입력 허용
}

 
    function updateInfo() {
        if (!validateForm()) return false;
		// Ajax를 이용해서 비동기적 통신이 가능하도록 설정
        $.ajax({
            type: "POST",
            url: "<%=contextPath%>/student/updateMyInfo.do",
            data: $("#myForm").serialize(),
            success: function(response) {
                if (response.trim() === "Success") {
                    alert("수정 완료되었습니다.");
                    disableInputs();
                } else {
                    alert("수정 실패: 입력 내용을 확인해주세요.");
                }
            },
            error: function() {
                alert("서버 요청 중 오류가 발생했습니다.");
            }
        });
        return false; // 폼 제출 막기
    }

    function disableInputs() {
        var inputs = document.querySelectorAll("input[type='text'], input[type='password'], input[type='email']");
        inputs.forEach(function(input) {
            input.classList.add("disabled-input");
            input.setAttribute("readonly", true);
        });
    }
</script>

<!-- 다음 주소 API 스크립트 추가 -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
    function sample4_execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                var roadAddr = data.roadAddress;
                var extraRoadAddr = '';

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
 <div id="myPage-container"> 

    <h2  id="myPage-title"><i class="fas fa-user-circle"></i>학생 정보 수정</h2>
    <%
        StudentVo member = (StudentVo) request.getAttribute("member");
        if (member != null) { 
    %>
        <form id="myForm" name="myForm" onsubmit="return updateInfo();">
            <table>
                
                <tr><td><label>아 이 디</label></td>
                    <td><input type="text" name="user_id" value="<%= member.getUser_id() %>" readonly></td>
                </tr>
                
                <tr><td><label>이 름</label></td>
                    <td><input type="text" name="user_name" value="<%= member.getUser_name() %>" readonly></td>
                </tr>
                
                <tr><td><label>주 소</label></td>
                    <td>
                        <input type="text" name="address" id="address" value="<%= member.getAddress() %>" placeholder="우편번호로 검색 후 상세주소까지 입력">
                        <button type="button" onclick="sample4_execDaumPostcode()">주소 찾기</button>
                    </td>
                </tr>
                
                <tr><td><label>전 화 번 호</label></td> <!--전화번호는 숫자만 가능하고 최대 11자리 까지 가능하게 설정. 더 입력하려하면 알림창 뜨게 설정  -->
                    <td><input type="text" name="phone" value="<%= member.getPhone() %>" placeholder="전화번호"  onkeypress="return isNumber(event);" oninput="checkPhoneLength(this);"></td>
                </tr>
                
                <tr><td><label>이 메 일</label></td>
                    <td><input type="text" name="email" value="<%= member.getEmail() %>" placeholder="이메일"></td>
                </tr>
                
                <tr><td><label>현 재 비 밀 번 호</label></td>
                    <td><input type="text" name="current_pw" value="<%= member.getUser_pw() %>" readonly></td>
                </tr>
                
                <tr><td><label>새 비 밀 번 호</label></td>
                    <td><input type="password" name="user_pw" placeholder="새 비밀번호"></td>
                </tr>
                
                <tr><td><label>새 비 밀 번 호 확 인</label></td>
                    <td><input type="password" name="confirm_pw" required placeholder="새 비밀번호 확인"></td>
                </tr>
            </table>
            
             <div class="button-container">
                <button type="submit">수정</button>
            </div>
        </form>
    <%
        } else { 
    %>
        <p>회원 정보를 불러올 수 없습니다.</p>
    <%
        }
    %>
    </div>
</body>
</html>