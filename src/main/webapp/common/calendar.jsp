<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    String contextPath = request.getContextPath();
%>

<style>
#calendar-container {
	max-width: 895px;
	background-color: #ffffff;
	padding: 30px;
	border-radius: 12px;
	box-shadow: 0px 8px 16px rgba(0, 0, 0, 0.15);
	margin: 0 auto;
}

#calendar-title {
	font-size: 28px;
	font-weight: bold;
	color: #4a90e2;
	text-align: center;
	margin-bottom: 20px;
}
</style>

<div id="calendar-container">
	<h2 id="calendar-title">
		<i class="fas fa-calendar-check"></i> 학사 일정
	</h2>
	<div id="calendar"></div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function () {
	const calendarEl = document.getElementById('calendar');

	if (!calendarEl) {
		console.error('calendar 요소를 찾을 수 없습니다.');
		return;
	}

	// 중복 초기화 방지
	if (calendarEl.dataset.initialized === 'true') {
		return;
	}
	calendarEl.dataset.initialized = 'true';

	const calendar = new FullCalendar.Calendar(calendarEl, {
		initialView: 'dayGridMonth',
		headerToolbar: {
			left: 'prev today',
			center: 'title',
			right: 'next'
		},
		locale: 'ko',
		events: function(fetchInfo, successCallback, failureCallback) {
			$.ajax({
				url: '<%=contextPath%>/Board/boardCalendar.do',
				type: 'GET',
				dataType: 'json',
				data: {
					start: fetchInfo.startStr,
					end: fetchInfo.endStr,
					action: 'getEvents'
				},
				success: function(response) {
					successCallback(response);
				},
				error: function(xhr, status, error) {
					console.error('이벤트 데이터를 불러오는 중 오류 발생:', error);
					failureCallback(error);
					alert('일정 데이터를 불러오는 데 실패했습니다. 나중에 다시 시도해주세요.');
				}
			});
		},
		eventClick: function(info) {
			alert(
				'일정: ' + info.event.title +
				'\n설명: ' + (info.event.extendedProps.description || '')
			);
		},
		height: 'auto'
	});

	calendar.render();
});
</script>