<%@page import="Vo.StudentVo"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>학생 정보 수정</title>
    <!-- Bootstrap CSS -->
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body {
            background-color: #f0f2f5;
            font-family: 'Arial', sans-serif;
        }
        #student-edit-container {
            max-width: 900px;
            background-color: #ffffff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0px 8px 16px rgba(0, 0, 0, 0.15);
            margin: 50px auto;
        }
        #student-edit-title {
            font-size: 28px;
            font-weight: bold;
            color: #4a90e2;
            text-align: center;
            margin-bottom: 20px;
        }
        #student-edit-table {
            width: 100%;
            margin: 20px 0;
            border-collapse: collapse;
        }
        #student-edit-table th, #student-edit-table td {
            border: none;
            padding: 12px;
            font-size: 14px;
        }
        #student-edit-table th {
            text-align: left;
            width: 30%;
            font-weight: bold;
            color: #333;
        }
        #student-edit-table td {
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
        input[readonly] {
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
            margin-top: 10px;
        }
    </style>
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
        
        function validatePhone(input) {
            input.value = input.value.replace(/[^0-9]/g, '');
        }

        function validateEmail(input) {
            const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailPattern.test(input.value)) {
                alert("올바른 이메일 형식을 입력해주세요.");
                input.focus();
            }
        }  
    </script>
</head>
<body>
    <div id="student-edit-container">
        <h2 id="student-edit-title"><i class="fas fa-edit"></i> 학생 정보 수정</h2>


        <%
            StudentVo student = (StudentVo) request.getAttribute("student");
        %>

        <form action="${pageContext.request.contextPath}/student/updateStudent.do" method="post">
            <table id="student-edit-table">
                <tr>
                    <th><label for="student_id">학 생 I D:</label></th>
                    <td><input type="text" id="student_id" name="student_id" value="<%= student.getStudent_id() %>" readonly></td>
                </tr>
                <tr>
                    <th><label for="user_id">사 용 자 I D:</label></th>
                    <td><input type="text" id="user_id" name="user_id" value="<%= student.getUser_id() %>" readonly></td>
                </tr>
                <tr>
                    <th><label for="user_pw">비밀번호:</label></th>
                    <td><input type="text" id="user_pw" name="user_pw" value="<%= student.getUser_pw() %>" required placeholder="수정할 비밀번호 입력"></td>
                </tr>
                <tr>
                    <th><label for="user_name">이름:</label></th>
                    <td><input type="text" id="user_name" name="user_name" value="<%= student.getUser_name() %>" required placeholder="수정할 이름 입력"></td>
                </tr>
                <tr>
                    <th><label for="birthDate">생년월일:</label></th>
                    <td><input type="date" id="birthDate" name="birthDate" value="<%= student.getBirthDate() %>" readonly></td>
                </tr>
                <tr>
                    <th><label for="gender">성별:</label></th>
                    <td>
                        <select id="gender" name="gender" required>
                            <option value="남" <%= "남".equals(student.getGender()) ? "selected" : "" %>>남</option>
                            <option value="여" <%= "여".equals(student.getGender()) ? "selected" : "" %>>여</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th><label for="address">주소:</label></th>
                    <td>
                        <div style="display: flex; align-items: center;">
                            <input type="text" id="address" name="address" value="<%= student.getAddress() %>" required placeholder="우편번호로 검색 후 상세주소도 이어서 입력" style="flex: 1;">
                            <input type="button" onclick="sample4_execDaumPostcode()" value="우편번호 찾기" style="margin-left: 5px;">
                        </div>
                    </td>
                </tr>
                <tr>
                    <th><label for="phone">전화번호:</label></th>
                    <td><input type="text" id="phone" name="phone" value="<%= student.getPhone() %>" placeholder="-없이 입력" oninput="validatePhone(this)" required></td>
                </tr>
                <tr>
                    <th><label for="email">이메일:</label></th>
                    <td><input type="email" id="email" name="email" value="<%= student.getEmail() %>" placeholder="이메일양식 확인 후 입력" onchange="validateEmail(this)" required></td>
                </tr>
                <tr>
                    <th><label for="role">역할:</label></th>
                    <td><input type="text" id="role" name="role" value="<%= student.getRole() %>" readonly></td>
                </tr>
                <tr>
                    <th><label for="majorcode">학 과 번 호:</label></th>
                    <td><input type="text" id="majorcode" name="majorcode" value="<%= student.getMajorcode() %>" required placeholder="정확한 학과번호"></td>
                </tr>
                <tr>
                    <th><label for="grade">학 년:</label></th>
                    <td><input type="number" id="grade" name="grade" min="1" max="4" value="<%= student.getGrade() %>" required></td>
                </tr>
                <tr>
                    <th><label for="admission_date">입 학 일:</label></th>
                    <td><input type="date" id="admission_date" name="admission_date" value="<%= student.getAdmission_date() %>" readonly></td>
                </tr>
                <tr>
                    <th><label for="status">상 태:</label></th>
                    <td>
                        <select id="status" name="status" required>
                            <option value="재학" <%= "재학".equals(student.getStatus()) ? "selected" : "" %>>재학</option>
                            <option value="휴학" <%= "휴학".equals(student.getStatus()) ? "selected" : "" %>>휴학</option>
                            <option value="졸업" <%= "졸업".equals(student.getStatus()) ? "selected" : "" %>>졸업</option>
                            <option value="자퇴" <%= "자퇴".equals(student.getStatus()) ? "selected" : "" %>>자퇴</option>
                        </select>
                    </td>
                </tr>
            </table>
            <div class="btn-container">
                <input type="submit" value="수정 완료">
            </div>
        </form>
    </div>
</body>
</html>