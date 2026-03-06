<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8"> 
<title>일정 관리 페이지</title>
<head>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

<!-- jQuery 최신 버전 추가 -->
<script src="https://code.jquery.com/jquery-latest.min.js"
	crossorigin="anonymous"></script>
<!-- Bootstrap CSS -->
<link
	href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css"
	rel="stylesheet">
<!-- Font Awesome -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<!-- 외부 CSS 파일 연결 -->
<link rel="stylesheet" type="text/css"
	href="<%=contextPath%>/css/majorCSS.css">
<style>
body, html {
	height: 100%;
	margin: 0;
	padding: 0;
	font-family: 'Arial', sans-serif;
}

#schedule-container {
	max-width: 900px;
	background-color: #ffffff;
	padding: 30px;
	border-radius: 12px;
	box-shadow: 0px 8px 16px rgba(0, 0, 0, 0.15);
	margin: 50px auto;
}

#schedule-title {
	font-size: 28px;
	font-weight: bold;
	color: #4a90e2;
	text-align: center;
	margin-bottom: 20px;
}

table.table-bordered {
	width: 100%;
	margin-top: 20px;
	border-collapse: collapse;
}

table.table-bordered th, table.table-bordered td {
	padding: 12px;
	text-align: left;
	border: 1px solid #ddd;
}

table.table-bordered th {
	background-color: #f7f7f7;
	font-weight: bold;
	color: #333;
}

input[type="text"] {
	width: 12ch;
}

textarea {
	width: 28ch;
	height: 3.5ch;
	padding: 0;
	margin: 0;
}

input[type="date"], textarea, input[type="text"] {
	padding: 0;
	margin: 0;
}

#title{
	width : 100%;
}

</style>
</head>
<body>
	<div id="schedule-container">
		<h2 id="schedule-title"><i class="fas fa-calendar-plus"></i> 일정 관리</h2>

		<!-- 일정 추가 폼 -->
		<form id="scheduleForm" action="<%=contextPath%>/Board/addSchedule"
			method="post">
			<div class="form-group">
				<label for="title">일정 제목:</label> <input type="text" id="title" name="title" class="form-control" required>
			</div>
			<div class="form-group">
				<label for="startDate">시작 일자:</label> <input type="date"
					id="startDate" name="startDate" class="form-control" required>
			</div>
			<div class="form-group">
				<label for="endDate">마침 일자:</label> <input type="date" id="endDate"
					name="endDate" class="form-control" required>
			</div>
			<div class="form-group">
				<label for="content">일정 내용:</label>
				<textarea id="content" name="content" class="form-control" required></textarea>
			</div>
			<input type="submit" value="추가" class="btn"
				style="background-color: #4a90e2; color: white;">
		</form>

		<h3 class="text-center mt-5">일정 목록</h3>
		<!-- 조회할 달 선택 폼 -->
		<form action="<%=contextPath%>/Board/viewSchedule.bo?" method="get"
			class="form-inline justify-content-center mt-3">
			<label for="month" class="mr-2">조회할 달:</label> <input type="month"
				id="month" name="month" class="form-control mr-2" required
				value="<%=request.getParameter("month") != null ? request.getParameter("month") : ""%>">
			<input type="submit" value="조회" class="btn"
				style="background-color: #4a90e2; color: white;">
		</form>

		<form action="<%out.print(contextPath);%>/Board/deleteSchedule"
			method="post" class="mt-4">
			<input type="hidden" name="month"
				value="<%=request.getParameter("month") != null ? request.getParameter("month") : ""%>">
			<table class="table table-bordered">
				<thead>
					<tr>
						<th>선택</th>
						<th>일정 제목</th>
						<th>시작 일자</th>
						<th>마침 일자</th>
						<th>일정 내용</th>
						<th>수정</th>
					</tr>
				</thead>
				<tbody>
					<c:choose>
						<c:when test="${not empty scheduleList}">
							<c:forEach var="schedule" items="${scheduleList}">
								<tr>
									<td><input type="checkbox" name="deleteIds"
										value="${schedule.schedule_id}"></td>
									<td>${schedule.event_name}</td>
									<td>${schedule.start_date}</td>
									<td>${schedule.end_date}</td>
									<td>${schedule.description}</td>
									<td><a href="javascript:void(0);"
										onclick="enableEdit(this.parentElement.parentElement);">수정</a></td>
								</tr>
							</c:forEach>

						</c:when>
						<c:otherwise>
							<tr>
								<td colspan="6" style="text-align: center;">일정이 속한 달을 선택하고
									조회해주세요!</td>
							</tr>
						</c:otherwise>
					</c:choose>
				</tbody>
			</table>
			<input type="button" value="선택된 일정 삭제" onclick="deleteSchedules();"
				class="btn btn-danger">
		</form>
	</div>

	<script>
        document.getElementById('scheduleForm').addEventListener('submit', function(event) {
            const title = document.getElementById('title').value.trim();
            const startDate = document.getElementById('startDate').value;
            const endDate = document.getElementById('endDate').value;

            if (!title || !startDate || !endDate) {
                alert('일정 제목, 시작 일자 및 마침 일자는 필수 입력 사항입니다.');
                event.preventDefault(); // 폼 제출 취소
            }
        });
        
        function enableEdit(row) {
            const cells = row.getElementsByTagName("td");
            const originalValues = [];

            // 임시로 값을 저장하고 input 태그로 변환
            for (let i = 1; i < cells.length - 1; i++) {
                const value = cells[i].innerText;
                originalValues.push(value);
                cells[i].innerHTML = '';
                if (i === 4) {
                    const textarea = document.createElement('textarea');
                    textarea.value = value;
                    cells[i].appendChild(textarea);
                } else if (i === 2 || i === 3) {
                    const input = document.createElement('input');
                    input.type = 'date';
                    input.value = value;
                    cells[i].appendChild(input);
                } else {
                    const input = document.createElement('input');
                    input.type = 'text';
                    input.value = value;
                    cells[i].appendChild(input);
                }
            }

            const editLink = cells[cells.length - 1].getElementsByTagName("a")[0];
            editLink.innerText = "저장";
            editLink.href = "javascript:void(0);";
            editLink.onclick = function () { saveEdit(row, originalValues); };
        }

        function saveEdit(row, originalValues) {
            const cells = row.getElementsByTagName("td");
            const scheduleId = row.querySelector("input[type='checkbox']").value;
            const updatedData = {
                schedule_id: scheduleId,
                title: cells[1].getElementsByTagName("input")[0].value,
                startDate: cells[2].getElementsByTagName("input")[0].value,
                endDate: cells[3].getElementsByTagName("input")[0].value,
                content: cells[4].getElementsByTagName("textarea")[0].value
            };

            const currentMonth = document.getElementById('month').value;

            const form = document.createElement('form');
            form.method = 'post';
            form.action = '<%=contextPath%>/Board/updateSchedule';
            for (const key in updatedData) {
                if (updatedData.hasOwnProperty(key)) {
                    const hiddenField = document.createElement('input');
                    hiddenField.type = 'hidden';
                    hiddenField.name = key;
                    hiddenField.value = updatedData[key];
                    form.appendChild(hiddenField);
                }
            }

            const monthField = document.createElement('input');
            monthField.type = 'hidden';
            monthField.name = 'month';
            monthField.value = currentMonth;
            form.appendChild(monthField);

            document.body.appendChild(form);
            form.submit();
        }

        function deleteSchedules() {
            const checkboxes = document.querySelectorAll('input[name="deleteIds"]:checked');
            const deleteIds = Array.from(checkboxes).map(cb => cb.value);

            if (deleteIds.length === 0) {
                alert('삭제할 일정이 선택되지 않았습니다.');
                return;
            }

            if (!confirm('선택된 일정을 삭제하시겠습니까?')) {
                return;
            }

            const currentMonth = document.getElementById('month').value;

            const params = new URLSearchParams();
            deleteIds.forEach(id => params.append('deleteIds', id));
            params.append('month', currentMonth);

            fetch('<%=contextPath%>/Board/deleteSchedule', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: params.toString()
            })
            .then(response => {
                if (response.ok) {
                    window.location.href = "<%=contextPath%>/Board/viewSchedule.bo?center=/view_admin/calendarEdit.jsp&month=" + encodeURIComponent(currentMonth);
                } else {
                    alert('일정 삭제 중 오류가 발생했습니다.');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('일정 삭제 중 오류가 발생했습니다.');
            });
        }
    </script>
</body>
</html>
