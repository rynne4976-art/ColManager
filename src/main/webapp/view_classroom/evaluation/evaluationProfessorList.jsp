<%@page import="Vo.ProfessorVo"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>강의 평가 조회</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/classroom_styles.css" rel="stylesheet" />
</head>
<body>
    <div class="container mt-5">
        <h1 class="text-center">강의 평가 조회</h1>
        <hr>
<%
    List<ProfessorVo> evaluationSearchList = (List<ProfessorVo>) request.getAttribute("evaluationSearchList");
    if (evaluationSearchList == null) {
        System.out.println("JSP: Evaluation List is null.");
    } else {
        System.out.println("JSP: Evaluation List size = " + evaluationSearchList.size());
        for (ProfessorVo evaluation : evaluationSearchList) {
            System.out.println("Course ID: " + evaluation.getCourseId());
            System.out.println("Course Name: " + evaluation.getCourseName());
            System.out.println("Rating: " + evaluation.getRating());
            System.out.println("Comments: " + evaluation.getComments());
        }
    }
%>

        
        
      <!-- ====================================================================== -->
        <!-- 교수가 담당한 과목을 선택해서 검색하면 해당과목의 강의평가를 조회할 수 있다.-->
        
        <form method="get" action="<%=request.getContextPath()%>/professor/evaluationList.bo">
		    <div class="row mb-3">
		        <div class="col-md-8">
		            <select class="form-select" name="courseId" ></select>
		        </div>
		        <div class="col-md-4">
		            <!--  <button type="submit" class="btn btn-primary w-100">검색</button> -->
		            <button type="submit" class="btn w-100" style="background-color: #c7ded5; color: #333; border: none; border-radius: 5px;">검색</button>
		        </div>
		    </div>
		</form>


             <!-- ====================================================================== -->
        
        
        
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>강의 ID</th>
                    <th>강의 이름</th>
                    <th>평점</th>
                    <th>평가 내용</th>
                </tr>
            </thead>
            <tbody>
                <% 
                List<ProfessorVo> evaluationList = (List<ProfessorVo>) request.getAttribute("evaluationList");

                    if (evaluationList != null && !evaluationList.isEmpty()) {
                        for (ProfessorVo evaluation : evaluationList) {
                %>
                <tr>
                    <td><%= evaluation.getCourseId() %></td>
                    <td><%= evaluation.getCourseName() %></td>
                    <td><%= evaluation.getRating() %></td>
                    <td><%= evaluation.getComments() %></td>
                </tr>
                <% 
                        }
                    } else {
                %>
                <tr>
                    <td colspan="4" class="text-center">조회할 평가 데이터가 없습니다.</td>
                </tr>
                <% 
                    } 
                %>
            </tbody>
        </table>
        <%-- <!-- 뒤로가기 버튼 -->
        <div class="text-center mt-4">
            <a href="<%=request.getContextPath()%>/professor/home.bo" class="btn btn-primary">돌아가기</a>
        </div> --%>
    </div>
    <script src="https://code.jquery.com/jquery-latest.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
 <script type="text/javascript">
function option() {
	$.ajax({
	    url: "<%=request.getContextPath()%>/professor/evaluationSearch.bo", // 요청 URL
	    method: "GET",         // HTTP 요청 메서드
	    dataType: "json",      // 서버에서 JSON 데이터를 반환해야 함
	    success: function(response) {
	        console.log("Received Response:", response); // JSON 객체로 처리 가능

	        // <select> 요소를 선택하고 옵션 초기화
	        const selectElement = document.querySelector("select[name='courseId']");
	        selectElement.innerHTML = ""; // 기존 옵션 제거

	        // 기본 선택 옵션 추가
	        const defaultOption = document.createElement("option");
	        defaultOption.value = "";
	        defaultOption.textContent = "강의를 선택하세요";
	        selectElement.appendChild(defaultOption);

	     // JSON 데이터를 기반으로 옵션 생성
	        response.forEach(function(item) {
	            const option = document.createElement("option");
	            option.value = item.courseId;
	            option.textContent = item.courseName + " (" + item.courseId + ")";
	            selectElement.appendChild(option);
	        });

	    },
	    error: function(xhr, status, error) {
	        console.error("Error Occurred:", error); // 오류 메시지 출력
	    }
	});

}

document.addEventListener("DOMContentLoaded", function() {
    option();
});
</script>

</body>

</html>