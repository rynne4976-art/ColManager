package Service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import Dao.MemberDAO;

// 부장
// - 단위 기능 별로 메소드를 만들어서 그 기능을 처리하는 클래스
public class MemberService {

	// MemberDAO 객체의 주소를 저장할 참조변수
	MemberDAO memberDao;

	private static final String CLIENT_ID = "2J_JyNSOWEr60rZNN6d6";
	private static final String CLIENT_SECRET = "5dNnJEq2mz";
	private static final String TOKEN_URL = "https://nid.naver.com/oauth2.0/token";
	private static final String USER_INFO_URL = "https://openapi.naver.com/v1/nid/me";

	// 기본 생성자 - 위 memberDao변수에 new MemberDAO() 객체를 만들어서 저장하는 역할
	public MemberService() {
		memberDao = new MemberDAO();
	}

	// 로그인 요청
	public Map<String, String> serviceUserCheck(HttpServletRequest request) {

		// 요청한 값 얻기(로그인 요청시 입력한 아이디, 비밀번호 request에서 얻기)
		String login_id = request.getParameter("id");
		String login_pass = request.getParameter("pass");

		Map<String, String> userInfo = memberDao.userCheck(login_id, login_pass);

		// HttpSession메모리 얻기
		HttpSession session = request.getSession();

		// check 값이 "1"인 경우에만 role과 name을 세션에 저장
		if ("1".equals(userInfo.get("check"))) {
			// HttpSession메모리에 입력한 아이디 바인딩
			session.setAttribute("role", userInfo.get("role"));
			session.setAttribute("name", userInfo.get("name"));
			session.setAttribute("majorcode", userInfo.get("majorcode"));
			session.setAttribute("id", login_id);
		}

		return userInfo;
	}

	// -------
	// 로그아웃 요청
	public void serviceLogOut(HttpServletRequest request) {

		// 기존에 생성했던 HttpSession 객체 메모리 얻기
		HttpSession session = request.getSession(false);
		if (session != null) {
			session.removeAttribute("userId");
			session.removeAttribute("userName");
			session.invalidate(); // 세션 무효화

		}

	}

}
