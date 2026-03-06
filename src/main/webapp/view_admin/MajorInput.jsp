<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    String contextPath = request.getContextPath();
%>

<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <title>New Major Input Page</title>
     <!-- 외부 CSS 파일 연결 -->
    <link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/majorCSS.css">
    <!-- Bootstrap CSS -->
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body {
            background-color: #f0f2f5;
            font-family: 'Arial', sans-serif;
        }
        #major-container {
            max-width: 900px;
            background-color: #ffffff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0px 8px 16px rgba(0, 0, 0, 0.15);
            margin: 50px auto;
        }
        #major-title {
            font-size: 28px;
            font-weight: bold;
            color: #4a90e2;
            text-align: center;
            margin-bottom: 20px;
        }
        #major-form {
            margin-bottom: 30px;
        }
        #major-form label {
            font-weight: bold;
        }
        #major-form input[type="text"],
        #major-form input[type="tel"],
        #major-form input[type="submit"] {
            width: 100%;
            padding: 10px;
            margin-top: 10px;
            border-radius: 8px;
            border: 1px solid #ccc;
            box-sizing: border-box;
        }
        #major-form input[type="submit"] {
            background-color: #4a90e2;
            color: white;
            border: none;
            cursor: pointer;
        }
        #major-form input[type="submit"]:hover {
            background-color: #3a78c2;
        }
        #major-table {
            width: 100%;
            margin-top: 20px;
            border-collapse: collapse;
        }
        #major-table th, #major-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        #major-table th {
            background-color: #f7f7f7;
            font-weight: bold;
            color: #333;
        }
        #major-table tr:hover {
            background-color: #f1f1f1;
        }
        #major-count {
            text-align: center;
            margin-top: 20px;
            font-size: 18px;
            color: #4a90e2;
        }
    </style>
    <script type="text/javascript">
        window.onload = function () {
            inputResult();  
            loadMajorData(); // 페이지 로드 시 학과 데이터 로드
        };

        // form 제출 핸들러
        function handleSubmit() {
            
            return validateForm(); // validateForm()의 결과에 따라 제출 여부 결정
        }
        
        // controller에서 받는 값 처리 함수
        function inputResult() {
            var addResult = parseInt(${addResult}, 10);
            if (isNaN(addResult)) return;

            switch (addResult) {
                case 0:
                    alert("데이터베이스에 추가하는 데 실패했습니다. 다시 시도해 주세요.");
                    break;
                case 1:
                    alert("학과가 성공적으로 추가되었습니다.");
                    break;
                case -2:
                    alert("이미 존재하는 학과명입니다.");
                    break;
                default:
                	break;
            }
        }

        // AJAX를 사용해 학과 데이터를 로드하는 함수
        let isLoading = false;
        function loadMajorData() {
            if (isLoading) return;
            isLoading = true;

            var xhr = new XMLHttpRequest();
            var contextPath = "<%=request.getContextPath()%>";

            xhr.open("GET", contextPath + "/major/fetchMajorData", true);
            xhr.onreadystatechange = function() {
                if (xhr.readyState == 4) {
                    isLoading = false;
                    if (xhr.status == 200) {
                        let data = JSON.parse(xhr.responseText);
                        console.log(data); // 서버에서 받아온 데이터 출력
                        updateMajorTable(data);
                    } else {
                        console.error("데이터 로드 중 오류 발생: " + xhr.status);
                    }
                }
            };
            xhr.send();
        }

        function updateMajorTable(data) {
            let tbody = document.querySelector("#major-table tbody");
            tbody.innerHTML = "";

            data.forEach(function(major) {
                let row = tbody.insertRow();
                let majorcode = major.majorcode;
                row.insertCell(0).innerText = majorcode;
                row.insertCell(1).innerText = major.majorname;
                row.insertCell(2).innerText = major.majortel;
            });
            updateMajorCount(tbody.querySelectorAll("tr").length);
        }

        function updateMajorCount(totalMajor) {
            const tfoot = document.querySelector("#major-table tfoot");
            if (totalMajor > 0) {
                tfoot.innerHTML = "<tr><th colspan='4'>조은대학교에는 총 " + totalMajor + "개의 학과가 있습니다!</th></tr>";
            } else {
                tfoot.innerHTML = `<tr><th colspan='4'>학과 정보가 없습니다!</th></tr>`;
            }
        }
    </script>
</head>

<body>
    <div id="major-container">
        <h2 id="major-title"><i class="fas fa-plus"></i> 신규 학과 추가</h2>
        <form id="major-form" action="<%=contextPath%>/major/MajorInput.do" method="post" onsubmit="return validateForm()">
            <label for="MajorNameInput">신규 학과명:</label>
            <input type="text" id="MajorNameInput" name="MajorNameInput" placeholder="**학과" required="required">
            <label for="MajorTelInput">학과 사무실 전화번호:</label>
            <input type="tel" id="MajorTelInput" name="MajorTelInput" placeholder="02-123-1234">
            <input type="submit" value="제출">
        </form>
    
        <h3 id="major-table-title" style="text-align: center;">학과 목록</h3>
        <table id="major-table" class="table table-striped">
            <thead>
                <tr>
                    <th>학과 코드</th>
                    <th>학과명</th>
                    <th>학과 사무실 전화번호</th>
                </tr>
            </thead>
            <tbody>
                <!-- 학과 데이터는 JavaScript를 통해 동적으로 추가될 예정 -->
            </tbody>
            <tfoot>
                <tr>
                    <th colspan="3" id="major-count">학과 정보가 없습니다!</th>
                </tr>
            </tfoot>
        </table>
    </div>

    <script>
        // 전화번호 유효성 검사
        function validateForm() {
            const telNumber = document.getElementById("MajorTelInput").value;
            const telRegex = /^\d{2,3}-\d{3,4}-\d{4}$/;

            if (!telRegex.test(telNumber)) {
                alert("유효한 전화번호 형식을 입력해 주세요. 예: 02-123-1234");
                return false;
            }
            return true;
        }

        function openCustomPopup(url) {
            // 팝업창을 띄울 때, 크기와 설정을 세밀히 조정합니다.
            const popupOptions = [ 'width=440', // 팝업 너비
            'height=700', // 팝업 높이
            'toolbar=no', // 툴바 표시 여부 (없음)
            'menubar=no', // 메뉴바 표시 여부 (없음)
            'scrollbars=yes', // 스크롤바 표시 (있음)
            'resizable=no', // 창 크기 조절 가능 여부 (없음)
            'location=yes', // 주소 표시 여부 (있음)
            'status=no' // 상태바 표시 여부 (없음)
            ].join(',');

            // 팝업창 열기
            window.open(url, 'editMajorPopup', popupOptions);
        }
    </script>
</body>

</html>
