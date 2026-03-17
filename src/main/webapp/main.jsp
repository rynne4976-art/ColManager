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
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<link href="<%=contextPath%>/css/widget.css" rel="stylesheet">

<style>
html, body {
	margin: 0;
	padding: 0;
	min-height: 100%;
}
body {
	display: block;
	background: #f4f6f9;
}
.wrapper {
	min-height: 100vh;
	display: flex;
	flex-direction: column;
}
.top,
.bottom {
	flex: 0 0 auto;
	height: auto;
}
.center {
	flex: 1 0 auto;
	overflow-x: hidden;
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

	<jsp:include page="/common/floatingWidgets.jsp" />
</body>
</html>
