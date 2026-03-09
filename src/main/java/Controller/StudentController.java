package Controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.util.List;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

//import Dao.CarDAO;
import Service.StudentService;
import Service.MenuItemService;
import Vo.MemberVo;
import Vo.StudentVo;
//import Vo.CarConfirmVo;
//import Vo.CarListVo;
//import Vo.CarOrderVo;

// 사장 ...

// MVC 중에서 C 역할

// /member/join.me?center=members/join.jsp

@WebServlet("/student/*")
public class StudentController extends HttpServlet {

	// 부장
	StudentService studentservice;

	@Override
	public void init() throws ServletException {
		studentservice = new StudentService();
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

		// 웹브라우저로 출력할 출력 스트림 생성
		PrintWriter out = null;

		// 조건에 따라 포워딩 또는 보여줄 VIEW 주소 경로를 저장할 변수
		String nextPage = null;

		// 재요청할 경로 주소를 저장할 변수
		String center = null;

		String action = request.getPathInfo(); // 2단계 요청주소
		System.out.println("요청한 2단계 주소: " + action);

		switch (action) {
		case "/main.bo": // CarMain.jsp 메인화면 2단계 요청 주소를 받으면

			nextPage = "/main.jsp";

			break;

		// ==============================================================================

		case "/studentRegister.do":
			// 학생 등록 서비스 호출
			int result = studentservice.registerStudent(request);
			// request.setAttribute("result", result);

			// 결과 메시지 설정
		    String message;
		    if (result == 1) {
		        message = "학생 정보가 성공적으로 추가되었습니다!";
		    } else {
		        message = "학생 정보를 추가하는 데 실패했습니다. 중복되는 학번이나 사용자ID인지 확인해주세요!";
		    }
		    
		    out = response.getWriter();
		    out.println("<script>");
		    out.println("alert('" + message + "');");
		    out.println("location.href='" + request.getContextPath() + "/student/viewStudentList.do';");
		    out.println("</script>");
		    out.close();
		    return;

		// ==========================================================================================

		case "/viewStudentList.do": // 전체 학생 조회
			List<StudentVo> students = studentservice.getAllStudents();
			request.setAttribute("students", students);
			
			center = "/view_admin/studentManager/viewStudentList.jsp";

			request.setAttribute("center", center);
			nextPage = "/main.jsp";
			break;

		// ==========================================================================================

		case "/studentManage.bo": //  학생 등록 조회

			center = request.getParameter("center");

			request.setAttribute("center", center);

			nextPage = "/main.jsp";
			break;

		// ==========================================================================================

		case "/editStudent.do": // 학생 정보 수정

			String userId = request.getParameter("user_id");
			StudentVo student = studentservice.getStudentById(userId);
			request.setAttribute("student", student);
			//아래코드3줄추가함
			center = "/view_admin/studentManager/editStudent.jsp";
			  
			request.setAttribute("center", center);
			nextPage = "/main.jsp";
			   
			// nextPage = "/view_admin/studentManager/editStudent.jsp";

			break;

		// ==========================================================================================
		case "/viewStudent.do":
			userId = request.getParameter("user_id");
			student = studentservice.getStudentById(userId);
			request.setAttribute("student", student);
			//아래 3줄코드 추가 및 한 줄 주석처리
			center = "/view_admin/studentManager/viewStudent.jsp";
			
			request.setAttribute("center", center);
			nextPage = "/main.jsp";
			// nextPage = "/view_admin/studentManager/viewStudent.jsp";
			break;
		// ==========================================================================================
		case "/updateStudent.do": // 수정했을때 보여주는 메세지
			boolean isUpdated = studentservice.updateStudent(request);
			String updateMessage = isUpdated ? "학생 정보가 성공적으로 수정되었습니다." : "학생 정보 수정에 실패했습니다.";
			  	out = response.getWriter();
			    out.println("<script>");
			    out.println("alert('" + updateMessage + "');");
			    out.println("location.href='" + request.getContextPath() + "/student/viewStudentList.do';");
			    out.println("</script>");
			    out.close();
			return;
			
		// ==========================================================================================
		case "/deleteStudent.do": // 학생 정보 삭제 및 삭제했을 때 보여지는 메세지
			String studentId = request.getParameter("student_id");
			boolean isDeleted = studentservice.deleteStudent(studentId);
			String deleteMessage = isDeleted ? "학생 정보가 성공적으로 삭제되었습니다." : "학생 정보 삭제에 실패했습니다.";
			 	out = response.getWriter();
			    out.println("<script>");
			    out.println("alert('" + deleteMessage + "');");
			    out.println("location.href='" + request.getContextPath() + "/student/viewStudentList.do';");
			    out.println("</script>");
			    out.close();
			return;

		// ==========================================================================================

		// 학생으로 로그인했을때 마이페이지 이동 처리
		case "/myPage.bo":
			String sessionUserId = (String) session.getAttribute("id");
			StudentVo member = studentservice.getStudentById(sessionUserId);
			request.setAttribute("member", member);
			center = "/view_admin/studentManager/myPage.jsp";
			request.setAttribute("center", center);
			nextPage = "/main.jsp";
			break;

       // 학생 본인 정보 수정 처리
       case "/updateMyInfo.do":
       		//==
       		String userPw = request.getParameter("user_pw");
       		if (userPw == null || userPw.trim().isEmpty()) {
               // 비밀번호가 비어 있는 경우 에러 메시지를 설정하고 마이페이지로 리다이렉트
               response.sendRedirect(request.getContextPath() + "/student/myPage.bo?error=" + URLEncoder.encode("비밀번호를 입력해주세요.", "UTF-8"));
               return;
       		}
	
       		boolean isMyInfoUpdated = studentservice.updateMyInfo(request);
           
           out = response.getWriter();
           if(isMyInfoUpdated) {
        	   out.write("Success");
        	   out.close();
        	   return;
           } else {
        	   out.write("notSuccess");
        	   out.close();
        	   return;
           }
         
           
           // ==========================================================================================
        // 학생으로 로그인 했을때 강의 평가 등록 페이지로 이동
       case "/evaluationRegister.do":
           String loggedInStudentId = (String) session.getAttribute("student_id");
           
           System.out.println(loggedInStudentId);
           
           List<StudentVo> courseList = studentservice.getAllCourses(loggedInStudentId);
           request.setAttribute("studentId", loggedInStudentId);
           request.setAttribute("courseList", courseList);
           	 // String name = (String)session.getAttribute("name");
        	 //request.setAttribute("name", name);
           center = "/view_classroom/evaluation/evaluationRegister.jsp";
           request.setAttribute("classroomCenter", center);
           nextPage = "/view_classroom/classroom.jsp";
           break;

       // ===============================================
       // 강의 평가 데이터 등록 처리
       case "/evaluationSubmit.do":
           boolean isEvaluationInserted = studentservice.insertEvaluation(request);
           String evaluationMessage = isEvaluationInserted ? "강의 평가가 성공적으로 등록되었습니다."
                   : "강의 평가 등록에 실패했습니다.";
           
           out = response.getWriter();
           out.println("<script>");
           out.println("alert('" + evaluationMessage + "');");
           out.println("location.href='" + request.getContextPath() + "/student/evaluationRegister.do';");
           out.println("</script>");
           out.close();
           return;

       // ===============================================
       // 강의 평가 목록 조회
       case "/evaluationList.do":
           studentId = (String) session.getAttribute("student_id");
           List<StudentVo> evaluations = studentservice.getEvaluationsByStudent(studentId); //getStudentEvaluations
           request.setAttribute("evaluations", evaluations);

           center = "/view_classroom/evaluation/evaluationList.jsp";
           request.setAttribute("classroomCenter", center);
           nextPage = "/view_classroom/classroom.jsp";
           break;

       // ===============================================
       // 강의 평가 수정 페이지로 이동
       case "/evaluationEdit.do":
           int evaluationId = Integer.parseInt(request.getParameter("evaluation_id"));
           StudentVo evaluation = studentservice.getEvaluationById(evaluationId);
           request.setAttribute("evaluation", evaluation);

           center = "/view_classroom/evaluation/evaluationEdit.jsp";
           request.setAttribute("classroomCenter", center);
           nextPage = "/view_classroom/classroom.jsp";
           break;

       // ===============================================
       // 강의 평가 수정 처리 결과 메세지
       case "/evaluationUpdate.do":
           boolean isEvaluationUpdated = studentservice.updateEvaluation(request);
           String updateEvaluationMessage = isEvaluationUpdated ? "강의 평가가 성공적으로 수정되었습니다."
                   : "강의 평가 수정에 실패했습니다.";
           out = response.getWriter();
           out.println("<script>");
           out.println("alert('" + updateEvaluationMessage + "');");
           out.println("location.href='" + request.getContextPath() + "/student/evaluationList.do';");
           out.println("</script>"); 
           out.close();
           return;
           

       // ===============================================
       // 강의 평가 삭제 처리
       case "/evaluationDelete.do":
           evaluationId = Integer.parseInt(request.getParameter("evaluation_id"));
           boolean isEvaluationDeleted = studentservice.deleteEvaluation(evaluationId);
           String deleteEvaluationMessage = isEvaluationDeleted ? "강의 평가가 성공적으로 삭제되었습니다."
                   : "강의 평가 삭제에 실패했습니다.";
           
           out = response.getWriter();
           out.println("<script>");
           out.println("alert('" + deleteEvaluationMessage + "');" );
           out.println("location.href='" + request.getContextPath() + "/student/evaluationList.do';");
           out.println("</script>");
           out.close();
           return;

		default:
			break;
		}

		// 디스패처 방식 포워딩(재요청)
		RequestDispatcher dispatch = request.getRequestDispatcher(nextPage);
		dispatch.forward(request, response);

	} // doHandle 메소드
}
