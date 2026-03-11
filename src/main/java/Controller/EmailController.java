package Controller;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Service.EmailService;

// MVC 중에서 C 역할 — 이메일 전송 요청을 담당하는 컨트롤러

@WebServlet("/email/*")
public class EmailController extends HttpServlet {

	// 이메일 전송 비즈니스 로직을 처리하는 서비스
	EmailService emailService;

	@Override
	public void init() throws ServletException {
		emailService = new EmailService();
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

		HttpSession session = request.getSession();

		request.setCharacterEncoding("UTF-8");

		String action = request.getPathInfo(); // 2단계 요청 주소
		System.out.println("[EmailController] 요청 주소: " + action);

		PrintWriter out = null;

		switch (action) {

		// =====================================================================
		// 이메일 전송 처리 (AJAX 응답)
		// main.jsp 플로팅 버튼 모달에서 fetch()로 호출
		case "/sendEmail.do":

			// HTTP 요청 파라미터 추출 (Controller 역할)
			// emailTo는 null로 설정 → EmailService의 DEFAULT_TO(info@yourschool.edu)로 자동 고정
			String emailTo      = null;
			String emailSubject = request.getParameter("emailSubject");
			String emailBody    = request.getParameter("emailBody");

			// 세션에서 발신자 정보 추출
			String senderName   = (String) session.getAttribute("name"); // 학생 이름
			String senderUserId = (String) session.getAttribute("id");   // user_id (DB 이메일 조회용)

			// 로그인 상태 확인
			if (senderUserId == null) {
				response.setContentType("text/plain;charset=UTF-8");
				out = response.getWriter();
				out.write("fail");
				out.close();
				return;
			}

			// EmailService에 위임 (비즈니스 로직 + EmailDao DB 조회는 Service에서 처리)
			boolean emailSent = emailService.sendEmail(
					emailTo, emailSubject, emailBody, senderName, senderUserId);

			// AJAX 응답 반환
			response.setContentType("text/plain;charset=UTF-8");
			out = response.getWriter();
			out.write(emailSent ? "success" : "fail");
			out.close();
			return;

		// =====================================================================
		default:
			break;
		}

	} // doHandle 메소드
}
