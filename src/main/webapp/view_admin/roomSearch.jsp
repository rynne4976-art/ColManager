<%@page import="java.net.URLDecoder"%>
<%@ page import="Vo.ClassroomVo" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.ArrayList" %>

<%
    request.setCharacterEncoding("UTF-8");
    String contextPath = request.getContextPath();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>강의실 목록</title>

    <!-- Bootstrap CSS -->
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<%
	String message = (String) request.getAttribute("message");
	if (message != null) {
    	message = URLDecoder.decode(message, "UTF-8");
%>
        <script>
            alert('<%= message %>'); // 메시지를 알림으로 표시
        </script>
<%
    }
%>
    <style>
        body {
            background-color: #f0f2f5;
            font-family: 'Arial', sans-serif;
        }

        #classroom-list-container {
            max-width: 900px;
            background-color: #ffffff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0px 8px 16px rgba(0, 0, 0, 0.15);
            margin: 50px auto;
        }

        #classroom-list-title {
            font-size: 28px;
            font-weight: bold;
            color: #4a90e2;
            text-align: center;
            margin-bottom: 20px;
        }

        #classroom-list-table {
            width: 100%;
            margin: 20px 0;
            border-collapse: collapse;
        }

        #classroom-list-table th, #classroom-list-table td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: center;
            font-size: 14px;
        }

        #classroom-list-table th {
            background-color: #4a90e2;
            color: white;
            font-weight: bold;
        }

        #classroom-list-table tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        #classroom-list-table tr:hover {
            background-color: #f1f1f1;
        }

        .btn-link {
            color: #4a90e2;
            text-decoration: none;
            cursor: pointer;
        }
        .btn-link:hover {
            text-decoration: underline;
        }
        .action-link {
            font-weight: bold;
        }

        .form-check {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .form-check-label {
            margin-bottom: 0;
        }

        .capacity-input {
            width: 80px;
            text-align: center;
        }

        .equipment-options {
            text-align: left;
        }

        .equipment-display {
            display: block;
        }
    </style>
</head>
<body>
		<!-- 페이지 헤더 -->
	    <div class="text-center mb-4 mt-5">
	        <h1 class="display-6"><i class="fas fa-book" style="color: #4a90e2"></i> 강의실 목록</h1> <!-- 아이콘 변경 -->
	        <p class="lead">현재 강의실을 확인하실 수 있습니다.</p>
	    </div>
    <div id="classroom-list-container">
        <table id="classroom-list-table">
            <thead>
                <tr id="table-header">
                    <th id="header-room-id">강의실 ID</th>
                    <th id="header-capacity">수용 인원</th>
                    <th id="header-equipment">장비</th>
                    <th id="header-edit">수정</th>
                    <th id="header-delete">삭제</th>
                </tr>
            </thead>
            <tbody>
                <%
                    ArrayList<ClassroomVo> courseList = (ArrayList<ClassroomVo>) request.getAttribute("roomList");

                    if (courseList != null && !courseList.isEmpty()) {
                        for (ClassroomVo classroom : courseList) {
                %>
                <tr id="row-<%= classroom.getRoom_id() %>" class="classroom-row">
                    <td class="room-id"><%= classroom.getRoom_id() %></td>
                    <td class="capacity">
                        <input type="number" class="capacity-input" id="capacity-<%= classroom.getRoom_id() %>" value="<%= classroom.getCapacity() %>" disabled>
                    </td>
                    <td class="equipment">
                        <div id="equipment-options-<%= classroom.getRoom_id() %>" class="equipment-options" style="display: none;">
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="checkbox" id="equipment1-<%= classroom.getRoom_id() %>" value="프로젝터">
                                <label class="form-check-label" for="equipment1-<%= classroom.getRoom_id() %>">프로젝터</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="checkbox" id="equipment2-<%= classroom.getRoom_id() %>" value="화이트보드">
                                <label class="form-check-label" for="equipment2-<%= classroom.getRoom_id() %>">화이트보드</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="checkbox" id="equipment3-<%= classroom.getRoom_id() %>" value="실험 장비">
                                <label class="form-check-label" for="equipment3-<%= classroom.getRoom_id() %>">실험 장비</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="checkbox" id="equipment4-<%= classroom.getRoom_id() %>" value="컴퓨터실">
                                <label class="form-check-label" for="equipment4-<%= classroom.getRoom_id() %>">컴퓨터실</label>
                            </div>
                        </div>
                        <span id="equipment-display-<%= classroom.getRoom_id() %>" class="equipment-display"><%= classroom.getEquipment() %></span>
                    </td>
                    <td class="edit-action">
                        <a class="btn-link action-link" href="javascript:void(0);" id="edit-btn-<%= classroom.getRoom_id() %>" onclick="enableEdit('<%= classroom.getRoom_id() %>')">수정</a>
                        <a class="btn-link action-link" href="javascript:void(0);" id="complete-btn-<%= classroom.getRoom_id() %>" onclick="updateRoom('<%= classroom.getRoom_id() %>')" style="display: none;">완료</a>
                    </td>
                    <td class="delete-action">
                        <a class="btn-link action-link" href="javascript:void(0);" onclick="deleteRoom('<%= classroom.getRoom_id() %>')">삭제</a>
                    </td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr id="no-data-row">
                    <td colspan="5">조회할 강의실 정보가 없습니다.</td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>

    <script>
        function enableEdit(roomId) {
            $("#capacity-" + roomId).prop("disabled", false);
            $("#equipment-options-" + roomId).show();
            $("#equipment-display-" + roomId).hide();
            $("#edit-btn-" + roomId).hide();
            $("#complete-btn-" + roomId).show();
        }

        function updateRoom(roomId) {
            var capacity = $("#capacity-" + roomId).val();
            var equipment = [];
            $("#equipment-options-" + roomId + " input:checked").each(function() {
                equipment.push($(this).val());
            });

            $.ajax({
                url: "<%=contextPath%>/classroom/updateRoom.do",
                method: "POST",
                data: {
                    room_id: roomId,
                    capacity: capacity,
                    equipment: equipment.join(",")
                },
                success: function(response) {
                    if (response === "success") {
                        alert("강의실 정보가 수정되었습니다.");
                        $("#capacity-" + roomId).prop("disabled", true);
                        $("#equipment-options-" + roomId).hide();
                        $("#equipment-display-" + roomId).text(equipment.join(", ")).show();
                        $("#edit-btn-" + roomId).show();
                        $("#complete-btn-" + roomId).hide();
                    } else {
                        alert("수정 실패");
                    }
                },
                error: function() {
                    alert("오류 발생");
                }
            });
        }

        function deleteRoom(roomId) {
            if (!confirm("강의실을 삭제하시겠습니까?")) return;

            $.ajax({
                url: "<%=contextPath%>/classroom/deleteRoom.do",
                method: "POST",
                data: { room_id: roomId },
                success: function(response) {
                    if (response === "success") {
                        alert("강의실이 삭제되었습니다.");
                        $("#row-" + roomId).remove();
                    } else {
                        alert("삭제 실패");
                    }
                },
                error: function() {
                    alert("오류 발생");
                }
            });
        }
    </script>
</body>
</html>
