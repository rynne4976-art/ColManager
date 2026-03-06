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
    <title>학사 일정</title>
    <!-- jQuery 최신 버전 추가 -->
    <script src="https://code.jquery.com/jquery-latest.min.js"></script>
    <!-- Bootstrap CSS -->
    <!-- <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet" > -->
    <!-- <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet"> -->
    <link href="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.css" rel="stylesheet"> <!-- 달력구조 -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script> <!-- 달력구조 -->
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.js"></script> <!-- 달력구조 -->
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/locales-all.min.js"></script> <!-- 한/영 -->
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

    
    <style>
        body, html {
            height: 100%;
            margin: 0;
            padding: 0;
            font-family: 'Arial', sans-serif;
        }
        #calendar-container {
            max-width: 895px;
            background-color: #ffffff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0px 8px 16px rgba(0, 0, 0, 0.15);
            margin: 50px auto;
        }
        #calendar-title {
            font-size: 28px;
            font-weight: bold;
            color: #4a90e2;
            text-align: center;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div id="calendar-container">
        <h2 id="calendar-title"><i class="fas fa-calendar-check"></i> 학사 일정</h2>
        <div id="calendar"></div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // 캘린더를 표시할 요소를 선택하고 FullCalendar 초기화
            const calendarEl = document.getElementById('calendar');
            const calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: 'dayGridMonth', // 기본 보기 형식 설정 (월간 보기)
                headerToolbar: {
                    left: 'prev today', // 이전, 다음, 오늘 버튼 표시
                    center: 'title', // 캘린더 제목을 중앙에 표시
                    right: 'next'
                },
                locale: 'ko', // 한국어 로케일 설정
                events: function(fetchInfo, successCallback, failureCallback) {
                    // 서버로부터 이벤트 데이터를 가져오는 함수
                    $.ajax({
                        url: '<%=contextPath%>/Board/boardCalendar.do', // 이벤트 데이터를 가져올 URL
                        type: 'GET',
                        dataType: 'json',
                        data: {
                            start: fetchInfo.startStr, // 요청할 이벤트의 시작 날짜
                            end: fetchInfo.endStr, // 요청할 이벤트의 종료 날짜
                            action: 'getEvents' // 서버에서의 동작 지정
                        },
                        success: function(response) {
                            successCallback(response);
                        },
                        error: function(xhr, status, error) {
                            console.error('이벤트 데이터를 불러오는 중 오류 발생:', error); // 오류 로그 출력
                            failureCallback(); // 이벤트 로드 실패 콜백 호출
                            alert('일정 데이터를 불러오는 데 실패했습니다. 나중에 다시 시도해주세요.'); // 사용자에게 오류 알림
                        }
                    });
                },
                eventClick: function(info) {
                    // 일정 클릭 시 일정의 제목과 설명을 알림창으로 표시
                    alert('일정: ' + info.event.title + '\n설명: ' + info.event.extendedProps.description);
                },
                height: 'auto' // 캘린더의 높이를 자동으로 설정하여 컨테이너에 맞춤
            });
            calendar.render(); // 캘린더 렌더링
        });
    </script>
</body>
</html>
