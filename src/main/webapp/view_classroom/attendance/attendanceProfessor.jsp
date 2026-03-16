<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<div class="container-fluid px-4 mt-4">
    <h2 class="mb-4">출석 관리</h2>

    <c:if test="${not empty attendanceMessage}">
        <div class="alert 
            <c:choose>
                <c:when test="${attendanceMessageType == 'success'}">alert-success</c:when>
                <c:when test="${attendanceMessageType == 'warning'}">alert-warning</c:when>
                <c:otherwise>alert-info</c:otherwise>
            </c:choose>">
            ${attendanceMessage}
        </div>
    </c:if>

    <div class="card mb-4">
        <div class="card-header">
            <i class="fas fa-calendar-check me-1"></i>
            출석 조회 조건
        </div>
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/classroom/attendanceProfessor.do" method="get">
                <div class="row g-3 align-items-end">
                    <div class="col-md-3">
                        <label class="form-label">과목 선택</label>
                        <select name="course_id" class="form-select" required>
                            <option value="">과목을 선택하세요</option>
                            <c:forEach var="course" items="${professorCourseList}">
                                <option value="${course.course_id}"
                                    <c:if test="${selectedCourseId == course.course_id}">selected</c:if>>
                                    ${course.course_name} (${course.course_id})
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="col-md-2">
                        <label class="form-label">수업 날짜</label>
                        <input type="date"
                               name="class_date"
                               value="${classDate}"
                               class="form-control"
                               required>
                    </div>

                    <div class="col-md-2">
                        <label class="form-label">학생명 검색</label>
                        <input type="text"
                               name="student_name"
                               value="${studentNameKeyword}"
                               class="form-control"
                               placeholder="학생명을 입력하세요">
                    </div>

                    <div class="col-md-2">
                        <label class="form-label">출석상태</label>
                        <select name="attendance_status" class="form-select">
                            <option value="">전체</option>
                            <option value="출석" <c:if test="${attendanceStatusFilter == '출석'}">selected</c:if>>출석</option>
                            <option value="지각" <c:if test="${attendanceStatusFilter == '지각'}">selected</c:if>>지각</option>
                            <option value="결석" <c:if test="${attendanceStatusFilter == '결석'}">selected</c:if>>결석</option>
                            <option value="공결" <c:if test="${attendanceStatusFilter == '공결'}">selected</c:if>>공결</option>
                            <option value="미등록" <c:if test="${attendanceStatusFilter == '미등록'}">selected</c:if>>미등록</option>
                        </select>
                    </div>

                    <div class="col-md-3">
                        <button type="submit" class="btn btn-primary w-100">
                            조회
                        </button>
                    </div>
                </div>

                <div class="row mt-3">
                    <div class="col-md-2">
                        <a class="btn btn-success w-100"
                           href="${pageContext.request.contextPath}/classroom/attendanceProfessor.do">
                            출결 등록
                        </a>
                    </div>

                    <div class="col-md-2">
                        <a class="btn btn-warning w-100"
                           href="${pageContext.request.contextPath}/classroom/attendanceUpdate.do?course_id=${selectedCourseId}&class_date=${classDate}&student_name=${studentNameKeyword}&attendance_status=${attendanceStatusFilter}">
                            출결 수정
                        </a>
                    </div>

                    <div class="col-md-8 d-flex justify-content-end">
                        <a href="${pageContext.request.contextPath}/classroom/attendanceProfessor.do"
                           class="btn btn-outline-secondary">
                            필터 초기화
                        </a>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <c:if test="${not empty studentList}">
        <div class="card">
            <div class="card-header">
                <i class="fas fa-user-check me-1"></i>
                학생별 출석 입력
            </div>
            <div class="card-body">
                <form id="attendanceForm"
                      action="${pageContext.request.contextPath}/classroom/attendanceSave.do"
                      method="post">

                    <input type="hidden" name="course_id" value="${selectedCourseId}">
                    <input type="hidden" name="class_date" value="${classDate}">
                    <input type="hidden" name="student_name" value="${studentNameKeyword}">
                    <input type="hidden" name="attendance_status" value="${attendanceStatusFilter}">
                    <input type="hidden" name="saveMode" id="saveMode">
                    <input type="hidden" name="single_student_id" id="singleStudentId">

                    <div class="row g-2 mb-3">
                        <div class="col-md-3">
                            <select id="bulkStatus" class="form-select">
                                <option value="">출석상태 선택</option>
                                <option value="출석">출석</option>
                                <option value="지각">지각</option>
                                <option value="결석">결석</option>
                                <option value="공결">공결</option>
                            </select>
                        </div>

                        <div class="col-md-2">
                            <button type="button"
                                    id="btnApplySelected"
                                    class="btn btn-outline-primary w-100"
                                    onclick="applySelectedStatus()">
                                선택 적용
                            </button>
                        </div>

                        <div class="col-md-2">
                            <button type="button"
                                    id="btnApplyAll"
                                    class="btn btn-outline-secondary w-100"
                                    onclick="applyAllStatus()">
                                전체 적용
                            </button>
                        </div>

                        <div class="col-md-2">
                            <button type="button"
                                    id="btnClearChecks"
                                    class="btn btn-outline-dark w-100"
                                    onclick="clearAllChecks()">
                                전체 해제
                            </button>
                        </div>
                    </div>

                    <div class="mb-3">
                        <strong>조회 결과:</strong> ${studentList.size()}명
                    </div>

                    <div class="table-responsive">
                        <table class="table table-bordered table-hover align-middle text-center">
                            <thead class="table-light">
                                <tr>
                                    <th style="width: 7%;">
                                        <input type="checkbox" id="checkAll" onclick="toggleAllStudents(this)">
                                    </th>
                                    <th style="width: 15%;">학번</th>
                                    <th style="width: 18%;">이름</th>
                                    <th style="width: 18%;">출석상태</th>
                                    <th>비고</th>
                                    <th style="width: 12%;">개별등록</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="student" items="${studentList}">
                                    <c:set var="studentId" value="${student.student_id}" />
                                    <c:set var="savedAtt" value="${attendanceMap[studentId]}" />

                                    <tr>
                                        <td>
                                            <input type="checkbox"
                                                   class="student-check"
                                                   name="student_id"
                                                   value="${student.student_id}">
                                        </td>
                                        <td>${student.student_id}</td>
                                        <td>${student.user_name}</td>
                                        <td>
                                            <select name="status_${student.student_id}" class="form-select">
                                                <option value="">선택</option>
                                                <option value="출석" <c:if test="${savedAtt.status == '출석'}">selected</c:if>>출석</option>
                                                <option value="지각" <c:if test="${savedAtt.status == '지각'}">selected</c:if>>지각</option>
                                                <option value="결석" <c:if test="${savedAtt.status == '결석'}">selected</c:if>>결석</option>
                                                <option value="공결" <c:if test="${savedAtt.status == '공결'}">selected</c:if>>공결</option>
                                            </select>
                                        </td>
                                        <td>
                                            <input type="text"
                                                   name="remark_${student.student_id}"
                                                   class="form-control"
                                                   value="${savedAtt.remark}"
                                                   placeholder="비고 입력">
                                        </td>
                                        <td>
                                            <button type="button"
                                                    class="btn btn-outline-primary btn-sm action-btn-single"
                                                    onclick="submitSingleAttendance('${student.student_id}', this)">
                                                개별 등록
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <div class="d-flex justify-content-end gap-2 mt-3">
                        <button type="button"
                                id="btnSubmitSelected"
                                class="btn btn-success"
                                onclick="submitSelectedAttendance(this)">
                            선택 학생 등록
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </c:if>

    <c:if test="${empty studentList && not empty selectedCourseId}">
        <div class="alert alert-warning">
            조회 조건에 맞는 학생이 없습니다.
        </div>
    </c:if>
</div>

<script>
let isSubmittingAttendance = false;

function getAttendanceForm() {
    return document.getElementById("attendanceForm");
}

function getStudentChecks() {
    return document.querySelectorAll(".student-check");
}

function getAllActionButtons() {
    return document.querySelectorAll(
        "#btnApplySelected, #btnApplyAll, #btnClearChecks, #btnSubmitSelected, .action-btn-single"
    );
}

function disableActionButtons(clickedButton, loadingText) {
    const buttons = getAllActionButtons();

    buttons.forEach(function(btn) {
        btn.disabled = true;
    });

    if (clickedButton) {
        clickedButton.innerText = loadingText;
    }
}

function toggleAllStudents(source) {
    if (isSubmittingAttendance) {
        return;
    }

    const checks = getStudentChecks();
    checks.forEach(function(chk) {
        chk.checked = source.checked;
    });
}

function clearAllChecks() {
    if (isSubmittingAttendance) {
        return;
    }

    const checks = getStudentChecks();
    checks.forEach(function(chk) {
        chk.checked = false;
    });

    const checkAll = document.getElementById("checkAll");
    if (checkAll) {
        checkAll.checked = false;
    }
}

function applySelectedStatus() {
    if (isSubmittingAttendance) {
        return;
    }

    const bulkStatus = document.getElementById("bulkStatus").value;
    const checks = document.querySelectorAll(".student-check:checked");

    if (checks.length === 0) {
        alert("적용할 학생을 선택하여 주십시오.");
        return;
    }

    if (bulkStatus === "") {
        alert("출석상태를 선택하여 주십시오.");
        return;
    }

    checks.forEach(function(chk) {
        const studentId = chk.value;
        const selectBox = document.querySelector("select[name='status_" + studentId + "']");
        if (selectBox) {
            selectBox.value = bulkStatus;
        }
    });
}

function applyAllStatus() {
    if (isSubmittingAttendance) {
        return;
    }

    const bulkStatus = document.getElementById("bulkStatus").value;
    const selects = document.querySelectorAll("select[name^='status_']");

    if (bulkStatus === "") {
        alert("출석상태를 선택하여 주십시오.");
        return;
    }

    selects.forEach(function(selectBox) {
        selectBox.value = bulkStatus;
    });
}

function validateStatus(studentIds) {
    for (let i = 0; i < studentIds.length; i++) {
        const studentId = studentIds[i];
        const selectBox = document.querySelector("select[name='status_" + studentId + "']");
        if (!selectBox || selectBox.value === "") {
            alert("출석상태가 선택되지 않은 학생이 있습니다.");
            return false;
        }
    }
    return true;
}

function submitSelectedAttendance(button) {
    if (isSubmittingAttendance) {
        return;
    }

    const checked = document.querySelectorAll(".student-check:checked");
    if (checked.length === 0) {
        alert("등록할 학생을 선택하여 주십시오.");
        return;
    }

    const studentIds = [];
    checked.forEach(function(chk) {
        studentIds.push(chk.value);
    });

    if (!validateStatus(studentIds)) {
        return;
    }

    isSubmittingAttendance = true;
    disableActionButtons(button, "등록 중...");

    document.getElementById("saveMode").value = "selected";
    document.getElementById("singleStudentId").value = "";
    getAttendanceForm().submit();
}

function submitSingleAttendance(studentId, button) {
    if (isSubmittingAttendance) {
        return;
    }

    if (!validateStatus([studentId])) {
        return;
    }

    const checks = getStudentChecks();
    checks.forEach(function(chk) {
        chk.checked = false;
    });

    isSubmittingAttendance = true;
    disableActionButtons(button, "등록 중...");

    document.getElementById("saveMode").value = "single";
    document.getElementById("singleStudentId").value = studentId;
    getAttendanceForm().submit();
}
</script>