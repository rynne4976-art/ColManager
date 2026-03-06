<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> <!-- JSP 페이지 설정 -->
<% 
    String contextPath = (String)request.getContextPath(); // 애플리케이션의 컨텍스트 경로
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"> <!-- 문서 인코딩 설정 -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0"> <!-- 반응형 웹 디자인 -->
    <title>수강신청 기간 설정</title> <!-- 페이지 제목 -->

    <!-- Bootstrap CSS 연결 -->
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet"> <!-- Bootstrap 스타일 적용 -->

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"> <!-- 아이콘 사용 -->

    <style>
        body {
            background-color: #f9f9f9; /* 배경색 설정 */
            font-family: 'Arial', sans-serif; /* 기본 글꼴 설정 */
        }

        .form-container {
            max-width: 500px; /* 폼의 최대 너비 설정 */
            margin: 50px auto; /* 중앙 정렬 */
            background-color: #ffffff; /* 카드 배경색 */
            border-radius: 12px; /* 둥근 모서리 */
            box-shadow: 0px 8px 16px rgba(0, 0, 0, 0.15); /* 그림자 효과 */
            overflow: hidden; /* 내부 콘텐츠 넘침 방지 */
        }

        .form-header {
            background-color:white; /* 헤더 배경색 */
            color:  #4a90e2; /* 헤더 텍스트 색상 */
            padding: 15px; /* 내부 여백 */
            text-align: center; /* 텍스트 중앙 정렬 */
            font-size: 18px; /* 텍스트 크기 */
            font-weight: bold; /* 텍스트 굵기 */
        }

        .form-body {
            padding: 20px; /* 본문 내부 여백 */
        }

        .form-label {
            font-size: 14px; /* 라벨 글자 크기 */
            font-weight: bold; /* 굵은 글꼴 */
            color: #333; /* 라벨 색상 */
        }

        .form-control {
            font-size: 14px; /* 입력 필드 글자 크기 */
            border-radius: 5px; /* 둥근 모서리 */
        }

        .btn-primary {
            background-color: #4a90e2; /* 기본 버튼 색상 */
            border: none; /* 테두리 제거 */
            padding: 10px; /* 패딩 설정 */
            font-size: 14px; /* 버튼 글자 크기 */
            font-weight: bold; /* 버튼 텍스트 굵기 */
            transition: background-color 0.3s ease; /* 호버 애니메이션 */
        }

        .btn-primary:hover {
            background-color: #357abd; /* 버튼 호버 색상 */
        }

        .btn-icon {
            display: inline-flex; /* 아이콘과 텍스트를 나란히 배치 */
            align-items: center;
        }

        .btn-icon i {
            margin-right: 8px; /* 아이콘과 텍스트 간격 */
        }
    </style>
</head>
<body>
    <div class="container form-container"> <!-- Bootstrap 컨테이너와 폼 스타일 적용 -->
        <div class="form-header"> <!-- 폼 헤더 -->
            <h1><i class="fas fa-calendar-alt"></i> 수강신청 기간 설정</h1> <!-- 아이콘과 제목 -->
        </div>
        <div class="form-body"> <!-- 폼 본문 -->
            <!-- 폼 시작 -->
            <form action="<%=contextPath %>/classroom/setEnrollmentPeriod.do" method="post">
                <!-- 시작 날짜 입력 필드 -->
                <div class="mb-3">
                    <label for="start_date" class="form-label">시작 날짜</label> <!-- 라벨 -->
                    <input type="datetime-local" name="start_date" id="start_date" class="form-control" required> <!-- 입력 필드 -->
                </div>

                <!-- 종료 날짜 입력 필드 -->
                <div class="mb-3">
                    <label for="end_date" class="form-label">종료 날짜</label> <!-- 라벨 -->
                    <input type="datetime-local" name="end_date" id="end_date" class="form-control" required> <!-- 입력 필드 -->
                </div>

                <!-- 설명 입력 필드 -->
                <div class="mb-3">
                    <label for="description" class="form-label">설명</label> <!-- 라벨 -->
                    <textarea name="description" id="description" rows="3" class="form-control" placeholder="설명을 입력하세요."></textarea> <!-- 텍스트 영역 -->
                </div>

                <!-- 제출 버튼 -->
                <button type="submit" class="btn btn-primary w-100 btn-icon">
                    <i class="fas fa-save"></i> 설정 <!-- 아이콘과 텍스트 -->
                </button>
            </form>
        </div>
    </div>

    <!-- Bootstrap JS 연결 -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script> <!-- Bootstrap 스크립트 -->
</body>
</html>
