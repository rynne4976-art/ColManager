package Controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONObject;

import Vo.ProfessorVo;
import Service.ProfessorService;

@WebServlet("/professor/*")
public class ProfessorController extends HttpServlet {

	// .. 사장

	// MVC중에서 C의 역할

	// 부장
	ProfessorService prosessservice;

	@Override
	public void init() throws ServletException {

		prosessservice = new ProfessorService();
	}

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

// 핸들러		
	protected void doHandle(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=utf-8");
		// 웹브라우저로 출력할 출력 스트림 생성
		PrintWriter out = response.getWriter();

		// 조건에 따라서 포워딩 또는 보여줄 VIEW주소 경로를 저장할 변수
		String nextPage = null;

		// 요청한 중앙화면 뷰 주소를 저장할 변수
		String center = null;

		String action = request.getPathInfo();// 2단계 요청주소
		System.out.println("요청한 2단계 주소 : " + action);
		
		HttpSession session = request.getSession();

		List<ProfessorVo> professorList = null;
		String professorId = null;
		String name = null;
		Date birthDate = null;
		String gender = null;
		String address = null;
		String phone = null;
		String majorcode = null;
		String email = null;
		Date employDate = null;

		switch (action) {

		// 교수정보 등록
		case "/professor.do":

			int result = 0;

			// 요청 파라미터 가져오기
			String user_id = request.getParameter("user_id");
			String user_pw = request.getParameter("user_pw");
			String professor_id = request.getParameter("professor_id");
			String p_name = request.getParameter("p_name");
			String p_birthDate = request.getParameter("p_birthDate");
			String p_gender = request.getParameter("p_gender");

			String address1 = request.getParameter("address1");
			String address2 = request.getParameter("address2");
			String address3 = request.getParameter("address3");
			String address4 = request.getParameter("address4");
			String address5 = request.getParameter("address5");
			String p_address = address1 + address2 + address3 + address4 + address5;

			String p_phone = request.getParameter("p_phone");
			String professorMajorCode = request.getParameter("majorcode");
			String p_email = request.getParameter("p_email");
			String p_employDate = request.getParameter("p_employDate");
			String role = request.getParameter("role");

			// professorVo 객체 생성
			ProfessorVo vo = new ProfessorVo();
			vo.setUser_id(user_id);
			vo.setUser_pw(user_pw);
			vo.setProfessor_id(professor_id);
			vo.setUser_name(p_name);
			vo.setBirthDate(Date.valueOf(p_birthDate));
			vo.setGender(p_gender);
			vo.setAddress(p_address);
			vo.setPhone(p_phone);
			vo.setMajorcode(professorMajorCode);
			vo.setEmail(p_email);
			vo.setEmployDate(Date.valueOf(p_employDate));
			vo.setRole("교수");

			result = prosessservice.serviceInsertProsess(vo);
			// prosessservice.registerProfessor(request);

			request.setAttribute("result", result);

			if (result == 2) {
				request.setAttribute("center", "/view_admin/professorManager/professorinquiry.jsp");
			} else {
				request.setAttribute("center", "/view_admin/professorManager/professoradd.jsp");
			}

			nextPage = "/main.jsp";

			break;

		// 전체 교수 조회
		case "/professorquiry.do":

			String prof_id = request.getParameter("professor_id");
			majorcode = request.getParameter("majorcode");

			professorList = prosessservice.getProfessors(prof_id, majorcode);

			request.setAttribute("professor", professorList);

			request.setAttribute("center", "/view_admin/professorManager/professorinquiry.jsp");

			nextPage = "/main.jsp";

			break;

		// 특정 교수 조회
		case "/professorview.do":

			String prof_id_ = request.getParameter("professor_id");
			String majorCode_ = request.getParameter("majorcode");

			professorList = prosessservice.getProfessors(prof_id_, majorCode_);
			request.setAttribute("professor", professorList);

			request.setAttribute("center", "/view_admin/professorManager/professorinquiry.jsp");

			nextPage = "/main.jsp";

			break;

//			    
		// 교수정보 수정
		case "/updateProfessor.do":

			// AJAX로 보내는 데이터를 받아옴
			professorId = request.getParameter("professor_id");
			name = request.getParameter("user_name");
			majorcode = request.getParameter("majorcode");
			birthDate = Date.valueOf(request.getParameter("birthDate"));
			gender = request.getParameter("gender");
			address = request.getParameter("address");
			phone = request.getParameter("phone");
			email = request.getParameter("email");
			employDate = Date.valueOf(request.getParameter("employDate"));

			// VO 객체를 생성하여 데이터 셋팅
			ProfessorVo professor = new ProfessorVo();
			professor.setProfessor_id(professorId);
			professor.setUser_name(name);
			professor.setMajorcode(majorcode);
			professor.setBirthDate(birthDate); // String을 Date로 변환
			professor.setGender(gender);
			professor.setAddress(address);
			professor.setPhone(phone);
			professor.setEmail(email);
			professor.setEmployDate(employDate); // String을 Date로 변환

			// 교수 정보를 업데이트
			boolean isUpdated = prosessservice.updateProfessor(professor);

			// 결과에 따라 응답 처리
			if (isUpdated) {
				response.setStatus(HttpServletResponse.SC_OK);
				response.getWriter().write("수정 완료");
				return;
			} else {
				response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
				response.getWriter().write("수정 실패");
				return;
			}

			// 교수 삭제
		case "/deleteProfessor.do":

			action = request.getPathInfo();
			response.setContentType("application/json");
			out = response.getWriter();

			if (action != null && action.equals("/deleteProfessor.do")) {
				// 파라미터를 URL에서 가져옴
				professorId = request.getParameter("professor_id");

				System.out.println(professorId);

				if (professorId != null && !professorId.isEmpty()) {

					boolean isDeleted = prosessservice.deleteProfessor(professorId);

					if (isDeleted) {
						out.print("{\"success\": true}");
						return;
					} else {
						out.print("{\"success\": false}");
						return;
					}
				} else {
					out.print("{\"success\": false, \"error\": \"Missing professorId\"}");
					return;
				}
			}

			break;
			
			
			// 전체 교수 조회	        
		case "/professorAdd.bo":  
			
				center = request.getParameter("center");
				
				request.setAttribute("center", center);
	            
    
	            nextPage = "/main.jsp";
	            
	            break;
	       
	      //===========================================================================
	      // 강의 평가 조회
		case "/evaluationList.bo":

		    // 세션에서 교수 ID 가져오기
		    String loggedInProfessorId = (String) request.getSession().getAttribute("professor_id"); 
		    
			String course_id = request.getParameter("courseId");
		    
			
		    // 강의 평가 데이터 조회
		    List<ProfessorVo> evaluationList;
		    if(course_id == null) {
				evaluationList = prosessservice.getEvaluationsByProfessorId(loggedInProfessorId);
			} else {
				evaluationList = prosessservice.getEvaluationsByCourseId(course_id);
			}

		    // JSP에 데이터 전달
		    request.setAttribute("evaluationList", evaluationList);
		    
		    center = "/view_classroom/evaluation/evaluationProfessorList.jsp";
		    request.setAttribute("classroomCenter", center);
		    
		    nextPage = "/view_classroom/classroom.jsp";
		    
		    break;
		    
		  //=====================================================================
		 // 강의 목록 조회 및 강의 평가 검색
		case "/evaluationSearch.bo":
			
			professor_id = (String)session.getAttribute("professor_id");
			
			// 강의 목록 조회 (교수가 담당한 강의들)
			List<ProfessorVo> courseList = prosessservice.getCoursesByProfessorId(professor_id);

			// JSON 배열 생성
			JSONArray jsonCourseArray = new JSONArray();

			for (ProfessorVo course : courseList) {
			    
			    // JSONObject 생성 및 매핑
			    JSONObject courseJson = new JSONObject();
			    courseJson.put("courseId", course.getCourseId());
			    courseJson.put("courseName", course.getCourseName());
			    
			    // JSON 배열에 추가
			    jsonCourseArray.put(courseJson);
			}

			response.setContentType("application/json; charset=UTF-8");	
			
			// JSON 응답 반환
    	    out.print(jsonCourseArray);
    	    out.flush();
    	    out.close();
		    
		   return;


		default:
			break;
		}// switch

		// 디스패처 방식 포워딩(재요청)
		RequestDispatcher dispatch = request.getRequestDispatcher(nextPage);
		dispatch.forward(request, response);

	}// doHandle메소드

}// class