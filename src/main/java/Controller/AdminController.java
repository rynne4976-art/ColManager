package Controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Service.AdminService;
import Vo.AdminVo; 

//.. 사장 

//MVC중에서 C의 역할 

@WebServlet("/admin/*")
public class AdminController extends HttpServlet {

	// 부장
	AdminService adminservice;

	@Override
	public void init() throws ServletException {

		adminservice = new AdminService();
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

	protected void doHandle(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html;charset=utf-8");
	// 웹브라우저로 출력할 출력 스트림 생성
	PrintWriter out;

	// 조건에 따라서 포워딩 또는 보여줄 VIEW주소 경로를 저장할 변수
	String nextPage = null;

	// 요청한 중앙화면 뷰 주소를 저장할 변수
	String center = null;

	String action = request.getPathInfo();// 2단계 요청주소

	System.out.println("요청한 2단계 주소 : " + action);

	List<AdminVo> memberList = null;
	String user_id = null;
	String admin_id = null;
	String searchWord = null;

	switch (action) {
		
	case "/adminjoin.bo":
		
		center = request.getParameter("center");
		
		request.setAttribute("center", center);
		
		nextPage = "/main.jsp";
		
		break;

	case "/joinPro.me":// 회원가입 2단계 요청주소와 같다면?

			int result = 0;

			// 요청한 값 얻기 (회원가입을 위해 입력했던 값들 request에서 얻기)
			user_id = request.getParameter("user_id");
			String user_pw = request.getParameter("user_pw");
			String user_name = request.getParameter("name");
			Date birthDate = Date.valueOf(request.getParameter("birthDate"));
			String gender = request.getParameter("gender");

			String address1 = request.getParameter("address1");
			String address2 = request.getParameter("address2");
			String address3 = request.getParameter("address3");
			String address4 = request.getParameter("address4");
			String address5 = request.getParameter("address5");
			String address = address1 + address2 + address3 + address4 + address5;

			String phone = request.getParameter("phone");
			String email = request.getParameter("email");
			admin_id = request.getParameter("admin_id");
			String department = request.getParameter("department");
			int access_level = Integer.parseInt(request.getParameter("access_level"));
			String role = request.getParameter("role");

			AdminVo vo = new AdminVo();
			vo.setUser_id(user_id);
			vo.setUser_pw(user_pw);
			vo.setUser_name(user_name);
			vo.setBirthDate(birthDate);
			vo.setGender(gender);
			vo.setAddress(address);
			vo.setPhone(phone);
			vo.setEmail(email);
			vo.setAdmin_id(admin_id);
			vo.setDepartment(department);
			vo.setAccess_level(access_level);
			vo.setRole("관리자");

			// 부장에게 시킴
			result = adminservice.serviceInsertMember(vo);

			request.setAttribute("result", result);

			if (result == 1) {

				request.setAttribute("message", " 회원등록이 되었습니다.");

			} else {
				request.setAttribute("message", "회원등록을 실패하였습니다");
			}

			center = "/view_admin/adminManager/adminjoin.jsp";
			request.setAttribute("center", center);
			
			nextPage = "/main.jsp";

			break;

		case "/joinIdCheck.me": // 아이디 중복 체크 요청!
			// 부장 한테 시키자
			// 입력한 아이디가 DB에 저장되어 있는지 확인 하는 작업
			// true -> 중복, false -> 중복 아님 둘중 하나를 반환 받음
			boolean result_ = adminservice.serviceOverLappedId(request);

			// 아이디 중복결과를 다시 한번 확인 하여 조건값을
			// join.jsp파일과 연결된 join.js파일에 작성해 놓은
			// $.ajax메소드 내부의
			// success:function의 data매개변수로 웹브라우저를 거쳐 보냅니다!
			out = response.getWriter();
			if (result_) {
				out.write("not_usable");
				out.flush();
				out.close();
				return;
			} else {
				out.write("");
				out.flush();
				out.close();
				return;
			}

		// 관리자 특정조회
		case "/managerquiry.do":

			searchWord = request.getParameter("searchWord");
			/* admin_id = request.getParameter("admin_id"); */

			memberList = adminservice.getMemberlist(searchWord);

			center = "/view_admin/adminManager/adminquiry.jsp";
			
			request.setAttribute("member", memberList);
			request.setAttribute("center", center);
			
			nextPage = "/main.jsp";

			break;

		// 전체 조회
		case "/managerview.do":

			memberList = adminservice.getAllMemberlist();

			request.setAttribute("member", memberList);

			center = request.getParameter("center");
			request.setAttribute("center", center);
			
			nextPage = "/main.jsp";

			break;

		// 관리자 삭제
		case "/managerDelete.do":

			action = request.getPathInfo();
			response.setContentType("application/json");
			out = response.getWriter();

			if (action != null && action.equals("/managerDelete.do")) {
				// 파라미터를 URL에서 가져옴
				admin_id = request.getParameter("admin_id");

				System.out.println(admin_id);

				if (admin_id != null && !admin_id.isEmpty()) {

					boolean isDeleted = adminservice.managerDelete(admin_id);

					if (isDeleted) {
						out.print("{\"success\": true}");
						return;
					} else {
						out.print("{\"success\": false}");
						return;
					}
				} else {
					out.print("{\"success\": false, \"error\": \"Missing admin_id\"}");
					return;
				}
			}

			break;

		
		// 수정하고 수정버튼 클릭시 수정
		case "/managerEdit.do" :

			try {
				// AJAX로 보내는 데이터를 받아옴
				String user_id_ = request.getParameter("user_id");
				String user_name_ = request.getParameter("user_name");
				Date birthDate__ = Date.valueOf(request.getParameter("birthDate"));
				String gender_ = request.getParameter("gender");
				String address_ = request.getParameter("address");
				String phone_ = request.getParameter("phone");
				String email_ = request.getParameter("email");
				String admin_id_ = request.getParameter("admin_id");
				String department_ = request.getParameter("department");
				int access_level_ = Integer.parseInt(request.getParameter("access_level"));
				
	
				// VO 객체를 생성하여 데이터 셋팅
				AdminVo mvo = new AdminVo();
				mvo.setUser_id(user_id_);
				mvo.setUser_name(user_name_);
				mvo.setBirthDate(birthDate__); // String을 Date로 변환
				mvo.setGender(gender_);
				mvo.setAddress(address_);
				mvo.setPhone(phone_);
				mvo.setEmail(email_);
				mvo.setAdmin_id(admin_id_);
				mvo.setDepartment(department_);
				mvo.setAccess_level(access_level_);

				// 교수 정보를 업데이트
				boolean isUpdated = adminservice.updateMember(mvo);
	
				request.setAttribute("member", mvo);

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
				
			} catch (Exception e) {
			    System.out.println("MemberController의 update에서 오류");
			    e.printStackTrace();
			    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			    response.getWriter().write("서버 오류");
			}
			
			break;
			
		default:
			break;

		}

		// 디스패처 방식 포워딩(재요청)
		RequestDispatcher dispatch = request.getRequestDispatcher(nextPage);
		dispatch.forward(request, response);

	}// doHandle메소드
}