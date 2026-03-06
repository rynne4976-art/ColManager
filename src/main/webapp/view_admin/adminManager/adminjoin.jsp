<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 회원가입</title>

<!-- Bootstrap CSS -->
<link
	href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css"
	rel="stylesheet">
<!-- Font Awesome -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<!-- jQuery -->
<script src="https://code.jquery.com/jquery-latest.min.js"></script>

<style>
body {
	background-color: #f0f2f5;
	font-family: 'Arial', sans-serif;
}

#admin-signup-container {
	max-width: 800px;
	background-color: #ffffff;
	padding: 30px;
	border-radius: 12px;
	box-shadow: 0px 8px 16px rgba(0, 0, 0, 0.15);
	margin: 50px auto;
}

#admin-signup-title {
	font-size: 28px;
	font-weight: bold;
	color: #4a90e2;
	text-align: center;
	margin-bottom: 20px;
}

#admin-signup-form {
	width: 100%;
}

#admin-signup-table {
	width: 100%;
	border-collapse: collapse;
	font-size: 14px;
}

#admin-signup-table th, #admin-signup-table td {
	border: 1px solid #ddd;
	padding: 10px;
	text-align: left;
}

#admin-signup-table th {
	background-color: #4a90e2;
	color: white;
	font-weight: bold;
	width: 30%;
}

#admin-signup-table tr:nth-child(even) {
	background-color: #f9f9f9;
}

#admin-signup-table tr:hover {
	background-color: #f1f1f1;
}

.form-control {
	width: 50%;
	display: inline-block;
}

.btn-submit {
	width: auto;
	padding: 10px 20px;
	background-color: #007bff;
	color: white;
	border: none;
	border-radius: 4px;
	cursor: pointer;
	font-size: 16px;
}

.btn-submit:hover {
	background-color: #0056b3;
}

.gender-radio {
	margin-right: 10px;
}

.address-input {
	margin-bottom: 5px;
}

#address-buttons {
	margin-top: 10px;
}

#guide {
	color: #999;
	display: none;
}

.validation-message {
	color: red;
	font-size: 12px;
	margin-left: 5px;
}

/* Ensure input and select elements fill the remaining space */
#admin-signup-table input[type="text"], #admin-signup-table input[type="password"],
	#admin-signup-table input[type="date"], #admin-signup-table select {
	width: 50%;
	box-sizing: border-box;
	padding: 5px;
	margin: 2px 0;
	border: 1px solid #ccc;
	border-radius: 4px;
	font-size: 13px;
}
</style>

<%
request.setCharacterEncoding("UTF-8");
String contextPath = request.getContextPath();
%>

<!-- 주소 -->
<script
	src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>


</head>
<body>
	<div id="admin-signup-container">
		<h2 id="admin-signup-title">
			<i class="fas fa-user-shield"></i> 관리자 회원가입
		</h2>
		<form action="<%=contextPath%>/admin/joinPro.me"
			id="admin-signup-form" method="get">
			<input type="hidden" name="role" value="관리자">

			<table id="admin-signup-table">
				<tr>
					<th>아이디</th>
					<td><input type="text" name="user_id" id="id"
						placeholder="아이디를 적어주세요" class="form-control"> <span
						id="idInput" class="validation-message"></span></td>
				</tr>
				<tr>
					<th>비밀번호</th>
					<td><input type="password" name="user_pw" id="pass"
						placeholder="비밀번호를 적어주세요" class="form-control"> <span
						id="passInput" class="validation-message"></span></td>
				</tr>
				<tr>
					<th>이름</th>
					<td><input type="text" name="name" id="name"
						placeholder="이름을 적어주세요" class="form-control"> <span
						id="nameInput" class="validation-message"></span></td>
				</tr>
				<tr>
					<th>생년월일</th>
					<td><input type="date" name="birthDate" id="birthDate"
						class="form-control"> <span id="birthDateInput"
						class="validation-message"></span></td>
				</tr>
				<tr>
					<th>성별</th>
					<td>
						<div class="form-check form-check-inline">
							<input type="radio" name="gender" id="gender-male" value="남"
								class="form-check-input gender-radio gender"> <label
								for="gender-male" class="form-check-label">남성</label>
						</div>
						<div class="form-check form-check-inline">
							<input type="radio" name="gender" id="gender-female" value="여"
								class="form-check-input gender-radio gender"> <label
								for="gender-female" class="form-check-label">여성</label>
						</div> <span id="genderInput" class="validation-message"></span>
					</td>
				</tr>
				<tr>
					<th>주소</th>
					<td><input type="text" id="sample4_postcode" name="address1"
						placeholder="우편번호" class="form-control address-input">
						<button type="button" onclick="sample4_execDaumPostcode()"
							class="btn btn-secondary">우편번호 찾기</button> <br> <input
						type="text" id="sample4_roadAddress" name="address2"
						placeholder="도로명주소" class="form-control address-input"> <input
						type="text" id="sample4_jibunAddress" name="address3"
						placeholder="지번주소" class="form-control address-input"> <br>
						<input type="text" id="sample4_detailAddress" name="address4"
						placeholder="상세주소" class="form-control address-input"> <input
						type="text" id="sample4_extraAddress" name="address5"
						placeholder="참고항목" class="form-control address-input">
						<p id="guide"></p>
						<p id="addressInput" class="validation-message"></p></td>
				</tr>
				<tr>
					<th>전화번호</th>
					<td><input type="text" name="phone" id="tel"
						placeholder="전화번호를 적어주세요" class="form-control"> <span
						id="telInput" class="validation-message"></span></td>
				</tr>
				<tr>
					<th>이메일</th>
					<td><input type="text" name="email" id="email"
						placeholder="이메일을 적어주세요" class="form-control"> <span
						id="emailInput" class="validation-message"></span></td>
				</tr>
				<tr>
					<th>관리자번호</th>
					<td><input type="text" name="admin_id" id="admin_id"
						placeholder="A000" class="form-control"> <span
						id="adminInput" class="validation-message"></span></td>
				</tr>
				<tr>
					<th>부서</th>
					<td><select id="department" name="department"
						class="form-control">
							<option value="" disabled selected>--선택해주세요--</option>
							<option value="IT지원팀">IT지원팀</option>
							<option value="입학처">입학처</option>
							<option value="재무부">재무부</option>
							<option value="학생처">학생처</option>
							<option value="학사관리팀">학사관리팀</option>
					</select> <span id="departmentInput" class="validation-message"></span></td>
				</tr>
				<tr>
					<th>관리자권한</th>
					<td><input type="text" name="access_level" id="access"
						placeholder="1~3" class="form-control"> <span
						id="accessInput" class="validation-message"></span></td>
				</tr>
			</table>
			<br>
			<div id="submit-button-container" class="text-center">
				<button type="button" class="btn-submit"
					onclick="check(); return false;">회원가입</button>
			</div>
		</form>
	</div>



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
                    if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) {
                        extraRoadAddr += data.bname;
                    }
                    // 건물명이 있고, 공동주택일 경우 추가한다.
                    if (data.buildingName !== '' && data.apartment === 'Y') {
                        extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                    if (extraRoadAddr !== '') {
                        extraRoadAddr = ' (' + extraRoadAddr + ')';
                    }

                    // 우편번호와 주소 정보를 해당 필드에 넣는다.
                    document.getElementById('sample4_postcode').value = data.zonecode;
                    document.getElementById("sample4_roadAddress").value = roadAddr;
                    document.getElementById("sample4_jibunAddress").value = data.jibunAddress;

                    // 참고항목 문자열이 있을 경우 해당 필드에 넣는다.
                    if (roadAddr !== '') {
                        document.getElementById("sample4_extraAddress").value = extraRoadAddr;
                    } else {
                        document.getElementById("sample4_extraAddress").value = '';
                    }

                    var guideTextBox = document.getElementById("guide");
                    // 사용자가 '선택 안함'을 클릭한 경우, 예상 주소라는 표시를 해준다.
                    if (data.autoRoadAddress) {
                        var expRoadAddr = data.autoRoadAddress + extraRoadAddr;
                        guideTextBox.innerHTML = '(예상 도로명 주소 : ' + expRoadAddr + ')';
                        guideTextBox.style.display = 'block';

                    } else if (data.autoJibunAddress) {
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
	<script>
    const contextPath = '<%=request.getContextPath()%>';
	</script>
	<!-- 회원가입 유효성 검사 체크 -->
	<script src="<%=request.getContextPath()%>/js/join.js"></script>
</body>
</html>