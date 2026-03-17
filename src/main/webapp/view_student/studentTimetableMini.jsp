<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    String contextPath = request.getContextPath();
%>

<div class="mini-timetable-card">
    <div class="mini-timetable-header">
        <h3>주간 시간표</h3>
    </div>
    
    <p id="mini-timetable-empty-message" style="display:none; color:#666; margin-bottom:12px;">
        표시할 시간표가 없습니다.
    </p>

    <div class="mini-timetable-box">
        <table class="mini-timetable-table">
            <thead>
                <tr>
                    <th class="mini-period-col">교시</th>
                    <th class="mini-day-header" data-day="MON">월</th>
                    <th class="mini-day-header" data-day="TUE">화</th>
                    <th class="mini-day-header" data-day="WED">수</th>
                    <th class="mini-day-header" data-day="THU">목</th>
                    <th class="mini-day-header" data-day="FRI">금</th>
                </tr>
            </thead>
            <tbody>
                <% for (int i = 1; i <= 9; i++) { %>
                <tr>
                    <td class="mini-period-col"><%= i %></td>
                    <td id="mini_MON_<%= i %>" class="mini-cell" data-day="MON" data-period="<%= i %>"></td>
                    <td id="mini_TUE_<%= i %>" class="mini-cell" data-day="TUE" data-period="<%= i %>"></td>
                    <td id="mini_WED_<%= i %>" class="mini-cell" data-day="WED" data-period="<%= i %>"></td>
                    <td id="mini_THU_<%= i %>" class="mini-cell" data-day="THU" data-period="<%= i %>"></td>
                    <td id="mini_FRI_<%= i %>" class="mini-cell" data-day="FRI" data-period="<%= i %>"></td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<style>
.mini-timetable-card {
    width: 95%;
    max-width: 1000px;
    margin: 0 auto;	
    box-sizing: border-box;
}

.mini-timetable-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 12px;
}

.mini-timetable-header h3 {
    margin: 0;
    font-size: 30px;
    color: #222;
    font-weight: bold;
}

.mini-timetable-more {
    display: inline-block;
    padding: 7px 14px;
    border-radius: 6px;
    background-color: #2f6fed;
    color: #fff;
    text-decoration: none;
    font-size: 14px;
    font-weight: 500;
}

.mini-timetable-more:hover {
    background-color: #1f57c8;
    color: #fff;
}

.mini-timetable-box {
    width: 100%;
    overflow-x: auto;
    display: flex;
    justify-content: center;
}

.mini-timetable-table {
    width: 100%;
    max-width: 1000px;
    border-collapse: collapse;
    table-layout: fixed;
    background-color: #fff;
}

.mini-timetable-table th,
.mini-timetable-table td {
    border: 1px solid #bfc6cf;
    text-align: center;
    vertical-align: middle;
    height: 68px;
    padding: 8px 6px;
    font-size: 16px;
    transition: background-color 0.2s ease;
}

.mini-timetable-table th {
    background-color: #f7f8fb;
    font-weight: bold;
    font-size: 15px;
}

.mini-period-col {
    width: 52px;
    background-color: #fafafa;
    font-weight: bold;
    font-size: 15px;
}

.mini-subject {
    font-size: 14px;
    font-weight: bold;
    color: #333;
    line-height: 1.3;
}

/* 오늘 요일 헤더 */
.mini-day-header.today-header {
    background-color: #e9eff7;
    color: #223043;
}

/* 오늘 요일 전체 열 */
.mini-cell.today-column {
    background-color: #f6f9fd;
}

/* 오늘 요일 중 실제 수업 있는 칸 */
.mini-cell.today-has-class {
    background-color: #e2ebf7;
}

/* 현재 진행 중 교시 */
.mini-cell.current-class {
    background-color: #d4e2f5;
}
</style>	

<script>
    const contextPath = "<%=contextPath%>";
</script>
<script src="<%=contextPath%>/js/startcenterTimetable.js"></script>