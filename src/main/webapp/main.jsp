<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%
	String contextPath = request.getContextPath();
%>

<!doctype html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>EveryOne</title>

<style>
html, body {
	margin: 0;
	padding: 0;
	height: 100%;
	display: flex;
	flex-direction: column;
}

.wrapper {
	display: flex;
	flex-direction: column;
	height: 100%;
}

.top {
	flex: 0 0 auto;
	height: 10%;
}

.center {
	flex: 1 0 auto;
	overflow-y: auto;
	align-content: center;
}

.bottom {
	flex: 0 0 auto;
	height: 20%;
}

</style>
</head>
<body>
	<c:set var="center" value="${requestScope.center}" />
	<c:if test="${center == null}">
		<c:set var="center" value="/view_start/startcenter.jsp" />
	</c:if>

	<div class="wrapper">
		<div class="top">
			<jsp:include page="top.jsp" />
		</div>
		<div class="center">
			<jsp:include page="${center}" />
		</div>
		<div class="bottom">
			<jsp:include page="bottom.jsp" />
		</div>
	</div>
</body>
</html>
