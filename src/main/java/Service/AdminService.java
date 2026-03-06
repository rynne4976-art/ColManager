package Service;

import java.sql.Date;
import java.util.List;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import Dao.AdminDAO;
import Vo.ProfessorVo;
import Vo.AdminVo;

//- 부장

//단위 기능 별로 메소드를 만들어서 그기능을 처리 하는 클래스 
public class AdminService {

	
	
	//adminDao객체의 주소를 저장할 참조변수
	AdminDAO adminDao;
	
	//생성자- 위 adminDao변수에 new adminDao()객체를 만들어서 저장하는 역할
	public AdminService() {
		adminDao = new AdminDAO();
	}

	
	//회원등록(가입) 요청
	public int serviceInsertMember(AdminVo vo) {
					        							
									
		//사원아 니가 회원가입 해라 insert~~
		return adminDao.insertMember(vo);
		
		
		
	}
	
	
	//아이디 중복 체크 요청
		public boolean serviceOverLappedId(HttpServletRequest request) {
			//요청한 아이디 얻기 
			String id = request.getParameter("user_id");
			//사원(adminDao) 한테 시킴!!!!!!!!
			//입력한 아이디가 DB에 저장되어 있는 지 확인 하는 작업을 MadminDao의 메소드를 호출해서 명령
			return  adminDao.overlappedId(id);
				    //true 또는 false를 반환 받아 다시 MemberController(사장)에 반환 
			
		}


		// 관리자 특정조회
		public List<AdminVo> getMemberlist(String searchWord) {
			
			return adminDao.getMemberList(searchWord);
		}
	

		//전체조회
		public List<AdminVo> getAllMemberlist() {
			
			return adminDao.getAllMemberList();
		}

		
		//삭제
		public boolean managerDelete(String admin_id) {
			
			if (admin_id == null || admin_id.trim().isEmpty()) {
			    throw new IllegalArgumentException("관리자 번호가 유효하지 않습니다.");
			}
				
			return adminDao.managerDelete(admin_id);
		}

		
			
		//정보수정
		public boolean updateMember(AdminVo mvo) {
			
			return adminDao.updateMember(mvo);
		}


	
		
		
}//MemberService



















