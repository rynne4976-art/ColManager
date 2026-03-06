<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
    <%
   	 	String contextPath = request.getContextPath();
    %>


<script>
	// main.jsp 메인 화면 요청
	location.href="<%=contextPath%>/member/main.bo";
</script>
