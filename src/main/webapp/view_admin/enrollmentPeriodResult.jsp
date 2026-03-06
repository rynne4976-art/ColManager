<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% String contextPath = (String)request.getContextPath(); %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>수강신청 기간 설정 결과</title>

    <!-- Bootstrap CSS -->
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

    <style>
        body {
            background-color: #f9f9f9;
            font-family: 'Arial', sans-serif;
        }

        .result-container {
            max-width: 600px;
            margin: 50px auto;
            background-color: #ffffff;
            border-radius: 12px;
            box-shadow: 0px 8px 16px rgba(0, 0, 0, 0.15);
            overflow: hidden;
        }

        .result-header {
            background-color: #4a90e2;
            color: white;
            padding: 20px;
            text-align: center;
            font-size: 18px;
            font-weight: bold;
        }

        .result-body {
            padding: 20px;
        }

        .result-list {
            list-style-type: none;
            padding: 0;
        }

        .result-list li {
            margin-bottom: 10px;
            font-size: 14px;
        }

        .btn-primary {
            background-color: #4a90e2;
            border: none;
            padding: 10px;
            font-size: 14px;
            font-weight: bold;
            transition: background-color 0.3s ease;
        }

        .btn-primary:hover {
            background-color: #357abd;
        }
    </style>
</head>
<body>
    <div class="container result-container">
        <div class="result-header">
            <i class="fas fa-check-circle"></i> 수강신청 기간 설정 결과
        </div>
        <div class="result-body">
            <h4 class="text-center mb-4">${message}</h4>

            <!-- 설정된 수강신청 기간 표시 -->
            <c:if test="${not empty startDate}">
                <p class="text-muted">설정된 수강신청 기간:</p>
                <ul class="result-list">
                    <li><strong>시작 날짜:</strong> ${startDate}</li>
                    <li><strong>종료 날짜:</strong> ${endDate}</li>
                    <li><strong>설명:</strong> ${description}</li>
                </ul>
            </c:if>

            <!-- 다시 설정하기 버튼 -->
            <div class="text-center mt-4">
                <a href="<%=contextPath %>/classroom/enrollmentPeriodPage.bo" class="btn btn-primary">
                    <i class="fas fa-redo"></i> 다시 설정하기
                </a>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
