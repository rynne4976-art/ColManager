<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>취업박람회</title>
		<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jobFair.css">
	</head>
	<body>
	
		<div class="jobfair-wrapper">
		    <h1>취업박람회</h1>
		    <p class="jobfair-subtitle">기업별 행사 정보, 지도, 채용공고를 한 번에 확인할 수 있습니다.</p>
		
		    <div id="jobfair-list" class="jobfair-list"></div>
		</div>
		
		<script>
		    const contextPath = "${pageContext.request.contextPath}";
		</script>
		<script src="${pageContext.request.contextPath}/js/jobFair.js"></script>
	
	</body>
</html>