<%@page import="Vo.StudentVo"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Vo.CourseVo"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    String contextPath = request.getContextPath();
    ArrayList<StudentVo> studentList_ = (ArrayList<StudentVo>)session.getAttribute("studentList");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>성적 조회</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css"
        rel="stylesheet" crossorigin="anonymous">
    <script type="text/javascript" src="http://code.jquery.com/jquery-latest.min.js"></script>
    <style>
        .btn-green { background-color: #4CAF50; color: white; }
        .btn-green:hover { background-color: #45a049; }
        .g-Ap, .g-A0 { color: #0d6efd; font-weight: 700; }
        .g-Bp, .g-B0 { color: #198754; font-weight: 700; }
        .g-Cp, .g-C0 { color: #fd7e14; font-weight: 700; }
        .g-Dp, .g-D0 { color: #dc3545; font-weight: 700; }
        .g-F          { color: #6c757d; font-weight: 700; }
    </style>
</head>
<body class="bg-light">
    <main class="container my-5">
        <h2 class="text-center mb-4">성적 목록</h2>
        
        <div class="d-flex justify-content-end mb-3">
            <form id="excelDownloadForm" action="<%=contextPath%>/classroom/download.do" method="get" target="downloadFrame" style="margin:0;">
                <button type="submit" class="btn btn-green">성적 엑셀 다운로드</button>
            </form>
            <iframe name="downloadFrame" style="display:none;"></iframe>
        </div>

        <script>
            (function(){
                let form = document.getElementById("excelDownloadForm");
                let polling = null;

                function getCookie(name){
                    let cookies = document.cookie ? document.cookie.split('; ') : [];
                    for(let i=0;i<cookies.length;i++){
                        let parts = cookies[i].split('=');
                        let key = parts[0];
                        let value = parts.slice(1).join('=');
                        if(key === name) return decodeURIComponent(value);
                    }
                    return "";
                }

                function clearCookie(name){
                    document.cookie = name + "=; path=/; max-age=0";
                }

                function startPolling(){
                    if(polling) clearInterval(polling);
                    polling = setInterval(function(){
                        let status = getCookie("fileDownloadStatus");
                        if(status === "success"){
                            clearInterval(polling);
                            clearCookie("fileDownloadStatus");
                            alert("다운로드에 성공했습니다.");
                        }else if(status === "fail"){
                            clearInterval(polling);
                            clearCookie("fileDownloadStatus");
                            alert("다운로드에 실패했습니다.");
                        }
                    }, 500);
                }

                if(form){
                    form.addEventListener("submit", function(){
                        startPolling();
                    });
                }
            })();
        </script>

        <div class="card shadow-sm">
            <div class="card-body">
                <table class="table table-bordered table-hover text-center align-middle">
                    <thead class="table-success">
                        <tr>
                            <th scope="col">학 과</th>
                            <th scope="col">학 번</th>
                            <th scope="col">과 목</th>
                            <th scope="col">과목 번호</th>
                            <th scope="col">중간 고사</th>
                            <th scope="col">기말 고사</th>
                            <th scope="col">과 제</th>
                            <th scope="col">총 점</th>
                            <th scope="col">등 급</th>
                            <th scope="col">학점(4.5)</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        for (StudentVo student : studentList_) {
                        %>
                        <tr>
                            <td><%=student.getCourse().getMajorname()%></td>
                            <td class="student_id"><%=student.getStudent_id()%></td>
                            <td><%=student.getCourse().getCourse_name()%></td>
                            <td><%=student.getCourse().getCourse_id()%></td>
                            <td><%=student.getMidtest_score()%></td>
                            <td><%=student.getFinaltest_score()%></td>
                            <td><%=student.getAssignment_score()%></td>
                            <td class="total"><%=student.getScore()%></td>
                            <td class="grade"></td>
                            <td class="gpa"></td>
                        </tr>
                        <%
                        }
                        %>
                    </tbody>
                    <tfoot id="gpa-summary" style="display:none;">
                        <tr class="table-secondary">
                            <td colspan="9" class="text-end fw-bold">평균 학점 (4.5 만점)</td>
                            <td id="avg-gpa" class="fw-bold text-primary fs-6">-</td>
                        </tr>
                    </tfoot>
                </table>
            </div>
        </div>
    </main>
    <script type="text/javascript">
    /* 점수 → 등급·학점 변환 (4.5 만점) */
    function getGradeInfo(score) {
        if (score >= 95) return { grade: "A+", cls: "g-Ap", gpa: 4.5 };
        if (score >= 90) return { grade: "A0", cls: "g-A0", gpa: 4.0 };
        if (score >= 85) return { grade: "B+", cls: "g-Bp", gpa: 3.5 };
        if (score >= 80) return { grade: "B0", cls: "g-B0", gpa: 3.0 };
        if (score >= 75) return { grade: "C+", cls: "g-Cp", gpa: 2.5 };
        if (score >= 70) return { grade: "C0", cls: "g-C0", gpa: 2.0 };
        if (score >= 65) return { grade: "D+", cls: "g-Dp", gpa: 1.5 };
        if (score >= 60) return { grade: "D0", cls: "g-D0", gpa: 1.0 };
        return { grade: "F", cls: "g-F", gpa: 0.0 };
    }

    window.onload = function() {
        const rows = document.querySelectorAll("tbody tr");
        let totalGpa = 0, count = 0;

        rows.forEach(row => {
            const totalEl = row.querySelector(".total");
            const gradeEl = row.querySelector(".grade");
            const gpaEl   = row.querySelector(".gpa");
            if (!totalEl || !gradeEl || !gpaEl) return;

            const score = parseFloat(totalEl.textContent);
            const info  = getGradeInfo(score);

            gradeEl.textContent = info.grade;
            gradeEl.className   = "grade " + info.cls;
            gpaEl.textContent   = info.gpa.toFixed(1);
            gpaEl.className     = "gpa " + info.cls;

            totalGpa += info.gpa;
            count++;
        });

        if (count > 0) {
            const avg = (totalGpa / count).toFixed(2);
            document.getElementById("avg-gpa").textContent = avg + " / 4.5";
            document.getElementById("gpa-summary").style.display = "";
        }
    };
    </script>
</body>
</html>