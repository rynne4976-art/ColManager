<%@ page import="java.util.function.Function"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>교수 등록</title>

    <%
    request.setCharacterEncoding("UTF-8");
    String contextPath = request.getContextPath();
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
        #professor-register-container {
            max-width: 900px;
            background-color: #ffffff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0px 8px 16px rgba(0, 0, 0, 0.15);
            margin: 50px auto;
        }
        #professor-register-title {
            font-size: 28px;
            font-weight: bold;
            color: #4a90e2;
            text-align: center;
            margin-bottom: 20px;
        }
        #professor-register-table {
            width: 100%;
            margin: 20px 0;
            border-collapse: collapse;
        }
        #professor-register-table th, #professor-register-table td {
            border: none;
            padding: 12px;
            font-size: 14px;
        }
        #professor-register-table th {
            text-align: left;
            width: 30%;
            font-weight: bold;
            color: #333;
            background-color: #f9f9f9;
        }
        #professor-register-table td {
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
        input[type="text"][readonly] {
            background-color: #e9ecef;
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
            margin-top: 20px;
        }
        .address-input {
            margin-top: 8px;
        }
        .address-input input {
            margin-bottom: 8px;
        }
        .radio-group {
            margin-top: 8px;
        }
        .radio-group input {
            margin-right: 5px;
        }
    </style>
    <script type="text/javascript">
    function handleFormSubmit() {
        const form = document.getElementById('professorForm');
        
        // 사용자에게 메시지를 띄움
        alert('등록이 완료되었습니다.');

        // 메시지 확인 후 폼 제출
        form.submit();
    }
    </script>
</head>
<body>

    <div id="professor-register-container">
        <h2 id="professor-register-title"><i class="fas fa-user-plus"></i> 교수 등록</h2>

        <form id="professorForm" action="<%=contextPath%>/professor/professor.do" method="post">
            <input type="hidden" name="role" value="교수">

            <table id="professor-register-table">
                <tr>
                    <th><label for="user_id">아이디</label></th>
                    <td><input type="text" id="user_id" name="user_id" required></td>		
                </tr>
                <tr>
                    <th><label for="user_pw">비밀번호</label></th>
                    <td><input type="password" id="user_pw" name="user_pw" required></td>		
                </tr>
                <tr>
                    <th><label for="professor_id">사번</label></th>
                    <td><input type="text" id="professor_id" name="professor_id" placeholder="P000"  required></td>		
                </tr>
                <tr>
                    <th><label for="p_name">이름</label></th>
                    <td><input type="text" id="p_name" name="p_name" required></td>		
                </tr>
                <tr>
                    <th><label for="p_birthDate">생년월일</label></th>
                    <td><input type="date" id="p_birthDate" name="p_birthDate" required></td>		
                </tr>
                <tr>
                    <th><label for="p_gender">성별</label></th>
                    <td class="radio-group">
                        <input type="radio" id="gender_male" name="p_gender" value="남" checked>
                        <label for="gender_male">남성</label>
                        <input type="radio" id="gender_female" name="p_gender" value="여">
                        <label for="gender_female">여성</label>
                    </td>		
                </tr>
                <tr>
                    <th><label for="address">주소</label></th>
                    <td>
                        <div class="address-input">
                            <input type="text" id="sample4_postcode" name="address1" placeholder="우편번호" required>
                            <input type="button" onclick="sample4_execDaumPostcode()" value="우편번호 찾기"><br>
                            <input type="text" id="sample4_roadAddress" name="address2" placeholder="도로명주소" required>
                            <input type="text" id="sample4_jibunAddress" name="address3" placeholder="지번주소"><br>
                            <input type="text" id="sample4_detailAddress" name="address4" placeholder="상세주소" required>
                            <input type="text" id="sample4_extraAddress" name="address5" placeholder="참고항목">
                            <span id="guide" style="color:#999;display:none"></span>
                        </div>
                    </td>		
                </tr>
                <tr>
                    <th><label for="p_phone">전화번호</label></th>
                    <td><input type="text" id="p_phone" name="p_phone" required></td>		
                </tr>
                <tr>
                    <th><label for="majorcode">학과번호</label></th>
                    <td><input type="text" id="majorcode" name="majorcode" required></td>		
                </tr>
                <tr>
                    <th><label for="p_email">이메일</label></th>
                    <td><input type="email" id="p_email" name="p_email" required></td>		
                </tr>
                <tr>
                    <th><label for="p_employDate">고용일</label></th>
                    <td><input type="date" id="p_employDate" name="p_employDate" required></td>		
                </tr>
            </table>

            <div class="btn-container">
                <input type="submit" value="등록"  onclick="handleFormSubmit()">
            </div>
        </form>
    </div>

    <!-- 다음 주소 API 스크립트 추가 -->
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <script>
        //본 예제에서는 도로명 주소 표기 방식에 대한 법령에 따라, 내려오는 데이터를 조합하여 올바른 주소를 구성하는 방법을 설명합니다.
        function sample4_execDaumPostcode() {
            new daum.Postcode({
                oncomplete: function(data) {
                    // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                    // 도로명 주소의 노출 규칙에 따라 주소를 표시한다.
                    // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                    var roadAddr = data.roadAddress; // 도로명 주소 변수
                    var extraRoadAddr = ''; // 참고 항목 변수

                    // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                    // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                    if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                        extraRoadAddr += data.bname;
                    }
                    // 건물명이 있고, 공동주택일 경우 추가한다.
                    if(data.buildingName !== '' && data.apartment === 'Y'){
                       extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                    if(extraRoadAddr !== ''){
                        extraRoadAddr = ' (' + extraRoadAddr + ')';
                    }

                    // 우편번호와 주소 정보를 해당 필드에 넣는다.
                    document.getElementById('sample4_postcode').value = data.zonecode;
                    document.getElementById("sample4_roadAddress").value = roadAddr;
                    document.getElementById("sample4_jibunAddress").value = data.jibunAddress;
                    
                    // 참고항목 문자열이 있을 경우 해당 필드에 넣는다.
                    if(roadAddr !== ''){
                        document.getElementById("sample4_extraAddress").value = extraRoadAddr;
                    } else {
                        document.getElementById("sample4_extraAddress").value = '';
                    }

                    var guideTextBox = document.getElementById("guide");
                    // 사용자가 '선택 안함'을 클릭한 경우, 예상 주소라는 표시를 해준다.
                    if(data.autoRoadAddress) {
                        var expRoadAddr = data.autoRoadAddress + extraRoadAddr;
                        guideTextBox.innerHTML = '(예상 도로명 주소 : ' + expRoadAddr + ')';
                        guideTextBox.style.display = 'block';

                    } else if(data.autoJibunAddress) {
                        var expJibunAddr = data.autoJibunAddress;
                        guideTextBox.innerHTML = '(예상 지번 주소 : ' + expJibunAddr + ')';
                        guideTextBox.style.display = 'block';
                    } else {
                        guideTextBox.innerHTML = '';
                        guideTextBox.style.display = 'none';
                    }
                }
            }).open();
        }
    </script>

</body>
</html>