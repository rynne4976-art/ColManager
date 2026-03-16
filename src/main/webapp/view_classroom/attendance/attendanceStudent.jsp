<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<div class="container-fluid px-4 mt-4">
    <h2 class="mb-4">출석 확인</h2>

    <div class="card">
        <div class="card-header">
            <i class="fas fa-calendar-check me-1"></i>
            내 출결 현황
        </div>
        <div class="card-body">
            <c:choose>
                <c:when test="${not empty attendanceList}">
                    <div class="table-responsive">
                        <table class="table table-bordered table-hover align-middle text-center">
                            <thead class="table-light">
                                <tr>
                                    <th style="width: 20%;">과목코드</th>
                                    <th style="width: 20%;">과목명</th>
                                    <th style="width: 20%;">수업일</th>
                                    <th style="width: 20%;">출석상태</th>
                                    <th>비고</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="a" items="${attendanceList}">
                                    <tr>
                                        <td>${a.course_id}</td>
                                        <td>${a.course_name }</td>
                                        <td>${a.class_date}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${a.status == '출석'}">
                                                    <span class="badge bg-success">출석</span>
                                                </c:when>
                                                <c:when test="${a.status == '지각'}">
                                                    <span class="badge bg-warning text-dark">지각</span>
                                                </c:when>
                                                <c:when test="${a.status == '결석'}">
                                                    <span class="badge bg-danger">결석</span>
                                                </c:when>
                                                <c:when test="${a.status == '공결'}">
                                                    <span class="badge bg-primary">공결</span>
                                                </c:when>
                                                <c:otherwise>
                                                    ${a.status}
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${a.remark}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>

                <c:otherwise>
                    <div class="alert alert-secondary mb-0">
                        조회된 출결 정보가 없습니다.
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>