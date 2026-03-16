package Controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.sql.Date;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.el.ListELResolver;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Cell;
import javax.servlet.http.Cookie;
import javax.servlet.ServletOutputStream;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import Service.BoardService;
import Service.ClassroomService;
import Service.MenuItemService;
import Service.StudentService;
import Vo.AttendanceVo;
import Vo.BoardVo;
import Vo.ClassroomVo;
import Vo.CourseVo;
import Vo.EnrollmentVo;
import Vo.StudentVo;


@WebServlet("/classroom/*")
public class ClassroomController extends HttpServlet {
	
	ClassroomService classroomservice;
	BoardService boardservice;
	String classroomCenter = null;
	
	@Override
	public void init() throws ServletException {
		classroomservice = new ClassroomService();
		boardservice = new BoardService();
	}
	
	// doGet doPost 메소드 오버라이딩
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException {
		doHandle(request, response);
	}
	
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException {
		doHandle(request, response);
	}
	
	protected void doHandle(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException {

        HttpSession session = request.getSession();
		
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=utf-8"); // MIME TYPE 설정
		
		//웹브라우저로 출력할 출력 스트림 생성
	    PrintWriter out = null;
	      
	    // 조건에 따라 포워딩 또는 보여줄 VIEW 주소 경로를 저장할 변수
	    String nextPage = null;
	    
	    // 재요청할 경로 주소를 저장할 변수
	    String center = null;
		
	    String action = request.getPathInfo(); // 2단계 요청주소
	    System.out.println("요청한 2단계 주소: " + action);
	    
	    
	    switch(action) {

		//==========================================================================================
	    
	    	case "/classroom.bo": // 학생 계정의 강의실 화면 2단계 요청 주소를 받으면
	    		
	    		center = request.getParameter("classroomCenter");
	    		
	    		ArrayList<BoardVo> list2 = (ArrayList<BoardVo>) boardservice.serviceBoardList();
				request.setAttribute("list", list2);
	    		
	    		request.setAttribute("classroomCenter", center);
	    		
				nextPage = "/view_classroom/classroom.jsp";
				
				break;
				
		//==========================================================================================
				
	    	case "/course_register.bo": // 수강관리 화면을 보여주는 요청을 받으면
	    		
	    		String majorCode = (String)session.getAttribute("majorcode");
	    		
	    		 // 서비스 계층을 통해 데이터를 가져옴
	    	    Map<String, Object> courseRegisterData = classroomservice.serviceGetCourseRegisterData(majorCode);
	    	    
	    	    // 데이터 추출
	    	    String majorName = (String) courseRegisterData.get("majorName");
	    	    ArrayList<ClassroomVo> list = (ArrayList<ClassroomVo>) courseRegisterData.get("classroomList");
	    		
	    		center = "/view_classroom/courseRegister.jsp";
	    		request.setAttribute("classroomCenter", center);
	    		request.setAttribute("majorname", majorName);
	    		request.setAttribute("rooms", list);
	    		
				nextPage = "/view_classroom/classroom.jsp";
				
				break;
				
		//==========================================================================================
			
			// 강의 등록을 했을 때 전달 받는 2단계 경로 
	    	case "/course_register.do":
	    		String course_name = request.getParameter("course_name");
	    		majorCode = (String) session.getAttribute("majorcode");
	    		String room_id = request.getParameter("room_id");
	    		String professor_id = request.getParameter("professor_id");
	    		
	    		int result = classroomservice.serviceRegisterInsertCourse(course_name, majorCode, room_id, professor_id); 
	    		
	    		if(result == 1) {
				    request.setAttribute("message", URLEncoder.encode("강의 등록이 완료되었습니다.", "UTF-8"));
				    request.setAttribute("center", "/view_classroom/courseSearch.jsp");
		    		nextPage = "/classroom/course_search.bo";
				} else {
				    request.setAttribute("message", URLEncoder.encode("강의 등록에 실패했습니다. 다시 입력해 주세요.", "UTF-8"));
		    		nextPage = "/classroom/course_register.bo";
				}
	    		
	    		break;
	    		
		//==========================================================================================
			    
	    	case "/course_search.bo": // 교수 강의 조회 화면 2단계 요청 주소를 받으면
	    		
	    		ArrayList<CourseVo> courseList = new ArrayList<CourseVo>();
	    		
	    		professor_id = (String) session.getAttribute("professor_id");
	    		String message = (String)request.getAttribute("message");
		    	center = (String)request.getAttribute("center");
	    		if (center == null) { // 값이 없으면 클라이언트 데이터 확인
	    			center = request.getParameter("center");
	    		}
	    		
	    		courseList = classroomservice.serviceCourseSearch(professor_id);
	    		
	    		request.setAttribute("courseList", courseList);
	    		request.setAttribute("classroomCenter", center);
	    		request.setAttribute("message", message);
	    		
				nextPage = "/view_classroom/classroom.jsp";
				
				break;
						
		//==========================================================================================
			    
	    	case "/courseNameSearch.do": // 교수 강의 조회 화면 2단계 요청 주소를 받으면
	    		
	    		ArrayList<CourseVo> courseListAjax = new ArrayList<CourseVo>();
	    		
	    		professor_id = (String) session.getAttribute("professor_id");
	    		
	    		courseListAjax = classroomservice.serviceCourseSearch(professor_id);
	    		
	    		// JSON 응답 설정
	    	    response.setContentType("application/json; charset=UTF-8");
	    	    out = response.getWriter();
	    	    
	    	    JSONArray courseArray = new JSONArray();
	    	    if (courseListAjax != null && !courseListAjax.isEmpty()) {

	    	        // 강의 목록을 JSON 배열로 변환
	    	        for (CourseVo course : courseListAjax) {
	    	            JSONObject courseJson = new JSONObject();
	    	            courseJson.put("courseName", course.getCourse_name()); // 강의 이름 추가
	    	            courseJson.put("courseId", course.getCourse_id()); // 강의 아이디 추가
	    	            courseArray.add(courseJson); // 배열에 추가
	    	        }
	    	    }
	    	    // JSON 응답 반환
	    	    out.print(courseArray);
	    	    out.flush();
	    	    out.close();
	    	    return;
				
		//==========================================================================================
				
	    	case "/updateCourse.do":
	    		// 요청으로부터 파라미터 받기
	            String course_id = request.getParameter("courseId");
	            course_name = request.getParameter("courseName");
	            room_id = request.getParameter("classroomId");
	    		
	    		int courseUpdateResult = classroomservice.serviceUpdateCourse(course_id, course_name, room_id);
	    		
	    		response.setContentType("application/json");
	    		response.setCharacterEncoding("UTF-8");
	    		out = response.getWriter();

	    		if(courseUpdateResult == 1) {
	    			// JSON으로 성공 메시지 반환
	    			out.print("{\"status\":\"success\"}");
	    		    return;
				} else {
					// JSON으로 실패 메시지 반환
					out.print("{\"status\":\"error\"}");
				    return;
				}
				
	    		
	    //==========================================================================================
	    	
	    	case "/getClassroomList.do": // 로그인된 교수의 강의실의 목록을 조회하는 2단계 요청 주소를 받으면
	    	
	    		majorCode = (String)session.getAttribute("majorcode");

	    	    ArrayList<ClassroomVo> classroomList = null;
	    		// 강의실 정보 조회
	    		classroomList = classroomservice.serviceGetClassInfo();
	    		
	    		if(classroomList != null) {
	    			// JSON 배열로 변환
	    	        JSONArray jsonArray = new JSONArray();
	    	        for (ClassroomVo room : classroomList) {
	    	            JSONObject jsonObject = new JSONObject();
	    	            jsonObject.put("room_id", room.getRoom_id());
	    	            jsonObject.put("capacity", room.getCapacity());
	    	            jsonObject.put("equipment", room.getEquipment());
	    	            jsonArray.add(jsonObject);
	    	        }
	    	        
	    	        out = response.getWriter();
	    	        out.print(jsonArray.toString());
	    	        out.flush();
	    	        return;
	    		}
	    		
	    		break;
	    		
	    //==========================================================================================
				
	    	case "/deleteCourse.do": // 교수가 등록한 강의를 삭제하는 2단계 요청 주소를 받으면
	    		
	    		course_id = request.getParameter("id");
	    		
	    		int deleteResult = classroomservice.serviceDeleteCourse(course_id); 
	    		
	    		if(deleteResult == 1) {
	    			request.setAttribute("message",  URLEncoder.encode("강의 삭제가 완료되었습니다.", "UTF-8"));
	    		} else {
	    			request.setAttribute("message",  URLEncoder.encode("강의 삭제에 실패했습니다.", "UTF-8"));
	    		}
	    		
	    		center = "/view_classroom/courseSearch.jsp";
	    		request.setAttribute("center", center);
	    		
	    		nextPage = "/classroom/course_search.bo";
	    		
				break;
				
	    //==========================================================================================
				
	    	case "/roomRegister.bo":
	    		
	    		center = "/view_admin/roomRegister.jsp";
	    		message = (String)request.getAttribute("message");
	    		
	    		request.setAttribute("center", center);
	    		request.setAttribute("message", message);
	    		
				nextPage = "/main.jsp";
	    		
	    		break;	
	    		
	    //==========================================================================================
				
	    	case "/roomRegister.do":
	    		
	    		room_id = (String) request.getParameter("room_id");
	    		String capacity = (String) request.getParameter("capacity");
	    		String[] equipment = request.getParameterValues("equipment[]");
	    		
	    		result = classroomservice.serviceRoomRegister(room_id, capacity, equipment);
	    		
	    		if(result == 1) {
	    			request.setAttribute("message",  URLEncoder.encode("강의실이 정상적으로 등록되었습니다.", "UTF-8"));
	    			nextPage = "/classroom/roomSearch.bo";
	    		} else {
	    			request.setAttribute("message",  URLEncoder.encode("강의실 등록에 실패했습니다. 다시 입력하세요.", "UTF-8"));
	    			nextPage = "/classroom/roomRegister.bo";
	    		}
	    		
	    		break;
	    		
	    //==========================================================================================
			    
	    	case "/roomSearch.bo": // 강의실 조회 화면 2단계 요청 주소를 받으면
	    		
	    		ArrayList<ClassroomVo> roomList = new ArrayList<ClassroomVo>();
	    		
	    		roomList = classroomservice.serviceGetClassInfo();
	    		
	    		center = "/view_admin/roomSearch.jsp";
	    		message = (String)request.getAttribute("message");
	    		
	    		request.setAttribute("roomList", roomList);
	    		request.setAttribute("center", center);
	    		request.setAttribute("message", message);
	    		
				nextPage = "/main.jsp";
				
				break;
	    		
		//==========================================================================================
				
	    	case "/updateRoom.do": // 강의실 수정에 대한 2단계 요청 주소를 받았을 때
	    		
	    		room_id = (String)request.getParameter("room_id");
	    		capacity = (String) request.getParameter("capacity");
	    		String room_equipment = (String)request.getParameter("equipment");
	    		
	    		result = classroomservice.serviceUpdateRoom(room_id, capacity, room_equipment);
	    		
	    		if(result == 1) {
	    	        out = response.getWriter();
	    	        out.write("success");
	    	        out.flush();
	    	        return;
	    		}
	    		
	    		break;
	    		
	    //==========================================================================================
				
	    	case "/deleteRoom.do": // 강의실 삭제에 대한 2단계 요청 주소를 받았을 때
	    		
	    		room_id = request.getParameter("room_id");
	    		
	    		result = classroomservice.serviceDeleteRoom(room_id); 
	    		
	    	    out = response.getWriter();
	    		if(result == 1) {
	    	        out.write("success");
	    	        out.flush();
	    	        return;
	    		} else {
	    	        out.write("non-success");
	    	        out.flush();
	    	        return;
	    		}
	    		
		//==========================================================================================
				
	    	case "/student_search.bo": //강의명 클릭시 조회될 학생목록
	    		
	    		ArrayList<StudentVo> studentList = new ArrayList<StudentVo>();
	    		
	    		String course_id_ = (String) request.getParameter("course_id");	    
	    		
	    		session.setAttribute("course_id", course_id_);
	    		
	    		studentList = classroomservice.serviceStudentSearch(course_id_);
	    		
	    		center = request.getParameter("classroomCenter");
	    		
	    		session.setAttribute("studentList", studentList);
	    		request.setAttribute("classroomCenter", center);
	    		
				nextPage = "/view_classroom/classroom.jsp";
	    		
	    		break;
	    		
	    //==========================================================================================

	    	case "/grade_register.do": // 교수가 성적 등록
	    		
	    		studentList = (ArrayList<StudentVo>) session.getAttribute("studentList");
	    		
	    		session.setAttribute("studentList", studentList);
	    		
	    		course_id_ = (String) session.getAttribute("course_id");
	    		String student_id = (String) request.getParameter("student_id");
	    		String total = (String)request.getParameter("total");
	    		String midtest_score = (String) request.getParameter("midtest");
	    		String finaltest_score = (String) request.getParameter("finaltest");
	    		String assignment_score = (String) request.getParameter("assignment");
	    		
	    		
	    		session.setAttribute("total", total);
	    		center = request.getParameter("classroomCenter");
	    		
	    		request.setAttribute("classroomCenter", center);
	    		
	    		nextPage = "/view_classroom/classroom.jsp";
	    		
	    		boolean isGradeExists = classroomservice.isGradeExists(course_id_, student_id);
	    		
	    		if(isGradeExists) {// 이미 해당 학생의 성적이 등록되어 있는 경우
	    			 response.getWriter().write("이미 성적이 등록된 학생입니다.");
	    			 return;
	    		} else {

		    		classroomservice.serviceGradeInsert(course_id_, student_id, total, midtest_score, finaltest_score, assignment_score);
		    		response.getWriter().write("성적이 성공적으로 등록되었습니다."); // 성공 메시지 반환
		    		return;
	    		}
	    		
	    		
   	    //==========================================================================================
		
	    	case "/grade_search.bo": // 학생이 성적 조회
	    		
	    		ArrayList<StudentVo> studentList_ = new ArrayList<StudentVo>();
	    			  
	    		String student_id_1 = (String) session.getAttribute("student_id");
	    		
	    		studentList_ = classroomservice.serviceGradeSearch(student_id_1);
	    		
	    		center = request.getParameter("classroomCenter");
	    		
	    		session.setAttribute("studentList", studentList_);
	    		request.setAttribute("classroomCenter", center);
	    		
				nextPage = "/view_classroom/classroom.jsp";
	    		
	    		
	    		break;
	    
  	    //==========================================================================================
	    		
	    	
	    	case "/download.do": // 학생 성적 엑셀 다운로드

	    		nextPage = "/view_classroom/gradeList.jsp";
	    		ArrayList<StudentVo> excelStudentList = new ArrayList<StudentVo>();
	    		String excelStudentId = (String) session.getAttribute("student_id");

	    		if(excelStudentId == null || excelStudentId.trim().equals("")) {
	    			Cookie failCookie = new Cookie("fileDownloadStatus", "fail");
	    			failCookie.setPath("/");
	    			response.addCookie(failCookie);
	    			response.setContentType("text/html;charset=UTF-8");
	    			out = response.getWriter();
	    			out.println("<script>history.back();</script>");
	    			return;
	    		}

	    		try {
	    			excelStudentList = classroomservice.serviceGradeDownload(excelStudentId);

	    			String fileName = URLEncoder.encode("grade", "UTF-8").replaceAll("\\+", "%20");
	    			response.reset();
	    			response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
	    			response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + ".xlsx\"");

	    			Cookie successCookie = new Cookie("fileDownloadStatus", "success");
	    			successCookie.setPath("/");
	    			response.addCookie(successCookie);

	    			Workbook workbook = new XSSFWorkbook();
	    			Sheet sheet = workbook.createSheet("grade");

	    			CellStyle headerStyle = workbook.createCellStyle();
	    			Font headerFont = workbook.createFont();
	    			headerFont.setBold(true);
	    			headerStyle.setFont(headerFont);
	    			headerStyle.setAlignment(HorizontalAlignment.CENTER);
	    			headerStyle.setVerticalAlignment(VerticalAlignment.CENTER);

	    			CellStyle bodyStyle = workbook.createCellStyle();
	    			bodyStyle.setAlignment(HorizontalAlignment.CENTER);
	    			bodyStyle.setVerticalAlignment(VerticalAlignment.CENTER);

    				CellStyle scoreStyle = workbook.createCellStyle();
    				scoreStyle.cloneStyleFrom(bodyStyle);
    				DataFormat dataFormat = workbook.createDataFormat();
    				scoreStyle.setDataFormat(dataFormat.getFormat("0.0"));

	    			String[] title = {"학과","학번","과목","중간","기말","과제","총점","등급"};
	    			Row header = sheet.createRow(0);
	    			for(int i=0;i<title.length;i++){
	    				Cell cell = header.createCell(i);
	    				cell.setCellValue(title[i]);
	    				cell.setCellStyle(headerStyle);
	    			}

	    			int rowNo = 1;
	    			for(StudentVo s : excelStudentList){
	    				Row row = sheet.createRow(rowNo++);

	    				String excelMajorName = "";
	    				String excelCourseName = "";
	    				try {
	    					if(s.getCourse() != null){
	    						if(s.getCourse().getMajorname() != null) excelMajorName = s.getCourse().getMajorname();
	    						if(s.getCourse().getCourse_name() != null) excelCourseName = s.getCourse().getCourse_name();
	    					}
	    				}catch(Exception e){}

	    				float totalScore = 0;
	    				try {
	    					if(s.getScore() != null) totalScore = s.getScore();
	    				}catch(Exception e){}
	    				
	    				totalScore = Math.round(totalScore * 10) / 10.0f;
	    				
	    				String grade = "F";
	    				if(totalScore >= 90) grade = "A";
	    				else if(totalScore >= 80) grade = "B";
	    				else if(totalScore >= 70) grade = "C";
	    				else if(totalScore >= 60) grade = "D";

	    				Cell c0 = row.createCell(0); c0.setCellValue(excelMajorName); c0.setCellStyle(bodyStyle);
	    				Cell c1 = row.createCell(1); c1.setCellValue(s.getStudent_id() != null ? s.getStudent_id() : ""); c1.setCellStyle(bodyStyle);
	    				Cell c2 = row.createCell(2); c2.setCellValue(excelCourseName); c2.setCellStyle(bodyStyle);
	    				Cell c3 = row.createCell(3); c3.setCellValue(s.getMidtest_score()); c3.setCellStyle(bodyStyle);
	    				Cell c4 = row.createCell(4); c4.setCellValue(s.getFinaltest_score()); c4.setCellStyle(bodyStyle);
	    				Cell c5 = row.createCell(5); c5.setCellValue(s.getAssignment_score()); c5.setCellStyle(bodyStyle);
	    				Cell c6 = row.createCell(6); c6.setCellValue(totalScore); c6.setCellStyle(scoreStyle);
	    				Cell c7 = row.createCell(7); c7.setCellValue(grade); c7.setCellStyle(bodyStyle);
	    			}

	    			for(int i=0;i<title.length;i++){
	    				sheet.autoSizeColumn(i);
	    			}

	    			ServletOutputStream sos = response.getOutputStream();
	    			workbook.write(sos);
	    			workbook.close();
	    			sos.flush();
	    			sos.close();
	    			return;
	    		}catch(Exception e){
	    			e.printStackTrace();
	    			Cookie failCookie = new Cookie("fileDownloadStatus", "fail");
	    			failCookie.setPath("/");
	    			response.addCookie(failCookie);
	    			response.sendRedirect(request.getContextPath() + "/view_classroom/gradeList.jsp");
	    			return;
	    		}

  	    //==========================================================================================

	    	case "/grade_update.do": //교수가 성적 수정
	    		
	    		studentList = (ArrayList<StudentVo>) session.getAttribute("studentList");
	    		
	    		session.setAttribute("studentList", studentList);
	    		
	    		course_id_ = (String) session.getAttribute("course_id");
	    		student_id = (String) request.getParameter("student_id");
	    		total = (String)request.getParameter("total");
	    		midtest_score = (String) request.getParameter("midtest");
	    		finaltest_score = (String) request.getParameter("finaltest");
	    		assignment_score = (String) request.getParameter("assignment");
	    		
	    		session.setAttribute("total", total);
	    		
	    		center = request.getParameter("classroomCenter");
	    		
	    		request.setAttribute("classroomCenter", center);
	    		
	    		nextPage = "/view_classroom/classroom.jsp";
	    		
	    	
	    		
	    		// 입력값 검증
	    	    try {
	    	    	int midtest = Integer.parseInt(midtest_score);
		    		int finaltest = Integer.parseInt(finaltest_score);
		    		int assignment = Integer.parseInt(assignment_score);

	    	        // 점수 범위 확인 (0~100)
	    	        if (midtest < 0 || midtest > 100 || finaltest < 0 || finaltest > 100 || assignment < 0 || assignment > 100) {
	    	            response.getWriter().write("점수는 0에서 100 사이여야 합니다.");
	    	            return;
	    	        }
	    	        classroomservice.serviceGradeUpdate(course_id_, student_id, total, midtest_score, finaltest_score, assignment_score );
	    	        response.getWriter().write("성적이 성공적으로 수정되었습니다.");
	    	        return;
	    	    } catch (NumberFormatException e) {
	    	        // 숫자가 아닌 값이 입력된 경우
	    	        response.getWriter().write("유효한 숫자를 입력해주세요.");
	    	    }
	    		
	    		break;
	    		
	    //==========================================================================================
	    		
	    	case "/grade_delete.do": //교수가 성적 삭제
	    		
	    		studentList = (ArrayList<StudentVo>) session.getAttribute("studentList");
	    		
	    		session.setAttribute("studentList", studentList);
	    		
	    		course_id_ = (String) session.getAttribute("course_id");
	    		student_id = (String) request.getParameter("student_id");
	    		
	    		System.out.println(course_id_);
	    		System.out.println(student_id);
	    		
	    		center = request.getParameter("classroomCenter");
	    		
	    		request.setAttribute("classroomCenter", center);
	    		
	    		nextPage = "/view_classroom/classroom.jsp";
	    		
	    	      
		       	classroomservice.serviceGradeDelete(course_id_, student_id);
		       	
		        response.getWriter().write("성적이 성공적으로 삭제되었습니다.");
		        return; 
	    		
	    //==========================================================================================  
	    	case "/course_submit.bo": // 수강신청 전체 과목 조회 요청 처리

	    	    // 수강신청 가능한 과목 목록을 담을 리스트
	    	    ArrayList<CourseVo> courseList1 = new ArrayList<>();
	    	    // 이미 수강신청한 과목 목록을 담을 리스트
	    	    ArrayList<CourseVo> courseList2 = new ArrayList<>();

	    	    // 세션에서 현재 로그인한 학생의 ID를 가져옴
	    	    String studentId = (String) session.getAttribute("student_id");

	    	    // 현재 학생이 신청 가능한 과목 목록을 서비스에서 조회
	    	    courseList1 = classroomservice.serviceCourseList(studentId);
	    	    // 현재 학생이 이미 선택한 과목 목록을 서비스에서 조회
	    	    courseList2 = classroomservice.serviceCourseSelect(studentId);

	    	    // 수강신청 기간 정보(시작 날짜와 종료 날짜)를 조회
	    	    LocalDateTime[] enrollmentPeriod = classroomservice.getEnrollmentPeriod();

	    	    // 수강신청 기간 정보가 없는 경우 처리
	    	    if (enrollmentPeriod == null) {
	    	        // 응답 콘텐츠 타입을 HTML로 설정하고 UTF-8로 인코딩
	    	        response.setContentType("text/html; charset=UTF-8");
	    	        
	    	        // PrintWriter 객체를 가져와 브라우저에 출력 준비
	    	        out = response.getWriter();
	    	        
	    	        // JavaScript로 경고 메시지를 출력
	    	        out.print("<script>");
	    	        // 경고창에 관리자에게 문의하라는 메시지를 출력
	    	        out.print("alert('수강신청 기간이 설정되지 않았습니다. 관리자에게 문의하세요.');");
	    	        // 이전 페이지로 돌아가는 JavaScript 명령어를 출력
	    	        out.print("history.back();");
	    	        // JavaScript 종료 태그
	    	        out.print("</script>");
	    	        
	    	        // 버퍼에 출력된 내용을 클라이언트로 전송
	    	        out.flush();
	    	        
	    	        // PrintWriter 객체 닫기
	    	        out.close();
	    	        
	    	        // 현재 메서드 종료, 이후 로직 실행하지 않음
	    	        return;
	    	    }

	    	    // 수강신청 기간인지 확인하는 메서드 호출 (현재 날짜와 수강신청 기간 비교)
	    	    boolean isEnrollmentPeriod = classroomservice.isEnrollmentPeriod();

	    	    center = request.getParameter("classroomCenter");

	    		request.setAttribute("classroomCenter", center);
	    		
	    	    // 수강신청 가능한 과목 목록을 JSP로 전달
	    	    request.setAttribute("courseList", courseList1);
	    	    // 이미 수강신청한 과목 목록을 JSP로 전달
	    	    request.setAttribute("courseList2", courseList2);
	    	    // 수강신청 시작 날짜를 JSP로 전달
	    	    request.setAttribute("startDate", enrollmentPeriod[0]);
	    	    // 수강신청 종료 날짜를 JSP로 전달
	    	    request.setAttribute("endDate", enrollmentPeriod[1]);
	    	    // 현재가 수강신청 기간인지 여부를 JSP로 전달
	    	    request.setAttribute("isEnrollmentPeriod", isEnrollmentPeriod);

	    	    
	    	    
	    	    // 이동할 JSP 경로를 설정 (수강신청 화면)
	    	    nextPage = "/view_classroom/classroom.jsp";

	    	    // case 블록 종료
	    	    break;


		        
		//==========================================================================================
			    
	    	case "/studentCourseSearch.do": // 학생이 수강하는 과목을 조회해서 가져오는 2단계 요청주소
	    		
	    		ArrayList<EnrollmentVo> studentCourseList = new ArrayList<EnrollmentVo>();
	    		
	    		student_id = (String) session.getAttribute("student_id");
	    		
	    		studentCourseList = classroomservice.serviceStudentCourseSearch(student_id);
	    		
	    		// JSON 응답 설정
	    	    response.setContentType("application/json; charset=UTF-8");
	    	    out = response.getWriter();
	    	    
	    	    courseArray = new JSONArray();
	    	    if (studentCourseList != null && !studentCourseList.isEmpty()) {

	    	        // 강의 목록을 JSON 배열로 변환
	    	        for (EnrollmentVo enrollment : studentCourseList) {
	    	            JSONObject courseJson = new JSONObject();
	    	            // EnrollmentVo의 CourseVo에서 강의 정보 추출
	    	            CourseVo course = enrollment.getCourse(); // EnrollmentVo에서 CourseVo를 가져옴

	    	            if (course != null) {
	    	                courseJson.put("courseId", course.getCourse_id());   // 강의 ID 추가
	    	                courseJson.put("courseName", course.getCourse_name()); // 강의 이름 추가
	    	            }
	    	            
	    	            // 배열에 추가
	    	            courseArray.add(courseJson);

	    	        }
	    	    }
	    	    // JSON 응답 반환
	    	    out.print(courseArray);
	    	    out.flush();
	    	    out.close();
	    	    return;
	    	    
		//==========================================================================================
		        
	    	case "/courseInsert.do": //수강 신청
	    		
	    		String courseId = request.getParameter("courseId");
	    		studentId = (String)session.getAttribute("student_id");
	    		System.out.println(courseId);
	    		System.out.println(studentId);
	    		int isInsert = classroomservice.serviceCourseInsert(courseId, studentId);
	    		
	    		nextPage = "/view_classroom/classroom.jsp";
	    		
	    		if(isInsert > 0) {
	    			response.getWriter().write("Success");
	    			return;
	    		}else {
	    			response.getWriter().write("Fail");
	    			return;
	    		}
	    		
		        
	    //==========================================================================================
	    		
	    	case "/courseDelete.do": //수강 취소
	    		
	    		courseId = request.getParameter("courseId");
	    		studentId = (String)session.getAttribute("student_id");
	    		System.out.println(courseId);
	    		System.out.println(studentId);
	    		
	    		int isDelete = classroomservice.serviceCourseDelete(courseId, studentId);
	    		
	    		nextPage = "/view_classroom/classroom.jsp";
	    		
	    		if(isDelete > 0) {
	    			response.getWriter().write("Success");
	    			return;
	    		}else {
	    			response.getWriter().write("Fail");
	    			return;
	    		}
	    					
	    //==========================================================================================
	    	case "/enrollmentPeriodPage.bo": // 수강신청 기간 설정 페이지로 이동
	    		request.setAttribute("center", "/view_admin/coursePeriod.jsp" );
	    	    nextPage = "/main.jsp"; // 설정 페이지 경로
	    	    break;
	    	
	    //==========================================================================================	  
	    	    
	    	case "/setEnrollmentPeriod.do": // 수강신청 기간 설정 요청
	    	    String startDateStr = request.getParameter("start_date"); // 시작 날짜
	    	    String endDateStr = request.getParameter("end_date");     // 종료 날짜
	    	    String description = request.getParameter("description"); // 설명

	    	    try {
	    	        // 날짜 문자열을 LocalDateTime으로 변환
	    	        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
	    	        LocalDateTime startDateTime = LocalDateTime.parse(startDateStr, formatter);
	    	        LocalDateTime endDateTime = LocalDateTime.parse(endDateStr, formatter);

	    	        // MySQL DATETIME에 맞는 Timestamp로 변환
	    	        Timestamp startTimestamp = Timestamp.valueOf(startDateTime);
	    	        Timestamp endTimestamp = Timestamp.valueOf(endDateTime);

	    	        // 서비스 호출
	    	        boolean result2 = classroomservice.setEnrollmentPeriod(startTimestamp, endTimestamp, description);
	    	        
	    	        if (result2) {
	    	            request.setAttribute("message", "수강신청 기간이 성공적으로 설정되었습니다.");
	    	            request.setAttribute("startDate", startDateStr); // 원래 포맷 유지
	    	            request.setAttribute("endDate", endDateStr);     // 원래 포맷 유지
	    	            request.setAttribute("description", description); // 설정된 설명
	    	        } else {
	    	            request.setAttribute("message", "수강신청 기간 설정에 실패했습니다.");
	    	        }
	    	    } catch (Exception e) {
	    	        e.printStackTrace(); // 예외 발생 시 출력
	    	        request.setAttribute("message", "입력 값 변환 중 오류가 발생했습니다.");
	    	    }

	    	    center = "/view_admin/enrollmentPeriodResult.jsp";
	    	    request.setAttribute("center", center);

	    	    nextPage = "/main.jsp";
	    	    break;

	    //==========================================================================================	  

	    	case "/allAssignNotice.do":
	    		
	    		// 세션에서 student_id 가져오기
	            session = request.getSession();
	            studentId = (String) session.getAttribute("student_id");

	            // DAO를 통해 데이터 가져오기
	            Map<String, List> allAssignNotice = classroomservice.getAssignmentsAndNotices(studentId);

	            
	            center = "/view_classroom/studentMyCourse.jsp";
	            
	    		request.setAttribute("classroomCenter", center);
	            request.setAttribute("allAssignNotice", allAssignNotice);
	            
	    		
	            nextPage="/view_classroom/classroom.jsp";
	            
	    		break;
	    	    
	    //==========================================================================================
	    	// ── 증명서 조회 메인 페이지 ──────────────────────────────────────────────────────
	    	case "/certificate.bo":
	    	{
	    		String certStudentId = (String) session.getAttribute("student_id");
	    		if (certStudentId != null) {
	    			ArrayList<StudentVo> certGradeList = classroomservice.serviceGradeSearch(certStudentId);
	    			StudentVo certStudentInfo = classroomservice.serviceGetStudentInfo(certStudentId);
	    			session.setAttribute("studentList", certGradeList);
	    			request.setAttribute("studentInfo", certStudentInfo);
	    		}
	    		request.setAttribute("classroomCenter", "/view_classroom/certificate/certificateMain.jsp");
	    		nextPage = "/view_classroom/classroom.jsp";
	    		break;
	    	}

	    	// ── 증명서 인쇄 미리보기 (새 탭) — grade | graduation ──────────────────────────
	    	case "/certPrint.bo":
	    	{
	    		String cpStudentId = (String) session.getAttribute("student_id");
	    		String cpType      = request.getParameter("type"); // "grade" | "graduation"
	    		if (cpStudentId != null) {
	    			StudentVo cpInfo = classroomservice.serviceGetStudentInfo(cpStudentId);
	    			request.setAttribute("studentInfo", cpInfo);
	    			if ("grade".equals(cpType)) {
	    				ArrayList<StudentVo> cpGradeList = classroomservice.serviceGradeSearch(cpStudentId);
	    				request.setAttribute("gradeList", cpGradeList);
	    			}
	    		}
	    		request.setAttribute("certType", cpType);
	    		nextPage = "/view_classroom/certificate/certificatePrint.jsp";
	    		break;
	    	}

	    //==========================================================================================

	    	case "/attendanceStudent.do":
	    	    session = request.getSession(false);
	    	    String role = session != null ? (String) session.getAttribute("role") : null;

	    	    if (!"학생".equals(role)) {
	    	        response.sendRedirect(request.getContextPath() + "/member/main.bo");
	    	        return;
	    	    }

	    	    String studentId_ = (String) session.getAttribute("student_id");

	    	    ArrayList<AttendanceVo> attendanceList = classroomservice.serviceAttendanceByStudent(studentId_);

	    	    request.setAttribute("attendanceList", attendanceList);

	    	    classroomCenter = "/view_classroom/attendance/attendanceStudent.jsp";
	    	    request.setAttribute("classroomCenter", classroomCenter);

	    	    nextPage = "/view_classroom/classroom.jsp";
	    	    break;

				// ==========================================================================================

	    	case "/attendanceProfessor.do": 
	    	    session = request.getSession(false);
	    	    String attrole = session != null ? (String) session.getAttribute("role") : null;

	    	    if (!"교수".equals(attrole)) {
	    	        response.sendRedirect(request.getContextPath() + "/member/main.bo");
	    	        return;
	    	    }

	    	    String professorId = (String) session.getAttribute("professor_id");
	    	    String selectedCourseId = request.getParameter("course_id");
	    	    String classDateStr = request.getParameter("class_date");
	    	    String studentNameKeyword = request.getParameter("student_name");
	    	    String attendanceStatusFilter = request.getParameter("attendance_status");

	    	    ArrayList<CourseVo> professorCourseList =
	    	            classroomservice.serviceCourseSearch(professorId);

	    	    ArrayList<StudentVo> attendstudentList = new ArrayList<StudentVo>();
	    	    ArrayList<AttendanceVo> attendance_List = new ArrayList<AttendanceVo>();

	    	    if (selectedCourseId != null && !selectedCourseId.trim().equals("")) {
	    	        attendstudentList = classroomservice.serviceStudentSearch(selectedCourseId, studentNameKeyword);

	    	        if (classDateStr != null && !classDateStr.trim().equals("")) {
	    	            Date classDate = Date.valueOf(classDateStr);
	    	            attendance_List =
	    	                    classroomservice.serviceAttendanceByCourseAndDate(selectedCourseId, classDate);
	    	        }
	    	    }

	    	    Map<String, AttendanceVo> attendanceMap = new HashMap<String, AttendanceVo>();
	    	    for (AttendanceVo att : attendance_List) {
	    	        attendanceMap.put(att.getStudent_id(), att);
	    	    }

	    	    if (attendanceStatusFilter != null && !attendanceStatusFilter.trim().equals("")) {
	    	        ArrayList<StudentVo> filteredStudentList = new ArrayList<StudentVo>();

	    	        for (StudentVo student : attendstudentList) {
	    	            AttendanceVo savedAtt = attendanceMap.get(student.getStudent_id());

	    	            if ("미등록".equals(attendanceStatusFilter)) {
	    	                if (savedAtt == null) {
	    	                    filteredStudentList.add(student);
	    	                }
	    	            } else {
	    	                if (savedAtt != null && attendanceStatusFilter.equals(savedAtt.getStatus())) {
	    	                    filteredStudentList.add(student);
	    	                }
	    	            }
	    	        }

	    	        attendstudentList = filteredStudentList;
	    	    }

	    	    request.setAttribute("professorCourseList", professorCourseList);
	    	    request.setAttribute("studentList", attendstudentList);
	    	    request.setAttribute("attendanceMap", attendanceMap);
	    	    request.setAttribute("selectedCourseId", selectedCourseId);
	    	    request.setAttribute("classDate", classDateStr);
	    	    request.setAttribute("studentNameKeyword", studentNameKeyword);
	    	    request.setAttribute("attendanceStatusFilter", attendanceStatusFilter);

	    	    classroomCenter = "/view_classroom/attendance/attendanceProfessor.jsp";
	    	    request.setAttribute("classroomCenter", classroomCenter);

	    	    nextPage = "/view_classroom/classroom.jsp";
	    	    break;
	    	
			// =========================================
			// 교수 출석 저장
			// =========================================
	    	case "/attendanceSave.do": 
	    	    session = request.getSession(false);
	    	    String saverole = session != null ? (String) session.getAttribute("role") : null;

	    	    if (!"교수".equals(saverole)) {
	    	        response.sendRedirect(request.getContextPath() + "/member/main.bo");
	    	        return;
	    	    }

	    	    String course_Id = request.getParameter("course_id");
	    	    String classDate_Str = request.getParameter("class_date");
	    	    String studentName_Keyword = request.getParameter("student_name");
	    	    String attendanceStatus_Filter = request.getParameter("attendance_status");
	    	    String saveMode = request.getParameter("saveMode");
	    	    String singleStudentId = request.getParameter("single_student_id");
	    	    String[] checkedStudentIds = request.getParameterValues("student_id");

	    	    int successCount = 0;
	    	    int duplicateCount = 0;
	    	    int invalidEnrollmentCount = 0;
	    	    int invalidStatusCount = 0;

	    	    if (course_Id == null || course_Id.trim().equals("")
	    	            || classDate_Str == null || classDate_Str.trim().equals("")) {

	    	        request.setAttribute("attendanceMessage", "과목 및 수업일을 확인하여 주십시오.");
	    	        request.setAttribute("attendanceMessageType", "warning");

	    	    } else {
	    	        Date classDate = Date.valueOf(classDate_Str);

	    	        if ("single".equals(saveMode)) {
	    	            if (singleStudentId == null || singleStudentId.trim().equals("")) {
	    	                request.setAttribute("attendanceMessage", "개별 등록 대상 학생이 없습니다.");
	    	                request.setAttribute("attendanceMessageType", "warning");
	    	            } else {
	    	                String status = request.getParameter("status_" + singleStudentId);
	    	                String remark = request.getParameter("remark_" + singleStudentId);

	    	                if (status == null || status.trim().equals("")) {
	    	                    request.setAttribute("attendanceMessage", "출석상태를 선택하여 주십시오.");
	    	                    request.setAttribute("attendanceMessageType", "warning");
	    	                } else {
	    	                    AttendanceVo vo = new AttendanceVo();
	    	                    vo.setStudent_id(singleStudentId);
	    	                    vo.setCourse_id(course_Id);
	    	                    vo.setClass_date(classDate);
	    	                    vo.setStatus(status);
	    	                    vo.setRemark(remark);

	    	                    int saveResult = classroomservice.serviceInsertAttendance(vo);

	    	                    if (saveResult == 1) {
	    	                        successCount++;
	    	                    } else if (saveResult == -1) {
	    	                        invalidEnrollmentCount++;
	    	                    } else if (saveResult == -2) {
	    	                        duplicateCount++;
	    	                    }
	    	                }
	    	            }

	    	        } else if ("selected".equals(saveMode)) {
	    	            if (checkedStudentIds == null || checkedStudentIds.length == 0) {
	    	                request.setAttribute("attendanceMessage", "등록할 학생을 선택하여 주십시오.");
	    	                request.setAttribute("attendanceMessageType", "warning");
	    	            } else {
	    	                for (String stdId : checkedStudentIds) {
	    	                    String status = request.getParameter("status_" + stdId);
	    	                    String remark = request.getParameter("remark_" + stdId);

	    	                    if (status == null || status.trim().equals("")) {
	    	                        invalidStatusCount++;
	    	                        continue;
	    	                    }

	    	                    AttendanceVo vo = new AttendanceVo();
	    	                    vo.setStudent_id(stdId);
	    	                    vo.setCourse_id(course_Id);
	    	                    vo.setClass_date(classDate);
	    	                    vo.setStatus(status);
	    	                    vo.setRemark(remark);

	    	                    int saveResult = classroomservice.serviceInsertAttendance(vo);

	    	                    if (saveResult == 1) {
	    	                        successCount++;
	    	                    } else if (saveResult == -1) {
	    	                        invalidEnrollmentCount++;
	    	                    } else if (saveResult == -2) {
	    	                        duplicateCount++;
	    	                    }
	    	                }
	    	            }
	    	        }

	    	        if (request.getAttribute("attendanceMessage") == null) {
	    	            StringBuilder msg = new StringBuilder();
	    	            String msgType = "success";

	    	            if (successCount > 0) {
	    	                msg.append(successCount).append("건 등록되었습니다. ");
	    	            }
	    	            if (duplicateCount > 0) {
	    	                msg.append("이미 등록된 출결 ").append(duplicateCount).append("건은 제외되었습니다. ");
	    	                msgType = "warning";
	    	            }
	    	            if (invalidEnrollmentCount > 0) {
	    	                msg.append("수강 정보가 없는 학생 ").append(invalidEnrollmentCount).append("건은 제외되었습니다. ");
	    	                msgType = "warning";
	    	            }
	    	            if (invalidStatusCount > 0) {
	    	                msg.append("출석상태 미선택 ").append(invalidStatusCount).append("건은 제외되었습니다. ");
	    	                msgType = "warning";
	    	            }

	    	            if (msg.length() == 0) {
	    	                msg.append("등록 가능한 데이터가 없습니다.");
	    	                msgType = "warning";
	    	            }

	    	            request.setAttribute("attendanceMessage", msg.toString().trim());
	    	            request.setAttribute("attendanceMessageType", msgType);
	    	        }
	    	    }

	    	    String professor_Id = (String) session.getAttribute("professor_id");

	    	    ArrayList<CourseVo> professorCourse_List =
	    	            classroomservice.serviceCourseSearch(professor_Id);

	    	    ArrayList<StudentVo> attstudentList = new ArrayList<StudentVo>();
	    	    ArrayList<AttendanceVo> attendanceSaveList = new ArrayList<AttendanceVo>();

	    	    if (course_Id != null && !course_Id.trim().equals("")) {
	    	        attstudentList = classroomservice.serviceStudentSearch(course_Id, studentName_Keyword);

	    	        if (classDate_Str != null && !classDate_Str.trim().equals("")) {
	    	            Date classDate = Date.valueOf(classDate_Str);
	    	            attendanceSaveList =
	    	                    classroomservice.serviceAttendanceByCourseAndDate(course_Id, classDate);
	    	        }
	    	    }

	    	    Map<String, AttendanceVo> attendance_Map = new HashMap<String, AttendanceVo>();
	    	    for (AttendanceVo att : attendanceSaveList) {
	    	        attendance_Map.put(att.getStudent_id(), att);
	    	    }

	    	    if (attendanceStatus_Filter != null && !attendanceStatus_Filter.trim().equals("")) {
	    	        ArrayList<StudentVo> filteredStudentList = new ArrayList<StudentVo>();

	    	        for (StudentVo student : attstudentList) {
	    	            AttendanceVo savedAtt = attendance_Map.get(student.getStudent_id());

	    	            if ("미등록".equals(attendanceStatus_Filter)) {
	    	                if (savedAtt == null) {
	    	                    filteredStudentList.add(student);
	    	                }
	    	            } else {
	    	                if (savedAtt != null && attendanceStatus_Filter.equals(savedAtt.getStatus())) {
	    	                    filteredStudentList.add(student);
	    	                }
	    	            }
	    	        }

	    	        attstudentList = filteredStudentList;
	    	    }

	    	    request.setAttribute("professorCourseList", professorCourse_List);
	    	    request.setAttribute("studentList", attstudentList);
	    	    request.setAttribute("attendanceMap", attendance_Map);
	    	    request.setAttribute("selectedCourseId", course_Id);
	    	    request.setAttribute("classDate", classDate_Str);
	    	    request.setAttribute("studentNameKeyword", studentName_Keyword);
	    	    request.setAttribute("attendanceStatusFilter", attendanceStatus_Filter);

	    	    classroomCenter = "/view_classroom/attendance/attendanceProfessor.jsp";
	    	    request.setAttribute("classroomCenter", classroomCenter);

	    	    nextPage = "/view_classroom/classroom.jsp";
	    	    break;
			
	    	case "/attendanceUpdate.do": 
	    	    session = request.getSession(false);
	    	    String srole = session != null ? (String) session.getAttribute("role") : null;

	    	    if (!"교수".equals(srole)) {
	    	        response.sendRedirect(request.getContextPath() + "/member/main.bo");
	    	        return;
	    	    }

	    	    String courseId_ = request.getParameter("course_id");
	    	    String class_DateStr = request.getParameter("class_date");
	    	    String studentNameKeyword_ = request.getParameter("student_name");
	    	    String attendanceStatusFilter_ = request.getParameter("attendance_status");
	    	    String updateMode = request.getParameter("updateMode");
	    	    String singleStudent_Id = request.getParameter("single_student_id");
	    	    String[] checkedStudent_Ids = request.getParameterValues("student_id");

	    	    int success_Count = 0;
	    	    int notFoundCount = 0;
	    	    int invalidStatus_Count = 0;

	    	    if (courseId_ == null || courseId_.trim().equals("")
	    	            || class_DateStr == null || class_DateStr.trim().equals("")) {

	    	        request.setAttribute("attendanceMessage", "과목 및 수업일을 확인하여 주십시오.");
	    	        request.setAttribute("attendanceMessageType", "warning");

	    	    } else {
	    	        Date classDate = Date.valueOf(class_DateStr);

	    	        if ("single".equals(updateMode)) {
	    	            if (singleStudent_Id == null || singleStudent_Id.trim().equals("")) {
	    	                request.setAttribute("attendanceMessage", "개별 수정 대상 학생이 없습니다.");
	    	                request.setAttribute("attendanceMessageType", "warning");
	    	            } else {
	    	                String status = request.getParameter("status_" + singleStudent_Id);
	    	                String remark = request.getParameter("remark_" + singleStudent_Id);

	    	                if (status == null || status.trim().equals("")) {
	    	                    request.setAttribute("attendanceMessage", "출석상태를 선택하여 주십시오.");
	    	                    request.setAttribute("attendanceMessageType", "warning");
	    	                } else {
	    	                    AttendanceVo vo = new AttendanceVo();
	    	                    vo.setStudent_id(singleStudent_Id);
	    	                    vo.setCourse_id(courseId_);
	    	                    vo.setClass_date(classDate);
	    	                    vo.setStatus(status);
	    	                    vo.setRemark(remark);

	    	                    int updateResult = classroomservice.serviceUpdateAttendance(vo);

	    	                    if (updateResult == 1) {
	    	                        success_Count++;
	    	                    } else if (updateResult == -1) {
	    	                        notFoundCount++;
	    	                    }
	    	                }
	    	            }

	    	        } else if ("selected".equals(updateMode)) {
	    	            if (checkedStudent_Ids == null || checkedStudent_Ids.length == 0) {
	    	                request.setAttribute("attendanceMessage", "수정할 학생을 선택하여 주십시오.");
	    	                request.setAttribute("attendanceMessageType", "warning");
	    	            } else {
	    	                for (String stdId : checkedStudent_Ids) {
	    	                    String status = request.getParameter("status_" + stdId);
	    	                    String remark = request.getParameter("remark_" + stdId);

	    	                    if (status == null || status.trim().equals("")) {
	    	                        invalidStatus_Count++;
	    	                        continue;
	    	                    }

	    	                    AttendanceVo vo = new AttendanceVo();
	    	                    vo.setStudent_id(stdId);
	    	                    vo.setCourse_id(courseId_);
	    	                    vo.setClass_date(classDate);
	    	                    vo.setStatus(status);
	    	                    vo.setRemark(remark);

	    	                    int updateResult = classroomservice.serviceUpdateAttendance(vo);

	    	                    if (updateResult == 1) {
	    	                        success_Count++;
	    	                    } else if (updateResult == -1) {
	    	                        notFoundCount++;
	    	                    }
	    	                }
	    	            }
	    	        }

	    	        if (request.getAttribute("attendanceMessage") == null) {
	    	            StringBuilder msg = new StringBuilder();
	    	            String msgType = "success";

	    	            if (success_Count > 0) {
	    	                msg.append(success_Count).append("건 수정되었습니다. ");
	    	            }
	    	            if (notFoundCount > 0) {
	    	                msg.append("등록된 출결이 없는 학생 ").append(notFoundCount).append("건은 제외되었습니다. ");
	    	                msgType = "warning";
	    	            }
	    	            if (invalidStatus_Count > 0) {
	    	                msg.append("출석상태 미선택 ").append(invalidStatus_Count).append("건은 제외되었습니다. ");
	    	                msgType = "warning";
	    	            }

	    	            request.setAttribute("attendanceMessage", msg.toString().trim());
	    	            request.setAttribute("attendanceMessageType", msgType);
	    	        }
	    	    }

	    	    String professorId_ = (String) session.getAttribute("professor_id");

	    	    ArrayList<CourseVo> professorCourseList_ =
	    	            classroomservice.serviceCourseSearch(professorId_);

	    	    ArrayList<StudentVo> attendstudentList_ = new ArrayList<StudentVo>();
	    	    ArrayList<AttendanceVo> attendanceListForUpdate = new ArrayList<AttendanceVo>();

	    	    if (courseId_ != null && !courseId_.trim().equals("")) {
	    	        attendstudentList_ = classroomservice.serviceStudentSearch(courseId_, studentNameKeyword_);

	    	        if (class_DateStr != null && !class_DateStr.trim().equals("")) {
	    	            Date classDate = Date.valueOf(class_DateStr);
	    	            attendanceListForUpdate =
	    	                    classroomservice.serviceAttendanceByCourseAndDate(courseId_, classDate);
	    	        }
	    	    }

	    	    Map<String, AttendanceVo> attendanceMap_ = new HashMap<String, AttendanceVo>();
	    	    for (AttendanceVo att : attendanceListForUpdate) {
	    	        attendanceMap_.put(att.getStudent_id(), att);
	    	    }

	    	    ArrayList<StudentVo> updateTargetList = new ArrayList<StudentVo>();
	    	    for (StudentVo student : attendstudentList_) {
	    	        AttendanceVo savedAtt = attendanceMap_.get(student.getStudent_id());
	    	        if (savedAtt != null) {
	    	            if (attendanceStatusFilter_ == null || attendanceStatusFilter_.trim().equals("")) {
	    	                updateTargetList.add(student);
	    	            } else if (attendanceStatusFilter_.equals(savedAtt.getStatus())) {
	    	                updateTargetList.add(student);
	    	            }
	    	        }
	    	    }

	    	    request.setAttribute("professorCourseList", professorCourseList_);
	    	    request.setAttribute("studentList", updateTargetList);
	    	    request.setAttribute("attendanceMap", attendanceMap_);
	    	    request.setAttribute("selectedCourseId", courseId_);
	    	    request.setAttribute("classDate", class_DateStr);
	    	    request.setAttribute("studentNameKeyword", studentNameKeyword_);
	    	    request.setAttribute("attendanceStatusFilter", attendanceStatusFilter_);

	    	    classroomCenter = "/view_classroom/attendance/attendanceProfessorUpdate.jsp";
	    	    request.setAttribute("classroomCenter", classroomCenter);

	    	    nextPage = "/view_classroom/classroom.jsp";
	    	    break;	    		

	    	default:
	    		break;
	    }
		
		// 디스패처 방식 포워딩(재요청)
		if (nextPage == null) {
			System.err.println("[ClassroomController] nextPage is null! action=" + action);
			response.sendError(HttpServletResponse.SC_NOT_FOUND, "요청한 페이지를 찾을 수 없습니다: " + action);
			return;
		}
		RequestDispatcher dispatch = request.getRequestDispatcher(nextPage);
		dispatch.forward(request, response);
		
	} // doHandle 메소드

}
