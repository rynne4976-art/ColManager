<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    String contextPath = request.getContextPath();
%>
<div class="student-classroom-wrap">
    <div class="text-center mb-4">
        <h1 class="display-4"><i class="fas fa-calendar-alt"></i>  주간 시간표</h1>
    </div>
	<div class="timetable-card">
	    
	    <p id="timetable-empty-message" style="display:none; color:#666; margin-bottom:15px;">
	        현재 표시할 시간표가 없습니다.
	    </p>
	
	    <div class="student-timetable-box">
	        <table class="student-timetable-table">
	            <thead>
	                <tr>
	                    <th class="period-col">교시</th>
	                    <th class="day-header" data-day="MON">월</th>
	                    <th class="day-header" data-day="TUE">화</th>
	                    <th class="day-header" data-day="WED">수</th>
	                    <th class="day-header" data-day="THU">목</th>
	                    <th class="day-header" data-day="FRI">금</th>
	                </tr>
	            </thead>
	            <tbody>
	                <% for (int i = 1; i <= 9; i++) { %>
	                <tr>
	                    <td class="period-col"><%= i %>교시</td>
	                    <td id="MON_<%= i %>" class="timetable-cell" data-day="MON" data-period="<%= i %>"></td>
	                    <td id="TUE_<%= i %>" class="timetable-cell" data-day="TUE" data-period="<%= i %>"></td>
	                    <td id="WED_<%= i %>" class="timetable-cell" data-day="WED" data-period="<%= i %>"></td>
	                    <td id="THU_<%= i %>" class="timetable-cell" data-day="THU" data-period="<%= i %>"></td>
	                    <td id="FRI_<%= i %>" class="timetable-cell" data-day="FRI" data-period="<%= i %>"></td>
	                </tr>
	                <% } %>
	            </tbody>
	        </table>
	    </div>
	</div>
</div>

<style>
.student-timetable-wrap {
    width: 100%;
    padding: 20px;
    box-sizing: border-box;
}

.student-timetable-title {
    margin-bottom: 20px;
    font-size: 28px;
    font-weight: bold;
    color: #222;
}

.student-timetable-box {
    width: 100%;
    overflow-x: auto;
}

.student-timetable-table {
    width: 100%;
    border-collapse: collapse;
    table-layout: fixed;
    background-color: #fff;
}

.student-timetable-table th,
.student-timetable-table td {
    border: 1px solid #dcdcdc;
    text-align: center;
    vertical-align: middle;
    height: 80px;
    padding: 8px;
    font-size: 14px;
    transition: background-color 0.2s ease, box-shadow 0.2s ease;
}

.student-timetable-table th {
    background-color: #f5f7fa;
    font-weight: bold;
}

.period-col {
    width: 80px;
    background-color: #fafafa;
    font-weight: bold;
}

.subject {
    font-weight: bold;
    color: #222;
    margin-bottom: 6px;
}

.room {
    font-size: 12px;
    color: #555;
    margin-bottom: 4px;
}

.professor, .prof {
    font-size: 12px;
    color: #777;
}

/* 오늘 요일 헤더 */
.day-header.today-header {
    background-color: #e9eef5;
    color: #223043;
}

.timetable-cell.today-column {
    background-color: #f7f9fc;
}

.timetable-cell.today-has-class {
    background-color: #eef3f8;
    box-shadow: inset 0 0 0 1px #d6dee8;
}

.timetable-cell.current-class {
    background-color: #e3ebf5;
    box-shadow: inset 0 0 0 2px #b8c7da;
}

.timetable-cell:hover {
    background-color: #f0f4fa;
}
</style>

<script>
    const contextPath = "<%=contextPath%>";
</script>
<script src="<%=contextPath%>/js/studentTimetable.js"></script>