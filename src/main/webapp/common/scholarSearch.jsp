<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>논문 검색</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/scholar.css">
</head>
<body>
	<div class="scholar-wrapper">
		<h1>논문 검색</h1>
		
		<div class="search-container">
		    <input type="text" id="search-input" placeholder="논문 검색어">
		    <input type="text" id="author-input" placeholder="저자">
		    <input type="text" id="year-input" placeholder="출판년도">
		    <input type="text" id="site-input" placeholder="사이트 제한">
		    <select id="sort-select">
		        <option value="">관련도순</option>
		        <option value="date">최신순</option>
		    </select>
		    <button type="button" id="search-btn">검색</button>
		</div>
		
		<div id="results"></div>
		
		<script>
		    const contextPath = "${pageContext.request.contextPath}";
		</script>
		<script src="${pageContext.request.contextPath}/js/scholar.js"></script>
	</div>
</body>
</html>