package Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONArray;

import Dao.ClassroomDAO;
import Vo.BoardVo;
import Vo.ClassroomVo;
import Vo.CourseVo;
import Vo.EnrollmentVo;
import Vo.StudentVo;

import java.sql.Timestamp;
import java.time.LocalDateTime;

public class ClassroomService {

	ClassroomDAO classroomdao;
	
	public ClassroomService() {
		classroomdao = new ClassroomDAO();
	}
	
	//------------
	// ClassroomService에 새로운 메서드 추가
	public Map<String, Object> serviceGetCourseRegisterData(String majorCode) {
		Map<String, Object> data = new HashMap<>();
		    
		// 학과 이름 조회
		String majorName = classroomdao.getMajorNameInfo(majorCode);
		data.put("majorName", majorName);
		    
	    // 강의실 정보 조회
	    ArrayList<ClassroomVo> list = classroomdao.getClassroomAllInfo();
	    data.put("classroomList", list);
		    
	    return data;
	}
		
	//-------------
	// 강의실 정보를 모두 조회해서 가져오는 기능의 함수
	public ArrayList<ClassroomVo> serviceGetClassInfo() {
		return classroomdao.getClassroomAllInfo();
	}

	//-------------
	// 강의를 등록하기 위해 DAO를 호출하는 함수
	public int serviceRegisterInsertCourse(String course_name, String majorcode, String room_id, String professor_id) {
		return classroomdao.registerInsertCourse(course_name, majorcode, room_id, professor_id);
	}

	//-------------
	// 교수의 강의를 조회하기 위해 DAO를 호출하는 함수
	public ArrayList<CourseVo> serviceCourseSearch(String professor_id) {
		return classroomdao.courseSearch(professor_id);
	}

	//-------------
	// 교수의 강의를 삭제하기 위해 DAO를 호출하는 함수
	public int serviceDeleteCourse(String course_id) {
		return classroomdao.courseDelete(course_id);
	}

	//-------------
	// 교수의 강의를 수정하기 위해 DAO를 호출하는 함수
	public int serviceUpdateCourse(String course_id, String course_name, String room_id) {
		return classroomdao.updateCourse(course_id, course_name, room_id);
	}

	// 교수의 강의를 수강하는 학생 조회
	public ArrayList<StudentVo> serviceStudentSearch(String course_id_) {
		return classroomdao.studentSearch(course_id_);
	}

	//성적 등록 
	public void serviceGradeInsert(String course_id_, String student_id, String total, String midtest_score, String finaltest_score, String assignment_score) {
		classroomdao.gradeInsert(course_id_, student_id, total,midtest_score, finaltest_score ,assignment_score);
	}

	//성적 조회
	public ArrayList<StudentVo> serviceGradeSearch(String student_id_1) {
		return classroomdao.gradeSearch(student_id_1);
	}

	// 이미 성적이 있는지 조회 
	public boolean isGradeExists(String course_id_, String student_id) {
		return classroomdao.gradeExists(course_id_, student_id);
	}

	// 성적 수정
	public void serviceGradeUpdate(String course_id_, String student_id, String total, String midtest_score, String finaltest_score,
			String assignment_score) {
		
		classroomdao.gradeUpdate(course_id_, student_id, total, midtest_score, finaltest_score, assignment_score);
	}

	// 성적 삭제
	public void serviceGradeDelete(String course_id_, String student_id) {
		classroomdao.gradeDelete(course_id_, student_id);
	}
	//-------------
	// 관리자가 강의실을 등록하기 위해 DAO를 호출하는 함수
	public int serviceRoomRegister(String room_id, String capacity, String[] equipment) {
		return classroomdao.roomRegister(room_id, capacity, equipment);
	}

	//-------------
	// 관리자가 모든 강의실을 조회하기 위해 DAO 호출하는 함수
//	public ArrayList<ClassroomVo> serviceRoomSearch() {
//		return classroomdao.roomShearch();
//	}

	//-------------
	// 관리자가 강의실의 정보를 수정하기 위해 DAO를 호출하는 함수
	public int serviceUpdateRoom(String room_id, String capacity, String room_equipment) {
		return classroomdao.updateRoom(room_id, capacity, room_equipment);
	}

	//-------------
	// 관리자가 강의실의 정보를 삭제하기 위해 DAO를 호출하는 함수
	public int serviceDeleteRoom(String room_id) {
		return classroomdao.deleteRoom(room_id);
	}

	//--------------
	// 한 학생의 수강 강의 조회를 위한 함수
	public ArrayList<EnrollmentVo> serviceStudentCourseSearch(String student_id) {
		return classroomdao.studentCourseSearch(student_id);
	}
	
	//수강 과목 전체 목록 조회
	public ArrayList<CourseVo> serviceCourseList(String studentId) {
		return classroomdao.courseList(studentId);
	}
	
	//수강 신청
	public int serviceCourseInsert(String courseId, String studentId) {
		return classroomdao.courseInsert(courseId, studentId);
	}

	//수강 취소
	public int serviceCourseDelete(String courseId, String studentId) {
		return classroomdao.courseDelete_(courseId, studentId);
	}

	//수강 목록 조회
	public ArrayList<CourseVo> serviceCourseSelect(String studentId) {
		return classroomdao.courseSelect(studentId);
	}

	//수강신청 기간인지 확인
	public boolean isEnrollmentPeriod() {
		
		// 수강신청 기간 정보 조회 
	    LocalDateTime[] period = classroomdao.getEnrollmentPeriod();
	    
	    if (period == null || period[0] == null || period[1] == null) {
	        return false; // 기간 정보가 없으면 false 반환
	    }

	    LocalDateTime now = LocalDateTime.now(); // 현재 날짜
	    return now.isAfter(period[0]) && now.isBefore(period[1]); // 현재 날짜가 수강신청 기간 안에 있는지

	    
	    
	}

	//수강신청 기간 조회
	public LocalDateTime[] getEnrollmentPeriod() {
	    return classroomdao.getEnrollmentPeriod(); // DAO에서 기간 조회
	}

	// 수강신청 기간 입력
	public boolean setEnrollmentPeriod(Timestamp startTimestamp, Timestamp endTimestamp, String description) {
	    return classroomdao.insertEnrollmentPeriod(startTimestamp, endTimestamp, description); // DAO 호출
	}

	//----------
	// 학생 강의실 홈에서 학생이 수강하는 모든 강의의 과제와 공지사항을 조회하기 위해 DAO 호출
	public Map<String, List> getAssignmentsAndNotices(String studentId) {
	    Map<String, List> result = new HashMap<>();
	    List assignments = new ArrayList();
	    List notices = new ArrayList();
	    
	    assignments = classroomdao.getAssignments(studentId);
	    notices = classroomdao.getNotices(studentId);

	    result.put("assignments", assignments);
	    result.put("notices", notices);
	    
	    return result;
	}







}
